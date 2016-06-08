From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH] IB/mlx4: Properly initialize GRH TClass and FlowLabel in AHs
Date: Wed, 8 Jun 2016 17:28:29 -0600
Message-ID: <20160608232829.GA27363@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When this code was reworked for IBoE support the order of assignments
for the sl_tclass_flowlabel got flipped around resulting in
TClass & FlowLabel being permanently set to 0 in the packet headers.

This breaks IB routers that rely on these headers, but only affects
kernel users - libmlx4 does this properly for user space.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Fixes: fa417f7b520e ("IB/mlx4: Add support for IBoE")
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/ah.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/ah.c b/drivers/infiniband/hw/mlx4/ah.c
index 105246fba2e7..5fc623362731 100644
--- a/drivers/infiniband/hw/mlx4/ah.c
+++ b/drivers/infiniband/hw/mlx4/ah.c
@@ -47,6 +47,7 @@ static struct ib_ah *create_ib_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
 
 	ah->av.ib.port_pd = cpu_to_be32(to_mpd(pd)->pdn | (ah_attr->port_num << 24));
 	ah->av.ib.g_slid  = ah_attr->src_path_bits;
+	ah->av.ib.sl_tclass_flowlabel = cpu_to_be32(ah_attr->sl << 28);
 	if (ah_attr->ah_flags & IB_AH_GRH) {
 		ah->av.ib.g_slid   |= 0x80;
 		ah->av.ib.gid_index = ah_attr->grh.sgid_index;
@@ -64,7 +65,6 @@ static struct ib_ah *create_ib_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
 		       !(1 << ah->av.ib.stat_rate & dev->caps.stat_rate_support))
 			--ah->av.ib.stat_rate;
 	}
-	ah->av.ib.sl_tclass_flowlabel = cpu_to_be32(ah_attr->sl << 28);
 
 	return &ah->ibah;
 }
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
