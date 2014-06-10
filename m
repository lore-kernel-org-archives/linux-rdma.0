From: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 for-next 10/16] RDMA/ocrdma: Do proper cleanup evenif FW is in error state
Date: Tue, 10 Jun 2014 19:32:21 +0530
Message-ID: <d75f4331-7c84-4b25-bf24-62b8439c907c@CMEXHTCAS1.ad.emulex.com>
References: <1402408947-2074-1-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-2-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-3-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-4-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-5-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-6-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-7-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-8-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-9-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-10-git-send-email-selvin.xavier@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1402408947-2074-10-git-send-email-selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Mitesh Ahuja <mitesh.ahuja-HfQkIhtri/DQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitesh Ahuja <mitesh.ahuja-HfQkIhtri/DQT0dZR+AlfA@public.gmane.org>

If any mailbox command reports timeout, save the state in the driver, to prevent
issuing any more commands to the HW. Do proper cleanup even if FW is in error state.

Signed-off-by: Mitesh Ahuja <mitesh.ahuja-HfQkIhtri/DQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |    1 +
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |    8 +++++++-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |   12 +++++++++++-
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 5cd65c2..fc27378 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -137,6 +137,7 @@ struct mqe_ctx {
 	u16 cqe_status;
 	u16 ext_status;
 	bool cmd_done;
+	bool fw_error_state;
 };
 
 struct ocrdma_hw_mr {
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 55308b6..5b6e9d9 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -966,8 +966,12 @@ static int ocrdma_wait_mqe_cmpl(struct ocrdma_dev *dev)
 				    msecs_to_jiffies(30000));
 	if (status)
 		return 0;
-	else
+	else {
+		dev->mqe_ctx.fw_error_state = true;
+		pr_err("%s(%d) mailbox timeout: fw not responding\n",
+		       __func__, dev->id);
 		return -1;
+	}
 }
 
 /* issue a mailbox command on the MQ */
@@ -979,6 +983,8 @@ static int ocrdma_mbx_cmd(struct ocrdma_dev *dev, struct ocrdma_mqe *mqe)
 	struct ocrdma_mbx_rsp *rsp = NULL;
 
 	mutex_lock(&dev->mqe_ctx.lock);
+	if (dev->mqe_ctx.fw_error_state)
+		goto mbx_err;
 	ocrdma_post_mqe(dev, mqe);
 	status = ocrdma_wait_mqe_cmpl(dev);
 	if (status)
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 7f54d24..8cd16a1 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -329,7 +329,10 @@ static int ocrdma_dealloc_ucontext_pd(struct ocrdma_ucontext *uctx)
 	struct ocrdma_pd *pd = uctx->cntxt_pd;
 	struct ocrdma_dev *dev = get_ocrdma_dev(pd->ibpd.device);
 
-	BUG_ON(uctx->pd_in_use);
+	if (uctx->pd_in_use) {
+		pr_err("%s(%d) Freeing in use pdid=0x%x.\n",
+		       __func__, dev->id, pd->id);
+	}
 	uctx->cntxt_pd = NULL;
 	status = _ocrdma_dealloc_pd(dev, pd);
 	return status;
@@ -844,6 +847,13 @@ int ocrdma_dereg_mr(struct ib_mr *ib_mr)
 	if (mr->umem)
 		ib_umem_release(mr->umem);
 	kfree(mr);
+
+	/* Don't stop cleanup, in case FW is unresponsive */
+	if (dev->mqe_ctx.fw_error_state) {
+		status = 0;
+		pr_err("%s(%d) fw not responding.\n",
+		       __func__, dev->id);
+	}
 	return status;
 }
 
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
