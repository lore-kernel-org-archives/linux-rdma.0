From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 08/13] ibacm: remove no-op osd_init/osd_close macros
Date: Mon, 17 Oct 2016 21:11:17 +0200
Message-ID: <1476731482-26491-9-git-send-email-hch@lst.de>
References: <1476731482-26491-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476731482-26491-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 ibacm/linux/osd.h          | 3 ---
 ibacm/prov/acmp/src/acmp.c | 3 ---
 ibacm/src/acm.c            | 3 ---
 ibacm/src/acme.c           | 8 +-------
 4 files changed, 1 insertion(+), 16 deletions(-)

diff --git a/ibacm/linux/osd.h b/ibacm/linux/osd.h
index 12877f4..ee582bb 100644
--- a/ibacm/linux/osd.h
+++ b/ibacm/linux/osd.h
@@ -112,9 +112,6 @@ static inline int event_wait(event_t *e, int timeout)
 	return ret;
 }
 
-#define osd_init()  0
-#define osd_close()
-
 static inline uint64_t time_stamp_us(void)
 {
 	struct timeval curtime;
diff --git a/ibacm/prov/acmp/src/acmp.c b/ibacm/prov/acmp/src/acmp.c
index 1f3aeef..4cda359 100644
--- a/ibacm/prov/acmp/src/acmp.c
+++ b/ibacm/prov/acmp/src/acmp.c
@@ -2941,9 +2941,6 @@ static void acmp_log_options(void)
 
 static void __attribute__((constructor)) acmp_init(void)
 {
-	if (osd_init())
-		return;
-
 	acmp_set_options();
 
 	acmp_log_options();
diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
index 056824d..912d563 100644
--- a/ibacm/src/acm.c
+++ b/ibacm/src/acm.c
@@ -3076,9 +3076,6 @@ int main(int argc, char **argv)
 	if (daemon)
 		daemonize();
 
-	if (osd_init())
-		return -1;
-
 	acm_set_options();
 	if (acm_open_lock_file())
 		return -1;
diff --git a/ibacm/src/acme.c b/ibacm/src/acme.c
index c5be0a3..f2c9348 100644
--- a/ibacm/src/acme.c
+++ b/ibacm/src/acme.c
@@ -985,14 +985,10 @@ static void parse_perf_arg(char *arg)
 
 int main(int argc, char **argv)
 {
-	int op, ret;
+	int op, ret = 0;
 	int make_addr = 0;
 	int make_opts = 0;
 
-	ret = osd_init();
-	if (ret)
-		goto out;
-
 	while ((op = getopt(argc, argv, "e::f:s:d:vcA::O::D:P::S:C:V")) != -1) {
 		switch (op) {
 		case 'e':
@@ -1068,8 +1064,6 @@ int main(int argc, char **argv)
 	if (!ret && make_opts)
 		ret = gen_opts();
 
-	osd_close();
-out:
 	if (verbose || !(make_addr || make_opts) || ret)
 		printf("return status 0x%x\n", ret);
 	return ret;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
