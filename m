From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 1/2] IB/core: Add don't trap flag to flow creation
Date: Thu, 18 Feb 2016 18:31:05 +0200
Message-ID: <1455813066-13028-2-git-send-email-yishaih@mellanox.com>
References: <1455813066-13028-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455813066-13028-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, marinav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Marina Varshaver <marinav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Don't trap flag (i.e. IB_FLOW_ATTR_FLAGS_DONT_TRAP) indicates that QP
will receive traffic, but will not steal it.

When a packet matches a flow steering rule that was created with
the don't trap flag, the QPs assigned to this rule will get this
packet, but matching will continue to other equal/lower priority
rules. This will let other QPs assigned to those rules to get the
packet too.

If both don't trap rule and other rules have the same priority
and match the same packet, the behavior is undefined.

The don't trap flag can't be set with default rule types
(i.e. IB_FLOW_ATTR_ALL_DEFAULT, IB_FLOW_ATTR_MC_DEFAULT) as default rules
don't have rules after them and don't trap has no meaning here.

Signed-off-by: Marina Varshaver <marinav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 8 ++++++++
 drivers/infiniband/hw/mlx4/main.c    | 3 +++
 include/rdma/ib_verbs.h              | 5 +++++
 3 files changed, 16 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 6ffc9c4..0f05de6 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3085,6 +3085,14 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 	     !capable(CAP_NET_ADMIN)) || !capable(CAP_NET_RAW))
 		return -EPERM;
 
+	if (cmd.flow_attr.flags >= IB_FLOW_ATTR_FLAGS_RESERVED)
+		return -EINVAL;
+
+	if ((cmd.flow_attr.flags & IB_FLOW_ATTR_FLAGS_DONT_TRAP) &&
+	    ((cmd.flow_attr.type == IB_FLOW_ATTR_ALL_DEFAULT) ||
+	     (cmd.flow_attr.type == IB_FLOW_ATTR_MC_DEFAULT)))
+		return -EINVAL;
+
 	if (cmd.flow_attr.num_of_specs > IB_FLOW_SPEC_SUPPORT_LAYERS)
 		return -EINVAL;
 
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 1c7ab6c..41f2c25 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1653,6 +1653,9 @@ static struct ib_flow *mlx4_ib_create_flow(struct ib_qp *qp,
 	struct mlx4_dev *dev = (to_mdev(qp->device))->dev;
 	int is_bonded = mlx4_is_bonded(dev);
 
+	if (flow_attr->flags & IB_FLOW_ATTR_FLAGS_DONT_TRAP)
+		return ERR_PTR(-EOPNOTSUPP);
+
 	memset(type, 0, sizeof(type));
 
 	mflow = kzalloc(sizeof(*mflow), GFP_KERNEL);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 284b00c..514223f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1487,6 +1487,11 @@ enum ib_flow_domain {
 	IB_FLOW_DOMAIN_NUM /* Must be last */
 };
 
+enum ib_flow_flags {
+	IB_FLOW_ATTR_FLAGS_DONT_TRAP = 1UL << 1, /* Continue match, no steal */
+	IB_FLOW_ATTR_FLAGS_RESERVED  = 1UL << 2  /* Must be last */
+};
+
 struct ib_flow_eth_filter {
 	u8	dst_mac[6];
 	u8	src_mac[6];
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
