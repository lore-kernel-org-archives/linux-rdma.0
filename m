From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 12/21] IB/hfi1: Guard against concurrent I2C access across
 all chains
Date: Tue, 12 Apr 2016 11:26:21 -0700
Message-ID: <20160412182611.25640.90032.stgit@scvm10.sc.intel.com>
References: <20160412174746.24485.92280.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160412174746.24485.92280.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The discrete ASIC board design makes the two I2C chains not
independent of each other.  That is, only one chain can safely
be accessed at a time.  For discrete ASIC devices, adjust the
resource locking so that access to one I2C chain will lock both
of the chains.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/firmware.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/firmware.c b/drivers/staging/rdma/hfi1/firmware.c
index 3040162..ed680fd 100644
--- a/drivers/staging/rdma/hfi1/firmware.c
+++ b/drivers/staging/rdma/hfi1/firmware.c
@@ -1413,8 +1413,15 @@ static int __acquire_chip_resource(struct hfi1_devdata *dd, u32 resource)
 
 	if (resource & CR_DYN_MASK) {
 		/* a dynamic resource is in use if either HFI has set the bit */
-		all_bits = resource_mask(0, resource) |
+		if (dd->pcidev->device == PCI_DEVICE_ID_INTEL0 &&
+		    (resource & (CR_I2C1 | CR_I2C2))) {
+			/* discrete devices must serialize across both chains */
+			all_bits = resource_mask(0, CR_I2C1 | CR_I2C2) |
+					resource_mask(1, CR_I2C1 | CR_I2C2);
+		} else {
+			all_bits = resource_mask(0, resource) |
 						resource_mask(1, resource);
+		}
 		my_bit = resource_mask(dd->hfi1_id, resource);
 	} else {
 		/* non-dynamic resources are not split between HFIs */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
