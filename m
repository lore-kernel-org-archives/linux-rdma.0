From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH 2/3] IB/srp: Enclose 14 expressions for the sizeof operator by
 parentheses
Date: Sat, 8 Apr 2017 14:12:38 +0200
Message-ID: <a7bdda64-7cd8-1107-9669-6ab0f70e16ad@users.sourceforge.net>
References: <50db1f1d-b689-1a9d-f6dd-a0f55169c75a@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50db1f1d-b689-1a9d-f6dd-a0f55169c75a-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Language: en-GB
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Sat, 8 Apr 2017 13:49:53 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script "checkpatch.pl" pointed information out like the following.

WARNING: sizeof … should be sizeof(…)

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index cf8cb7206983..bc934c5f1e36 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -213,8 +213,8 @@ static int srp_target_is_topspin(struct srp_target_port *target)
 	static const u8 cisco_oui[3]   = { 0x00, 0x1b, 0x0d };
 
 	return topspin_workarounds &&
-		(!memcmp(&target->ioc_guid, topspin_oui, sizeof topspin_oui) ||
-		 !memcmp(&target->ioc_guid, cisco_oui, sizeof cisco_oui));
+		(!memcmp(&target->ioc_guid, topspin_oui, sizeof(topspin_oui)) ||
+		 !memcmp(&target->ioc_guid, cisco_oui, sizeof(cisco_oui)));
 }
 
 static struct srp_iu *srp_alloc_iu(struct srp_host *host, size_t size,
@@ -223,7 +223,7 @@ static struct srp_iu *srp_alloc_iu(struct srp_host *host, size_t size,
 {
 	struct srp_iu *iu;
 
-	iu = kmalloc(sizeof *iu, gfp_mask);
+	iu = kmalloc(sizeof(*iu), gfp_mask);
 	if (!iu)
 		goto out;
 
@@ -272,7 +272,7 @@ static int srp_init_qp(struct srp_target_port *target,
 	struct ib_qp_attr *attr;
 	int ret;
 
-	attr = kmalloc(sizeof *attr, GFP_KERNEL);
+	attr = kmalloc(sizeof(*attr), GFP_KERNEL);
 	if (!attr)
 		return -ENOMEM;
 
@@ -488,7 +488,7 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 	const int m = 1 + dev->use_fast_reg * target->mr_per_cmd * 2;
 	int ret;
 
-	init_attr = kzalloc(sizeof *init_attr, GFP_KERNEL);
+	init_attr = kzalloc(sizeof(*init_attr), GFP_KERNEL);
 	if (!init_attr)
 		return -ENOMEM;
 
@@ -703,7 +703,7 @@ static int srp_send_req(struct srp_rdma_ch *ch, bool multich)
 	} *req = NULL;
 	int status;
 
-	req = kzalloc(sizeof *req, GFP_KERNEL);
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
 	if (!req)
 		return -ENOMEM;
 
@@ -713,7 +713,7 @@ static int srp_send_req(struct srp_rdma_ch *ch, bool multich)
 	req->param.qp_num		      = ch->qp->qp_num;
 	req->param.qp_type		      = ch->qp->qp_type;
 	req->param.private_data 	      = &req->priv;
-	req->param.private_data_len 	      = sizeof req->priv;
+	req->param.private_data_len	      = sizeof(req->priv);
 	req->param.flow_control 	      = 1;
 
 	get_random_bytes(&req->param.starting_psn, 4);
@@ -2164,7 +2164,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	scmnd->host_scribble = (void *) req;
 
 	cmd = iu->buf;
-	memset(cmd, 0, sizeof *cmd);
+	memset(cmd, 0, sizeof(*cmd));
 
 	cmd->opcode = SRP_CMD;
 	int_to_scsilun(scmnd->device->lun, &cmd->lun);
@@ -2347,7 +2347,7 @@ static void srp_cm_rep_handler(struct ib_cm_id *cm_id,
 	}
 
 	ret = -ENOMEM;
-	qp_attr = kmalloc(sizeof *qp_attr, GFP_KERNEL);
+	qp_attr = kmalloc(sizeof(*qp_attr), GFP_KERNEL);
 	if (!qp_attr)
 		goto error;
 
@@ -2575,10 +2575,10 @@ static int srp_send_tsk_mgmt(struct srp_rdma_ch *ch, u64 req_tag, u64 lun,
 		return -1;
 	}
 
-	ib_dma_sync_single_for_cpu(dev, iu->dma, sizeof *tsk_mgmt,
+	ib_dma_sync_single_for_cpu(dev, iu->dma, sizeof(*tsk_mgmt),
 				   DMA_TO_DEVICE);
 	tsk_mgmt = iu->buf;
-	memset(tsk_mgmt, 0, sizeof *tsk_mgmt);
+	memset(tsk_mgmt, 0, sizeof(*tsk_mgmt));
 
 	tsk_mgmt->opcode 	= SRP_TSK_MGMT;
 	int_to_scsilun(lun, &tsk_mgmt->lun);
@@ -2592,7 +2592,7 @@ static int srp_send_tsk_mgmt(struct srp_rdma_ch *ch, u64 req_tag, u64 lun,
 
 	init_completion(&ch->tsk_mgmt_done);
 
-	ib_dma_sync_single_for_device(dev, iu->dma, sizeof *tsk_mgmt,
+	ib_dma_sync_single_for_device(dev, iu->dma, sizeof(*tsk_mgmt),
 				      DMA_TO_DEVICE);
 	if (srp_post_send(ch, iu, sizeof(*tsk_mgmt))) {
 		srp_put_tx_iu(ch, iu, SRP_IU_TSK_MGMT);
@@ -3308,7 +3308,7 @@ static ssize_t srp_create_target(struct device *dev,
 	target_host->max_channel = 0;
 	target_host->max_id      = 1;
 	target_host->max_lun     = -1LL;
-	target_host->max_cmd_len = sizeof ((struct srp_cmd *) (void *) 0L)->cdb;
+	target_host->max_cmd_len = sizeof(((struct srp_cmd *)(void *)0L)->cdb);
 
 	target = host_to_target(target_host);
 
@@ -3535,7 +3535,7 @@ static struct srp_host *srp_add_port(struct srp_device *device, u8 port)
 {
 	struct srp_host *host;
 
-	host = kzalloc(sizeof *host, GFP_KERNEL);
+	host = kzalloc(sizeof(*host), GFP_KERNEL);
 	if (!host)
 		return NULL;
 
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
