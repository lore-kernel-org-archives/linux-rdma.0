From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 2/2] IB/usnic: Add dependency on CONFIG_INET
Date: Wed, 15 Jan 2014 17:02:21 -0800
Message-ID: <1389834141-16587-3-git-send-email-umalhi@cisco.com>
References: <1389834141-16587-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389834141-16587-1-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

usNIC needs inet notifiers to function correctly.  Hence, add
dependency in Kconfig on CONFIG_INET.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/usnic/Kconfig b/drivers/infiniband/hw/usnic/Kconfig
index 2cc8ba0..29ab11c 100644
--- a/drivers/infiniband/hw/usnic/Kconfig
+++ b/drivers/infiniband/hw/usnic/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_USNIC
 	tristate "Verbs support for Cisco VIC"
-	depends on NETDEVICES && ETHERNET && PCI && INTEL_IOMMU
+	depends on NETDEVICES && ETHERNET && INET && PCI && INTEL_IOMMU
 	select ENIC
 	select NET_VENDOR_CISCO
 	select PCI_IOV
-- 
1.8.2.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
