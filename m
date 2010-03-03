From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] RDMA/cxgb3: wait at least one schedule cycle during device
	removal.
Date: Wed, 03 Mar 2010 09:06:34 -0600
Message-ID: <20100303150633.11256.9555.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wenxiong-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

During a hot-plug LLD removal event or an EEH error event, iw_cxgb3
must ensure that any/all threads that might be in a cxgb3 exported function
concurrently must return from the function before iw_cxgb3 returns from
its event processing. Do this by calling synchronize_net().

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb3/iwch.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch.c b/drivers/infiniband/hw/cxgb3/iwch.c
index ee1d8b4..63f975f 100644
--- a/drivers/infiniband/hw/cxgb3/iwch.c
+++ b/drivers/infiniband/hw/cxgb3/iwch.c
@@ -189,6 +189,7 @@ static void close_rnic_dev(struct t3cdev *tdev)
 	list_for_each_entry_safe(dev, tmp, &dev_list, entry) {
 		if (dev->rdev.t3cdev_p == tdev) {
 			dev->rdev.flags = CXIO_ERROR_FATAL;
+			synchronize_net();
 			cancel_delayed_work_sync(&dev->db_drop_task);
 			list_del(&dev->entry);
 			iwch_unregister_device(dev);
@@ -217,6 +218,7 @@ static void iwch_event_handler(struct t3cdev *tdev, u32 evt, u32 port_id)
 	switch (evt) {
 	case OFFLOAD_STATUS_DOWN: {
 		rdev->flags = CXIO_ERROR_FATAL;
+		synchronize_net();
 		event.event  = IB_EVENT_DEVICE_FATAL;
 		dispatch = 1;
 		break;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
