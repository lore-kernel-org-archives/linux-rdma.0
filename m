From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 10/16] IB/uverbs: Add support for flow counter set
Date: Thu, 19 Oct 2017 17:41:52 +0300
Message-ID: <1508424118-27205-11-git-send-email-yishaih@mellanox.com>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508424118-27205-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The struct ib_uverbs_flow_spec_action_count associates
a counter set with the flow.

Use of ib_uverbs_flow_spec_action_count allows the
consumer to associate an existing counter set to
a flow on creation.

Signed-off-by: Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h     |  1 +
 drivers/infiniband/core/uverbs_cmd.c | 32 ++++++++++++++++++++++++++++++++
 include/uapi/rdma/ib_user_verbs.h    | 13 +++++++++++++
 3 files changed, 46 insertions(+)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 50c4bb4..c87aca9 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -244,6 +244,7 @@ struct ib_uverbs_flow_spec {
 		struct ib_uverbs_flow_spec_ipv6    ipv6;
 		struct ib_uverbs_flow_spec_action_tag	flow_tag;
 		struct ib_uverbs_flow_spec_action_drop	drop;
+		struct ib_uverbs_flow_spec_action_count flow_count;
 	};
 };
 
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index bf2b95a..e05726f 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2732,6 +2732,13 @@ static int kern_spec_to_ib_spec_action(struct ib_uverbs_flow_spec *kern_spec,
 
 		ib_spec->drop.size = sizeof(struct ib_flow_spec_action_drop);
 		break;
+	case IB_FLOW_SPEC_ACTION_COUNT:
+		if (kern_spec->flow_count.size !=
+			sizeof(struct ib_uverbs_flow_spec_action_count))
+			return -EINVAL;
+		ib_spec->flow_count.size =
+				sizeof(struct ib_flow_spec_action_count);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -3269,9 +3276,11 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 	struct ib_uverbs_flow_attr	  *kern_flow_attr;
 	struct ib_flow_attr		  *flow_attr;
 	struct ib_qp			  *qp;
+	struct ib_counter_set	*cs = NULL;
 	int err = 0;
 	void *kern_spec;
 	void *ib_spec;
+	int cs_used = 0;
 	int i;
 
 	if (ucore->inlen < sizeof(cmd))
@@ -3366,6 +3375,25 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 		flow_attr->size +=
 			((union ib_flow_spec *) ib_spec)->size;
 		cmd.flow_attr.size -= ((struct ib_uverbs_flow_spec *)kern_spec)->size;
+		if (((struct ib_uverbs_flow_spec *)kern_spec)->type ==
+				IB_FLOW_SPEC_ACTION_COUNT) {
+			__u32 cs_handle =
+				((struct ib_uverbs_flow_spec *)kern_spec)->flow_count.cs_handle;
+			cs_used++;
+			if (cs_used > 1) {
+				uobj_put_obj_read(cs);
+				err = -EINVAL;
+				goto err_free;
+			}
+			cs = uobj_get_obj_read(counter_set,
+					       cs_handle,
+					       file->ucontext);
+			if (!cs) {
+				err = -EINVAL;
+				goto err_free;
+			}
+			((union ib_flow_spec *)ib_spec)->flow_count.counter_set = cs;
+		}
 		kern_spec += ((struct ib_uverbs_flow_spec *) kern_spec)->size;
 		ib_spec += ((union ib_flow_spec *) ib_spec)->size;
 	}
@@ -3376,6 +3404,10 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 		goto err_free;
 	}
 	flow_id = ib_create_flow(qp, flow_attr, IB_FLOW_DOMAIN_USER);
+
+	if (cs_used)
+		uobj_put_obj_read(cs);
+
 	if (IS_ERR(flow_id)) {
 		err = PTR_ERR(flow_id);
 		goto err_free;
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 49d9b2d..63f79d5 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -987,6 +987,19 @@ struct ib_uverbs_flow_spec_action_drop {
 	};
 };
 
+struct ib_uverbs_flow_spec_action_count {
+	union {
+		struct ib_uverbs_flow_spec_hdr hdr;
+		struct {
+			__u32 type;
+			__u16 size;
+			__u16 reserved;
+		};
+	};
+	__u32 cs_handle;
+	__u32 reserved1;
+};
+
 struct ib_uverbs_flow_tunnel_filter {
 	__be32 tunnel_id;
 };
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
