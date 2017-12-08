From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-rc 0/6] vmw_pvrdma fixes for 4.15
Date: Fri, 8 Dec 2017 10:58:23 -0800
Message-ID: <20171208185818.GA28514@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Do some cleanup and fixes related to the comments received during SRQ
support upstreaming that applied to existing code. Also add in two
missed macros used by the userlevel library for SRQs, a missed
ib_umem_release, and an incorrect usage of the new refcount_t type.

Bryan Tan (6):
  RDMA/vmw_pvrdma: Clarify QP is_kernel logic
  RDMA/vmw_pvrdma: Call ib_umem_release on destroy QP path
  RDMA/vmw_pvrdma: Use more specific sizeof in kcalloc
  RDMA/vmw_pvrdma: Use refcount_dec_and_test to avoid warning
  RDMA/vmw_pvrdma: Use refcount_t instead of atomic_t
  RDMA/vmw_pvrdma: Add UAR SRQ macros in ABI header file

 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h      |  4 ++--
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c   |  6 +++---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c | 19 ++++++++-----------
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c   | 20 +++++++++++++-------
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c  |  4 ++--
 include/uapi/rdma/vmw_pvrdma-abi.h             |  2 ++
 6 files changed, 30 insertions(+), 25 deletions(-)

-- 
1.8.5.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
