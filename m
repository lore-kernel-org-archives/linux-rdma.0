From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 2/5] verbs: Split ibverbs_init functionality
Date: Mon, 10 Jul 2017 18:05:34 +0300
Message-ID: <1499699137-29037-3-git-send-email-yishaih@mellanox.com>
References: <1499699137-29037-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1499699137-29037-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

ibverbs_init is called only in the first time that
ibv_get_device_list is called by the user.

This function does two main things:
1) Initialization actions like fork init, memory check, etc.
2) Scan the sysfs device list and build the cached ibv_device list.

This patch refactors the ibverbs_init and moves out the built
device list code into new function - ibverbs_get_device_list.

Motivation: In downstream patch, we refresh the ibv_device list
according to the updated snapshot of the sysfs devices, so we want
that the initialization action will continue to be singleton, but
rescan the sysfs in each call to ibv_get_device_list.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/init.c | 45 ++++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/libibverbs/init.c b/libibverbs/init.c
index fdabe82..6e453ea 100644
--- a/libibverbs/init.c
+++ b/libibverbs/init.c
@@ -486,9 +486,8 @@ static void add_device(struct ibv_device *dev,
 	(*dev_list)[(*num_devices)++] = dev;
 }
 
-int ibverbs_init(struct ibv_device ***list)
+int ibverbs_get_device_list(struct ibv_device ***list)
 {
-	const char *sysfs_path;
 	struct ibv_sysfs_dev *sysfs_dev, *next_dev;
 	struct ibv_device *device;
 	int num_devices = 0;
@@ -499,23 +498,6 @@ int ibverbs_init(struct ibv_device ***list)
 
 	*list = NULL;
 
-	if (getenv("RDMAV_FORK_SAFE") || getenv("IBV_FORK_SAFE"))
-		if (ibv_fork_init())
-			fprintf(stderr, PFX "Warning: fork()-safety requested "
-				"but init failed\n");
-
-	sysfs_path = ibv_get_sysfs_path();
-	if (!sysfs_path)
-		return -ENOSYS;
-
-	ret = check_abi_version(sysfs_path);
-	if (ret)
-		return -ret;
-
-	check_memlock_limit();
-
-	read_config();
-
 	ret = find_sysfs_devs();
 	if (ret)
 		return -ret;
@@ -582,3 +564,28 @@ out:
 
 	return num_devices;
 }
+
+int ibverbs_init(struct ibv_device ***list)
+{
+	const char *sysfs_path;
+	int ret;
+
+	if (getenv("RDMAV_FORK_SAFE") || getenv("IBV_FORK_SAFE"))
+		if (ibv_fork_init())
+			fprintf(stderr, PFX "Warning: fork()-safety requested "
+				"but init failed\n");
+
+	sysfs_path = ibv_get_sysfs_path();
+	if (!sysfs_path)
+		return -ENOSYS;
+
+	ret = check_abi_version(sysfs_path);
+	if (ret)
+		return -ret;
+
+	check_memlock_limit();
+
+	read_config();
+
+	return ibverbs_get_device_list(list);
+}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
