From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v3 4/5] IB/srp: Refactor srp_send_req()
Date: Mon,  8 Jan 2018 15:14:35 -0800
Message-ID: <20180108231436.19750-5-bart.vanassche@wdc.com>
References: <20180108231436.19750-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108231436.19750-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch does not change any functionality but makes the next
patch in this series easier to read.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 65 +++++++++++++++++++------------------
 1 file changed, 34 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index fec6e800adf4..9472f5989d27 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -738,35 +738,21 @@ static int srp_send_req(struct srp_rdma_ch *ch, bool multich)
 		struct ib_cm_req_param param;
 		struct srp_login_req   priv;
 	} *req = NULL;
+	char *ipi, *tpi;
 	int status;
-	u8 subnet_timeout;
-
-	subnet_timeout = srp_get_subnet_timeout(target->srp_host);
 
 	req = kzalloc(sizeof *req, GFP_KERNEL);
 	if (!req)
 		return -ENOMEM;
 
-	req->param.primary_path		      = &ch->path;
-	req->param.alternate_path 	      = NULL;
-	req->param.service_id 		      = target->service_id;
-	req->param.qp_num		      = ch->qp->qp_num;
-	req->param.qp_type		      = ch->qp->qp_type;
-	req->param.private_data 	      = &req->priv;
-	req->param.private_data_len 	      = sizeof req->priv;
 	req->param.flow_control 	      = 1;
-
-	get_random_bytes(&req->param.starting_psn, 4);
-	req->param.starting_psn 	     &= 0xffffff;
+	req->param.retry_count                = target->tl_retry_count;
 
 	/*
 	 * Pick some arbitrary defaults here; we could make these
 	 * module parameters if anyone cared about setting them.
 	 */
 	req->param.responder_resources	      = 4;
-	req->param.remote_cm_response_timeout = subnet_timeout + 2;
-	req->param.local_cm_response_timeout  = subnet_timeout + 2;
-	req->param.retry_count                = target->tl_retry_count;
 	req->param.rnr_retry_count 	      = 7;
 	req->param.max_cm_retries 	      = 15;
 
@@ -777,6 +763,28 @@ static int srp_send_req(struct srp_rdma_ch *ch, bool multich)
 					      SRP_BUF_FORMAT_INDIRECT);
 	req->priv.req_flags	= (multich ? SRP_MULTICHAN_MULTI :
 				   SRP_MULTICHAN_SINGLE);
+
+	{
+		u8 subnet_timeout;
+
+		subnet_timeout = srp_get_subnet_timeout(target->srp_host);
+
+		req->param.primary_path = &ch->path;
+		req->param.alternate_path = NULL;
+		req->param.service_id = target->service_id;
+		get_random_bytes(&req->param.starting_psn, 4);
+		req->param.starting_psn &= 0xffffff;
+		req->param.qp_num = ch->qp->qp_num;
+		req->param.qp_type = ch->qp->qp_type;
+		req->param.local_cm_response_timeout = subnet_timeout + 2;
+		req->param.remote_cm_response_timeout = subnet_timeout + 2;
+		req->param.private_data = &req->priv;
+		req->param.private_data_len = sizeof(req->priv);
+
+		ipi = req->priv.initiator_port_id;
+		tpi = req->priv.target_port_id;
+	}
+
 	/*
 	 * In the published SRP specification (draft rev. 16a), the
 	 * port identifier format is 8 bytes of ID extension followed
@@ -787,19 +795,15 @@ static int srp_send_req(struct srp_rdma_ch *ch, bool multich)
 	 * recognized by the I/O Class they report.
 	 */
 	if (target->io_class == SRP_REV10_IB_IO_CLASS) {
-		memcpy(req->priv.initiator_port_id,
-		       &target->sgid.global.interface_id, 8);
-		memcpy(req->priv.initiator_port_id + 8,
-		       &target->initiator_ext, 8);
-		memcpy(req->priv.target_port_id,     &target->ioc_guid, 8);
-		memcpy(req->priv.target_port_id + 8, &target->id_ext, 8);
+		memcpy(ipi,     &target->sgid.global.interface_id, 8);
+		memcpy(ipi + 8, &target->initiator_ext, 8);
+		memcpy(tpi,     &target->ioc_guid, 8);
+		memcpy(tpi + 8, &target->id_ext, 8);
 	} else {
-		memcpy(req->priv.initiator_port_id,
-		       &target->initiator_ext, 8);
-		memcpy(req->priv.initiator_port_id + 8,
-		       &target->sgid.global.interface_id, 8);
-		memcpy(req->priv.target_port_id,     &target->id_ext, 8);
-		memcpy(req->priv.target_port_id + 8, &target->ioc_guid, 8);
+		memcpy(ipi,     &target->initiator_ext, 8);
+		memcpy(ipi + 8, &target->sgid.global.interface_id, 8);
+		memcpy(tpi,     &target->id_ext, 8);
+		memcpy(tpi + 8, &target->ioc_guid, 8);
 	}
 
 	/*
@@ -812,9 +816,8 @@ static int srp_send_req(struct srp_rdma_ch *ch, bool multich)
 			     PFX "Topspin/Cisco initiator port ID workaround "
 			     "activated for target GUID %016llx\n",
 			     be64_to_cpu(target->ioc_guid));
-		memset(req->priv.initiator_port_id, 0, 8);
-		memcpy(req->priv.initiator_port_id + 8,
-		       &target->srp_host->srp_dev->dev->node_guid, 8);
+		memset(ipi, 0, 8);
+		memcpy(ipi + 8, &target->srp_host->srp_dev->dev->node_guid, 8);
 	}
 
 	status = ib_send_cm_req(ch->cm_id, &req->param);
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
