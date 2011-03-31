From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] RDMA/cxgb4: Initialization errors can cause crash.
Date: Thu, 31 Mar 2011 14:36:42 -0500
Message-ID: <20110331193642.6723.23391.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

c4iw_uld_add() must return ERR_PTR() values instead of NULL on failure.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/device.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index e29172c..8e70953 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -392,7 +392,7 @@ static struct c4iw_dev *c4iw_alloc(const struct cxgb4_lld_info *infop)
 	devp = (struct c4iw_dev *)ib_alloc_device(sizeof(*devp));
 	if (!devp) {
 		printk(KERN_ERR MOD "Cannot allocate ib device\n");
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 	devp->rdev.lldi = *infop;
 
@@ -414,7 +414,7 @@ static struct c4iw_dev *c4iw_alloc(const struct cxgb4_lld_info *infop)
 		mutex_unlock(&dev_mutex);
 		printk(KERN_ERR MOD "Unable to open CXIO rdev err %d\n", ret);
 		ib_dealloc_device(&devp->ibdev);
-		return NULL;
+		return ERR_PTR(ret);
 	}
 
 	idr_init(&devp->cqidr);
@@ -444,7 +444,7 @@ static void *c4iw_uld_add(const struct cxgb4_lld_info *infop)
 		       DRV_VERSION);
 
 	dev = c4iw_alloc(infop);
-	if (!dev)
+	if (IS_ERR(dev))
 		goto out;
 
 	PDBG("%s found device %s nchan %u nrxq %u ntxq %u nports %u\n",

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
