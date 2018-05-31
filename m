From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v3 09/14] IB/core: Add support for flow counters
Date: Thu, 31 May 2018 16:43:36 +0300
Message-ID: <20180531134341.18441-10-leon@kernel.org>
References: <20180531134341.18441-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180531134341.18441-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, "Michael J . Ruhl" <michael.j.ruhl@intel.com>, Or Gerlitz <ogerlitz@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

A counters object could be attached to flow on creation
by providing the counter specification action.

General counters description which count packets and bytes are
introduced, downstream patches from this series will use them
as part of flow counters binding.

In addition, increase number of flow specifications supported
layers to 10 upon adding count specification and for the
previously added drop specification.

Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Raed Salem <raeds@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/rdma/ib_verbs.h | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 84f412f7b8f3..2cc04abb6df8 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1859,9 +1859,10 @@ enum ib_flow_spec_type {
 	IB_FLOW_SPEC_ACTION_TAG         = 0x1000,
 	IB_FLOW_SPEC_ACTION_DROP        = 0x1001,
 	IB_FLOW_SPEC_ACTION_HANDLE	= 0x1002,
+	IB_FLOW_SPEC_ACTION_COUNT       = 0x1003,
 };
 #define IB_FLOW_SPEC_LAYER_MASK	0xF0
-#define IB_FLOW_SPEC_SUPPORT_LAYERS 8
+#define IB_FLOW_SPEC_SUPPORT_LAYERS 10
 
 /* Flow steering rule priority is set according to it's domain.
  * Lower domain value means higher priority.
@@ -2041,6 +2042,17 @@ struct ib_flow_spec_action_handle {
 	struct ib_flow_action	     *act;
 };
 
+enum ib_counters_description {
+	IB_COUNTER_PACKETS,
+	IB_COUNTER_BYTES,
+};
+
+struct ib_flow_spec_action_count {
+	enum ib_flow_spec_type type;
+	u16 size;
+	struct ib_counters *counters;
+};
+
 union ib_flow_spec {
 	struct {
 		u32			type;
@@ -2058,6 +2070,7 @@ union ib_flow_spec {
 	struct ib_flow_spec_action_tag  flow_tag;
 	struct ib_flow_spec_action_drop drop;
 	struct ib_flow_spec_action_handle action;
+	struct ib_flow_spec_action_count flow_count;
 };
 
 struct ib_flow_attr {
-- 
2.14.3
