From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Fri, 18 Apr 2014 11:40:32 -0700
Message-ID: <1397846432-20495-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

InfiniBand/RDMA updates for 3.15-rc2:

 - Mostly cxgb4 fixes unblocked by the merge of some prerequisites via
   the net tree.

 - Drop deprecated MSI-X API use.

 - A couple other miscellaneous things.

----------------------------------------------------------------
Alexander Gordeev (2):
      IB/qib: Use pci_enable_msix_range() instead of pci_enable_msix()
      IB/mthca: Use pci_enable_msix_exact() instead of pci_enable_msix()

Eli Cohen (1):
      IB/mlx5: Add block multicast loopback support

Hariprasad Shenai (1):
      RDMA/cxgb4: Use pr_warn_ratelimited

Roland Dreier (1):
      Merge branches 'cxgb4', 'misc', 'mlx5' and 'qib' into for-next

Steve Wise (9):
      RDMA/cxgb4: Use the BAR2/WC path for kernel QPs and T5 devices
      RDMA/cxgb4: Endpoint timeout fixes
      RDMA/cxgb4: rmb() after reading valid gen bit
      RDMA/cxgb4: SQ flush fix
      RDMA/cxgb4: Max fastreg depth depends on DSGL support
      RDMA/cxgb4: Initialize reserved fields in a FW work request
      RDMA/cxgb4: Add missing debug stats
      RDMA/cxgb4: Use uninitialized_var()
      RDMA/cxgb4: Fix over-dereference when terminating

 drivers/infiniband/hw/cxgb4/cm.c         | 89 ++++++++++++++++++++------------
 drivers/infiniband/hw/cxgb4/cq.c         | 24 ++++-----
 drivers/infiniband/hw/cxgb4/device.c     | 41 ++++++++++++---
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h   |  2 +
 drivers/infiniband/hw/cxgb4/mem.c        |  6 ++-
 drivers/infiniband/hw/cxgb4/provider.c   |  2 +-
 drivers/infiniband/hw/cxgb4/qp.c         | 70 +++++++++++++++----------
 drivers/infiniband/hw/cxgb4/resource.c   | 10 ++--
 drivers/infiniband/hw/cxgb4/t4.h         | 72 ++++++++++++++++++++++++--
 drivers/infiniband/hw/mlx5/main.c        |  2 +
 drivers/infiniband/hw/mlx5/qp.c          | 12 +++++
 drivers/infiniband/hw/mthca/mthca_main.c |  8 +--
 drivers/infiniband/hw/qib/qib_pcie.c     | 55 ++++++++++----------
 include/linux/mlx5/device.h              |  1 +
 include/linux/mlx5/qp.h                  |  1 +
 15 files changed, 270 insertions(+), 125 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
