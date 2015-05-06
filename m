From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [GIT PULL] please pull linux.git
Date: Wed, 06 May 2015 10:56:32 -0400
Message-ID: <1430924192.2407.322.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-WBU9TXDNFgqTgjPvBq23"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-WBU9TXDNFgqTgjPvBq23
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from

  git://github.com/dledford/linux.git tags/for-linus

Most of the changes are fairly small and well confined.  The
iWARP address reporting changes are the only ones that are a
medium size.  I had these queued up prior to rc1, but due to
the shuffle in maintainers,  they did not get submitted when
I expected.  My apologies for that.  I feel comfortable with
them however due to the testing they've received,  so I left
them in this submission.

----------------------------------------------------------------
Minor updates for 4.1-rc

----------------------------------------------------------------
Bart Van Assche (1):
      IPoIB/CM: Fix indentation level

David Ahern (1):
      IB/core: Fix unaligned accesses

Doug Ledford (1):
      MAINTAINERS: Update InfiniBand subsystem maintainer

Guy Shapiro (2):
      IB/core: dma map/unmap locking optimizations
      IB/core: dma unmap optimizations

Hariprasad S (5):
      iw_cxgb4: Cleanup register defines/MACROS
      iw_cxgb4: 32b platform fixes
      iw_cxgb4: use BAR2 GTS register for T5 kernel mode CQs
      iw_cxgb4: enforce qp/cq id requirements
      iw_cxgb4: Remove negative advice dmesg warnings

Honggang LI (1):
      IB/core: change rdma_gid2ip into void function as it always return ze=
ro

Jason Gunthorpe (1):
      RDMA/CMA: Canonize IPv4 on IPV6 sockets properly

Luis R. Rodriguez (2):
      IB/qib: add acounting for MTRR
      IB/qib: use arch_phys_wc_add()

Steve Wise (1):
      RDMA/cxgb4: Report the actual address of the remote connecting peer

Tatyana Nikolova (2):
      RDMA/core: Enable the iWarp Port Mapper to provide the actual address=
 of the connecting peer to its clients
      RDMA/nes: Report the actual address of the remote connecting peer

Yann Droneaud (1):
      MAINTAINERS: add include/rdma/ to InfiniBand subsystem

 MAINTAINERS                               |   6 +-
 drivers/infiniband/core/addr.c            |  13 +-
 drivers/infiniband/core/cm.c              |  23 ++--
 drivers/infiniband/core/cm_msgs.h         |   4 +-
 drivers/infiniband/core/cma.c             |  27 ++--
 drivers/infiniband/core/iwpm_msg.c        |  73 ++++++++++-
 drivers/infiniband/core/iwpm_util.c       | 208 +++++++++++++++++++++++++-=
----
 drivers/infiniband/core/iwpm_util.h       |  15 +++
 drivers/infiniband/core/umem_odp.c        |  14 +-
 drivers/infiniband/hw/cxgb4/cm.c          |  87 ++++++++++---
 drivers/infiniband/hw/cxgb4/cq.c          |  22 ++--
 drivers/infiniband/hw/cxgb4/device.c      |  37 +++++-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h    |   7 +
 drivers/infiniband/hw/cxgb4/mem.c         |   6 +-
 drivers/infiniband/hw/cxgb4/qp.c          |  10 +-
 drivers/infiniband/hw/cxgb4/t4.h          |   7 +-
 drivers/infiniband/hw/cxgb4/t4fw_ri_api.h |   4 +-
 drivers/infiniband/hw/nes/nes.c           |   1 +
 drivers/infiniband/hw/nes/nes_cm.c        |  65 +++++++---
 drivers/infiniband/hw/qib/qib.h           |   1 -
 drivers/infiniband/hw/qib/qib_file_ops.c  |   3 +-
 drivers/infiniband/hw/qib/qib_iba6120.c   |   8 +-
 drivers/infiniband/hw/qib/qib_iba7220.c   |   8 +-
 drivers/infiniband/hw/qib/qib_iba7322.c   |  41 +++---
 drivers/infiniband/hw/qib/qib_init.c      |  26 +---
 drivers/infiniband/hw/qib/qib_wc_x86_64.c |  31 +----
 drivers/infiniband/ulp/ipoib/ipoib_cm.c   |   4 +-
 include/rdma/ib_addr.h                    |   3 +-
 include/rdma/ib_cm.h                      |   7 +-
 include/rdma/iw_portmap.h                 |  25 ++++
 include/uapi/rdma/rdma_netlink.h          |   1 +
 31 files changed, 568 insertions(+), 219 deletions(-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-WBU9TXDNFgqTgjPvBq23
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVSiugAAoJELgmozMOVy/dLQsP/3UOCwZ2R6CKiASXz11Rv2dW
DyKyWUgDv8cuxFOUEcz1EcXvTWcTZkTHq1u4Pt0NvC79C7NjBRbJLpKyJj+OaKAp
OB2pDAJyx6F4HioZUbKABf5yIwqcx3imsy0Uqq5+iTJhK2TP5grBLfz16LKAyKaJ
m7j7AQEapsyBsUwYJa4v2eEtzTgp5bjAVm++0EpJvgQxt1fbz8zZbMxVv5e+qA5v
LE0Ah6IjiYQpqqGFdbIqsWHK2xLegp7DiaMnLJILe2qW7+G1ZAg7sTCAmOZfAXCK
3wRcZNMU4HM3nE6DLIe3S3DOsC16/BIskBBFPwaN0VJiAmeuS2mZb/veecKmQ0zk
oJgEy9elBgyqf+w6nilN3bgnSab0V3TVYKQrlCddKBHUFihQ/NJv2+q0d1JmB/Gh
Anoci6aEad+p73ij9SFiqNXFte+z2MX+UFpnWxpqzIlJVNBsgWffWw9rVDjjk7sf
GQYEZEJbm3FyKxDCP/pS/+JP/zLt6dsAvpg/jxh3rWWW0hyLSsYZF8ejRKbqeJel
BZLYUKWZTAE2dbyTZMgCeXBX5xsE35TGuSGLUrMyjFkOu/cuiaeefsAHY9XzbR46
kGegN0szIc+7fiz+sqQ6SMc9OEgnujdPkKnGy+geYz9jsQ4rKWIe2lCv7oTDtiDo
z3rZY1jpYLzVx+vuuv0o
=XDJD
-----END PGP SIGNATURE-----

--=-WBU9TXDNFgqTgjPvBq23--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
