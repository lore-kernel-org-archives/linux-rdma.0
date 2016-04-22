From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 10/11] IB/srp: Do not register memory if register_always = -1
Date: Fri, 22 Apr 2016 14:16:00 -0700
Message-ID: <571A9490.9010003@sandisk.com>
References: <571A936F.7040409@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <571A936F.7040409-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This makes it easier to test the code path that does not use
memory registration (srp_map_sg_dma()).

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index f4003f6..a173ec4 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -69,7 +69,7 @@ static unsigned int cmd_sg_entries;
 static unsigned int indirect_sg_entries;
 static bool allow_ext_sg;
 static bool prefer_fr = true;
-static bool register_always = true;
+static int register_always = true;
 static int topspin_workarounds = 1;
 
 module_param(srp_sg_tablesize, uint, 0444);
@@ -95,7 +95,7 @@ module_param(prefer_fr, bool, 0444);
 MODULE_PARM_DESC(prefer_fr,
 "Whether to use fast registration if both FMR and fast registration are supported");
 
-module_param(register_always, bool, 0444);
+module_param(register_always, int, 0444);
 MODULE_PARM_DESC(register_always,
 		 "Use memory registration even for contiguous memory regions");
 
@@ -1600,9 +1600,9 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 
 	memset(&state, 0, sizeof(state));
 	state.desc = req->indirect_desc;
-	if (dev->use_fast_reg)
+	if (dev->use_fast_reg && register_always >= 0)
 		ret = srp_map_sg_fr(&state, ch, req, scat, count);
-	else if (dev->use_fmr)
+	else if (dev->use_fmr && register_always >= 0)
 		ret = srp_map_sg_fmr(&state, ch, req, scat, count);
 	else
 		ret = srp_map_sg_dma(&state, ch, req, scat, count);
@@ -3430,12 +3430,13 @@ static void srp_add_one(struct ib_device *device)
 			    device->map_phys_fmr && device->unmap_fmr);
 	srp_dev->has_fr = (device->attrs.device_cap_flags &
 			   IB_DEVICE_MEM_MGT_EXTENSIONS);
-	if (!srp_dev->has_fmr && !srp_dev->has_fr)
+	if (!srp_dev->has_fmr && !srp_dev->has_fr) {
 		dev_warn(&device->dev, "neither FMR nor FR is supported\n");
-
-	srp_dev->use_fast_reg = (srp_dev->has_fr &&
-				 (!srp_dev->has_fmr || prefer_fr));
-	srp_dev->use_fmr = !srp_dev->use_fast_reg && srp_dev->has_fmr;
+	} else if (register_always >= 0) {
+		srp_dev->use_fast_reg = (srp_dev->has_fr &&
+					 (!srp_dev->has_fmr || prefer_fr));
+		srp_dev->use_fmr = !srp_dev->use_fast_reg && srp_dev->has_fmr;
+	}
 
 	/*
 	 * Use the smallest page size supported by the HCA, down to a
@@ -3468,7 +3469,7 @@ static void srp_add_one(struct ib_device *device)
 	if (IS_ERR(srp_dev->pd))
 		goto free_dev;
 
-	if (!register_always || (!srp_dev->has_fmr && !srp_dev->has_fr)) {
+	if (register_always <= 0 || (!srp_dev->has_fmr && !srp_dev->has_fr)) {
 		srp_dev->global_mr = ib_get_dma_mr(srp_dev->pd,
 						   IB_ACCESS_LOCAL_WRITE |
 						   IB_ACCESS_REMOTE_READ |
-- 
2.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
