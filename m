From: Insu Yun <wuninsu@gmail.com>
Subject: [PATCH] usnic: corretly check failed allocation
Date: Thu, 15 Oct 2015 12:27:40 -0400
Message-ID: <1444926460-29333-1-git-send-email-wuninsu@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: umalhi@cisco.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu, Insu Yun <wuninsu@gmail.com>
List-Id: linux-rdma@vger.kernel.org

Since ib_alloc_device returns allocated memory address, not error, 
it should be checked as IS_NULL, not IS_ERR_OR_NULL.

Signed-off-by: Insu Yun <wuninsu@gmail.com>
---
 drivers/infiniband/hw/usnic/usnic_ib_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index 34c49b8..7c5f602 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -328,14 +328,14 @@ static void *usnic_ib_device_add(struct pci_dev *dev)
 	netdev = pci_get_drvdata(dev);
 
 	us_ibdev = (struct usnic_ib_dev *)ib_alloc_device(sizeof(*us_ibdev));
-	if (IS_ERR_OR_NULL(us_ibdev)) {
+	if (!us_ibdev) {
 		usnic_err("Device %s context alloc failed\n",
 				netdev_name(pci_get_drvdata(dev)));
 		return ERR_PTR(us_ibdev ? PTR_ERR(us_ibdev) : -EFAULT);
 	}
 
 	us_ibdev->ufdev = usnic_fwd_dev_alloc(dev);
-	if (IS_ERR_OR_NULL(us_ibdev->ufdev)) {
+	if (!us_ibdev->ufdev) {
 		usnic_err("Failed to alloc ufdev for %s with err %ld\n",
 				pci_name(dev), PTR_ERR(us_ibdev->ufdev));
 		goto err_dealloc;
-- 
1.9.1
