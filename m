From: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 12/15] RDMA/ocrdma : Add missing adapter mailbox opcodes
Date: Wed, 4 Jun 2014 23:49:12 +0530
Message-ID: <c3cc68e8-176c-4339-9813-7f59a38246d8@CMEXHTCAS1.ad.emulex.com>
References: <1401905955-28117-1-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-2-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-3-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-4-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-5-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-6-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-7-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-8-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-9-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-10-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-11-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-12-git-send-email-selvin.xavier@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1401905955-28117-12-git-send-email-selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fixing the Statistics command opcode. Also specifying the
opcode of each command  for better readablilty.

Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h |   62 +++++++++++++++-------------
 1 files changed, 33 insertions(+), 29 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 3cb88f0..a20d348 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -44,35 +44,39 @@ enum {
 #define OCRDMA_SUBSYS_ROCE 10
 enum {
 	OCRDMA_CMD_QUERY_CONFIG = 1,
-	OCRDMA_CMD_ALLOC_PD,
-	OCRDMA_CMD_DEALLOC_PD,
-
-	OCRDMA_CMD_CREATE_AH_TBL,
-	OCRDMA_CMD_DELETE_AH_TBL,
-
-	OCRDMA_CMD_CREATE_QP,
-	OCRDMA_CMD_QUERY_QP,
-	OCRDMA_CMD_MODIFY_QP,
-	OCRDMA_CMD_DELETE_QP,
-
-	OCRDMA_CMD_RSVD1,
-	OCRDMA_CMD_ALLOC_LKEY,
-	OCRDMA_CMD_DEALLOC_LKEY,
-	OCRDMA_CMD_REGISTER_NSMR,
-	OCRDMA_CMD_REREGISTER_NSMR,
-	OCRDMA_CMD_REGISTER_NSMR_CONT,
-	OCRDMA_CMD_QUERY_NSMR,
-	OCRDMA_CMD_ALLOC_MW,
-	OCRDMA_CMD_QUERY_MW,
-
-	OCRDMA_CMD_CREATE_SRQ,
-	OCRDMA_CMD_QUERY_SRQ,
-	OCRDMA_CMD_MODIFY_SRQ,
-	OCRDMA_CMD_DELETE_SRQ,
-
-	OCRDMA_CMD_ATTACH_MCAST,
-	OCRDMA_CMD_DETACH_MCAST,
-	OCRDMA_CMD_GET_RDMA_STATS,
+	OCRDMA_CMD_ALLOC_PD = 2,
+	OCRDMA_CMD_DEALLOC_PD = 3,
+
+	OCRDMA_CMD_CREATE_AH_TBL = 4,
+	OCRDMA_CMD_DELETE_AH_TBL = 5,
+
+	OCRDMA_CMD_CREATE_QP = 6,
+	OCRDMA_CMD_QUERY_QP = 7,
+	OCRDMA_CMD_MODIFY_QP = 8 ,
+	OCRDMA_CMD_DELETE_QP = 9,
+
+	OCRDMA_CMD_RSVD1 = 10,
+	OCRDMA_CMD_ALLOC_LKEY = 11,
+	OCRDMA_CMD_DEALLOC_LKEY = 12,
+	OCRDMA_CMD_REGISTER_NSMR = 13,
+	OCRDMA_CMD_REREGISTER_NSMR = 14,
+	OCRDMA_CMD_REGISTER_NSMR_CONT = 15,
+	OCRDMA_CMD_QUERY_NSMR = 16,
+	OCRDMA_CMD_ALLOC_MW = 17,
+	OCRDMA_CMD_QUERY_MW = 18,
+
+	OCRDMA_CMD_CREATE_SRQ = 19,
+	OCRDMA_CMD_QUERY_SRQ = 20,
+	OCRDMA_CMD_MODIFY_SRQ = 21,
+	OCRDMA_CMD_DELETE_SRQ = 22,
+
+	OCRDMA_CMD_ATTACH_MCAST = 23,
+	OCRDMA_CMD_DETACH_MCAST = 24,
+
+	OCRDMA_CMD_CREATE_RBQ = 25,
+	OCRDMA_CMD_DESTROY_RBQ = 26,
+
+	OCRDMA_CMD_GET_RDMA_STATS = 27,
 
 	OCRDMA_CMD_MAX
 };
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
