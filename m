From: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Subject: [PATCH] IBcore/CM: Issue DREQ when receiving REQ/REP for stale QP
Date: Fri, 28 Oct 2016 13:14:29 +0200
Message-ID: <1477653269-27359-1-git-send-email-hans.westgaard.ry@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Matan Barak <matanb@mellanox.com>, Erez Shitrit <erezsh@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Ira Weiny <ira.weiny@intel.com>, Or Gerlitz <ogerlitz@mellanox.com>, Hakon Bugge <haakon.bugge@oracle.com>, Yuval Shaia <yuval.shaia@oracle.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

from "InfiBand Architecture Specifications Volume 1":

  A QP is said to have a stale connection when only one side has
  connection information. A stale connection may result if the remote CM
  had dropped the connection and sent a DREQ but the DREQ was never
  received by the local CM. Alternatively the remote CM may have lost
  all record of past connections because its node crashed and rebooted,
  while the local CM did not become aware of the remote node's reboot
  and therefore did not clean up stale connections.

and:

   A local CM may receive a REQ/REP for a stale connection. It shall
   abort the connection issuing REJ to the REQ/REP. It shall then issue
   DREQ with "DREQ:remote QPN” set to the remote QPN from the REQ/REP.

This patch solves a problem with reuse of QPN. Current codebase, that
is IPoIB, relies on a REAP-mechanism to do cleanup of the structures
in CM. A problem with this is the timeconstants governing this
mechanism; they are up to 768 seconds and the interface may look
inresponsive in that period.  Issuing a DREQ (and receiving a DREP)
does the necessary cleanup and the interface comes up.

Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
---
 drivers/infiniband/core/cm.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index c995255..c97e4d5 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1519,6 +1519,7 @@ static struct cm_id_private * cm_match_req(struct cm_work *work,
 	struct cm_id_private *listen_cm_id_priv, *cur_cm_id_priv;
 	struct cm_timewait_info *timewait_info;
 	struct cm_req_msg *req_msg;
+	struct ib_cm_id *cm_id;
 
 	req_msg = (struct cm_req_msg *)work->mad_recv_wc->recv_buf.mad;
 
@@ -1540,10 +1541,18 @@ static struct cm_id_private * cm_match_req(struct cm_work *work,
 	timewait_info = cm_insert_remote_qpn(cm_id_priv->timewait_info);
 	if (timewait_info) {
 		cm_cleanup_timewait(cm_id_priv->timewait_info);
+		cur_cm_id_priv = cm_get_id(timewait_info->work.local_id,
+					   timewait_info->work.remote_id);
+
 		spin_unlock_irq(&cm.lock);
 		cm_issue_rej(work->port, work->mad_recv_wc,
 			     IB_CM_REJ_STALE_CONN, CM_MSG_RESPONSE_REQ,
 			     NULL, 0);
+		if (cur_cm_id_priv) {
+			cm_id = &cur_cm_id_priv->id;
+			ib_send_cm_dreq(cm_id, NULL, 0);
+			cm_deref_id(cur_cm_id_priv);
+		}
 		return NULL;
 	}
 
@@ -1919,6 +1928,9 @@ static int cm_rep_handler(struct cm_work *work)
 	struct cm_id_private *cm_id_priv;
 	struct cm_rep_msg *rep_msg;
 	int ret;
+	struct cm_id_private *cur_cm_id_priv;
+	struct ib_cm_id *cm_id;
+	struct cm_timewait_info *timewait_info;
 
 	rep_msg = (struct cm_rep_msg *)work->mad_recv_wc->recv_buf.mad;
 	cm_id_priv = cm_acquire_id(rep_msg->remote_comm_id, 0);
@@ -1953,16 +1965,26 @@ static int cm_rep_handler(struct cm_work *work)
 		goto error;
 	}
 	/* Check for a stale connection. */
-	if (cm_insert_remote_qpn(cm_id_priv->timewait_info)) {
+	timewait_info = cm_insert_remote_qpn(cm_id_priv->timewait_info);
+	if (timewait_info) {
 		rb_erase(&cm_id_priv->timewait_info->remote_id_node,
 			 &cm.remote_id_table);
 		cm_id_priv->timewait_info->inserted_remote_id = 0;
+		cur_cm_id_priv = cm_get_id(timewait_info->work.local_id,
+					   timewait_info->work.remote_id);
+
 		spin_unlock(&cm.lock);
 		spin_unlock_irq(&cm_id_priv->lock);
 		cm_issue_rej(work->port, work->mad_recv_wc,
 			     IB_CM_REJ_STALE_CONN, CM_MSG_RESPONSE_REP,
 			     NULL, 0);
 		ret = -EINVAL;
+		if (cur_cm_id_priv) {
+			cm_id = &cur_cm_id_priv->id;
+			ib_send_cm_dreq(cm_id, NULL, 0);
+			cm_deref_id(cur_cm_id_priv);
+		}
+
 		goto error;
 	}
 	spin_unlock(&cm.lock);
-- 
2.7.4
