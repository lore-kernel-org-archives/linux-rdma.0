From: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 7/8] RDMA/cxgb4: Advertise ~0ULL as max MR size.
Date: Tue,  6 Aug 2013 21:04:39 +0530
Message-ID: <1375803280-7916-8-git-send-email-vipul@chelsio.com>
References: <1375803280-7916-1-git-send-email-vipul@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375803280-7916-1-git-send-email-vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Lustre uses a advertised max MR size of ~0ULL to indicate it should use
a dma_mr. Hence advertise max MR size as ~0ULL.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/t4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
index 1272dfe..e73ace7 100644
--- a/drivers/infiniband/hw/cxgb4/t4.h
+++ b/drivers/infiniband/hw/cxgb4/t4.h
@@ -47,7 +47,7 @@
 #define T4_MAX_QP_DEPTH (T4_MAX_RQ_SIZE - 1)
 #define T4_MAX_CQ_DEPTH (T4_MAX_IQ_SIZE - 1)
 #define T4_MAX_NUM_STAG (1<<15)
-#define T4_MAX_MR_SIZE (~0ULL - 1)
+#define T4_MAX_MR_SIZE (~0ULL)
 #define T4_PAGESIZE_MASK 0xffff000  /* 4KB-128MB */
 #define T4_STAG_UNSET 0xffffffff
 #define T4_FW_MAJ 0
-- 
1.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
