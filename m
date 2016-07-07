From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] Add transactions per second to latency tests
Date: Thu, 7 Jul 2016 09:06:34 -0700
Message-ID: <4257b3f1d2c22af577a5e584d2a34013342fb0ca.1467907759.git.root@stevo1.asicdesigners.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

For duration (-D) latency tests, it is useful to have the average
transactions per second (tps) output.  So ib_*_lat now shows
average tps:

---------------------------------------------------------------------------------------
 #bytes        #iterations       t_avg[usec]    tps average
 2             1008430           2.97           168068.16
---------------------------------------------------------------------------------------

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 src/perftest_parameters.c | 5 +++--
 src/perftest_parameters.h | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/src/perftest_parameters.c b/src/perftest_parameters.c
index 1cf4985..55d894b 100755
--- a/src/perftest_parameters.c
+++ b/src/perftest_parameters.c
@@ -2443,13 +2443,14 @@ void print_report_lat_duration (struct perftest_parameters *user_param)
 	int rtt_factor;
 	double cycles_to_units;
 	cycles_t test_sample_time;
-	double latency;
+	double latency, tps;
 
 	rtt_factor = (user_param->verb == READ || user_param->verb == ATOMIC) ? 1 : 2;
 	cycles_to_units = get_cpu_mhz(user_param->cpu_freq_f);
 
 	test_sample_time = (user_param->tcompleted[0] - user_param->tposted[0]);
 	latency = (((test_sample_time / cycles_to_units) / rtt_factor) / user_param->iters);
+	tps = user_param->iters / (test_sample_time / (cycles_to_units * 1000000));
 
 	if (user_param->output == OUTPUT_LAT) {
 		printf("%lf\n",latency);
@@ -2458,7 +2459,7 @@ void print_report_lat_duration (struct perftest_parameters *user_param)
 		printf(REPORT_FMT_LAT_DUR,
 				user_param->size,
 				user_param->iters,
-				latency);
+				latency, tps);
 		printf( user_param->cpu_util_data.enable ? REPORT_EXT_CPU_UTIL : REPORT_EXT , calc_cpu_util(user_param));
 	}
 }
diff --git a/src/perftest_parameters.h b/src/perftest_parameters.h
index 07c539c..7c1c871 100755
--- a/src/perftest_parameters.h
+++ b/src/perftest_parameters.h
@@ -180,7 +180,7 @@
 
 #define RESULT_FMT_LAT " #bytes #iterations    t_min[usec]    t_max[usec]  t_typical[usec]"
 
-#define RESULT_FMT_LAT_DUR " #bytes        #iterations       t_avg[usec]  	"
+#define RESULT_FMT_LAT_DUR " #bytes        #iterations       t_avg[usec]    tps average"
 
 #define RESULT_EXT "\n"
 
@@ -202,7 +202,7 @@
 /* Result print format for latency tests. */
 #define REPORT_FMT_LAT " %-7lu %d          %-7.2f        %-7.2f      %-7.2f"
 
-#define REPORT_FMT_LAT_DUR " %-7lu       %d            %-7.2f"
+#define REPORT_FMT_LAT_DUR " %-7lu       %d            %-7.2f        %-7.2f"
 
 #define CHECK_VALUE(arg,type,minv,maxv,name) 						    					\
 { arg = (type)strtol(optarg, NULL, 0); if ((arg < minv) || (arg > maxv))                \
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
