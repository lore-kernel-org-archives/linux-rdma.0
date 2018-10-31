From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma] net/mlx5: Fix XRC SRQ umem valid bits
Date: Wed, 31 Oct 2018 12:20:28 +0200
Message-ID: <20181031102028.9142-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Yishai Hadas <yishaih@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Adapt XRC SRQ to the latest HW specification with fixed definition
around umem valid bits. The previous definition relied on a bit which
was taken for other purposes in legacy FW.

Fixes: bd37197554eb ("net/mlx5: Update mlx5_ifc with DEVX UID bits")
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
Hi Doug, Jason

This commit fixes code sent in this merge window, so I'm not marking it
with any rdma-rc/rdma-next. It will be better to be sent during this merge
window if you have extra pull request to issue, or as a -rc material, if
not.

BTW, we didn't combine reserved fields, because our convention is to align such
fields to 32 bits for better readability.

Thanks
---
 include/linux/mlx5/mlx5_ifc.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 0f460fb22c31..248116bc13a8 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -2470,14 +2470,15 @@ struct mlx5_ifc_xrc_srqc_bits {

 	u8         wq_signature[0x1];
 	u8         cont_srq[0x1];
-	u8         dbr_umem_valid[0x1];
+	u8         reserved_at_22[0x1];
 	u8         rlky[0x1];
 	u8         basic_cyclic_rcv_wqe[0x1];
 	u8         log_rq_stride[0x3];
 	u8         xrcd[0x18];

 	u8         page_offset[0x6];
-	u8         reserved_at_46[0x2];
+	u8         reserved_at_46[0x1];
+	u8         dbr_umem_valid[0x1];
 	u8         cqn[0x18];

 	u8         reserved_at_60[0x20];
@@ -6685,9 +6686,12 @@ struct mlx5_ifc_create_xrc_srq_in_bits {

 	struct mlx5_ifc_xrc_srqc_bits xrc_srq_context_entry;

-	u8         reserved_at_280[0x40];
+	u8         reserved_at_280[0x60];
+
 	u8         xrc_srq_umem_valid[0x1];
-	u8         reserved_at_2c1[0x5bf];
+	u8         reserved_at_2e1[0x1f];
+
+	u8         reserved_at_300[0x580];

 	u8         pas[0][0x40];
 };
