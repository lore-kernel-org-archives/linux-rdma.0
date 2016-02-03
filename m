From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Wed, 3 Feb 2016 15:24:52 -0500
Message-ID: <56B26214.1020606@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3cRGcaQkbxEEqPKCvEqdWrnreAlo2GJwo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3cRGcaQkbxEEqPKCvEqdWrnreAlo2GJwo
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

As per our off-list discussion, here is the pull request.

The following changes since commit 36f90b0a2ddd60823fe193a85e60ff1906c2a9=
b3:

  Linux 4.5-rc2 (2016-01-31 18:12:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to b85d9905a7ca128f24e3a4e60ff2a1b0cd58ae7c:

  staging/rdma: remove deprecated ipath driver (2016-02-03 11:10:58 -0500=
)

----------------------------------------------------------------
4.5-rc2 fixes

- One minor fix to the ib core
- Four minor fixes to the Mellanox drivers
- Remove three deprecated drivers from staging/rdma now that all of Greg'=
s
  queued changes to them are merged

----------------------------------------------------------------
Doug Ledford (3):
      staging/rdma: remove deprecated amso1100 driver
      staging/rdma: remove deprecated ehca driver
      staging/rdma: remove deprecated ipath driver

Majd Dibbiny (2):
      IB/mlx5: Fix reqlen validation in mlx5_ib_alloc_ucontext
      IB/mlx5: Fix use of null pointer PD

Maor Gottlieb (1):
      IB/mlx5: Use MLX5_GET to correctly get end of padding mode

Matan Barak (1):
      IB/mlx5: Add CREATE_CQ and CREATE_QP to uverbs_ex_cmd_mask

Moni Shoua (1):
      IB/core: Set correct payload length for RoCEv2 over IPv6

 MAINTAINERS                                      |   20 -
 drivers/infiniband/core/ud_header.c              |    7 +-
 drivers/infiniband/hw/mlx5/main.c                |    8 +-
 drivers/infiniband/hw/mlx5/qp.c                  |   20 +-
 drivers/staging/rdma/Kconfig                     |    6 -
 drivers/staging/rdma/Makefile                    |    3 -
 drivers/staging/rdma/amso1100/Kbuild             |    6 -
 drivers/staging/rdma/amso1100/Kconfig            |   15 -
 drivers/staging/rdma/amso1100/TODO               |    4 -
 drivers/staging/rdma/amso1100/c2.c               | 1240 ----------
 drivers/staging/rdma/amso1100/c2.h               |  547 -----
 drivers/staging/rdma/amso1100/c2_ae.c            |  327 ---
 drivers/staging/rdma/amso1100/c2_ae.h            |  108 -
 drivers/staging/rdma/amso1100/c2_alloc.c         |  142 --
 drivers/staging/rdma/amso1100/c2_cm.c            |  458 ----
 drivers/staging/rdma/amso1100/c2_cq.c            |  437 ----
 drivers/staging/rdma/amso1100/c2_intr.c          |  219 --
 drivers/staging/rdma/amso1100/c2_mm.c            |  377 ---
 drivers/staging/rdma/amso1100/c2_mq.c            |  175 --
 drivers/staging/rdma/amso1100/c2_mq.h            |  106 -
 drivers/staging/rdma/amso1100/c2_pd.c            |   90 -
 drivers/staging/rdma/amso1100/c2_provider.c      |  862 -------
 drivers/staging/rdma/amso1100/c2_provider.h      |  182 --
 drivers/staging/rdma/amso1100/c2_qp.c            | 1024 --------
 drivers/staging/rdma/amso1100/c2_rnic.c          |  652 -----
 drivers/staging/rdma/amso1100/c2_status.h        |  158 --
 drivers/staging/rdma/amso1100/c2_user.h          |   82 -
 drivers/staging/rdma/amso1100/c2_vq.c            |  260 --
 drivers/staging/rdma/amso1100/c2_vq.h            |   63 -
 drivers/staging/rdma/amso1100/c2_wr.h            | 1520 ------------
 drivers/staging/rdma/ehca/Kconfig                |   10 -
 drivers/staging/rdma/ehca/Makefile               |   16 -
 drivers/staging/rdma/ehca/TODO                   |    4 -
 drivers/staging/rdma/ehca/ehca_av.c              |  279 ---
 drivers/staging/rdma/ehca/ehca_classes.h         |  481 ----
 drivers/staging/rdma/ehca/ehca_classes_pSeries.h |  208 --
 drivers/staging/rdma/ehca/ehca_cq.c              |  397 ---
 drivers/staging/rdma/ehca/ehca_eq.c              |  189 --
 drivers/staging/rdma/ehca/ehca_hca.c             |  414 ----
 drivers/staging/rdma/ehca/ehca_irq.c             |  870 -------
 drivers/staging/rdma/ehca/ehca_irq.h             |   77 -
 drivers/staging/rdma/ehca/ehca_iverbs.h          |  202 --
 drivers/staging/rdma/ehca/ehca_main.c            | 1118 ---------
 drivers/staging/rdma/ehca/ehca_mcast.c           |  131 -
 drivers/staging/rdma/ehca/ehca_mrmw.c            | 2202 ----------------=
-
 drivers/staging/rdma/ehca/ehca_mrmw.h            |  127 -
 drivers/staging/rdma/ehca/ehca_pd.c              |  123 -
 drivers/staging/rdma/ehca/ehca_qes.h             |  260 --
 drivers/staging/rdma/ehca/ehca_qp.c              | 2256 ----------------=
--
 drivers/staging/rdma/ehca/ehca_reqs.c            |  953 --------
 drivers/staging/rdma/ehca/ehca_sqp.c             |  245 --
 drivers/staging/rdma/ehca/ehca_tools.h           |  155 --
 drivers/staging/rdma/ehca/ehca_uverbs.c          |  309 ---
 drivers/staging/rdma/ehca/hcp_if.c               |  949 --------
 drivers/staging/rdma/ehca/hcp_if.h               |  265 --
 drivers/staging/rdma/ehca/hcp_phyp.c             |   82 -
 drivers/staging/rdma/ehca/hcp_phyp.h             |   90 -
 drivers/staging/rdma/ehca/hipz_fns.h             |   68 -
 drivers/staging/rdma/ehca/hipz_fns_core.h        |  100 -
 drivers/staging/rdma/ehca/hipz_hw.h              |  414 ----
 drivers/staging/rdma/ehca/ipz_pt_fn.c            |  289 ---
 drivers/staging/rdma/ehca/ipz_pt_fn.h            |  289 ---
 drivers/staging/rdma/ipath/Kconfig               |   16 -
 drivers/staging/rdma/ipath/Makefile              |   37 -
 drivers/staging/rdma/ipath/TODO                  |    5 -
 drivers/staging/rdma/ipath/ipath_common.h        |  851 -------
 drivers/staging/rdma/ipath/ipath_cq.c            |  483 ----
 drivers/staging/rdma/ipath/ipath_debug.h         |   99 -
 drivers/staging/rdma/ipath/ipath_diag.c          |  551 -----
 drivers/staging/rdma/ipath/ipath_dma.c           |  179 --
 drivers/staging/rdma/ipath/ipath_driver.c        | 2784
----------------------
 drivers/staging/rdma/ipath/ipath_eeprom.c        | 1183 ---------
 drivers/staging/rdma/ipath/ipath_file_ops.c      | 2619
--------------------
 drivers/staging/rdma/ipath/ipath_fs.c            |  415 ----
 drivers/staging/rdma/ipath/ipath_iba6110.c       | 1939 ---------------
 drivers/staging/rdma/ipath/ipath_init_chip.c     | 1062 ---------
 drivers/staging/rdma/ipath/ipath_intr.c          | 1271 ----------
 drivers/staging/rdma/ipath/ipath_kernel.h        | 1374 -----------
 drivers/staging/rdma/ipath/ipath_keys.c          |  270 ---
 drivers/staging/rdma/ipath/ipath_mad.c           | 1521 ------------
 drivers/staging/rdma/ipath/ipath_mmap.c          |  174 --
 drivers/staging/rdma/ipath/ipath_mr.c            |  370 ---
 drivers/staging/rdma/ipath/ipath_qp.c            | 1079 ---------
 drivers/staging/rdma/ipath/ipath_rc.c            | 1969 ---------------
 drivers/staging/rdma/ipath/ipath_registers.h     |  512 ----
 drivers/staging/rdma/ipath/ipath_ruc.c           |  733 ------
 drivers/staging/rdma/ipath/ipath_sdma.c          |  818 -------
 drivers/staging/rdma/ipath/ipath_srq.c           |  380 ---
 drivers/staging/rdma/ipath/ipath_stats.c         |  347 ---
 drivers/staging/rdma/ipath/ipath_sysfs.c         | 1237 ----------
 drivers/staging/rdma/ipath/ipath_uc.c            |  547 -----
 drivers/staging/rdma/ipath/ipath_ud.c            |  579 -----
 drivers/staging/rdma/ipath/ipath_user_pages.c    |  228 --
 drivers/staging/rdma/ipath/ipath_user_sdma.c     |  874 -------
 drivers/staging/rdma/ipath/ipath_user_sdma.h     |   52 -
 drivers/staging/rdma/ipath/ipath_verbs.c         | 2376 ----------------=
--
 drivers/staging/rdma/ipath/ipath_verbs.h         |  941 --------
 drivers/staging/rdma/ipath/ipath_verbs_mcast.c   |  363 ---
 drivers/staging/rdma/ipath/ipath_wc_ppc64.c      |   49 -
 drivers/staging/rdma/ipath/ipath_wc_x86_64.c     |  144 --
 100 files changed, 20 insertions(+), 53101 deletions(-)
 delete mode 100644 drivers/staging/rdma/amso1100/Kbuild
 delete mode 100644 drivers/staging/rdma/amso1100/Kconfig
 delete mode 100644 drivers/staging/rdma/amso1100/TODO
 delete mode 100644 drivers/staging/rdma/amso1100/c2.c
 delete mode 100644 drivers/staging/rdma/amso1100/c2.h
 delete mode 100644 drivers/staging/rdma/amso1100/c2_ae.c
 delete mode 100644 drivers/staging/rdma/amso1100/c2_ae.h
 delete mode 100644 drivers/staging/rdma/amso1100/c2_alloc.c
 delete mode 100644 drivers/staging/rdma/amso1100/c2_cm.c
 delete mode 100644 drivers/staging/rdma/amso1100/c2_cq.c
 delete mode 100644 drivers/staging/rdma/amso1100/c2_intr.c
 delete mode 100644 drivers/staging/rdma/amso1100/c2_mm.c
 delete mode 100644 drivers/staging/rdma/amso1100/c2_mq.c
 delete mode 100644 drivers/staging/rdma/amso1100/c2_mq.h
 delete mode 100644 drivers/staging/rdma/amso1100/c2_pd.c
 delete mode 100644 drivers/staging/rdma/amso1100/c2_provider.c
 delete mode 100644 drivers/staging/rdma/amso1100/c2_provider.h
 delete mode 100644 drivers/staging/rdma/amso1100/c2_qp.c
 delete mode 100644 drivers/staging/rdma/amso1100/c2_rnic.c
 delete mode 100644 drivers/staging/rdma/amso1100/c2_status.h
 delete mode 100644 drivers/staging/rdma/amso1100/c2_user.h
 delete mode 100644 drivers/staging/rdma/amso1100/c2_vq.c
 delete mode 100644 drivers/staging/rdma/amso1100/c2_vq.h
 delete mode 100644 drivers/staging/rdma/amso1100/c2_wr.h
 delete mode 100644 drivers/staging/rdma/ehca/Kconfig
 delete mode 100644 drivers/staging/rdma/ehca/Makefile
 delete mode 100644 drivers/staging/rdma/ehca/TODO
 delete mode 100644 drivers/staging/rdma/ehca/ehca_av.c
 delete mode 100644 drivers/staging/rdma/ehca/ehca_classes.h
 delete mode 100644 drivers/staging/rdma/ehca/ehca_classes_pSeries.h
 delete mode 100644 drivers/staging/rdma/ehca/ehca_cq.c
 delete mode 100644 drivers/staging/rdma/ehca/ehca_eq.c
 delete mode 100644 drivers/staging/rdma/ehca/ehca_hca.c
 delete mode 100644 drivers/staging/rdma/ehca/ehca_irq.c
 delete mode 100644 drivers/staging/rdma/ehca/ehca_irq.h
 delete mode 100644 drivers/staging/rdma/ehca/ehca_iverbs.h
 delete mode 100644 drivers/staging/rdma/ehca/ehca_main.c
 delete mode 100644 drivers/staging/rdma/ehca/ehca_mcast.c
 delete mode 100644 drivers/staging/rdma/ehca/ehca_mrmw.c
 delete mode 100644 drivers/staging/rdma/ehca/ehca_mrmw.h
 delete mode 100644 drivers/staging/rdma/ehca/ehca_pd.c
 delete mode 100644 drivers/staging/rdma/ehca/ehca_qes.h
 delete mode 100644 drivers/staging/rdma/ehca/ehca_qp.c
 delete mode 100644 drivers/staging/rdma/ehca/ehca_reqs.c
 delete mode 100644 drivers/staging/rdma/ehca/ehca_sqp.c
 delete mode 100644 drivers/staging/rdma/ehca/ehca_tools.h
 delete mode 100644 drivers/staging/rdma/ehca/ehca_uverbs.c
 delete mode 100644 drivers/staging/rdma/ehca/hcp_if.c
 delete mode 100644 drivers/staging/rdma/ehca/hcp_if.h
 delete mode 100644 drivers/staging/rdma/ehca/hcp_phyp.c
 delete mode 100644 drivers/staging/rdma/ehca/hcp_phyp.h
 delete mode 100644 drivers/staging/rdma/ehca/hipz_fns.h
 delete mode 100644 drivers/staging/rdma/ehca/hipz_fns_core.h
 delete mode 100644 drivers/staging/rdma/ehca/hipz_hw.h
 delete mode 100644 drivers/staging/rdma/ehca/ipz_pt_fn.c
 delete mode 100644 drivers/staging/rdma/ehca/ipz_pt_fn.h
 delete mode 100644 drivers/staging/rdma/ipath/Kconfig
 delete mode 100644 drivers/staging/rdma/ipath/Makefile
 delete mode 100644 drivers/staging/rdma/ipath/TODO
 delete mode 100644 drivers/staging/rdma/ipath/ipath_common.h
 delete mode 100644 drivers/staging/rdma/ipath/ipath_cq.c
 delete mode 100644 drivers/staging/rdma/ipath/ipath_debug.h
 delete mode 100644 drivers/staging/rdma/ipath/ipath_diag.c
 delete mode 100644 drivers/staging/rdma/ipath/ipath_dma.c
 delete mode 100644 drivers/staging/rdma/ipath/ipath_driver.c
 delete mode 100644 drivers/staging/rdma/ipath/ipath_eeprom.c
 delete mode 100644 drivers/staging/rdma/ipath/ipath_file_ops.c
 delete mode 100644 drivers/staging/rdma/ipath/ipath_fs.c
 delete mode 100644 drivers/staging/rdma/ipath/ipath_iba6110.c
 delete mode 100644 drivers/staging/rdma/ipath/ipath_init_chip.c
 delete mode 100644 drivers/staging/rdma/ipath/ipath_intr.c
 delete mode 100644 drivers/staging/rdma/ipath/ipath_kernel.h
 delete mode 100644 drivers/staging/rdma/ipath/ipath_keys.c
 delete mode 100644 drivers/staging/rdma/ipath/ipath_mad.c
 delete mode 100644 drivers/staging/rdma/ipath/ipath_mmap.c
 delete mode 100644 drivers/staging/rdma/ipath/ipath_mr.c
 delete mode 100644 drivers/staging/rdma/ipath/ipath_qp.c
 delete mode 100644 drivers/staging/rdma/ipath/ipath_rc.c
 delete mode 100644 drivers/staging/rdma/ipath/ipath_registers.h
 delete mode 100644 drivers/staging/rdma/ipath/ipath_ruc.c
 delete mode 100644 drivers/staging/rdma/ipath/ipath_sdma.c
 delete mode 100644 drivers/staging/rdma/ipath/ipath_srq.c
 delete mode 100644 drivers/staging/rdma/ipath/ipath_stats.c
 delete mode 100644 drivers/staging/rdma/ipath/ipath_sysfs.c
 delete mode 100644 drivers/staging/rdma/ipath/ipath_uc.c
 delete mode 100644 drivers/staging/rdma/ipath/ipath_ud.c
 delete mode 100644 drivers/staging/rdma/ipath/ipath_user_pages.c
 delete mode 100644 drivers/staging/rdma/ipath/ipath_user_sdma.c
 delete mode 100644 drivers/staging/rdma/ipath/ipath_user_sdma.h
 delete mode 100644 drivers/staging/rdma/ipath/ipath_verbs.c
 delete mode 100644 drivers/staging/rdma/ipath/ipath_verbs.h
 delete mode 100644 drivers/staging/rdma/ipath/ipath_verbs_mcast.c
 delete mode 100644 drivers/staging/rdma/ipath/ipath_wc_ppc64.c
 delete mode 100644 drivers/staging/rdma/ipath/ipath_wc_x86_64.c

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--3cRGcaQkbxEEqPKCvEqdWrnreAlo2GJwo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWsmIUAAoJELgmozMOVy/d1+oP/1vVJmxui/yZexjkEsnXpNy6
OBdTaR1XvgqyH79iUnC9OtD/3JH1zQAT8xEA2ebCKWigvhhl9xkGI8mVz8crcAhg
JZ6XKLU8f786q+6sRjtEjIj2YJDOJmnbD5vn5PoUeCL+uhtwlTSgBfkmwIDG2j5F
dN4/4DxXYVZ3T1MMcnNgQw9So/ugEhZSmwAHjfNbSPGkF/kAKOyTilaZ5N8vAbHL
TtygU+a9jc72zhdhgVziEvDaelqd259isSZ/T9G6W2+ZBlVbWIYtPp+ajwbXFN1H
hGrblkhYlCATCR02idL/WlBEJA/+M+vXde4nEgZfelvpkOS2RTbZsZhwlIS7N9A7
oO22IXfR3dLsBMTWnb32ITBmrV8BX0AHo8V3jlBDMBYYvJUsSHwKiuECoqU9taj3
Dl1lmCSUH4wUH7Pyvg3gsalzywZm70lfYncbl9SRUa7+XKXLgzWCw8X7DewqG2zK
t75c3e5lTJe5mL8dPM2whK/ZxuChJ6ejKWwf3i9FcIHZMu7h7udrCgGDIw5p9IjL
46fQO6eP2l3NbNdcXBb9EH0CyLKlQOIcQKMtgdpdReIeZscCZdw8Iaca9KEagO21
vrV8MqbfQWghe8rQt5QyrQVBkiS0faDxiEB8RxKY/ecmIC65eusXVHU2Oj+zZyJG
mMFUo9TVJXRcoTLLSZwk
=VazI
-----END PGP SIGNATURE-----

--3cRGcaQkbxEEqPKCvEqdWrnreAlo2GJwo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
