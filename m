From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3] libibverbs init.c: conditionally emit warning if no userspace driver found
Date: Tue, 12 May 2015 07:14:28 -0700
Message-ID: <1431440068-19037-1-git-send-email-jsquyres@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

It's not a warning or an error if libibverbs cannot find a userspace
driver for kernel devices.  Indeed, returning a num_devices of is
sufficient -- the middleware shouldn't be unconditionally printing out
stderr message; let the upper layer application do that (if it wants
to).

For debugging purposes, if the environment variable IBV_SHOW_WARNINGS
is set (to any value), warnings will be emitted to stderr if a
corresponding userspace driver cannot be found for a kernel device.

Signed-off-by: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 man/ibv_get_device_list.3 | 6 ++++++
 src/init.c                | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/man/ibv_get_device_list.3 b/man/ibv_get_device_list.3
index 16cc1a0..96de554 100644
--- a/man/ibv_get_device_list.3
+++ b/man/ibv_get_device_list.3
@@ -50,6 +50,12 @@ Client code should open all the devices it intends to use with
 Once it frees the array with
 .B ibv_free_device_list()\fR,
 it will be able to use only the open devices; pointers to unopened devices will no longer be valid.
+.P
+Setting the environment variable
+.BR IBV_SHOW_WARNINGS
+will cause warnings to be emitted to stderr if a kernel verbs device
+is discovered, but no corresponding userspace driver can be found for
+it.
 .SH "SEE ALSO"
 .BR ibv_fork_init (3),
 .BR ibv_get_device_name (3),
diff --git a/src/init.c b/src/init.c
index d0e4b1c..dbdd795 100644
--- a/src/init.c
+++ b/src/init.c
@@ -561,7 +561,7 @@ out:
 		     next_dev = sysfs_dev ? sysfs_dev->next : NULL;
 	     sysfs_dev;
 	     sysfs_dev = next_dev, next_dev = sysfs_dev ? sysfs_dev->next : NULL) {
-		if (!sysfs_dev->have_driver) {
+		if (!sysfs_dev->have_driver && getenv("IBV_SHOW_WARNINGS")) {
 			fprintf(stderr, PFX "Warning: no userspace device-specific "
 				"driver found for %s\n", sysfs_dev->sysfs_path);
 			if (statically_linked)
-- 
2.2.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
