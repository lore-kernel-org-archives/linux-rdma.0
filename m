From: Kangjie Lu <kjlu@umn.edu>
Subject: [PATCH] net: mlx5: fix a potential NULL pointer dereference
Date: Mon, 11 Mar 2019 01:33:43 -0500
Message-ID: <20190311063343.20188-1-kjlu@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kjlu@umn.edu
Cc: pakki001@umn.edu, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

In case skb_header_pointer fails, the fix issues a warning.

A better fix requires modifying the signature of mlx5e_get_fcs to
pass an error code upstream.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index be396e5e4e39..6ec1c110e4be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -719,6 +719,8 @@ static u32 mlx5e_get_fcs(const struct sk_buff *skb)
 
 	fcs_bytes = skb_header_pointer(skb, skb->len - ETH_FCS_LEN,
 				       ETH_FCS_LEN, &_fcs_bytes);
+	if (unlikely(!fcs_bytes))
+		pr_warn_once("skb_header_pointer returns NULL\n");
 
 	return __get_unaligned_cpu32(fcs_bytes);
 }
-- 
2.17.1
