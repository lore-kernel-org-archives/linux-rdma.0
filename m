From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 5/7] RDMA/cxgb4: remove db_drop_task.
Date: Fri, 11 Mar 2011 16:30:32 -0600
Message-ID: <20110311223032.16418.78659.stgit@build.ogc.int>
References: <20110311222826.16418.43582.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110311222826.16418.43582.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Unloading iw_cxgb4 can crash due to the unload code trying to use
db_drop_task, which is uninitialized.  So remove this dead code.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/device.c   |    1 -
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index f5638f2..3e46b80 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -373,7 +373,6 @@ static void c4iw_rdev_close(struct c4iw_rdev *rdev)
 static void c4iw_remove(struct c4iw_dev *dev)
 {
 	PDBG("%s c4iw_dev %p\n", __func__,  dev);
-	cancel_delayed_work_sync(&dev->db_drop_task);
 	list_del(&dev->entry);
 	if (dev->registered)
 		c4iw_unregister_device(dev);
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 2fe19ec..9f6166f 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -176,7 +176,6 @@ struct c4iw_dev {
 	struct idr mmidr;
 	spinlock_t lock;
 	struct list_head entry;
-	struct delayed_work db_drop_task;
 	struct dentry *debugfs_root;
 	u8 registered;
 };

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
