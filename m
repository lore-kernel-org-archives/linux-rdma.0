From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [[PATCH 11/11] ucm: using UD type QP's, ucm reports wrong reject
 event when user rejects AH resolution request.
Date: Fri, 16 Oct 2009 16:52:56 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C9835ECA1CCF@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


During rejects, both usr and ucm internal, the qp_type does not get initialized
so the check for UD type QP messages fail on active side and the wrong
event gets generated. Initialize saddr.ib information before sending reject
back to active side.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_ucm/cm.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index 7ce3aab..cc480c4 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -304,6 +304,13 @@ static int ucm_reject(ib_hca_transport_t *tp, ib_cm_msg_t *msg)
 	smsg.sqpn = msg->dqpn;
 
 	dapl_os_memcpy(&smsg.daddr, &msg->saddr, sizeof(union dcm_addr));
+	
+	/* no dst_addr IB info in REQ, init lid, gid, get type from saddr */
+	smsg.saddr.ib.lid = tp->addr.ib.lid; 
+	smsg.saddr.ib.qp_type = msg->saddr.ib.qp_type;
+	dapl_os_memcpy(&smsg.saddr.ib.gid[0],
+		       &tp->addr.ib.gid, 16); 
+
 	dapl_os_memcpy(&smsg.saddr, &msg->daddr, sizeof(union dcm_addr));
 
 	dapl_dbg_log(DAPL_DBG_TYPE_CM, 
@@ -1736,10 +1743,11 @@ dapls_ib_reject_connection(IN dp_ib_cm_handle_t cm,
         if (psize > DCM_MAX_PDATA_SIZE)
                 return DAT_LENGTH_ERROR;
 
-	/* cr_thread will destroy CR, update saddr lid, gid info */
+	/* cr_thread will destroy CR, update saddr lid, gid, qp_type info */
 	dapl_os_lock(&cm->lock);
 	cm->state = DCM_REJECTED;
 	cm->msg.saddr.ib.lid = cm->hca->ib_trans.addr.ib.lid; 
+	cm->msg.saddr.ib.qp_type = cm->msg.daddr.ib.qp_type;
 	dapl_os_memcpy(&cm->msg.saddr.ib.gid[0],
 		       &cm->hca->ib_trans.addr.ib.gid, 16); 
 	cm->msg.op = htons(DCM_REJ_USER);
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
