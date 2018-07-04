From: =?UTF-8?q?H=C3=A5kon=20Bugge?= <Haakon.Bugge@oracle.com>
Subject: [PATCH] IB/cm: Remove unused and erroneous msg sequence encoding
Date: Wed,  4 Jul 2018 12:48:01 +0200
Message-ID: <20180704104801.912482-1-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Don Hiatt <don.hiatt@intel.com>, Ira Weiny <ira.weiny@intel.com>, Sean Hefty <sean.hefty@intel.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>
List-Id: linux-rdma@vger.kernel.org

In cm_form_tid(), a two bit message sequence number is OR'ed into bit
31-30 of the lower TID value.

After commit f06d26537559 ("IB/cm: Randomize starting comm ID"), the
local_id is XOR'ed with a 32-bit random value. Hence, bit 31-30 in the
lower TID now has an arbitrarily value and it makes no sense to OR in
the message sequence number.

Adding to that, the evolution in use of IDR routines in cm_alloc_id()
has always had the possibility of returning a value with bit 30 set.

In addition, said bits are never checked.

Hence, remove the encoding and the corresponding enum.

Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
---
 drivers/infiniband/core/cm.c      | 14 ++++++--------
 drivers/infiniband/core/cm_msgs.h |  7 -------
 2 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index de699f67a755..4724cb09b69d 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1256,14 +1256,12 @@ struct ib_cm_id *ib_cm_insert_listen(struct ib_device *device,
 }
 EXPORT_SYMBOL(ib_cm_insert_listen);
 
-static __be64 cm_form_tid(struct cm_id_private *cm_id_priv,
-			  enum cm_msg_sequence msg_seq)
+static __be64 cm_form_tid(struct cm_id_private *cm_id_priv)
 {
 	u64 hi_tid, low_tid;
 
 	hi_tid   = ((u64) cm_id_priv->av.port->mad_agent->hi_tid) << 32;
-	low_tid  = (u64) ((__force u32)cm_id_priv->id.local_id |
-			  (msg_seq << 30));
+	low_tid  = (u64)cm_id_priv->id.local_id;
 	return cpu_to_be64(hi_tid | low_tid);
 }
 
@@ -1291,7 +1289,7 @@ static void cm_format_req(struct cm_req_msg *req_msg,
 					      pri_path->opa.slid);
 
 	cm_format_mad_hdr(&req_msg->hdr, CM_REQ_ATTR_ID,
-			  cm_form_tid(cm_id_priv, CM_MSG_SEQUENCE_REQ));
+			  cm_form_tid(cm_id_priv));
 
 	req_msg->local_comm_id = cm_id_priv->id.local_id;
 	req_msg->service_id = param->service_id;
@@ -2465,7 +2463,7 @@ static void cm_format_dreq(struct cm_dreq_msg *dreq_msg,
 			  u8 private_data_len)
 {
 	cm_format_mad_hdr(&dreq_msg->hdr, CM_DREQ_ATTR_ID,
-			  cm_form_tid(cm_id_priv, CM_MSG_SEQUENCE_DREQ));
+			  cm_form_tid(cm_id_priv));
 	dreq_msg->local_comm_id = cm_id_priv->id.local_id;
 	dreq_msg->remote_comm_id = cm_id_priv->id.remote_id;
 	cm_dreq_set_remote_qpn(dreq_msg, cm_id_priv->remote_qpn);
@@ -3096,7 +3094,7 @@ static void cm_format_lap(struct cm_lap_msg *lap_msg,
 		alt_ext = opa_is_extended_lid(alternate_path->opa.dlid,
 					      alternate_path->opa.slid);
 	cm_format_mad_hdr(&lap_msg->hdr, CM_LAP_ATTR_ID,
-			  cm_form_tid(cm_id_priv, CM_MSG_SEQUENCE_LAP));
+			  cm_form_tid(cm_id_priv));
 	lap_msg->local_comm_id = cm_id_priv->id.local_id;
 	lap_msg->remote_comm_id = cm_id_priv->id.remote_id;
 	cm_lap_set_remote_qpn(lap_msg, cm_id_priv->remote_qpn);
@@ -3472,7 +3470,7 @@ static void cm_format_sidr_req(struct cm_sidr_req_msg *sidr_req_msg,
 			       struct ib_cm_sidr_req_param *param)
 {
 	cm_format_mad_hdr(&sidr_req_msg->hdr, CM_SIDR_REQ_ATTR_ID,
-			  cm_form_tid(cm_id_priv, CM_MSG_SEQUENCE_SIDR));
+			  cm_form_tid(cm_id_priv));
 	sidr_req_msg->request_id = cm_id_priv->id.local_id;
 	sidr_req_msg->pkey = param->path->pkey;
 	sidr_req_msg->service_id = param->service_id;
diff --git a/drivers/infiniband/core/cm_msgs.h b/drivers/infiniband/core/cm_msgs.h
index 8b76f0ef965e..476d4309576d 100644
--- a/drivers/infiniband/core/cm_msgs.h
+++ b/drivers/infiniband/core/cm_msgs.h
@@ -44,13 +44,6 @@
 
 #define IB_CM_CLASS_VERSION	2 /* IB specification 1.2 */
 
-enum cm_msg_sequence {
-	CM_MSG_SEQUENCE_REQ,
-	CM_MSG_SEQUENCE_LAP,
-	CM_MSG_SEQUENCE_DREQ,
-	CM_MSG_SEQUENCE_SIDR
-};
-
 struct cm_req_msg {
 	struct ib_mad_hdr hdr;
 
-- 
2.14.3
