From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 07/13] ibacm: remove CDECL_FUNC
Date: Mon, 17 Oct 2016 21:11:16 +0200
Message-ID: <1476731482-26491-8-git-send-email-hch@lst.de>
References: <1476731482-26491-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476731482-26491-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 ibacm/linux/osd.h | 2 --
 ibacm/src/acm.c   | 2 +-
 ibacm/src/acme.c  | 2 +-
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/ibacm/linux/osd.h b/ibacm/linux/osd.h
index 5fafd4d..12877f4 100644
--- a/ibacm/linux/osd.h
+++ b/ibacm/linux/osd.h
@@ -53,8 +53,6 @@
 #define ACM_ADDR_FILE "ibacm_addr.cfg"
 #define ACM_OPTS_FILE "ibacm_opts.cfg"
 
-#define CDECL_FUNC
-
 #if DEFINE_ATOMICS
 typedef struct { pthread_mutex_t mut; int val; } atomic_t;
 static inline int atomic_inc(atomic_t *atomic)
diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
index 508148a..056824d 100644
--- a/ibacm/src/acm.c
+++ b/ibacm/src/acm.c
@@ -3049,7 +3049,7 @@ static void show_usage(char *program)
 	printf("                      (default %s/%s)\n", ACM_CONF_DIR, ACM_OPTS_FILE);
 }
 
-int CDECL_FUNC main(int argc, char **argv)
+int main(int argc, char **argv)
 {
 	int i, op, daemon = 1;
 
diff --git a/ibacm/src/acme.c b/ibacm/src/acme.c
index a924dad..c5be0a3 100644
--- a/ibacm/src/acme.c
+++ b/ibacm/src/acme.c
@@ -983,7 +983,7 @@ static void parse_perf_arg(char *arg)
 	}
 }
 
-int CDECL_FUNC main(int argc, char **argv)
+int main(int argc, char **argv)
 {
 	int op, ret;
 	int make_addr = 0;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
