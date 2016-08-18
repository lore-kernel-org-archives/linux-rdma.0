From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] RDMA/ocrdma: display ocrdma tech preview status
Date: Thu, 18 Aug 2016 08:02:20 -0400
Message-ID: <1471521740-28353-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds a code to display ocrdma driver technology
preview status on ocrdma module load.

Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 07d0c6c..9b8774c 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -444,6 +444,16 @@ void ocrdma_update_link_state(struct ocrdma_dev *dev, u8 lstate)
 		ocrdma_dispatch_port_active(dev);
 }
 
+void ocrdma_print_tech_preview_status(void)
+{
+	printk(KERN_INFO
+	       "*************************************************************\n");
+	printk(KERN_INFO
+	       "RoCE supported at Tech Preview level in all OCE141XX Adapters\n");
+	printk(KERN_INFO
+	       "*************************************************************\n");
+}
+
 static struct ocrdma_driver ocrdma_drv = {
 	.name			= "ocrdma_driver",
 	.add			= ocrdma_add,
@@ -456,6 +466,7 @@ static int __init ocrdma_init_module(void)
 {
 	int status;
 
+	ocrdma_print_tech_preview_status();
 	ocrdma_init_debugfs();
 
 	status = be_roce_register_driver(&ocrdma_drv);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
