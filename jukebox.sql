-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Dec 25, 2022 at 03:49 PM
-- Server version: 5.7.36
-- PHP Version: 7.4.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `jukebox`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `4-trigger`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `4-trigger` ()  NO SQL
DELETE FROM tbl_mekan WHERE uyelikSonBulmaTarihi < NOW()$$

DROP PROCEDURE IF EXISTS `DELETE_SONG`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `DELETE_SONG` (IN `sarkiID` INT)  NO SQL
DELETE sarkilar, musteri_istek
FROM tbl_sarkilar sarkilar
LEFT JOIN tbl_musteri_istek musteri_istek ON sarkilar.sarkiID = musteri_istek.sarkiID
WHERE sarkilar.sarkiID = sarkiID$$

DROP PROCEDURE IF EXISTS `INSERT_SONG`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `INSERT_SONG` (IN `sarkiID` INT, IN `playlistID` INT, IN `band` VARCHAR(150), IN `album` VARCHAR(150), IN `songName` VARCHAR(150))  BEGIN
  INSERT INTO tbl_sarkilar (sarkiID,playlistID, band, album, sarkiAdi)
  VALUES (sarkiID,playlistID, band, album, songName);
END$$

DROP PROCEDURE IF EXISTS `sorgu1-girilen_mekanin-sarkilarini-listeler-parameters`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sorgu1-girilen_mekanin-sarkilarini-listeler-parameters` (IN `mekan` VARCHAR(150))  NO SQL
SELECT tbl_sarkilar.band,tbl_sarkilar.album,tbl_sarkilar.sarkiAdi
FROM
tbl_sarkilar,tbl_playlist,tbl_mekan
WHERE
tbl_sarkilar.playlistID=tbl_playlist.playlistID
AND
tbl_mekan.playlistID = tbl_playlist.playlistID
AND
tbl_mekan.mekanAdi LIKE CONCAT('%',mekan,'%')$$

DROP PROCEDURE IF EXISTS `sorgu2-musteri-istek-mekana-gore-gruplu-hali`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sorgu2-musteri-istek-mekana-gore-gruplu-hali` ()  SELECT 
CONCAT(tbl_musteri.musteriAdi,' ',tbl_musteri.musteriSoyadi)as 'Isim soyisim',
tbl_mekan.mekanAdi,
tbl_sarkilar.sarkiAdi
FROM
tbl_musteri,tbl_musteri_istek,tbl_mekan,tbl_sarkilar,tbl_playlist
WHERE
tbl_musteri.musteriID=tbl_musteri_istek.musteriID
AND
tbl_musteri_istek.sarkiID=tbl_sarkilar.sarkiID
AND
tbl_sarkilar.playlistID=tbl_playlist.playlistID
AND
tbl_playlist.playlistID=tbl_mekan.mekanID$$

DROP PROCEDURE IF EXISTS `sorgu3-son-uyelik-tarihi-gecen-mekanlar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sorgu3-son-uyelik-tarihi-gecen-mekanlar` ()  SELECT tbl_mekan.mekanAdi,
CONCAT(tbl_mekan.mekanSahibiAd,' ',tbl_mekan.mekanSahibiSoyad)as'isim soyisim',
tbl_mekan.mekanSahibiTell,
tbl_mekan.mekanSahibiMail
FROM
tbl_mekan
WHERE
tbl_mekan.uyelikSonBulmaTarihi<now()$$

DROP PROCEDURE IF EXISTS `sorgu4-mekana-gore-uyelik-tur-2-olanlar-gelen-komisyon`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sorgu4-mekana-gore-uyelik-tur-2-olanlar-gelen-komisyon` ()  NO SQL
SELECT tbl_mekan.mekanAdi,(((COUNT(tbl_musteri_istek.istekID)*10)/100)*60)as 'Komisyon'
FROM
tbl_musteri,tbl_musteri_istek,tbl_mekan,tbl_sarkilar,tbl_playlist,tbl_uyelik
WHERE
tbl_musteri.musteriID=tbl_musteri_istek.musteriID
AND
tbl_musteri_istek.sarkiID=tbl_sarkilar.sarkiID
AND
tbl_sarkilar.playlistID=tbl_playlist.playlistID
AND
tbl_playlist.playlistID=tbl_mekan.mekanID
AND
tbl_uyelik.uyelikTuruID=tbl_mekan.uyelikTuruID
AND
tbl_uyelik.uyelikTuruID=2
GROUP BY
tbl_mekan.mekanAdi$$

DROP PROCEDURE IF EXISTS `sorgu5-girilen_mekanin-girilen-sarkiyi-arar-parameters`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sorgu5-girilen_mekanin-girilen-sarkiyi-arar-parameters` (IN `mekan` VARCHAR(150), IN `sarki` VARCHAR(150))  NO SQL
SELECT tbl_sarkilar.band,tbl_sarkilar.album,tbl_sarkilar.sarkiAdi
FROM
tbl_sarkilar,tbl_playlist,tbl_mekan
WHERE
tbl_sarkilar.playlistID=tbl_playlist.playlistID
AND
tbl_mekan.playlistID = tbl_playlist.playlistID
AND
tbl_mekan.mekanAdi LIKE CONCAT('%',mekan,'%')
AND
tbl_sarkilar.sarkiAdi LIKE CONCAT('%',sarki,'%')$$

DROP PROCEDURE IF EXISTS `sorgu6-girilen-mekanin-sarki-sayisi-parameters`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sorgu6-girilen-mekanin-sarki-sayisi-parameters` (IN `mekan` VARCHAR(150))  NO SQL
SELECT 
tbl_mekan.mekanAdi,COUNT(tbl_sarkilar.sarkiID)as 'Sarki Sayisi'
FROM
tbl_sarkilar,tbl_playlist,tbl_mekan
WHERE
tbl_sarkilar.playlistID=tbl_playlist.playlistID
AND
tbl_mekan.playlistID = tbl_playlist.playlistID
AND
tbl_mekan.mekanAdi LIKE CONCAT('%',mekan,'%')$$

DROP PROCEDURE IF EXISTS `sorgu7-yillar-arasi-uye-olan-mekanlar-uylik-turleri-parameters`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sorgu7-yillar-arasi-uye-olan-mekanlar-uylik-turleri-parameters` (IN `yil1` INT, IN `yil2` INT)  NO SQL
SELECT
tbl_uyelik.uyelikTuruAdi,
tbl_mekan.mekanAdi,
tbl_mekan.mekanSahibiAd,
tbl_mekan.mekanSahibiSoyad,
tbl_mekan.mekanSahibiTell,
tbl_mekan.mekanSahibiMail 
FROM 
tbl_mekan,tbl_uyelik
WHERE
tbl_mekan.uyelikTuruID=tbl_uyelik.uyelikTuruID
AND
YEAR(tbl_mekan.uyelikTarihi) BETWEEN yil1 AND yil2$$

DROP PROCEDURE IF EXISTS `sorgu8-musterinin-istek-sayisi`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sorgu8-musterinin-istek-sayisi` ()  NO SQL
SELECT 
CONCAT(tbl_musteri.musteriAdi,' ',tbl_musteri.musteriSoyadi) as 'Musteri Isim Soyisim',
COUNT(tbl_musteri_istek.istekID) as 'Istek Sayisi'

FROM
tbl_musteri,tbl_musteri_istek
WHERE
tbl_musteri.musteriID=tbl_musteri_istek.musteriID
GROUP BY
tbl_musteri.musteriAdi$$

DROP PROCEDURE IF EXISTS `sorgu9-playlistler-sarki-sayisi`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sorgu9-playlistler-sarki-sayisi` ()  NO SQL
SELECT
tbl_playlist.playlistAdi,
COUNT(tbl_sarkilar.sarkiID) as 'Sarki sayisi'
FROM
tbl_playlist,tbl_sarkilar
WHERE
tbl_playlist.playlistID=tbl_sarkilar.playlistID
GROUP BY
tbl_playlist.playlistAdi$$

DROP PROCEDURE IF EXISTS `UPDATE_MEKAN`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `UPDATE_MEKAN` (IN `mekanID` INT, IN `uyelikTuruID` INT, IN `uyelikSonBulmaTarihi` DATE)  BEGIN
  UPDATE tbl_mekan
  SET uyelikTuruID = uyelikTuruID, uyelikSonBulmaTarihi = uyelikSonBulmaTarihi
  WHERE mekanID = mekanID;
END$$

DROP PROCEDURE IF EXISTS `z_sorgu10-mekanlarin-istek-sayisi`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `z_sorgu10-mekanlarin-istek-sayisi` ()  NO SQL
SELECT
tbl_mekan.mekanAdi,
COUNT(tbl_musteri_istek.istekID) as 'Istek Sayisi'
FROM
tbl_mekan,tbl_musteri_istek,tbl_sarkilar,tbl_playlist
WHERE
tbl_musteri_istek.sarkiID=tbl_sarkilar.sarkiID
AND
tbl_sarkilar.playlistID=tbl_playlist.playlistID
AND
tbl_playlist.playlistID=tbl_mekan.playlistID
GROUP BY tbl_mekan.mekanAdi$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `log_eski_uye_mekan`
--

DROP TABLE IF EXISTS `log_eski_uye_mekan`;
CREATE TABLE IF NOT EXISTS `log_eski_uye_mekan` (
  `mekanID` int(11) NOT NULL,
  `uyelikTarihi` date DEFAULT NULL,
  `mekanAdi` varchar(150) DEFAULT NULL,
  `mekanSahibiAd` varchar(150) DEFAULT NULL,
  `mekanSahibiSoyad` varchar(150) DEFAULT NULL,
  `mekanSahibiTell` varchar(20) DEFAULT NULL,
  `mekanSahibiMail` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`mekanID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_mekan`
--

DROP TABLE IF EXISTS `tbl_mekan`;
CREATE TABLE IF NOT EXISTS `tbl_mekan` (
  `mekanID` int(11) NOT NULL,
  `uyelikTuruID` int(11) DEFAULT NULL,
  `playlistID` int(11) DEFAULT NULL,
  `uyelikTarihi` timestamp NULL DEFAULT NULL,
  `uyelikSonBulmaTarihi` date DEFAULT NULL,
  `mekanAdi` varchar(150) DEFAULT NULL,
  `mekanAdres` varchar(150) DEFAULT NULL,
  `mekanSahibiAd` varchar(150) DEFAULT NULL,
  `mekanSahibiSoyad` varchar(150) DEFAULT NULL,
  `mekanSahibiTell` varchar(20) DEFAULT NULL,
  `mekanSahibiMail` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`mekanID`),
  KEY `uyelikTuruFK1` (`uyelikTuruID`),
  KEY `mekanPlaylistFK` (`playlistID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_mekan`
--

INSERT INTO `tbl_mekan` (`mekanID`, `uyelikTuruID`, `playlistID`, `uyelikTarihi`, `uyelikSonBulmaTarihi`, `mekanAdi`, `mekanAdres`, `mekanSahibiAd`, `mekanSahibiSoyad`, `mekanSahibiTell`, `mekanSahibiMail`) VALUES
(1, 2, 1, '2020-12-18 00:40:43', '2021-12-28', 'Deep Rock Cafe', 'Izmir simit sk no:132', 'Hasan', 'Guc', '555 358 12 01', 'hasan.guc@hotmail.com'),
(2, 2, 2, '2021-12-18 00:47:49', '2021-12-28', 'Deep Metal Cafe', 'Izmir kahraman sk no:1123', 'Mehmet Ali', 'Er', '545 313 12 01', 'mehmet.ali.Er@hotmail.com'),
(3, 2, 3, '2022-12-18 00:47:49', '2021-12-28', 'Death Metal Cafe', 'Izmir inonu cad basin sitesi no:152', 'Ayse', 'Akyol', '557 312 11 61', 'ayse.akyol@hotmail.com'),
(4, 2, 4, '2022-12-18 00:49:22', '2021-12-28', 'Trash Metal Cafe', 'Izmir f.altay no:212', 'Dave', 'Mustaine', '546 354 12 51', 'dave.mustaine@hotmail.com'),
(5, 2, 5, '2022-12-18 01:45:54', '2021-12-28', 'Turkce Rock Cafe', 'Izmir Alsancak kibris sehitligi no:164', 'Soner', 'Canozer', '514 156 15 64', 'soner.canozer@hotmail.com'),
(6, 2, 6, '2021-06-18 02:51:42', '2021-12-28', 'Dejavu', 'Ankara Altindag SENKAL N 32/A, Siteler', 'Ikbal', 'Ozkara', '545 546 45 64', 'ikbal.ozkara@hotmail.com'),
(7, 2, 7, '2022-12-18 02:51:42', '2021-12-28', 'Lime', 'Istanbul Kadikoy Saskinbakkal', 'Ata', 'Karadas', '555 000 41 55 ', 'ata.karadas@hotmail.com'),
(8, 2, 8, '2022-12-18 02:52:16', '2021-12-28', 'Kupa Kizi', 'Izmir Konak HALIT ZIYA BULVARI SIGORTA ISM. N 74, Cankaya', 'Sergen', 'Limoncuoglu', '500 542 15 35', 'sergen.limoncuoglu@hotmail.com'),
(9, 2, 9, '2022-12-18 02:52:16', '2021-12-28', 'Kafe Dengi ', 'Istanbul Umraniye Yukari Dudullu', 'Duygu', 'Kulaksizoglu', '555 555 55 55', 'duyguKulaksizoglu@hotmail.com'),
(10, 2, 10, '2022-12-18 02:52:44', '2021-12-28', 'Kime Ne Cafe', 'Ankara Cankaya Kavaklidere', 'Seden', 'Abaci', '', 'seden.abaci@hotmail.com'),
(11, 1, 10, '2022-12-25 15:46:05', '2020-12-28', 'asda', 'afaf', 'afsaf', 'afaf', 'afaf', 'afaf');

--
-- Triggers `tbl_mekan`
--
DROP TRIGGER IF EXISTS `1-silinen-mekan-log-mekana-ekle`;
DELIMITER $$
CREATE TRIGGER `1-silinen-mekan-log-mekana-ekle` BEFORE DELETE ON `tbl_mekan` FOR EACH ROW INSERT INTO
log_eski_uye_mekan(
	log_eski_uye_mekan.mekanID,
    log_eski_uye_mekan.uyelikTarihi,
    log_eski_uye_mekan.mekanAdi,
    log_eski_uye_mekan.mekanSahibiAd,
    log_eski_uye_mekan.mekanSahibiSoyad,
    log_eski_uye_mekan.mekanSahibiTell,
    log_eski_uye_mekan.mekanSahibiMail
)
SELECT 
old.mekanID,
old.uyelikTarihi,
old.mekanAdi,
old.mekanSahibiAd,
old.mekanSahibiSoyad,
old.mekanSahibiTell,
old.mekanSahibiMail
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_musteri`
--

DROP TABLE IF EXISTS `tbl_musteri`;
CREATE TABLE IF NOT EXISTS `tbl_musteri` (
  `musteriID` int(11) NOT NULL,
  `musteriAdi` varchar(100) DEFAULT NULL,
  `musteriSoyadi` varchar(100) DEFAULT NULL,
  `musteriMail` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`musteriID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_musteri`
--

INSERT INTO `tbl_musteri` (`musteriID`, `musteriAdi`, `musteriSoyadi`, `musteriMail`) VALUES
(1, 'Akif ', 'Sener', 'akif.sener@hotmail.com'),
(2, 'Bay Paker', 'Corlu', 'bay.paker.corlu@hotmail.com'),
(3, 'Melikkan Demirel', 'Gul', 'melikkan.demirel.gul@hotmail.com'),
(4, 'Tunahan', 'Seven', 'tunahan.seven@hotmail.com'),
(5, 'Bengibay', 'Arsoy', 'bengibay.arsoy@hotmail.com'),
(6, 'Hunalp', 'Durmus', 'hunalp.durmus@hotmail.com'),
(7, 'Isin Sezer', 'Zengin', 'isinsezer.zengin@hotmail.com'),
(8, 'Goli Demirel', 'Durmus', 'goli.demirel.durmus@hotmail.com'),
(9, 'Sejda Sebla', 'Corlu', 'sejda.sebla.corlu@hotmail.com'),
(10, 'Omriye Bilir', 'Bilir', 'omriye.bilir@hotmail');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_musteri_istek`
--

DROP TABLE IF EXISTS `tbl_musteri_istek`;
CREATE TABLE IF NOT EXISTS `tbl_musteri_istek` (
  `istekID` int(11) NOT NULL,
  `musteriID` int(11) DEFAULT NULL,
  `sarkiID` int(11) DEFAULT NULL,
  PRIMARY KEY (`istekID`),
  KEY `musteri_istek_FK1` (`musteriID`),
  KEY `musteri_istek_FK2` (`sarkiID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_musteri_istek`
--

INSERT INTO `tbl_musteri_istek` (`istekID`, `musteriID`, `sarkiID`) VALUES
(1, 4, 29),
(2, 3, 26),
(3, 5, 35),
(4, 1, 17),
(5, 2, 30),
(6, 4, 12),
(7, 3, 28),
(8, 2, 20),
(9, 1, 43),
(10, 8, 50);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_playlist`
--

DROP TABLE IF EXISTS `tbl_playlist`;
CREATE TABLE IF NOT EXISTS `tbl_playlist` (
  `playlistID` int(11) NOT NULL,
  `playlistAdi` varchar(150) DEFAULT NULL,
  `playlistSarkiSayisi` int(11) DEFAULT NULL,
  PRIMARY KEY (`playlistID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_playlist`
--

INSERT INTO `tbl_playlist` (`playlistID`, `playlistAdi`, `playlistSarkiSayisi`) VALUES
(1, 'DeepRockCafe Playlist', 10),
(2, 'DeepMetalCafe Playlist', 10),
(3, 'DeathMetalCafe Playlist', 10),
(4, 'TrashMetalCafe Playlist', 10),
(5, 'TurkceRockCafe Playlist', 10),
(6, 'Playlist 6', 0),
(7, 'Playlist 7', 0),
(8, 'Playlist 8', 0),
(9, 'Playlist 9', 0),
(10, 'Playlist 10', 0);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_sarkilar`
--

DROP TABLE IF EXISTS `tbl_sarkilar`;
CREATE TABLE IF NOT EXISTS `tbl_sarkilar` (
  `sarkiID` int(11) NOT NULL,
  `playlistID` int(11) DEFAULT NULL,
  `band` varchar(150) DEFAULT NULL,
  `album` varchar(150) DEFAULT NULL,
  `sarkiAdi` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`sarkiID`),
  KEY `playlistSarkilarFK` (`playlistID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_sarkilar`
--

INSERT INTO `tbl_sarkilar` (`sarkiID`, `playlistID`, `band`, `album`, `sarkiAdi`) VALUES
(1, 1, 'AC DC', 'Higway to Hell', 'Higway to Hell'),
(2, 1, 'GUNS N\' Roses', 'Appetite For Destruction', 'Welcome to The Jungle'),
(3, 1, 'Alice In Chains', 'Facelift', 'Man in the Box'),
(4, 1, 'Lordi', 'The Hills Have Eyes 2', 'Hard Rock Hallelujah'),
(5, 1, 'Judas Priest', 'British Steel', 'Breaking the Law'),
(6, 1, 'Johnny Cash', 'Amirican VI', 'Personal Jesus'),
(7, 1, 'Black Sabbath', 'Black Sabbath', 'N.I.B'),
(8, 1, 'Led Zeppelin', 'Led Zeppelin IV', 'Stairway to Heaven'),
(9, 1, 'Queen', 'A Night At The Opera', 'Bohemian Rhapsody'),
(10, 1, 'Bob Dylan', 'Desire', 'One More Cup of Coffee'),
(11, 2, 'Iron Maiden', 'Number Of The Beast', 'Hallowed By Thy Name'),
(12, 2, 'Motorhead', 'Kiss of Death', 'God Was Never on Your Side'),
(13, 2, 'Judas Priest', 'Painkiller', 'Painkiller'),
(14, 2, 'Manowar', 'Gods of War', 'Die for Metal'),
(15, 2, 'Pantera', 'Vulgar Display of Power', 'Walk'),
(16, 2, 'Anthrax', 'Spreading The Disease', 'Madhouse'),
(17, 2, 'Marilyn Manson', 'Antichrist Superstar', 'The Beautiful People'),
(18, 2, 'Dio', 'Holy Diver', 'Rainbow In The Dark'),
(19, 2, 'Opeth', 'Sorceress', 'Sorceress'),
(20, 2, 'Anthrax', 'Persistence Of Time', 'Got The Time'),
(21, 3, 'Sepultura', 'Roots', 'Roots Bloody Roots'),
(22, 3, 'Death', 'Symbolic', 'Zero Tolerance'),
(23, 3, 'Death', 'Scream Bloody Gore', 'Zombie Ritual'),
(24, 3, 'Sepultura', 'Roots', 'Ratamahatta'),
(25, 3, 'Death', 'Symbolic', 'Perennial Quest'),
(26, 3, 'Death', 'The Sound Of Perseverance', 'Spirit Crusher'),
(27, 3, 'Sepultura', 'Chaos A.D', 'Territory'),
(28, 3, 'Be\'lakor', 'Stone\'s Reach', 'Countless Skies'),
(29, 3, 'Mayhem', 'De Mysteriis Dom Sathanas', 'Freezing Moon'),
(30, 3, 'Burzum', 'Hvis Lyset Tar Oss', 'Det Som En Gang Var'),
(31, 5, 'Almora', 'Kalihora\'s Song', 'Cehennem Geceleri'),
(32, 5, 'Pentagram', 'Anatolia', 'Anatolia'),
(33, 5, 'Almora', 'Kiyamet Senfonisi', 'Iyiler Siyah Giyer'),
(34, 5, 'Pentagram', 'Bir', 'Seytan Bunun Neresinde'),
(35, 5, 'Erkin Koray', '1966', 'Bir Eylul Aksami'),
(36, 5, 'Almora', 'Kiyamet Senfonisi', 'Kiyamet Senfonisi'),
(37, 5, 'Erkin Koray', 'Fesuphanallah', 'Cemalim'),
(38, 5, 'Almora', 'Shehrazad', 'Gunesin Ozanlari'),
(39, 5, 'Almora', 'Kalihora\'s Song', 'Tears of the Angels'),
(40, 5, 'Almora', 'Kiyamet Senfonisi', 'Gidenlerin Ardindan'),
(41, 4, 'Megadeth', 'Count To Extinction', 'Symphony Of Destruction'),
(42, 4, 'Metallica', 'Kill \'Em All', 'Seek & Destroy'),
(43, 4, 'Megadeth', 'So Far,So Good... So What!', 'In My Darkest Hour'),
(44, 4, 'Megadeth', 'Youthanasia', 'A Tout Le Monde'),
(45, 4, 'Megadeth', 'Peace Sells...But Who\'s Buying', 'Peace Sells'),
(46, 4, 'Metallica', 'Hardwired...To Self-Destruct', 'Hardwired'),
(47, 4, 'Megadeth', 'Hidden Treasures', 'Angry Again'),
(48, 4, 'Slayer', 'Reign In Blood', 'Raining Blood'),
(49, 4, 'Pantera', 'Cowboys from Hell', 'Cowboys from Hell'),
(50, 4, 'Megadeth', 'Rust In Peace', 'Holy Wars... The Punishment Due');

--
-- Triggers `tbl_sarkilar`
--
DROP TRIGGER IF EXISTS `2-playlisteki-sarki-sayisi`;
DELIMITER $$
CREATE TRIGGER `2-playlisteki-sarki-sayisi` AFTER INSERT ON `tbl_sarkilar` FOR EACH ROW UPDATE tbl_playlist 
SET playlistSarkiSayisi=(
SELECT COUNT(tbl_sarkilar.sarkiID)
FROM tbl_sarkilar
WHERE
tbl_sarkilar.playlistID=tbl_playlist.playlistID
)
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `3-playlisteki-sarki-sayisi`;
DELIMITER $$
CREATE TRIGGER `3-playlisteki-sarki-sayisi` AFTER DELETE ON `tbl_sarkilar` FOR EACH ROW UPDATE tbl_playlist 
SET playlistSarkiSayisi=(
SELECT COUNT(tbl_sarkilar.sarkiID)
FROM tbl_sarkilar
WHERE
tbl_sarkilar.playlistID=tbl_playlist.playlistID
)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_uyelik`
--

DROP TABLE IF EXISTS `tbl_uyelik`;
CREATE TABLE IF NOT EXISTS `tbl_uyelik` (
  `uyelikTuruID` int(11) NOT NULL,
  `uyelikTuruAdi` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`uyelikTuruID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_uyelik`
--

INSERT INTO `tbl_uyelik` (`uyelikTuruID`, `uyelikTuruAdi`) VALUES
(1, 'Kullanim Bedeli Odemeli'),
(2, 'Ucretsiz her sarki istekginde yuzde 60 komisyon');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_uyelik_fiyat`
--

DROP TABLE IF EXISTS `tbl_uyelik_fiyat`;
CREATE TABLE IF NOT EXISTS `tbl_uyelik_fiyat` (
  `uyelikTuruID` int(11) DEFAULT NULL,
  `fiyat` int(11) DEFAULT NULL,
  KEY `uyelikTuruFK` (`uyelikTuruID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_uyelik_fiyat`
--

INSERT INTO `tbl_uyelik_fiyat` (`uyelikTuruID`, `fiyat`) VALUES
(1, 5000),
(2, NULL);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_mekan`
--
ALTER TABLE `tbl_mekan`
  ADD CONSTRAINT `mekanPlaylistFK` FOREIGN KEY (`playlistID`) REFERENCES `tbl_playlist` (`playlistID`),
  ADD CONSTRAINT `uyelikTuruFK1` FOREIGN KEY (`uyelikTuruID`) REFERENCES `tbl_uyelik` (`uyelikTuruID`);

--
-- Constraints for table `tbl_musteri_istek`
--
ALTER TABLE `tbl_musteri_istek`
  ADD CONSTRAINT `musteri_istek_FK1` FOREIGN KEY (`musteriID`) REFERENCES `tbl_musteri` (`musteriID`),
  ADD CONSTRAINT `musteri_istek_FK2` FOREIGN KEY (`sarkiID`) REFERENCES `tbl_sarkilar` (`sarkiID`);

--
-- Constraints for table `tbl_sarkilar`
--
ALTER TABLE `tbl_sarkilar`
  ADD CONSTRAINT `playlistSarkilarFK` FOREIGN KEY (`playlistID`) REFERENCES `tbl_playlist` (`playlistID`);

--
-- Constraints for table `tbl_uyelik_fiyat`
--
ALTER TABLE `tbl_uyelik_fiyat`
  ADD CONSTRAINT `uyelikTuruFK` FOREIGN KEY (`uyelikTuruID`) REFERENCES `tbl_uyelik` (`uyelikTuruID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
