From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/5] ib/mlx4: enable 4K mtu for IBoE
Date: Mon, 10 Oct 2011 10:53:41 +0200
Message-ID: <alpine.LRH.2.00.1110101052450.11243@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1110101047420.10901@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1110101047420.10901-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The IBoE port mtu is derived from the corresponding EN netdevice
mtu, which can go upto supporting Jumbo-Frames of 9KB and hence
surely supports the max IB mtu of 4K

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index fa643f4..e953cf9 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -227,7 +227,7 @@ static int eth_link_query_port(struct ib_device *ibdev, u8 port,
 	props->pkey_tbl_len	= 1;
 	props->bad_pkey_cntr	= be16_to_cpup((__be16 *) (out_mad->data + 46));
 	props->qkey_viol_cntr	= be16_to_cpup((__be16 *) (out_mad->data + 48));
-	props->max_mtu		= IB_MTU_2048;
+	props->max_mtu		= IB_MTU_4096;
 	props->subnet_timeout	= 0;
 	props->max_vl_num	= out_mad->data[37] >> 4;
 	props->init_type_reply	= 0;
-- 
1.7.4.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
