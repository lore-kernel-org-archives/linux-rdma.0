From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 02/20] net/mlx5e: drop useless LIST_HEAD
Date: Sun, 23 Dec 2018 09:56:57 +0100
Message-ID: <1545555435-24576-3-git-send-email-Julia.Lawall@lip6.fr>
References: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: kernel-janitors@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Drop LIST_HEAD where the variable it declares is never used.

These became useless in 244cd96adb5f ("net_sched: remove list_head
from tc_action")

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier x;
@@
- LIST_HEAD(x);
  ... when != x
// </smpl>

Fixes: 244cd96adb5f ("net_sched: remove list_head from tc_action")
Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Successfully 0-day tested on 151 configurations.

 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 4d6c9757afad..cae6c6d48984 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2183,7 +2183,6 @@ static bool modify_header_match_supported(struct mlx5_flow_spec *spec,
 {
 	const struct tc_action *a;
 	bool modify_ip_header;
-	LIST_HEAD(actions);
 	u8 htype, ip_proto;
 	void *headers_v;
 	u16 ethertype;
@@ -2272,7 +2271,6 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv, struct tcf_exts *exts,
 {
 	struct mlx5_nic_flow_attr *attr = flow->nic_attr;
 	const struct tc_action *a;
-	LIST_HEAD(actions);
 	u32 action = 0;
 	int err, i;
 
@@ -2511,7 +2509,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv, struct tcf_exts *exts,
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 	struct ip_tunnel_info *info = NULL;
 	const struct tc_action *a;
-	LIST_HEAD(actions);
 	bool encap = false;
 	u32 action = 0;
 	int err, i;
