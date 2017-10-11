From: Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH for-next] IB,hfi1 Add MODULE_FIRMWARE statements
Date: Wed, 11 Oct 2017 14:41:34 +0200
Message-ID: <20171011144134.c6bba480faee444cb9881710@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Provide information about used firmware files via modinfo.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/firmware.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/firmware.c b/drivers/infiniband/hw/hfi1/firmware.c
index dee3c674f33d..f56ace76b42c 100644
--- a/drivers/infiniband/hw/hfi1/firmware.c
+++ b/drivers/infiniband/hw/hfi1/firmware.c
@@ -70,6 +70,11 @@
 #define ALT_FW_PCIE_NAME "hfi1_pcie_d.fw"
 #define HOST_INTERFACE_VERSION 1
 
+MODULE_FIRMWARE(DEFAULT_FW_8051_NAME_ASIC);
+MODULE_FIRMWARE(DEFAULT_FW_FABRIC_NAME);
+MODULE_FIRMWARE(DEFAULT_FW_SBUS_NAME);
+MODULE_FIRMWARE(DEFAULT_FW_PCIE_NAME);
+
 static uint fw_8051_load = 1;
 static uint fw_fabric_serdes_load = 1;
 static uint fw_pcie_serdes_load = 1;
-- 
2.12.3


-- 
SUSE Linux GmbH
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
