From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [1/2] support libibnetdisc caching overwrite
	flag
Date: Thu, 15 Apr 2010 16:52:27 -0700
Message-ID: <1271375547.17987.178.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-FIwGfjjv/RCvRywFvXXj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-FIwGfjjv/RCvRywFvXXj
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Sasha,

This patch supports a flag in the libibnetdisc caching code to overwrite
a previous cache.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-FIwGfjjv/RCvRywFvXXj
Content-Disposition: attachment; filename=0001-support-libibnetdisc-caching-overwrite-flag.patch
Content-Type: message/rfc822; name=0001-support-libibnetdisc-caching-overwrite-flag.patch

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Thu, 15 Apr 2010 09:37:44 -0700
Subject: [PATCH] support libibnetdisc caching overwrite flag
Message-Id: <1271375429.17987.176.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 .../libibnetdisc/include/infiniband/ibnetdisc.h    |    3 +++
 .../libibnetdisc/src/ibnetdisc_cache.c             |   17 ++++++++++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
index 136282c..c83bd0b 100644
--- a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
+++ b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
@@ -181,6 +181,9 @@ MAD_EXPORT void ibnd_destroy_fabric(ibnd_fabric_t * fabric);
 MAD_EXPORT ibnd_fabric_t *ibnd_load_fabric(const char *file,
 					   unsigned int flags);
 
+#define IBND_CACHE_FABRIC_FLAG_DEFAULT   0x0000
+#define IBND_CACHE_FABRIC_FLAG_OVERWRITE 0x0001
+
 MAD_EXPORT int ibnd_cache_fabric(ibnd_fabric_t * fabric, const char *file,
 				 unsigned int flags);
 
diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c b/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
index 480a0a2..6cf7d4d 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
@@ -876,9 +876,20 @@ int ibnd_cache_fabric(ibnd_fabric_t * fabric, const char *file,
 		return -1;
 	}
 
-	if (!stat(file, &statbuf)) {
-		IBND_DEBUG("file '%s' already exists\n", file);
-		return -1;
+	if (flags & IBND_CACHE_FABRIC_FLAG_OVERWRITE) {
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
+			return -1;
+		}
 	}
 
 	if ((fd = open(file, O_CREAT | O_EXCL | O_WRONLY, 0644)) < 0) {
-- 
1.5.4.5


--=-FIwGfjjv/RCvRywFvXXj--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
