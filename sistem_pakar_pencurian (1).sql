-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 21, 2024 at 06:34 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sistem_pakar_pencurian`
--

-- --------------------------------------------------------

--
-- Table structure for table `aturan`
--

CREATE TABLE `aturan` (
  `id` int(11) NOT NULL,
  `kondisi` text DEFAULT NULL,
  `pasal_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `aturan`
--

INSERT INTO `aturan` (`id`, `kondisi`, `pasal_id`) VALUES
(1, 'Apakah pencurian dilakukan hanya untuk memiliki pribadi tanpa niat lain?', 1),
(2, 'Apakah pencurian dilakukan dengan ancaman atau kekerasan?', 4),
(3, 'Apakah pencurian dilakukan oleh keluarga dengan harta kekayaan yang dipisah?', 6),
(4, 'Apakah barang yang dicuri bernilai kecil?', 3),
(5, 'Apakah ada pemberatan lain?', 2),
(6, 'Apakah perbuatan dilakukan pada waktu malam dalam sebuah rumah atau pekarangan tertutup yang ada rumahnya?', 7),
(7, 'Apakah perbuatan dilakukan oleh dua orang atau lebih dengan bersekutu?', 8),
(8, 'Apakah masuk ke tempat melakukan kejahatan dengan merusak atau memanjat atau dengan memakai anak kunci palsu, perintah palsu, atau pakaian jabatan palsu?', 9),
(9, 'Apakah perbuatan mengakibatkan luka-luka berat?', 10),
(10, 'Apakah perbuatan mengakibatkan kematian?', 11),
(11, 'Apakah pencurian dilakukan 2 atau lebih dan melanggar point 6,8,9,10 diatas', 12);

-- --------------------------------------------------------

--
-- Table structure for table `pasal_pencurian`
--

CREATE TABLE `pasal_pencurian` (
  `id` int(11) NOT NULL,
  `pasal` varchar(30) DEFAULT NULL,
  `pelanggaran` text DEFAULT NULL,
  `hukuman_max` varchar(20) DEFAULT NULL,
  `deskripsi` text NOT NULL,
  `Gambar` varchar(255) NOT NULL,
  `denda` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pasal_pencurian`
--

INSERT INTO `pasal_pencurian` (`id`, `pasal`, `pelanggaran`, `hukuman_max`, `deskripsi`, `Gambar`, `denda`) VALUES
(1, 'Pasal 362', 'Pencurian biasa', '5 tahun', 'Barang siapa mengambil barang sesuatu, yang seluruhnya atau sebagian \r\nkepunyaan orang lain, dengan maksud untuk dimiliki secara melawan hukum, \r\ndiancam karena pencurian, dengan pidana penjara paling lama lima tahun atau \r\npidana denda paling banyak sembilan ratus rupiah.', 'images/pencurian.jpg', '900.00'),
(2, 'Pasal 363', 'Pencurian dengan pemberatan', '7 tahun', '(1) Diancam dengan pidana penjara paling lama tujuh tahun:  1. pencurian ternak;  2. pencurian pada waktu ada kebakaran, letusan, banjir gempa bumi, atau  gempa laut, gunung meletus, kapal karam, kapal terdampar, kecelakaan  kereta api, huru-hara, pemberontakan atau bahaya perang;  3. pencurian di waktu malam dalam sebuah rumah atau pekarangan  tertutup yang ada rumahnya, yang dilakukan oleh orang yang ada di situ  tidak diketahui atau tidak dikehendaki oleh yang berhak;  4. pencurian yang dilakukan oleh dua orang atau lebih:  5. pencurian yang untuk masuk ke tempat melakukan kejahatan, atau  untuk sampai pada barang yang diambil, dilakukan dengan merusak,  memotong atau memanjat, atau dengan memakai anak kunci palsu,  perintah palsu atau pakaian jabatan palsu.  (2)Jika pencurian yang diterangkan dalam butir 3 disertai dengan salah satu  hal dalam butir 4 dan 5, maka diancam dengan pidana penjara paling lama  sembilan tahun.', 'images/ringan.png', ''),
(3, 'Pasal 364', 'Pencurian ringan', '3 bulan', 'Perbuatan yang diterangkan dalam pasal 362 (Barang siapa mengambil barang sesuatu, yang seluruhnya atau sebagian \r\nkepunyaan orang lain, dengan maksud untuk dimiliki secara melawan hukum, \r\ndiancam karena pencurian, dengan pidana penjara paling lama lima tahun atau \r\npidana denda paling banyak sembilan ratus rupiah.)\r\ndan pasal 363 butir 4 (pencurian yang dilakukan oleh dua orang atau lebih), begitu pun \r\nperbuatan yang diterangkan dalam pasal 363 butir 5 (pencurian yang untuk masuk ke tempat melakukan kejahatan, atau \r\nuntuk sampai pada barang yang diambil, dilakukan dengan merusak, \r\nmemotong atau memanjat, atau dengan memakai anak kunci palsu, \r\nperintah palsu atau pakaian jabatan palsu), apabila tidak dilakukan \r\ndalam sebuah rumah atau pekarangan tertutup yang ada rumahnya, jika harga \r\nbarang yang dicuri tidak lebih dari dua puluh lima rupiah, diancam karena \r\npencurian ringan dengan pidana penjara paling lama tiga bulan atau pidana \r\ndenda paling banyak dua ratus lima puluh rupiah.', 'images/ringan.png', ''),
(4, 'Pasal 365 ayat 1', 'Pencurian dengan kekerasan', '9 tahun', 'Diancam dengan pidana penjara paling lama sembilan tahun pencurian  yang didahului, disertai atau diikuti dengan kekerasan atau ancaman  kekerasan, terhadap orang dengan maksud untuk mempersiapkan atsu  mempermudah pencurian, atau dalam hal tertangkap tangan, untuk  memungkinkan melarikan diri sendiri atau peserta lainnya, atau untuk  tetap menguasai barang yang dicuri. ', 'images/ancaman.png', ''),
(6, 'Pasal 367', 'Pencurian oleh keluarga dengan terpisah harta kekayaan', '5 tahun', '(1) Jika pembuat atau pemhantu ciari salah satu kejahatan dalam bab ini adalah suami (istri) dari orang yang terkena kejahatan dan tidak terpisah meja dan ranjang atau terpisah harta kekayaan, maka terhadap pembuat atau pembantu itu tidak mungkin diadakan tuntutan pidana. (2) Jika dia adalah suami (istri) yang terpisah meja dan ranjang atau terpisah harta kekayaan, atau jika dia adalah keluarga sedarah atau semenda, baik dalam garis lurus maupun garis menyimpang derajat kedua maka terhadap orang itu hanya mungkin diadakan penuntutan jika ada pengaduan yang terkena kejahatan. (3) Jika menurut lembaga matriarkal kekuasaan bapak dilakukan oleh orang lain daripada bapak kandung (sendiri), maka ketentuan ayat di atas berlaku juga bagi orang itu.', 'images/keluarga.png', ''),
(7, 'Pasal 365 ayat 2', 'Pencurian dalam rumah atau pekarangan tertutup malam hari', '12 tahun', 'Diancam dengan pidana penjara paling lama dua belas tahun:  1. jika perbuatan dilakukan pada waktu malam dalam sebuah rumah  atau pekarangan tertutup yang ada rumahnya, di berjalan;  2. jika perhuatan dilakukan oleh dua orang atau lebih dengan  bersekutu;  3. jika masuk kc tempat melakukan kejahatan dengan merusak atau  memanjat atau dengan memakai anak kunci palsu, periniah palsu  atau pakaian jabatan palsu.  4. jika perbuatan mengakibatkan luka-luka berat. ', 'images/pencurian.jpg', ''),
(8, 'Pasal 365 ayat 2', 'Pencurian oleh dua orang atau lebih dengan bersekutu', '12 tahun', 'Diancam dengan pidana penjara paling lama dua belas tahun:  1. jika perbuatan dilakukan pada waktu malam dalam sebuah rumah  atau pekarangan tertutup yang ada rumahnya, di berjalan;  2. jika perhuatan dilakukan oleh dua orang atau lebih dengan  bersekutu;  3. jika masuk kc tempat melakukan kejahatan dengan merusak atau  memanjat atau dengan memakai anak kunci palsu, periniah palsu  atau pakaian jabatan palsu.  4. jika perbuatan mengakibatkan luka-luka berat. ', 'images/pencurian.jpg', ''),
(9, 'Pasal 365 ayat 2', 'Pencurian dengan merusak atau memakai anak kunci palsu', '12 tahun', 'Diancam dengan pidana penjara paling lama dua belas tahun:  1. jika perbuatan dilakukan pada waktu malam dalam sebuah rumah  atau pekarangan tertutup yang ada rumahnya, di berjalan;  2. jika perhuatan dilakukan oleh dua orang atau lebih dengan  bersekutu;  3. jika masuk kc tempat melakukan kejahatan dengan merusak atau  memanjat atau dengan memakai anak kunci palsu, periniah palsu  atau pakaian jabatan palsu.  4. jika perbuatan mengakibatkan luka-luka berat. ', 'images/pencurian.jpg', ''),
(10, 'Pasal 365 ayat 2', 'Pencurian yang mengakibatkan luka-luka berat', '12 tahun', 'Diancam dengan pidana penjara paling lama dua belas tahun:  1. jika perbuatan dilakukan pada waktu malam dalam sebuah rumah  atau pekarangan tertutup yang ada rumahnya, di berjalan;  2. jika perhuatan dilakukan oleh dua orang atau lebih dengan  bersekutu;  3. jika masuk kc tempat melakukan kejahatan dengan merusak atau  memanjat atau dengan memakai anak kunci palsu, periniah palsu  atau pakaian jabatan palsu.  4. jika perbuatan mengakibatkan luka-luka berat. ', 'images/pencurian.jpg', ''),
(11, 'Pasal 365 ayat 3', 'Pencurian yang mengakibatkan kematian', '15 tahun', '(3) Jika perbuatan mengakibatkan kematian maka diancam dengan pidana  penjara paling lama lima belas tuhun. ', 'images/mati.png', ''),
(12, 'Pasal 365 ayat 4', 'Pencurian menyebabkan luka berat atau meninggal yang dilakukan 2 orang atau lebih', 'mati', 'Diancam dengan pidana mati atau pidana penjara seumur hidup atau \r\nselama waktu tertentu paling lama dua puluh tahun, jika perbuatan mengakihntkan luka berat atau kematian dan dilakukan oleh dua orang \r\natau lebih dengan bersekutu, disertai pula oleh salah satu hal yang \r\nditerangkan dalam no. 1 dan 3 pada KUHP\r\n', 'images/mati.png', '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `aturan`
--
ALTER TABLE `aturan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pasal_id` (`pasal_id`);

--
-- Indexes for table `pasal_pencurian`
--
ALTER TABLE `pasal_pencurian`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `aturan`
--
ALTER TABLE `aturan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `pasal_pencurian`
--
ALTER TABLE `pasal_pencurian`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `aturan`
--
ALTER TABLE `aturan`
  ADD CONSTRAINT `aturan_ibfk_1` FOREIGN KEY (`pasal_id`) REFERENCES `pasal_pencurian` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
