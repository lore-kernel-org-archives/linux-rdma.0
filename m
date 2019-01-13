From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 1/3] IB/mlx5: DEVX handling for indirection MKEY
Date: Sun, 13 Jan 2019 16:01:16 +0200
Message-ID: <20190113140118.10204-2-leon@kernel.org>
References: <20190113140118.10204-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190113140118.10204-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Once an indirection MKEY is created umem valid bit shouldn't be set as
this MKEY doesn't really hold a umem.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/devx.c | 38 +++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 8bb711da7ee1..b7ff2138ac2a 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -1011,6 +1011,32 @@ static void devx_obj_build_destroy_cmd(void *in, void *out, void *din,
 	}
 }
 
+static int devx_handle_mkey_create(struct mlx5_ib_dev *dev,
+				   struct devx_obj *obj,
+				   void *in, int in_len)
+{
+	int min_len = MLX5_BYTE_OFF(create_mkey_in, memory_key_mkey_entry) +
+			MLX5_FLD_SZ_BYTES(create_mkey_in,
+			memory_key_mkey_entry);
+	void *mkc;
+	u8 access_mode;
+
+	if (in_len < min_len)
+		return -EINVAL;
+
+	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
+
+	access_mode = MLX5_GET(mkc, mkc, access_mode_1_0);
+	access_mode |= MLX5_GET(mkc, mkc, access_mode_4_2) << 2;
+
+	if (access_mode == MLX5_MKC_ACCESS_MODE_KLMS ||
+		access_mode == MLX5_MKC_ACCESS_MODE_KSM)
+		return 0;
+
+	MLX5_SET(create_mkey_in, in, mkey_umem_valid, 1);
+	return 0;
+}
+
 static int devx_obj_cleanup(struct ib_uobject *uobject,
 			    enum rdma_remove_reason why)
 {
@@ -1032,6 +1058,8 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 	void *cmd_in = uverbs_attr_get_alloced_ptr(attrs, MLX5_IB_ATTR_DEVX_OBJ_CREATE_CMD_IN);
 	int cmd_out_len =  uverbs_attr_get_len(attrs,
 					MLX5_IB_ATTR_DEVX_OBJ_CREATE_CMD_OUT);
+	int cmd_in_len = uverbs_attr_get_len(attrs,
+					MLX5_IB_ATTR_DEVX_OBJ_CREATE_CMD_IN);
 	void *cmd_out;
 	struct ib_uobject *uobj = uverbs_attr_get_uobject(
 		attrs, MLX5_IB_ATTR_DEVX_OBJ_CREATE_HANDLE);
@@ -1060,10 +1088,16 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 		return -ENOMEM;
 
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_in, uid, uid);
-	devx_set_umem_valid(cmd_in);
+	if (opcode == MLX5_CMD_OP_CREATE_MKEY) {
+		err = devx_handle_mkey_create(dev, obj, cmd_in, cmd_in_len);
+		if (err)
+			goto obj_free;
+	} else {
+		devx_set_umem_valid(cmd_in);
+	}
 
 	err = mlx5_cmd_exec(dev->mdev, cmd_in,
-			    uverbs_attr_get_len(attrs, MLX5_IB_ATTR_DEVX_OBJ_CREATE_CMD_IN),
+			    cmd_in_len,
 			    cmd_out, cmd_out_len);
 	if (err)
 		goto obj_free;
-- 
2.19.1
