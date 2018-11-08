From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 03/10] net/mlx5: Add interface to hold and release core resources
Date: Thu,  8 Nov 2018 21:10:10 +0200
Message-ID: <20181108191017.21891-4-leon@kernel.org>
References: <20181108191017.21891-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181108191017.21891-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis@mellanox.com>

Sometimes upper layers may want to prevent the destruction of a core
resource for a period of time while work on that resource is in
progress.  Add API to support this.

Signed-off-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/qp.c | 16 ++++++++++++++++
 include/linux/mlx5/qp.h                      |  5 +++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
index 690dc1dd9391..cba4a435043a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -670,3 +670,19 @@ int mlx5_core_query_q_counter(struct mlx5_core_dev *dev, u16 counter_id,
 	return mlx5_cmd_exec(dev, in, sizeof(in), out, out_size);
 }
 EXPORT_SYMBOL_GPL(mlx5_core_query_q_counter);
+
+struct mlx5_core_rsc_common *mlx5_core_res_hold(struct mlx5_core_dev *dev,
+						int res_num,
+						enum mlx5_res_type res_type)
+{
+	u32 rsn = res_num | (res_type << MLX5_USER_INDEX_LEN);
+
+	return mlx5_get_rsc(dev, rsn);
+}
+EXPORT_SYMBOL_GPL(mlx5_core_res_hold);
+
+void mlx5_core_res_put(struct mlx5_core_rsc_common *res)
+{
+	mlx5_core_put_rsc(res);
+}
+EXPORT_SYMBOL_GPL(mlx5_core_res_put);
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index fbe322c966bc..b26ea9077384 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -596,6 +596,11 @@ int mlx5_core_dealloc_q_counter(struct mlx5_core_dev *dev, u16 counter_id);
 int mlx5_core_query_q_counter(struct mlx5_core_dev *dev, u16 counter_id,
 			      int reset, void *out, int out_size);
 
+struct mlx5_core_rsc_common *mlx5_core_res_hold(struct mlx5_core_dev *dev,
+						int res_num,
+						enum mlx5_res_type res_type);
+void mlx5_core_res_put(struct mlx5_core_rsc_common *res);
+
 static inline const char *mlx5_qp_type_str(int type)
 {
 	switch (type) {
-- 
2.19.1
