From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] libibmad: libibumad: Print warnings and errors to stderr
 not stdout
Date: Tue, 17 Nov 2009 14:38:10 -0800
Message-ID: <20091117143810.81ade4b4.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 17 Nov 2009 14:39:37 -0800
Subject: [PATCH] libibmad: libibumad: Print warnings and errors to stderr not stdout


Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 libibmad/include/infiniband/mad.h |    4 ++--
 libibumad/src/umad.c              |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/libibmad/include/infiniband/mad.h b/libibmad/include/infiniband/mad.h
index ed8fd71..9347bc2 100644
--- a/libibmad/include/infiniband/mad.h
+++ b/libibmad/include/infiniband/mad.h
@@ -1018,11 +1018,11 @@ static inline uint64_t htonll(uint64_t x)
 #define ALIGN(l, size) (((l) + ((size) - 1)) / (size) * (size))
 
 /** printf style warning MACRO, includes name of function and pid */
-#define IBWARN(fmt, ...) fprintf(stdout, "ibwarn: [%d] %s: " fmt "\n", getpid(), __func__, ## __VA_ARGS__)
+#define IBWARN(fmt, ...) fprintf(stderr, "ibwarn: [%d] %s: " fmt "\n", getpid(), __func__, ## __VA_ARGS__)
 
 /** printf style abort MACRO, includes name of function and pid */
 #define IBPANIC(fmt, ...) do { \
-	fprintf(stdout, "ibpanic: [%d] %s: " fmt ": %m\n", getpid(), __func__, ## __VA_ARGS__); \
+	fprintf(stderr, "ibpanic: [%d] %s: " fmt ": %m\n", getpid(), __func__, ## __VA_ARGS__); \
 	exit(-1); \
 } while(0)
 
diff --git a/libibumad/src/umad.c b/libibumad/src/umad.c
index cdf6b46..277ae6b 100644
--- a/libibumad/src/umad.c
+++ b/libibumad/src/umad.c
@@ -83,7 +83,7 @@ extern int sys_read_gid(char *dir_name, char *file_name, uint8_t * gid);
 extern int sys_read_uint64(char *dir_name, char *file_name, uint64_t * u);
 extern int sys_read_uint(char *dir_name, char *file_name, unsigned *u);
 
-#define IBWARN(fmt, args...) fprintf(stdout, "ibwarn: [%d] %s: " fmt "\n", getpid(), __func__, ## args)
+#define IBWARN(fmt, args...) fprintf(stderr, "ibwarn: [%d] %s: " fmt "\n", getpid(), __func__, ## args)
 
 #define TRACE	if (umaddebug)	IBWARN
 #define DEBUG	if (umaddebug)	IBWARN
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
