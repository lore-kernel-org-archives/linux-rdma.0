From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH libibverbs] init.c: increase sysfs read buffer size to 16
Date: Thu,  3 Dec 2015 15:09:41 -0800
Message-ID: <1449184181-25676-1-git-send-email-jsquyres@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Xuyang Wang <xuywang-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The default value of 8 is too small to read
/sys/class/infiniband/usnic_x/node_type, which contains "6: usNIC
UDP".  Per a7a73a8c1b39362f1701256bc772d82847832f9c, the too-small
buffer causes a stderr warning to be emitted from ibv_devinfo when
reading usNIC devices.

This commit therefore increases the buffer size to 16, which is long
enough to read the usNIC node_type value.

Signed-off-by: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Xuyang Wang <xuywang-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 src/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/init.c b/src/init.c
index dbdd795..ef78871 100644
--- a/src/init.c
+++ b/src/init.c
@@ -351,7 +351,7 @@ static struct ibv_device *try_driver(struct ibv_driver *driver,
 {
 	struct verbs_device *vdev;
 	struct ibv_device *dev;
-	char value[8];
+	char value[16];
 
 	if (driver->init_func) {
 		dev = driver->init_func(sysfs_dev->sysfs_path, sysfs_dev->abi_ver);
-- 
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
