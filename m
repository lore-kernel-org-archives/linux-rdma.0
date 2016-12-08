From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 02/23] IB/hfi1: Fix dc8051 multiple qword memory reads
Date: Wed, 07 Dec 2016 19:32:22 -0800
Message-ID: <20161208033220.21135.35541.stgit@scvm10.sc.intel.com>
References: <20161208032312.21135.66056.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161208032312.21135.66056.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When reading multiple dc8051 data memory locations
at once, the read enabled field must be toggled
at every address change.  Do that by writing only
the address first, then writing the enable.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/firmware.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/firmware.c b/drivers/infiniband/hw/hfi1/firmware.c
index 9a36c8c..bcf7da4 100644
--- a/drivers/infiniband/hw/hfi1/firmware.c
+++ b/drivers/infiniband/hw/hfi1/firmware.c
@@ -263,11 +263,13 @@ static int __read_8051_data(struct hfi1_devdata *dd, u32 addr, u64 *result)
 	u64 reg;
 	int count;
 
-	/* start the read at the given address */
-	reg = ((addr & DC_DC8051_CFG_RAM_ACCESS_CTRL_ADDRESS_MASK)
-			<< DC_DC8051_CFG_RAM_ACCESS_CTRL_ADDRESS_SHIFT)
-		| DC_DC8051_CFG_RAM_ACCESS_CTRL_READ_ENA_SMASK;
+	/* step 1: set the address, clear enable */
+	reg = (addr & DC_DC8051_CFG_RAM_ACCESS_CTRL_ADDRESS_MASK)
+			<< DC_DC8051_CFG_RAM_ACCESS_CTRL_ADDRESS_SHIFT;
 	write_csr(dd, DC_DC8051_CFG_RAM_ACCESS_CTRL, reg);
+	/* step 2: enable */
+	write_csr(dd, DC_DC8051_CFG_RAM_ACCESS_CTRL,
+		  reg | DC_DC8051_CFG_RAM_ACCESS_CTRL_READ_ENA_SMASK);
 
 	/* wait until ACCESS_COMPLETED is set */
 	count = 0;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
