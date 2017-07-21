From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Fri, 21 Jul 2017 08:16:04 -0400
Message-ID: <1500639364.23761.22.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

As per my previous pull request, there were two drivers that each had a
rather large number of legitimate fixes still to be sent.  As it turned
out, I also missed a reasonably large set of fixes from one person
across the stack that are all important fixes.  All in all, the
bnxt_re, i40iw, and Dan Carpenter are 3/4 to 2/3rds of this pull
request.  There were some other random fixes that I didn't send in the
last pull request that I added to this one.  This catches the rdma
stack up to the fixes from up to about the beginning of this week.  Any
more fixes I'll wait and batch up later in the -rc cycle.  This will
give us a good base to start with for basing a for-next branch on -rc2.
 Thanks.

Here's the boilerplate:

The following changes since commit
ebc9ca43e1d52a85c72fc2d343f353386ed6c188:

  IB/core: Allow QP state transition from reset to error (2017-07-17
21:21:30 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to
a62ab66b13a0f9bcb17b7b761f6670941ed5cd62:

  RDMA/core: Initialize port_num in qp_attr (2017-07-20 11:24:13 -0400)

----------------------------------------------------------------
Second set of -rc fixes for 4.13 cycle

- i40iw fixes
- bnxt_re fixes
- Dan Carpenter bugfixes across stack
- 10 more random fixes, no more than 2 from any 1 person

----------------------------------------------------------------
Amrani, Ram (1):
      RDMA/qedr: Prevent memory overrun in verbs' user responses

Dan Carpenter (8):
      RDMA/bnxt_re: checking for NULL instead of IS_ERR()
      IB/IPoIB: Fix error code in ipoib_add_port()
      IB/i40iw: Fix error code in i40iw_create_cq()
      cxgb4: Fix error codes in c4iw_create_cq()
      IB/cxgb3: Fix error codes in iwch_alloc_mr()
      RDMA/ocrdma: Fix an error code in ocrdma_alloc_pd()
      RDMA/ocrdma: Fix error codes in ocrdma_create_srq()
      IB/mlx5: Fix a warning message

Devesh Sharma (3):
      RDMA/bnxt_re: Free doorbell page index (DPI) during dealloc
ucontext
      RDMA/bnxt_re: Enable atomics only if host bios supports
      RDMA/bnxt_re: Fix return value of poll routine

Eddie Wai (1):
      RDMA/bnxt_re: Fixed the max_rd_atomic support for initiator and
destination QP

Ganesh Goudar (1):
      iw_cxgb4: don't use WR keys/addrs for 0 byte reads

Henry Orosco (2):
      i40iw: Add missing memory barrier
      i40iw: Update list correctly

Håkon Bugge (1):
      IB/mlx4: Fix CM REQ retries in paravirt mode

Ismail, Mustafa (2):
      RDMA/uverbs: Fix the check for port number
      RDMA/core: Initialize port_num in qp_attr

Kaike Wan (1):
      IB/rdmavt: Setting of QP timeout can overflow jiffies computation

Kalderon, Michal (1):
      IB/cma: Fix reference count leak when no ipv4 addresses are set

Matan Barak (1):
      IB/core: Fix sparse warnings

Mustafa Ismail (2):
      i40iw: Fix order of cleanup in close
      i40iw: Do not poll CCQ after it is destroyed

Sagi Grimberg (1):
      RDMA/iser: don't send an rkey if all data is written as
immadiate-data

Selvin Xavier (4):
      RDMA/bnxt_re: Do not free the ctx_tbl entry if delete GID fails
      RDMA/bnxt_re: Report supported value to IB stack in query_device
      RDMA/bnxt_re: Report MISSED_EVENTS in req_notify_cq
      RDMA/bnxt_re: Fix the value reported for local ack delay

Shiraz Saleem (4):
      i40iw: Utilize iwdev->reset during PCI function reset
      i40iw: Release cm_id ref on PCI function reset
      i40iw: Free QP resources on CQP destroy QP failure
      i40iw: Avoid memory leak of CQP request objects

Somnath Kotur (2):
      RDMA/bnxt_re: Fix WQE Size posted to HW to prevent it from
throwing error
      RDMA/bnxt_re: Specify RDMA component when allocating stats
context

Tatyana Nikolova (1):
      i40iw: Free QP PBLEs when the QP is destroyed

Vijay Immanuel (1):
      rxe: fix broken receive queue draining

 drivers/infiniband/core/cma.c                |   2 +
 drivers/infiniband/core/uverbs_cmd.c         |  13 +--
 drivers/infiniband/hw/bnxt_re/bnxt_re.h      |   9 ++
 drivers/infiniband/hw/bnxt_re/ib_verbs.c     | 119 ++++++++++++++++---
--------
 drivers/infiniband/hw/bnxt_re/ib_verbs.h     |   3 +-
 drivers/infiniband/hw/bnxt_re/main.c         |   1 +
 drivers/infiniband/hw/bnxt_re/qplib_fp.c     |  29 +++++++
 drivers/infiniband/hw/bnxt_re/qplib_fp.h     |   1 +
 drivers/infiniband/hw/bnxt_re/qplib_sp.c     |  16 ++++
 drivers/infiniband/hw/bnxt_re/qplib_sp.h     |   3 +
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |   9 +-
 drivers/infiniband/hw/cxgb4/cq.c             |   1 +
 drivers/infiniband/hw/cxgb4/qp.c             |   2 +-
 drivers/infiniband/hw/i40iw/i40iw.h          |   1 +
 drivers/infiniband/hw/i40iw/i40iw_cm.c       |   5 +-
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c     |   2 +
 drivers/infiniband/hw/i40iw/i40iw_main.c     |  60 +++++++-------
 drivers/infiniband/hw/i40iw/i40iw_puda.c     |   5 +-
 drivers/infiniband/hw/i40iw/i40iw_utils.c    |  60 +++++++++++++-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c    |  19 +++--
 drivers/infiniband/hw/i40iw/i40iw_verbs.h    |   2 +-
 drivers/infiniband/hw/mlx4/cm.c              |   4 +
 drivers/infiniband/hw/mlx5/mr.c              |   2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |   4 +-
 drivers/infiniband/hw/qedr/verbs.c           |  16 +++-
 drivers/infiniband/sw/rdmavt/qp.c            |   4 +-
 drivers/infiniband/sw/rxe/rxe_resp.c         |   3 +
 drivers/infiniband/sw/rxe/rxe_verbs.c        |   3 +
 drivers/infiniband/ulp/ipoib/ipoib_main.c    |   1 +
 drivers/infiniband/ulp/iser/iser_initiator.c |   6 +-
 include/rdma/ib_addr.h                       |   6 +-
 include/rdma/rdmavt_qp.h                     |  14 ++++
 32 files changed, 306 insertions(+), 119 deletions(-)

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
