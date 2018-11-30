From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 1/3] net/mlx5: Expose packet based credit mode
Date: Fri, 30 Nov 2018 13:22:04 +0200
Message-ID: <20181130112206.19870-2-leon@kernel.org>
References: <20181130112206.19870-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181130112206.19870-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Danit Goldberg <danitg@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Danit Goldberg <danitg@mellanox.com>

Packet based credit mode bit determines whether the credit mode
is done per message or packet. Expose the QP creation flag and
the HCA capability.

Signed-off-by: Danit Goldberg <danitg@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 171d68663640..52393fbcf3b4 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1057,7 +1057,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         vector_calc[0x1];
 	u8         umr_ptr_rlky[0x1];
 	u8	   imaicl[0x1];
-	u8         reserved_at_232[0x4];
+	u8	   qp_packet_based[0x1];
+	u8         reserved_at_233[0x3];
 	u8         qkv[0x1];
 	u8         pkv[0x1];
 	u8         set_deth_sqpn[0x1];
@@ -2269,7 +2270,8 @@ struct mlx5_ifc_qpc_bits {
 	u8         st[0x8];
 	u8         reserved_at_10[0x3];
 	u8         pm_state[0x2];
-	u8         reserved_at_15[0x3];
+	u8         reserved_at_15[0x1];
+	u8         req_e2e_credit_mode[0x2];
 	u8         offload_type[0x4];
 	u8         end_padding_mode[0x2];
 	u8         reserved_at_1e[0x2];
-- 
2.19.1
