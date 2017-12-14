From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 for-rc 0/8] vmw_pvrdma fixes for 4.15
Date: Wed, 13 Dec 2017 16:17:59 -0800
Message-ID: <20171214001753.GA9780@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
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
ib_umem_release, an incorrect usage of the new refcount_t type,
and switched from use of wait queues to completions.

v0 -> v1 changelog:
- Removed use of BIT() in UAPI header
- Make setting/usage of is_kernel consistent between QP/CQ/SRQ
- Use completions instead of wait queues for resource destroy
- Cleaned up commit messages

Bryan Tan (8):
  RDMA/vmw_pvrdma: Clarify QP and CQ is_kernel logic
  RDMA/vmw_pvrdma: Call ib_umem_release on destroy QP path
  RDMA/vmw_pvrdma: Use more specific sizeof in kcalloc
  RDMA/vmw_pvrdma: Use refcount_dec_and_test to avoid warning
  RDMA/vmw_pvrdma: Use refcount_t instead of atomic_t
  RDMA/vmw_pvrdma: Remove usage of BIT() from UAPI header
  RDMA/vmw_pvrdma: Add UAR SRQ macros in ABI header file
  RDMA/vmw_pvrdma: Use completion instead of wait queue

 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h      | 10 +++++-----
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c   | 18 ++++++++---------
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c | 27 ++++++++++++--------------
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c   | 23 ++++++++++++++--------
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c  |  7 ++++---
 include/uapi/rdma/vmw_pvrdma-abi.h             | 12 +++++++-----
 6 files changed, 52 insertions(+), 45 deletions(-)

-- 
1.8.5.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
