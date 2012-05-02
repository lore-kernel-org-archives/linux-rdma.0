From: Roland Dreier <roland@kernel.org>
Subject: [PATCH] RDMA/ocrdma: Fix build with IPV6=n
Date: Wed,  2 May 2012 15:51:00 -0700
Message-ID: <1335999060-23779-1-git-send-email-roland@kernel.org>
References: <4F9ACFC4.6010002@xenotime.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F9ACFC4.6010002@xenotime.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-rdma@vger.kernel.org, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

When IPV6 is not enabled:

    ERROR: "register_inet6addr_notifier" [drivers/infiniband/hw/ocrdma/ocrdma.ko] undefined!
    ERROR: "unregister_inet6addr_notifier" [drivers/infiniband/hw/ocrdma/ocrdma.ko] undefined!

Fix this by wrapping the inet6 calls in #ifdef IPV6.  Also make the
ocrdma module depend on (IPV6 || IPV6=n) to forbid the case of modular
ipv6 but built-in ocrdma (which can't work, because ocrdma calls ipv6
functions).

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Roland Dreier <roland@purestorage.com>
---
OK, added this to my tree, should fix this.

Thanks,
  Roland

 drivers/infiniband/hw/ocrdma/Kconfig       |    2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c |   29 ++++++++++++++++++++--------
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/Kconfig b/drivers/infiniband/hw/ocrdma/Kconfig
index cf99342..b5b6056 100644
--- a/drivers/infiniband/hw/ocrdma/Kconfig
+++ b/drivers/infiniband/hw/ocrdma/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_OCRDMA
 	tristate "Emulex One Connect HCA support"
-	depends on ETHERNET && NETDEVICES && PCI
+	depends on ETHERNET && NETDEVICES && PCI && (IPV6 || IPV6=n)
 	select NET_VENDOR_EMULEX
 	select BE2NET
 	---help---
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 0bc1efb..a20d16e 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -51,12 +51,6 @@ static DEFINE_SPINLOCK(ocrdma_devlist_lock);
 static DEFINE_IDR(ocrdma_dev_id);
 
 static union ib_gid ocrdma_zero_sgid;
-static int ocrdma_inet6addr_event(struct notifier_block *,
-				  unsigned long, void *);
-
-static struct notifier_block ocrdma_inet6addr_notifier = {
-	.notifier_call = ocrdma_inet6addr_event
-};
 
 static int ocrdma_get_instance(void)
 {
@@ -204,6 +198,8 @@ static int ocrdma_build_sgid_tbl(struct ocrdma_dev *dev)
 	return 0;
 }
 
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+
 static int ocrdma_inet6addr_event(struct notifier_block *notifier,
 				  unsigned long event, void *ptr)
 {
@@ -259,6 +255,12 @@ static int ocrdma_inet6addr_event(struct notifier_block *notifier,
 	return NOTIFY_OK;
 }
 
+static struct notifier_block ocrdma_inet6addr_notifier = {
+	.notifier_call = ocrdma_inet6addr_event
+};
+
+#endif /* IPV6 */
+
 static enum rdma_link_layer ocrdma_link_layer(struct ib_device *device,
 					      u8 port_num)
 {
@@ -541,23 +543,34 @@ static struct ocrdma_driver ocrdma_drv = {
 	.state_change_handler	= ocrdma_event_handler,
 };
 
+static void ocrdma_unregister_inet6addr_notifier(void)
+{
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+	unregister_inet6addr_notifier(&ocrdma_inet6addr_notifier);
+#endif
+}
+
 static int __init ocrdma_init_module(void)
 {
 	int status;
 
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 	status = register_inet6addr_notifier(&ocrdma_inet6addr_notifier);
 	if (status)
 		return status;
+#endif
+
 	status = be_roce_register_driver(&ocrdma_drv);
 	if (status)
-		unregister_inet6addr_notifier(&ocrdma_inet6addr_notifier);
+		ocrdma_unregister_inet6addr_notifier();
+
 	return status;
 }
 
 static void __exit ocrdma_exit_module(void)
 {
 	be_roce_unregister_driver(&ocrdma_drv);
-	unregister_inet6addr_notifier(&ocrdma_inet6addr_notifier);
+	ocrdma_unregister_inet6addr_notifier();
 }
 
 module_init(ocrdma_init_module);
-- 
1.7.9.5
