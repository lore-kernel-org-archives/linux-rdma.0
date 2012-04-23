From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/15] uDAPL v2.0 scm: fix retry count on connection pending
 timeout
Date: Mon, 23 Apr 2012 20:00:59 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F948120269@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Retry count not being decremented on connection TIMEOUT.
Also, cleanup log messages on CONN and REP pending and
add local port to output.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_scm/cm.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/dapl/openib_scm/cm.c b/dapl/openib_scm/cm.c
index a34965b..cac6a72 100644
--- a/dapl/openib_scm/cm.c
+++ b/dapl/openib_scm/cm.c
@@ -505,19 +505,18 @@ static void dapli_socket_connected(dp_ib_cm_handle_t cm_ptr, int err)
 	struct dapl_ep *ep_ptr = cm_ptr->ep;
 
 	if (err) {
-		dapl_log(DAPL_DBG_TYPE_WARN,
-			 " CONN_REQUEST: %s ERR %s -> %s %d - %s %d\n",
+		dapl_log(DAPL_DBG_TYPE_CM_WARN,
+			 " CONN_PENDING: %s ERR %s -> %s PORT L-%x R-%x %s cnt=%d\n",
 			 err == -1 ? "POLL" : "SOCKOPT",
 			 err == -1 ? strerror(dapl_socket_errno()) : strerror(err), 
-			 inet_ntoa(((struct sockaddr_in *)
-				&cm_ptr->addr)->sin_addr), 
-			 ntohs(((struct sockaddr_in *)
-				&cm_ptr->addr)->sin_port),
+			 inet_ntoa(((struct sockaddr_in *)&cm_ptr->addr)->sin_addr),
+			 ntohs(((struct sockaddr_in *)&cm_ptr->msg.daddr.so)->sin_port),
+			 ntohs(((struct sockaddr_in *)&cm_ptr->addr)->sin_port),
 			 (err == ETIMEDOUT || err == ECONNREFUSED) ? 
 			 "RETRYING...":"ABORTING", cm_ptr->retry);
 
 		/* retry a timeout */
-		if ((err == ETIMEDOUT) || (err == ECONNREFUSED && --cm_ptr->retry)) {
+		if (((err == ETIMEDOUT) || (err == ECONNREFUSED)) && --cm_ptr->retry) {
 			closesocket(cm_ptr->socket);
 			cm_ptr->socket = DAPL_INVALID_SOCKET;
 			dapli_socket_connect(cm_ptr->ep, (DAT_IA_ADDRESS_PTR)&cm_ptr->addr, 
@@ -715,14 +714,15 @@ static void dapli_socket_connect_rtu(dp_ib_cm_handle_t cm_ptr)
 	len = recv(cm_ptr->socket, (char *)&cm_ptr->msg, exp, 0);
 	if (len != exp || ntohs(cm_ptr->msg.ver) < DCM_VER_MIN) {
 		int err = dapl_socket_errno();
-		dapl_log(DAPL_DBG_TYPE_WARN,
-			 " CONN_RTU read: sk %d ERR 0x%x, rcnt=%d, v=%d -> %s PORT L-%x R-%x PID L-%x R-%x\n",
+		dapl_log(DAPL_DBG_TYPE_CM_WARN,
+			 " CONN_REP_PENDING: sk %d ERR 0x%x, rcnt=%d, v=%d ->"
+			 " %s PORT L-%x R-%x PID L-%x R-%x %d\n",
 			 cm_ptr->socket, err, len, ntohs(cm_ptr->msg.ver),
 			 inet_ntoa(((struct sockaddr_in *)&cm_ptr->addr)->sin_addr),
 			 ntohs(((struct sockaddr_in *)&cm_ptr->msg.daddr.so)->sin_port),
 			 ntohs(((struct sockaddr_in *)&cm_ptr->addr)->sin_port),
 			 ntohs(*(uint16_t*)&cm_ptr->msg.resv[0]),
-			 ntohs(*(uint16_t*)&cm_ptr->msg.resv[2]));
+			 ntohs(*(uint16_t*)&cm_ptr->msg.resv[2]),cm_ptr->retry);
 
 		/* Retry; corner case where server tcp stack resets under load */
 		if (err == ECONNRESET && --cm_ptr->retry) {
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
