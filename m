From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v2 15/18] IB/ucm: use stack variable 'base' in ib_ucm_add_one
Date: Tue, 02 Feb 2010 12:09:00 -0700
Message-ID: <20100202190900.28217.53919.stgit@bob.kio>
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

This change is not useful by itself, but sets us up for a future change
that allows us to support more than IB_UCM_MAX_DEVICES.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/infiniband/core/ucm.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index 7ff3300..06c50d8 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -1240,6 +1240,7 @@ static DEVICE_ATTR(ibdev, S_IRUGO, show_ibdev, NULL);
 static void ib_ucm_add_one(struct ib_device *device)
 {
 	int devnum;
+	dev_t base;
 	struct ib_ucm_device *ucm_dev;
 
 	if (!device->alloc_ucontext ||
@@ -1257,12 +1258,13 @@ static void ib_ucm_add_one(struct ib_device *device)
 		goto err;
 
 	ucm_dev->devnum = devnum;
+	base = devnum + IB_UCM_BASE_DEV;
 	set_bit(devnum, dev_map);
 
 	cdev_init(&ucm_dev->cdev, &ucm_fops);
 	ucm_dev->cdev.owner = THIS_MODULE;
 	kobject_set_name(&ucm_dev->cdev.kobj, "ucm%d", ucm_dev->devnum);
-	if (cdev_add(&ucm_dev->cdev, IB_UCM_BASE_DEV + devnum, 1))
+	if (cdev_add(&ucm_dev->cdev, base, 1))
 		goto err;
 
 	ucm_dev->dev.class = &cm_class;
