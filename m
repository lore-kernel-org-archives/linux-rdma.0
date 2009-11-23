From: Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH]: Add different print macros
Date: Mon, 23 Nov 2009 12:04:19 +0200
Message-ID: <4B0A5E23.9000104@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add different print macros for warning, verbose and
debug messages.

Signed-off-by: Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/include/ibdiag_common.h |    4 ++--
 libibmad/include/infiniband/mad.h        |    6 ++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/infiniband-diags/include/ibdiag_common.h b/infiniband-diags/include/ibdiag_common.h
index 74f6deb..9b2add7 100644
--- a/infiniband-diags/include/ibdiag_common.h
+++ b/infiniband-diags/include/ibdiag_common.h
@@ -50,10 +50,10 @@ extern int ibd_timeout;
 
 #undef DEBUG
 #define DEBUG(fmt, ...) do { \
-	if (ibdebug || ibverbose) IBWARN(fmt, ## __VA_ARGS__); \
+	if (ibdebug) IBDEBUG(fmt, ## __VA_ARGS__); \
 } while (0)
 #define VERBOSE(fmt, ...) do { \
-	if (ibdebug || ibverbose > 1) IBWARN(fmt, ## __VA_ARGS__); \
+	if (ibverbose) IBVERBOSE(fmt, ## __VA_ARGS__); \
 } while (0)
 #define IBERROR(fmt, ...) iberror(__FUNCTION__, fmt, ## __VA_ARGS__)
 
diff --git a/libibmad/include/infiniband/mad.h b/libibmad/include/infiniband/mad.h
index 9347bc2..2e407b0 100644
--- a/libibmad/include/infiniband/mad.h
+++ b/libibmad/include/infiniband/mad.h
@@ -1020,6 +1020,12 @@ static inline uint64_t htonll(uint64_t x)
 /** printf style warning MACRO, includes name of function and pid */
 #define IBWARN(fmt, ...) fprintf(stderr, "ibwarn: [%d] %s: " fmt "\n", getpid(), __func__, ## __VA_ARGS__)
 
+/** printf style debug MACRO, includes name of function and pid */
+#define IBDEBUG(fmt, ...) fprintf(stdout, "ibdebug: [%d] %s: " fmt "\n", getpid(), __func__, ## __VA_ARGS__)
+
+/** printf style verbose MACRO, includes name of function and pid */
+#define IBVERBOSE(fmt, ...) fprintf(stdout, "[%d] %s: " fmt "\n", getpid(), __func__, ## __VA_ARGS__)
+
 /** printf style abort MACRO, includes name of function and pid */
 #define IBPANIC(fmt, ...) do { \
 	fprintf(stderr, "ibpanic: [%d] %s: " fmt ": %m\n", getpid(), __func__, ## __VA_ARGS__); \
-- 
1.6.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
