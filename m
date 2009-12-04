From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH]uDAPL v2 - ucm, scm: DAPL_GLOBAL_ROUTING enabled causes segv
Date: Fri, 4 Dec 2009 14:34:55 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C98361E0FFD1@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


socket cm and ud cm providers support QP modify with is_global
set and GRH. New v2 providers didn't pass GID information
in modify_qp RTR call and incorrectly byte swapped the already
network order GID. Add debug print of GID during global modify.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/qp.c |    9 +++++++--
 dapl/openib_scm/cm.c    |    4 ++--
 dapl/openib_ucm/cm.c    |    4 ++--
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/dapl/openib_common/qp.c b/dapl/openib_common/qp.c
index 143098e..eec5bf2 100644
--- a/dapl/openib_common/qp.c
+++ b/dapl/openib_common/qp.c
@@ -399,11 +399,16 @@ dapls_modify_qp_state(IN ib_qp_handle_t		qp_handle,
 		/* address handle. RC and UD */
 		qp_attr.ah_attr.dlid = ntohs(lid);
 		if (ia_ptr->hca_ptr->ib_trans.global) {
+			dapl_dbg_log(DAPL_DBG_TYPE_EP, 
+				     " QPS_RTR: GID Subnet 0x" F64x " ID 0x" F64x "\n", 
+				     (unsigned long long)htonll(gid->global.subnet_prefix),
+				     (unsigned long long)htonll(gid->global.interface_id));
+
 			qp_attr.ah_attr.is_global = 1;
 			qp_attr.ah_attr.grh.dgid.global.subnet_prefix = 
-				ntohll(gid->global.subnet_prefix);
+				gid->global.subnet_prefix;
 			qp_attr.ah_attr.grh.dgid.global.interface_id = 
-				ntohll(gid->global.interface_id);
+				gid->global.interface_id;
 			qp_attr.ah_attr.grh.hop_limit =
 				ia_ptr->hca_ptr->ib_trans.hop_limit;
 			qp_attr.ah_attr.grh.traffic_class =
diff --git a/dapl/openib_scm/cm.c b/dapl/openib_scm/cm.c
index 3201c9a..759e926 100644
--- a/dapl/openib_scm/cm.c
+++ b/dapl/openib_scm/cm.c
@@ -732,7 +732,7 @@ static void dapli_socket_connect_rtu(dp_ib_cm_handle_t cm_ptr)
 				  IBV_QPS_RTR, 
 				  cm_ptr->msg.saddr.ib.qpn,
 				  cm_ptr->msg.saddr.ib.lid,
-				  NULL) != DAT_SUCCESS) {
+				  (ib_gid_handle_t)cm_ptr->msg.saddr.ib.gid) != DAT_SUCCESS) {
 		dapl_log(DAPL_DBG_TYPE_ERR,
 			 " CONN_RTU: QPS_RTR ERR %s (%d,%d,%x,%x,%x) -> %s %x\n",
 			 strerror(errno), ep_ptr->qp_handle->qp_type,
@@ -1107,7 +1107,7 @@ dapli_socket_accept_usr(DAPL_EP * ep_ptr,
 				  IBV_QPS_RTR, 
 				  cm_ptr->msg.saddr.ib.qpn,
 				  cm_ptr->msg.saddr.ib.lid,
-				  NULL) != DAT_SUCCESS) {
+				  (ib_gid_handle_t)cm_ptr->msg.saddr.ib.gid) != DAT_SUCCESS) {
 		dapl_log(DAPL_DBG_TYPE_ERR,
 			 " ACCEPT_USR: QPS_RTR ERR %s -> %s\n",
 			 strerror(errno), 
diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index b51556a..f5459c0 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -1019,7 +1019,7 @@ static void ucm_connect_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 				  IBV_QPS_RTR, 
 				  cm->msg.daddr.ib.qpn,
 				  cm->msg.daddr.ib.lid,
-				  NULL) != DAT_SUCCESS) {
+				  (ib_gid_handle_t)cm->msg.daddr.ib.gid) != DAT_SUCCESS) {
 		dapl_log(DAPL_DBG_TYPE_ERR,
 			 " CONN_RTU: QPS_RTR ERR %s <- lid %x iqp %x\n",
 			 strerror(errno), ntohs(cm->msg.daddr.ib.lid),
@@ -1417,7 +1417,7 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
 				  IBV_QPS_RTR, 
 				  cm->msg.daddr.ib.qpn,
 				  cm->msg.daddr.ib.lid,
-				  NULL) != DAT_SUCCESS) {
+				  (ib_gid_handle_t)cm->msg.daddr.ib.gid) != DAT_SUCCESS) {
 		dapl_log(DAPL_DBG_TYPE_ERR,
 			 " ACCEPT_USR: QPS_RTR ERR %s -> lid %x qpn %x\n",
 			 strerror(errno), ntohs(cm->msg.daddr.ib.lid),
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
