From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] infiniband-diags: Use modern glibc htobe64/be64toh macros
Date: Fri, 24 Feb 2017 00:39:45 -0500
Message-ID: <1487914785-32724-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/ibdiag_common.h |  2 ++
 src/ibstat.c            |  8 ++++----
 src/mcm_rereg_test.c    | 12 ++++++------
 src/smpquery.c          |  2 +-
 4 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/include/ibdiag_common.h b/include/ibdiag_common.h
index 587dcfe59d65..79d8e72827b0 100644
--- a/include/ibdiag_common.h
+++ b/include/ibdiag_common.h
@@ -39,6 +39,8 @@
 #ifndef _IBDIAG_COMMON_H_
 #define _IBDIAG_COMMON_H_
 
+#include <endian.h>
+
 #include <stdarg.h>
 #include <infiniband/mad.h>
 #include <infiniband/iba/ib_types.h>
diff --git a/src/ibstat.c b/src/ibstat.c
index 2d980c40c312..31a3082071be 100644
--- a/src/ibstat.c
+++ b/src/ibstat.c
@@ -76,9 +76,9 @@ static void ca_dump(umad_ca_t * ca)
 	printf("\tNumber of ports: %d\n", ca->numports);
 	printf("\tFirmware version: %s\n", ca->fw_ver);
 	printf("\tHardware version: %s\n", ca->hw_ver);
-	printf("\tNode GUID: 0x%016" PRIx64 "\n", ntohll(ca->node_guid));
+	printf("\tNode GUID: 0x%016" PRIx64 "\n", be64toh(ca->node_guid));
 	printf("\tSystem image GUID: 0x%016" PRIx64 "\n",
-	       ntohll(ca->system_guid));
+	       be64toh(ca->system_guid));
 }
 
 static char *port_state_str[] = {
@@ -190,7 +190,7 @@ static int port_dump(umad_port_t * port, int alone)
 	printf("%sLMC: %d\n", pre, port->lmc);
 	printf("%sSM lid: %d\n", pre, port->sm_lid);
 	printf("%sCapability mask: 0x%08x\n", pre, ntohl(port->capmask));
-	printf("%sPort GUID: 0x%016" PRIx64 "\n", pre, ntohll(port->port_guid));
+	printf("%sPort GUID: 0x%016" PRIx64 "\n", pre, be64toh(port->port_guid));
 #ifdef HAVE_UMAD_PORT_LINK_LAYER
 	printf("%sLink layer: %s\n", pre, port->link_layer);
 #endif
@@ -251,7 +251,7 @@ static int ports_list(char names[][UMAD_CA_NAME_LEN], int n)
 
 	for (i = 0; i < found; i++)
 		if (guids[i])
-			printf("0x%016" PRIx64 "\n", ntohll(guids[i]));
+			printf("0x%016" PRIx64 "\n", be64toh(guids[i]));
 	return found;
 }
 
diff --git a/src/mcm_rereg_test.c b/src/mcm_rereg_test.c
index c3b00627a82b..182749e7a16e 100644
--- a/src/mcm_rereg_test.c
+++ b/src/mcm_rereg_test.c
@@ -166,7 +166,7 @@ static int rereg_send_all(int port, int agent, ib_portid_t * dport,
 		    rereg_port_gid(port, agent, dport, umad, len, list[i].gid);
 		if (ret < 0) {
 			err("rereg_send_all: rereg_port_gid 0x%016" PRIx64
-			    " failed\n", ntohll(list[i].guid));
+			    " failed\n", be64toh(list[i].guid));
 			continue;
 		}
 		list[i].trid = mad_get_field64(umad_get_mad(umad), 0,
@@ -245,7 +245,7 @@ static int rereg_recv_all(int port, int agent, ib_portid_t * dport,
 			}
 			info("guid 0x%016" PRIx64
 			     ": method = %x status = %x. Resending\n",
-			     ntohll(list[i].guid), method, status);
+			     be64toh(list[i].guid), method, status);
 			rereg_port_gid(port, agent, dport, umad, len,
 				       list[i].gid);
 			list[i].trid =
@@ -298,7 +298,7 @@ static int rereg_query_all(int port, int agent, ib_portid_t * dport,
 
 		if (status)
 			info("guid 0x%016" PRIx64 ": status %x, method %x\n",
-			     ntohll(list[i].guid), status, method);
+			     be64toh(list[i].guid), status, method);
 	}
 
 	info("rereg_query_all: %u queried.\n", cnt);
@@ -315,8 +315,8 @@ static int rereg_and_test_port(char *guid_file, int port, int agent,
 	char line[256];
 	FILE *f;
 	ibmad_gid_t port_gid;
-	uint64_t prefix = htonll(0xfe80000000000000ull);
-	uint64_t guid = htonll(0x0002c90200223825ull);
+	uint64_t prefix = htobe64(0xfe80000000000000ull);
+	uint64_t guid = htobe64(0x0002c90200223825ull);
 	struct guid_trid *list;
 	int i = 0;
 
@@ -335,7 +335,7 @@ static int rereg_and_test_port(char *guid_file, int port, int agent,
 
 	while (fgets(line, sizeof(line), f)) {
 		guid = strtoull(line, NULL, 0);
-		guid = htonll(guid);
+		guid = htobe64(guid);
 		memcpy(&port_gid[0], &prefix, 8);
 		memcpy(&port_gid[8], &guid, 8);
 
diff --git a/src/smpquery.c b/src/smpquery.c
index 2bd71320dc91..ba2f58a17fbc 100644
--- a/src/smpquery.c
+++ b/src/smpquery.c
@@ -403,7 +403,7 @@ static char *guid_info(ib_portid_t * dest, char **argv, int argc)
 		p = (uint64_t *) data;
 		for (j = 0; j < k; j += 2, p += 2) {
 			printf("%4u: 0x%016" PRIx64 " 0x%016" PRIx64 "\n",
-			       (i * 8) + j, ntohll(p[0]), ntohll(p[1]));
+			       (i * 8) + j, be64toh(p[0]), be64toh(p[1]));
 		}
 	}
 	printf("%d guids capacity for this port\n", n);
-- 
1.7.12

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
