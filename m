From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH perftest 16/23] perftest: check for NULL fgets() returns
Date: Thu, 18 Aug 2016 13:32:11 -0400
Message-ID: <1471541538-20270-17-git-send-email-jarod@redhat.com>
References: <1471541538-20270-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471541538-20270-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Check for fgets() failure in addition to fopen() failure and take
appropriate action.

CC: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/perftest_parameters.c    | 5 ++++-
 src/perftest_resources.c     | 5 ++++-
 src/raw_ethernet_resources.c | 5 ++++-
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/src/perftest_parameters.c b/src/perftest_parameters.c
index e316143..32ebea9 100755
--- a/src/perftest_parameters.c
+++ b/src/perftest_parameters.c
@@ -147,7 +147,10 @@ static int get_cache_line_size()
 		if (fp == NULL) {
 			return DEF_CACHE_LINE_SIZE;
 		}
-		fgets(line,10,fp);
+		if (fgets(line,10,fp) == NULL) {
+			fclose(fp);
+			return DEF_CACHE_LINE_SIZE;
+		}
 		size = atoi(line);
 		fclose(fp);
 	}
diff --git a/src/perftest_resources.c b/src/perftest_resources.c
index 4dc0705..91c6d1e 100755
--- a/src/perftest_resources.c
+++ b/src/perftest_resources.c
@@ -230,7 +230,10 @@ static void get_cpu_stats(struct perftest_parameters *duration_param,int stat_in
 	int index=0;
 	fp = fopen(file_name, "r");
 	if (fp != NULL) {
-		fgets(line,100,fp);
+		if (fgets(line,100,fp) == NULL) {
+			fclose(fp);
+			return;
+		}
 		compress_spaces(line,line);
 		index=get_n_word_string(line,tmp,index,2); /* skip first word */
 		duration_param->cpu_util_data.ustat[stat_index-1] = atoll(tmp);
diff --git a/src/raw_ethernet_resources.c b/src/raw_ethernet_resources.c
index d087cab..22e1bab 100755
--- a/src/raw_ethernet_resources.c
+++ b/src/raw_ethernet_resources.c
@@ -69,7 +69,10 @@ int check_flow_steering_support(char *dev_name)
 	fp = fopen(file_name, "r");
 	if (fp == NULL)
 		return 0;
-	fgets(line,4,fp);
+	if (fgets(line,4,fp) == NULL) {
+		fclose(fp);
+		return 0;
+	}
 
 	int val = atoi(line);
 	if (val >= 0) {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
