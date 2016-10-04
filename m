From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Tue, 4 Oct 2016 09:50:27 -0400
Message-ID: <8434ee69-d81c-20f1-add3-ff072a63f569@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IJmeEExPOH9vcDHcPJ0A7SM2fBB31N8fX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IJmeEExPOH9vcDHcPJ0A7SM2fBB31N8fX
Content-Type: multipart/mixed; boundary="59n6s59xWqSjvKnQ0NuooMOSprko151HE";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <8434ee69-d81c-20f1-add3-ff072a63f569-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git

--59n6s59xWqSjvKnQ0NuooMOSprko151HE
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This is the first pull request of the 4.9 merge window for the RDMA
subsystem.  It is only the hfi1 driver.  It had dependencies on code
that only landed late in the 4.7-rc cycle (around 4.7-rc7), so putting
this with my other for-next code would have create an ugly merge of lot
of 4.7-rc stuff.  For that reason, it's being submitted individually.
It's been through 0day and linux-next.  I'll be sending a different
topic branch through linux-next today and will make a new pull request
once you've picked this one up.  I expect there will be three or four
pull requests this cycle as I'm somewhat splitting things up into these
broad groups:

1) hfi1 driver update (needed late 4.7-rc code)
2) hns-roce driver (new driver, still waiting on last few patch
approvals from netdev@)
3) rest of the core stack (needs to wait until after DaveM's tree has
been pulled because it needed to be based on his net-next tree from
around 4.7-rc4)
4) there are four other brand new drivers on the list undergoing review,
and it's possible some of them might complete review in time to be sent,
if so, they will be separate pull requests

Here's the boilerplate for this pull request:

The following changes since commit e4618d40eb3dc1a6d1f55f7150ea25bb23ab41=
0a:

  IB/rdmavt: Don't vfree a kzalloc'ed memory region (2016-09-16 14:14:23
-0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to 61347fa6087884305ea4a3a04501839fdb68dc76:

  IB/rdmavt: Trivial function comment corrected. (2016-10-03 10:55:27 -04=
00)

----------------------------------------------------------------
First pull request of the 4.9 merge window

- Updates to hfi1 driver

----------------------------------------------------------------
Dean Luick (6):
      IB/hfi1: Move serdes tune inside link start function
      IB/hfi1: Extend i2c timeout
      IB/hfi1: Act on external device timeout
      IB/hfi1: Restore EPROM read ability
      IB/hfi1: Add ability to read platform config from the EPROM
      IB/hfi1: Use EPROM platform configuration read

Dennis Dalessandro (3):
      IB/qib: Remove qpt_mask global
      IB/hfi1: Cleanup tasklet refs in comments
      IB/hfi1: Remove unused variable from devdata

Harish Chegondi (2):
      IB/hfi1: Fix the count of user packets submitted to an SDMA engine
      IB/hfi1: Adjust hardware buffering parameter

Jakub Pawlak (1):
      IB/hfi1: Fix resource release in context allocation

Jianxin Xiong (2):
      IB/hfi1: Increase default settings of max_cqes and max_qps
      IB/hfi1: Update SMA ingress checks for response packets

Mike Marciniszyn (12):
      IB/rdmavt: Add functions to get and release QP references
      IB/rdmavt, IB/qib, IB/hfi1: Use new QP put get routines
      IB/core: Add ib headers for general use
      IB/qib,IB/hfi: Use core common header file
      IB/rdmavt: Correct sparse annotation
      IB/hfi1: Move iowait_init() to priv allocate
      IB/rdmavt: Move reset calldown to reset path
      IB/rdmavt: Add qp init function
      IB/rdmavt, IB/hfi1: Add lockdep asserts for lock debug
      IB/hfi1: Consolidate pio control masks into single definition
      IB/hfi1: Fix defered ack race with qp destroy
      IB/hfi1: Fix trace of atomic ack

Parav Pandit (1):
      IB/rdmavt: Trivial function comment corrected.

Sebastian Sanchez (3):
      IB/hfi1: Remove filtering of Set(PkeyTable) in HFI SMA
      IB/hfi1: Do not read more than a SGE length
      IB/hfi1: Combine shift copy and byte copy for SGE reads

Tadeusz Struk (6):
      IB/hfi1: Fix locking scheme for affinity settings
      IB/hfi1: Add sysfs interface for affinity setup
      IB/hfi1: Add a new VL sysfs attribute for sdma engines
      IB/hfi1: Add irq affinity notification handler
      IB/hfi1: Add new debugfs sdma_cpu_list file
      IB/hfi1: Document new sysfs entries for hfi1 driver

Tymoteusz Kielan (1):
      IB/hfi1: Fix user-space buffers mapping with IOMMU enabled

 Documentation/infiniband/sysfs.txt        |  30 +++
 drivers/infiniband/hw/hfi1/affinity.c     | 203 ++++++++++++----
 drivers/infiniband/hw/hfi1/affinity.h     |   3 +-
 drivers/infiniband/hw/hfi1/chip.c         |  57 +++--
 drivers/infiniband/hw/hfi1/chip.h         |   8 +-
 drivers/infiniband/hw/hfi1/common.h       |   8 -
 drivers/infiniband/hw/hfi1/debugfs.c      |  38 +++
 drivers/infiniband/hw/hfi1/driver.c       |  35 ++-
 drivers/infiniband/hw/hfi1/eprom.c        | 185 +++++++++++++++
 drivers/infiniband/hw/hfi1/eprom.h        |   4 +-
 drivers/infiniband/hw/hfi1/file_ops.c     |  59 +++--
 drivers/infiniband/hw/hfi1/hfi.h          |  22 +-
 drivers/infiniband/hw/hfi1/init.c         |  45 ++--
 drivers/infiniband/hw/hfi1/mad.c          |   7 -
 drivers/infiniband/hw/hfi1/pio.c          |  20 +-
 drivers/infiniband/hw/hfi1/pio.h          |   2 +-
 drivers/infiniband/hw/hfi1/pio_copy.c     | 246 +++++--------------
 drivers/infiniband/hw/hfi1/platform.c     |  32 ++-
 drivers/infiniband/hw/hfi1/qp.c           |  32 +--
 drivers/infiniband/hw/hfi1/qsfp.c         |   2 +-
 drivers/infiniband/hw/hfi1/rc.c           | 146 ++++++------
 drivers/infiniband/hw/hfi1/ruc.c          |  10 +-
 drivers/infiniband/hw/hfi1/sdma.c         | 377
+++++++++++++++++++++++++++++-
 drivers/infiniband/hw/hfi1/sdma.h         |  13 +-
 drivers/infiniband/hw/hfi1/sysfs.c        | 103 +++++++-
 drivers/infiniband/hw/hfi1/trace.c        |  31 +--
 drivers/infiniband/hw/hfi1/trace_ctxts.h  |  13 +-
 drivers/infiniband/hw/hfi1/trace_ibhdrs.h |  14 +-
 drivers/infiniband/hw/hfi1/trace_rx.h     |   4 +-
 drivers/infiniband/hw/hfi1/uc.c           |  15 +-
 drivers/infiniband/hw/hfi1/ud.c           |  61 +++--
 drivers/infiniband/hw/hfi1/user_sdma.c    |  40 ++--
 drivers/infiniband/hw/hfi1/verbs.c        |  60 +++--
 drivers/infiniband/hw/hfi1/verbs.h        |  93 +-------
 drivers/infiniband/hw/hfi1/verbs_txreq.c  |   2 +-
 drivers/infiniband/hw/qib/qib.h           |   2 +-
 drivers/infiniband/hw/qib/qib_driver.c    |   7 +-
 drivers/infiniband/hw/qib/qib_iba7322.c   |   2 +-
 drivers/infiniband/hw/qib/qib_qp.c        |  13 +-
 drivers/infiniband/hw/qib/qib_rc.c        |  73 +++---
 drivers/infiniband/hw/qib/qib_ruc.c       |   4 +-
 drivers/infiniband/hw/qib/qib_uc.c        |   6 +-
 drivers/infiniband/hw/qib/qib_ud.c        |   6 +-
 drivers/infiniband/hw/qib/qib_verbs.c     |  16 +-
 drivers/infiniband/hw/qib/qib_verbs.h     |  94 +-------
 drivers/infiniband/sw/rdmavt/qp.c         | 119 ++++++----
 include/rdma/ib_hdrs.h                    | 178 ++++++++++++++
 include/rdma/rdmavt_qp.h                  |  19 ++
 48 files changed, 1660 insertions(+), 899 deletions(-)
 create mode 100644 include/rdma/ib_hdrs.h


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--59n6s59xWqSjvKnQ0NuooMOSprko151HE--

--IJmeEExPOH9vcDHcPJ0A7SM2fBB31N8fX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX87OjAAoJELgmozMOVy/dMY8QAJcMLO1qWswab/dO99H1Hjym
HpI31z3F9Pfrr3/oYjagKOJxLUyqi9lbk33Fb67j3tpOA19zs2m11rFFnn45ddd6
IHN2SLhb3H7GaFv6bJ7JPeh3/766gIlp/WsNV9rWperrqsEEQiXYISgzA9TueKwU
q866kRXBgeKadlSB6HhKCwRdazmlVcBqhu/ivpyx6vAmR2AHj5Hl/JTuez1dQIzB
SepPLU4B6nryw/O5julmJLc9KzASJABckJrrLdvVi4vrGG8t261TDO8WwqapVfOl
Lkwq5arOf+/MyiUHrtqG+EcrlAG7YaCUh+Vqt1svDxR9MF19gDIGDhrWLCm8xrhi
HBlPhI3+BinU2giEuNCWI2aY5J53ZbrGTROMRELCbwHFZsZGmEPru9ZynabnVbJW
txwLQKI6xovpUGbn0c8hP2mf6xowqBCbnRjrTdnOuKsylfuWEwJdLveNn2VU54ek
HqLnBkoLeBhRxGlIUbCJIzx/ndg/BlAErWDCaDpriqq6FhVAwPVpMWypb9mFGlr2
MFYagy5etgNiOTcooFbc1KNG3i5GlSa9RF8iK733ZP3WFozK2z6CDJzgLbRMPPld
BUPEuoDgnDkQ6rlux4OU6Uu5pytxXANNntj6yUtXqkOBafGZ6LtcAPW8H9z4HBd/
9HeHJIkLICIILqxfsupP
=ZQcq
-----END PGP SIGNATURE-----

--IJmeEExPOH9vcDHcPJ0A7SM2fBB31N8fX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
