From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-rc 5/6] RDMA/bnxt_re: Fix system crash during load/unload
Date: Thu, 15 Feb 2018 21:20:12 -0800
Message-ID: <1518758413-20850-6-git-send-email-selvin.xavier@broadcom.com>
References: <1518758413-20850-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1518758413-20850-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

During driver unload, the driver proceeds with cleanup
without waiting for the scheduled events. So the device
pointers get freed up and driver crashes when the events
are scheduled later.

Flush the bnxt_re_task work queue before starting
device removal.

Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 3d5bbf9..560520c 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -1591,6 +1591,11 @@ static void __exit bnxt_re_mod_exit(void)
 	*/
 	list_for_each_entry_safe_reverse(rdev, next, &to_be_deleted, list) {
 		dev_info(rdev_to_dev(rdev), "Unregistering Device");
+		/*
+		 * Flush out any scheduled tasks before destroying the
+		 * resources
+		 */
+		flush_workqueue(bnxt_re_wq);
 		bnxt_re_dev_stop(rdev);
 		bnxt_re_ib_unreg(rdev, true);
 		bnxt_re_remove_one(rdev);
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
