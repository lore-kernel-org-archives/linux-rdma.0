From: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH for-next 1/5] RDMA/ocrdma: Cleanup unused device list and rcu variables
Date: Tue, 20 Oct 2015 14:17:56 +0530
Message-ID: <1445330880-3912-2-git-send-email-selvin.xavier@avagotech.com>
References: <1445330880-3912-1-git-send-email-selvin.xavier@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445330880-3912-1-git-send-email-selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Padmanabh Ratnakar <padmanabh.ratnakar-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ocrdma_dev_list is not used by the driver. So removing
the references of this variable. dev->rcu was introduced
for the ipv6 notifier for GID management. This is no longer
required as the GID management is outside the HW driver.

Signed-off-by: Padmanabh Ratnakar <padmanabh.ratnakar-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h      |  1 -
 drivers/infiniband/hw/ocrdma/ocrdma_main.c | 16 ++--------------
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index b4091ab..8cd57c7 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -278,7 +278,6 @@ struct ocrdma_dev {
 	u32 hba_port_num;
 
 	struct list_head entry;
-	struct rcu_head rcu;
 	int id;
 	u64 *stag_arr;
 	u8 sl; /* service level */
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 87aa55d..cb1af0f 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -63,8 +63,6 @@ MODULE_DESCRIPTION(OCRDMA_ROCE_DRV_DESC " " OCRDMA_ROCE_DRV_VERSION);
 MODULE_AUTHOR("Emulex Corporation");
 MODULE_LICENSE("Dual BSD/GPL");
 
-static LIST_HEAD(ocrdma_dev_list);
-static DEFINE_SPINLOCK(ocrdma_devlist_lock);
 static DEFINE_IDR(ocrdma_dev_id);
 
 void ocrdma_get_guid(struct ocrdma_dev *dev, u8 *guid)
@@ -325,9 +323,6 @@ static struct ocrdma_dev *ocrdma_add(struct be_dev_info *dev_info)
 	for (i = 0; i < ARRAY_SIZE(ocrdma_attributes); i++)
 		if (device_create_file(&dev->ibdev.dev, ocrdma_attributes[i]))
 			goto sysfs_err;
-	spin_lock(&ocrdma_devlist_lock);
-	list_add_tail_rcu(&dev->entry, &ocrdma_dev_list);
-	spin_unlock(&ocrdma_devlist_lock);
 	/* Init stats */
 	ocrdma_add_port_stats(dev);
 	/* Interrupt Moderation */
@@ -356,9 +351,8 @@ idr_err:
 	return NULL;
 }
 
-static void ocrdma_remove_free(struct rcu_head *rcu)
+static void ocrdma_remove_free(struct ocrdma_dev *dev)
 {
-	struct ocrdma_dev *dev = container_of(rcu, struct ocrdma_dev, rcu);
 
 	idr_remove(&ocrdma_dev_id, dev->id);
 	kfree(dev->mbx_cmd);
@@ -375,15 +369,9 @@ static void ocrdma_remove(struct ocrdma_dev *dev)
 	ib_unregister_device(&dev->ibdev);
 
 	ocrdma_rem_port_stats(dev);
-
-	spin_lock(&ocrdma_devlist_lock);
-	list_del_rcu(&dev->entry);
-	spin_unlock(&ocrdma_devlist_lock);
-
 	ocrdma_free_resources(dev);
 	ocrdma_cleanup_hw(dev);
-
-	call_rcu(&dev->rcu, ocrdma_remove_free);
+	ocrdma_remove_free(dev);
 }
 
 static int ocrdma_open(struct ocrdma_dev *dev)
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
