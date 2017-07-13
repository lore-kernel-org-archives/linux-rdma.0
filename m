From: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH] IB/hfi1: fix spelling mistake in variable name continious
Date: Thu, 13 Jul 2017 23:13:38 +0100
Message-ID: <20170713221338.14493-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Trivial fix to spelling mistake, rename variable 'continious'
to the correct spelling 'continuous'

Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 937350d9deab..9527c68143cc 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -7333,7 +7333,7 @@ void handle_verify_cap(struct work_struct *work)
 	struct hfi1_devdata *dd = ppd->dd;
 	u64 reg;
 	u8 power_management;
-	u8 continious;
+	u8 continuous;
 	u8 vcu;
 	u8 vau;
 	u8 z;
@@ -7352,7 +7352,7 @@ void handle_verify_cap(struct work_struct *work)
 	lcb_shutdown(dd, 0);
 	adjust_lcb_for_fpga_serdes(dd);
 
-	read_vc_remote_phy(dd, &power_management, &continious);
+	read_vc_remote_phy(dd, &power_management, &continuous);
 	read_vc_remote_fabric(dd, &vau, &z, &vcu, &vl15buf,
 			      &partner_supported_crc);
 	read_vc_remote_link_width(dd, &remote_tx_rate, &link_widths);
@@ -7366,7 +7366,7 @@ void handle_verify_cap(struct work_struct *work)
 	get_link_widths(dd, &active_tx, &active_rx);
 	dd_dev_info(dd,
 		    "Peer PHY: power management 0x%x, continuous updates 0x%x\n",
-		    (int)power_management, (int)continious);
+		    (int)power_management, (int)continuous);
 	dd_dev_info(dd,
 		    "Peer Fabric: vAU %d, Z %d, vCU %d, vl15 credits 0x%x, CRC sizes 0x%x\n",
 		    (int)vau, (int)z, (int)vcu, (int)vl15buf,
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
