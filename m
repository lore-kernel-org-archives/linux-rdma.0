From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 3/8] nvme: Modify and export sync command submission for fabrics
Date: Mon, 13 Jun 2016 16:45:23 +0200
Message-ID: <1465829128-22993-4-git-send-email-hch@lst.de>
References: <1465829128-22993-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465829128-22993-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

NVMe over fabrics will use __nvme_submit_sync_cmd in the the
transport and require a few tweaks to it.  For that we export it
and add a few more paramters:

1. allow passing a queue ID to the block layer

   For the NVMe over Fabrics connect command we need to able to specify a
   queue ID that we want to send the command on.  Add a qid parameter to
   the relevant functions to enable this behavior.

2. allow submitting at_head commands

   In cases where we want to (re)connect to a controller
   where we have inflight queued commands we want to first
   connect and only then allow the other queued commands to
   be kicked. This will prevents failures in controller resets
   and reconnects.

3. allow passing flags to blk_mq_allocate_request

   Both for Fabrics connect the the keep-alive feature in NVMe 1.2.1 we
   want to be able to use reserved requests.

Reviewed-by: Jay Freyensee <james.p.freyensee-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Tested-by: Ming Lin <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>
Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/nvme/host/core.c | 27 ++++++++++++++++++---------
 drivers/nvme/host/nvme.h |  5 +++--
 drivers/nvme/host/pci.c  |  4 ++--
 3 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f874c0e..bd04ec6 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -192,11 +192,16 @@ void nvme_requeue_req(struct request *req)
 EXPORT_SYMBOL_GPL(nvme_requeue_req);
 
 struct request *nvme_alloc_request(struct request_queue *q,
-		struct nvme_command *cmd, unsigned int flags)
+		struct nvme_command *cmd, unsigned int flags, int qid)
 {
 	struct request *req;
 
-	req = blk_mq_alloc_request(q, nvme_is_write(cmd), flags);
+	if (qid == NVME_QID_ANY) {
+		req = blk_mq_alloc_request(q, nvme_is_write(cmd), flags);
+	} else {
+		req = blk_mq_alloc_request_hctx(q, nvme_is_write(cmd), flags,
+				qid ? qid - 1 : 0);
+	}
 	if (IS_ERR(req))
 		return req;
 
@@ -324,12 +329,12 @@ EXPORT_SYMBOL_GPL(nvme_setup_cmd);
  */
 int __nvme_submit_sync_cmd(struct request_queue *q, struct nvme_command *cmd,
 		struct nvme_completion *cqe, void *buffer, unsigned bufflen,
-		unsigned timeout)
+		unsigned timeout, int qid, int at_head, int flags)
 {
 	struct request *req;
 	int ret;
 
-	req = nvme_alloc_request(q, cmd, 0);
+	req = nvme_alloc_request(q, cmd, flags, qid);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
@@ -342,17 +347,19 @@ int __nvme_submit_sync_cmd(struct request_queue *q, struct nvme_command *cmd,
 			goto out;
 	}
 
-	blk_execute_rq(req->q, NULL, req, 0);
+	blk_execute_rq(req->q, NULL, req, at_head);
 	ret = req->errors;
  out:
 	blk_mq_free_request(req);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(__nvme_submit_sync_cmd);
 
 int nvme_submit_sync_cmd(struct request_queue *q, struct nvme_command *cmd,
 		void *buffer, unsigned bufflen)
 {
-	return __nvme_submit_sync_cmd(q, cmd, NULL, buffer, bufflen, 0);
+	return __nvme_submit_sync_cmd(q, cmd, NULL, buffer, bufflen, 0,
+			NVME_QID_ANY, 0, 0);
 }
 EXPORT_SYMBOL_GPL(nvme_submit_sync_cmd);
 
@@ -370,7 +377,7 @@ int __nvme_submit_user_cmd(struct request_queue *q, struct nvme_command *cmd,
 	void *meta = NULL;
 	int ret;
 
-	req = nvme_alloc_request(q, cmd, 0);
+	req = nvme_alloc_request(q, cmd, 0, NVME_QID_ANY);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
@@ -520,7 +527,8 @@ int nvme_get_features(struct nvme_ctrl *dev, unsigned fid, unsigned nsid,
 	c.features.prp1 = cpu_to_le64(dma_addr);
 	c.features.fid = cpu_to_le32(fid);
 
-	ret = __nvme_submit_sync_cmd(dev->admin_q, &c, &cqe, NULL, 0, 0);
+	ret = __nvme_submit_sync_cmd(dev->admin_q, &c, &cqe, NULL, 0, 0,
+			NVME_QID_ANY, 0, 0);
 	if (ret >= 0)
 		*result = le32_to_cpu(cqe.result);
 	return ret;
@@ -539,7 +547,8 @@ int nvme_set_features(struct nvme_ctrl *dev, unsigned fid, unsigned dword11,
 	c.features.fid = cpu_to_le32(fid);
 	c.features.dword11 = cpu_to_le32(dword11);
 
-	ret = __nvme_submit_sync_cmd(dev->admin_q, &c, &cqe, NULL, 0, 0);
+	ret = __nvme_submit_sync_cmd(dev->admin_q, &c, &cqe, NULL, 0, 0,
+			NVME_QID_ANY, 0, 0);
 	if (ret >= 0)
 		*result = le32_to_cpu(cqe.result);
 	return ret;
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 282421f..68a67ac 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -231,8 +231,9 @@ void nvme_stop_queues(struct nvme_ctrl *ctrl);
 void nvme_start_queues(struct nvme_ctrl *ctrl);
 void nvme_kill_queues(struct nvme_ctrl *ctrl);
 
+#define NVME_QID_ANY -1
 struct request *nvme_alloc_request(struct request_queue *q,
-		struct nvme_command *cmd, unsigned int flags);
+		struct nvme_command *cmd, unsigned int flags, int qid);
 void nvme_requeue_req(struct request *req);
 int nvme_setup_cmd(struct nvme_ns *ns, struct request *req,
 		struct nvme_command *cmd);
@@ -240,7 +241,7 @@ int nvme_submit_sync_cmd(struct request_queue *q, struct nvme_command *cmd,
 		void *buf, unsigned bufflen);
 int __nvme_submit_sync_cmd(struct request_queue *q, struct nvme_command *cmd,
 		struct nvme_completion *cqe, void *buffer, unsigned bufflen,
-		unsigned timeout);
+		unsigned timeout, int qid, int at_head, int flags);
 int nvme_submit_user_cmd(struct request_queue *q, struct nvme_command *cmd,
 		void __user *ubuffer, unsigned bufflen, u32 *result,
 		unsigned timeout);
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index dc39924..db6fdee 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -901,7 +901,7 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req, bool reserved)
 		 req->tag, nvmeq->qid);
 
 	abort_req = nvme_alloc_request(dev->ctrl.admin_q, &cmd,
-			BLK_MQ_REQ_NOWAIT);
+			BLK_MQ_REQ_NOWAIT, NVME_QID_ANY);
 	if (IS_ERR(abort_req)) {
 		atomic_inc(&dev->ctrl.abort_limit);
 		return BLK_EH_RESET_TIMER;
@@ -1512,7 +1512,7 @@ static int nvme_delete_queue(struct nvme_queue *nvmeq, u8 opcode)
 	cmd.delete_queue.opcode = opcode;
 	cmd.delete_queue.qid = cpu_to_le16(nvmeq->qid);
 
-	req = nvme_alloc_request(q, &cmd, BLK_MQ_REQ_NOWAIT);
+	req = nvme_alloc_request(q, &cmd, BLK_MQ_REQ_NOWAIT, NVME_QID_ANY);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
