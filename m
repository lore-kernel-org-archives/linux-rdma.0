From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] ib_srpt: Use correct ib_sg_dma primitives
Date: Fri, 28 Mar 2014 12:29:56 -0400
Message-ID: <20140328162956.5004.27020.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The code was incorrectly using sg_dma_address() and
sg_dma_len() instead of ib_sg_dma_address() and
ib_sg_dma_len().

This prevents srpt from functioning with the
Intel HCA and indeed will corrupt memory
badly.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Tested-by: Vinod Kumar <vinod.kumar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 520a7e5..b4884ae 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1078,6 +1078,7 @@ static void srpt_unmap_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 static int srpt_map_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 				 struct srpt_send_ioctx *ioctx)
 {
+	struct ib_device *dev = ch->sport->sdev->device;
 	struct se_cmd *cmd;
 	struct scatterlist *sg, *sg_orig;
 	int sg_cnt;
@@ -1124,7 +1125,7 @@ static int srpt_map_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 
 	db = ioctx->rbufs;
 	tsize = cmd->data_length;
-	dma_len = sg_dma_len(&sg[0]);
+	dma_len = ib_sg_dma_len(dev, &sg[0]);
 	riu = ioctx->rdma_ius;
 
 	/*
@@ -1155,7 +1156,8 @@ static int srpt_map_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 					++j;
 					if (j < count) {
 						sg = sg_next(sg);
-						dma_len = sg_dma_len(sg);
+						dma_len = ib_sg_dma_len(
+								dev, sg);
 					}
 				}
 			} else {
@@ -1192,8 +1194,8 @@ static int srpt_map_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 	tsize = cmd->data_length;
 	riu = ioctx->rdma_ius;
 	sg = sg_orig;
-	dma_len = sg_dma_len(&sg[0]);
-	dma_addr = sg_dma_address(&sg[0]);
+	dma_len = ib_sg_dma_len(dev, &sg[0]);
+	dma_addr = ib_sg_dma_address(dev, &sg[0]);
 
 	/* this second loop is really mapped sg_addres to rdma_iu->ib_sge */
 	for (i = 0, j = 0;
@@ -1216,8 +1218,10 @@ static int srpt_map_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 					++j;
 					if (j < count) {
 						sg = sg_next(sg);
-						dma_len = sg_dma_len(sg);
-						dma_addr = sg_dma_address(sg);
+						dma_len = ib_sg_dma_len(
+								dev, sg);
+						dma_addr = ib_sg_dma_address(
+								dev, sg);
 					}
 				}
 			} else {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
