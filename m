From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 4/4] IB/mlx5: Compare only index part of a memory window rkey
Date: Tue, 19 Mar 2019 11:24:39 +0200
Message-ID: <20190319092439.10701-5-leon@kernel.org>
References: <20190319092439.10701-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190319092439.10701-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Guy Levi <guyle@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Jerome Glisse <jglisse@redhat.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko@mellanox.com>

The InfiniBand Architecture Specification section 10.6.7.2.4 TYPE
2 MEMORY WINDOWS says that if the CI supports the Base Memory Management
Extensions defined in this specification, the R_Key format for a Type
2 Memory Window must consist of:
* 24 bit index in the most significant bits of the R_Key, which is
owned by the CI, and
* 8 bit key in the least significant bits of the R_Key, which is
owned by the Consumer.

This means that the kernel should compare only the index part of a R_Key
to determine equality with another R_Key.

Fixes: db570d7deafb ("IB/mlx5: Add ODP support to MW")
Signed-off-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/odp.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 95dccac1f844..2b197da1cc37 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -711,6 +711,15 @@ struct pf_frame {
 	int depth;
 };
 
+static bool mkey_is_eq(struct mlx5_core_mkey *mmkey, u32 key)
+{
+	if (!mmkey)
+		return false;
+	if (mmkey->type == MLX5_MKEY_MW)
+		return mlx5_base_mkey(mmkey->key) == mlx5_base_mkey(key);
+	return mmkey->key == key;
+}
+
 static int get_indirect_num_descs(struct mlx5_core_mkey *mmkey)
 {
 	struct mlx5_ib_mw *mw;
@@ -760,7 +769,7 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 
 next_mr:
 	mmkey = __mlx5_mr_lookup(dev->mdev, mlx5_base_mkey(key));
-	if (!mmkey || mmkey->key != key) {
+	if (!mkey_is_eq(mmkey, key)) {
 		mlx5_ib_dbg(dev, "failed to find mkey %x\n", key);
 		ret = -EFAULT;
 		goto srcu_unlock;
-- 
2.20.1
