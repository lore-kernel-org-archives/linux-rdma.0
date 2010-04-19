From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [1/3] make libibnetdisc default behavior to
	overwrite a cache
Date: Mon, 19 Apr 2010 11:43:07 -0700
Message-ID: <1271702587.17987.212.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-TPS8G2yRmVeIl9dlmNmu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-TPS8G2yRmVeIl9dlmNmu
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hey Sasha,

As discussed in a previous thread, this patch makes the default caching
behavior in libibnetdisc to overwrite a previous cache.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-TPS8G2yRmVeIl9dlmNmu
Content-Disposition: attachment; filename*0=0001-make-libibnetdisc-default-behavior-to-overwrite-a-ca.pat; filename*1=ch
Content-Type: message/rfc822; name=0001-make-libibnetdisc-default-behavior-to-overwrite-a-ca.patch

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Mon, 19 Apr 2010 10:52:14 -0700
Subject: [PATCH] make libibnetdisc default behavior to overwrite a cache
Message-Id: <1271702059.17987.211.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 .../libibnetdisc/src/ibnetdisc_cache.c             |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c b/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
index 5acb8f6..e05ce99 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
@@ -889,8 +889,11 @@ int ibnd_cache_fabric(ibnd_fabric_t * fabric, const char *file,
 	}
 
 	if (!stat(file, &statbuf)) {
-		IBND_DEBUG("file '%s' already exists\n", file);
-		return -1;
+		if (unlink(file) < 0) {
+			IBND_DEBUG("error removing '%s': %s\n",
+				   file, strerror(errno));
+			return -1;
+		}
 	}
 
 	if ((fd = open(file, O_CREAT | O_EXCL | O_WRONLY, 0644)) < 0) {
-- 
1.5.4.5


--=-TPS8G2yRmVeIl9dlmNmu--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
