From: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH master] RDMA/ocrdma: unregister inet notifier while unloading ocrdma
Date: Tue, 18 Mar 2014 14:54:56 +0530
Message-ID: <0d6fca73-a4aa-43ea-b08c-63edd88d0011@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Unregister the inet notifier during ocrdma unload to avoid the panic after
driver unload.

Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 1a8a945..d75a718 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -487,6 +487,11 @@ static void ocrdma_unregister_inet6addr_notifier(void)
 #endif
 }
 
+static void ocrdma_unregister_inetaddr_notifier(void)
+{
+	unregister_inetaddr_notifier(&ocrdma_inetaddr_notifier);
+}
+
 static int __init ocrdma_init_module(void)
 {
 	int status;
@@ -498,13 +503,19 @@ static int __init ocrdma_init_module(void)
 #if IS_ENABLED(CONFIG_IPV6)
 	status = register_inet6addr_notifier(&ocrdma_inet6addr_notifier);
 	if (status)
-		return status;
+		goto err_notifier6;
 #endif
 
 	status = be_roce_register_driver(&ocrdma_drv);
 	if (status)
-		ocrdma_unregister_inet6addr_notifier();
+		goto err_be_reg;
 
+	return 0;
+
+err_be_reg:
+	ocrdma_unregister_inet6addr_notifier();
+err_notifier6:
+	ocrdma_unregister_inetaddr_notifier();
 	return status;
 }
 
@@ -512,6 +523,7 @@ static void __exit ocrdma_exit_module(void)
 {
 	be_roce_unregister_driver(&ocrdma_drv);
 	ocrdma_unregister_inet6addr_notifier();
+	ocrdma_unregister_inetaddr_notifier();
 }
 
 module_init(ocrdma_init_module);
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
