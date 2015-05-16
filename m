From: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH for-4.1 06/11] RDMA/ocrdma: Prevent allocation of DPP PDs if FW doesnt support it
Date: Sat, 16 May 2015 13:21:44 +0530
Message-ID: <1431762709-20740-7-git-send-email-selvin.xavier@avagotech.com>
References: <1431762709-20740-1-git-send-email-selvin.xavier@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431762709-20740-1-git-send-email-selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>

If DPP PDs are not supported by the FW, allocate only normal PDs.

Signed-off-by: Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 48 ++++++++++++++---------------
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |  2 +-
 2 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 5636eb6..4b77f34 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1440,27 +1440,30 @@ static int ocrdma_mbx_alloc_pd_range(struct ocrdma_dev *dev)
 	struct ocrdma_alloc_pd_range_rsp *rsp;
 
 	/* Pre allocate the DPP PDs */
-	cmd = ocrdma_init_emb_mqe(OCRDMA_CMD_ALLOC_PD_RANGE, sizeof(*cmd));
-	if (!cmd)
-		return -ENOMEM;
-	cmd->pd_count = dev->attr.max_dpp_pds;
-	cmd->enable_dpp_rsvd |= OCRDMA_ALLOC_PD_ENABLE_DPP;
-	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
-	if (status)
-		goto mbx_err;
-	rsp = (struct ocrdma_alloc_pd_range_rsp *)cmd;
-
-	if ((rsp->dpp_page_pdid & OCRDMA_ALLOC_PD_RSP_DPP) && rsp->pd_count) {
-		dev->pd_mgr->dpp_page_index = rsp->dpp_page_pdid >>
-				OCRDMA_ALLOC_PD_RSP_DPP_PAGE_SHIFT;
-		dev->pd_mgr->pd_dpp_start = rsp->dpp_page_pdid &
-				OCRDMA_ALLOC_PD_RNG_RSP_START_PDID_MASK;
-		dev->pd_mgr->max_dpp_pd = rsp->pd_count;
-		pd_bitmap_size = BITS_TO_LONGS(rsp->pd_count) * sizeof(long);
-		dev->pd_mgr->pd_dpp_bitmap = kzalloc(pd_bitmap_size,
-						     GFP_KERNEL);
+	if (dev->attr.max_dpp_pds) {
+		cmd = ocrdma_init_emb_mqe(OCRDMA_CMD_ALLOC_PD_RANGE,
+					  sizeof(*cmd));
+		if (!cmd)
+			return -ENOMEM;
+		cmd->pd_count = dev->attr.max_dpp_pds;
+		cmd->enable_dpp_rsvd |= OCRDMA_ALLOC_PD_ENABLE_DPP;
+		status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
+		rsp = (struct ocrdma_alloc_pd_range_rsp *)cmd;
+
+		if (!status && (rsp->dpp_page_pdid & OCRDMA_ALLOC_PD_RSP_DPP) &&
+		    rsp->pd_count) {
+			dev->pd_mgr->dpp_page_index = rsp->dpp_page_pdid >>
+					OCRDMA_ALLOC_PD_RSP_DPP_PAGE_SHIFT;
+			dev->pd_mgr->pd_dpp_start = rsp->dpp_page_pdid &
+					OCRDMA_ALLOC_PD_RNG_RSP_START_PDID_MASK;
+			dev->pd_mgr->max_dpp_pd = rsp->pd_count;
+			pd_bitmap_size =
+				BITS_TO_LONGS(rsp->pd_count) * sizeof(long);
+			dev->pd_mgr->pd_dpp_bitmap = kzalloc(pd_bitmap_size,
+							     GFP_KERNEL);
+		}
+		kfree(cmd);
 	}
-	kfree(cmd);
 
 	cmd = ocrdma_init_emb_mqe(OCRDMA_CMD_ALLOC_PD_RANGE, sizeof(*cmd));
 	if (!cmd)
@@ -1468,10 +1471,8 @@ static int ocrdma_mbx_alloc_pd_range(struct ocrdma_dev *dev)
 
 	cmd->pd_count = dev->attr.max_pd - dev->attr.max_dpp_pds;
 	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
-	if (status)
-		goto mbx_err;
 	rsp = (struct ocrdma_alloc_pd_range_rsp *)cmd;
-	if (rsp->pd_count) {
+	if (!status && rsp->pd_count) {
 		dev->pd_mgr->pd_norm_start = rsp->dpp_page_pdid &
 					OCRDMA_ALLOC_PD_RNG_RSP_START_PDID_MASK;
 		dev->pd_mgr->max_normal_pd = rsp->pd_count;
@@ -1486,7 +1487,6 @@ static int ocrdma_mbx_alloc_pd_range(struct ocrdma_dev *dev)
 	} else {
 		return -ENOMEM;
 	}
-mbx_err:
 	kfree(cmd);
 	return status;
 }
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 06e8ab7..9dcb660 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -365,7 +365,7 @@ static struct ocrdma_pd *_ocrdma_alloc_pd(struct ocrdma_dev *dev,
 	if (!pd)
 		return ERR_PTR(-ENOMEM);
 
-	if (udata && uctx) {
+	if (udata && uctx && dev->attr.max_dpp_pds) {
 		pd->dpp_enabled =
 			ocrdma_get_asic_type(dev) == OCRDMA_ASIC_GEN_SKH_R;
 		pd->num_dpp_qp =
-- 
2.2.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
