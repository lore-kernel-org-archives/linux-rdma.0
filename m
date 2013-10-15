From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC 9/9] IB/mlx5: Publish support in signature feature
Date: Tue, 15 Oct 2013 18:38:30 +0300
Message-ID: <1381851510-17290-10-git-send-email-sagig@mellanox.com>
References: <1381851510-17290-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1381851510-17290-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Currently support only T10-DIF types of signature
handover operations (typs 1|2|3).

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index f3c7111..3dd8219 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -274,6 +274,15 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	if (flags & MLX5_DEV_CAP_FLAG_XRC)
 		props->device_cap_flags |= IB_DEVICE_XRC;
 	props->device_cap_flags |= IB_DEVICE_MEM_MGT_EXTENSIONS;
+	if (flags & MLX5_DEV_CAP_FLAG_SIG_HAND_OVER) {
+		props->device_cap_flags |= IB_DEVICE_SIGNATURE_HANDOVER;
+		/* At this stage no support for signature handover */
+		props->sig_prot_cap = IB_PROT_T10DIF_TYPE_1 |
+				      IB_PROT_T10DIF_TYPE_2 |
+				      IB_PROT_T10DIF_TYPE_3;
+		props->sig_guard_cap = IB_GUARD_T10DIF_CRC |
+				       IB_GUARD_T10DIF_CSUM;
+	}
 
 	props->vendor_id	   = be32_to_cpup((__be32 *)(out_mad->data + 36)) &
 		0xffffff;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
