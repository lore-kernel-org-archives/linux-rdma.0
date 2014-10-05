From: Jes.Sorensen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [PATCH 3/3] infiniband: ocrdma: Save the bit environment, spare unncessary parenthesis
Date: Sun,  5 Oct 2014 16:33:25 +0200
Message-ID: <1412519605-16106-4-git-send-email-Jes.Sorensen@redhat.com>
References: <1412519605-16106-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412519605-16106-1-git-send-email-Jes.Sorensen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-drivers-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Jes Sorensen <Jes.Sorensen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Parenthesis around constants serves no purpose, save the bits!

Signed-off-by: Jes Sorensen <Jes.Sorensen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h | 38 +++++++++++++++----------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index c521261..4e03648 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -101,7 +101,7 @@ enum {
 	QTYPE_MCCQ	= 3
 };
 
-#define OCRDMA_MAX_SGID (8)
+#define OCRDMA_MAX_SGID		8
 
 #define OCRDMA_MAX_QP    2048
 #define OCRDMA_MAX_CQ    2048
@@ -126,33 +126,33 @@ enum {
 #define OCRDMA_DB_CQ_RING_ID_EXT_MASK  0x0C00	/* bits 10-11 of qid at 12-11 */
 /* qid #2 msbits at 12-11 */
 #define OCRDMA_DB_CQ_RING_ID_EXT_MASK_SHIFT  0x1
-#define OCRDMA_DB_CQ_NUM_POPPED_SHIFT       (16)	/* bits 16 - 28 */
+#define OCRDMA_DB_CQ_NUM_POPPED_SHIFT	16	/* bits 16 - 28 */
 /* Rearm bit */
-#define OCRDMA_DB_CQ_REARM_SHIFT        (29)	/* bit 29 */
+#define OCRDMA_DB_CQ_REARM_SHIFT	29	/* bit 29 */
 /* solicited bit */
-#define OCRDMA_DB_CQ_SOLICIT_SHIFT   (31)	/* bit 31 */
+#define OCRDMA_DB_CQ_SOLICIT_SHIFT	31	/* bit 31 */
 
 #define OCRDMA_EQ_ID_MASK		0x1FF	/* bits 0 - 8 */
 #define OCRDMA_EQ_ID_EXT_MASK		0x3e00	/* bits 9-13 */
-#define OCRDMA_EQ_ID_EXT_MASK_SHIFT	(2)	/* qid bits 9-13 at 11-15 */
+#define OCRDMA_EQ_ID_EXT_MASK_SHIFT	2	/* qid bits 9-13 at 11-15 */
 
 /* Clear the interrupt for this eq */
-#define OCRDMA_EQ_CLR_SHIFT			(9)	/* bit 9 */
+#define OCRDMA_EQ_CLR_SHIFT		9	/* bit 9 */
 /* Must be 1 */
-#define OCRDMA_EQ_TYPE_SHIFT		(10)	/* bit 10 */
+#define OCRDMA_EQ_TYPE_SHIFT		10	/* bit 10 */
 /* Number of event entries processed */
-#define OCRDMA_NUM_EQE_SHIFT		(16)	/* bits 16 - 28 */
+#define OCRDMA_NUM_EQE_SHIFT		16	/* bits 16 - 28 */
 /* Rearm bit */
-#define OCRDMA_REARM_SHIFT		(29)	/* bit 29 */
+#define OCRDMA_REARM_SHIFT		29	/* bit 29 */
 
 #define OCRDMA_MQ_ID_MASK		0x7FF	/* bits 0 - 10 */
 /* Number of entries posted */
-#define OCRDMA_MQ_NUM_MQE_SHIFT	(16)	/* bits 16 - 29 */
+#define OCRDMA_MQ_NUM_MQE_SHIFT	16	/* bits 16 - 29 */
 
-#define OCRDMA_MIN_HPAGE_SIZE (4096)
+#define OCRDMA_MIN_HPAGE_SIZE	4096
 
-#define OCRDMA_MIN_Q_PAGE_SIZE (4096)
-#define OCRDMA_MAX_Q_PAGES     (8)
+#define OCRDMA_MIN_Q_PAGE_SIZE	4096
+#define OCRDMA_MAX_Q_PAGES	8
 
 #define OCRDMA_SLI_ASIC_ID_OFFSET	0x9C
 #define OCRDMA_SLI_ASIC_REV_MASK	0x000000FF
@@ -168,14 +168,14 @@ enum {
 # 6: 256K Bytes
 # 7: 512K Bytes
 */
-#define OCRDMA_MAX_Q_PAGE_SIZE_CNT (8)
+#define OCRDMA_MAX_Q_PAGE_SIZE_CNT	8
 #define OCRDMA_Q_PAGE_BASE_SIZE (OCRDMA_MIN_Q_PAGE_SIZE * OCRDMA_MAX_Q_PAGES)
 
-#define MAX_OCRDMA_QP_PAGES      (8)
+#define MAX_OCRDMA_QP_PAGES		8
 #define OCRDMA_MAX_WQE_MEM_SIZE (MAX_OCRDMA_QP_PAGES * OCRDMA_MIN_HQ_PAGE_SIZE)
 
-#define OCRDMA_CREATE_CQ_MAX_PAGES (4)
-#define OCRDMA_DPP_CQE_SIZE (4)
+#define OCRDMA_CREATE_CQ_MAX_PAGES	4
+#define OCRDMA_DPP_CQE_SIZE		4
 
 #define OCRDMA_GEN2_MAX_CQE 1024
 #define OCRDMA_GEN2_CQ_PAGE_SIZE 4096
@@ -290,7 +290,7 @@ struct ocrdma_pa {
 	u32 hi;
 };
 
-#define MAX_OCRDMA_EQ_PAGES (8)
+#define MAX_OCRDMA_EQ_PAGES	8
 struct ocrdma_create_eq_req {
 	struct ocrdma_mbx_hdr req;
 	u32 num_pages;
@@ -312,7 +312,7 @@ struct ocrdma_create_eq_rsp {
 	u32 vector_eqid;
 };
 
-#define OCRDMA_EQ_MINOR_OTHER (0x1)
+#define OCRDMA_EQ_MINOR_OTHER	0x1
 
 enum {
 	OCRDMA_MCQE_STATUS_SHIFT	= 0,
-- 
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
