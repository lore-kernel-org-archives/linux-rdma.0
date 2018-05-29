From: "Ruhl, Michael J" <michael.j.ruhl@intel.com>
Subject: RE: [PATCH rdma-next v2 01/13] IB/uverbs: Add an ib_uobject getter
 to ioctl() infrastructure
Date: Tue, 29 May 2018 19:31:22 +0000
Message-ID: <14063C7AD467DE4B82DEDB5C278E8663B38ED738@FMSMSX108.amr.corp.intel.com>
References: <20180529130917.13592-1-leon@kernel.org>
 <20180529130917.13592-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180529130917.13592-2-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

>-----Original Message-----
>From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
>owner@vger.kernel.org] On Behalf Of Leon Romanovsky
>Sent: Tuesday, May 29, 2018 9:09 AM
>To: Doug Ledford <dledford@redhat.com>; Jason Gunthorpe
><jgg@mellanox.com>
>Cc: Leon Romanovsky <leonro@mellanox.com>; RDMA mailing list <linux-
>rdma@vger.kernel.org>; Boris Pismenny <borisp@mellanox.com>; Matan
>Barak <matanb@mellanox.com>; Raed Salem <raeds@mellanox.com>; Yishai
>Hadas <yishaih@mellanox.com>; Saeed Mahameed
><saeedm@mellanox.com>; linux-netdev <netdev@vger.kernel.org>
>Subject: [PATCH rdma-next v2 01/13] IB/uverbs: Add an ib_uobject getter to
>ioctl() infrastructure
>
>From: Matan Barak <matanb@mellanox.com>
>
>Previously, the user had to dig inside the attribute to get the uobject.
>Add a helper function that correctly extract it (and do the required
>checks) for him/her.
>
>Tested-by: Michael Guralnik <michaelgur@mellanox.com>
>Signed-off-by: Matan Barak <matanb@mellanox.com>
>Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>---
> drivers/infiniband/core/uverbs_std_types_cq.c      | 23 +++++++++++---------
>--
> .../infiniband/core/uverbs_std_types_flow_action.c |  4 ++--
> include/rdma/uverbs_ioctl.h                        | 11 +++++++++++
> 3 files changed, 25 insertions(+), 13 deletions(-)
>
>diff --git a/drivers/infiniband/core/uverbs_std_types_cq.c
>b/drivers/infiniband/core/uverbs_std_types_cq.c
>index b0dbae9dd0d7..3d293d01afea 100644
>--- a/drivers/infiniband/core/uverbs_std_types_cq.c
>+++ b/drivers/infiniband/core/uverbs_std_types_cq.c
>@@ -65,7 +65,6 @@ static int
>UVERBS_HANDLER(UVERBS_METHOD_CQ_CREATE)(struct ib_device *ib_dev,
> 	struct ib_cq_init_attr attr = {};
> 	struct ib_cq                   *cq;
> 	struct ib_uverbs_completion_event_file    *ev_file = NULL;
>-	const struct uverbs_attr *ev_file_attr;
> 	struct ib_uobject *ev_file_uobj;
>
> 	if (!(ib_dev->uverbs_cmd_mask & 1ULL <<
>IB_USER_VERBS_CMD_CREATE_CQ))
>@@ -87,10 +86,8 @@ static int
>UVERBS_HANDLER(UVERBS_METHOD_CQ_CREATE)(struct ib_device *ib_dev,
>
>	UVERBS_ATTR_CREATE_CQ_FLAGS)))
> 		return -EFAULT;
>
>-	ev_file_attr = uverbs_attr_get(attrs,
>UVERBS_ATTR_CREATE_CQ_COMP_CHANNEL);
>-	if (!IS_ERR(ev_file_attr)) {
>-		ev_file_uobj = ev_file_attr->obj_attr.uobject;
>-
>+	ev_file_uobj = uverbs_attr_get_uobject(attrs,
>UVERBS_ATTR_CREATE_CQ_COMP_CHANNEL);
>+	if (!IS_ERR(ev_file_uobj)) {
> 		ev_file = container_of(ev_file_uobj,
> 				       struct ib_uverbs_completion_event_file,
> 				       uobj_file.uobj);
>@@ -102,8 +99,8 @@ static int
>UVERBS_HANDLER(UVERBS_METHOD_CQ_CREATE)(struct ib_device *ib_dev,
> 		goto err_event_file;
> 	}
>
>-	obj = container_of(uverbs_attr_get(attrs,
>-
>UVERBS_ATTR_CREATE_CQ_HANDLE)->obj_attr.uobject,

See comment below on error checking.  Does this need the error check?

>+	obj = container_of(uverbs_attr_get_uobject(attrs,
>+
>UVERBS_ATTR_CREATE_CQ_HANDLE),
> 			   typeof(*obj), uobject);
> 	obj->uverbs_file	   = ucontext->ufile;
> 	obj->comp_events_reported  = 0;
>@@ -170,13 +167,17 @@ static int
>UVERBS_HANDLER(UVERBS_METHOD_CQ_DESTROY)(struct ib_device
>*ib_dev,
> 						    struct ib_uverbs_file *file,
> 						    struct uverbs_attr_bundle
>*attrs)
> {
>-	struct ib_uverbs_destroy_cq_resp resp;
> 	struct ib_uobject *uobj =
>-		uverbs_attr_get(attrs,
>UVERBS_ATTR_DESTROY_CQ_HANDLE)->obj_attr.uobject;
>-	struct ib_ucq_object *obj = container_of(uobj, struct ib_ucq_object,
>-						 uobject);
>+		uverbs_attr_get_uobject(attrs,
>UVERBS_ATTR_DESTROY_CQ_HANDLE);
>+	struct ib_uverbs_destroy_cq_resp resp;
>+	struct ib_ucq_object *obj;
> 	int ret;
>
>+	if (IS_ERR(uobj))
>+		return PTR_ERR(uobj);
>+

I remember a conversation that if an method attribute was mandatory, that you did not need to
test the uobj for error (since it was checked in the infrastructure).

Is this error check necessary?

Thanks

Mike

>+	obj = container_of(uobj, struct ib_ucq_object, uobject);
>+
> 	if (!(ib_dev->uverbs_cmd_mask & 1ULL <<
>IB_USER_VERBS_CMD_DESTROY_CQ))
> 		return -EOPNOTSUPP;
>
>diff --git a/drivers/infiniband/core/uverbs_std_types_flow_action.c
>b/drivers/infiniband/core/uverbs_std_types_flow_action.c
>index b4f016dfa23d..a7be51cf2e42 100644
>--- a/drivers/infiniband/core/uverbs_std_types_flow_action.c
>+++ b/drivers/infiniband/core/uverbs_std_types_flow_action.c
>@@ -320,7 +320,7 @@ static int
>UVERBS_HANDLER(UVERBS_METHOD_FLOW_ACTION_ESP_CREATE)(struct
>ib_device
> 		return ret;
>
> 	/* No need to check as this attribute is marked as MANDATORY */
>-	uobj = uverbs_attr_get(attrs,
>UVERBS_ATTR_FLOW_ACTION_ESP_HANDLE)->obj_attr.uobject;
>+	uobj = uverbs_attr_get_uobject(attrs,
>UVERBS_ATTR_FLOW_ACTION_ESP_HANDLE);
> 	action = ib_dev->create_flow_action_esp(ib_dev, &esp_attr.hdr,
>attrs);
> 	if (IS_ERR(action))
> 		return PTR_ERR(action);
>@@ -350,7 +350,7 @@ static int
>UVERBS_HANDLER(UVERBS_METHOD_FLOW_ACTION_ESP_MODIFY)(struct
>ib_device
> 	if (ret)
> 		return ret;
>
>-	uobj = uverbs_attr_get(attrs,
>UVERBS_ATTR_FLOW_ACTION_ESP_HANDLE)->obj_attr.uobject;
>+	uobj = uverbs_attr_get_uobject(attrs,
>UVERBS_ATTR_FLOW_ACTION_ESP_HANDLE);
> 	action = uobj->object;
>
> 	if (action->type != IB_FLOW_ACTION_ESP)
>diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
>index 4a4201d997a7..7ac6271a5ee0 100644
>--- a/include/rdma/uverbs_ioctl.h
>+++ b/include/rdma/uverbs_ioctl.h
>@@ -420,6 +420,17 @@ static inline void *uverbs_attr_get_obj(const struct
>uverbs_attr_bundle *attrs_b
> 	return uobj->object;
> }
>
>+static inline struct ib_uobject *uverbs_attr_get_uobject(const struct
>uverbs_attr_bundle *attrs_bundle,
>+							 u16 idx)
>+{
>+	const struct uverbs_attr *attr = uverbs_attr_get(attrs_bundle, idx);
>+
>+	if (IS_ERR(attr))
>+		return ERR_CAST(attr);
>+
>+	return attr->obj_attr.uobject;
>+}
>+
> static inline int uverbs_copy_to(const struct uverbs_attr_bundle
>*attrs_bundle,
> 				 size_t idx, const void *from, size_t size)
> {
>--
>2.14.3
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
