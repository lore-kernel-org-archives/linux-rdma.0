From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 6/8] net/mlx5: Expose TIR ICM address in command outbox
Date: Sun, 31 Mar 2019 19:44:48 +0300
Message-ID: <20190331164450.23618-7-leon@kernel.org>
References: <20190331164450.23618-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190331164450.23618-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Ariel Levkovich <lariel@mellanox.com>, Eli Cohen <eli@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Ariel Levkovich <lariel@mellanox.com>

Adding the TIR ICM address to the create_tir command outbox
through which the device reports the ICM address of the newly
created TIR.

The TIR address can be used for direct attachment to a steering
rule in SW managed steering mode.

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
Reviewed-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index c2a558d58067..688b6172cbd5 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -6899,14 +6899,14 @@ struct mlx5_ifc_create_tis_in_bits {
 
 struct mlx5_ifc_create_tir_out_bits {
 	u8         status[0x8];
-	u8         reserved_at_8[0x18];
+	u8         icm_address_63_40[0x18];
 
 	u8         syndrome[0x20];
 
-	u8         reserved_at_40[0x8];
+	u8         icm_address_39_32[0x8];
 	u8         tirn[0x18];
 
-	u8         reserved_at_60[0x20];
+	u8         icm_address_31_0[0x20];
 };
 
 struct mlx5_ifc_create_tir_in_bits {
-- 
2.20.1
