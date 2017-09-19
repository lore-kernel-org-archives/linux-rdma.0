From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 05/10] verbs: Remove the init_device entry point
Date: Tue, 19 Sep 2017 15:18:46 -0600
Message-ID: <1505855931-4956-6-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1505855931-4956-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1505855931-4956-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

All providers are converted now.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibverbs/driver.h |  2 --
 libibverbs/init.c   | 22 +++++++---------------
 2 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index 397441f49a0e5a..168728cfa1a524 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -129,8 +129,6 @@ struct verbs_device_ops {
 			       struct ibv_context *ctx);
 
 	struct verbs_device *(*alloc_device)(struct verbs_sysfs_dev *sysfs_dev);
-	struct verbs_device *(*init_device)(const char *uverbs_sys_path,
-					    int abi_version);
 	void (*uninit_device)(struct verbs_device *device);
 };
 
diff --git a/libibverbs/init.c b/libibverbs/init.c
index 2369a1df6e1fbd..d75d70b195a6f6 100644
--- a/libibverbs/init.c
+++ b/libibverbs/init.c
@@ -367,22 +367,14 @@ static struct verbs_device *try_driver(const struct verbs_device_ops *ops,
 	struct ibv_device *dev;
 	char value[16];
 
-	if (ops->alloc_device) {
-		if (!match_device(ops, sysfs_dev))
-			return NULL;
+	if (!match_device(ops, sysfs_dev))
+		return NULL;
 
-		vdev = ops->alloc_device(sysfs_dev);
-		if (!vdev) {
-			fprintf(stderr, PFX
-				"Fatal: couldn't allocate device for %s\n",
-				sysfs_dev->ibdev_path);
-			return NULL;
-		}
-	} else {
-		vdev =
-		    ops->init_device(sysfs_dev->sysfs_path, sysfs_dev->abi_ver);
-		if (!vdev)
-			return NULL;
+	vdev = ops->alloc_device(sysfs_dev);
+	if (!vdev) {
+		fprintf(stderr, PFX "Fatal: couldn't allocate device for %s\n",
+			sysfs_dev->ibdev_path);
+		return NULL;
 	}
 
 	vdev->ops = ops;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
