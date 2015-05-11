From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] libibverbs init.c: remove stderr warnings if no userspace driver found
Date: Mon, 11 May 2015 13:43:40 -0700
Message-ID: <1431377021-27932-1-git-send-email-jsquyres@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Also the statically_linked variable, since it was only used when
printing the stderr warning.

Signed-off-by: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 src/init.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/src/init.c b/src/init.c
index d0e4b1c..190608a 100644
--- a/src/init.c
+++ b/src/init.c
@@ -484,7 +484,6 @@ HIDDEN int ibverbs_init(struct ibv_device ***list)
 	struct ibv_device *device;
 	int num_devices = 0;
 	int list_size = 0;
-	int statically_linked = 0;
 	int no_driver = 0;
 	int ret;
 
@@ -537,7 +536,6 @@ HIDDEN int ibverbs_init(struct ibv_device ***list)
 		if (!hand) {
 			fprintf(stderr, PFX "Warning: dlopen(NULL) failed, "
 				"assuming static linking.\n");
-			statically_linked = 1;
 			goto out;
 		}
 		dlclose(hand);
@@ -561,13 +559,6 @@ out:
 		     next_dev = sysfs_dev ? sysfs_dev->next : NULL;
 	     sysfs_dev;
 	     sysfs_dev = next_dev, next_dev = sysfs_dev ? sysfs_dev->next : NULL) {
-		if (!sysfs_dev->have_driver) {
-			fprintf(stderr, PFX "Warning: no userspace device-specific "
-				"driver found for %s\n", sysfs_dev->sysfs_path);
-			if (statically_linked)
-				fprintf(stderr, "	When linking libibverbs statically, "
-					"driver must be statically linked too.\n");
-		}
 		free(sysfs_dev);
 	}
 
-- 
2.2.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
