From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH 2/3] mlx4: Don't bother using skb_tx_hash in
 mlx4_en_select_queue
Date: Fri, 27 Apr 2018 14:06:45 -0400
Message-ID: <20180427180640.4883.75746.stgit@ahduyck-green-test.jf.intel.com>
References: <20180427180142.4883.96259.stgit@ahduyck-green-test.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180427180142.4883.96259.stgit@ahduyck-green-test.jf.intel.com>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, davem@davemloft.net
Cc: linux-rdma@vger.kernel.org, dennis.dalessandro@intel.com, niranjana.vishwanathapura@intel.com, tariqt@mellanox.com
List-Id: linux-rdma@vger.kernel.org

The code in the fallback path has supported XDP in conjunction with the Tx
traffic classification for TCs for over a year now. So instead of just
calling skb_tx_hash for every packet we are better off using the fallback
since that will record the Tx queue to the socket and then that can be used
instead of having to recompute the hash every time.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 6b68537..0227786 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -694,7 +694,7 @@ u16 mlx4_en_select_queue(struct net_device *dev, struct sk_buff *skb,
 	u16 rings_p_up = priv->num_tx_rings_p_up;
 
 	if (netdev_get_num_tc(dev))
-		return skb_tx_hash(dev, skb);
+		return fallback(dev, skb);
 
 	return fallback(dev, skb) % rings_p_up;
 }
