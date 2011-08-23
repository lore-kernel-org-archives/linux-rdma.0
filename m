From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: ibqueryerrors Clean up exit codes
Date: Tue, 23 Aug 2011 16:41:16 -0700
Message-ID: <20110823164116.b624d553.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Update man page for exit status

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 man/ibqueryerrors.8.in |    6 ++++++
 src/ibqueryerrors.c    |   13 ++++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/man/ibqueryerrors.8.in b/man/ibqueryerrors.8.in
index d190715..78323c7 100644
--- a/man/ibqueryerrors.8.in
+++ b/man/ibqueryerrors.8.in
@@ -97,6 +97,12 @@ for information on caching ibnetdiscover output.
 .PP
 \-t <timeout_ms> override the default timeout for the solicited mads.
 
+.SH EXIT STATUS
+
+If a failure to scan the fabric occurs return -1.  If the scan succeeds without
+errors beyond thresholds return 0.  If errors are found on ports beyond
+thresholds return 1.
+
 .SH FILES
 
 @IBDIAG_CONFIG_PATH@/error_thresholds
diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index 6de3d6f..9ea9810 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -273,7 +273,7 @@ static void report_suppressed(void)
 	printf("\n");
 }
 
-static void print_summary(void)
+static int print_summary(void)
 {
 	printf("\n## Summary: %d nodes checked, %d bad nodes found\n",
 		summary.nodes_checked, summary.bad_nodes);
@@ -281,6 +281,7 @@ static void print_summary(void)
 		summary.ports_checked, summary.bad_ports);
 	printf("## %s\n", threshold_str);
 	report_suppressed();
+	return (summary.bad_ports);
 }
 
 static int query_and_dump(char *buf, size_t size, ib_portid_t * portid,
@@ -879,7 +880,7 @@ int main(int argc, char **argv)
 
 	if (dr_path && load_cache_file) {
 		fprintf(stderr, "Cannot specify cache and direct route path\n");
-		exit(1);
+		exit(-1);
 	}
 
 	/* limit the scan the fabric around the target */
@@ -901,7 +902,7 @@ int main(int argc, char **argv)
 	if (load_cache_file) {
 		if ((fabric = ibnd_load_fabric(load_cache_file, 0)) == NULL) {
 			fprintf(stderr, "loading cached fabric failed\n");
-			exit(1);
+			exit(-1);
 		}
 	} else {
 		if (resolved >= 0) {
@@ -918,7 +919,7 @@ int main(int argc, char **argv)
 							       NULL,
 							       &config))) {
 			fprintf(stderr, "discover failed\n");
-			rc = 1;
+			rc = -1;
 			goto close_port;
 		}
 	}
@@ -951,7 +952,9 @@ int main(int argc, char **argv)
 	} else
 		ibnd_iter_nodes(fabric, print_node, NULL);
 
-	print_summary();
+	rc = print_summary();
+	if (rc)
+		rc = 1;
 
 destroy_fabric:
 	ibnd_destroy_fabric(fabric);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
