From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 3/3] osmtest: Add support for full world path records back
 as option
Date: Thu, 07 Mar 2013 07:48:03 -0500
Message-ID: <51388C83.3050905@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 osmtest/include/osmtest.h |    1 +
 osmtest/main.c            |    6 ++++++
 osmtest/osmtest.c         |   40 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/osmtest/include/osmtest.h b/osmtest/include/osmtest.h
index c3134ef..4a7f0a3 100644
--- a/osmtest/include/osmtest.h
+++ b/osmtest/include/osmtest.h
@@ -86,6 +86,7 @@ typedef struct _osmtest_opt {
 	uint8_t wait_time;
 	char *log_file;
 	boolean_t ignore_path_records;
+	boolean_t full_world_path_recs;
 } osmtest_opt_t;
 
 /*
diff --git a/osmtest/main.c b/osmtest/main.c
index 7b586e9..6129674 100644
--- a/osmtest/main.c
+++ b/osmtest/main.c
@@ -107,6 +107,7 @@ void show_usage()
 	       "          -d0  - Unused.\n"
 	       "          -d1  - Do not scan/compare path records.\n"
 	       "          -d2  - Force log flushing after each log message.\n"
+	       "          -d4  - Use full world path record queries.\n"
 	       "          Without -d, no debug options are enabled\n\n");
 	printf("-m <LID in hex>\n"
 	       "--max_lid <LID in hex>\n"
@@ -327,6 +328,7 @@ int main(int argc, char *argv[])
 	opt.create = FALSE;
 	opt.mmode = 1;
 	opt.ignore_path_records = FALSE;	/*  Do path Records too */
+	opt.full_world_path_recs = FALSE;
 	opt.flow = OSMT_FLOW_ALL;	/*  run all validation tests */
 	strcpy(flow_name, "All Validations");
 	strcpy(opt.file_name, "osmtest.dat");
@@ -533,6 +535,10 @@ int main(int argc, char *argv[])
 				printf("Force Log Flush\n");
 				opt.force_log_flush = TRUE;
 				break;
+			case 4:
+				printf("Use Full World Path Record Queries\n");
+				opt.full_world_path_recs = TRUE;
+				break;
 			case 3:
 				/* Used to be memory tracking */
 			default:
diff --git a/osmtest/osmtest.c b/osmtest/osmtest.c
index 9dd0b98..75e7c55 100644
--- a/osmtest/osmtest.c
+++ b/osmtest/osmtest.c
@@ -2238,6 +2238,9 @@ osmtest_write_all_path_recs(IN osmtest_t * const p_osmt, IN FILE * fh)
 
 	OSM_LOG_ENTER(&p_osmt->log);
 
+	if (p_osmt->opt.full_world_path_recs)
+		goto full_world;
+
 	result = fprintf(fh, "#\n" "# Path Records\n" "#\n");
 	if (result < 0) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0026: "
@@ -2275,6 +2278,43 @@ osmtest_write_all_path_recs(IN osmtest_t * const p_osmt, IN FILE * fh)
 		}
 		p_dst_node = (node_t *) cl_qmap_next(&p_dst_node->map_item);
 	}
+	goto Exit;
+
+full_world:
+	memset(&context, 0, sizeof(context));
+
+	/*
+	 * Do a blocking query for all PathRecords in the subnet.
+	 */
+	status = osmtest_get_all_recs(p_osmt, IB_MAD_ATTR_PATH_RECORD,
+				      sizeof(*p_rec), &context);
+
+	if (status != IB_SUCCESS) {
+		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0002: "
+			"osmtest_get_all_recs failed (%s)\n",
+			ib_get_err_str(status));
+		goto Exit;
+	}
+	/*
+	 * Write the received records out to the file.
+	 */
+	num_recs = context.result.result_cnt;
+
+	OSM_LOG(&p_osmt->log, OSM_LOG_VERBOSE, "Received %zu records\n", num_recs);
+
+	result = fprintf(fh, "#\n" "# Path Records\n" "#\n");
+	if (result < 0) {
+		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0005: "
+			"Write failed\n");
+		status = IB_ERROR;
+		goto Exit;
+	}
+
+	for (i = 0; i < num_recs; i++) {
+		p_rec =
+		    osmv_get_query_path_rec(context.result.p_result_madw, i);
+		osmtest_write_path_info(p_osmt, fh, p_rec);
+	}
 
 Exit:
 	/*
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
