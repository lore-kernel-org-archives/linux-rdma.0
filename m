From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Thu, 26 May 2016 18:34:28 -0400
Message-ID: <166c87fa-09ef-f170-7351-d18062bc25cf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="v8TWaEOSinpKsMx39K3OjfSUJ7afWIdSv"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--v8TWaEOSinpKsMx39K3OjfSUJ7afWIdSv
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This is the second group of code for the 4.7 merge window.  It looks
large, but only in one sense.  I'll get to that in a minute.  The list
of changes here breaks down as follows:

Round two of 4.7 merge window patches

- Dynamic counter infrastructure in the IB drivers  <- 1 patch
  This is a sysfs based code to allow free form access to the hardware
  counters RDMA devices might support so drivers don't need to code
  this up repeatedly themselves
- SendOnlyFullMember multicast support              <- 4 patches
- IB router support                                 <- 4 patches
- A couple misc fixes                               <- 4 or so here
- The big item on the list: hfi1 driver updates, plus moving the hfi1
  driver out of staging                             <- everything else

There was a group of 15 patches in the hfi1 list that I thought I had in
the first pull request but they weren't.  So that added to the length of
the hfi1 section here.

As far as these go, everything but the hfi1 is pretty straight forward.
The hfi1 is, if you recall, the driver that Al had complaints about how
it used the write/writev interfaces in an overloaded fashion.  The write
portion of their interface behaved like the write handler in the IB
stack proper and did bi-directional communications.  The writev
interface, on the other hand, only accepts SDMA request structures.  The
completions for those structures are sent back via an entirely different
event mechanism.  With the security patch, we put security checks on the
write interface, however, we also knew they would be going away soon.
Now, we've converted the write handler in the hfi1 driver to use ioctls
from the IB reserved magic area for its bidirectional communications.
With that change, Intel has addressed
all of the items originally on their TODO when they went into staging
(as well as many items added to the list later).  As such, I moved them
out, and since they were the last item in the staging/rdma directory,
and I don't have immediate plans to use the staging area again, I
removed the staging/rdma area.  Because of the move out of staging, as
well as a series of 5 patches in the hfi1 driver that removed code
people thought should be done in a different way and was optional to
begin with (a snoop debug interface, an eeprom driver for an eeprom
connected directory to their hfi1 chip and not via an i2c bus, and a few
other things like that), the line count, especially the removal count,
is high.

I know we have a long weekend coming up, so I wanted to get this out
before Friday so you had plenty of time to digest and look it over.  Let
me know if you see anything amiss.

Now the boilerplate:

The following changes since commit c16d2750a08c8ccaf98d65f287a8aec91bb961=
0d:

  IB/mlx5: Fire the CQ completion handler from tasklet (2016-05-18
10:45:49 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to 7a226f9c32b0481b0744e2726cd7f8349b866af5:

  staging/rdma: Remove the entire rdma subdirectory of staging
(2016-05-26 12:59:34 -0400)

----------------------------------------------------------------
Round two of 4.7 merge window patches

- Dynamic counter infrastructure in the IB drivers
  This is a sysfs based code to allow free form access to the hardware
  counters RDMA devices might support so drivers don't need to code
  this up repeatedly themselves
- SendOnlyFullMember multicast support
- IB router support
- A couple misc fixes
- The big item on the list: hfi1 driver updates, plus moving the hfi1
  driver out of staging

----------------------------------------------------------------
Ashutosh Dixit (1):
      IB/hfi1: Change hfi1_init loop to preserve error returns

Christoph Lameter (1):
      IB/core: Make device counter infrastructure dynamic

Dean Luick (3):
      IB/hfi1: Remove no-op QSFP reset code
      IB/hfi1: Immediately apply congestion setting MAD
      IB/hfi1: Correct 8051 link parameter settings

Dennis Dalessandro (11):
      IB/hfi1: Remove anti-pattern in cdev init
      IB/hfi1: Remove multiple device cdev
      IB/hfi1: Remove UI char device
      IB/hfi1: Remove EPROM functionality from data device
      IB/hfi1: Remove snoop/diag interface
      IB/hfi1: Remove unused user command
      IB/hfi1: Add ioctl() interface for user commands
      IB/hfi1: Remove write(), use ioctl() for user cmds
      IB/hfi1: Add trace message in user IOCTL handling
      IB/hfi1: Do not free hfi1 cdev parent structure early
      IB/hfi1: Move driver out of staging

Doug Ledford (3):
      Merge branches 'misc-4.7-2', 'ipoib' and 'ib-router' into k.o/for-4=
=2E7
      Merge branch 'hfi1-2' into k.o/for-4.7
      staging/rdma: Remove the entire rdma subdirectory of staging

Easwar Hariharan (3):
      IB/hfi1: Ignore non-temperature warnings on a downed link
      IB/hfi1: Wait for QSFP modules to initialize
      IB/hfi1: Correct external device configuration shift

Erez Shitrit (4):
      IB/core: Introduce capabilitymask2 field in ClassPortInfo mad
      IB/SA Agent: Add support for SA agent get ClassPortInfo
      IB/core: Support new type of join-state for multicast
      IB/ipoib: Support SendOnlyFullMember MCG for SendOnly join

Honggang Li (1):
      RDMA/cxgb3: device driver frees DMA memory with different size

Ira Weiny (1):
      IB/hfi1: Remove unnecessary comment

Jakub Pawlak (1):
      IB/hfi1: Correct log message strings

Jianxin Xiong (5):
      IB/hfi1: Keep SC_USER as the last send context type
      ib_pack.h: Add opcode definition for send with invalidate
      IB/hfi1: Fix bug that blocks process on exit after port bounce
      IB/hfi1, qib: Add ieth to the packet header definitions
      IB/hfi1: Add tracing support for send with invalidate opcode

Jubin John (6):
      IB/hfi1: Remove unnecessary header
      IB/hfi1: Fix hfi_rcvhdr tracepoint
      IB/rdmavt: Use kzalloc_node
      IB/hfi1: Fix sdma_event_names[] build warning
      IB/qib: Remove unused qib_7322_intr_msgs[]
      IB/hfi1: Fix pio map initialization

Leon Romanovsky (1):
      IB/core: Integrate IB address resolution module into core

Mark Bloch (6):
      IB/MAD: Integrate ib_mad module into ib_core module
      IB/SA: Integrate ib_sa module into ib_core module
      IB/netlink: Add a new local service operation
      IB/core: Register SA ibnl client during ib_core initialization
      IB/core: Add IP to GID netlink offload
      IB/IPoIB: Allow setting the device address

Mike Marciniszyn (7):
      IB/hfi1: Fix pio wait counter double increment
      IB/hfi1: Fix potential panic with sdma drained mechanism
      IB/rdmavt: Increase CQ callback thread priority
      IB/rdmavt: Insure QP vmalloc variants zero memory
      IB/hfi1: Fix hard lockup due to not using save/restore spin lock
      IB/rdmavt: Max atomic value should be a u8
      IB/rdamvt: Fix rdmavt s_ack_queue sizing

Mitko Haralanov (2):
      IB/hfi1: Improve performance of interval RB trees
      IB/hfi1: Fix an interval RB node reference count leak

Muhammad Falak R Wani (1):
      staging/rdma/hfi1: use RCU_INIT_POINTER() when NULLing.

Sebastian Sanchez (1):
      IB/hfi1: Update pkey table properly after link down or FM start

 Documentation/infiniband/sysfs.txt                 |   12 +
 MAINTAINERS                                        |   14 +-
 drivers/infiniband/Kconfig                         |    2 +
 drivers/infiniband/core/Makefile                   |   12 +-
 drivers/infiniband/core/addr.c                     |  226 ++-
 drivers/infiniband/core/core_priv.h                |   16 +
 drivers/infiniband/core/device.c                   |   58 +
 drivers/infiniband/core/mad.c                      |   13 +-
 drivers/infiniband/core/multicast.c                |   23 +-
 drivers/infiniband/core/sa_query.c                 |  211 ++-
 drivers/infiniband/core/sysfs.c                    |  366 ++--
 drivers/infiniband/hw/Makefile                     |    1 +
 drivers/infiniband/hw/cxgb3/cxio_hal.c             |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c        |  147 +-
 drivers/infiniband/hw/cxgb4/provider.c             |   58 +-
 .../{staging/rdma =3D> infiniband/hw}/hfi1/Kconfig   |    0
 .../{staging/rdma =3D> infiniband/hw}/hfi1/Makefile  |    2 +-
 .../rdma =3D> infiniband/hw}/hfi1/affinity.c         |    0
 .../rdma =3D> infiniband/hw}/hfi1/affinity.h         |    0
 .../{staging/rdma =3D> infiniband/hw}/hfi1/aspm.h    |    0
 .../{staging/rdma =3D> infiniband/hw}/hfi1/chip.c    |   41 +-
 .../{staging/rdma =3D> infiniband/hw}/hfi1/chip.h    |    6 +
 .../rdma =3D> infiniband/hw}/hfi1/chip_registers.h   |    0
 .../{staging/rdma =3D> infiniband/hw}/hfi1/common.h  |    5 +-
 .../{staging/rdma =3D> infiniband/hw}/hfi1/debugfs.c |    0
 .../{staging/rdma =3D> infiniband/hw}/hfi1/debugfs.h |    0
 .../{staging/rdma =3D> infiniband/hw}/hfi1/device.c  |   18 +-
 .../{staging/rdma =3D> infiniband/hw}/hfi1/device.h  |    3 +-
 drivers/{staging/rdma =3D> infiniband/hw}/hfi1/dma.c |    0
 .../{staging/rdma =3D> infiniband/hw}/hfi1/driver.c  |    2 +-
 .../{staging/rdma =3D> infiniband/hw}/hfi1/efivar.c  |    0
 .../{staging/rdma =3D> infiniband/hw}/hfi1/efivar.h  |    0
 drivers/infiniband/hw/hfi1/eprom.c                 |  102 ++
 .../{staging/rdma =3D> infiniband/hw}/hfi1/eprom.h   |    0
 .../rdma =3D> infiniband/hw}/hfi1/file_ops.c         |  549 ++----
 .../rdma =3D> infiniband/hw}/hfi1/firmware.c         |    0
 drivers/{staging/rdma =3D> infiniband/hw}/hfi1/hfi.h |    7 +-
 .../{staging/rdma =3D> infiniband/hw}/hfi1/init.c    |   22 +-
 .../{staging/rdma =3D> infiniband/hw}/hfi1/intr.c    |    0
 .../{staging/rdma =3D> infiniband/hw}/hfi1/iowait.h  |    0
 drivers/{staging/rdma =3D> infiniband/hw}/hfi1/mad.c |   99 +-
 drivers/{staging/rdma =3D> infiniband/hw}/hfi1/mad.h |    0
 .../{staging/rdma =3D> infiniband/hw}/hfi1/mmu_rb.c  |   22 +-
 .../{staging/rdma =3D> infiniband/hw}/hfi1/mmu_rb.h  |    0
 .../rdma =3D> infiniband/hw}/hfi1/opa_compat.h       |    0
 .../{staging/rdma =3D> infiniband/hw}/hfi1/pcie.c    |    0
 drivers/{staging/rdma =3D> infiniband/hw}/hfi1/pio.c |    3 +-
 drivers/{staging/rdma =3D> infiniband/hw}/hfi1/pio.h |    8 +-
 .../rdma =3D> infiniband/hw}/hfi1/pio_copy.c         |    0
 .../rdma =3D> infiniband/hw}/hfi1/platform.c         |   27 +-
 .../rdma =3D> infiniband/hw}/hfi1/platform.h         |    1 +
 drivers/{staging/rdma =3D> infiniband/hw}/hfi1/qp.c  |    9 +-
 drivers/{staging/rdma =3D> infiniband/hw}/hfi1/qp.h  |    0
 .../{staging/rdma =3D> infiniband/hw}/hfi1/qsfp.c    |    0
 .../{staging/rdma =3D> infiniband/hw}/hfi1/qsfp.h    |    0
 drivers/{staging/rdma =3D> infiniband/hw}/hfi1/rc.c  |    0
 drivers/{staging/rdma =3D> infiniband/hw}/hfi1/ruc.c |    0
 .../{staging/rdma =3D> infiniband/hw}/hfi1/sdma.c    |    4 +-
 .../{staging/rdma =3D> infiniband/hw}/hfi1/sdma.h    |    0
 .../rdma =3D> infiniband/hw}/hfi1/sdma_txreq.h       |    0
 .../{staging/rdma =3D> infiniband/hw}/hfi1/sysfs.c   |    4 +-
 .../{staging/rdma =3D> infiniband/hw}/hfi1/trace.c   |    8 +
 .../{staging/rdma =3D> infiniband/hw}/hfi1/trace.h   |    5 +-
 .../{staging/rdma =3D> infiniband/hw}/hfi1/twsi.c    |    0
 .../{staging/rdma =3D> infiniband/hw}/hfi1/twsi.h    |    0
 drivers/{staging/rdma =3D> infiniband/hw}/hfi1/uc.c  |    0
 drivers/{staging/rdma =3D> infiniband/hw}/hfi1/ud.c  |    0
 .../rdma =3D> infiniband/hw}/hfi1/user_exp_rcv.c     |    0
 .../rdma =3D> infiniband/hw}/hfi1/user_exp_rcv.h     |    0
 .../rdma =3D> infiniband/hw}/hfi1/user_pages.c       |    0
 .../rdma =3D> infiniband/hw}/hfi1/user_sdma.c        |   18 +-
 .../rdma =3D> infiniband/hw}/hfi1/user_sdma.h        |    0
 .../{staging/rdma =3D> infiniband/hw}/hfi1/verbs.c   |    4 +-
 .../{staging/rdma =3D> infiniband/hw}/hfi1/verbs.h   |    1 +
 .../rdma =3D> infiniband/hw}/hfi1/verbs_txreq.c      |    0
 .../rdma =3D> infiniband/hw}/hfi1/verbs_txreq.h      |    0
 drivers/infiniband/hw/i40iw/i40iw_verbs.c          |  145 +-
 drivers/infiniband/hw/qib/qib_iba7322.c            |   15 -
 drivers/infiniband/hw/qib/qib_mad.c                |    6 +-
 drivers/infiniband/hw/qib/qib_verbs.h              |    1 +
 drivers/infiniband/sw/rdmavt/cq.c                  |    1 +
 drivers/infiniband/sw/rdmavt/mr.c                  |    4 +-
 drivers/infiniband/sw/rdmavt/qp.c                  |   30 +-
 drivers/infiniband/ulp/ipoib/ipoib.h               |    4 +
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |  109 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |  140 ++
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c     |   48 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c         |    3 +
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c          |    2 +
 drivers/infiniband/ulp/srpt/ib_srpt.c              |    2 +-
 drivers/staging/Kconfig                            |    2 -
 drivers/staging/Makefile                           |    1 -
 drivers/staging/rdma/Kconfig                       |   27 -
 drivers/staging/rdma/Makefile                      |    2 -
 drivers/staging/rdma/hfi1/TODO                     |    6 -
 drivers/staging/rdma/hfi1/diag.c                   | 1925
--------------------
 drivers/staging/rdma/hfi1/eprom.c                  |  471 -----
 include/rdma/ib_mad.h                              |   60 +-
 include/rdma/ib_pack.h                             |    5 +
 include/rdma/ib_sa.h                               |   12 +
 include/rdma/ib_verbs.h                            |  126 +-
 include/rdma/rdma_vt.h                             |   13 +-
 include/rdma/rdmavt_qp.h                           |    5 +-
 include/uapi/rdma/hfi/hfi1_user.h                  |   80 +-
 include/uapi/rdma/rdma_netlink.h                   |   10 +
 105 files changed, 1986 insertions(+), 3400 deletions(-)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/Kconfig (100%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/Makefile (88%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/affinity.c (100%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/affinity.h (100%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/aspm.h (100%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/chip.c (99%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/chip.h (99%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/chip_registers.h (=
100%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/common.h (98%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/debugfs.c (100%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/debugfs.h (100%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/device.c (94%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/device.h (97%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/dma.c (100%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/driver.c (99%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/efivar.c (100%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/efivar.h (100%)
 create mode 100644 drivers/infiniband/hw/hfi1/eprom.c
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/eprom.h (100%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/file_ops.c (78%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/firmware.c (100%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/hfi.h (99%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/init.c (99%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/intr.c (100%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/iowait.h (100%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/mad.c (99%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/mad.h (100%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/mmu_rb.c (95%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/mmu_rb.h (100%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/opa_compat.h (100%=
)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/pcie.c (100%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/pio.c (99%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/pio.h (98%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/pio_copy.c (100%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/platform.c (98%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/platform.h (99%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/qp.c (99%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/qp.h (100%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/qsfp.c (100%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/qsfp.h (100%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/rc.c (100%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/ruc.c (100%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/sdma.c (99%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/sdma.h (100%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/sdma_txreq.h (100%=
)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/sysfs.c (99%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/trace.c (97%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/trace.h (99%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/twsi.c (100%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/twsi.h (100%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/uc.c (100%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/ud.c (100%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/user_exp_rcv.c (10=
0%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/user_exp_rcv.h (10=
0%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/user_pages.c (100%=
)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/user_sdma.c (99%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/user_sdma.h (100%)=

 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/verbs.c (99%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/verbs.h (99%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/verbs_txreq.c (100=
%)
 rename drivers/{staging/rdma =3D> infiniband/hw}/hfi1/verbs_txreq.h (100=
%)
 delete mode 100644 drivers/staging/rdma/Kconfig
 delete mode 100644 drivers/staging/rdma/Makefile
 delete mode 100644 drivers/staging/rdma/hfi1/TODO
 delete mode 100644 drivers/staging/rdma/hfi1/diag.c
 delete mode 100644 drivers/staging/rdma/hfi1/eprom.c


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--v8TWaEOSinpKsMx39K3OjfSUJ7afWIdSv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXR3n0AAoJELgmozMOVy/dKOgP/1vpfyTyeHXMtl5xe39pmWHX
sKg2P2EJ3AvkcA1ffNnmqwZGxTlzpBqcYnFAgkPoAXVaPCqrQ0d/ZyHkZYLzjShp
1onIOpvu6fHqJgJnELcp0ln259jp0ZrL9h74UzHFS2X18GfhKdVekoKd/cqBAYLN
hGVCP3WDPTPUFSQaR9KrjDGMTMY60d8JqDgbvvpEr8SVxf35DCLNEnrLcjqJRdMW
zR2gMTP5g+K38Bi1Qcj6V+ndPmNevB9KzmGRAERttEM9gXuW0p59oqgpkZfwRfPj
lEG/DwH9LKKjwt7Zyr8Z307bFuCAonOVCNEcbBmrNmCcZbmJ6COU38sLlcsDetB+
fDPIX1SFcexGGP09CBpHRkwl+WOGk44Ay1wC21AIbAPUizEPx81bAzyQvNTYNCsW
80g1nrnyAOq8Bw3kKfkHnv7HF7UZyi4YftRLX5H+qJofTIcSfrmI9H9XNd0wLuPu
J31XVldU/SPVvsjTfht7gFpTaW8FicAPP0LD3iL2eEdIUblGbQdLPnAh/uatJyS4
S5Bldjx5j9tAXDvcshg2zH3e+U/rLmIUKRTDId8lB4FI4QqRNhtE8KqBtrqiUlS7
uMtF7vh4zEKKCJXNLhukj4pwlcxTi3hq8NlHvXNI80m3DZmjtYwGueQK8uDCTOGh
UAxm551K1dRSGa5vLuxy
=VSYW
-----END PGP SIGNATURE-----

--v8TWaEOSinpKsMx39K3OjfSUJ7afWIdSv--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
