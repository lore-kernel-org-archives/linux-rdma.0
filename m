From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Tue, 14 Jul 2015 15:42:56 -0400
Message-ID: <55A56640.2000206@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cbEFoomGQvcNU5GQ2gw2c2B4GKEcUD2ef"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cbEFoomGQvcNU5GQ2gw2c2B4GKEcUD2ef
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This comprises a number of various fixes (including the ones you've
requested):

The following changes since commit bc197aad0daa:

  Linux 4.2-rc2 (2015-07-12 15:10:30 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to d8b2ba7c5928173fe1c12bd2545f5ed85d1c3c7a:

  IB/core: Destroy ocrdma_dev_id IDR on module exit (2015-07-14 13:20:16
-0400)

----------------------------------------------------------------
Changes for 4.2-rc

- Mainly fix-ups for the various 4.2 items

----------------------------------------------------------------
Amir Vadai (1):
      IB/IPoIB: Fix bad error flow in ipoib_add_port()

Carol L Soto (1):
      IB/ucm: Fix bitmap wrap when devnum > IB_UCM_MAX_DEVICES

Doug Ledford (2):
      IB/mlx4: Fix memory leak in do_slave_init
      IB/mlx4: Optimize do_slave_init

Erez Shitrit (2):
      IB/cm: Do not queue work to a device that's going away
      IB/ipoib: Set MTU to max allowed by mode when mode changes

Haggai Eran (2):
      IB/ucma: Fix lockdep warning in ucma_lock_files
      IB/ipoib: Prevent lockdep warning in __ipoib_ib_dev_flush

Hal Rosenstock (1):
      IB: Add rdma_cap_ib_switch helper and use where appropriate

Ira Weiny (2):
      IB/mad: Fix compare between big endian and cpu endian
      IB/mad: Remove improper use of BUG_ON

Johannes Thumshirn (2):
      IB/core: Destroy multcast_idr on module exit
      IB/core: Destroy ocrdma_dev_id IDR on module exit

Maninder Singh (1):
      IB/mlx4: Optimize freeing of items on error unwind

Matan Barak (1):
      IB/mlx4: Do not attemp to report HCA clock offset on VFs

Or Gerlitz (1):
      IB/mlx4: Fix use of flow-counters for process_mad

Sagi Grimberg (1):
      IB/srp: Avoid using uninitialized variable

Tatyana Nikolova (3):
      RDMA/core: Fixes for port mapper client registration
      RDMA/nes: Fix for resolving the neigh
      RDMA/nes: Fix for incorrect recording of the MAC address

Vaishali Thakkar (2):
      IB/srpt: Convert use of __constant_cpu_to_beXX to cpu_to_beXX
      IB/ipath: Convert use of __constant_<foo> to <foo>

Wengang Wang (1):
      rds: rds_ib_device.refcount overflow

Yuval Shaia (1):
      IB/ipoib: Scatter-Gather support in connected mode

 drivers/infiniband/core/agent.c            |  4 +-
 drivers/infiniband/core/cm.c               | 61 ++++++++++++++++++++++--=
-
 drivers/infiniband/core/iwpm_msg.c         | 33 +++++++-------
 drivers/infiniband/core/iwpm_util.c        | 12 ++++-
 drivers/infiniband/core/iwpm_util.h        | 28 +++++++++---
 drivers/infiniband/core/mad.c              | 47 +++++++-------------
 drivers/infiniband/core/multicast.c        |  8 +---
 drivers/infiniband/core/opa_smi.h          |  4 +-
 drivers/infiniband/core/sa_query.c         |  8 +---
 drivers/infiniband/core/smi.c              | 37 ++++++++--------
 drivers/infiniband/core/smi.h              |  4 +-
 drivers/infiniband/core/sysfs.c            |  2 +-
 drivers/infiniband/core/ucm.c              |  4 +-
 drivers/infiniband/core/ucma.c             |  5 ++-
 drivers/infiniband/hw/ehca/ehca_sqp.c      |  5 ++-
 drivers/infiniband/hw/ipath/ipath_mad.c    |  5 ++-
 drivers/infiniband/hw/ipath/ipath_verbs.c  |  4 +-
 drivers/infiniband/hw/mlx4/mad.c           | 34 +++++++++-----
 drivers/infiniband/hw/mlx4/main.c          | 33 +++++++-------
 drivers/infiniband/hw/mlx5/mad.c           |  5 ++-
 drivers/infiniband/hw/mthca/mthca_mad.c    |  5 ++-
 drivers/infiniband/hw/nes/nes_cm.c         |  5 ++-
 drivers/infiniband/hw/nes/nes_hw.c         |  2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c   |  5 ++-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c |  1 +
 drivers/infiniband/hw/qib/qib_mad.c        |  5 ++-
 drivers/infiniband/ulp/ipoib/ipoib.h       | 29 +++++++++++-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c    | 33 ++++++--------
 drivers/infiniband/ulp/ipoib/ipoib_ib.c    | 49 ++++++++-------------
 drivers/infiniband/ulp/ipoib/ipoib_main.c  | 21 ++++-----
 drivers/infiniband/ulp/srp/ib_srp.c        | 23 +++-------
 drivers/infiniband/ulp/srpt/ib_srpt.c      | 71
+++++++++++++++---------------
 drivers/scsi/scsi_transport_srp.c          |  3 +-
 include/rdma/ib_verbs.h                    | 20 +++++++--
 include/scsi/scsi_transport_srp.h          |  1 +
 net/rds/ib_rdma.c                          |  4 +-
 36 files changed, 351 insertions(+), 269 deletions(-)



--cbEFoomGQvcNU5GQ2gw2c2B4GKEcUD2ef
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVpWZAAAoJELgmozMOVy/dmjkQAJxoduO03Mu+QtlTPEWqEstf
gytvZbaFY2Foq39dhcMvUYzJnTIymbweoo5tj8h/k016XXCa21x5GTWpQXB9ZeUe
Uck/XYy1ZzxcOgjyludcxVWFT1nFM7kitwolDbbQnBz9+LAIEkxBvpWvnnj8uTk0
pmZ4WfaC4krk3FRUxB+D+7UnK4uQKwuVwT7dC0UQSy9jZru29ALVw8ZOzczEIOyj
153FMK+a1PSh1yGn0iq514yq9z+Ib1t1A+jUrLwPQWdhSmEVjX6wQM/+kRFf8pwG
WrqPEZgUN6n9Lv5cxkN948CqiHDP9ATbcfMXwA/VFTHz6dc72r3FUgJUcNh7P3lx
A51HMOB8cAa2WALSgQt6Wm5VQAm1SQzdXa+EiJ2/bTJtSxumim2cXQ+1VISw4LDx
tgBei7bhfdqfuVtJBmNedvVvK8Mge8docHzhhrH4RuHAisHQNiawE+QfpK7jFRAo
XL79Nh491LJ8O074QmNscejR4RqfhsOy5jZ3QHid096eBY3lOZlvPwodpsm8+zuC
V9gXulJF3rZQiHXFmwn/ZCHXLHI82wQGP5rsy7VNymLWY9woUrqkTWro784zaOCY
bCk8CWVGgr6pPMh1RFuTPEc7XKOmJfg2t0EyWOVmpAqg3wJONaQXuJM9fh2wgoZo
Q0EzreKqltPoNR6gq/5J
=dc2u
-----END PGP SIGNATURE-----

--cbEFoomGQvcNU5GQ2gw2c2B4GKEcUD2ef--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
