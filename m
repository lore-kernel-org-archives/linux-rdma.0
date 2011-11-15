From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/2] libibverbs: fix memory leaks in various error flows in the library source code
Date: Tue, 15 Nov 2011 14:40:51 +0200
Message-ID: <201111151440.51561.dotanb@sw.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 src/cmd.c        |    4 +++-
 src/compat-1_0.c |    5 ++++-
 src/init.c       |    3 ++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/src/cmd.c b/src/cmd.c
index 39af833..1a04228 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -68,8 +68,10 @@ static int ibv_cmd_get_context_v2(struct ibv_context *context,
 	IBV_INIT_CMD_RESP(cmd, cmd_size, GET_CONTEXT, resp, resp_size);
 	cmd->cq_fd_tab = (uintptr_t) &cq_fd;
 
-	if (write(context->cmd_fd, cmd, cmd_size) != cmd_size)
+	if (write(context->cmd_fd, cmd, cmd_size) != cmd_size) {
+		free(t);
 		return errno;
+	}
 
 	VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
 
diff --git a/src/compat-1_0.c b/src/compat-1_0.c
index 3f5ff35..fff6412 100644
--- a/src/compat-1_0.c
+++ b/src/compat-1_0.c
@@ -238,7 +238,7 @@ struct ibv_device_1_0 **__ibv_get_device_list_1_0(int *num)
 
 	l = calloc(n + 2, sizeof (struct ibv_device_1_0 *));
 	if (!l)
-		return NULL;
+		goto free_device_list;
 
 	l[0] = (void *) real_list;
 
@@ -258,6 +258,9 @@ fail:
 	for (i = 1; i <= n; ++i)
 		if (l[i])
 			free(l[i]);
+	free(l);
+
+free_device_list:
 	ibv_free_device_list(real_list);
 	return NULL;
 }
diff --git a/src/init.c b/src/init.c
index 06e550d..8d6786e 100644
--- a/src/init.c
+++ b/src/init.c
@@ -309,7 +309,7 @@ static void read_config(void)
 		if (asprintf(&path, "%s/%s", IBV_CONFIG_DIR, dent->d_name) < 0) {
 			fprintf(stderr, PFX "Warning: couldn't read config file %s/%s.\n",
 				IBV_CONFIG_DIR, dent->d_name);
-			return;
+			goto out;
 		}
 
 		if (stat(path, &buf)) {
@@ -326,6 +326,7 @@ next:
 		free(path);
 	}
 
+out:
 	closedir(conf_dir);
 }
 
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
