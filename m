From: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 8/9] RDMA/nes: Add max_cqe check to nes_create_cq()
Date: Tue, 1 Dec 2009 16:20:02 -0600
Message-ID: <20091201222002.GA7488@ctung-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Add a check to nes_create_cq() to return -EINVAL if creating
a CQ with depth > max_cqe (32766).

Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_hw.c    |    2 +-
 drivers/infiniband/hw/nes/nes_verbs.c |    5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index b59ca56..6f625a9 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -482,7 +482,7 @@ struct nes_adapter *nes_init_adapter(struct nes_device *nesdev, u8 hw_rev) {
 	nesadapter->max_irrq_wr = (u32temp >> 16) & 3;
 
 	nesadapter->max_sge = 4;
-	nesadapter->max_cqe = 32767;
+	nesadapter->max_cqe = 32766;
 
 	if (nes_read_eeprom_values(nesdev, nesadapter)) {
 		printk(KERN_ERR PFX "Unable to read EEPROM data.\n");
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index e929684..e09d3ed 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -527,7 +527,7 @@ static int nes_query_device(struct ib_device *ibdev, struct ib_device_attr *prop
 	props->max_qp_wr = nesdev->nesadapter->max_qp_wr - 2;
 	props->max_sge = nesdev->nesadapter->max_sge;
 	props->max_cq = nesibdev->max_cq;
-	props->max_cqe = nesdev->nesadapter->max_cqe - 1;
+	props->max_cqe = nesdev->nesadapter->max_cqe;
 	props->max_mr = nesibdev->max_mr;
 	props->max_mw = nesibdev->max_mr;
 	props->max_pd = nesibdev->max_pd;
@@ -1543,6 +1543,9 @@ static struct ib_cq *nes_create_cq(struct ib_device *ibdev, int entries,
 	unsigned long flags;
 	int ret;
 
+	if (entries > nesadapter->max_cqe)
+		return ERR_PTR(-EINVAL);
+
 	err = nes_alloc_resource(nesadapter, nesadapter->allocated_cqs,
 			nesadapter->max_cq, &cq_num, &nesadapter->next_cq);
 	if (err) {
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
