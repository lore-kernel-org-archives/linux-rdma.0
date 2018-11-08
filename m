From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 04/10] net/mlx5: Enumerate page fault types
Date: Thu,  8 Nov 2018 21:10:11 +0200
Message-ID: <20181108191017.21891-5-leon@kernel.org>
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

Give meaningful names to type of WQE page faults.

Signed-off-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/device.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index b4c0457fbebd..e326524bafcc 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -212,6 +212,13 @@ enum {
 	MLX5_PFAULT_SUBTYPE_RDMA = 1,
 };
 
+enum wqe_page_fault_type {
+	MLX5_WQE_PF_TYPE_RMP = 0,
+	MLX5_WQE_PF_TYPE_REQ_SEND_OR_WRITE = 1,
+	MLX5_WQE_PF_TYPE_RESP = 2,
+	MLX5_WQE_PF_TYPE_REQ_READ_OR_ATOMIC = 3,
+};
+
 enum {
 	MLX5_PERM_LOCAL_READ	= 1 << 2,
 	MLX5_PERM_LOCAL_WRITE	= 1 << 3,
-- 
2.19.1
