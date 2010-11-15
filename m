From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH v2] mlx4: Fix IBoE reported rate
Date: Mon, 15 Nov 2010 16:04:39 +0200
Message-ID: <20101115140439.GA20131@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The link rate is the multiplication of the link speed in the link width. For
Etherent ports the rate is 10G so we use 1 for the witdh and 4 for speed so it
yields the correct rate.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
Changes: Use 1X for width and 4 for speed.
It should be noted that in the future (for other devices),
active_width and active_speed may have other values to relflect the
correct rate.

 drivers/infiniband/hw/mlx4/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index f200b96..02a9034 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -219,7 +219,7 @@ static int eth_link_query_port(struct ib_device *ibdev, u8 port,
 	struct net_device *ndev;
 	enum ib_mtu tmp;
 
-	props->active_width	= IB_WIDTH_4X;
+	props->active_width	= IB_WIDTH_1X;
 	props->active_speed	= 4;
 	props->port_cap_flags	= IB_PORT_CM_SUP;
 	props->gid_tbl_len	= to_mdev(ibdev)->dev->caps.gid_table_len[port];
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
