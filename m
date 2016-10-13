From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 05/32] srp_daemon: use NULL instead of 0 for NULL pointers
Date: Thu, 13 Oct 2016 19:51:08 +0200
Message-ID: <1476381095-20041-6-git-send-email-hch@lst.de>
References: <1476381095-20041-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476381095-20041-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 srp_daemon/srp_daemon.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
index f16674d..2317508 100644
--- a/srp_daemon/srp_daemon.c
+++ b/srp_daemon/srp_daemon.c
@@ -189,7 +189,7 @@ int srpd_sys_read_gid(char *dir_name, char *file_name, uint8_t *gid)
 	for (s = buf, i = 0 ; i < 8; i++) {
 		if (!(str = strsep(&s, ": \t\n")))
 			return -EINVAL;
-		ugid[i] = htons(strtoul(str, 0, 16) & 0xffff);
+		ugid[i] = htons(strtoul(str, NULL, 16) & 0xffff);
 	}
 
 	return 0;
@@ -203,7 +203,7 @@ int srpd_sys_read_uint64(char *dir_name, char *file_name, uint64_t *u)
 	if ((r = srpd_sys_read_string(dir_name, file_name, buf, sizeof(buf))) < 0)
 		return r;
 
-	*u = strtoull(buf, 0, 0);
+	*u = strtoull(buf, NULL, 0);
 
 	return 0;
 }
@@ -356,36 +356,36 @@ int is_enabled_by_rules_file(struct target_details *target)
 	do {
 		rule++;
 		if (conf->rules[rule].id_ext[0] != '\0' &&
-		    strtoull(target->id_ext, 0, 16) !=
-		    strtoull(conf->rules[rule].id_ext, 0, 16))
+		    strtoull(target->id_ext, NULL, 16) !=
+		    strtoull(conf->rules[rule].id_ext, NULL, 16))
 			continue;
 
 		if (conf->rules[rule].ioc_guid[0] != '\0' &&
 		    ntohll(target->ioc_prof.guid) !=
-		    strtoull(conf->rules[rule].ioc_guid, 0, 16))
+		    strtoull(conf->rules[rule].ioc_guid, NULL, 16))
 			continue;
 
 		if (conf->rules[rule].dgid[0] != '\0') {
 			char tmp = conf->rules[rule].dgid[16];
 			conf->rules[rule].dgid[16] = '\0';
-			if (strtoull(conf->rules[rule].dgid, 0, 16) !=
+			if (strtoull(conf->rules[rule].dgid, NULL, 16) !=
 			    target->subnet_prefix) {
 				conf->rules[rule].dgid[16] = tmp;
 				continue;
 			}
 			conf->rules[rule].dgid[16] = tmp;
-			if (strtoull(&conf->rules[rule].dgid[16], 0, 16) !=
+			if (strtoull(&conf->rules[rule].dgid[16], NULL, 16) !=
 			    target->h_guid)
 				continue;
 		}
 
 		if (conf->rules[rule].service_id[0] != '\0' &&
-		    strtoull(conf->rules[rule].service_id, 0, 16) !=
+		    strtoull(conf->rules[rule].service_id, NULL, 16) !=
 	            target->h_service_id)
 			continue;
 
 		if (conf->rules[rule].pkey[0] != '\0' &&
-		    (uint16_t)strtoul(conf->rules[rule].pkey, 0, 16) !=
+		    (uint16_t)strtoul(conf->rules[rule].pkey, NULL, 16) !=
 	            target->pkey)
 			continue;
 
@@ -436,7 +436,7 @@ static int add_non_exist_target(struct target_details *target)
 		strncpy(subdir_name_ptr, subdir->d_name,
 			MAX_SCSI_HOST_DIR_NAME_LENGTH - prefix_len);
 		if (!check_equal_uint64(scsi_host_dir, "id_ext",
-				        strtoull(target->id_ext, 0, 16)))
+				        strtoull(target->id_ext, NULL, 16)))
 			continue;
 		if (!check_equal_uint16(scsi_host_dir, "pkey", target->pkey) &&
 		    !config->execute)
@@ -1795,7 +1795,7 @@ static int umad_resources_create(struct umad_resources *umad_res)
 
 	umad_res->agent = umad_register(umad_res->portid, SRP_MGMT_CLASS_SA,
 					   SRP_MGMT_CLASS_SA_VERSION,
-					   SRP_SA_RMPP_VERSION, 0);
+					   SRP_SA_RMPP_VERSION, NULL);
 	if (umad_res->agent < 0) {
 		pr_err("umad_register failed\n");
 		return umad_res->agent;
@@ -2064,9 +2064,9 @@ int main(int argc, char *argv[])
 	memset(&sa, 0, sizeof(sa));
 	sigemptyset(&sa.sa_mask);
 	sa.sa_handler = signal_handler;
-	sigaction(SIGINT, &sa, 0);
-	sigaction(SIGTERM, &sa, 0);
-	sigaction(SRP_CATAS_ERR, &sa, 0);
+	sigaction(SIGINT, &sa, NULL);
+	sigaction(SIGTERM, &sa, NULL);
+	sigaction(SRP_CATAS_ERR, &sa, NULL);
 
 	if (strcmp(argv[0] + max_t(int, 0, strlen(argv[0]) - strlen("ibsrpdm")),
 		   "ibsrpdm") == 0) {
@@ -2268,9 +2268,9 @@ close_log:
 	closelog();
 restore_sig:
 	sa.sa_handler = SIG_DFL;
-	sigaction(SIGINT, &sa, 0);
-	sigaction(SIGTERM, &sa, 0);
-	sigaction(SRP_CATAS_ERR, &sa, 0);
+	sigaction(SIGINT, &sa, NULL);
+	sigaction(SIGTERM, &sa, NULL);
+	sigaction(SRP_CATAS_ERR, &sa, NULL);
 close_pipe:
 	close(wakeup_pipe[1]);
 	close(wakeup_pipe[0]);
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
