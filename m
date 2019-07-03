From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 5/5] net/mlx5: Properly name the generic WQE control
 field
Date: Wed, 3 Jul 2019 07:39:34 +0000
Message-ID: <20190703073909.14965-6-saeedm@mellanox.com>
References: <20190703073909.14965-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190703073909.14965-1-saeedm@mellanox.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Tariq Toukan <tariqt@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

A generic WQE control field is used for different purposes
in different cases.
Use union to allow using the proper name in each case.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/qp.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index d1f353c64797..127d224443e3 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -202,7 +202,12 @@ struct mlx5_wqe_ctrl_seg {
 	u8			signature;
 	u8			rsvd[2];
 	u8			fm_ce_se;
-	__be32			imm;
+	union {
+		__be32		general_id;
+		__be32		imm;
+		__be32		umr_mkey;
+		__be32		tisn;
+	};
 };
=20
 #define MLX5_WQE_CTRL_DS_MASK 0x3f
--=20
2.21.0
