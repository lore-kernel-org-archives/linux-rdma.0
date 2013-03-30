From: Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] libibmad: Add setting of errno on function failure
Date: Sat, 30 Mar 2013 09:53:18 -0700
Message-ID: <5157187E.2070504@oracle.com>
References: <515678FE.9010503@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020701070208060205040604"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <515678FE.9010503-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------020701070208060205040604
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit





--------------020701070208060205040604
Content-Type: text/plain; charset=windows-1252;
 name="0001-libibmad-Add-setting-of-errno-on-function-failure.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-libibmad-Add-setting-of-errno-on-function-failure.patch"

>From d26b4c3cf435f2e89cb8c86c30043e7bfad7cec0 Mon Sep 17 00:00:00 2001
From: Brendan Doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date: Tue, 12 Mar 2013 19:38:52 +0000
Subject: [PATCH] libibmad: Add setting of errno on function failure

Signed-off-by: Brendan Doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 src/mad.c     |    3 +++
 src/resolve.c |   38 +++++++++++++++++++++++++++++---------
 src/rpc.c     |    3 +++
 src/serv.c    |    4 +++-
 4 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/src/mad.c b/src/mad.c
index 10f908c..5deefa2 100644
--- a/src/mad.c
+++ b/src/mad.c
@@ -41,6 +41,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <time.h>
+#include <errno.h>
 
 #include <infiniband/umad.h>
 #include <infiniband/mad.h>
@@ -102,10 +103,12 @@ void *mad_encode(void *buf, ib_rpc_t * rpc, ib_dr_path_t * drpath, void *data)
 	if ((rpc->mgtclass & 0xff) == IB_SMI_DIRECT_CLASS) {
 		if (!drpath) {
 			IBWARN("encoding dr mad without drpath (null)");
+			errno = EINVAL;
 			return NULL;
 		}
 		if (drpath->cnt >= IB_SUBNET_PATH_HOPS_MAX) {
 			IBWARN("dr path with hop count %d", drpath->cnt);
+			errno = EINVAL;
 			return NULL;
 		}
 		mad_set_field(buf, 0, IB_DRSMP_HOPCNT_F, drpath->cnt);
diff --git a/src/resolve.c b/src/resolve.c
index f866bf4..bccd938 100644
--- a/src/resolve.c
+++ b/src/resolve.c
@@ -40,6 +40,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <arpa/inet.h>
+#include <errno.h>
 
 #include <infiniband/umad.h>
 #include <infiniband/mad.h>
@@ -61,6 +62,10 @@ int ib_resolve_smlid_via(ib_portid_t * sm_id, int timeout,
 		return -1;
 
 	mad_decode_field(portinfo, IB_PORT_SMLID_F, &lid);
+	if (!IB_LID_VALID(lid)) {
+		errno = ENXIO;
+		return -1;
+	}
 	mad_decode_field(portinfo, IB_PORT_SMSL_F, &sm_id->sl);
 
 	return ib_portid_set(sm_id, lid, 0, 0);
@@ -75,11 +80,13 @@ int ib_resolve_gid_via(ib_portid_t * portid, ibmad_gid_t gid,
 		       ib_portid_t * sm_id, int timeout,
 		       const struct ibmad_port *srcport)
 {
-	ib_portid_t sm_portid;
+	ib_portid_t sm_portid = { 0 };
 	char buf[IB_SA_DATA_SIZE] = { 0 };
 
-	if (!sm_id) {
+	if (!sm_id)
 		sm_id = &sm_portid;
+
+	if (!IB_LID_VALID(sm_id->lid)) {
 		if (ib_resolve_smlid_via(sm_id, timeout, srcport) < 0)
 			return -1;
 	}
@@ -95,15 +102,17 @@ int ib_resolve_guid_via(ib_portid_t * portid, uint64_t * guid,
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
+	if (!IB_LID_VALID(sm_id->lid)) {
 		if (ib_resolve_smlid_via(sm_id, timeout, srcport) < 0)
 			return -1;
 	}
@@ -145,18 +154,24 @@ int ib_resolve_portid_str_via(ib_portid_t * portid, char *addr_str,
 	switch (dest_type) {
 	case IB_DEST_LID:
 		lid = strtol(addr_str, 0, 0);
-		if (!IB_LID_VALID(lid))
+		if (!IB_LID_VALID(lid)) {
+			errno = EINVAL;
 			return -1;
+		}
 		return ib_portid_set(portid, lid, 0, 0);
 
 	case IB_DEST_DRPATH:
-		if (str2drpath(&portid->drpath, addr_str, 0, 0) < 0)
+		if (str2drpath(&portid->drpath, addr_str, 0, 0) < 0) {
+			errno = EINVAL;
 			return -1;
+		}
 		return 0;
 
 	case IB_DEST_GUID:
-		if (!(guid = strtoull(addr_str, 0, 0)))
+		if (!(guid = strtoull(addr_str, 0, 0))) {
+			errno = EINVAL;
 			return -1;
+		}
 
 		/* keep guid in portid? */
 		return ib_resolve_guid_via(portid, &guid, sm_id, 0, srcport);
@@ -164,16 +179,20 @@ int ib_resolve_portid_str_via(ib_portid_t * portid, char *addr_str,
 	case IB_DEST_DRSLID:
 		lid = strtol(addr_str, &routepath, 0);
 		routepath++;
-		if (!IB_LID_VALID(lid))
+		if (!IB_LID_VALID(lid)) {
+			errno = EINVAL;
 			return -1;
+		}
 		ib_portid_set(portid, lid, 0, 0);
 
 		/* handle DR parsing and set DrSLID to local lid */
 		if (ib_resolve_self_via(&selfportid, &selfport, 0, srcport) < 0)
 			return -1;
 		if (str2drpath(&portid->drpath, routepath, selfportid.lid, 0) <
-		    0)
+		    0) {
+			errno = EINVAL;
 			return -1;
+		}
 		return 0;
 
 	case IB_DEST_GID:
@@ -182,6 +201,7 @@ int ib_resolve_portid_str_via(ib_portid_t * portid, char *addr_str,
 		return ib_resolve_gid_via(portid, gid, sm_id, 0, srcport);
 	default:
 		IBWARN("bad dest_type %d", dest_type);
+		errno = EINVAL;
 	}
 
 	return -1;
diff --git a/src/rpc.c b/src/rpc.c
index 7d93180..08b6c19 100644
--- a/src/rpc.c
+++ b/src/rpc.c
@@ -184,6 +184,7 @@ _do_madrpc(int port_id, void *sndbuf, void *rcvbuf, int agentid, int len,
 			return length;
 	}
 
+	errno = status;
 	*p_error = ETIMEDOUT;
 	ERRS("timeout after %d retries, %d ms", retries, timeout * retries);
 	return -1;
@@ -260,6 +261,7 @@ void *mad_rpc(const struct ibmad_port *port, ib_rpc_t * rpc,
 	if (status != 0) {
 		ERRS("MAD completed with error status 0x%x; dport (%s)",
 		     status, portid2str(dport));
+		errno = EIO;
 		return NULL;
 	}
 
@@ -309,6 +311,7 @@ void *mad_rpc_rmpp(const struct ibmad_port *port, ib_rpc_t * rpc,
 	if ((status = mad_get_field(mad, 0, IB_MAD_STATUS_F)) != 0) {
 		ERRS("MAD completed with error status 0x%x; dport (%s)",
 		     status, portid2str(dport));
+		errno = EIO;
 		return NULL;
 	}
 
diff --git a/src/serv.c b/src/serv.c
index ae5fd6c..6da8163 100644
--- a/src/serv.c
+++ b/src/serv.c
@@ -98,8 +98,10 @@ int mad_respond_via(void *umad, ib_portid_t * portid, uint32_t rstatus,
 	int is_smi;
 
 	if (!portid) {
-		if (!(mad_addr = umad_get_mad_addr(umad)))
+		if (!(mad_addr = umad_get_mad_addr(umad))) {
+			errno = EINVAL;
 			return -1;
+		}
 
 		memset(&rport, 0, sizeof(rport));
 
-- 
1.7.9.2


--------------020701070208060205040604--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
