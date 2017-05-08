From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Mon, 08 May 2017 15:43:07 -0400
Message-ID: <1494272587.3041.256.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

As mentioned in my first pull request, this is the subsequent pull
request(s) I had.  This is all I have, and in fact this cleans out the
RDMA subsystem's entire patchworks queue of kernel changes that are
ready to go (well, it did for the weekend anyway, a few new patches are
in, but they'll be coming during the -rc cycle).

The first is the single patch that would have conflicted if taken from
my tree or DaveM's tree as it needed our trees merged to come cleanly.
 It's been in my tree since last week and has been through 0day, but
not linux-next.  It is using the for-linus tag, here's the boilerplate
for it:

The following changes since commit
4ac4d584886a4f47f8ff3bca0f32ff9a2987d3e5:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2017-
05-04 12:26:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to
693dfd5a3f19efc44acf3a57217c0480e414f8ee:

  IB/mlx5: Enable IPoIB acceleration (2017-05-04 16:22:08 -0400)

----------------------------------------------------------------
Updates #2 for 4.12 kernel merge window

- mlx5/IPoIB fixup patch

----------------------------------------------------------------
Erez Shitrit (1):
      IB/mlx5: Enable IPoIB acceleration

 drivers/infiniband/hw/mlx5/main.c               | 22 +++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/ipoib.c | 44 +++++++++++++++
----------
 drivers/net/ethernet/mellanox/mlx5/core/ipoib.h |  2 ++
 include/linux/mlx5/driver.h                     | 19 +++++++++++
 5 files changed, 70 insertions(+), 19 deletions(-)

The second pull request contains the patch series from Intel plus three
other stragllers that came in late last week.  I took them because it
allowed me to legitimately claim that the RDMA patchworks queue was,
for a short time, 100% cleared of all waiting kernel patches, woohoo!
:-).  I have it under my for-next tag, so it did get 0day and linux-
next over the end of last week, and linux-next did show one minor
conflict.  The Intel series does a patchworks cleanup of some function
declarations, while a different series coming to you via the PCI
subsystem removes in internal function and declaration that is in the
area of the cleanup.  The fixup is simple and obvious.  Here's the
boilerplate on this series:

The following changes since commit
24b43c99647bf9be4995e6a6c9c3a923c147770a:

  infiniband: avoid dereferencing uninitialized dst on error path
(2017-05-02 10:45:45 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-next

for you to fetch changes up to
67cf3623e097706b0ca03bf79bf28d60c39591eb:

  rxe: expose num_possible_cpus() cnum_comp_vectors (2017-05-04
19:33:02 -0400)

----------------------------------------------------------------
Updates #3 for 4.12 kernel merge window

- The hfi1 15 patch set that landed late
- IPoIB get_link_ksettings which landed late because I asked for a
  respin
- One late rxe change
- One -rc worthy fix that's in early

----------------------------------------------------------------
Jakub Byczkowski (1):
      IB/hfi1: Fix checks for Offline transient state

Leon Romanovsky (1):
      IB/rxe: Update caller's CRC for RXE_MEM_TYPE_DMA memory type

Michael J. Ruhl (9):
      IB/hfi1: Return an error on memory allocation failure
      IB/hfi1: Fix a subcontext memory leak
      IB/hfi1: Name function prototype parameters
      IB/hfi1: Use filedata rather than filepointer
      IB/hfi1: Search shared contexts on the opened device, not all
devices
      IB/hfi1: Correctly clear the pkey
      IB/hfi1: Clean up context initialization
      IB/hfi1: Fix an assign/ordering issue with shared context IDs
      IB/hfi1: Clean up on context initialization failure

Mike Marciniszyn (2):
      IB/hfi1, IB/rdmavt: Move r_adefered to r_lock cache line
      IB/hfi1: Fix yield logic in send engine

Sagi Grimberg (1):
      rxe: expose num_possible_cpus() cnum_comp_vectors

Sebastian Sanchez (2):
      IB/hfi1: Get rid of divide when setting the tx request header
      IB/hfi1: Remove atomic operations for SDMA_REQ_HAVE_AHG bit

Tymoteusz Kielan (1):
      IB/hfi1: Adjust default eager_buffer_size to 8MB

Zhu Yanjun (1):
      IB/ipoib: add get_link_ksettings in ethtool

 drivers/infiniband/hw/hfi1/chip.c            |  47 ++-
 drivers/infiniband/hw/hfi1/chip.h            |  10 +-
 drivers/infiniband/hw/hfi1/driver.c          |  42 +--
 drivers/infiniband/hw/hfi1/file_ops.c        | 425 ++++++++++++++-----
--------
 drivers/infiniband/hw/hfi1/hfi.h             | 107 ++++---
 drivers/infiniband/hw/hfi1/init.c            |  33 +--
 drivers/infiniband/hw/hfi1/intr.c            |   3 +-
 drivers/infiniband/hw/hfi1/qp.c              |   4 +-
 drivers/infiniband/hw/hfi1/rc.c              |  13 +-
 drivers/infiniband/hw/hfi1/ruc.c             |  80 +++--
 drivers/infiniband/hw/hfi1/trace_ctxts.h     |  17 +-
 drivers/infiniband/hw/hfi1/trace_tx.h        |  34 +++
 drivers/infiniband/hw/hfi1/user_exp_rcv.c    | 180 ++++++------
 drivers/infiniband/hw/hfi1/user_exp_rcv.h    |  17 +-
 drivers/infiniband/hw/hfi1/user_sdma.c       | 191 ++++++------
 drivers/infiniband/hw/hfi1/user_sdma.h       |  18 +-
 drivers/infiniband/hw/hfi1/verbs.h           |   5 +-
 drivers/infiniband/hw/hfi1/vnic_main.c       |   8 +-
 drivers/infiniband/sw/rxe/rxe_mr.c           |   2 +-
 drivers/infiniband/sw/rxe/rxe_param.h        |   1 -
 drivers/infiniband/sw/rxe/rxe_verbs.c        |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c |  59 ++++
 include/rdma/rdmavt_qp.h                     |   1 +
 include/uapi/linux/ethtool.h                 |   1 +
 24 files changed, 695 insertions(+), 605 deletions(-)

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
