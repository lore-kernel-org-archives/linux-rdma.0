From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v2 01/18] IB/uverbs: convert *cdev to cdev in struct
	ib_uverbs_device
Date: Tue, 02 Feb 2010 12:07:49 -0700
Message-ID: <20100202190749.28217.21875.stgit@bob.kio>
References: <20100202185235.28217.64521.stgit@bob.kio>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100202185235.28217.64521.stgit@bob.kio>
Sender: linux-kernel-owner@vger.kernel.org
To: rdreier@cisco.com
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Instead of storing a pointer to a cdev, embed the entire struct cdev.

This change allows us to use the container_of() macro in
ib_uverbs_open() in a future patch.

This change increases the size of struct ib_uverbs_device to
168 bytes across 3 cachelines from 80 bytes in 2 cachelines.
However, we rearrange the members so that everything fits into
the first cacheline except for the struct cdev. Finally, we don't
touch the cdev in any fastpaths, so this change shouldn't negatively
affect performance.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/infiniband/core/uverbs.h      |    7 ++++---
 drivers/infiniband/core/uverbs_main.c |   23 ++++++++++-------------
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index b3ea958..e695f65 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -41,6 +41,7 @@
 #include <linux/idr.h>
 #include <linux/mutex.h>
 #include <linux/completion.h>
+#include <linux/cdev.h>
 
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_umem.h>
@@ -69,12 +70,12 @@
 
 struct ib_uverbs_device {
 	struct kref				ref;
+	int					num_comp_vectors;
 	struct completion			comp;
-	int					devnum;
-	struct cdev			       *cdev;
 	struct device			       *dev;
 	struct ib_device		       *ib_dev;
-	int					num_comp_vectors;
+	int					devnum;
+	struct cdev			        cdev;
 };
 
 struct ib_uverbs_event_file {
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 5f284ff..5da9a73 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -43,7 +43,6 @@
 #include <linux/sched.h>
 #include <linux/file.h>
 #include <linux/mount.h>
-#include <linux/cdev.h>
 
 #include <asm/uaccess.h>
 
@@ -761,17 +760,15 @@ static void ib_uverbs_add_one(struct ib_device *device)
 	uverbs_dev->ib_dev           = device;
 	uverbs_dev->num_comp_vectors = device->num_comp_vectors;
 
-	uverbs_dev->cdev = cdev_alloc();
-	if (!uverbs_dev->cdev)
-		goto err;
-	uverbs_dev->cdev->owner = THIS_MODULE;
-	uverbs_dev->cdev->ops = device->mmap ? &uverbs_mmap_fops : &uverbs_fops;
-	kobject_set_name(&uverbs_dev->cdev->kobj, "uverbs%d", uverbs_dev->devnum);
-	if (cdev_add(uverbs_dev->cdev, IB_UVERBS_BASE_DEV + uverbs_dev->devnum, 1))
+	cdev_init(&uverbs_dev->cdev, NULL);
+	uverbs_dev->cdev.owner = THIS_MODULE;
+	uverbs_dev->cdev.ops = device->mmap ? &uverbs_mmap_fops : &uverbs_fops;
+	kobject_set_name(&uverbs_dev->cdev.kobj, "uverbs%d", uverbs_dev->devnum);
+	if (cdev_add(&uverbs_dev->cdev, IB_UVERBS_BASE_DEV + uverbs_dev->devnum, 1))
 		goto err_cdev;
 
 	uverbs_dev->dev = device_create(uverbs_class, device->dma_device,
-					uverbs_dev->cdev->dev, uverbs_dev,
+					uverbs_dev->cdev.dev, uverbs_dev,
 					"uverbs%d", uverbs_dev->devnum);
 	if (IS_ERR(uverbs_dev->dev))
 		goto err_cdev;
@@ -790,10 +787,10 @@ static void ib_uverbs_add_one(struct ib_device *device)
 	return;
 
 err_class:
-	device_destroy(uverbs_class, uverbs_dev->cdev->dev);
+	device_destroy(uverbs_class, uverbs_dev->cdev.dev);
 
 err_cdev:
-	cdev_del(uverbs_dev->cdev);
+	cdev_del(&uverbs_dev->cdev);
 	clear_bit(uverbs_dev->devnum, dev_map);
 
 err:
@@ -811,8 +808,8 @@ static void ib_uverbs_remove_one(struct ib_device *device)
 		return;
 
 	dev_set_drvdata(uverbs_dev->dev, NULL);
-	device_destroy(uverbs_class, uverbs_dev->cdev->dev);
-	cdev_del(uverbs_dev->cdev);
+	device_destroy(uverbs_class, uverbs_dev->cdev.dev);
+	cdev_del(&uverbs_dev->cdev);
 
 	spin_lock(&map_lock);
 	dev_table[uverbs_dev->devnum] = NULL;
