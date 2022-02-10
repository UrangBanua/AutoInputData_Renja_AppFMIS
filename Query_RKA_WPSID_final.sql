SELECT
  a.id_rinci_sub_bl AS id_rka,
  IFNULL(id_standar_harga, 0) AS id_ssh,
  a.kode_bl,
  a.kode_sbl,
  a.jenis_bl AS jenis_rka,
  b.kode_sub_skpd AS kode_subunit,
  'Sasaran Renstra Perangkat Daerah diproses melalui Generated Data Perencanaan' AS sasaran,
  TRIM(b.nama_program) AS program,
  TRIM(b.nama_giat) AS kegiatan,
  TRIM(SUBSTRING(b.nama_sub_giat, 17, LENGTH(b.nama_sub_giat))) AS sub_kegiatan,
  b.pagu_n_lalu AS pagu_lalu,
  b.pagu AS pagu_sekarang,
  b.pagu_n_depan AS pagu_depan,
  TRIM(a.subs_bl_teks) AS aktivitas,
  TRIM(b.nama_sub_skpd) AS nama_subunit,
  TRIM(REPLACE(REPLACE(REPLACE(d.namadana, '[DANA KHUSUS] - ', ''), '[DANA UMUM] - ', ''),' - ','-')) AS sumber_dana,
  TRIM(a.satuan) AS satuan,
  TRIM(a.spek) AS spek,
  TRIM(a.ket_bl_teks) AS rincian_belanja,
  IFNULL(kode_standar_harga, 'batal') AS kode_ssh,
  a.kode_akun,
  TRIM(SUBSTRING(a.nama_akun, 19, LENGTH(a.nama_akun))) AS nama_rekening,
  a.sat1,
  a.volum1,
  a.sat2,
  a.volum2,
  a.sat3,
  a.volum3,
  a.volume,
  a.harga_satuan AS harga,
  a.total_harga
FROM data_rka a
  LEFT OUTER JOIN data_sub_keg_bl b
    ON a.kode_sbl = b.kode_sbl
  LEFT OUTER JOIN (SELECT DISTINCT
      data_dana_sub_keg.kode_sbl AS kode_sbl,
      data_dana_sub_keg.namadana
    FROM data_dana_sub_keg
    GROUP BY data_dana_sub_keg.kode_sbl) d
    ON d.kode_sbl = b.kode_sbl
  LEFT OUTER JOIN data_ssh e
    ON 
    (a.tahun_anggaran = e.tahun_anggaran
    AND a.nama_komponen = e.nama_standar_harga
    AND a.harga_satuan = e.harga
    AND a.satuan = e.satuan
    AND REPLACE(a.spek, 'Spesifikasi : ', '') = e.spek) OR
    (a.tahun_anggaran = e.tahun_anggaran
    AND a.nama_komponen = e.nama_standar_harga
    AND a.harga_satuan = e.harga
    AND a.satuan = e.satuan)
WHERE a.harga_satuan > 0
AND a.total_harga > 0
AND a.tahun_anggaran = 2022
-- AND (REPLACE(a.spek, 'Spesifikasi : ', '') LIKE e.spek
-- OR a.subs_bl_teks + ' | ' + a.ket_bl_teks LIKE LEFT(e.spek,10)+'%')
GROUP BY a.id,
         a.kode_akun,
         b.kode_sbl,
         b.nama_program,
         b.nama_giat,
         b.nama_sub_giat,
         d.namadana
ORDER BY a.id_rinci_sub_bl