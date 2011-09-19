From: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH RFC 3/4] ib/mlx4: get extended active speed from port info
Date: Mon, 19 Sep 2011 19:06:42 +0300
Message-ID: <201109191906.42834.marcela@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

mlx4_ib: Add extended link speeds support

This patch implements IB spec extension of the PortInfo attribute:

Component  : LinkSpeedExtActive
Used By    : (All X's except base SP0)
Access     : RO
Length     : 4
Offset     : 496
Description: If PortInfo:CapabilityMask.IsExtendedSpeedsSupported
	     (according to IBTA RefID 4720), currently
             active extended link speed, indicated as follows:
0: No extended speed active
1: 14.0625 Gbps (FDR)
2: 25.78125 Gbps (EDR)
3-15: Reserved

Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/infiniband/hw/mlx4/main.c
===================================================================
--- a/drivers/infiniband/hw/mlx4/main.c	2011-09-14 13:49:58.000000000 +0300
+++ b/drivers/infiniband/hw/mlx4/main.c	2011-09-14 13:50:52.408510900 +0300
@@ -202,7 +202,7 @@ static int ib_link_query_port(struct ib_
 	props->subnet_timeout	= out_mad->data[51] & 0x1f;
 	props->max_vl_num	= out_mad->data[37] >> 4;
 	props->init_type_reply	= out_mad->data[41] >> 4;
-
+	props->ext_active_speed = out_mad->data[62] >> 4;
 	return 0;
 }
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
