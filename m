From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] RDMA: Use standard way to check return value
Date: Wed, 24 Jan 2018 14:43:01 +0200
Message-ID: <20180124124301.10884-1-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, hare-IBi9RG/b67k@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

To be compatible with other modules/drivers, change return code checks
from "if (rc != 0)" to "if (rc)".

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
v0 -> v1:
	* Add some other fixes (srp,iser and srpt)
v1 -> v2:
	* Accept Leon's comment and change commit's title.
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c | 8 ++++----
 drivers/infiniband/ulp/iser/iser_initiator.c   | 2 +-
 drivers/infiniband/ulp/srp/ib_srp.c            | 2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c          | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
index d650a9fcde24..ce289a55a9dc 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
@@ -837,16 +837,16 @@ static int pvrdma_pci_probe(struct pci_dev *pdev,
 	}
 
 	/* Enable 64-Bit DMA */
-	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) == 0) {
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
-		if (ret != 0) {
+		if (ret) {
 			dev_err(&pdev->dev,
 				"pci_set_consistent_dma_mask failed\n");
 			goto err_free_resource;
 		}
 	} else {
 		ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
-		if (ret != 0) {
+		if (ret) {
 			dev_err(&pdev->dev,
 				"pci_set_dma_mask failed\n");
 			goto err_free_resource;
@@ -1018,7 +1018,7 @@ static int pvrdma_pci_probe(struct pci_dev *pdev,
 
 	/* Check if device was successfully activated */
 	ret = pvrdma_read_reg(dev, PVRDMA_REG_ERR);
-	if (ret != 0) {
+	if (ret) {
 		dev_err(&pdev->dev, "failed to activate device\n");
 		ret = -EFAULT;
 		goto err_disable_intr;
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 2a07692007bd..09045a432f89 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -128,7 +128,7 @@ iser_prepare_write_cmd(struct iscsi_task *task,
 
 	err = iser_reg_rdma_mem(iser_task, ISER_DIR_OUT,
 				buf_out->data_len == imm_sz);
-	if (err != 0) {
+	if (err) {
 		iser_err("Failed to register write cmd RDMA mem\n");
 		return err;
 	}
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 62d88212c1b0..8d9676b9fbc9 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2109,7 +2109,7 @@ static void srp_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 				      DMA_FROM_DEVICE);
 
 	res = srp_post_recv(ch, iu);
-	if (res != 0)
+	if (res)
 		shost_printk(KERN_ERR, target->scsi_host,
 			     PFX "Recv failed with error code %d\n", res);
 }
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index d78f60dcc2ba..659e6d62fb97 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1441,7 +1441,7 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
 			       scsilun_to_int(&srp_cmd->lun), data_len,
 			       TCM_SIMPLE_TAG, dir, TARGET_SCF_ACK_KREF,
 			       sg, sg_cnt, NULL, 0, NULL, 0);
-	if (rc != 0) {
+	if (rc) {
 		pr_debug("target_submit_cmd() returned %d for tag %#llx\n", rc,
 			 srp_cmd->tag);
 		goto release_ioctx;
@@ -1508,7 +1508,7 @@ static void srpt_handle_tsk_mgmt(struct srpt_rdma_ch *ch,
 			       scsilun_to_int(&srp_tsk->lun), srp_tsk, tcm_tmr,
 			       GFP_KERNEL, srp_tsk->task_tag,
 			       TARGET_SCF_ACK_KREF);
-	if (rc != 0) {
+	if (rc) {
 		send_ioctx->cmd.se_tmr_req->response = TMR_FUNCTION_REJECTED;
 		goto fail;
 	}
-- 
2.14.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
