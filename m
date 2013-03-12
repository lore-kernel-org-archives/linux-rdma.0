From: Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] libibmad: To fix compilation warning: need typecasts
Date: Tue, 12 Mar 2013 12:39:42 -0700
Message-ID: <513F847E.7000709@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Brendan Doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Signed-off-by: Brendan Doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/infiniband/mad.h |   12 ++++++++----
 src/fields.c             |    8 ++++----
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/infiniband/mad.h b/include/infiniband/mad.h
index 02b2353..cefcc54 100644
--- a/include/infiniband/mad.h
+++ b/include/infiniband/mad.h
@@ -1655,14 +1655,18 @@ static inline uint64_t htonll(uint64_t x)
 #define ALIGN(l, size) (((l) + ((size) - 1)) / (size) * (size))
 
 /** printf style warning MACRO, includes name of function and pid */
-#define IBWARN(fmt, ...) fprintf(stderr, "ibwarn: [%d] %s: " fmt "\n", getpid(), __func__, ## __VA_ARGS__)
+#define IBWARN(fmt, ...) fprintf(stderr, "ibwarn: [%d] %s: " fmt "\n", \
+(int)getpid(), __func__, ## __VA_ARGS__)
 
-#define IBDEBUG(fmt, ...) fprintf(stdout, "ibdebug: [%d] %s: " fmt "\n", getpid(), __func__, ## __VA_ARGS__)
+#define IBDEBUG(fmt, ...) fprintf(stdout, "ibdebug: [%d] %s: " fmt "\n", \
+(int)getpid(), __func__, ## __VA_ARGS__)
 
-#define IBVERBOSE(fmt, ...) fprintf(stdout, "[%d] %s: " fmt "\n", getpid(), __func__, ## __VA_ARGS__)
+#define IBVERBOSE(fmt, ...) fprintf(stdout, "[%d] %s: " fmt "\n", \
+(int)getpid(), __func__, ## __VA_ARGS__)
 
 #define IBPANIC(fmt, ...) do { \
-	fprintf(stderr, "ibpanic: [%d] %s: " fmt ": %m\n", getpid(), __func__, ## __VA_ARGS__); \
+	fprintf(stderr, "ibpanic: [%d] %s: " fmt ": %m\n", \
+	(int)getpid(), __func__, ## __VA_ARGS__); \
 	exit(-1); \
 } while(0)
 
diff --git a/src/fields.c b/src/fields.c
index d2b6792..33a6364 100644
--- a/src/fields.c
+++ b/src/fields.c
@@ -959,15 +959,15 @@ static void _set_field64(void *buf, int base_offs, const ib_field_t * f,
 	uint64_t nval;
 
 	nval = htonll(val);
-	memcpy((char *)buf + base_offs + f->bitoffs / 8, &nval,
-	       sizeof(uint64_t));
+	memcpy(((void *)(char *)buf + base_offs + f->bitoffs / 8),
+		(void *)&nval, sizeof(uint64_t));
 }
 
 static uint64_t _get_field64(void *buf, int base_offs, const ib_field_t * f)
 {
 	uint64_t val;
-	memcpy(&val, ((char *)buf + base_offs + f->bitoffs / 8),
-	       sizeof(uint64_t));
+	memcpy((void *)&val, (void *)((char *)buf + base_offs + f->bitoffs / 8),
+		sizeof(uint64_t));
 	return ntohll(val);
 }
 
-- 
1.7.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
