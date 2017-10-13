From: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] bnxt_re: Fix incorrect usage of test_bit()
Date: Fri, 13 Oct 2017 11:38:00 +0530
Message-ID: <20171013060800.10371-1-somnath.kotur@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

test_bit() takes a bit number while the 'flags' field in
struct bnxt_qplib_rcfw was using actual BIT position converted
values.
Fix this by assigning bit numbers and use consistent APIs
all the flag values.
Also logging a message in case of failure.

Thanks to Dan Carpenter for pointing this out.

Suggested-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/main.c       | 5 +++--
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c | 8 ++++----
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h | 6 +++---
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index e7450ea..87f8a5d 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -1071,9 +1071,10 @@ static int bnxt_re_ib_reg(struct bnxt_re_dev *rdev)
 	 */
 	rc = bnxt_qplib_alloc_rcfw_channel(rdev->en_dev->pdev, &rdev->rcfw,
 					   BNXT_RE_MAX_QPC_COUNT);
-	if (rc)
+	if (rc) {
+		pr_err("Failed to allocate RCFW Channel: %#x\n", rc);
 		goto fail;
-
+	}
 	rc = bnxt_re_net_ring_alloc
 			(rdev, rdev->rcfw.creq.pbl[PBL_LVL_0].pg_map_arr,
 			 rdev->rcfw.creq.pbl[rdev->rcfw.creq.level].pg_count,
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
index 2bdb156..560f924 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -172,14 +172,14 @@ static int __send_message(struct bnxt_qplib_rcfw *rcfw, struct cmdq_base *req,
 	rcfw->seq_num++;
 
 	cmdq_prod = cmdq->prod;
-	if (rcfw->flags & FIRMWARE_FIRST_FLAG) {
+	if (test_bit(FIRMWARE_FIRST_FLAG, &rcfw->flags)) {
 		/* The very first doorbell write
 		 * is required to set this flag
 		 * which prompts the FW to reset
 		 * its internal pointers
 		 */
-		cmdq_prod |= FIRMWARE_FIRST_FLAG;
-		rcfw->flags &= ~FIRMWARE_FIRST_FLAG;
+		cmdq_prod |= BIT(FIRMWARE_FIRST_FLAG);
+		clear_bit(FIRMWARE_FIRST_FLAG, &rcfw->flags);
 	}
 
 	/* ring CMDQ DB */
@@ -622,7 +622,7 @@ int bnxt_qplib_enable_rcfw_channel(struct pci_dev *pdev,
 
 	/* General */
 	rcfw->seq_num = 0;
-	rcfw->flags = FIRMWARE_FIRST_FLAG;
+	set_bit(FIRMWARE_FIRST_FLAG, &rcfw->flags);
 	bmap_size = BITS_TO_LONGS(RCFW_MAX_OUTSTANDING_CMD *
 				  sizeof(unsigned long));
 	rcfw->cmdq_bitmap = kzalloc(bmap_size, GFP_KERNEL);
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
index 85b16da..2946a7c 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
@@ -162,9 +162,9 @@ struct bnxt_qplib_rcfw {
 	unsigned long		*cmdq_bitmap;
 	u32			bmap_size;
 	unsigned long		flags;
-#define FIRMWARE_INITIALIZED_FLAG	BIT(0)
-#define FIRMWARE_FIRST_FLAG		BIT(31)
-#define FIRMWARE_TIMED_OUT		BIT(3)
+#define FIRMWARE_INITIALIZED_FLAG	0
+#define FIRMWARE_FIRST_FLAG		31
+#define FIRMWARE_TIMED_OUT		3
 	wait_queue_head_t	waitq;
 	int			(*aeq_handler)(struct bnxt_qplib_rcfw *,
 					       struct creq_func_event *);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
