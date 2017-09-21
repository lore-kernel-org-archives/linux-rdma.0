From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-rc] RDMA/vmw_pvrdma: Fix reporting correct opcodes for
 completion
Date: Thu, 21 Sep 2017 15:56:21 -0700
Message-ID: <20170921225608.GA31527@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>

Since the IB_WC_BIND_MW opcode has been dropped, set the correct
IB WC opcode explicitly.

Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
index 663a0c3..984aa34 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
@@ -416,9 +416,34 @@ static inline enum ib_wc_status pvrdma_wc_status_to_ib(
 	return (enum ib_wc_status)status;
 }
 
-static inline int pvrdma_wc_opcode_to_ib(int opcode)
-{
-	return opcode;
+static inline int pvrdma_wc_opcode_to_ib(unsigned int opcode)
+{
+	switch (opcode) {
+	case PVRDMA_WC_SEND:
+		return IB_WC_SEND;
+	case PVRDMA_WC_RDMA_WRITE:
+		return IB_WC_RDMA_WRITE;
+	case PVRDMA_WC_RDMA_READ:
+		return IB_WC_RDMA_READ;
+	case PVRDMA_WC_COMP_SWAP:
+		return IB_WC_COMP_SWAP;
+	case PVRDMA_WC_FETCH_ADD:
+		return IB_WC_FETCH_ADD;
+	case PVRDMA_WC_LOCAL_INV:
+		return IB_WC_LOCAL_INV;
+	case PVRDMA_WC_FAST_REG_MR:
+		return IB_WC_REG_MR;
+	case PVRDMA_WC_MASKED_COMP_SWAP:
+		return IB_WC_MASKED_COMP_SWAP;
+	case PVRDMA_WC_MASKED_FETCH_ADD:
+		return IB_WC_MASKED_FETCH_ADD;
+	case PVRDMA_WC_RECV:
+		return IB_WC_RECV;
+	case PVRDMA_WC_RECV_RDMA_WITH_IMM:
+		return IB_WC_RECV_RDMA_WITH_IMM;
+	default:
+		return IB_WC_SEND;
+	}
 }
 
 static inline int pvrdma_wc_flags_to_ib(int flags)
-- 
1.8.5.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
