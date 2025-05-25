from flask import Flask, request, render_template, redirect, url_for, session
import mysql.connector
import re

app = Flask(__name__)
app.secret_key = 'rahasia'

def get_database_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="sistem_pakar_pencurian"
    )

def get_aturan():
    connection = get_database_connection()
    cursor = connection.cursor(dictionary=True)
    cursor.execute("SELECT * FROM aturan")
    aturan_list = cursor.fetchall()
    cursor.close()
    connection.close()
    return aturan_list

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/practice')
def practice():
    session['jawaban'] = []
    session.pop('kategori_list', None)

    connection = get_database_connection()
    cursor = connection.cursor(dictionary=True)
    cursor.execute("""
        SELECT DISTINCT k.id, k.nama
        FROM pertanyaan p
        LEFT JOIN kategori k ON p.id_kategori = k.id
        ORDER BY CASE WHEN p.id_kategori IS NULL THEN 0 ELSE 1 END, k.id
    """)
    kategori_list = cursor.fetchall()
    cursor.close()
    connection.close()

    if kategori_list:
        session['jawaban'] = []
        session['kategori_list'] = kategori_list
        return redirect(url_for('practice_step', step=0))
    else:
        return "Tidak ada pertanyaan."

@app.route('/practice/<int:step>')
def practice_step(step):
    kategori_list = session.get('kategori_list', [])
    if step >= len(kategori_list):
        return redirect(url_for('result'))

    kategori = kategori_list[step]
    kategori_id = kategori['id']

    connection = get_database_connection()
    cursor = connection.cursor(dictionary=True)
    if kategori_id is None:
        cursor.execute("SELECT * FROM pertanyaan WHERE id_kategori IS NULL")
    else:
        cursor.execute("SELECT * FROM pertanyaan WHERE id_kategori = %s", (kategori_id,))
    pertanyaan_list = cursor.fetchall()
    cursor.close()
    connection.close()

    return render_template(
        'single-blog.html',
        pertanyaan_list=pertanyaan_list,
        step=step,
        total=len(kategori_list),
        kategori=kategori
    )

@app.route('/practice_result', methods=['POST'])
def practice_result():
    answers = request.form.getlist('jawaban')
    step = int(request.form.get('step', 0))

    if 'jawaban' not in session:
        session['jawaban'] = []

    jawaban = session['jawaban']
    jawaban = list(set(jawaban + answers))
    session['jawaban'] = jawaban

    kategori_list = session.get('kategori_list', [])
    if step + 1 < len(kategori_list):
        return redirect(url_for('practice_step', step=step + 1))
    else:
        return redirect(url_for('result'))

@app.route('/result')
def result():
    jawaban = session.get('jawaban', [])
    hasil, hukuman_tertinggi = forward_chaining(jawaban)
    semua_pertanyaan = []
    for h in hasil:
        for q in h['matched_questions']:
            if q not in semua_pertanyaan:
                semua_pertanyaan.append(q)

    return render_template(
        'about.html',
        hasil=hasil,
        jawaban=jawaban,
        hukuman_tertinggi=hukuman_tertinggi,
        semua_pertanyaan=semua_pertanyaan
    )

@app.route('/dasar')
def dasar():
    conn = get_database_connection()
    cursor = conn.cursor(dictionary=True)
    
    cursor.execute("SELECT pasal, pelanggaran FROM pasal_pencurian")
    pasal_list = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template('service.html', pasal_list=pasal_list)



import re
from collections import defaultdict

def evaluate_expression(expr, jawaban_set):
    expr = re.sub(r'\b(P\d+)\b', r'"\1" in jawaban_set', expr)
    expr = expr.replace('AND', 'and').replace('OR', 'or')
    try:
        return eval(expr)
    except Exception as e:
        print(f"Error evaluating: {expr} -> {e}")
        return False

def forward_chaining(jawaban):
    jawaban_set = set(jawaban)
    aturan_list = get_aturan()
    hasil = []

    prioritas_hukuman = ["Mati", "Seumur Hidup"]

    conn = get_database_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT id, pertanyaan FROM pertanyaan")
    pertanyaan_data = cursor.fetchall()
    pertanyaan_dict = {p['id']: p['pertanyaan'] for p in pertanyaan_data}

    pasal_data_dict = {}
    aturan_tercocok = []

    # Langkah 1: cocokkan aturan
    for aturan in aturan_list:
        kondisi_asli = aturan['kondisi']
        tokens = re.findall(r'\bP\d+\b', kondisi_asli)

        kondisi_eval = re.sub(r'\b(P\d+)\b', r'"\1" in jawaban_set', kondisi_asli)
        kondisi_eval = kondisi_eval.replace('AND', 'and').replace('OR', 'or')

        try:
            is_match = eval(kondisi_eval)
            if is_match:
                if 'AND' in kondisi_asli and not all(token in jawaban_set for token in tokens):
                    continue

                cursor.execute("SELECT * FROM pasal_pencurian WHERE id = %s", (aturan['pasal_id'],))
                pasal_data = cursor.fetchone()

                if pasal_data:
                    pasal_data_dict[aturan['pasal_id']] = pasal_data
                    aturan_tercocok.append({
                        'aturan': aturan,
                        'tokens': tokens
                    })

        except Exception as e:
            print(f"Error eval kondisi: {kondisi_eval} -> {e}")

    # Langkah 2: kelompokkan aturan yang punya kondisi sama
    kondisi_grup = defaultdict(list)
    for item in aturan_tercocok:
        kondisi_grup[item['aturan']['kondisi']].append(item['aturan']['pasal_id'])

    # Langkah 3: tentukan hukuman dan denda tertinggi per grup
    hukuman_tertinggi = ''
    denda_tertinggi = 0
    pasal_id_hukuman_max = None

    for kondisi, pasal_ids in kondisi_grup.items():
        max_hukuman_text = ''
        max_hukuman_angka = 0
        max_denda_val = 0
        max_pasal_id = None

        for pid in pasal_ids:
            pasal_data = pasal_data_dict.get(pid)
            if not pasal_data:
                continue

            hukuman = pasal_data.get('hukuman_max', '')
            denda_raw = pasal_data.get('denda', '').replace('Rp.', '').replace('.', '').replace(',', '').strip()
            denda_val = int(denda_raw) if denda_raw.isdigit() else 0

            # Tentukan hukuman tertinggi
            if any(p in hukuman for p in prioritas_hukuman):
                max_hukuman_text = hukuman
                max_pasal_id = pid
            else:
                angka = re.search(r'\d+', hukuman)
                if angka:
                    angka_val = int(angka.group())
                    if angka_val > max_hukuman_angka:
                        max_hukuman_angka = angka_val
                        max_hukuman_text = hukuman
                        max_pasal_id = pid

            if denda_val > max_denda_val:
                max_denda_val = denda_val

        # Simpan jika grup ini punya hukuman tertinggi global
        if any(p in max_hukuman_text for p in prioritas_hukuman) or max_hukuman_angka > 0:
            hukuman_tertinggi = max_hukuman_text
            denda_tertinggi = max_denda_val
            pasal_id_hukuman_max = max_pasal_id

    # Langkah 4: siapkan hasil akhir
    for item in aturan_tercocok:
        aturan = item['aturan']
        tokens = item['tokens']
        pasal_id = aturan['pasal_id']
        pasal_data = pasal_data_dict.get(pasal_id)

        matched_tokens = [token for token in tokens if token in jawaban_set]
        matched_questions = [pertanyaan_dict.get(token, token) for token in matched_tokens]

        if pasal_id == pasal_id_hukuman_max:
            cursor.execute("SELECT * FROM perkara WHERE id_pasal = %s", (pasal_id,))
            perkara_data = cursor.fetchone()
        else:
            perkara_data = None

        hasil.append({
            'pasal': pasal_data,
            'perkara': perkara_data,
            'matched_tokens': matched_tokens,
            'matched_questions': matched_questions,
            'kondisi': aturan['kondisi']
        })

    cursor.close()
    conn.close()

    # Format hukuman akhir
    if hukuman_tertinggi:
        if denda_tertinggi:
            hukuman_tertinggi += f" dan Denda {denda_tertinggi:,}".replace(',', '.')
    else:
        hukuman_tertinggi = "Tidak Diketahui"

    return hasil, hukuman_tertinggi





if __name__ == '__main__':
    app.run(host='0.0.0.0',debug=True)
