From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv2] infiniband-diags/saquery: Add support for ServiceID in
 PathRecord querying
Date: Wed, 13 Feb 2013 19:43:27 -0500
Message-ID: <511C332F.8020006@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Change since v1:
Added change for man page

diff --git a/doc/rst/saquery.8.in.rst b/doc/rst/saquery.8.in.rst
index cf784f0..5034475 100644
--- a/doc/rst/saquery.8.in.rst
+++ b/doc/rst/saquery.8.in.rst
@@ -135,6 +135,8 @@ OPTIONS
 
 **--proxy_join** Proxy join (MCMemberRecord)
 
+**--service_id** ServiceID (PathRecord)
+
 Supported query names (and aliases):
 
 ::
@@ -205,4 +207,4 @@ Ira Weiny
         < weiny2-i2BcT+NCU+M@public.gmane.org >
 
 Hal Rosenstock
-        < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
+        < halr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org >
diff --git a/src/saquery.c b/src/saquery.c
index d24694a..72a0fe9 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -60,7 +60,13 @@
 #include "ibdiag_common.h"
 #include "ibdiag_sa.h"
 
+#ifndef IB_PR_COMPMASK_SERVICEID
+#define IB_PR_COMPMASK_SERVICEID (IB_PR_COMPMASK_SERVICEID_MSB | \
+				  IB_PR_COMPMASK_SERVICEID_LSB)
+#endif
+
 struct query_params {
+	uint64_t service_id;
 	ib_gid_t sgid, dgid, gid, mgid;
 	uint16_t slid, dlid, mlid;
 	uint32_t flow_label;
@@ -981,6 +987,7 @@ static int query_path_records(const struct query_cmd *q, struct sa_handle * h,
 	uint8_t reversible = 0;
 
 	memset(&pr, 0, sizeof(pr));
+	CHECK_AND_SET_VAL(p->service_id, 64, 0, pr.service_id, PR, SERVICEID);
 	CHECK_AND_SET_GID(p->sgid, pr.sgid, PR, SGID);
 	CHECK_AND_SET_GID(p->dgid, pr.dgid, PR, DGID);
 	CHECK_AND_SET_VAL(p->slid, 16, 0, pr.slid, PR, SLID);
@@ -1551,6 +1558,9 @@ static int process_opt(void *context, int ch, char *optarg)
 	case 'X':
 		p->proxy_join = strtoul(optarg, NULL, 0);
 		break;
+	case 22:
+		p->service_id = strtoull(optarg, NULL, 0);
+		break;
 	default:
 		return -1;
 	}
@@ -1633,6 +1643,7 @@ int main(int argc, char **argv)
 		{"scope", 21, 1, NULL, "Scope (MCMemberRecord)"},
 		{"join_state", 'J', 1, NULL, "Join state (MCMemberRecord)"},
 		{"proxy_join", 'X', 1, NULL, "Proxy join (MCMemberRecord)"},
+		{"service_id", 22, 1, NULL, "ServiceID (PathRecord)"},
 		{0}
 	};
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
