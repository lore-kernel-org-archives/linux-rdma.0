From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 11/13] IB/core: Add completion queue (cq) object actions
Date: Wed,  7 Jun 2017 15:22:50 +0300
Message-ID: <1496838172-39671-12-git-send-email-matanb@mellanox.com>
References: <1496838172-39671-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496838172-39671-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Adding CQ ioctl actions:
1. create_cq
2. destroy_cq

This requires adding the following:
1. A specification describing the action
	a. Handler
	b. Common attributes specification group
	c. (Optional) Driver specific specification group
2. A specification describing the attribute group.
   Each attribute is one of the following:
	a. PTR_IN - input data
		    Note: This could be encoded inlined for data < 64bit
	b. PTR_OUT - response data
	c. IDR - idr based object
	d. FD - fd based object
   Blobs attributes (clauses a and b) contain their type, while objects
   specifications (clauses c and d) contains the expected object type
   (for example, the given id should be UVERBS_TYPE_PD) and the
   required access (READ, WRITE, NEW or DESTROY). If a NEW is required,
   the new object's id will be assigned to this attribute.
   All attributes could get UA_FLAGS attribute. Currently we support
   stating that an attribute is mandatory or that the specification size
   corresponds to a lower bound (and that this attribute could be
   extended).
3. Handler
   A handler gets an array of uverbs_attr_array (meaning, array of
   arrays). Each element in uverbs_attr_array corresponds to one
   attribute group  indexed by the group number (currently,
   uverbs_attr_array[0] -> common group and
   uverbs_attr_array[1] -> driver-specific group).
   Each of these attribute groups correspond to the specification
   group defined in the action (clauses 1.b and 1.c respectively).
   The indices of these arrays corresponds to the attribute ids
   declared in the specifications (clause 2).

   The handler is quite simple. It assumes the infrastructure fetched
   all objects and locked, created or destroyed them as required by
   the specification. Pointer (or blob) attributes were validated to
   match their required sizes. After the handler finished, the
   infrastructure commits or rollbacks the objects.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_std_types.c | 145 ++++++++++++++++++++++++++++-
 include/rdma/uverbs_std_types.h            |   2 +
 include/uapi/rdma/ib_user_ioctl_verbs.h    |  20 ++++
 3 files changed, 166 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
index caf82a0..cef13b43 100644
--- a/drivers/infiniband/core/uverbs_std_types.c
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -248,6 +248,141 @@ static void create_udata(struct uverbs_attr_array *ctx, size_t num,
 	}
 	INIT_UDATA_BUF_OR_NULL(udata, inbuf, outbuf, inbuf_len, outbuf_len);
 }
+
+static DECLARE_UVERBS_ATTR_SPEC(
+	uverbs_create_cq_spec,
+	UVERBS_ATTR_IDR(CREATE_CQ_HANDLE, UVERBS_TYPE_CQ, UVERBS_ACCESS_NEW,
+			UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)),
+	UVERBS_ATTR_PTR_IN(CREATE_CQ_CQE, u32,
+			   UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)),
+	UVERBS_ATTR_PTR_IN(CREATE_CQ_USER_HANDLE, u64),
+	UVERBS_ATTR_FD(CREATE_CQ_COMP_CHANNEL, UVERBS_TYPE_COMP_CHANNEL, UVERBS_ACCESS_READ),
+	/*
+	 * Currently, COMP_VECTOR is mandatory, but that could be lifted in the
+	 * future.
+	 */
+	UVERBS_ATTR_PTR_IN(CREATE_CQ_COMP_VECTOR, u32,
+			   UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)),
+	UVERBS_ATTR_PTR_IN(CREATE_CQ_FLAGS, u32),
+	UVERBS_ATTR_PTR_OUT(CREATE_CQ_RESP_CQE, u32,
+			    UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)));
+
+static int uverbs_create_cq_handler(struct ib_device *ib_dev,
+				    struct ib_uverbs_file *file,
+				    struct uverbs_attr_array *ctx, size_t num)
+{
+	struct uverbs_attr_array *common = &ctx[0];
+	struct ib_ucontext *ucontext = file->ucontext;
+	struct ib_ucq_object           *obj;
+	struct ib_udata uhw;
+	int ret;
+	u64 user_handle = 0;
+	struct ib_cq_init_attr attr = {};
+	struct ib_cq                   *cq;
+	struct ib_uverbs_completion_event_file    *ev_file = NULL;
+
+	if (!(ib_dev->uverbs_cmd_mask & 1ULL << IB_USER_VERBS_CMD_CREATE_CQ))
+		return -EOPNOTSUPP;
+
+	ret = uverbs_copy_from(&attr.comp_vector, common, CREATE_CQ_COMP_VECTOR);
+	if (!ret)
+		ret = uverbs_copy_from(&attr.cqe, common, CREATE_CQ_CQE);
+	if (ret)
+		return ret;
+
+	/* Optional params, if they don't exist, we get -ENOENT and skip them */
+	if (uverbs_copy_from(&attr.flags, common, CREATE_CQ_FLAGS) == -EFAULT ||
+	    uverbs_copy_from(&user_handle, common, CREATE_CQ_USER_HANDLE) == -EFAULT)
+		return -EFAULT;
+
+	if (uverbs_is_valid(common, CREATE_CQ_COMP_CHANNEL)) {
+		struct ib_uobject *ev_file_uobj =
+			common->attrs[CREATE_CQ_COMP_CHANNEL].obj_attr.uobject;
+
+		ev_file = container_of(ev_file_uobj,
+				       struct ib_uverbs_completion_event_file,
+				       uobj_file.uobj);
+		uverbs_uobject_get(ev_file_uobj);
+	}
+
+	if (attr.comp_vector >= ucontext->ufile->device->num_comp_vectors) {
+		ret = -EINVAL;
+		goto err_event_file;
+	}
+
+	obj = container_of(common->attrs[CREATE_CQ_HANDLE].obj_attr.uobject,
+			   typeof(*obj), uobject);
+	obj->uverbs_file	   = ucontext->ufile;
+	obj->comp_events_reported  = 0;
+	obj->async_events_reported = 0;
+	INIT_LIST_HEAD(&obj->comp_list);
+	INIT_LIST_HEAD(&obj->async_list);
+
+	/* Temporary, only until drivers get the new uverbs_attr_array */
+	create_udata(ctx, num, &uhw);
+
+	cq = ib_dev->create_cq(ib_dev, &attr, ucontext, &uhw);
+	if (IS_ERR(cq)) {
+		ret = PTR_ERR(cq);
+		goto err_event_file;
+	}
+
+	cq->device        = ib_dev;
+	cq->uobject       = &obj->uobject;
+	cq->comp_handler  = ib_uverbs_comp_handler;
+	cq->event_handler = ib_uverbs_cq_event_handler;
+	cq->cq_context    = &ev_file->ev_queue;
+	obj->uobject.object = cq;
+	obj->uobject.user_handle = user_handle;
+	atomic_set(&cq->usecnt, 0);
+
+	ret = uverbs_copy_to(common, CREATE_CQ_RESP_CQE, &cq->cqe);
+	if (ret)
+		goto err_cq;
+
+	return 0;
+err_cq:
+	ib_destroy_cq(cq);
+
+err_event_file:
+	if (ev_file)
+		uverbs_uobject_put(&ev_file->uobj_file.uobj);
+	return ret;
+};
+
+static DECLARE_UVERBS_ATTR_SPEC(
+	uverbs_destroy_cq_spec,
+	UVERBS_ATTR_IDR(DESTROY_CQ_HANDLE, UVERBS_TYPE_CQ,
+			UVERBS_ACCESS_DESTROY,
+			UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)),
+	UVERBS_ATTR_PTR_OUT(DESTROY_CQ_RESP, struct ib_uverbs_destroy_cq_resp,
+			    UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)));
+
+static int uverbs_destroy_cq_handler(struct ib_device *ib_dev,
+				     struct ib_uverbs_file *file,
+				     struct uverbs_attr_array *ctx, size_t num)
+{
+	struct uverbs_attr_array *common = &ctx[0];
+	struct ib_uverbs_destroy_cq_resp resp;
+	struct ib_uobject *uobj =
+		common->attrs[DESTROY_CQ_HANDLE].obj_attr.uobject;
+	struct ib_ucq_object *obj = container_of(uobj, struct ib_ucq_object,
+						 uobject);
+	int ret;
+
+	if (!(ib_dev->uverbs_cmd_mask & 1ULL << IB_USER_VERBS_CMD_DESTROY_CQ))
+		return -EOPNOTSUPP;
+
+	ret = rdma_explicit_destroy(uobj);
+	if (ret)
+		return ret;
+
+	resp.comp_events_reported  = obj->comp_events_reported;
+	resp.async_events_reported = obj->async_events_reported;
+
+	return uverbs_copy_to(common, DESTROY_CQ_RESP, &resp);
+}
+
 DECLARE_UVERBS_TYPE(uverbs_type_comp_channel,
 		    &UVERBS_TYPE_ALLOC_FD(0,
 					  sizeof(struct ib_uverbs_completion_event_file),
@@ -257,7 +392,15 @@ static void create_udata(struct uverbs_attr_array *ctx, size_t num,
 
 DECLARE_UVERBS_TYPE(uverbs_type_cq,
 		    &UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_ucq_object), 0,
-					      uverbs_free_cq));
+					      uverbs_free_cq),
+		    &UVERBS_ACTIONS(
+			ADD_UVERBS_ACTION(UVERBS_CQ_CREATE,
+					  uverbs_create_cq_handler,
+					  &uverbs_create_cq_spec,
+					  &uverbs_uhw_compat_spec),
+			ADD_UVERBS_ACTION(UVERBS_CQ_DESTROY,
+					  uverbs_destroy_cq_handler,
+					  &uverbs_destroy_cq_spec)));
 
 DECLARE_UVERBS_TYPE(uverbs_type_qp,
 		    &UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uqp_object), 0,
diff --git a/include/rdma/uverbs_std_types.h b/include/rdma/uverbs_std_types.h
index c7ec8be..1f22bb2 100644
--- a/include/rdma/uverbs_std_types.h
+++ b/include/rdma/uverbs_std_types.h
@@ -36,6 +36,8 @@
 #include <rdma/uverbs_types.h>
 #include <rdma/ib_user_ioctl_verbs.h>
 
+extern const struct uverbs_action_group uverbs_actions_cq;
+
 extern const struct uverbs_type uverbs_type_comp_channel;
 extern const struct uverbs_type uverbs_type_cq;
 extern const struct uverbs_type uverbs_type_qp;
diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/ib_user_ioctl_verbs.h
index 4165738..1f00020 100644
--- a/include/uapi/rdma/ib_user_ioctl_verbs.h
+++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
@@ -60,5 +60,25 @@ enum {
 	UVERBS_UHW_OUT,
 };
 
+enum uverbs_create_cq_cmd_attr_ids {
+	CREATE_CQ_HANDLE,
+	CREATE_CQ_CQE,
+	CREATE_CQ_USER_HANDLE,
+	CREATE_CQ_COMP_CHANNEL,
+	CREATE_CQ_COMP_VECTOR,
+	CREATE_CQ_FLAGS,
+	CREATE_CQ_RESP_CQE,
+};
+
+enum uverbs_destroy_cq_cmd_attr_ids {
+	DESTROY_CQ_HANDLE,
+	DESTROY_CQ_RESP,
+};
+
+enum uverbs_actions_cq_ops {
+	UVERBS_CQ_CREATE,
+	UVERBS_CQ_DESTROY,
+};
+
 #endif
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
