From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Thu, 9 Jun 2016 12:32:54 -0400
Message-ID: <372115f0-64fe-b092-3485-f071737e5e1a@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VSpBJgFmN7s8gVDkUtJVuu8namqodEVoc"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VSpBJgFmN7s8gVDkUtJVuu8namqodEVoc
Content-Type: multipart/mixed; boundary="UNUenK4d2f4qqmF3CI7q6UU4aq6LCKAvf"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <372115f0-64fe-b092-3485-f071737e5e1a-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git

--UNUenK4d2f4qqmF3CI7q6UU4aq6LCKAvf
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This is the first -rc pull for the RDMA subsystem.  The patch count is
high, but they are all smallish patches fixing simple things for the
most part, and the overall line count of changes here is smaller than
the patch count would lead a person to believe.

Code is up and running in my labs, including direct testing of cxgb4,
mlx4, mlx5, ocrdma, and qib.

Here's the boilerplate:

The following changes since commit af8c34ce6ae32addda3788d54a7e340cad2251=
6b:

  Linux 4.7-rc2 (2016-06-05 14:31:26 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to 61c78eea9516a921799c17b4c20558e2aa780fd3:

  IB/IPoIB: Don't update neigh validity for unresolved entries
(2016-06-07 10:49:48 -0400)

----------------------------------------------------------------
Round one of 4.7 rc fixes

- Multiple minor fixes to the rdma core
- Multiple minor fixes to hfi1
- Multiple minor fixes to mlx5
- A very few other minor fixes (SRP, IPoIB, usNIC, mlx4)

----------------------------------------------------------------
Achiad Shochat (1):
      IB/mlx5: Fix alternate path code

Aviv Heller (1):
      IB/core: Fix removal of default GID cache entry

Bart Van Assche (10):
      IB/cm: Fix a recently introduced locking bug
      IB/mlx4: Fix device managed flow steering support test
      IB/srp: Always initialize use_fast_reg and use_fmr
      IB/srp: Fix srp_map_sg_dma()
      RDMA/core: Fix indentation
      IB/mad: Fix indentation
      IB/rdmavt: Annotate rvt_reset_qp()
      IB/hfi1: Fix indentation
      IB/hfi1: Use bit 0 instead of bit 1
      IB/hfi1: Suppress sparse warnings

Colin Ian King (1):
      IB/core: fix null pointer deref and mem leak in error handling

Dan Carpenter (2):
      IB/hfi1: fix some indenting
      IB/core: fix an error code in ib_core_init()

Doug Ledford (2):
      IB/core: Fix array length allocation
      IB/core: fix error unwind in sysfs hw counters code

Eli Cohen (1):
      IB/core: Fix query port failure in RoCE

Eran Ben Elisha (1):
      IB/mlx5: Fix FW version diaplay in sysfs

Erez Shitrit (2):
      IB/IPoIB: Fix race between ipoib_remove_one to sysfs functions
      IB/IPoIB: Don't update neigh validity for unresolved entries

Krzysztof Kozlowski (1):
      IB/usnic: Remove unused DMA attributes

Leon Romanovsky (1):
      IB/hfi1: Avoid large frame size warning

Maor Gottlieb (1):
      IB/mlx5: Set flow steering capability bit

Mark Bloch (2):
      IB/IPoIB: Disable bottom half when dealing with device address
      IB/core: Initialize sysfs attributes before sysfs create group

Max Gurtovoy (2):
      IB/core: Fix bit curruption in ib_device_cap_flags structure
      IB/core: Make all casts in ib_device_cap_flags enum consistent

Noa Osherovich (7):
      IB/mlx5: Return PORT_ERR in Active to Initializing tranisition
      IB/mlx5: Limit query HCA clock
      IB/mlx5: Fix returned values of query QP
      IB/mlx5: Check BlueFlame HCA support
      IB/mlx5: Fix entries checks in mlx5_ib_create_cq
      IB/mlx5: Fix entries check in mlx5_ib_resize_cq
      IB/mlx5: Fix pkey_index length in the QP path record

 drivers/infiniband/core/cache.c                | 10 +++++--
 drivers/infiniband/core/cm.c                   |  4 +--
 drivers/infiniband/core/device.c               |  6 +++-
 drivers/infiniband/core/iwpm_msg.c             |  2 +-
 drivers/infiniband/core/mad.c                  |  6 ++--
 drivers/infiniband/core/sysfs.c                | 24 ++++++++++-----
 drivers/infiniband/hw/hfi1/affinity.c          | 31 +++++++++----------
 drivers/infiniband/hw/hfi1/chip.c              |  6 ++--
 drivers/infiniband/hw/hfi1/init.c              |  2 +-
 drivers/infiniband/hw/hfi1/trace.c             | 13 --------
 drivers/infiniband/hw/hfi1/user_sdma.c         |  6 ++--
 drivers/infiniband/hw/mlx4/main.c              |  4 +--
 drivers/infiniband/hw/mlx5/cq.c                | 12 ++++++--
 drivers/infiniband/hw/mlx5/main.c              | 22 +++++++++-----
 drivers/infiniband/hw/mlx5/qp.c                | 41
++++++++++++++++----------
 drivers/infiniband/hw/usnic/usnic_uiom.c       |  5 ----
 drivers/infiniband/sw/rdmavt/qp.c              |  6 ++++
 drivers/infiniband/ulp/ipoib/ipoib.h           |  1 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |  4 +++
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |  8 ++---
 drivers/infiniband/ulp/ipoib/ipoib_main.c      | 15 ++++++----
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |  6 ++--
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c      |  6 ++++
 drivers/infiniband/ulp/srp/ib_srp.c            |  7 ++---
 include/linux/mlx5/qp.h                        |  5 ++--
 include/rdma/ib_verbs.h                        |  6 ++--
 26 files changed, 148 insertions(+), 110 deletions(-)


--UNUenK4d2f4qqmF3CI7q6UU4aq6LCKAvf--

--VSpBJgFmN7s8gVDkUtJVuu8namqodEVoc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXWZo2AAoJELgmozMOVy/d4q8P/0xW2zJhHekhdJEaMlkwYOya
TCjprkouaSoImt8pGu88kyzqUfJPNQYMAzI5CSNmkTzNEFw+cPVWIiBQO7Si1U0p
l637G6Wss8PV0tcBKvgHPITNzEbDvpXs9H8MDQBG7U3R7a+FQE5s5FXbgdjGh8fs
S6a5Sfex0+EDhjmPVpmHXuLbSg1UznXkHWG+TvFWZ5cxJiOacV3fFentj6Sq49HI
JEu8xLVtWU7sqOW9X/y/jdiR0rKBc2C1n3BrLVBoBCkxwD1rhLulqacCZqe7devF
9rO9Clry7dbOtncvB3YPeRj5tvyz+PXzAClyMD1Ym3BuM58MNUNF+2WCvg+0/GZz
ERXsavk5y1c5AvvIxA7rD+0IZe7WoaFcDCsGGjF5S+NWvcaKx4+B1sIeSovBNe9K
kxoxwKyl0Y9Zgv1djhr9PYAzwH831HbrmzADSezgWZn0Es/tZRzjdrLvJrumvnPx
7zAp+GNthD5TVn+GKN2NKzUHuWFzb08rmj2XXG4AOk+WwaCOfYyyscyWeRxXMaIX
C/Rj5ZZnkJrN1a98WQFuTbB/NnUtfBGdtZRp9SfGzGwYmGStv00cRNzh/zPKSGBY
W3luDQspmOnRP/8jW/ELRGeCoi6/vrXhmK7V91DN6WfKwxNY8xTPn0IisnolOobb
Ns8eHrf0hbt2uu4Bn/nA
=iEsz
-----END PGP SIGNATURE-----

--VSpBJgFmN7s8gVDkUtJVuu8namqodEVoc--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
