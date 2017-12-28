From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Date: Thu, 28 Dec 2017 14:03:40 -0700
Message-ID: <20171228210340.GA13723@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

This is the next batch of for-rc patches from RDMA. It includes the
fix for the ipoib regression I mentioned last time, and the result of
a fairly major debugging effort to get iser working reliably on cxgb4
hardware - it turns out the cxgb4 driver was not handling QP error
flushing properly causing iser to fail.

I was on the fence for the LAG counters bug fix at rc6. In the end
this appears to be a user space API issue, as data exposed to user
space is not correct under certain device configurations. I also
expect this patch will go to -stable.

The following changes since commit 9d98e19ba08f6aa33a4a1414f3dfe8440e67530c:

  IB/ipoib: Restore MM behavior in case of tx_ring allocation failure (2017-12-13 10:31:57 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to 45e6ae7ef21b907dacb18da62d5787d74a31d860:

  IB/mlx5: Fix mlx5_ib_alloc_mr error flow (2017-12-27 15:24:41 -0700)

----------------------------------------------------------------
Third pull request for 4.15-rc

- cxgb4 fix for an iser testing failure as debugged by Steve and Sagi.
  The problem was a driver bug in the handling of shutting down a QP.
- Various vmw_pvrdma fixes for bogus WARN_ON, missed resource free on error
  unwind and a use after free bug
- Improper congestion counter values on mlx5 when link aggregation is enabled
- ipoib lockdep regression introduced in this merge window
- hfi1 regression supporting the device in a VM introduced in a recent patch
- Typo that breaks future uAPI compatibility in the verbs core
- More SELinux related oops fixing
- Fix an oops during error unwind in mlx5

----------------------------------------------------------------
Alex Vesker (1):
      IB/ipoib: Fix lockdep issue found on ipoib_ib_dev_heavy_flush

Bryan Tan (3):
      RDMA/vmw_pvrdma: Call ib_umem_release on destroy QP path
      RDMA/vmw_pvrdma: Use refcount_dec_and_test to avoid warning
      RDMA/vmw_pvrdma: Avoid use after free due to QP/CQ/SRQ destroy

Majd Dibbiny (2):
      IB/mlx5: Fix congestion counters in LAG mode
      IB/mlx5: Serialize access to the VMA list

Michael J. Ruhl (1):
      IB/hfi: Only read capability registers if the capability exists

Moni Shoua (2):
      IB/uverbs: Fix command checking as part of ib_uverbs_ex_modify_qp()
      IB/core: Verify that QP is security enabled in create and destroy

Nitzan Carmi (1):
      IB/mlx5: Fix mlx5_ib_alloc_mr error flow

Steve Wise (3):
      iw_cxgb4: Only validate the MSN for successful completions
      iw_cxgb4: reflect the original WR opcode in drain cqes
      iw_cxgb4: when flushing, complete all wrs in a chain

 drivers/infiniband/core/security.c             |  3 ++
 drivers/infiniband/core/uverbs_cmd.c           |  4 +-
 drivers/infiniband/core/verbs.c                |  3 +-
 drivers/infiniband/hw/cxgb4/cq.c               | 13 ++---
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h         |  2 -
 drivers/infiniband/hw/cxgb4/qp.c               | 72 ++++++++++++++++++++++++--
 drivers/infiniband/hw/cxgb4/t4.h               |  6 +++
 drivers/infiniband/hw/hfi1/hfi.h               |  1 -
 drivers/infiniband/hw/hfi1/pcie.c              | 30 +++++------
 drivers/infiniband/hw/mlx5/cmd.c               | 11 ----
 drivers/infiniband/hw/mlx5/cmd.h               |  2 -
 drivers/infiniband/hw/mlx5/main.c              | 43 +++++----------
 drivers/infiniband/hw/mlx5/mlx5_ib.h           |  4 ++
 drivers/infiniband/hw/mlx5/mr.c                |  1 +
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h      |  6 +--
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c   |  7 +--
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c | 17 +++---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c   | 14 +++--
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c  |  7 +--
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |  7 ++-
 drivers/net/ethernet/mellanox/mlx5/core/lag.c  | 56 ++++++++++++++++++++
 include/linux/mlx5/driver.h                    |  4 ++
 22 files changed, 208 insertions(+), 105 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
