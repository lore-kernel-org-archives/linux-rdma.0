From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 3/5] IB/uverbs: Add support for flow tag
Date: Wed, 18 Jan 2017 14:59:49 +0200
Message-ID: <20170118125951.3469-4-leon@kernel.org>
References: <20170118125951.3469-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118125951.3469-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rony Efraim <ronye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The struct ib_uverbs_flow_spec_action_tag associates a tag_id with the
flow defined by any number of other flow_spec entries which can reference
L2, L3, and L4 packet contents.

Use of ib_uverbs_flow_spec_action_tag allows the consumer to identify
the set of rules which where matched by
the packet by examining the tag_id in the CQE.

Signed-off-by: Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h     |  1 +
 drivers/infiniband/core/uverbs_cmd.c | 35 +++++++++++++++++++++++++++++++++--
 include/uapi/rdma/ib_user_verbs.h    | 13 +++++++++++++
 3 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 455034a..e1bedf0 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -228,6 +228,7 @@ struct ib_uverbs_flow_spec {
 		struct ib_uverbs_flow_spec_ipv4    ipv4;
 		struct ib_uverbs_flow_spec_tcp_udp tcp_udp;
 		struct ib_uverbs_flow_spec_ipv6    ipv6;
+		struct ib_uverbs_flow_spec_action_tag	flow_tag;
 	};
 };
 
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 7007822..0834dce 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3143,6 +3143,25 @@ ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file *file,
 	return ret ? ret : in_len;
 }
 
+static int kern_spec_to_ib_spec_action(struct ib_uverbs_flow_spec *kern_spec,
+				       union ib_flow_spec *ib_spec)
+{
+	ib_spec->type = kern_spec->type;
+	switch (ib_spec->type) {
+	case IB_FLOW_SPEC_ACTION_TAG:
+		if (kern_spec->flow_tag.size !=
+		    sizeof(struct ib_uverbs_flow_spec_action_tag))
+			return -EINVAL;
+
+		ib_spec->flow_tag.size = sizeof(struct ib_flow_spec_action_tag);
+		ib_spec->flow_tag.tag_id = kern_spec->flow_tag.tag_id;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static size_t kern_spec_filter_sz(struct ib_uverbs_flow_spec_hdr *spec)
 {
 	/* Returns user space filter size, includes padding */
@@ -3167,8 +3186,8 @@ static ssize_t spec_filter_size(void *kern_spec_filter, u16 kern_filter_size,
 	return kern_filter_size;
 }
 
-static int kern_spec_to_ib_spec(struct ib_uverbs_flow_spec *kern_spec,
-				union ib_flow_spec *ib_spec)
+static int kern_spec_to_ib_spec_filter(struct ib_uverbs_flow_spec *kern_spec,
+				       union ib_flow_spec *ib_spec)
 {
 	ssize_t actual_filter_sz;
 	ssize_t kern_filter_sz;
@@ -3263,6 +3282,18 @@ static int kern_spec_to_ib_spec(struct ib_uverbs_flow_spec *kern_spec,
 	return 0;
 }
 
+static int kern_spec_to_ib_spec(struct ib_uverbs_flow_spec *kern_spec,
+				union ib_flow_spec *ib_spec)
+{
+	if (kern_spec->reserved)
+		return -EINVAL;
+
+	if (kern_spec->type >= IB_FLOW_SPEC_ACTION_TAG)
+		return kern_spec_to_ib_spec_action(kern_spec, ib_spec);
+	else
+		return kern_spec_to_ib_spec_filter(kern_spec, ib_spec);
+}
+
 int ib_uverbs_ex_create_wq(struct ib_uverbs_file *file,
 			   struct ib_device *ib_dev,
 			   struct ib_udata *ucore,
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index dfdfe4e..b458fea 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -929,6 +929,19 @@ struct ib_uverbs_flow_spec_ipv6 {
 	struct ib_uverbs_flow_ipv6_filter mask;
 };
 
+struct ib_uverbs_flow_spec_action_tag {
+	union {
+		struct ib_uverbs_flow_spec_hdr hdr;
+		struct {
+			__u32 type;
+			__u16 size;
+			__u16 reserved;
+		};
+	};
+	__u32			      tag_id;
+	__u32			      reserved1;
+};
+
 struct ib_uverbs_flow_tunnel_filter {
 	__be32 tunnel_id;
 };
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
