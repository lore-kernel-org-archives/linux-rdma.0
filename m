From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] uDAPL v2: scm: client side setsockopt NODELAY fails if data
 arrives before setting
Date: Tue, 24 Nov 2009 16:16:16 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C98361B96A62@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Move setsockopt before connect to avoid race with data.
Seems to fail on windows. Not seen on linux.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_scm/cm.c |   34 ++++++++++++++++++++--------------
 1 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/dapl/openib_scm/cm.c b/dapl/openib_scm/cm.c
index c957f29..105351c 100644
--- a/dapl/openib_scm/cm.c
+++ b/dapl/openib_scm/cm.c
@@ -69,7 +69,15 @@ enum DAPL_FD_EVENTS {
 static int dapl_config_socket(DAPL_SOCKET s)
 {
 	unsigned long nonblocking = 1;
-	return ioctlsocket(s, FIONBIO, &nonblocking);
+	int ret, opt;
+
+	ret = ioctlsocket(s, FIONBIO, &nonblocking);
+
+	/* no delay for small packets */
+	if (!ret)
+		ret = setsockopt(s, IPPROTO_TCP, TCP_NODELAY, 
+				 (char *)&opt, sizeof(opt));
+	return ret;
 }
 
 static int dapl_connect_socket(DAPL_SOCKET s, struct sockaddr *addr,
@@ -176,11 +184,17 @@ enum DAPL_FD_EVENTS {
 
 static int dapl_config_socket(DAPL_SOCKET s)
 {
-	int ret;
+	int ret, opt = 1;
 
+	/* non-blocking */
 	ret = fcntl(s, F_GETFL);
 	if (ret >= 0)
 		ret = fcntl(s, F_SETFL, ret | O_NONBLOCK);
+
+	/* no delay for small packets */
+	if (!ret)
+		ret = setsockopt(s, IPPROTO_TCP, TCP_NODELAY, 
+				 (char *)&opt, sizeof(opt));
 	return ret;
 }
 
@@ -434,7 +448,7 @@ DAT_RETURN dapli_socket_disconnect(dp_ib_cm_handle_t cm_ptr)
  */
 static void dapli_socket_connected(dp_ib_cm_handle_t cm_ptr, int err)
 {
-	int ret, len, exp, opt = 1;
+	int len, exp;
 	struct iovec iov[2];
 	struct dapl_ep *ep_ptr = cm_ptr->ep;
 
@@ -450,14 +464,6 @@ static void dapli_socket_connected(dp_ib_cm_handle_t cm_ptr, int err)
 		goto bail;
 	}
 
-	/* no delay for small packets */
-	ret = setsockopt(cm_ptr->socket, IPPROTO_TCP, TCP_NODELAY,
-			 (char *)&opt, sizeof(opt));
-	if (ret)
-		dapl_log(DAPL_DBG_TYPE_ERR,
-			 " CONN_PENDING: NODELAY setsockopt: %s\n",
-			 strerror(errno));
-		
 	cm_ptr->state = DCM_REP_PENDING;
 
 	/* send qp info and pdata to remote peer */
@@ -537,7 +543,7 @@ dapli_socket_connect(DAPL_EP * ep_ptr,
 	if (ret < 0) {
 		dapl_log(DAPL_DBG_TYPE_ERR,
 			 " connect: config socket %d ERR %d %s\n",
-			 cm_ptr->socket, ret, strerror(errno));
+			 cm_ptr->socket, ret, strerror(dapl_socket_errno()));
 		dat_ret = DAT_INTERNAL_ERROR;
 		goto bail;
 	}
@@ -954,8 +960,8 @@ static void dapli_socket_accept(ib_cm_srvc_handle_t cm_ptr)
 			   (char *)&opt, sizeof(opt));
 		if (ret)
 			dapl_log(DAPL_DBG_TYPE_ERR,
-				 " ACCEPT: NODELAY setsockopt: %s\n",
-				 strerror(errno));
+				 " ACCEPT: NODELAY setsockopt: 0x%x 0x%x %s\n",
+			 	 ret, dapl_socket_errno(), strerror(dapl_socket_errno()));
 		
 		/* get local address information from socket */
 		sl = sizeof(acm_ptr->addr);
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
