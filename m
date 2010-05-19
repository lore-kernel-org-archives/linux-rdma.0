From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/9] dapl-2.0: scm: SOCKOPT ERR Connection timed out on
 large clusters
Date: Wed, 19 May 2010 11:25:21 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C70130DE@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Large scale all to all connections on +1500 cores
the listen backlog is reached and SYN's are dropped
which causes the connect to timeout. Retry connect
on timeout errors.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_scm/cm.c |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/dapl/openib_scm/cm.c b/dapl/openib_scm/cm.c
index 7465190..4c8d4a1 100644
--- a/dapl/openib_scm/cm.c
+++ b/dapl/openib_scm/cm.c
@@ -60,6 +60,12 @@
 #include "dapl_ep_util.h"
 #include "dapl_osd.h"
 
+/* forward declarations */
+static DAT_RETURN
+dapli_socket_connect(DAPL_EP * ep_ptr,
+		     DAT_IA_ADDRESS_PTR r_addr,
+		     DAT_CONN_QUAL r_qual, DAT_COUNT p_size, DAT_PVOID p_data);
+
 #ifdef DAPL_DBG
 /* Check for EP linking to IA and proper connect state */
 void dapli_ep_check(DAPL_EP *ep)
@@ -494,13 +500,27 @@ static void dapli_socket_connected(dp_ib_cm_handle_t cm_ptr, int err)
 
 	if (err) {
 		dapl_log(DAPL_DBG_TYPE_ERR,
-			 " CONN_PENDING: %s ERR %s -> %s %d\n",
+			 " CONN_PENDING: %s ERR %s -> %s %d - %s\n",
 			 err == -1 ? "POLL" : "SOCKOPT",
 			 err == -1 ? strerror(dapl_socket_errno()) : strerror(err), 
 			 inet_ntoa(((struct sockaddr_in *)
 				&cm_ptr->addr)->sin_addr), 
 			 ntohs(((struct sockaddr_in *)
-				&cm_ptr->addr)->sin_port));
+				&cm_ptr->addr)->sin_port),
+			 err == ETIMEDOUT ? "RETRYING...":"ABORTING");
+
+		/* retry a timeout */
+		if (err == ETIMEDOUT) {
+			closesocket(cm_ptr->socket);
+			cm_ptr->socket = DAPL_INVALID_SOCKET;
+			dapli_socket_connect(cm_ptr->ep, (DAT_IA_ADDRESS_PTR)&cm_ptr->addr, 
+					     ntohs(((struct sockaddr_in *)&cm_ptr->addr)->sin_port) - 1000,
+					     ntohs(cm_ptr->msg.p_size), &cm_ptr->msg.p_data);
+			dapl_ep_unlink_cm(cm_ptr->ep, cm_ptr);
+			dapli_cm_free(cm_ptr);
+			return;
+		}
+
 		goto bail;
 	}
 
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
