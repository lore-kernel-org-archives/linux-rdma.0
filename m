From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 00/45] Address issues detected by static analysis tools
Date: Wed, 11 Oct 2017 10:48:42 -0700
Message-ID: <20171011174927.25113-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Doug,

As we all know there are several static analysis tools available for the Linux
kernel and these tools are valuable. I'm referring to increasing the gcc
warning level (W=1), sparse and smatch. It is helpful to analyze new code with
these tools before submitting a patch. These tools are most useful if existing
code is clean. Hence this patch series that significantly reduces the number
of complaints reported by static analysis tools. Please consider this patch
series for kernel v4.15.

Thanks,

Bart.

Changes compared to v1:
- Replaced the patch that modified a qib macro by a patch that removes that
  macro and the code that uses it.
- Removed the c4iw_debug kernel module parameter instead of declaring the
  c4iw_debug variable static.
- Left out the uverbs patch since it is still under discussion.
- Left out a patch for include/rdma/opa_addr.h because an alternative patch
  went into Doug's tree very recently.
- Added Reviewed-by tags for the patches that got a positive review.

Bart Van Assche (45):
  IB/core: Fix endianness annotation in rdma_is_multicast_addr()
  IB/cm: Suppress gcc 7 fall-through complaints
  RDMA/cma: Avoid triggering undefined behavior
  RDMA/iwcm: Remove a set-but-not-used variable
  RDMA/isert: Suppress gcc 7 fall-through complaints
  RDMA/bnxt_re: Suppress gcc 7 fall-through complaints
  RDMA/bnxt_re: Remove set-but-not-used variables
  RDMA/cxgb3: Annotate locking assumptions
  RDMA/cxgb3: Annotate an RCU pointer
  RDMA/cxgb3: Remove a set-but-not-used variable
  RDMA/cxgb4: Fix indentation
  RDMA/cxgb4: Remove the obsolete kernel module option 'c4iw_debug'
  RDMA/cxgb4: Suppress gcc 7 fall-through complaints
  RDMA/cxgb4: Remove a set-but-not-used variable
  IB/hfi1: Suppress gcc 7 fall-through complaints
  IB/hfi1: Remove set-but-not-used variables
  IB/hfi1: Define hfi1_handle_cnp_tbl[] once
  IB/hns: Annotate iomem pointers correctly
  IB/hns: Declare local functions 'static'
  RDMA/i40iw: Fix a race condition
  RDMA/i40iw: Suppress gcc 7 fall-through complaints
  RDMA/i40iw: Remove a set-but-not-used variable
  IB/mthca: Fix indentation
  IB/mlx4: Suppress gcc 7 fall-through complaints
  IB/mlx5: Suppress gcc 7 fall-through complaints
  IB/mlx5: Remove a set-but-not-used variable
  IB/nes: Fix indentation
  IB/nes: Suppress gcc 7 fall-through complaints
  IB/nes: Remove set-but-not-used variables
  IB/nes: Fix a race condition in nes_inetaddr_event()
  RDMA/ocrdma: Use NULL instead of 0 to represent a pointer
  RDMA/ocrdma: Suppress gcc 7 fall-through complaints
  RDMA/ocrdma: Remove set-but-not-used variables
  RDMA/qedr: Use NULL instead of 0 to represent a pointer
  RDMA/qedr: Declare local functions static
  RDMA/qedr: Annotate iomem pointers correctly
  RDMA/qedr: Remove set-but-not-used variables
  IB/qib: Remove remaining code related to writing the EEPROM
  IB/qib: Suppress gcc 7 fall-through complaints
  IB/qib: Remove set-but-not-used variables
  RDMA/rdmavt: Suppress gcc 7 fall-through complaints
  RDMA/rxe: Suppress gcc 7 fall-through complaints
  RDMA/usnic: Make the compiler check declaration consistency during
    compilation
  RDMA/usnic: Remove a set-but-not-used variable
  RDMA/usnic: Instantiate data structures once

 drivers/infiniband/core/cm.c                  |  1 +
 drivers/infiniband/core/cma.c                 | 11 ++--
 drivers/infiniband/core/iwcm.c                |  3 --
 drivers/infiniband/hw/bnxt_re/ib_verbs.c      | 12 ++---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c      |  7 +--
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c    |  4 --
 drivers/infiniband/hw/bnxt_re/qplib_sp.c      |  5 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c         |  6 +--
 drivers/infiniband/hw/cxgb3/iwch_qp.c         |  3 ++
 drivers/infiniband/hw/cxgb4/cm.c              | 16 ++----
 drivers/infiniband/hw/cxgb4/device.c          |  4 +-
 drivers/infiniband/hw/hfi1/driver.c           |  6 +++
 drivers/infiniband/hw/hfi1/file_ops.c         |  4 +-
 drivers/infiniband/hw/hfi1/hfi.h              |  5 --
 drivers/infiniband/hw/hfi1/mad.c              |  3 +-
 drivers/infiniband/hw/hfi1/rc.c               |  2 +-
 drivers/infiniband/hw/hfi1/ruc.c              |  9 ----
 drivers/infiniband/hw/hfi1/sdma.c             |  5 +-
 drivers/infiniband/hw/hfi1/ud.c               |  2 -
 drivers/infiniband/hw/hfi1/verbs.c            | 10 ----
 drivers/infiniband/hw/hns/hns_roce_eq.c       |  6 +--
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c    | 73 +++++++++++++++------------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c    |  3 +-
 drivers/infiniband/hw/i40iw/i40iw_cm.c        |  3 +-
 drivers/infiniband/hw/i40iw/i40iw_hw.c        |  1 +
 drivers/infiniband/hw/i40iw/i40iw_puda.c      |  1 +
 drivers/infiniband/hw/i40iw/i40iw_utils.c     | 13 +++--
 drivers/infiniband/hw/mlx4/cq.c               |  2 +
 drivers/infiniband/hw/mlx4/mcg.c              |  1 +
 drivers/infiniband/hw/mlx5/cq.c               |  2 +
 drivers/infiniband/hw/mlx5/qp.c               |  3 +-
 drivers/infiniband/hw/mthca/mthca_main.c      | 10 ++--
 drivers/infiniband/hw/nes/nes.c               | 33 +++++++-----
 drivers/infiniband/hw/nes/nes_cm.c            |  9 +---
 drivers/infiniband/hw/nes/nes_hw.c            |  7 +--
 drivers/infiniband/hw/nes/nes_nic.c           |  9 ++--
 drivers/infiniband/hw/nes/nes_utils.c         | 13 +++--
 drivers/infiniband/hw/nes/nes_verbs.c         | 12 ++---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c      |  6 +--
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c   |  4 +-
 drivers/infiniband/hw/qedr/main.c             | 24 ++++-----
 drivers/infiniband/hw/qedr/qedr_iw_cm.c       | 14 ++---
 drivers/infiniband/hw/qedr/qedr_roce_cm.c     | 29 +++++------
 drivers/infiniband/hw/qedr/verbs.c            |  9 +---
 drivers/infiniband/hw/qib/qib.h               | 18 -------
 drivers/infiniband/hw/qib/qib_diag.c          |  6 ---
 drivers/infiniband/hw/qib/qib_file_ops.c      |  9 ----
 drivers/infiniband/hw/qib/qib_iba6120.c       | 27 ----------
 drivers/infiniband/hw/qib/qib_iba7220.c       | 23 ---------
 drivers/infiniband/hw/qib/qib_iba7322.c       | 21 ++------
 drivers/infiniband/hw/qib/qib_mad.c           |  4 +-
 drivers/infiniband/hw/qib/qib_pcie.c          |  3 +-
 drivers/infiniband/hw/qib/qib_rc.c            |  2 +-
 drivers/infiniband/hw/qib/qib_sd7220.c        |  2 -
 drivers/infiniband/hw/qib/qib_sdma.c          |  2 +-
 drivers/infiniband/hw/qib/qib_tx.c            |  4 --
 drivers/infiniband/hw/qib/qib_verbs.c         |  3 +-
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c |  2 -
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h | 25 +--------
 drivers/infiniband/hw/usnic/usnic_ib_sysfs.c  |  1 +
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c  | 25 +++++++++
 drivers/infiniband/sw/rdmavt/qp.c             |  1 +
 drivers/infiniband/sw/rxe/rxe_comp.c          |  4 +-
 drivers/infiniband/sw/rxe/rxe_task.c          |  2 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c         |  1 +
 drivers/infiniband/ulp/isert/ib_isert.c       | 14 ++---
 drivers/net/ethernet/chelsio/cxgb3/t3cdev.h   |  2 +-
 include/rdma/ib_addr.h                        |  4 +-
 68 files changed, 241 insertions(+), 369 deletions(-)

-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
