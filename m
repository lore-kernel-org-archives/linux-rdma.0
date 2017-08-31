From: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 4/8] bnxt_re: Free up devices in module_exit path
Date: Thu, 31 Aug 2017 09:27:31 +0530
Message-ID: <20170831035735.19595-5-somnath.kotur@broadcom.com>
References: <20170831035735.19595-1-somnath.kotur@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170831035735.19595-1-somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up all devices added to the bnxt_re_dev_list in the
module_exit entry point.

Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/main.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 82d1cbc..00a3b74 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -1375,6 +1375,22 @@ static int __init bnxt_re_mod_init(void)
 
 static void __exit bnxt_re_mod_exit(void)
 {
+	struct bnxt_re_dev *rdev;
+	LIST_HEAD(to_be_deleted);
+
+	mutex_lock(&bnxt_re_dev_lock);
+	/* Free all adapter allocated resources */
+	if (!list_empty(&bnxt_re_dev_list))
+		list_splice_init(&bnxt_re_dev_list, &to_be_deleted);
+	mutex_unlock(&bnxt_re_dev_lock);
+
+	list_for_each_entry(rdev, &to_be_deleted, list) {
+		dev_info(rdev_to_dev(rdev), "Unregistering Device");
+		bnxt_re_dev_stop(rdev);
+		bnxt_re_ib_unreg(rdev, true);
+		bnxt_re_remove_one(rdev);
+		bnxt_re_dev_unreg(rdev);
+	}
 	unregister_netdevice_notifier(&bnxt_re_netdev_notifier);
 	if (bnxt_re_wq)
 		destroy_workqueue(bnxt_re_wq);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
