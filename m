From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] libibverbs init.c: remove stderr warnings if no userspace driver found
Date: Fri,  8 May 2015 11:21:54 -0700
Message-ID: <1431109314-31662-1-git-send-email-jsquyres@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 src/init.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/src/init.c b/src/init.c
index d0e4b1c..9c21768 100644
--- a/src/init.c
+++ b/src/init.c
@@ -557,19 +557,5 @@ HIDDEN int ibverbs_init(struct ibv_device ***list)
 	}
 
 out:
-	for (sysfs_dev = sysfs_dev_list,
-		     next_dev = sysfs_dev ? sysfs_dev->next : NULL;
-	     sysfs_dev;
-	     sysfs_dev = next_dev, next_dev = sysfs_dev ? sysfs_dev->next : NULL) {
-		if (!sysfs_dev->have_driver) {
-			fprintf(stderr, PFX "Warning: no userspace device-specific "
-				"driver found for %s\n", sysfs_dev->sysfs_path);
-			if (statically_linked)
-				fprintf(stderr, "	When linking libibverbs statically, "
-					"driver must be statically linked too.\n");
-		}
-		free(sysfs_dev);
-	}
-
 	return num_devices;
 }
-- 
2.2.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
