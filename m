From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] net/mlx5e: fix high stack usage
Date: Fri,  2 Nov 2018 16:33:03 +0100
Message-ID: <20181102153316.1492515-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, "David S. Miller" <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>, Tariq Toukan <tariqt@mellanox.com>, Eran Ben Elisha <eranbe@mellanox.com>, Boris Pismenny <borisp@mellanox.com>, Ilya Lesokhin <ilyal@mellanox.com>, Moshe Shemesh <moshe@mellanox.com>, Kamal Heib <kamalh@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

A patch that looks harmless causes the stack usage of the mlx5e_grp_sw_update_stats()
function to drastically increase with x86 gcc-4.9 and higher (tested up to 8.1):

drivers/net/ethernet/mellanox/mlx5/core/en_stats.c: In function ‘mlx5e_grp_sw_update_stats’:
drivers/net/ethernet/mellanox/mlx5/core/en_stats.c:216:1: warning: the frame size of 1276 bytes is larger than 500 bytes [-Wframe-larger-than=]

By splitting out the loop body into a non-inlined function, the stack size goes
back down to under 500 bytes.

Fixes: 779d986d60de ("net/mlx5e: Do not ignore netdevice TX/RX queues number")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 168 +++++++++---------
 1 file changed, 86 insertions(+), 82 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 1e55b9c27ffc..c270206f3475 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -126,93 +126,97 @@ static int mlx5e_grp_sw_fill_stats(struct mlx5e_priv *priv, u64 *data, int idx)
 	return idx;
 }
 
+static noinline_for_stack void
+mlx5e_grp_sw_collect_stat(struct mlx5e_priv *priv, struct mlx5e_sw_stats *s, int i)
+{
+	struct mlx5e_channel_stats *channel_stats = &priv->channel_stats[i];
+	struct mlx5e_xdpsq_stats *xdpsq_red_stats = &channel_stats->xdpsq;
+	struct mlx5e_xdpsq_stats *xdpsq_stats = &channel_stats->rq_xdpsq;
+	struct mlx5e_rq_stats *rq_stats = &channel_stats->rq;
+	struct mlx5e_ch_stats *ch_stats = &channel_stats->ch;
+	int j;
+
+	s->rx_packets	+= rq_stats->packets;
+	s->rx_bytes	+= rq_stats->bytes;
+	s->rx_lro_packets += rq_stats->lro_packets;
+	s->rx_lro_bytes	+= rq_stats->lro_bytes;
+	s->rx_ecn_mark	+= rq_stats->ecn_mark;
+	s->rx_removed_vlan_packets += rq_stats->removed_vlan_packets;
+	s->rx_csum_none	+= rq_stats->csum_none;
+	s->rx_csum_complete += rq_stats->csum_complete;
+	s->rx_csum_unnecessary += rq_stats->csum_unnecessary;
+	s->rx_csum_unnecessary_inner += rq_stats->csum_unnecessary_inner;
+	s->rx_xdp_drop     += rq_stats->xdp_drop;
+	s->rx_xdp_redirect += rq_stats->xdp_redirect;
+	s->rx_xdp_tx_xmit  += xdpsq_stats->xmit;
+	s->rx_xdp_tx_full  += xdpsq_stats->full;
+	s->rx_xdp_tx_err   += xdpsq_stats->err;
+	s->rx_xdp_tx_cqe   += xdpsq_stats->cqes;
+	s->rx_wqe_err   += rq_stats->wqe_err;
+	s->rx_mpwqe_filler_cqes    += rq_stats->mpwqe_filler_cqes;
+	s->rx_mpwqe_filler_strides += rq_stats->mpwqe_filler_strides;
+	s->rx_buff_alloc_err += rq_stats->buff_alloc_err;
+	s->rx_cqe_compress_blks += rq_stats->cqe_compress_blks;
+	s->rx_cqe_compress_pkts += rq_stats->cqe_compress_pkts;
+	s->rx_page_reuse  += rq_stats->page_reuse;
+	s->rx_cache_reuse += rq_stats->cache_reuse;
+	s->rx_cache_full  += rq_stats->cache_full;
+	s->rx_cache_empty += rq_stats->cache_empty;
+	s->rx_cache_busy  += rq_stats->cache_busy;
+	s->rx_cache_waive += rq_stats->cache_waive;
+	s->rx_congst_umr  += rq_stats->congst_umr;
+	s->rx_arfs_err    += rq_stats->arfs_err;
+	s->ch_events      += ch_stats->events;
+	s->ch_poll        += ch_stats->poll;
+	s->ch_arm         += ch_stats->arm;
+	s->ch_aff_change  += ch_stats->aff_change;
+	s->ch_eq_rearm    += ch_stats->eq_rearm;
+	/* xdp redirect */
+	s->tx_xdp_xmit    += xdpsq_red_stats->xmit;
+	s->tx_xdp_full    += xdpsq_red_stats->full;
+	s->tx_xdp_err     += xdpsq_red_stats->err;
+	s->tx_xdp_cqes    += xdpsq_red_stats->cqes;
+
+	for (j = 0; j < priv->max_opened_tc; j++) {
+		struct mlx5e_sq_stats *sq_stats = &channel_stats->sq[j];
+
+		s->tx_packets		+= sq_stats->packets;
+		s->tx_bytes		+= sq_stats->bytes;
+		s->tx_tso_packets	+= sq_stats->tso_packets;
+		s->tx_tso_bytes		+= sq_stats->tso_bytes;
+		s->tx_tso_inner_packets	+= sq_stats->tso_inner_packets;
+		s->tx_tso_inner_bytes	+= sq_stats->tso_inner_bytes;
+		s->tx_added_vlan_packets += sq_stats->added_vlan_packets;
+		s->tx_nop               += sq_stats->nop;
+		s->tx_queue_stopped	+= sq_stats->stopped;
+		s->tx_queue_wake	+= sq_stats->wake;
+		s->tx_udp_seg_rem	+= sq_stats->udp_seg_rem;
+		s->tx_queue_dropped	+= sq_stats->dropped;
+		s->tx_cqe_err		+= sq_stats->cqe_err;
+		s->tx_recover		+= sq_stats->recover;
+		s->tx_xmit_more		+= sq_stats->xmit_more;
+		s->tx_csum_partial_inner += sq_stats->csum_partial_inner;
+		s->tx_csum_none		+= sq_stats->csum_none;
+		s->tx_csum_partial	+= sq_stats->csum_partial;
+#ifdef CONFIG_MLX5_EN_TLS
+		s->tx_tls_ooo		+= sq_stats->tls_ooo;
+		s->tx_tls_resync_bytes	+= sq_stats->tls_resync_bytes;
+#endif
+		s->tx_cqes		+= sq_stats->cqes;
+	}
+}
+
 void mlx5e_grp_sw_update_stats(struct mlx5e_priv *priv)
 {
-	struct mlx5e_sw_stats temp, *s = &temp;
+	struct mlx5e_sw_stats s;
 	int i;
 
-	memset(s, 0, sizeof(*s));
-
-	for (i = 0; i < mlx5e_get_netdev_max_channels(priv->netdev); i++) {
-		struct mlx5e_channel_stats *channel_stats =
-			&priv->channel_stats[i];
-		struct mlx5e_xdpsq_stats *xdpsq_red_stats = &channel_stats->xdpsq;
-		struct mlx5e_xdpsq_stats *xdpsq_stats = &channel_stats->rq_xdpsq;
-		struct mlx5e_rq_stats *rq_stats = &channel_stats->rq;
-		struct mlx5e_ch_stats *ch_stats = &channel_stats->ch;
-		int j;
-
-		s->rx_packets	+= rq_stats->packets;
-		s->rx_bytes	+= rq_stats->bytes;
-		s->rx_lro_packets += rq_stats->lro_packets;
-		s->rx_lro_bytes	+= rq_stats->lro_bytes;
-		s->rx_ecn_mark	+= rq_stats->ecn_mark;
-		s->rx_removed_vlan_packets += rq_stats->removed_vlan_packets;
-		s->rx_csum_none	+= rq_stats->csum_none;
-		s->rx_csum_complete += rq_stats->csum_complete;
-		s->rx_csum_unnecessary += rq_stats->csum_unnecessary;
-		s->rx_csum_unnecessary_inner += rq_stats->csum_unnecessary_inner;
-		s->rx_xdp_drop     += rq_stats->xdp_drop;
-		s->rx_xdp_redirect += rq_stats->xdp_redirect;
-		s->rx_xdp_tx_xmit  += xdpsq_stats->xmit;
-		s->rx_xdp_tx_full  += xdpsq_stats->full;
-		s->rx_xdp_tx_err   += xdpsq_stats->err;
-		s->rx_xdp_tx_cqe   += xdpsq_stats->cqes;
-		s->rx_wqe_err   += rq_stats->wqe_err;
-		s->rx_mpwqe_filler_cqes    += rq_stats->mpwqe_filler_cqes;
-		s->rx_mpwqe_filler_strides += rq_stats->mpwqe_filler_strides;
-		s->rx_buff_alloc_err += rq_stats->buff_alloc_err;
-		s->rx_cqe_compress_blks += rq_stats->cqe_compress_blks;
-		s->rx_cqe_compress_pkts += rq_stats->cqe_compress_pkts;
-		s->rx_page_reuse  += rq_stats->page_reuse;
-		s->rx_cache_reuse += rq_stats->cache_reuse;
-		s->rx_cache_full  += rq_stats->cache_full;
-		s->rx_cache_empty += rq_stats->cache_empty;
-		s->rx_cache_busy  += rq_stats->cache_busy;
-		s->rx_cache_waive += rq_stats->cache_waive;
-		s->rx_congst_umr  += rq_stats->congst_umr;
-		s->rx_arfs_err    += rq_stats->arfs_err;
-		s->ch_events      += ch_stats->events;
-		s->ch_poll        += ch_stats->poll;
-		s->ch_arm         += ch_stats->arm;
-		s->ch_aff_change  += ch_stats->aff_change;
-		s->ch_eq_rearm    += ch_stats->eq_rearm;
-		/* xdp redirect */
-		s->tx_xdp_xmit    += xdpsq_red_stats->xmit;
-		s->tx_xdp_full    += xdpsq_red_stats->full;
-		s->tx_xdp_err     += xdpsq_red_stats->err;
-		s->tx_xdp_cqes    += xdpsq_red_stats->cqes;
-
-		for (j = 0; j < priv->max_opened_tc; j++) {
-			struct mlx5e_sq_stats *sq_stats = &channel_stats->sq[j];
-
-			s->tx_packets		+= sq_stats->packets;
-			s->tx_bytes		+= sq_stats->bytes;
-			s->tx_tso_packets	+= sq_stats->tso_packets;
-			s->tx_tso_bytes		+= sq_stats->tso_bytes;
-			s->tx_tso_inner_packets	+= sq_stats->tso_inner_packets;
-			s->tx_tso_inner_bytes	+= sq_stats->tso_inner_bytes;
-			s->tx_added_vlan_packets += sq_stats->added_vlan_packets;
-			s->tx_nop               += sq_stats->nop;
-			s->tx_queue_stopped	+= sq_stats->stopped;
-			s->tx_queue_wake	+= sq_stats->wake;
-			s->tx_udp_seg_rem	+= sq_stats->udp_seg_rem;
-			s->tx_queue_dropped	+= sq_stats->dropped;
-			s->tx_cqe_err		+= sq_stats->cqe_err;
-			s->tx_recover		+= sq_stats->recover;
-			s->tx_xmit_more		+= sq_stats->xmit_more;
-			s->tx_csum_partial_inner += sq_stats->csum_partial_inner;
-			s->tx_csum_none		+= sq_stats->csum_none;
-			s->tx_csum_partial	+= sq_stats->csum_partial;
-#ifdef CONFIG_MLX5_EN_TLS
-			s->tx_tls_ooo		+= sq_stats->tls_ooo;
-			s->tx_tls_resync_bytes	+= sq_stats->tls_resync_bytes;
-#endif
-			s->tx_cqes		+= sq_stats->cqes;
-		}
-	}
+	memset(&s, 0, sizeof(s));
+
+	for (i = 0; i < mlx5e_get_netdev_max_channels(priv->netdev); i++)
+		mlx5e_grp_sw_collect_stat(priv, &s, i);
 
-	memcpy(&priv->stats.sw, s, sizeof(*s));
+	memcpy(&priv->stats.sw, &s, sizeof(s));
 }
 
 static const struct counter_desc q_stats_desc[] = {
-- 
2.18.0
