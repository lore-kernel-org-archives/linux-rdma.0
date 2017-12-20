From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 for-rc 3/4] RDMA/vmw_pvrdma: Add UAR SRQ macros in ABI
 header file
Date: Wed, 20 Dec 2017 09:50:57 -0800
Message-ID: <20171220175051.GA22751@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
References: <20171220174748.GA18149@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171220174748.GA18149-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Support for SRQs were added in the vmw_pvrdma userlevel library
before two necessary macros were added into the kernel ABI header
file. Add the two UAR SRQ macros that are required by the userlevel
library so that the library can rely on the kernel ABI header file
for these SRQ macro definitions.

Fixes: 8b10ba783c9d ("RDMA/vmw_pvrdma: Add shared receive queue support")
Reviewed-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 include/uapi/rdma/vmw_pvrdma-abi.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/rdma/vmw_pvrdma-abi.h b/include/uapi/rdma/vmw_pvrdma-abi.h
index aaa352f..4007cac 100644
--- a/include/uapi/rdma/vmw_pvrdma-abi.h
+++ b/include/uapi/rdma/vmw_pvrdma-abi.h
@@ -58,6 +58,8 @@
 #define PVRDMA_UAR_CQ_ARM_SOL		BIT(29)		/* Arm solicited bit. */
 #define PVRDMA_UAR_CQ_ARM		BIT(30)		/* Arm bit. */
 #define PVRDMA_UAR_CQ_POLL		BIT(31)		/* Poll bit. */
+#define PVRDMA_UAR_SRQ_OFFSET		8		/* SRQ doorbell. */
+#define PVRDMA_UAR_SRQ_RECV		BIT(30)		/* Recv bit. */
 
 enum pvrdma_wr_opcode {
 	PVRDMA_WR_RDMA_WRITE,
-- 
1.8.5.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
