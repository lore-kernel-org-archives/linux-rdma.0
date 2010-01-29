From: Alex Chiang <achiang@hp.com>
Subject: [PATCH 4/7] IB/uverbs: use stack variable 'base' in ib_uverbs_add_one
Date: Fri, 29 Jan 2010 14:45:18 -0700
Message-ID: <20100129214518.17745.15314.stgit@bob.kio>
References: <20100129214039.17745.38679.stgit@bob.kio>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755163Ab0A2VqI@vger.kernel.org>
In-Reply-To: <20100129214039.17745.38679.stgit@bob.kio>
Sender: linux-kernel-owner@vger.kernel.org
To: rdreier@cisco.com
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This change is not useful by itself, but sets us up for a future change
that allows us to support more than IB_UVERBS_MAX_DEVICES in a system.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/infiniband/core/uverbs_main.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index acae9ed..a5d441d 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -730,7 +730,7 @@ static CLASS_ATTR(abi_version, S_IRUGO, show_abi_version, NULL);
 
 static void ib_uverbs_add_one(struct ib_device *device)
 {
-	int devnum;
+	int devnum, base;
 	struct ib_uverbs_device *uverbs_dev;
 
 	if (!device->alloc_ucontext)
@@ -750,6 +750,7 @@ static void ib_uverbs_add_one(struct ib_device *device)
 		goto err;
 	}
 	uverbs_dev->devnum = devnum;
+	base = devnum + IB_UVERBS_BASE_DEV;
 	set_bit(devnum, dev_map);
 	spin_unlock(&map_lock);
 
@@ -760,7 +761,7 @@ static void ib_uverbs_add_one(struct ib_device *device)
 	uverbs_dev->cdev.owner = THIS_MODULE;
 	uverbs_dev->cdev.ops = device->mmap ? &uverbs_mmap_fops : &uverbs_fops;
 	kobject_set_name(&uverbs_dev->cdev.kobj, "uverbs%d", uverbs_dev->devnum);
-	if (cdev_add(&uverbs_dev->cdev, IB_UVERBS_BASE_DEV + devnum, 1))
+	if (cdev_add(&uverbs_dev->cdev, base, 1))
 		goto err_cdev;
 
 	uverbs_dev->dev = device_create(uverbs_class, device->dma_device,
