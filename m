From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 03/12] IB/uverbs: Expose XRC ODP device capabilities
Date: Tue, 22 Jan 2019 08:48:42 +0200
Message-ID: <20190122064851.6032-4-leon@kernel.org>
References: <20190122064851.6032-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190122064851.6032-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis@mellanox.com>

Expose XRC ODP capabilities as part of the extended device capabilities.

Signed-off-by: Moni Shoua <monis@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/uverbs_cmd.c | 1 +
 include/rdma/ib_verbs.h              | 1 +
 include/uapi/rdma/ib_user_verbs.h    | 2 ++
 3 files changed, 4 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 4e40a04d1857..b3430c7c67f3 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3613,6 +3613,7 @@ static int ib_uverbs_ex_query_device(struct uverbs_attr_bundle *attrs)
 		attr.odp_caps.per_transport_caps.uc_odp_caps;
 	resp.odp_caps.per_transport_caps.ud_odp_caps =
 		attr.odp_caps.per_transport_caps.ud_odp_caps;
+	resp.xrc_odp_caps = attr.odp_caps.per_transport_caps.xrc_odp_caps;
 
 	resp.timestamp_mask = attr.timestamp_mask;
 	resp.hca_core_clock = attr.hca_core_clock;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 38438561b648..d54c87640f89 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -277,6 +277,7 @@ struct ib_odp_caps {
 		uint32_t  rc_odp_caps;
 		uint32_t  uc_odp_caps;
 		uint32_t  ud_odp_caps;
+		uint32_t  xrc_odp_caps;
 	} per_transport_caps;
 };
 
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 480d9a60b68e..0474c7400268 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -270,6 +270,8 @@ struct ib_uverbs_ex_query_device_resp {
 	struct ib_uverbs_tm_caps tm_caps;
 	struct ib_uverbs_cq_moderation_caps cq_moderation_caps;
 	__aligned_u64 max_dm_size;
+	__u32 xrc_odp_caps;
+	__u32 reserved;
 };
 
 struct ib_uverbs_query_port {
-- 
2.19.1
