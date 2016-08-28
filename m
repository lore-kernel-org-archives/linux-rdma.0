From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 7/9] IB/mlx5: Add VERBOSITY Kconfig option
Date: Sun, 28 Aug 2016 10:58:36 +0300
Message-ID: <1472371118-8260-8-git-send-email-leon@kernel.org>
References: <1472371118-8260-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472371118-8260-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch introduces new MLX5_INFINIBAND_VERBOSE Kconfig
option to enable the output of dump_wqe() which was never
printed.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/Kconfig | 6 ++++++
 drivers/infiniband/hw/mlx5/qp.c    | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/Kconfig b/drivers/infiniband/hw/mlx5/Kconfig
index bce263b..789fef4 100644
--- a/drivers/infiniband/hw/mlx5/Kconfig
+++ b/drivers/infiniband/hw/mlx5/Kconfig
@@ -6,3 +6,9 @@ config MLX5_INFINIBAND
 	  Mellanox Connect-IB PCI Express host channel adapters (HCAs).
 	  This is required to use InfiniBand protocols such as
 	  IP-over-IB or SRP with these devices.
+
+config MLX5_INFINIBAND_VERBOSE
+	bool "Enable ConnectX-4/Connect-IB verbosity"
+	depends on MLX5_INFINIBAND
+	---help---
+	  This is a configuration option to enable verbose output to easy debug.
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 174d09b..67b58f7 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3984,7 +3984,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			   get_fence(fence, wr), next_fence,
 			   mlx5_ib_opcode[wr->opcode]);
 skip_psv:
-		if (0)
+		if (IS_BUILTIN(CONFIG_MLX5_INFINIBAND_VERBOSE))
 			dump_wqe(qp, idx, size);
 	}

--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
