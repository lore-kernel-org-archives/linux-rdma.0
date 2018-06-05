From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH net-next] net/mlx5e: fix error return code in mlx5e_alloc_rq()
Date: Tue, 5 Jun 2018 02:42:56 +0000
Message-ID: <1528166576-55047-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@mellanox.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Fix to return error code -ENOMEM from the kvzalloc_node() error handling
case instead of 0, as done elsewhere in this function.

Fixes: 069d11465a80 ("net/mlx5e: RX, Enhance legacy Receive Queue memory scheme")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 333d4ed..89c96a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -566,8 +566,10 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 			kvzalloc_node((wq_sz << rq->wqe.info.log_num_frags) *
 				      sizeof(*rq->wqe.frags),
 				      GFP_KERNEL, cpu_to_node(c->cpu));
-		if (!rq->wqe.frags)
+		if (!rq->wqe.frags) {
+			err = -ENOMEM;
 			goto err_free;
+		}
 
 		err = mlx5e_init_di_list(rq, params, wq_sz, c->cpu);
 		if (err)
