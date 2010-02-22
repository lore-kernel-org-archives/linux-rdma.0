From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] RDMA/cxgb3: Mark rdma device with CXIO_ERROR_FATAL when
	removing.
Date: Mon, 22 Feb 2010 16:07:22 -0600
Message-ID: <20100222220722.20959.48045.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If cxgb3 calls the iw_cxgb3 t3cclient remove function due to a device
removal event, then the iwch device must be marked with CXIO_ERROR_FATAL
since the device below us is going away.  Otherwise, we can get stuck in
a deadlock as rdma ULPs try and deallocate objects (like MRs, QPs, etc).
So always mark the device with CXIO_ERROR_FATAL when removing.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb3/iwch.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch.c b/drivers/infiniband/hw/cxgb3/iwch.c
index 6a3214a..1ce6509 100644
--- a/drivers/infiniband/hw/cxgb3/iwch.c
+++ b/drivers/infiniband/hw/cxgb3/iwch.c
@@ -188,6 +188,7 @@ static void close_rnic_dev(struct t3cdev *tdev)
 	mutex_lock(&dev_mutex);
 	list_for_each_entry_safe(dev, tmp, &dev_list, entry) {
 		if (dev->rdev.t3cdev_p == tdev) {
+			dev->rdev.flags = CXIO_ERROR_FATAL;
 			cancel_delayed_work_sync(&dev->db_drop_task);
 			list_del(&dev->entry);
 			iwch_unregister_device(dev);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
