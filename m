From: Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 03/10] net/mlx5_core: Break down the vport mac address query function
Date: Thu, 20 Aug 2015 19:46:22 +0300
Message-ID: <1440089189-3361-4-git-send-email-achiad@mellanox.com>
References: <1440089189-3361-1-git-send-email-achiad@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440089189-3361-1-git-send-email-achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVS1Z/+hSey0Gg@public.gmane.org>, Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Introduce a new function called mlx5_query_nic_vport_context().
This function gets all the NIC vport attributes from the device.

The MAC address is just one of the NIC vport attributes, so
mlx5_query_nic_vport_mac_address() is now just a wrapper function
above mlx5_query_nic_vport_context().

More NIC vport attributes will be used in following commits.

Signed-off-by: Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/vport.c | 27 ++++++++++++++++---------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index b94177e..54ab63b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -57,12 +57,25 @@ u8 mlx5_query_vport_state(struct mlx5_core_dev *mdev, u8 opmod)
 }
 EXPORT_SYMBOL(mlx5_query_vport_state);
 
+static int mlx5_query_nic_vport_context(struct mlx5_core_dev *mdev, u32 *out,
+					int outlen)
+{
+	u32 in[MLX5_ST_SZ_DW(query_nic_vport_context_in)];
+
+	memset(in, 0, sizeof(in));
+
+	MLX5_SET(query_nic_vport_context_in, in, opcode,
+		 MLX5_CMD_OP_QUERY_NIC_VPORT_CONTEXT);
+
+	return mlx5_cmd_exec_check_status(mdev, in, sizeof(in), out, outlen);
+}
+
 void mlx5_query_nic_vport_mac_address(struct mlx5_core_dev *mdev, u8 *addr)
 {
-	u32  in[MLX5_ST_SZ_DW(query_nic_vport_context_in)];
 	u32 *out;
 	int outlen = MLX5_ST_SZ_BYTES(query_nic_vport_context_out);
 	u8 *out_addr;
+	int err;
 
 	out = mlx5_vzalloc(outlen);
 	if (!out)
@@ -71,15 +84,9 @@ void mlx5_query_nic_vport_mac_address(struct mlx5_core_dev *mdev, u8 *addr)
 	out_addr = MLX5_ADDR_OF(query_nic_vport_context_out, out,
 				nic_vport_context.permanent_address);
 
-	memset(in, 0, sizeof(in));
-
-	MLX5_SET(query_nic_vport_context_in, in, opcode,
-		 MLX5_CMD_OP_QUERY_NIC_VPORT_CONTEXT);
-
-	memset(out, 0, outlen);
-	mlx5_cmd_exec_check_status(mdev, in, sizeof(in), out, outlen);
-
-	ether_addr_copy(addr, &out_addr[2]);
+	err = mlx5_query_nic_vport_context(mdev, out, outlen);
+	if (!err)
+		ether_addr_copy(addr, &out_addr[2]);
 
 	kvfree(out);
 }
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
