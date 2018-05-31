From: "Ruhl, Michael J" <michael.j.ruhl@intel.com>
Subject: RE: [PATCH rdma-next v3 10/14] IB/uverbs: Add support for flow
 counters
Date: Thu, 31 May 2018 14:49:44 +0000
Message-ID: <14063C7AD467DE4B82DEDB5C278E8663B38F0661@FMSMSX108.amr.corp.intel.com>
References: <20180531134341.18441-1-leon@kernel.org>
 <20180531134341.18441-11-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180531134341.18441-11-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

>-----Original Message-----
>From: Leon Romanovsky [mailto:leon@kernel.org]
>Sent: Thursday, May 31, 2018 9:44 AM
>To: Doug Ledford <dledford@redhat.com>; Jason Gunthorpe
><jgg@mellanox.com>
>Cc: Leon Romanovsky <leonro@mellanox.com>; RDMA mailing list <linux-
>rdma@vger.kernel.org>; Boris Pismenny <borisp@mellanox.com>; Matan
>Barak <matanb@mellanox.com>; Ruhl, Michael J <michael.j.ruhl@intel.com>;
>Or Gerlitz <ogerlitz@mellanox.com>; Raed Salem <raeds@mellanox.com>;
>Yishai Hadas <yishaih@mellanox.com>; Saeed Mahameed
><saeedm@mellanox.com>; linux-netdev <netdev@vger.kernel.org>
>Subject: [PATCH rdma-next v3 10/14] IB/uverbs: Add support for flow
>counters
>
>From: Raed Salem <raeds@mellanox.com>
>
>The struct ib_uverbs_flow_spec_action_count associates
>a counters object with the flow.
>
>Post this association the flow counters can be read via
>the counters object.
>
>Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
>Signed-off-by: Raed Salem <raeds@mellanox.com>
>Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>---
> drivers/infiniband/core/uverbs.h     |  1 +
> drivers/infiniband/core/uverbs_cmd.c | 81
>+++++++++++++++++++++++++++++++-----
> include/uapi/rdma/ib_user_verbs.h    | 13 ++++++
> 3 files changed, 84 insertions(+), 11 deletions(-)
>
>diff --git a/drivers/infiniband/core/uverbs.h
>b/drivers/infiniband/core/uverbs.h
>index 5b2461fa634d..c0d40fc3a53a 100644
>--- a/drivers/infiniband/core/uverbs.h
>+++ b/drivers/infiniband/core/uverbs.h
>@@ -263,6 +263,7 @@ struct ib_uverbs_flow_spec {
> 		struct ib_uverbs_flow_spec_action_tag	flow_tag;
> 		struct ib_uverbs_flow_spec_action_drop	drop;
> 		struct ib_uverbs_flow_spec_action_handle action;
>+		struct ib_uverbs_flow_spec_action_count flow_count;
> 	};
> };
>
>diff --git a/drivers/infiniband/core/uverbs_cmd.c
>b/drivers/infiniband/core/uverbs_cmd.c
>index ddb9d79691be..3179a95c6f5e 100644
>--- a/drivers/infiniband/core/uverbs_cmd.c
>+++ b/drivers/infiniband/core/uverbs_cmd.c
>@@ -2748,43 +2748,82 @@ ssize_t ib_uverbs_detach_mcast(struct
>ib_uverbs_file *file,
> struct ib_uflow_resources {
> 	size_t			max;
> 	size_t			num;
>-	struct ib_flow_action	*collection[0];
>+	size_t			collection_num;
>+	size_t			counters_num;
>+	struct ib_counters	**counters;
>+	struct ib_flow_action	**collection;
> };
>
> static struct ib_uflow_resources *flow_resources_alloc(size_t num_specs)
> {
> 	struct ib_uflow_resources *resources;
>
>-	resources =
>-		kmalloc(sizeof(*resources) +
>-			num_specs * sizeof(*resources->collection),
>GFP_KERNEL);
>+	resources = kzalloc(sizeof(*resources), GFP_KERNEL);
>
> 	if (!resources)
>-		return NULL;
>+		goto err_res;

Why the new goto?

>+
>+	resources->counters =
>+		kcalloc(num_specs, sizeof(*resources->counters),
>GFP_KERNEL);
>+
>+	if (!resources->counters)
>+		goto err_cnt;

kcalloc() zeros stuff.  Could you just have a single common goto for the
cleanup?

Mike

>+
>+	resources->collection =
>+		kcalloc(num_specs, sizeof(*resources->collection),
>GFP_KERNEL);
>+
>+	if (!resources->collection)
>+		goto err_collection;
>
>-	resources->num = 0;
> 	resources->max = num_specs;
>
> 	return resources;
>+
>+err_collection:
>+	kfree(resources->counters);
>+err_cnt:
>+	kfree(resources);
>+err_res:
>+	return NULL;
> }
>
> void ib_uverbs_flow_resources_free(struct ib_uflow_resources *uflow_res)
> {
> 	unsigned int i;
>
>-	for (i = 0; i < uflow_res->num; i++)
>+	for (i = 0; i < uflow_res->collection_num; i++)
> 		atomic_dec(&uflow_res->collection[i]->usecnt);
>
>+	for (i = 0; i < uflow_res->counters_num; i++)
>+		atomic_dec(&uflow_res->counters[i]->usecnt);
>+
>+	kfree(uflow_res->collection);
>+	kfree(uflow_res->counters);
> 	kfree(uflow_res);
> }
>
> static void flow_resources_add(struct ib_uflow_resources *uflow_res,
>-			       struct ib_flow_action *action)
>+			       enum ib_flow_spec_type type,
>+			       void *ibobj)
> {
> 	WARN_ON(uflow_res->num >= uflow_res->max);
>
>-	atomic_inc(&action->usecnt);
>-	uflow_res->collection[uflow_res->num++] = action;
>+	switch (type) {
>+	case IB_FLOW_SPEC_ACTION_HANDLE:
>+		atomic_inc(&((struct ib_flow_action *)ibobj)->usecnt);
>+		uflow_res->collection[uflow_res->collection_num++] =
>+			(struct ib_flow_action *)ibobj;
>+		break;
>+	case IB_FLOW_SPEC_ACTION_COUNT:
>+		atomic_inc(&((struct ib_counters *)ibobj)->usecnt);
>+		uflow_res->counters[uflow_res->counters_num++] =
>+			(struct ib_counters *)ibobj;
>+		break;
>+	default:
>+		WARN_ON(1);
>+	}
>+
>+	uflow_res->num++;
> }
>
> static int kern_spec_to_ib_spec_action(struct ib_ucontext *ucontext,
>@@ -2821,9 +2860,29 @@ static int kern_spec_to_ib_spec_action(struct
>ib_ucontext *ucontext,
> 			return -EINVAL;
> 		ib_spec->action.size =
> 			sizeof(struct ib_flow_spec_action_handle);
>-		flow_resources_add(uflow_res, ib_spec->action.act);
>+		flow_resources_add(uflow_res,
>+				   IB_FLOW_SPEC_ACTION_HANDLE,
>+				   ib_spec->action.act);
> 		uobj_put_obj_read(ib_spec->action.act);
> 		break;
>+	case IB_FLOW_SPEC_ACTION_COUNT:
>+		if (kern_spec->flow_count.size !=
>+			sizeof(struct ib_uverbs_flow_spec_action_count))
>+			return -EINVAL;
>+		ib_spec->flow_count.counters =
>+			uobj_get_obj_read(counters,
>+					  UVERBS_OBJECT_COUNTERS,
>+					  kern_spec->flow_count.handle,
>+					  ucontext);
>+		if (!ib_spec->flow_count.counters)
>+			return -EINVAL;
>+		ib_spec->flow_count.size =
>+				sizeof(struct ib_flow_spec_action_count);
>+		flow_resources_add(uflow_res,
>+				   IB_FLOW_SPEC_ACTION_COUNT,
>+				   ib_spec->flow_count.counters);
>+		uobj_put_obj_read(ib_spec->flow_count.counters);
>+		break;
> 	default:
> 		return -EINVAL;
> 	}
>diff --git a/include/uapi/rdma/ib_user_verbs.h
>b/include/uapi/rdma/ib_user_verbs.h
>index 409507f83b91..4f9991de8e3a 100644
>--- a/include/uapi/rdma/ib_user_verbs.h
>+++ b/include/uapi/rdma/ib_user_verbs.h
>@@ -998,6 +998,19 @@ struct ib_uverbs_flow_spec_action_handle {
> 	__u32			      reserved1;
> };
>
>+struct ib_uverbs_flow_spec_action_count {
>+	union {
>+		struct ib_uverbs_flow_spec_hdr hdr;
>+		struct {
>+			__u32 type;
>+			__u16 size;
>+			__u16 reserved;
>+		};
>+	};
>+	__u32			      handle;
>+	__u32			      reserved1;
>+};
>+
> struct ib_uverbs_flow_tunnel_filter {
> 	__be32 tunnel_id;
> };
>--
>2.14.3
