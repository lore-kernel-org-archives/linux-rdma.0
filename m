From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Thu, 17 Nov 2016 07:13:54 -0500
Message-ID: <58466423-c87e-3921-101e-bffab8989fd8@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2h2gbnDbUc1Ig11EiWDIUXQKjTwuPXHdf"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2h2gbnDbUc1Ig11EiWDIUXQKjTwuPXHdf
Content-Type: multipart/mixed; boundary="i3te1l1BmgfkOf9hKEhn5iqCrql1N2Nbu";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <58466423-c87e-3921-101e-bffab8989fd8-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git

--i3te1l1BmgfkOf9hKEhn5iqCrql1N2Nbu
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Due to various issues, I've been away and couldn't send a pull request
for about three weeks.  There were a number of -rc patches that built up
in the meantime (some where there already from the early -rc stages).
Obviously, there were way too many to send now, so I tried to pare the
list down to the more important patches for the -rc cycle.  Most of the
code has had plenty of soak time at the various vendor's testing setups,
so I doubt there will be another -rc pull request this cycle.  I also
tried to limit the patches to those with smaller footprints, so even
though a shortlog is longer than I would like, the actual diffstat is
mostly very small with the exception of just three files that had more
changes, and a couple files with pure removals.  Here's the boilerplate:

The following changes since commit a909d3e636995ba7c349e2ca5dbb528154d4ac=
30:

  Linux 4.9-rc3 (2016-10-29 13:52:02 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to 5c6b2aaf9316fd0983c0c999d920306ddc65bd2d:

  iw_cxgb4: invalidate the mr when posting a read_w_inv wr (2016-11-16
20:10:36 -0500)

----------------------------------------------------------------
First round of -rc fixes

- Misc Intel hfi1 fixes
- Misc Mellanox mlx4, mlx5, and rxe fixes
- A couple cxgb4 fixes

----------------------------------------------------------------
Daniel Jurgens (2):
      IB/mlx5: Use cache line size to select CQE stride
      IB/mlx4: Check gid_index return value

Dasaratharaman Chandramouli (1):
      IB/hfi1: Fix ECN processing in prescan_rxq

Dennis Dalessandro (3):
      IB/rdmavt: rdmavt can handle non aligned page maps
      IB/hfi1: Remove leftover snoop references
      IB/hfi1: Remove incorrect IS_ERR check

Doug Ledford (1):
      Merge branches 'hfi1' and 'mlx' into k.o/for-4.9-rc

Easwar Hariharan (2):
      IB/hfi1: Clean up unused argument
      IB/hfi1: Delete unused lock

Eli Cohen (2):
      IB/mlx5: Fix fatal error dispatching
      IB/mlx5: Fix NULL pointer dereference on debug print

Ira Weiny (1):
      IB/hfi1: Fix rnr_timer addition

Jakub Pawlak (2):
      IB/hfi1: Fix integrity check flags default values
      IB/hfi1: Fix status error code for unsupported packets

Jianxin Xiong (2):
      IB/hfi1: Fix a potential memory leak in hfi1_create_ctxts()
      IB/hfi1: Prevent hardware counter names from being cut off

Krzysztof Blaszkowski (2):
      IB/hfi1: Return ENODEV for unsupported PCI device ids.
      IB/hfi1: Relocate rcvhdrcnt module parameter check.

Leon Romanovsky (1):
      IB/core: Set routable RoCE gid type for ipv4/ipv6 networks

Majd Dibbiny (1):
      IB/mlx5: Fix memory leak in query device

Maor Gottlieb (1):
      IB/mlx5: Validate requested RQT size

Mark Bloch (3):
      IB/cm: Mark stale CM id's whenever the mad agent was unregistered
      IB/core: Add missing check for addr_resolve callback return value
      IB/core: Avoid unsigned int overflow in sg_alloc_table

Matan Barak (1):
      IB/mlx4: Fix create CQ error flow

Moshe Lazer (1):
      IB/mlx5: Resolve soft lock on massive reg MRs

Steve Wise (2):
      iw_cxgb4: set *bad_wr for post_send/post_recv errors
      iw_cxgb4: invalidate the mr when posting a read_w_inv wr

Tadeusz Struk (2):
      IB/hfi1: Remove redundant sysfs irq affinity entry
      IB/hfi1: Fix an Oops on pci device force remove

Tariq Toukan (1):
      IB/uverbs: Fix leak of XRC target QPs

Yonatan Cohen (4):
      IB/rxe: Fix kernel panic in UDP tunnel with GRO and RX checksum
      IB/rxe: Fix handling of erroneous WR
      IB/rxe: Clear queue buffer when modifying QP to reset
      IB/rxe: Update qp state for user query

 drivers/infiniband/core/addr.c         |  11 ++-
 drivers/infiniband/core/cm.c           | 126
++++++++++++++++++++++++++++-----
 drivers/infiniband/core/cma.c          |  21 +++++-
 drivers/infiniband/core/umem.c         |   2 +-
 drivers/infiniband/core/uverbs_main.c  |   7 +-
 drivers/infiniband/hw/cxgb4/cq.c       |  17 +----
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |   2 +-
 drivers/infiniband/hw/cxgb4/mem.c      |  12 ++++
 drivers/infiniband/hw/cxgb4/qp.c       |  20 +++---
 drivers/infiniband/hw/hfi1/affinity.c  |  72 -------------------
 drivers/infiniband/hw/hfi1/affinity.h  |   4 --
 drivers/infiniband/hw/hfi1/chip.c      |  27 +++----
 drivers/infiniband/hw/hfi1/chip.h      |   3 +
 drivers/infiniband/hw/hfi1/driver.c    |  37 +++++++---
 drivers/infiniband/hw/hfi1/file_ops.c  |  19 ++++-
 drivers/infiniband/hw/hfi1/hfi.h       |  89 +++++++++--------------
 drivers/infiniband/hw/hfi1/init.c      | 104 ++++++++++++++++-----------=

 drivers/infiniband/hw/hfi1/pcie.c      |   3 +-
 drivers/infiniband/hw/hfi1/pio.c       |  13 +---
 drivers/infiniband/hw/hfi1/rc.c        |   2 +-
 drivers/infiniband/hw/hfi1/sdma.c      |  19 +----
 drivers/infiniband/hw/hfi1/sysfs.c     |  25 -------
 drivers/infiniband/hw/hfi1/trace_rx.h  |  60 ----------------
 drivers/infiniband/hw/hfi1/user_sdma.c |   2 +-
 drivers/infiniband/hw/mlx4/ah.c        |   5 +-
 drivers/infiniband/hw/mlx4/cq.c        |   5 +-
 drivers/infiniband/hw/mlx5/cq.c        |   3 +-
 drivers/infiniband/hw/mlx5/main.c      |  11 +--
 drivers/infiniband/hw/mlx5/mlx5_ib.h   |   2 +
 drivers/infiniband/hw/mlx5/mr.c        |   6 +-
 drivers/infiniband/hw/mlx5/qp.c        |  12 +++-
 drivers/infiniband/sw/rdmavt/dma.c     |   3 -
 drivers/infiniband/sw/rxe/rxe_net.c    |   8 +--
 drivers/infiniband/sw/rxe/rxe_qp.c     |   2 +
 drivers/infiniband/sw/rxe/rxe_queue.c  |   9 +++
 drivers/infiniband/sw/rxe/rxe_queue.h  |   2 +
 drivers/infiniband/sw/rxe/rxe_req.c    |  21 +++---
 37 files changed, 391 insertions(+), 395 deletions(-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--i3te1l1BmgfkOf9hKEhn5iqCrql1N2Nbu--

--2h2gbnDbUc1Ig11EiWDIUXQKjTwuPXHdf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYLZ8CAAoJELgmozMOVy/djpYP/RJq2wHPYkrUn521mctTmlOs
cep9wtjznPP/XUDgtFKhlEhzxg/CukWV33qoeh+Jv9BmlCfU9m6IbkSZnT1sNAdw
FNd1hq1NdJQ9QFfiU0tCcqmWJvGI3a6+w3E/hqeaDuhOIyA9cpHNuEIlSe6Jm+Lt
DENS5MpVk050a89/AN/9oU4nEYtNlvtH8nGIrKimA7lktl1UiLcooFkEVabYbcnI
XMU+EjrcvalbPFL9YlNW03ID/KXXBq2/sBEM5B/qIK7BhYW5y77tGHuGy6Wd+0c1
Sj6h0GmT+sXeVPYxXXocjYDWsy4syxeCWwGGZGUDvdNbXWIMb+iQzhW+fBYiicQQ
BwTdXE9qgW82MhHGvln/duB7jeylc3K4VqhMB6Pkey9+rx/ziH1o8/0iTsQxLWwU
RpeV9V13UGA34eRx9HxvT1BArGVspTycj2mOyArkz6bfeEjIyJFfe1AArpsR2CZe
LP4SyeSLM7nD27SPGWWSE+4l+Eosg4+NBslwBXiBHwYJAPs0x6fFGJU3dHyeklTo
NyAFViQiq5efPylpkQ6VUod+uHs8dBGjLwc8sEgofq/A3vnGfpPWtK8NQuEbAEtR
IHfraYEAV+zvUPA3GRq0LEtzTJ6D3+xfkbgU2z2Dk3dRn/CI0f9fBVtn7c4Falue
CE/esZXeB5ltzILD6fVQ
=S+hS
-----END PGP SIGNATURE-----

--2h2gbnDbUc1Ig11EiWDIUXQKjTwuPXHdf--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
