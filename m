From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 20/28] IB/srpt: Add P_Key support
Date: Wed,  3 Jan 2018 13:39:30 -0800
Message-ID: <20180103213938.11664-21-bart.vanassche@wdc.com>
References: <20180103213938.11664-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180103213938.11664-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Process connection requests that use another P_Key than the default
correctly.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 14 +++++++++++---
 drivers/infiniband/ulp/srpt/ib_srpt.h |  2 ++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 323d55e6daf1..eeeb47739e9a 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -41,6 +41,7 @@
 #include <linux/string.h>
 #include <linux/delay.h>
 #include <linux/atomic.h>
+#include <rdma/ib_cache.h>
 #include <scsi/scsi_proto.h>
 #include <scsi/scsi_tcq.h>
 #include <target/target_core_base.h>
@@ -1009,7 +1010,12 @@ static int srpt_init_ch_qp(struct srpt_rdma_ch *ch, struct ib_qp *qp)
 	attr->qp_state = IB_QPS_INIT;
 	attr->qp_access_flags = IB_ACCESS_LOCAL_WRITE;
 	attr->port_num = ch->sport->port;
-	attr->pkey_index = 0;
+
+	ret = ib_find_cached_pkey(ch->sport->sdev->device, ch->sport->port,
+				  ch->pkey, &attr->pkey_index);
+	if (ret < 0)
+		pr_err("Translating pkey %#x failed (%d) - using index 0\n",
+		       ch->pkey, ret);
 
 	ret = ib_modify_qp(qp, attr,
 			   IB_QP_STATE | IB_QP_ACCESS_FLAGS | IB_QP_PORT |
@@ -1926,9 +1932,10 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 
 	it_iu_len = be32_to_cpu(req->req_it_iu_len);
 
-	pr_info("Received SRP_LOGIN_REQ with i_port_id %pI6, t_port_id %pI6 and it_iu_len %d on port %d (guid=%pI6)\n",
+	pr_info("Received SRP_LOGIN_REQ with i_port_id %pI6, t_port_id %pI6 and it_iu_len %d on port %d (guid=%pI6); pkey %#04x\n",
 		req->initiator_port_id, req->target_port_id, it_iu_len,
-		param->port, &sport->gid);
+		param->port, &sport->gid,
+		be16_to_cpu(param->primary_path->pkey));
 
 	rsp = kzalloc(sizeof(*rsp), GFP_KERNEL);
 	rej = kzalloc(sizeof(*rej), GFP_KERNEL);
@@ -2005,6 +2012,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 
 	init_rcu_head(&ch->rcu);
 	kref_init(&ch->kref);
+	ch->pkey = be16_to_cpu(param->primary_path->pkey);
 	ch->zw_cqe.done = srpt_zerolength_write_done;
 	INIT_WORK(&ch->release_work, srpt_release_channel_work);
 	memcpy(ch->i_port_id, req->initiator_port_id, 16);
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 0c68bee6ba1b..dd44e51fa167 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -266,6 +266,7 @@ enum rdma_ch_state {
  * @cmd_wait_list: List of SCSI commands that arrived before the RTU event. This
  *                 list contains struct srpt_ioctx elements and is protected
  *                 against concurrent modification by the cm_id spinlock.
+ * @pkey:          P_Key of the IB partition for this SRP channel.
  * @sess:          Session information associated with this SRP channel.
  * @sess_name:     Session name.
  * @ini_guid:      Initiator port GUID.
@@ -294,6 +295,7 @@ struct srpt_rdma_ch {
 	struct srpt_recv_ioctx	**ioctx_recv_ring;
 	struct list_head	list;
 	struct list_head	cmd_wait_list;
+	uint16_t		pkey;
 	struct se_session	*sess;
 	u8			sess_name[36];
 	u8			ini_guid[24];
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
