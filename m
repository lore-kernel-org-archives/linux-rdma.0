From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [2/3] support libibnetdisc caching no-overwrite
	flag
Date: Mon, 19 Apr 2010 11:43:15 -0700
Message-ID: <1271702595.17987.214.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-y04pfogm7IqhYvSsEPph"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-y04pfogm7IqhYvSsEPph
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hey Sasha,

This patch adds a flag to support a no-overwrite caching flag for
libibnetdisc.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-y04pfogm7IqhYvSsEPph
Content-Disposition: attachment; filename=0002-support-libibnetdisc-caching-no-overwrite-flag.patch
Content-Type: message/rfc822; name=0002-support-libibnetdisc-caching-no-overwrite-flag.patch

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Mon, 19 Apr 2010 11:09:37 -0700
Subject: [PATCH] support libibnetdisc caching no-overwrite flag
Message-Id: <1271702059.17987.207.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 .../libibnetdisc/include/infiniband/ibnetdisc.h    |    3 +++
 .../libibnetdisc/src/ibnetdisc_cache.c             |   16 ++++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
index 136282c..865c1e0 100644
--- a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
+++ b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
@@ -181,6 +181,9 @@ MAD_EXPORT void ibnd_destroy_fabric(ibnd_fabric_t * fabric);
 MAD_EXPORT ibnd_fabric_t *ibnd_load_fabric(const char *file,
 					   unsigned int flags);
 
+#define IBND_CACHE_FABRIC_FLAG_DEFAULT      0x0000
+#define IBND_CACHE_FABRIC_FLAG_NO_OVERWRITE 0x0001
+
 MAD_EXPORT int ibnd_cache_fabric(ibnd_fabric_t * fabric, const char *file,
 				 unsigned int flags);
 
diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c b/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
index e05ce99..56b59fb 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
@@ -888,10 +888,18 @@ int ibnd_cache_fabric(ibnd_fabric_t * fabric, const char *file,
 		return -1;
 	}
 
-	if (!stat(file, &statbuf)) {
-		if (unlink(file) < 0) {
-			IBND_DEBUG("error removing '%s': %s\n",
-				   file, strerror(errno));
+	if (!(flags & IBND_CACHE_FABRIC_FLAG_NO_OVERWRITE)) {
+		if (!stat(file, &statbuf)) {
+			if (unlink(file) < 0) {
+				IBND_DEBUG("error removing '%s': %s\n",
+					   file, strerror(errno));
+				return -1;
+			}
+		}
+	}
+	else {
+		if (!stat(file, &statbuf)) {
+			IBND_DEBUG("file '%s' already exists\n", file);
 			return -1;
 		}
 	}
-- 
1.5.4.5


--=-y04pfogm7IqhYvSsEPph--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
