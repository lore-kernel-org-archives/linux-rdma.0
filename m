From: Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] usnic: correctly check failed allocation
Date: Thu, 15 Oct 2015 21:15:15 +0000
Message-ID: <1444943715-31250-1-git-send-email-wuninsu@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: taesoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, yeongjin.jang-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, insu-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since ib_alloc_device returns allocated memory address, not error,
it should be checked as IS_NULL, not IS_ERR_OR_NULL.

Signed-off-by: Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index 34c49b8..cbc0514 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -328,16 +328,15 @@ static void *usnic_ib_device_add(struct pci_dev *dev)
 	netdev = pci_get_drvdata(dev);
 
 	us_ibdev = (struct usnic_ib_dev *)ib_alloc_device(sizeof(*us_ibdev));
-	if (IS_ERR_OR_NULL(us_ibdev)) {
+	if (!us_ibdev) {
 		usnic_err("Device %s context alloc failed\n",
 				netdev_name(pci_get_drvdata(dev)));
-		return ERR_PTR(us_ibdev ? PTR_ERR(us_ibdev) : -EFAULT);
+		return ERR_PTR(-EFAULT);
 	}
 
 	us_ibdev->ufdev = usnic_fwd_dev_alloc(dev);
-	if (IS_ERR_OR_NULL(us_ibdev->ufdev)) {
-		usnic_err("Failed to alloc ufdev for %s with err %ld\n",
-				pci_name(dev), PTR_ERR(us_ibdev->ufdev));
+	if (!us_ibdev->ufdev) {
+		usnic_err("Failed to alloc ufdev for %s\n", pci_name(dev));
 		goto err_dealloc;
 	}
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
