From: Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] libibmad: Fixes for failures when not all ports of HCA are
 connected
Date: Tue, 12 Mar 2013 12:37:33 -0700
Message-ID: <513F83FD.1090106@oracle.com>
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
 src/resolve.c |   22 ++++++++++++++++++----
 src/rpc.c     |    1 +
 src/sa.c      |    2 ++
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/src/resolve.c b/src/resolve.c
index f866bf4..ab24c79 100644
--- a/src/resolve.c
+++ b/src/resolve.c
@@ -40,6 +40,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <arpa/inet.h>
+#include <errno.h>
 
 #include <infiniband/umad.h>
 #include <infiniband/mad.h>
@@ -57,10 +58,18 @@ int ib_resolve_smlid_via(ib_portid_t * sm_id, int timeout,
 
 	memset(sm_id, 0, sizeof(*sm_id));
 
-	if (!smp_query_via(portinfo, &self, IB_ATTR_PORT_INFO, 0, 0, srcport))
+	if (!smp_query_via(portinfo, &self, IB_ATTR_PORT_INFO, 0, 0, srcport)) {
+		if (!errno)
+			errno = EIO;
 		return -1;
+	}
 
 	mad_decode_field(portinfo, IB_PORT_SMLID_F, &lid);
+	if (lid == 0) {
+		if (!errno)
+			errno = EIO;
+		return -1;
+	}
 	mad_decode_field(portinfo, IB_PORT_SMSL_F, &sm_id->sl);
 
 	return ib_portid_set(sm_id, lid, 0, 0);
@@ -95,21 +104,26 @@ int ib_resolve_guid_via(ib_portid_t * portid, uint64_t * guid,
 			ib_portid_t * sm_id, int timeout,
 			const struct ibmad_port *srcport)
 {
-	ib_portid_t sm_portid;
+	ib_portid_t sm_portid = { 0 };
 	uint8_t buf[IB_SA_DATA_SIZE] = { 0 };
 	ib_portid_t self = { 0 };
 	uint64_t selfguid, prefix;
 	ibmad_gid_t selfgid;
 	uint8_t nodeinfo[64];
 
-	if (!sm_id) {
+	if (!sm_id)
 		sm_id = &sm_portid;
+
+	if (!sm_id->lid) {
 		if (ib_resolve_smlid_via(sm_id, timeout, srcport) < 0)
 			return -1;
 	}
 
-	if (!smp_query_via(nodeinfo, &self, IB_ATTR_NODE_INFO, 0, 0, srcport))
+	if (!smp_query_via(nodeinfo, &self, IB_ATTR_NODE_INFO, 0, 0, srcport)) {
+		if (!errno)
+			errno = EIO;
 		return -1;
+	}
 	mad_decode_field(nodeinfo, IB_NODE_PORT_GUID_F, &selfguid);
 	mad_set_field64(selfgid, 0, IB_GID_PREFIX_F, IB_DEFAULT_SUBN_PREFIX);
 	mad_set_field64(selfgid, 0, IB_GID_GUID_F, selfguid);
diff --git a/src/rpc.c b/src/rpc.c
index 6312d42..cf2b60d 100644
--- a/src/rpc.c
+++ b/src/rpc.c
@@ -178,6 +178,7 @@ _do_madrpc(int port_id, void *sndbuf, void *rcvbuf, int agentid, int len,
 					 IB_MAD_TRID_F) != trid);
 
 		status = umad_status(rcvbuf);
+		errno = status;
 		if (!status)
 			return length;	/* done */
 		if (status == ENOMEM)
diff --git a/src/sa.c b/src/sa.c
index 352ed9f..367da2a 100644
--- a/src/sa.c
+++ b/src/sa.c
@@ -38,6 +38,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <errno.h>
 
 #include <infiniband/mad.h>
 #include "mad_internal.h"
@@ -56,6 +57,7 @@ uint8_t *sa_rpc_call(const struct ibmad_port *ibmad_port, void *rcvbuf,
 
 	if (portid->lid <= 0) {
 		IBWARN("only lid routes are supported");
+		errno = EIO;
 		return NULL;
 	}
 
-- 
1.7.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
