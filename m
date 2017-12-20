From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 for-rc 0/4] vmw_pvrdma fixes for 4.15
Date: Wed, 20 Dec 2017 09:47:57 -0800
Message-ID: <20171220174748.GA18149@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add in two missed macros used by the userlevel library for SRQs,
fix a missed ib_umem_release for QPs, fix an incorrect usage of
the new refcount_t type for SRQs, and fix a potential use after
free.

v1 -> v2 changelog:
- Remove patches that are not for-rc material
- Clarify commit message for the SRQ macros patch

v0 -> v1 changelog:
- Removed use of BIT() in UAPI header
- Make setting/usage of is_kernel consistent between QP/CQ/SRQ
- Use completions instead of wait queues for resource destroy
- Cleaned up commit messages

Bryan Tan (4):
  RDMA/vmw_pvrdma: Call ib_umem_release on destroy QP path
  RDMA/vmw_pvrdma: Use refcount_dec_and_test to avoid warning
  RDMA/vmw_pvrdma: Add UAR SRQ macros in ABI header file
  RDMA/vmw_pvrdma: Avoid use after free due to QP/CQ/SRQ destroy

 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h      |  6 +++---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c   |  7 ++++---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c | 17 +++++++----------
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c   | 14 +++++++++++---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c  |  7 ++++---
 include/uapi/rdma/vmw_pvrdma-abi.h             |  2 ++
 6 files changed, 31 insertions(+), 22 deletions(-)

-- 
1.8.5.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
