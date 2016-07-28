From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/hfi1: Expand reported serial number
Date: Wed, 27 Jul 2016 21:09:40 -0400
Message-ID: <20160728010940.GD3158@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Expand the serial number space by using more bits
from the GUID.

Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index becc7b11e31e..c93683496614 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -14601,8 +14601,14 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 	/* set up LCB access - must be after set_up_interrupts() */
 	init_lcb_access(dd);
 
+	/*
+	 * Serial number is created from the base guid:
+	 * [27:24] = base guid [38:35]
+	 * [23: 0] = base guid [23: 0]
+	 */
 	snprintf(dd->serial, SERIAL_MAX, "0x%08llx\n",
-		 dd->base_guid & 0xFFFFFF);
+		 (dd->base_guid & 0xFFFFFF) |
+		     ((dd->base_guid >> 11) & 0xF000000));
 
 	dd->oui1 = dd->base_guid >> 56 & 0xFF;
 	dd->oui2 = dd->base_guid >> 48 & 0xFF;
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
