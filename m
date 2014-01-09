From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v1 for-next 03/15] IB/usnic: Make usNIC built depend on Intel IOMMU
Date: Thu,  9 Jan 2014 14:47:31 -0800
Message-ID: <1389307663-11296-4-git-send-email-umalhi@cisco.com>
References: <1389307663-11296-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389307663-11296-1-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

usNIC requires Intel IOMMU to be present in order to function
correctly.  This patch adds a dependency on CONFIG_INTEL_IOMMU
of CONFIG_INFINIBAND_USNIC.  It also fixes iommu_domain_has_cap
not found error that is thrown if usNIC is built with !CONFIG_IOMMU_API.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/Kconfig b/drivers/infiniband/hw/usnic/Kconfig
index 0f14b6d..2cc8ba0 100644
--- a/drivers/infiniband/hw/usnic/Kconfig
+++ b/drivers/infiniband/hw/usnic/Kconfig
@@ -1,10 +1,9 @@
 config INFINIBAND_USNIC
 	tristate "Verbs support for Cisco VIC"
-	depends on NETDEVICES && ETHERNET && PCI
+	depends on NETDEVICES && ETHERNET && PCI && INTEL_IOMMU
 	select ENIC
 	select NET_VENDOR_CISCO
 	select PCI_IOV
-	select IOMMU_SUPPORT
 	select INFINIBAND_USER_ACCESS
 	---help---
 	  This is a low-level driver for Cisco's Virtual Interface
-- 
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
