From: Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] libibmad: Conversion specifier; %m is not supported on Solaris
Date: Tue, 12 Mar 2013 12:38:11 -0700
Message-ID: <513F8423.3010302@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Brendan Doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Signed-off-by: Brendan Doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 src/rpc.c  |    4 ++--
 src/serv.c |    7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/src/rpc.c b/src/rpc.c
index 6312d42..4fb5a21 100644
--- a/src/rpc.c
+++ b/src/rpc.c
@@ -153,7 +153,7 @@ _do_madrpc(int port_id, void *sndbuf, void *rcvbuf, int agentid, int len,
 
 		length = len;
 		if (umad_send(port_id, agentid, sndbuf, length, timeout, 0) < 0) {
-			IBWARN("send failed; %m");
+			IBWARN("send failed; %s", strerror(errno));
 			return -1;
 		}
 
@@ -162,7 +162,7 @@ _do_madrpc(int port_id, void *sndbuf, void *rcvbuf, int agentid, int len,
 		do {
 			length = len;
 			if (umad_recv(port_id, rcvbuf, &length, timeout) < 0) {
-				IBWARN("recv failed: %m");
+				IBWARN("recv failed: %s", strerror(errno));
 				return -1;
 			}
 
diff --git a/src/serv.c b/src/serv.c
index 2e3b7ef..ae5fd6c 100644
--- a/src/serv.c
+++ b/src/serv.c
@@ -38,6 +38,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <errno.h>
 
 #include <infiniband/umad.h>
 #include <infiniband/mad.h>
@@ -75,7 +76,7 @@ int mad_send_via(ib_rpc_t * rpc, ib_portid_t * dport, ib_rmpp_hdr_t * rmpp,
 	if (umad_send(srcport->port_id, srcport->class_agents[rpc->mgtclass & 0xff],
 		      umad, IB_MAD_SIZE, mad_get_timeout(srcport, rpc->timeout),
 		      0) < 0) {
-		IBWARN("send failed; %m");
+		IBWARN("send failed; %s", strerror(errno));
 		return -1;
 	}
 
@@ -157,7 +158,7 @@ int mad_respond_via(void *umad, ib_portid_t * portid, uint32_t rstatus,
 	if (umad_send
 	    (srcport->port_id, srcport->class_agents[rpc.mgtclass], umad,
 	     IB_MAD_SIZE, mad_get_timeout(srcport, rpc.timeout), 0) < 0) {
-		DEBUG("send failed; %m");
+		DEBUG("send failed; %s", strerror(errno));
 		return -1;
 	}
 
@@ -179,7 +180,7 @@ void *mad_receive_via(void *umad, int timeout, struct ibmad_port *srcport)
 			       mad_get_timeout(srcport, timeout))) < 0) {
 		if (!umad)
 			umad_free(mad);
-		DEBUG("recv failed: %m");
+		DEBUG("recv failed: %s", strerror(errno));
 		return 0;
 	}
 
-- 
1.7.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
