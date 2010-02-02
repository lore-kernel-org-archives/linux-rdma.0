From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v2 03/18] IB/uverbs: use stack variable 'devnum' in
	ib_uverbs_add_one
Date: Tue, 02 Feb 2010 12:07:59 -0700
Message-ID: <20100202190759.28217.75429.stgit@bob.kio>
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

This change is not useful by itself, but it sets us up for a future
change that allows us to dynamically allocate device numbers in case
we have more than IB_UVERBS_MAX_DEVICES in the system.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/infiniband/core/uverbs_main.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 3f11292..acae9ed 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -730,6 +730,7 @@ static CLASS_ATTR(abi_version, S_IRUGO, show_abi_version, NULL);
 
 static void ib_uverbs_add_one(struct ib_device *device)
 {
+	int devnum;
 	struct ib_uverbs_device *uverbs_dev;
 
 	if (!device->alloc_ucontext)
@@ -743,12 +744,13 @@ static void ib_uverbs_add_one(struct ib_device *device)
 	init_completion(&uverbs_dev->comp);
 
 	spin_lock(&map_lock);
-	uverbs_dev->devnum = find_first_zero_bit(dev_map, IB_UVERBS_MAX_DEVICES);
-	if (uverbs_dev->devnum >= IB_UVERBS_MAX_DEVICES) {
+	devnum = find_first_zero_bit(dev_map, IB_UVERBS_MAX_DEVICES);
+	if (devnum >= IB_UVERBS_MAX_DEVICES) {
 		spin_unlock(&map_lock);
 		goto err;
 	}
-	set_bit(uverbs_dev->devnum, dev_map);
+	uverbs_dev->devnum = devnum;
+	set_bit(devnum, dev_map);
 	spin_unlock(&map_lock);
 
 	uverbs_dev->ib_dev           = device;
@@ -758,7 +760,7 @@ static void ib_uverbs_add_one(struct ib_device *device)
 	uverbs_dev->cdev.owner = THIS_MODULE;
 	uverbs_dev->cdev.ops = device->mmap ? &uverbs_mmap_fops : &uverbs_fops;
 	kobject_set_name(&uverbs_dev->cdev.kobj, "uverbs%d", uverbs_dev->devnum);
-	if (cdev_add(&uverbs_dev->cdev, IB_UVERBS_BASE_DEV + uverbs_dev->devnum, 1))
+	if (cdev_add(&uverbs_dev->cdev, IB_UVERBS_BASE_DEV + devnum, 1))
 		goto err_cdev;
 
 	uverbs_dev->dev = device_create(uverbs_class, device->dma_device,
@@ -781,7 +783,7 @@ err_class:
 
 err_cdev:
 	cdev_del(&uverbs_dev->cdev);
-	clear_bit(uverbs_dev->devnum, dev_map);
+	clear_bit(devnum, dev_map);
 
 err:
 	kref_put(&uverbs_dev->ref, ib_uverbs_release_dev);
