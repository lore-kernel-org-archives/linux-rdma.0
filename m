From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 1/2] IB/mlx5: Verify DEVX general object type correctly
Date: Tue, 14 May 2019 14:44:11 +0300
Message-ID: <20190514114412.30604-2-leon@kernel.org>
References: <20190514114412.30604-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190514114412.30604-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

As the obj_id in the firmware is not globally unique in general_object,
the object type must be considered upon checking for a valid object id.

Fixes: 2351776e87a1 ("IB/mlx5: Verify DEVX object type")
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/devx.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 169ffffcf5ed..80b42d069328 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -154,7 +154,7 @@ bool mlx5_ib_devx_is_flow_counter(void *obj, u32 *counter_id)
  * must be considered upon checking for a valid object id.
  * For that the opcode of the creator command is encoded as part of the obj_id.
  */
-static u64 get_enc_obj_id(u16 opcode, u32 obj_id)
+static u64 get_enc_obj_id(u32 opcode, u32 obj_id)
 {
 	return ((u64)opcode << 32) | obj_id;
 }
@@ -167,7 +167,9 @@ static u64 devx_get_obj_id(const void *in)
 	switch (opcode) {
 	case MLX5_CMD_OP_MODIFY_GENERAL_OBJECT:
 	case MLX5_CMD_OP_QUERY_GENERAL_OBJECT:
-		obj_id = get_enc_obj_id(MLX5_CMD_OP_CREATE_GENERAL_OBJECT,
+		obj_id = get_enc_obj_id(MLX5_CMD_OP_CREATE_GENERAL_OBJECT |
+					MLX5_GET(general_obj_in_cmd_hdr, in,
+						 obj_type) << 16,
 					MLX5_GET(general_obj_in_cmd_hdr, in,
 						 obj_id));
 		break;
@@ -1171,6 +1173,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 	struct mlx5_ib_dev *dev = to_mdev(c->ibucontext.device);
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
 	struct devx_obj *obj;
+	u16 obj_type = 0;
 	int err;
 	int uid;
 	u32 obj_id;
@@ -1230,7 +1233,11 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 	if (err)
 		goto err_copy;
 
-	obj->obj_id = get_enc_obj_id(opcode, obj_id);
+	if (opcode == MLX5_CMD_OP_CREATE_GENERAL_OBJECT)
+		obj_type = MLX5_GET(general_obj_in_cmd_hdr, cmd_in, obj_type);
+
+	obj->obj_id = get_enc_obj_id(opcode | obj_type << 16, obj_id);
+
 	return 0;
 
 err_copy:
-- 
2.20.1
