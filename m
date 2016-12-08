From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 14/23] IB/hfi1: Preserve external device completed bit
Date: Wed, 07 Dec 2016 19:33:40 -0800
Message-ID: <20161208033338.21135.1939.stgit@scvm10.sc.intel.com>
References: <20161208032312.21135.66056.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161208032312.21135.66056.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The driver should not change the external device request
completed bit when not actually doing an external device
request.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 8dee6c2..ef72bc2 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -8477,7 +8477,10 @@ static int do_8051_command(
 	 */
 	if (type == HCMD_WRITE_LCB_CSR) {
 		in_data |= ((*out_data) & 0xffffffffffull) << 8;
-		reg = ((((*out_data) >> 40) & 0xff) <<
+		/* must preserve COMPLETED - it is tied to hardware */
+		reg = read_csr(dd, DC_DC8051_CFG_EXT_DEV_0);
+		reg &= DC_DC8051_CFG_EXT_DEV_0_COMPLETED_SMASK;
+		reg |= ((((*out_data) >> 40) & 0xff) <<
 				DC_DC8051_CFG_EXT_DEV_0_RETURN_CODE_SHIFT)
 		      | ((((*out_data) >> 48) & 0xffff) <<
 				DC_DC8051_CFG_EXT_DEV_0_RSP_DATA_SHIFT);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
