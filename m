From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 06/32] srp_daemon: mark symbols as static where possible
Date: Thu, 13 Oct 2016 19:51:09 +0200
Message-ID: <1476381095-20041-7-git-send-email-hch@lst.de>
References: <1476381095-20041-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476381095-20041-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 srp_daemon/srp_daemon.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
index 2317508..f0f05cf 100644
--- a/srp_daemon/srp_daemon.c
+++ b/srp_daemon/srp_daemon.c
@@ -151,7 +151,7 @@ static int check_process_uniqueness(struct config_t *conf)
 	return fd;
 }
 
-int srpd_sys_read_string(const char *dir_name, const char *file_name,
+static int srpd_sys_read_string(const char *dir_name, const char *file_name,
 			 char *str, int max_len)
 {
 	char path[256], *s;
@@ -177,7 +177,7 @@ int srpd_sys_read_string(const char *dir_name, const char *file_name,
 	return 0;
 }
 
-int srpd_sys_read_gid(char *dir_name, char *file_name, uint8_t *gid)
+static int srpd_sys_read_gid(char *dir_name, char *file_name, uint8_t *gid)
 {
 	char buf[64], *str, *s;
 	uint16_t *ugid = (uint16_t *)gid;
@@ -195,7 +195,7 @@ int srpd_sys_read_gid(char *dir_name, char *file_name, uint8_t *gid)
 	return 0;
 }
 
-int srpd_sys_read_uint64(char *dir_name, char *file_name, uint64_t *u)
+static int srpd_sys_read_uint64(char *dir_name, char *file_name, uint64_t *u)
 {
 	char buf[32];
 	int r;
@@ -257,7 +257,7 @@ check_equal_uint16(char *dir_name, char *attr, uint16_t val)
 
 static int recalc(struct resources *res);
 
-void pr_cmd(char *target_str, int not_connected)
+static void pr_cmd(char *target_str, int not_connected)
 {
 	int ret;
 
@@ -343,7 +343,7 @@ static int check_not_equal_int(char *dir_name, char *attr, int value)
 	return 0;
 }
 
-int is_enabled_by_rules_file(struct target_details *target)
+static int is_enabled_by_rules_file(struct target_details *target)
 {
 	int rule;
 	struct config_t *conf = config;
@@ -584,7 +584,7 @@ static int add_non_exist_target(struct target_details *target)
 	return 1;
 }
 
-int send_and_get(int portid, int agent, srp_ib_user_mad_t *out_mad,
+static int send_and_get(int portid, int agent, srp_ib_user_mad_t *out_mad,
 		 srp_ib_user_mad_t *in_mad, int in_mad_size)
 {
 	struct srp_dm_mad *out_dm_mad = (void *) out_mad->hdr.data;
@@ -1804,7 +1804,7 @@ static int umad_resources_create(struct umad_resources *umad_res)
 	return 0;
 }
 
-void *run_thread_retry_to_connect(void *res_in)
+static void *run_thread_retry_to_connect(void *res_in)
 {
 	struct resources *res = (struct resources *)res_in;
 	struct target_details *target;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
