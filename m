From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 02/5] infiniband-diags: ibqueryerrors; add ibcheckerrors
 like summary
Date: Wed, 27 Apr 2011 18:46:49 -0700
Message-ID: <20110427184649.bac5544b.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Mon, 25 Apr 2011 12:39:12 -0700
Subject: [PATCH 02/5] infiniband-diags: ibqueryerrors; add ibcheckerrors like summary

ibcheckerrors reports a summary of nodes checked, node errors, port checked, and
port errors.  Track and print same as a summary.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 src/ibqueryerrors.c |   49 +++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index 68957fe..e0a328b 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -89,14 +89,26 @@ static char *threshold_file = DEF_THRES_FILE;
 
 /* define a "packet" with threshold values in it */
 uint8_t thresholds[1204] = { 0 };
+char * threshold_str = NULL;
 
 static void set_thres(char *name, uint32_t val)
 {
 	int f;
+	int n;
+	char tmp[256];
 	for (f = IB_PC_FIRST_F; f <= IB_PC_LAST_F; f++) {
 		if (strcmp(name, mad_field_name(f)) == 0) {
 			mad_encode_field(thresholds, f, &val);
-			printf("[%s = %u]", name, val);
+			snprintf(tmp, 255, "[%s = %u]", name, val);
+			threshold_str = realloc(threshold_str,
+					strlen(threshold_str)+strlen(tmp)+1);
+			if (!threshold_str) {
+				fprintf(stderr, "Failed to allocate memory: "
+					"%s\n", strerror(errno));
+				exit(1);
+			}
+			n = strlen(threshold_str);
+			strcpy(threshold_str+n, tmp);
 		}
 	}
 }
@@ -109,11 +121,19 @@ static void set_thresholds(char *threshold_file)
 	char *p_prefix, *p_last;
 	char *name;
 	char *val_str;
+	char str[64];
 
 	if (!thresf)
 		return;
 
-	printf("Thresholds: ");
+	snprintf(str, 63, "Thresholds: ");
+	threshold_str = malloc(strlen(str)+1);
+	if (!threshold_str) {
+		fprintf(stderr, "Failed to allocate memory: %s\n",
+			strerror(errno));
+		exit(1);
+	}
+	strcpy(threshold_str, str);
 	while (fgets(buf, sizeof buf, thresf) != NULL) {
 		p_prefix = strtok_r(buf, "\n", &p_last);
 		if (!p_prefix)
@@ -128,7 +148,6 @@ static void set_thresholds(char *threshold_file)
 		val = strtoul(val_str, NULL, 0);
 		set_thres(name, val);
 	}
-	printf("\n");
 
 	fclose(thresf);
 }
@@ -275,12 +294,22 @@ static int suppress(enum MAD_FIELDS field)
 static void report_suppressed(void)
 {
 	int i = 0;
-	printf("Suppressing:");
+	printf("## Suppresed:");
 	for (i = 0; i < sup_total; i++)
 		printf(" %s", mad_field_name(suppressed_fields[i]));
 	printf("\n");
 }
 
+static void print_summary(void)
+{
+	printf("\n## Summary: %d nodes checked, %d bad nodes found\n",
+		summary.nodes_checked, summary.bad_nodes);
+	printf("##          %d ports checked, %d ports have errors beyond threshold\n",
+		summary.ports_checked, summary.bad_ports);
+	printf("## %s\n", threshold_str);
+	report_suppressed();
+}
+
 static int query_and_dump(char *buf, size_t size, ib_portid_t * portid,
 			  ibnd_node_t * node, char *node_name, int portnum,
 			  const char *attr_name, uint16_t attr_id,
@@ -374,6 +403,7 @@ static int print_results(ib_portid_t * portid, char *node_name,
 			printf("Errors for 0x%" PRIx64 " \"%s\"\n", node->guid,
 			       node_name);
 			*header_printed = 1;
+			summary.bad_nodes++;
 		}
 
 		if (portnum == 0xFF)
@@ -384,6 +414,8 @@ static int print_results(ib_portid_t * portid, char *node_name,
 			       node->guid, portnum, str);
 		if (portnum != 0xFF && port_config)
 			print_port_config(node_name, node, portnum);
+
+		summary.bad_ports++;
 	}
 	return (n);
 }
@@ -515,8 +547,10 @@ void print_node(ibnd_node_t * node, void *user_data)
 	    (cap_mask & 0x100)) {
 		all_port_sup = 1;
 		if (!print_port(&portid, cap_mask, node_name, node,
-				0xFF, &header_printed))
+				0xFF, &header_printed)) {
+			summary.ports_checked += node->numports;
 			goto clear;
+		}
 	}
 
 	for (p = startport; p <= node->numports; p++) {
@@ -529,12 +563,14 @@ void print_node(ibnd_node_t * node, void *user_data)
 
 			print_port(&portid, cap_mask, node_name, node, p,
 				   &header_printed);
+			summary.ports_checked++;
 			if (!all_port_sup)
 				clear_port(&portid, cap_mask, node_name, p);
 		}
 	}
 
 clear:
+	summary.nodes_checked++;
 	if (all_port_sup)
 		clear_port(&portid, cap_mask, node_name, 0xFF);
 
@@ -746,7 +782,6 @@ int main(int argc, char **argv)
 		}
 	}
 
-	report_suppressed();
 	set_thresholds(threshold_file);
 
 	if (node_guid_str) {
@@ -775,6 +810,8 @@ int main(int argc, char **argv)
 	} else
 		ibnd_iter_nodes(fabric, print_node, NULL);
 
+	print_summary();
+
 destroy_fabric:
 	ibnd_destroy_fabric(fabric);
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
