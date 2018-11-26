From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 6/7] IB/mlx5: Update the supported DEVX commands
Date: Mon, 26 Nov 2018 08:28:37 +0200
Message-ID: <20181126062838.5907-7-leon@kernel.org>
References: <20181126062838.5907-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181126062838.5907-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Update the supported DEVX commands, it includes adding to the
query/modify command's list and to the encoding handling.

In addition, a valid range for general commands was added to be used for
future commands.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/devx.c | 17 +++++++++++++++++
 include/linux/mlx5/mlx5_ifc.h     | 10 ++++++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 80053324dd31..5271469aad10 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -314,6 +314,8 @@ static u64 devx_get_obj_id(const void *in)
 					MLX5_GET(query_dct_in, in, dctn));
 		break;
 	case MLX5_CMD_OP_QUERY_XRQ:
+	case MLX5_CMD_OP_QUERY_XRQ_DC_PARAMS_ENTRY:
+	case MLX5_CMD_OP_QUERY_XRQ_ERROR_PARAMS:
 		obj_id = get_enc_obj_id(MLX5_CMD_OP_CREATE_XRQ,
 					MLX5_GET(query_xrq_in, in, xrqn));
 		break;
@@ -340,9 +342,16 @@ static u64 devx_get_obj_id(const void *in)
 					MLX5_GET(drain_dct_in, in, dctn));
 		break;
 	case MLX5_CMD_OP_ARM_XRQ:
+	case MLX5_CMD_OP_SET_XRQ_DC_PARAMS_ENTRY:
 		obj_id = get_enc_obj_id(MLX5_CMD_OP_CREATE_XRQ,
 					MLX5_GET(arm_xrq_in, in, xrqn));
 		break;
+	case MLX5_CMD_OP_QUERY_PACKET_REFORMAT_CONTEXT:
+		obj_id = get_enc_obj_id
+				(MLX5_CMD_OP_ALLOC_PACKET_REFORMAT_CONTEXT,
+				 MLX5_GET(query_packet_reformat_context_in,
+					  in, packet_reformat_id));
+		break;
 	default:
 		obj_id = 0;
 	}
@@ -601,6 +610,7 @@ static bool devx_is_obj_modify_cmd(const void *in)
 	case MLX5_CMD_OP_DRAIN_DCT:
 	case MLX5_CMD_OP_ARM_DCT_FOR_KEY_VIOLATION:
 	case MLX5_CMD_OP_ARM_XRQ:
+	case MLX5_CMD_OP_SET_XRQ_DC_PARAMS_ENTRY:
 		return true;
 	case MLX5_CMD_OP_SET_FLOW_TABLE_ENTRY:
 	{
@@ -642,6 +652,9 @@ static bool devx_is_obj_query_cmd(const void *in)
 	case MLX5_CMD_OP_QUERY_XRC_SRQ:
 	case MLX5_CMD_OP_QUERY_DCT:
 	case MLX5_CMD_OP_QUERY_XRQ:
+	case MLX5_CMD_OP_QUERY_XRQ_DC_PARAMS_ENTRY:
+	case MLX5_CMD_OP_QUERY_XRQ_ERROR_PARAMS:
+	case MLX5_CMD_OP_QUERY_PACKET_REFORMAT_CONTEXT:
 		return true;
 	default:
 		return false;
@@ -685,6 +698,10 @@ static bool devx_is_general_cmd(void *in)
 {
 	u16 opcode = MLX5_GET(general_obj_in_cmd_hdr, in, opcode);

+	if (opcode >= MLX5_CMD_OP_GENERAL_START &&
+	    opcode < MLX5_CMD_OP_GENERAL_END)
+		return true;
+
 	switch (opcode) {
 	case MLX5_CMD_OP_QUERY_HCA_CAP:
 	case MLX5_CMD_OP_QUERY_HCA_VPORT_CONTEXT:
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index ece1b606c909..171d68663640 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -144,6 +144,9 @@ enum {
 	MLX5_CMD_OP_DESTROY_XRQ                   = 0x718,
 	MLX5_CMD_OP_QUERY_XRQ                     = 0x719,
 	MLX5_CMD_OP_ARM_XRQ                       = 0x71a,
+	MLX5_CMD_OP_QUERY_XRQ_DC_PARAMS_ENTRY     = 0x725,
+	MLX5_CMD_OP_SET_XRQ_DC_PARAMS_ENTRY       = 0x726,
+	MLX5_CMD_OP_QUERY_XRQ_ERROR_PARAMS        = 0x727,
 	MLX5_CMD_OP_QUERY_VPORT_STATE             = 0x750,
 	MLX5_CMD_OP_MODIFY_VPORT_STATE            = 0x751,
 	MLX5_CMD_OP_QUERY_ESW_VPORT_CONTEXT       = 0x752,
@@ -245,6 +248,7 @@ enum {
 	MLX5_CMD_OP_MODIFY_FLOW_TABLE             = 0x93c,
 	MLX5_CMD_OP_ALLOC_PACKET_REFORMAT_CONTEXT = 0x93d,
 	MLX5_CMD_OP_DEALLOC_PACKET_REFORMAT_CONTEXT = 0x93e,
+	MLX5_CMD_OP_QUERY_PACKET_REFORMAT_CONTEXT = 0x93f,
 	MLX5_CMD_OP_ALLOC_MODIFY_HEADER_CONTEXT   = 0x940,
 	MLX5_CMD_OP_DEALLOC_MODIFY_HEADER_CONTEXT = 0x941,
 	MLX5_CMD_OP_QUERY_MODIFY_HEADER_CONTEXT   = 0x942,
@@ -260,6 +264,12 @@ enum {
 	MLX5_CMD_OP_MAX
 };

+/* Valid range for general commands that don't work over an object */
+enum {
+	MLX5_CMD_OP_GENERAL_START = 0xb00,
+	MLX5_CMD_OP_GENERAL_END = 0xd00,
+};
+
 struct mlx5_ifc_flow_table_fields_supported_bits {
 	u8         outer_dmac[0x1];
 	u8         outer_smac[0x1];
