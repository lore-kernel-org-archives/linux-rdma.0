From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] IB core: Fix locking on device numbers allocation
Date: Tue, 23 Mar 2010 21:13:17 +0200
Message-ID: <20100323191317.GA14496@mtldesk030.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When the driver needs to dynamically allocate char device numbers in systems
with more than IB_UVERBS_MAX_DEVICES, it releases map lock, allocates a new
range and a new device number from that range, and only then re-acquires the
lock. This must be protected for the same reasoning that the map_lock spinlock
is used. Without protecting we could also end up calling alloc_chrdev_region()
a nubmer of times and cause a leakage. Fix this by replacing map_lock with a
mutex and apply on the all the allocation code.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index d805cf3..9589c71 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -72,7 +72,7 @@ DEFINE_IDR(ib_uverbs_cq_idr);
 DEFINE_IDR(ib_uverbs_qp_idr);
 DEFINE_IDR(ib_uverbs_srq_idr);
 
-static DEFINE_SPINLOCK(map_lock);
+static DEFINE_MUTEX(map_lock);
 static DECLARE_BITMAP(dev_map, IB_UVERBS_MAX_DEVICES);
 
 static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
@@ -738,15 +738,15 @@ static void ib_uverbs_add_one(struct ib_device *device)
 	kref_init(&uverbs_dev->ref);
 	init_completion(&uverbs_dev->comp);
 
-	spin_lock(&map_lock);
+	mutex_lock(&map_lock);
 	devnum = find_first_zero_bit(dev_map, IB_UVERBS_MAX_DEVICES);
 	if (devnum >= IB_UVERBS_MAX_DEVICES) {
-		spin_unlock(&map_lock);
 		devnum = find_overflow_devnum();
-		if (devnum < 0)
+		if (devnum < 0) {
+			mutex_unlock(&map_lock);
 			goto err;
+		}
 
-		spin_lock(&map_lock);
 		uverbs_dev->devnum = devnum + IB_UVERBS_MAX_DEVICES;
 		base = devnum + overflow_maj;
 		set_bit(devnum, overflow_map);
@@ -755,7 +755,7 @@ static void ib_uverbs_add_one(struct ib_device *device)
 		base = devnum + IB_UVERBS_BASE_DEV;
 		set_bit(devnum, dev_map);
 	}
-	spin_unlock(&map_lock);
+	mutex_unlock(&map_lock);
 
 	uverbs_dev->ib_dev           = device;
 	uverbs_dev->num_comp_vectors = device->num_comp_vectors;
-- 
1.7.0.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
