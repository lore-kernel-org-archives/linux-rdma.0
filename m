From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 13/14] IB/srpt: Move the code for parsing struct ib_cm_req_event_param
Date: Tue, 16 Jan 2018 16:14:17 -0800
Message-ID: <20180117001418.7852-14-bart.vanassche@wdc.com>
References: <20180117001418.7852-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180117001418.7852-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch does not change any functionality but makes srpt_cm_req_recv()
independent of the IB/CM and hence simplifies the patch that introduces
RDMA/CM support.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 49 +++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index f066fac19f13..bf37816a1b12 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2028,20 +2028,22 @@ static void srpt_release_channel_work(struct work_struct *w)
 /**
  * srpt_cm_req_recv - process the event IB_CM_REQ_RECEIVED
  * @cm_id: IB/CM connection identifier.
- * @param: IB/CM REQ parameters.
- * @private_data: IB/CM REQ private data.
+ * @port_num: Port through which the IB/CM REQ message was received.
+ * @pkey: P_Key of the incoming connection.
+ * @req: SRP login request.
+ * @src_addr: GID of the port that submitted the login request.
  *
  * Ownership of the cm_id is transferred to the target session if this
  * functions returns zero. Otherwise the caller remains the owner of cm_id.
  */
 static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
-			    struct ib_cm_req_event_param *param,
-			    void *private_data)
+			    u8 port_num, __be16 pkey,
+			    const struct srp_login_req *req,
+			    const char *src_addr)
 {
 	struct srpt_device *sdev = cm_id->context;
-	struct srpt_port *sport = &sdev->port[param->port - 1];
+	struct srpt_port *sport = &sdev->port[port_num - 1];
 	struct srpt_nexus *nexus;
-	struct srp_login_req *req;
 	struct srp_login_rsp *rsp = NULL;
 	struct srp_login_rej *rej = NULL;
 	struct ib_cm_rep_param *rep_param = NULL;
@@ -2052,17 +2054,14 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 
 	WARN_ON_ONCE(irqs_disabled());
 
-	if (WARN_ON(!sdev || !private_data))
+	if (WARN_ON(!sdev || !req))
 		return -EINVAL;
 
-	req = (struct srp_login_req *)private_data;
-
 	it_iu_len = be32_to_cpu(req->req_it_iu_len);
 
 	pr_info("Received SRP_LOGIN_REQ with i_port_id %pI6, t_port_id %pI6 and it_iu_len %d on port %d (guid=%pI6); pkey %#04x\n",
 		req->initiator_port_id, req->target_port_id, it_iu_len,
-		param->port, &sport->gid,
-		be16_to_cpu(param->primary_path->pkey));
+		port_num, &sport->gid, be16_to_cpu(pkey));
 
 	nexus = srpt_get_nexus(sport, req->initiator_port_id,
 			       req->target_port_id);
@@ -2090,7 +2089,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	if (!sport->enabled) {
 		rej->reason = cpu_to_be32(SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
 		pr_info("rejected SRP_LOGIN_REQ because target port %s_%d has not yet been enabled\n",
-			sport->sdev->device->name, param->port);
+			sport->sdev->device->name, port_num);
 		goto reject;
 	}
 
@@ -2113,11 +2112,11 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 
 	init_rcu_head(&ch->rcu);
 	kref_init(&ch->kref);
-	ch->pkey = be16_to_cpu(param->primary_path->pkey);
+	ch->pkey = be16_to_cpu(pkey);
 	ch->nexus = nexus;
 	ch->zw_cqe.done = srpt_zerolength_write_done;
 	INIT_WORK(&ch->release_work, srpt_release_channel_work);
-	ch->sport = &sdev->port[param->port - 1];
+	ch->sport = sport;
 	ch->ib_cm.cm_id = cm_id;
 	cm_id->context = ch;
 	/*
@@ -2169,8 +2168,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		goto free_recv_ring;
 	}
 
-	srpt_format_guid(ch->sess_name, sizeof(ch->sess_name),
-			 &param->primary_path->dgid.global.interface_id);
+	strlcpy(ch->sess_name, src_addr, sizeof(ch->sess_name));
 	snprintf(i_port_id, sizeof(i_port_id), "0x%016llx%016llx",
 			be64_to_cpu(*(__be64 *)nexus->i_port_id),
 			be64_to_cpu(*(__be64 *)(nexus->i_port_id + 8)));
@@ -2224,7 +2222,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		rej->reason = cpu_to_be32(
 				SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
 		pr_info("rejected SRP_LOGIN_REQ because target %s_%d is not enabled\n",
-			sdev->device->name, param->port);
+			sdev->device->name, port_num);
 		mutex_unlock(&sport->mutex);
 		goto reject;
 	}
@@ -2327,6 +2325,19 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	return ret;
 }
 
+static int srpt_ib_cm_req_recv(struct ib_cm_id *cm_id,
+			       struct ib_cm_req_event_param *param,
+			       void *private_data)
+{
+	char sguid[40];
+
+	srpt_format_guid(sguid, sizeof(sguid),
+			 &param->primary_path->dgid.global.interface_id);
+
+	return srpt_cm_req_recv(cm_id, param->port, param->primary_path->pkey,
+				private_data, sguid);
+}
+
 static void srpt_cm_rej_recv(struct srpt_rdma_ch *ch,
 			     enum ib_cm_rej_reason reason,
 			     const u8 *private_data,
@@ -2401,8 +2412,8 @@ static int srpt_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 	ret = 0;
 	switch (event->event) {
 	case IB_CM_REQ_RECEIVED:
-		ret = srpt_cm_req_recv(cm_id, &event->param.req_rcvd,
-				       event->private_data);
+		ret = srpt_ib_cm_req_recv(cm_id, &event->param.req_rcvd,
+					  event->private_data);
 		break;
 	case IB_CM_REJ_RECEIVED:
 		srpt_cm_rej_recv(ch, event->param.rej_rcvd.reason,
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
