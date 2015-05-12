From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Tue, 12 May 2015 16:24:31 -0400
Message-ID: <1431462271.43876.85.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-VGKor7S6wNVoHauenyl9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-VGKor7S6wNVoHauenyl9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull these -rc fixes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

----------------------------------------------------------------
Changes for 4.1-rc3

  Update MAINTAINERS git repo pointer
  printk garbage fix
  Fix for qib and iw_cxgb4 bugs introduced in 4.1 window
  Fix for an older iWARP netlink bug
  Fix a memcpy issue in ehca driver

----------------------------------------------------------------
Doug Ledford (1):
      MAINTAINERS: update the official rdma git repo

Joe Perches (1):
      infiniband: Remove duplicated KERN_<LEVEL> from pr_<level> uses

Mike Marciniszyn (1):
      IB/qib: fix test of unsigned variable

Nicholas Mc Guire (1):
      IB/ehca: use correct destination for memcpy

Steve Wise (1):
      iw_cxgb4: use wildcard mapping for getting remote addr info

Tatyana Nikolova (1):
      RDMA/core: Fix for parsing netlink string attribute

 MAINTAINERS                               |  2 +-
 drivers/infiniband/core/iwpm_msg.c        |  2 +-
 drivers/infiniband/hw/cxgb4/cm.c          | 16 ++++++++--------
 drivers/infiniband/hw/cxgb4/device.c      |  4 ++--
 drivers/infiniband/hw/ehca/ehca_mcast.c   |  4 ++--
 drivers/infiniband/hw/mlx4/main.c         |  3 +--
 drivers/infiniband/hw/mlx5/qp.c           |  2 +-
 drivers/infiniband/hw/qib/qib.h           |  2 +-
 drivers/infiniband/hw/qib/qib_wc_x86_64.c |  3 ++-
 9 files changed, 19 insertions(+), 19 deletions(-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-VGKor7S6wNVoHauenyl9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVUmF/AAoJELgmozMOVy/d5F0QAJaLub2zeYwecUEJo1cssyEr
dqstnNcs+pffBNKVuBcAuYeDQb0l50/14mjsql9IMcygR4PsOxjJnZgIv8lK9RfF
zpsKuqrwH56eMPLq+Ozqr272VRyM4Q0iMVwYi/cwW17EPPNYE+E+lr0stCG2Mejo
18Sv0yM/IHU4sMXMt/LKgVU+WBubkfG1bAacuKaul1hYorEXGhsSuDAFQn+AUVnK
Ec77Q8c3YxhRo+YCTSTOVv1sRFQiqlaKW67+kAT+kPkfan7uPTeei+cWYymX59Gz
l2u65gEHrBmlVJ7b4sv1fAx1PE/gUqbD0d3ttGOsGoZqOY2z8rTXKoRor7Zcn2Ij
noBzr30Ye6jd3Yeah6G5OQBJM/blDo9Mj+SYiudFw31c9SQe6gGbEANFU/MVrwJl
Tcxyj3WxmptSgKzNeo/RFsY6xGNqpL2iyZfKY8Sfa9ZqZc87Ol7PcH4U7NAzS8dP
VSpBz5VJ4RagsNOaYYo4MdFXOFZTkEgmG1ii+mz64b62jpdWBDJM/RQWS7Zaej2X
I0QT2T9YuccLZjkciuKEAeG81GKx6aTFIEWeu1ydYkM0vW3obUK/Y5+0yut+3mq1
/qIgeifyGxytrPjCaq3SerPqsCTp1Fh9WRSQpskChhw/AHAw3DqW1dAxMgoccfkK
f0yEmqDV7pZYb8ie11RX
=i/Ae
-----END PGP SIGNATURE-----

--=-VGKor7S6wNVoHauenyl9--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
