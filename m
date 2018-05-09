From: =?UTF-8?q?H=C3=A5kon=20Bugge?= <Haakon.Bugge@oracle.com>
Subject: [PATCH IB/core 2/2] IB/cm: Send authentic pkey in REQ msg and check eligibility of the pkeys
Date: Wed,  9 May 2018 11:30:20 +0200
Message-ID: <20180509093020.24503-3-Haakon.Bugge@oracle.com>
References: <20180509093020.24503-1-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180509093020.24503-1-Haakon.Bugge@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Don Hiatt <don.hiatt@intel.com>, Ira Weiny <ira.weiny@intel.com>, Sean Hefty <sean.hefty@intel.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>
List-Id: linux-rdma@vger.kernel.org

There is no point in using RDMA CM to establish a connection between
two QPs that cannot possible communicate. Particularly, if both the
active and passive side use limited pkeys, they are not able to
communicate.

In order to detect this situation, the authentic pkey is used in the
CM REQ message. The authentic pkey is the one that the HCA inserts
into the BTH in the IB packets.

When the passive side receives the REQ, commit ("ib_core: A full pkey
is required to match a limited one") ensures that
ib_find_matched_cached_pkey() fails unless at least one of the pkeys
compared has the full-member bit.

In the limited-to-limited case, this will prohibit the connection to
be formed, and thus, Pkey Violation Traps will not be sent to the SM.

Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
---
 drivers/infiniband/core/cm.c | 39 ++++++++++++++++++++++++++++++++-------
 include/rdma/ib_cm.h         |  4 +++-
 2 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index a92e1a5c202b..52ed51d5bd2a 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2004 Topspin Corporation.  All rights reserved.
  * Copyright (c) 2004, 2005 Voltaire Corporation.  All rights reserved.
  * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2018 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -91,6 +92,7 @@ static const char * const ibcm_rej_reason_strs[] = {
 	[IB_CM_REJ_INVALID_CLASS_VERSION]	= "invalid class version",
 	[IB_CM_REJ_INVALID_FLOW_LABEL]		= "invalid flow label",
 	[IB_CM_REJ_INVALID_ALT_FLOW_LABEL]	= "invalid alt flow label",
+	[IB_CM_REJ_INVALID_PKEY]		= "invalid PKey",
 };
 
 const char *__attribute_const__ ibcm_reject_msg(int reason)
@@ -518,8 +520,8 @@ static int cm_init_av_by_path(struct sa_path_rec *path, struct cm_av *av,
 		return -EINVAL;
 	cm_dev = port->cm_dev;
 
-	ret = ib_find_cached_pkey(cm_dev->ib_device, port->port_num,
-				  be16_to_cpu(path->pkey), &av->pkey_index);
+	ret = ib_find_matched_cached_pkey(cm_dev->ib_device, port->port_num,
+					  be16_to_cpu(path->pkey), &av->pkey_index);
 	if (ret)
 		return ret;
 
@@ -1241,7 +1243,7 @@ static void cm_format_req(struct cm_req_msg *req_msg,
 	cm_req_set_starting_psn(req_msg, cpu_to_be32(param->starting_psn));
 	cm_req_set_local_resp_timeout(req_msg,
 				      param->local_cm_response_timeout);
-	req_msg->pkey = param->primary_path->pkey;
+	req_msg->pkey = cpu_to_be16(cm_id_priv->pkey);
 	cm_req_set_path_mtu(req_msg, param->primary_path->mtu);
 	cm_req_set_max_cm_retries(req_msg, param->max_cm_retries);
 
@@ -1396,7 +1398,23 @@ int ib_send_cm_req(struct ib_cm_id *cm_id,
 	cm_id_priv->responder_resources = param->responder_resources;
 	cm_id_priv->retry_count = param->retry_count;
 	cm_id_priv->path_mtu = param->primary_path->mtu;
-	cm_id_priv->pkey = param->primary_path->pkey;
+
+	/*
+	 * We want to send the pkey used in the BTH in packets
+	 * sent. This, in order for the passive side to determine if
+	 * communication is permitted by the respective pkeys.
+	 *
+	 * The pkey in the paths are derived from the MGID, which has
+	 * the full membership bit set. Hence, we retrieve the pkey by
+	 * using the address vector's pkey_index.
+	 */
+	ret = ib_get_cached_pkey(cm_id_priv->id.device,
+				 cm_id_priv->av.port->port_num,
+				 cm_id_priv->av.pkey_index,
+				 &cm_id_priv->pkey);
+	if (ret)
+		goto error1;
+
 	cm_id_priv->qp_type = param->qp_type;
 
 	ret = cm_alloc_msg(cm_id_priv, &cm_id_priv->msg);
@@ -1956,16 +1974,19 @@ static int cm_req_handler(struct cm_work *work)
 				 cm_id_priv);
 	if (ret) {
 		int err;
+		int rej_reason = (ret == -ENOENT ?
+				  IB_CM_REJ_INVALID_PKEY :
+				  IB_CM_REJ_INVALID_GID);
 
 		err = ib_get_cached_gid(work->port->cm_dev->ib_device,
 					work->port->port_num, 0,
 					&work->path[0].sgid,
 					NULL);
 		if (err)
-			ib_send_cm_rej(cm_id, IB_CM_REJ_INVALID_GID,
+			ib_send_cm_rej(cm_id, rej_reason,
 				       NULL, 0, NULL, 0);
 		else
-			ib_send_cm_rej(cm_id, IB_CM_REJ_INVALID_GID,
+			ib_send_cm_rej(cm_id, rej_reason,
 				       &work->path[0].sgid,
 				       sizeof(work->path[0].sgid),
 				       NULL, 0);
@@ -1975,7 +1996,11 @@ static int cm_req_handler(struct cm_work *work)
 		ret = cm_init_av_by_path(&work->path[1], &cm_id_priv->alt_av,
 					 cm_id_priv);
 		if (ret) {
-			ib_send_cm_rej(cm_id, IB_CM_REJ_INVALID_ALT_GID,
+			int rej_reason = (ret == -ENOENT ?
+					  IB_CM_REJ_INVALID_PKEY :
+					  IB_CM_REJ_INVALID_ALT_GID);
+
+			ib_send_cm_rej(cm_id, rej_reason,
 				       &work->path[0].sgid,
 				       sizeof(work->path[0].sgid), NULL, 0);
 			goto rejected;
diff --git a/include/rdma/ib_cm.h b/include/rdma/ib_cm.h
index 7979cb04f529..56b62303946a 100644
--- a/include/rdma/ib_cm.h
+++ b/include/rdma/ib_cm.h
@@ -3,6 +3,7 @@
  * Copyright (c) 2004 Topspin Corporation.  All rights reserved.
  * Copyright (c) 2004 Voltaire Corporation.  All rights reserved.
  * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2018 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -183,7 +184,8 @@ enum ib_cm_rej_reason {
 	IB_CM_REJ_DUPLICATE_LOCAL_COMM_ID	= 30,
 	IB_CM_REJ_INVALID_CLASS_VERSION		= 31,
 	IB_CM_REJ_INVALID_FLOW_LABEL		= 32,
-	IB_CM_REJ_INVALID_ALT_FLOW_LABEL	= 33
+	IB_CM_REJ_INVALID_ALT_FLOW_LABEL	= 33,
+	IB_CM_REJ_INVALID_PKEY			= 34,
 };
 
 struct ib_cm_rej_event_param {
-- 
2.13.6
