From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: Fix saquery error reporting
Date: Fri, 17 Feb 2012 23:07:16 -0800
Message-ID: <20120217230716.130eefc2.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


The sa_query function can fail in 2 ways
	1) the system calls can fail
	2) the SA returns a failure result

The first case was not being handled properly.  In addition ensure the program
returns a proper errno value as an exit code regardless of the failure mode.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 src/ibdiag_common.c |    4 ++--
 src/saquery.c       |    9 ++++-----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index b26a5e2..58d3d95 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -561,7 +561,7 @@ int sa_query(bind_handle_t h, uint8_t method,
 		IBWARN("umad_send failed: attr %u: %s\n",
 			attr, strerror(errno));
 		free(umad);
-		return (IB_ERROR);
+		return (-ret);
 	}
 
 recv_mad:
@@ -574,7 +574,7 @@ recv_mad:
 		IBWARN("umad_recv failed: attr 0x%x: %s\n", attr,
 			strerror(errno));
 		free(umad);
-		return (IB_ERROR);
+		return (-ret);
 	}
 
 	if ((ret = umad_status(umad)))
diff --git a/src/saquery.c b/src/saquery.c
index e29a1d0..097d9dd 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -732,7 +732,7 @@ static int get_any_records(bind_handle_t h,
 	int ret = sa_query(h, IB_MAD_METHOD_GET_TABLE, attr_id, attr_mod,
 			   cl_ntoh64(comp_mask), sm_key, attr, result);
 	if (ret) {
-		fprintf(stderr, "Query SA failed: %s\n", ib_get_err_str(ret));
+		fprintf(stderr, "Query SA failed: %s\n", strerror(ret));
 		return ret;
 	}
 
@@ -822,7 +822,7 @@ static uint16_t get_lid(bind_handle_t h, const char *name)
 	if (!name)
 		return 0;
 	if (isalpha(name[0])) {
-		if (get_lid_from_name(h, name, &rc_lid) != IB_SUCCESS) {
+		if (get_lid_from_name(h, name, &rc_lid) != 0) {
 			fprintf(stderr, "Failed to find lid for \"%s\"\n", name);
 			exit(EINVAL);
 		}
@@ -946,8 +946,7 @@ static int get_print_class_port_info(bind_handle_t h)
 	int ret = sa_query(h, IB_MAD_METHOD_GET, CLASS_PORT_INFO, 0, 0,
 			   0, NULL, &result);
 	if (ret) {
-		fprintf(stderr, "ERROR: Query SA failed: %s\n",
-			ib_get_err_str(ret));
+		fprintf(stderr, "ERROR: Query SA failed: %s\n", strerror(ret));
 		return ret;
 	}
 	if (result.status != IB_SA_MAD_STATUS_SUCCESS) {
@@ -1719,7 +1718,7 @@ int main(int argc, char **argv)
 		    || !q->handler) {
 			fprintf(stderr, "Unknown query type %d\n",
 				ntohs(query_type));
-			status = IB_UNKNOWN_ERROR;
+			status = EINVAL;
 		} else
 			status = q->handler(q, h, &params, argc, argv);
 		break;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
