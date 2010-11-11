From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] mlx4: Fix IBoE reported rate
Date: Thu, 11 Nov 2010 18:09:45 +0200
Message-ID: <20101111160945.GA29411@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The link rate is the multiplication of the link speed in the link width. For
Etherent ports the rate is 10G so we use 4 for the witdh and 1 for speed so it
yields the correct rate.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index ba871f8..f274c9c 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -220,7 +220,7 @@ static int eth_link_query_port(struct ib_device *ibdev, u8 port,
 	enum ib_mtu tmp;
 
 	props->active_width	= IB_WIDTH_4X;
-	props->active_speed	= 4;
+	props->active_speed	= 1;
 	props->port_cap_flags	= IB_PORT_CM_SUP;
 	props->gid_tbl_len	= to_mdev(ibdev)->dev->caps.gid_table_len[port];
 	props->max_msg_sz	= to_mdev(ibdev)->dev->caps.max_msg_sz;
-- 
1.7.3.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
