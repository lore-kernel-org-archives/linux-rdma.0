From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 18/33] net/mlx4/en_rx: Mark expected switch fall-throughs
Date: Tue, 7 Aug 2018 18:21:40 -0500
Message-ID: <b6ce3c05540217f74c1e92fa555e0190a98b146a.1533675546.git.gustavo@embeddedor.com>
References: <cover.1533675546.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1533675546.git.gustavo@embeddedor.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Tariq Toukan <tariqt@mellanox.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Addresses-Coverity-ID: 114794 ("Missing break in switch")
Addresses-Coverity-ID: 114795 ("Missing break in switch")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 3360f7b..a1aeeb8 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -795,8 +795,10 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 				goto xdp_drop_no_cnt; /* Drop on xmit failure */
 			default:
 				bpf_warn_invalid_xdp_action(act);
+				/* fall through */
 			case XDP_ABORTED:
 				trace_xdp_exception(dev, xdp_prog, act);
+				/* fall through */
 			case XDP_DROP:
 				ring->xdp_drop++;
 xdp_drop_no_cnt:
-- 
2.7.4
