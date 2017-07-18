From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] verbs: Avoid load drivers more than one time
Date: Tue, 18 Jul 2017 19:24:09 +0300
Message-ID: <1500395049-23618-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Drivers name list is built only once as part of read_config() and freed
upon load_drivers().

As such, calling load_drivers() more than one time has no sense and
might bring an oops in case there is some kernel driver without a
matching user driver upon the second call.

Fixes: c632072027a8 ('verbs: Refresh cahced ibv_device list')
Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

Pull request was sent:
https://github.com/linux-rdma/rdma-core/pull/169

 libibverbs/init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libibverbs/init.c b/libibverbs/init.c
index b3046b3..1c41b36 100644
--- a/libibverbs/init.c
+++ b/libibverbs/init.c
@@ -495,6 +495,7 @@ int ibverbs_get_device_list(struct list_head *list)
 {
 	struct ibv_sysfs_dev *tmp_sysfs_dev_list = NULL, *sysfs_dev, *next_dev;
 	struct verbs_device *vdev, *tmp;
+	static int drivers_loaded;
 	int num_devices = 0;
 	int statically_linked = 0;
 	int no_driver = 0;
@@ -533,7 +534,7 @@ int ibverbs_get_device_list(struct list_head *list)
 			no_driver = 1;
 	}
 
-	if (!no_driver)
+	if (!no_driver || drivers_loaded)
 		goto out;
 
 	/*
@@ -557,6 +558,7 @@ int ibverbs_get_device_list(struct list_head *list)
 	}
 
 	load_drivers();
+	drivers_loaded = 1;
 
 	for (sysfs_dev = tmp_sysfs_dev_list; sysfs_dev; sysfs_dev =
 	     sysfs_dev->next) {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
