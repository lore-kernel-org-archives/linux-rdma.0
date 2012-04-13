From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 4/5] infiniband-diags: Remove dependencies on ib_resolve_smlid/ib_resolve_self
Date: Thu, 12 Apr 2012 18:09:44 -0700
Message-ID: <1334279385-10792-4-git-send-email-foraker1@llnl.gov>
References: <1334279385-10792-1-git-send-email-foraker1@llnl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1334279385-10792-1-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ib_resolve_smlid() and ib_resolve_self() issue SMP queries to the local
interface for data that can be acquired thru other means.
resolve_sm_portid() (originally defined in 3179ae8c and made public here)
and the new function resolve_self() replace these functions, pulling
information from the umad layer instead.

Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
---
 include/ibdiag_common.h |    3 +++
 src/ibaddr.c            |    2 +-
 src/ibdiag_common.c     |   37 +++++++++++++++++++++++++++++++++++++
 src/ibportstate.c       |    4 ++--
 src/ibsendtrap.c        |    4 ++--
 src/mcm_rereg_test.c    |    4 +++-
 src/perfquery.c         |    2 +-
 src/sminfo.c            |    2 +-
 src/vendstat.c          |    2 +-
 9 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/include/ibdiag_common.h b/include/ibdiag_common.h
index 0131193..4388834 100644
--- a/include/ibdiag_common.h
+++ b/include/ibdiag_common.h
@@ -144,4 +144,7 @@ void sa_report_err(int status);
 void get_max_msg(char *width_msg, char *speed_msg, int msg_size,
 		 ibnd_port_t * port);
 
+int resolve_sm_portid(char *ca_name, uint8_t portnum, ib_portid_t *sm_id);
+int resolve_self(char *ca_name, uint8_t ca_port, ib_portid_t *portid,
+                 int *port, ibmad_gid_t *gid);
 #endif				/* _IBDIAG_COMMON_H_ */
diff --git a/src/ibaddr.c b/src/ibaddr.c
index 397ef77..10dfae8 100644
--- a/src/ibaddr.c
+++ b/src/ibaddr.c
@@ -154,7 +154,7 @@ int main(int argc, char **argv)
 					      ibd_sm_id, srcport) < 0)
 			IBERROR("can't resolve destination port %s", argv[0]);
 	} else {
-		if (ib_resolve_self_via(&portid, &port, 0, srcport) < 0)
+		if (resolve_self(ibd_ca, ibd_ca_port, &portid, &port, NULL) < 0)
 			IBERROR("can't resolve self port %s", argv[0]);
 	}
 
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index b22ed60..6605362 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -507,6 +507,43 @@ int resolve_sm_portid(char *ca_name, uint8_t portnum, ib_portid_t *sm_id)
 	return 0;
 }
 
+/** =========================================================================
+ * Resolve local CA characteristics using the umad layer rather than using
+ * ib_resolve_self_via which requires SMP queries on the local port.
+ */
+int resolve_self(char *ca_name, uint8_t ca_port, ib_portid_t *portid,
+		 int *portnum, ibmad_gid_t *gid)
+{
+	umad_port_t port;
+	uint64_t prefix, guid;
+	int rc;
+
+	if (!(portid || portnum || gid))
+		return (-1);
+
+	if ((rc = umad_get_port(ca_name, ca_port, &port)) < 0)
+		return rc;
+
+	if (portid) {
+		memset(portid, 0, sizeof(*portid));
+		portid->lid = port.base_lid;
+		portid->sl = port.sm_sl;
+	}
+	if (portnum)
+		*portnum = port.portnum;
+	if (gid) {
+		memset(gid, 0, sizeof(*gid));
+		prefix = cl_hton64(port.gid_prefix);
+		guid = cl_hton64(port.port_guid);
+		mad_encode_field(*gid, IB_GID_PREFIX_F, &prefix);
+		mad_encode_field(*gid, IB_GID_GUID_F, &guid);
+	}
+
+	umad_release_port(&port);
+
+	return 0;
+}
+
 /* define a common SA query structure
  * This is by no means optimal but it moves the saquery functionality out of
  * the saquery tool and provides it to other utilities.
diff --git a/src/ibportstate.c b/src/ibportstate.c
index ec6b823..ac74dfd 100644
--- a/src/ibportstate.c
+++ b/src/ibportstate.c
@@ -574,8 +574,8 @@ int main(int argc, char **argv)
 			peerportid.drpath.p[1] = (uint8_t) portnum;
 
 			/* Set DrSLID to local lid */
-			if (ib_resolve_self_via(&selfportid,
-						&selfport, 0, srcport) < 0)
+			if (resolve_self(ibd_ca, ibd_ca_port, &selfportid,
+						&selfport, 0) < 0)
 				IBERROR("could not resolve self");
 			peerportid.drpath.drslid = (uint16_t) selfportid.lid;
 			peerportid.drpath.drdlid = 0xffff;
diff --git a/src/ibsendtrap.c b/src/ibsendtrap.c
index 618706b..2d63e35 100644
--- a/src/ibsendtrap.c
+++ b/src/ibsendtrap.c
@@ -130,10 +130,10 @@ static int send_trap(const char *name,
 	ib_rpc_t trap_rpc;
 	ib_mad_notice_attr_t notice;
 
-	if (ib_resolve_self_via(&selfportid, &selfport, NULL, srcport))
+	if (resolve_self(ibd_ca, ibd_ca_port, &selfportid, &selfport, NULL))
 		IBERROR("can't resolve self");
 
-	if (ib_resolve_smlid_via(&sm_port, 0, srcport))
+	if (resolve_sm_portid(ibd_ca, ibd_ca_port, &sm_port))
 		IBERROR("can't resolve SM destination port");
 
 	memset(&trap_rpc, 0, sizeof(trap_rpc));
diff --git a/src/mcm_rereg_test.c b/src/mcm_rereg_test.c
index 60ec421..ec979d7 100644
--- a/src/mcm_rereg_test.c
+++ b/src/mcm_rereg_test.c
@@ -44,6 +44,8 @@
 #include <infiniband/mad.h>
 #include <infiniband/iba/ib_types.h>
 
+#include "ibdiag_common.h"
+
 #define info(fmt, ...) fprintf(stderr, "INFO: " fmt, ## __VA_ARGS__ )
 #define err(fmt, ...) fprintf(stderr, "ERR: " fmt, ## __VA_ARGS__ )
 #ifdef NOISY_DEBUG
@@ -368,7 +370,7 @@ int main(int argc, char **argv)
 	if (!srcport)
 		err("Failed to open port");
 
-	ib_resolve_smlid_via(&dport_id, TMO, srcport);
+	resolve_sm_portid(NULL, 0, &dport_id);
 	dport_id.qp = 1;
 	if (!dport_id.qkey)
 		dport_id.qkey = IB_DEFAULT_QP1_QKEY;
diff --git a/src/perfquery.c b/src/perfquery.c
index c747d11..7361c06 100644
--- a/src/perfquery.c
+++ b/src/perfquery.c
@@ -734,7 +734,7 @@ int main(int argc, char **argv)
 					      ibd_sm_id, srcport) < 0)
 			IBERROR("can't resolve destination port %s", argv[0]);
 	} else {
-		if (ib_resolve_self_via(&portid, &port, 0, srcport) < 0)
+		if (resolve_self(ibd_ca, ibd_ca_port, &portid, &port, 0) < 0)
 			IBERROR("can't resolve self port %s", argv[0]);
 	}
 
diff --git a/src/sminfo.c b/src/sminfo.c
index b02906f..dfe0681 100644
--- a/src/sminfo.c
+++ b/src/sminfo.c
@@ -127,7 +127,7 @@ int main(int argc, char **argv)
 					      0, srcport) < 0)
 			IBERROR("can't resolve destination port %s", argv[0]);
 	} else {
-		if (ib_resolve_smlid_via(&portid, ibd_timeout, srcport) < 0)
+		if (resolve_sm_portid(ibd_ca, ibd_ca_port, &portid) < 0)
 			IBERROR("can't resolve sm port %s", argv[0]);
 	}
 
diff --git a/src/vendstat.c b/src/vendstat.c
index 8dbd1ee..059ceab 100644
--- a/src/vendstat.c
+++ b/src/vendstat.c
@@ -331,7 +331,7 @@ int main(int argc, char **argv)
 					      ibd_sm_id, srcport) < 0)
 			IBERROR("can't resolve destination port %s", argv[0]);
 	} else {
-		if (ib_resolve_self_via(&portid, &port, 0, srcport) < 0)
+		if (resolve_self(ibd_ca, ibd_ca_port, &portid, &port, 0) < 0)
 			IBERROR("can't resolve self port %s", argv[0]);
 	}
 
-- 
1.7.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
