From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 for-rc 6/8] RDMA/vmw_pvrdma: Remove usage of BIT() from
 UAPI header
Date: Wed, 13 Dec 2017 16:25:01 -0800
Message-ID: <20171214002451.GA16748@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
References: <20171214001753.GA9780@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171214001753.GA9780-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

BIT() should not be used in the UAPI header. Remove it.

Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 include/uapi/rdma/vmw_pvrdma-abi.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/uapi/rdma/vmw_pvrdma-abi.h b/include/uapi/rdma/vmw_pvrdma-abi.h
index aaa352f..8d37af5 100644
--- a/include/uapi/rdma/vmw_pvrdma-abi.h
+++ b/include/uapi/rdma/vmw_pvrdma-abi.h
@@ -52,12 +52,12 @@
 #define PVRDMA_UVERBS_ABI_VERSION	3		/* ABI Version. */
 #define PVRDMA_UAR_HANDLE_MASK		0x00FFFFFF	/* Bottom 24 bits. */
 #define PVRDMA_UAR_QP_OFFSET		0		/* QP doorbell. */
-#define PVRDMA_UAR_QP_SEND		BIT(30)		/* Send bit. */
-#define PVRDMA_UAR_QP_RECV		BIT(31)		/* Recv bit. */
+#define PVRDMA_UAR_QP_SEND		(1 << 30)	/* Send bit. */
+#define PVRDMA_UAR_QP_RECV		(1 << 31)	/* Recv bit. */
 #define PVRDMA_UAR_CQ_OFFSET		4		/* CQ doorbell. */
-#define PVRDMA_UAR_CQ_ARM_SOL		BIT(29)		/* Arm solicited bit. */
-#define PVRDMA_UAR_CQ_ARM		BIT(30)		/* Arm bit. */
-#define PVRDMA_UAR_CQ_POLL		BIT(31)		/* Poll bit. */
+#define PVRDMA_UAR_CQ_ARM_SOL		(1 << 29)	/* Arm solicited bit. */
+#define PVRDMA_UAR_CQ_ARM		(1 << 30)	/* Arm bit. */
+#define PVRDMA_UAR_CQ_POLL		(1 << 31)	/* Poll bit. */
 
 enum pvrdma_wr_opcode {
 	PVRDMA_WR_RDMA_WRITE,
-- 
1.8.5.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
