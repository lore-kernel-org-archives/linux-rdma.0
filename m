From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v2 2/5] RDMA/core: Don't depend device ODP capabilities on kconfig option
Date: Tue,  8 Jan 2019 08:16:42 +0200
Message-ID: <20190108061645.25226-3-leon@kernel.org>
References: <20190108061645.25226-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190108061645.25226-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Haggai Eran <haggaie@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Device capability bits are exposing what specific device supports from
HW perspective. Those bits are not dependent on kernel configurations
and RDMA/core should ensure that proper interfaces to users will be
disabled if CONFIG_INFINIBAND_ON_DEMAND_PAGING is not set.

Fixes: f4056bfd8ccf ("IB/core: Add on demand paging caps to ib_uverbs_ex_query_device")
Fixes: 8cdd312cfed7 ("IB/mlx5: Implement the ODP capability query verb")
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/uverbs_cmd.c |  2 --
 drivers/infiniband/hw/mlx5/main.c    | 10 +++++-----
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 6b12cc5f97b2..549d9eedf62e 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3609,7 +3609,6 @@ static int ib_uverbs_ex_query_device(struct uverbs_attr_bundle *attrs)
 
 	copy_query_dev_fields(ucontext, &resp.base, &attr);
 
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	resp.odp_caps.general_caps = attr.odp_caps.general_caps;
 	resp.odp_caps.per_transport_caps.rc_odp_caps =
 		attr.odp_caps.per_transport_caps.rc_odp_caps;
@@ -3617,7 +3616,6 @@ static int ib_uverbs_ex_query_device(struct uverbs_attr_bundle *attrs)
 		attr.odp_caps.per_transport_caps.uc_odp_caps;
 	resp.odp_caps.per_transport_caps.ud_odp_caps =
 		attr.odp_caps.per_transport_caps.ud_odp_caps;
-#endif
 
 	resp.timestamp_mask = attr.timestamp_mask;
 	resp.hca_core_clock = attr.hca_core_clock;
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 94fe253d4956..06ee1f0cb22d 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -923,11 +923,11 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	props->hca_core_clock = MLX5_CAP_GEN(mdev, device_frequency_khz);
 	props->timestamp_mask = 0x7FFFFFFFFFFFFFFFULL;
 
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	if (MLX5_CAP_GEN(mdev, pg))
-		props->device_cap_flags |= IB_DEVICE_ON_DEMAND_PAGING;
-	props->odp_caps = dev->odp_caps;
-#endif
+	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING)) {
+		if (MLX5_CAP_GEN(mdev, pg))
+			props->device_cap_flags |= IB_DEVICE_ON_DEMAND_PAGING;
+		props->odp_caps = dev->odp_caps;
+	}
 
 	if (MLX5_CAP_GEN(mdev, cd))
 		props->device_cap_flags |= IB_DEVICE_CROSS_CHANNEL;
-- 
2.19.1
