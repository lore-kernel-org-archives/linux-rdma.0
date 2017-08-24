From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 2/3] verbs: Use util/symver.h for all symbol versioning
Date: Thu, 24 Aug 2017 16:00:28 -0600
Message-ID: <1503612029-19854-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1503612029-19854-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1503612029-19854-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This makes verbs support static libraries and disabling compat.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibverbs/compat-1_0.c | 270 ++++++++++++++++++++++--------------------------
 libibverbs/device.c     |  58 +++++------
 libibverbs/ibverbs.h    |   6 --
 libibverbs/verbs.c      | 202 +++++++++++++++++-------------------
 4 files changed, 242 insertions(+), 294 deletions(-)

diff --git a/libibverbs/compat-1_0.c b/libibverbs/compat-1_0.c
index d63bd55cc09dfc..695f89deaa9f75 100644
--- a/libibverbs/compat-1_0.c
+++ b/libibverbs/compat-1_0.c
@@ -38,6 +38,7 @@
 #include <unistd.h>
 #include <alloca.h>
 
+#include <util/symver.h>
 #include "ibverbs.h"
 
 struct ibv_pd_1_0 {
@@ -227,67 +228,9 @@ struct ibv_context_1_0 {
 typedef struct ibv_device *(*ibv_driver_init_func_1_1)(const char *uverbs_sys_path,
 						       int abi_version);
 
-/* Hack to avoid GCC's -Wmissing-prototypes and the similar error from sparse
-   with these prototypes. Symbol versionining requires the goofy names, the
-   prototype must match the version in the historical 1.0 verbs.h.
- */
-struct ibv_device_1_0 **__ibv_get_device_list_1_0(int *num);
-void __ibv_free_device_list_1_0(struct ibv_device_1_0 **list);
-const char *__ibv_get_device_name_1_0(struct ibv_device_1_0 *device);
-__be64 __ibv_get_device_guid_1_0(struct ibv_device_1_0 *device);
-struct ibv_context_1_0 *__ibv_open_device_1_0(struct ibv_device_1_0 *device);
-int __ibv_close_device_1_0(struct ibv_context_1_0 *context);
-int __ibv_get_async_event_1_0(struct ibv_context_1_0 *context,
-			      struct ibv_async_event *event);
-void __ibv_ack_async_event_1_0(struct ibv_async_event *event);
-int __ibv_query_device_1_0(struct ibv_context_1_0 *context,
-			   struct ibv_device_attr *device_attr);
-int __ibv_query_port_1_0(struct ibv_context_1_0 *context, uint8_t port_num,
-			 struct ibv_port_attr *port_attr);
-int __ibv_query_gid_1_0(struct ibv_context_1_0 *context, uint8_t port_num,
-			int index, union ibv_gid *gid);
-int __ibv_query_pkey_1_0(struct ibv_context_1_0 *context, uint8_t port_num,
-			 int index, __be16 *pkey);
-struct ibv_pd_1_0 *__ibv_alloc_pd_1_0(struct ibv_context_1_0 *context);
-int __ibv_dealloc_pd_1_0(struct ibv_pd_1_0 *pd);
-struct ibv_mr_1_0 *__ibv_reg_mr_1_0(struct ibv_pd_1_0 *pd, void *addr,
-				    size_t length, int access);
-int __ibv_dereg_mr_1_0(struct ibv_mr_1_0 *mr);
-struct ibv_cq_1_0 *__ibv_create_cq_1_0(struct ibv_context_1_0 *context, int cqe,
-				       void *cq_context,
-				       struct ibv_comp_channel *channel,
-				       int comp_vector);
-int __ibv_resize_cq_1_0(struct ibv_cq_1_0 *cq, int cqe);
-int __ibv_destroy_cq_1_0(struct ibv_cq_1_0 *cq);
-int __ibv_get_cq_event_1_0(struct ibv_comp_channel *channel,
-			   struct ibv_cq_1_0 **cq, void **cq_context);
-void __ibv_ack_cq_events_1_0(struct ibv_cq_1_0 *cq, unsigned int nevents);
-struct ibv_srq_1_0 *
-__ibv_create_srq_1_0(struct ibv_pd_1_0 *pd,
-		     struct ibv_srq_init_attr *srq_init_attr);
-int __ibv_modify_srq_1_0(struct ibv_srq_1_0 *srq, struct ibv_srq_attr *srq_attr,
-			 int srq_attr_mask);
-int __ibv_query_srq_1_0(struct ibv_srq_1_0 *srq, struct ibv_srq_attr *srq_attr);
-int __ibv_destroy_srq_1_0(struct ibv_srq_1_0 *srq);
-struct ibv_qp_1_0 *
-__ibv_create_qp_1_0(struct ibv_pd_1_0 *pd,
-		    struct ibv_qp_init_attr_1_0 *qp_init_attr);
-int __ibv_query_qp_1_0(struct ibv_qp_1_0 *qp, struct ibv_qp_attr *attr,
-		       int attr_mask, struct ibv_qp_init_attr_1_0 *init_attr);
-int __ibv_modify_qp_1_0(struct ibv_qp_1_0 *qp, struct ibv_qp_attr *attr,
-			int attr_mask);
-int __ibv_destroy_qp_1_0(struct ibv_qp_1_0 *qp);
-struct ibv_ah_1_0 *__ibv_create_ah_1_0(struct ibv_pd_1_0 *pd,
-				       struct ibv_ah_attr *attr);
-int __ibv_destroy_ah_1_0(struct ibv_ah_1_0 *ah);
-int __ibv_attach_mcast_1_0(struct ibv_qp_1_0 *qp, union ibv_gid *gid,
-			   uint16_t lid);
-int __ibv_detach_mcast_1_0(struct ibv_qp_1_0 *qp, union ibv_gid *gid,
-			   uint16_t lid);
-void __ibv_register_driver_1_1(const char *name,
-			       ibv_driver_init_func_1_1 init_func);
-
-struct ibv_device_1_0 **__ibv_get_device_list_1_0(int *num)
+COMPAT_SYMVER_FUNC(ibv_get_device_list, 1_0, "IBVERBS_1.0",
+		   struct ibv_device_1_0 **,
+		   int *num)
 {
 	struct ibv_device **real_list;
 	struct ibv_device_1_0 **l;
@@ -325,9 +268,10 @@ free_device_list:
 	ibv_free_device_list(real_list);
 	return NULL;
 }
-symver(__ibv_get_device_list_1_0, ibv_get_device_list, IBVERBS_1.0);
 
-void __ibv_free_device_list_1_0(struct ibv_device_1_0 **list)
+COMPAT_SYMVER_FUNC(ibv_free_device_list, 1_0, "IBVERBS_1.0",
+		   void,
+		   struct ibv_device_1_0 **list)
 {
 	struct ibv_device_1_0 **l = list;
 
@@ -339,19 +283,20 @@ void __ibv_free_device_list_1_0(struct ibv_device_1_0 **list)
 	ibv_free_device_list((void *) list[-1]);
 	free(list - 1);
 }
-symver(__ibv_free_device_list_1_0, ibv_free_device_list, IBVERBS_1.0);
 
-const char *__ibv_get_device_name_1_0(struct ibv_device_1_0 *device)
+COMPAT_SYMVER_FUNC(ibv_get_device_name, 1_0, "IBVERBS_1.0",
+		   const char *,
+		   struct ibv_device_1_0 *device)
 {
 	return ibv_get_device_name(device->real_device);
 }
-symver(__ibv_get_device_name_1_0, ibv_get_device_name, IBVERBS_1.0);
 
-__be64 __ibv_get_device_guid_1_0(struct ibv_device_1_0 *device)
+COMPAT_SYMVER_FUNC(ibv_get_device_guid, 1_0, "IBVERBS_1.0",
+		   __be64,
+		   struct ibv_device_1_0 *device)
 {
 	return ibv_get_device_guid(device->real_device);
 }
-symver(__ibv_get_device_guid_1_0, ibv_get_device_guid, IBVERBS_1.0);
 
 static int poll_cq_wrapper_1_0(struct ibv_cq_1_0 *cq, int num_entries,
 			       struct ibv_wc *wc)
@@ -519,7 +464,9 @@ static int post_recv_wrapper_1_0(struct ibv_qp_1_0 *qp, struct ibv_recv_wr_1_0 *
 	return ret;
 }
 
-struct ibv_context_1_0 *__ibv_open_device_1_0(struct ibv_device_1_0 *device)
+COMPAT_SYMVER_FUNC(ibv_open_device, 1_0, "IBVERBS_1.0",
+		   struct ibv_context_1_0 *,
+		   struct ibv_device_1_0 *device)
 {
 	struct ibv_context     *real_ctx;
 	struct ibv_context_1_0 *ctx;
@@ -545,9 +492,10 @@ struct ibv_context_1_0 *__ibv_open_device_1_0(struct ibv_device_1_0 *device)
 
 	return ctx;
 }
-symver(__ibv_open_device_1_0, ibv_open_device, IBVERBS_1.0);
 
-int __ibv_close_device_1_0(struct ibv_context_1_0 *context)
+COMPAT_SYMVER_FUNC(ibv_close_device, 1_0, "IBVERBS_1.0",
+		   int,
+		   struct ibv_context_1_0 *context)
 {
 	int ret;
 
@@ -558,10 +506,11 @@ int __ibv_close_device_1_0(struct ibv_context_1_0 *context)
 	free(context);
 	return 0;
 }
-symver(__ibv_close_device_1_0, ibv_close_device, IBVERBS_1.0);
 
-int __ibv_get_async_event_1_0(struct ibv_context_1_0 *context,
-			      struct ibv_async_event *event)
+COMPAT_SYMVER_FUNC(ibv_get_async_event, 1_0, "IBVERBS_1.0",
+		   int,
+		   struct ibv_context_1_0 *context,
+		   struct ibv_async_event *event)
 {
 	int ret;
 
@@ -596,9 +545,10 @@ int __ibv_get_async_event_1_0(struct ibv_context_1_0 *context,
 
 	return ret;
 }
-symver(__ibv_get_async_event_1_0, ibv_get_async_event, IBVERBS_1.0);
 
-void __ibv_ack_async_event_1_0(struct ibv_async_event *event)
+COMPAT_SYMVER_FUNC(ibv_ack_async_event, 1_0, "IBVERBS_1.0",
+		   void,
+		   struct ibv_async_event *event)
 {
 	struct ibv_async_event real_event = *event;
 
@@ -632,37 +582,45 @@ void __ibv_ack_async_event_1_0(struct ibv_async_event *event)
 
 	ibv_ack_async_event(&real_event);
 }
-symver(__ibv_ack_async_event_1_0, ibv_ack_async_event, IBVERBS_1.0);
 
-int __ibv_query_device_1_0(struct ibv_context_1_0 *context,
-			   struct ibv_device_attr *device_attr)
+COMPAT_SYMVER_FUNC(ibv_query_device, 1_0, "IBVERBS_1.0",
+		   int,
+		   struct ibv_context_1_0 *context,
+		   struct ibv_device_attr *device_attr)
 {
 	return ibv_query_device(context->real_context, device_attr);
 }
-symver(__ibv_query_device_1_0, ibv_query_device, IBVERBS_1.0);
 
-int __ibv_query_port_1_0(struct ibv_context_1_0 *context, uint8_t port_num,
-			 struct ibv_port_attr *port_attr)
+COMPAT_SYMVER_FUNC(ibv_query_port, 1_0, "IBVERBS_1.0",
+		   int,
+		   struct ibv_context_1_0 *context,
+		   uint8_t port_num,
+		   struct ibv_port_attr *port_attr)
 {
 	return ibv_query_port(context->real_context, port_num, port_attr);
 }
-symver(__ibv_query_port_1_0, ibv_query_port, IBVERBS_1.0);
 
-int __ibv_query_gid_1_0(struct ibv_context_1_0 *context, uint8_t port_num,
-			int index, union ibv_gid *gid)
+COMPAT_SYMVER_FUNC(ibv_query_gid, 1_0, "IBVERBS_1.0",
+		   int,
+		   struct ibv_context_1_0 *context,
+		   uint8_t port_num, int index,
+		   union ibv_gid *gid)
 {
 	return ibv_query_gid(context->real_context, port_num, index, gid);
 }
-symver(__ibv_query_gid_1_0, ibv_query_gid, IBVERBS_1.0);
 
-int __ibv_query_pkey_1_0(struct ibv_context_1_0 *context, uint8_t port_num,
-			 int index, __be16 *pkey)
+COMPAT_SYMVER_FUNC(ibv_query_pkey, 1_0, "IBVERBS_1.0",
+		   int,
+		   struct ibv_context_1_0 *context,
+		   uint8_t port_num, int index,
+		   __be16 *pkey)
 {
 	return ibv_query_pkey(context->real_context, port_num, index, pkey);
 }
-symver(__ibv_query_pkey_1_0, ibv_query_pkey, IBVERBS_1.0);
 
-struct ibv_pd_1_0 *__ibv_alloc_pd_1_0(struct ibv_context_1_0 *context)
+COMPAT_SYMVER_FUNC(ibv_alloc_pd, 1_0, "IBVERBS_1.0",
+		   struct ibv_pd_1_0 *,
+		   struct ibv_context_1_0 *context)
 {
 	struct ibv_pd *real_pd;
 	struct ibv_pd_1_0 *pd;
@@ -682,9 +640,10 @@ struct ibv_pd_1_0 *__ibv_alloc_pd_1_0(struct ibv_context_1_0 *context)
 
 	return pd;
 }
-symver(__ibv_alloc_pd_1_0, ibv_alloc_pd, IBVERBS_1.0);
 
-int __ibv_dealloc_pd_1_0(struct ibv_pd_1_0 *pd)
+COMPAT_SYMVER_FUNC(ibv_dealloc_pd, 1_0, "IBVERBS_1.0",
+		   int,
+		   struct ibv_pd_1_0 *pd)
 {
 	int ret;
 
@@ -695,10 +654,11 @@ int __ibv_dealloc_pd_1_0(struct ibv_pd_1_0 *pd)
 	free(pd);
 	return 0;
 }
-symver(__ibv_dealloc_pd_1_0, ibv_dealloc_pd, IBVERBS_1.0);
 
-struct ibv_mr_1_0 *__ibv_reg_mr_1_0(struct ibv_pd_1_0 *pd, void *addr,
-				    size_t length, int access)
+COMPAT_SYMVER_FUNC(ibv_reg_mr, 1_0, "IBVERBS_1.0",
+		   struct ibv_mr_1_0 *,
+		   struct ibv_pd_1_0 *pd, void *addr, size_t length,
+		   int access)
 {
 	struct ibv_mr *real_mr;
 	struct ibv_mr_1_0 *mr;
@@ -721,9 +681,10 @@ struct ibv_mr_1_0 *__ibv_reg_mr_1_0(struct ibv_pd_1_0 *pd, void *addr,
 
 	return mr;
 }
-symver(__ibv_reg_mr_1_0, ibv_reg_mr, IBVERBS_1.0);
 
-int __ibv_dereg_mr_1_0(struct ibv_mr_1_0 *mr)
+COMPAT_SYMVER_FUNC(ibv_dereg_mr, 1_0, "IBVERBS_1.0",
+		   int,
+		   struct ibv_mr_1_0 *mr)
 {
 	int ret;
 
@@ -734,12 +695,11 @@ int __ibv_dereg_mr_1_0(struct ibv_mr_1_0 *mr)
 	free(mr);
 	return 0;
 }
-symver(__ibv_dereg_mr_1_0, ibv_dereg_mr, IBVERBS_1.0);
 
-struct ibv_cq_1_0 *__ibv_create_cq_1_0(struct ibv_context_1_0 *context, int cqe,
-				       void *cq_context,
-				       struct ibv_comp_channel *channel,
-				       int comp_vector)
+COMPAT_SYMVER_FUNC(ibv_create_cq, 1_0, "IBVERBS_1.0",
+		   struct ibv_cq_1_0 *,
+		   struct ibv_context_1_0 *context, int cqe, void *cq_context,
+		   struct ibv_comp_channel *channel, int comp_vector)
 {
 	struct ibv_cq *real_cq;
 	struct ibv_cq_1_0 *cq;
@@ -764,15 +724,17 @@ struct ibv_cq_1_0 *__ibv_create_cq_1_0(struct ibv_context_1_0 *context, int cqe,
 
 	return cq;
 }
-symver(__ibv_create_cq_1_0, ibv_create_cq, IBVERBS_1.0);
 
-int __ibv_resize_cq_1_0(struct ibv_cq_1_0 *cq, int cqe)
+COMPAT_SYMVER_FUNC(ibv_resize_cq, 1_0, "IBVERBS_1.0",
+		   int,
+		   struct ibv_cq_1_0 *cq, int cqe)
 {
 	return ibv_resize_cq(cq->real_cq, cqe);
 }
-symver(__ibv_resize_cq_1_0, ibv_resize_cq, IBVERBS_1.0);
 
-int __ibv_destroy_cq_1_0(struct ibv_cq_1_0 *cq)
+COMPAT_SYMVER_FUNC(ibv_destroy_cq, 1_0, "IBVERBS_1.0",
+		   int,
+		   struct ibv_cq_1_0 *cq)
 {
 	int ret;
 
@@ -783,10 +745,12 @@ int __ibv_destroy_cq_1_0(struct ibv_cq_1_0 *cq)
 	free(cq);
 	return 0;
 }
-symver(__ibv_destroy_cq_1_0, ibv_destroy_cq, IBVERBS_1.0);
 
-int __ibv_get_cq_event_1_0(struct ibv_comp_channel *channel,
-			   struct ibv_cq_1_0 **cq, void **cq_context)
+COMPAT_SYMVER_FUNC(ibv_get_cq_event, 1_0, "IBVERBS_1.0",
+		   int,
+		   struct ibv_comp_channel *channel,
+		   struct ibv_cq_1_0 **cq,
+		   void **cq_context)
 {
 	struct ibv_cq *real_cq;
 	void *cq_ptr;
@@ -801,16 +765,19 @@ int __ibv_get_cq_event_1_0(struct ibv_comp_channel *channel,
 
 	return 0;
 }
-symver(__ibv_get_cq_event_1_0, ibv_get_cq_event, IBVERBS_1.0);
 
-void __ibv_ack_cq_events_1_0(struct ibv_cq_1_0 *cq, unsigned int nevents)
+COMPAT_SYMVER_FUNC(ibv_ack_cq_events, 1_0, "IBVERBS_1.0",
+		   void,
+		   struct ibv_cq_1_0 *cq,
+		   unsigned int nevents)
 {
 	ibv_ack_cq_events(cq->real_cq, nevents);
 }
-symver(__ibv_ack_cq_events_1_0, ibv_ack_cq_events, IBVERBS_1.0);
 
-struct ibv_srq_1_0 *__ibv_create_srq_1_0(struct ibv_pd_1_0 *pd,
-					 struct ibv_srq_init_attr *srq_init_attr)
+COMPAT_SYMVER_FUNC(ibv_create_srq, 1_0, "IBVERBS_1.0",
+		   struct ibv_srq_1_0 *,
+		   struct ibv_pd_1_0 *pd,
+		   struct ibv_srq_init_attr *srq_init_attr)
 {
 	struct ibv_srq *real_srq;
 	struct ibv_srq_1_0 *srq;
@@ -834,23 +801,27 @@ struct ibv_srq_1_0 *__ibv_create_srq_1_0(struct ibv_pd_1_0 *pd,
 
 	return srq;
 }
-symver(__ibv_create_srq_1_0, ibv_create_srq, IBVERBS_1.0);
 
-int __ibv_modify_srq_1_0(struct ibv_srq_1_0 *srq,
-			 struct ibv_srq_attr *srq_attr,
-			 int srq_attr_mask)
+COMPAT_SYMVER_FUNC(ibv_modify_srq, 1_0, "IBVERBS_1.0",
+		   int,
+		   struct ibv_srq_1_0 *srq,
+		   struct ibv_srq_attr *srq_attr,
+		   int srq_attr_mask)
 {
 	return ibv_modify_srq(srq->real_srq, srq_attr, srq_attr_mask);
 }
-symver(__ibv_modify_srq_1_0, ibv_modify_srq, IBVERBS_1.0);
 
-int __ibv_query_srq_1_0(struct ibv_srq_1_0 *srq, struct ibv_srq_attr *srq_attr)
+COMPAT_SYMVER_FUNC(ibv_query_srq, 1_0, "IBVERBS_1.0",
+		   int,
+		   struct ibv_srq_1_0 *srq,
+		   struct ibv_srq_attr *srq_attr)
 {
 	return ibv_query_srq(srq->real_srq, srq_attr);
 }
-symver(__ibv_query_srq_1_0, ibv_query_srq, IBVERBS_1.0);
 
-int __ibv_destroy_srq_1_0(struct ibv_srq_1_0 *srq)
+COMPAT_SYMVER_FUNC(ibv_destroy_srq, 1_0, "IBVERBS_1.0",
+		   int,
+		   struct ibv_srq_1_0 *srq)
 {
 	int ret;
 
@@ -861,10 +832,11 @@ int __ibv_destroy_srq_1_0(struct ibv_srq_1_0 *srq)
 	free(srq);
 	return 0;
 }
-symver(__ibv_destroy_srq_1_0, ibv_destroy_srq, IBVERBS_1.0);
 
-struct ibv_qp_1_0 *__ibv_create_qp_1_0(struct ibv_pd_1_0 *pd,
-				       struct ibv_qp_init_attr_1_0 *qp_init_attr)
+COMPAT_SYMVER_FUNC(ibv_create_qp, 1_0, "IBVERBS_1.0",
+		   struct ibv_qp_1_0 *,
+		   struct ibv_pd_1_0 *pd,
+		   struct ibv_qp_init_attr_1_0 *qp_init_attr)
 {
 	struct ibv_qp *real_qp;
 	struct ibv_qp_1_0 *qp;
@@ -905,11 +877,11 @@ struct ibv_qp_1_0 *__ibv_create_qp_1_0(struct ibv_pd_1_0 *pd,
 
 	return qp;
 }
-symver(__ibv_create_qp_1_0, ibv_create_qp, IBVERBS_1.0);
 
-int __ibv_query_qp_1_0(struct ibv_qp_1_0 *qp, struct ibv_qp_attr *attr,
-		       int attr_mask,
-		       struct ibv_qp_init_attr_1_0 *init_attr)
+COMPAT_SYMVER_FUNC(ibv_query_qp, 1_0, "IBVERBS_1.0",
+		   int,
+		   struct ibv_qp_1_0 *qp, struct ibv_qp_attr *attr,
+		   int attr_mask, struct ibv_qp_init_attr_1_0 *init_attr)
 {
 	struct ibv_qp_init_attr real_init_attr;
 	int ret;
@@ -928,16 +900,19 @@ int __ibv_query_qp_1_0(struct ibv_qp_1_0 *qp, struct ibv_qp_attr *attr,
 
 	return 0;
 }
-symver(__ibv_query_qp_1_0, ibv_query_qp, IBVERBS_1.0);
 
-int __ibv_modify_qp_1_0(struct ibv_qp_1_0 *qp, struct ibv_qp_attr *attr,
-			int attr_mask)
+COMPAT_SYMVER_FUNC(ibv_modify_qp, 1_0, "IBVERBS_1.0",
+		   int,
+		   struct ibv_qp_1_0 *qp,
+		   struct ibv_qp_attr *attr,
+		   int attr_mask)
 {
 	return ibv_modify_qp(qp->real_qp, attr, attr_mask);
 }
-symver(__ibv_modify_qp_1_0, ibv_modify_qp, IBVERBS_1.0);
 
-int __ibv_destroy_qp_1_0(struct ibv_qp_1_0 *qp)
+COMPAT_SYMVER_FUNC(ibv_destroy_qp, 1_0, "IBVERBS_1.0",
+		   int,
+		   struct ibv_qp_1_0 *qp)
 {
 	int ret;
 
@@ -948,10 +923,10 @@ int __ibv_destroy_qp_1_0(struct ibv_qp_1_0 *qp)
 	free(qp);
 	return 0;
 }
-symver(__ibv_destroy_qp_1_0, ibv_destroy_qp, IBVERBS_1.0);
 
-struct ibv_ah_1_0 *__ibv_create_ah_1_0(struct ibv_pd_1_0 *pd,
-				       struct ibv_ah_attr *attr)
+COMPAT_SYMVER_FUNC(ibv_create_ah, 1_0, "IBVERBS_1.0",
+		   struct ibv_ah_1_0 *,
+		   struct ibv_pd_1_0 *pd, struct ibv_ah_attr *attr)
 {
 	struct ibv_ah *real_ah;
 	struct ibv_ah_1_0 *ah;
@@ -972,9 +947,10 @@ struct ibv_ah_1_0 *__ibv_create_ah_1_0(struct ibv_pd_1_0 *pd,
 
 	return ah;
 }
-symver(__ibv_create_ah_1_0, ibv_create_ah, IBVERBS_1.0);
 
-int __ibv_destroy_ah_1_0(struct ibv_ah_1_0 *ah)
+COMPAT_SYMVER_FUNC(ibv_destroy_ah, 1_0, "IBVERBS_1.0",
+		   int,
+		   struct ibv_ah_1_0 *ah)
 {
 	int ret;
 
@@ -985,25 +961,27 @@ int __ibv_destroy_ah_1_0(struct ibv_ah_1_0 *ah)
 	free(ah);
 	return 0;
 }
-symver(__ibv_destroy_ah_1_0, ibv_destroy_ah, IBVERBS_1.0);
 
-int __ibv_attach_mcast_1_0(struct ibv_qp_1_0 *qp, union ibv_gid *gid, uint16_t lid)
+COMPAT_SYMVER_FUNC(ibv_attach_mcast, 1_0, "IBVERBS_1.0",
+		   int,
+		   struct ibv_qp_1_0 *qp, union ibv_gid *gid, uint16_t lid)
 {
 	return ibv_attach_mcast(qp->real_qp, gid, lid);
 }
-symver(__ibv_attach_mcast_1_0, ibv_attach_mcast, IBVERBS_1.0);
 
-int __ibv_detach_mcast_1_0(struct ibv_qp_1_0 *qp, union ibv_gid *gid, uint16_t lid)
+COMPAT_SYMVER_FUNC(ibv_detach_mcast, 1_0, "IBVERBS_1.0",
+		   int,
+		   struct ibv_qp_1_0 *qp, union ibv_gid *gid, uint16_t lid)
 {
 	return ibv_detach_mcast(qp->real_qp, gid, lid);
 }
-symver(__ibv_detach_mcast_1_0, ibv_detach_mcast, IBVERBS_1.0);
 
-void __ibv_register_driver_1_1(const char *name, ibv_driver_init_func_1_1 init_func)
+COMPAT_SYMVER_FUNC(ibv_register_driver, 1_1, "IBVERBS_1.1",
+		   void,
+		   const char *name, ibv_driver_init_func_1_1 init_func)
 {
 	/* The driver interface is private as of rdma-core 13. This stub is
 	 * left to preserve dynamic-link compatibility with old libfabrics
 	 * usnic providers which use this function only to suppress a fprintf
 	 * in old versions of libibverbs. */
 }
-symver(__ibv_register_driver_1_1, ibv_register_driver, IBVERBS_1.1);
diff --git a/libibverbs/device.c b/libibverbs/device.c
index ac04bb32425d2b..16a7d4caeac5a0 100644
--- a/libibverbs/device.c
+++ b/libibverbs/device.c
@@ -43,28 +43,16 @@
 #include <alloca.h>
 #include <errno.h>
 
+#include <util/symver.h>
 #include "ibverbs.h"
 
-/* Hack to avoid GCC's -Wmissing-prototypes and the similar error from sparse
-   with these prototypes. Symbol versionining requires the goofy names, the
-   prototype must match the version in verbs.h.
- */
-struct ibv_device **__ibv_get_device_list(int *num_devices);
-void __ibv_free_device_list(struct ibv_device **list);
-const char *__ibv_get_device_name(struct ibv_device *device);
-__be64 __ibv_get_device_guid(struct ibv_device *device);
-struct ibv_context *__ibv_open_device(struct ibv_device *device);
-int __ibv_close_device(struct ibv_context *context);
-int __ibv_get_async_event(struct ibv_context *context,
-			  struct ibv_async_event *event);
-void __ibv_ack_async_event(struct ibv_async_event *event);
-
 static pthread_mutex_t dev_list_lock = PTHREAD_MUTEX_INITIALIZER;
 static int initialized;
 static struct list_head device_list = LIST_HEAD_INIT(device_list);
 
-
-struct ibv_device **__ibv_get_device_list(int *num)
+LATEST_SYMVER_FUNC(ibv_get_device_list, 1_1, "IBVERBS_1.1",
+		   struct ibv_device **,
+		   int *num)
 {
 	struct ibv_device **l = NULL;
 	struct verbs_device *device;
@@ -108,9 +96,10 @@ out:
 	pthread_mutex_unlock(&dev_list_lock);
 	return l;
 }
-default_symver(__ibv_get_device_list, ibv_get_device_list);
 
-void __ibv_free_device_list(struct ibv_device **list)
+LATEST_SYMVER_FUNC(ibv_free_device_list, 1_1, "IBVERBS_1.1",
+		   void,
+		   struct ibv_device **list)
 {
 	int i;
 
@@ -118,15 +107,17 @@ void __ibv_free_device_list(struct ibv_device **list)
 		ibverbs_device_put(list[i]);
 	free(list);
 }
-default_symver(__ibv_free_device_list, ibv_free_device_list);
 
-const char *__ibv_get_device_name(struct ibv_device *device)
+LATEST_SYMVER_FUNC(ibv_get_device_name, 1_1, "IBVERBS_1.1",
+		   const char *,
+		   struct ibv_device *device)
 {
 	return device->name;
 }
-default_symver(__ibv_get_device_name, ibv_get_device_name);
 
-__be64 __ibv_get_device_guid(struct ibv_device *device)
+LATEST_SYMVER_FUNC(ibv_get_device_guid, 1_1, "IBVERBS_1.1",
+		   __be64,
+		   struct ibv_device *device)
 {
 	char attr[24];
 	uint64_t guid = 0;
@@ -146,7 +137,6 @@ __be64 __ibv_get_device_guid(struct ibv_device *device)
 
 	return htobe64(guid);
 }
-default_symver(__ibv_get_device_guid, ibv_get_device_guid);
 
 void verbs_init_cq(struct ibv_cq *cq, struct ibv_context *context,
 		       struct ibv_comp_channel *channel,
@@ -189,7 +179,9 @@ __lib_ibv_create_cq_ex(struct ibv_context *context,
 	return cq;
 }
 
-struct ibv_context *__ibv_open_device(struct ibv_device *device)
+LATEST_SYMVER_FUNC(ibv_open_device, 1_1, "IBVERBS_1.1",
+		   struct ibv_context *,
+		   struct ibv_device *device)
 {
 	struct verbs_device *verbs_device = verbs_get_device(device);
 	char *devpath;
@@ -276,9 +268,10 @@ err:
 	close(cmd_fd);
 	return NULL;
 }
-default_symver(__ibv_open_device, ibv_open_device);
 
-int __ibv_close_device(struct ibv_context *context)
+LATEST_SYMVER_FUNC(ibv_close_device, 1_1, "IBVERBS_1.1",
+		   int,
+		   struct ibv_context *context)
 {
 	int async_fd = context->async_fd;
 	int cmd_fd   = context->cmd_fd;
@@ -304,10 +297,11 @@ int __ibv_close_device(struct ibv_context *context)
 
 	return 0;
 }
-default_symver(__ibv_close_device, ibv_close_device);
 
-int __ibv_get_async_event(struct ibv_context *context,
-			  struct ibv_async_event *event)
+LATEST_SYMVER_FUNC(ibv_get_async_event, 1_1, "IBVERBS_1.1",
+		   int,
+		   struct ibv_context *context,
+		   struct ibv_async_event *event)
 {
 	struct ibv_kern_async_event ev;
 
@@ -350,9 +344,10 @@ int __ibv_get_async_event(struct ibv_context *context,
 
 	return 0;
 }
-default_symver(__ibv_get_async_event, ibv_get_async_event);
 
-void __ibv_ack_async_event(struct ibv_async_event *event)
+LATEST_SYMVER_FUNC(ibv_ack_async_event, 1_1, "IBVERBS_1.1",
+		   void,
+		   struct ibv_async_event *event)
 {
 	switch (event->event_type) {
 	case IBV_EVENT_CQ_ERR:
@@ -415,4 +410,3 @@ void __ibv_ack_async_event(struct ibv_async_event *event)
 		return;
 	}
 }
-default_symver(__ibv_ack_async_event, ibv_ack_async_event);
diff --git a/libibverbs/ibverbs.h b/libibverbs/ibverbs.h
index c8e993c314876a..74f2ab81f5a95c 100644
--- a/libibverbs/ibverbs.h
+++ b/libibverbs/ibverbs.h
@@ -42,12 +42,6 @@
 
 #define INIT		__attribute__((constructor))
 
-#define DEFAULT_ABI	"IBVERBS_1.1"
-
-#define symver(name, api, ver) asm(".symver " #name "," #api "@" #ver)
-#define default_symver(name, api)                                              \
-	asm(".symver " #name "," #api "@@" DEFAULT_ABI)
-
 #define PFX		"libibverbs: "
 
 struct ibv_abi_compat_v2 {
diff --git a/libibverbs/verbs.c b/libibverbs/verbs.c
index e54fd7746888aa..65d9c1c8ca2fc4 100644
--- a/libibverbs/verbs.c
+++ b/libibverbs/verbs.c
@@ -45,6 +45,7 @@
 #include <netinet/in.h>
 
 #include <util/compiler.h>
+#include <util/symver.h>
 
 #include "ibverbs.h"
 #ifndef NRESOLVE_NEIGH
@@ -53,52 +54,7 @@
 #include "neigh.h"
 #endif
 
-/* Hack to avoid GCC's -Wmissing-prototypes and the similar error from sparse
-   with these prototypes. Symbol versionining requires the goofy names, the
-   prototype must match the version in verbs.h.
- */
-int __ibv_query_device(struct ibv_context *context,
-		       struct ibv_device_attr *device_attr);
-int __ibv_query_port(struct ibv_context *context, uint8_t port_num,
-		     struct ibv_port_attr *port_attr);
-int __ibv_query_gid(struct ibv_context *context, uint8_t port_num, int index,
-		    union ibv_gid *gid);
-int __ibv_query_pkey(struct ibv_context *context, uint8_t port_num, int index,
-		     __be16 *pkey);
-struct ibv_pd *__ibv_alloc_pd(struct ibv_context *context);
-int __ibv_dealloc_pd(struct ibv_pd *pd);
-struct ibv_mr *__ibv_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
-			    int access);
-int __ibv_rereg_mr(struct ibv_mr *mr, int flags, struct ibv_pd *pd, void *addr,
-		   size_t length, int access);
-int __ibv_dereg_mr(struct ibv_mr *mr);
-struct ibv_cq *__ibv_create_cq(struct ibv_context *context, int cqe,
-			       void *cq_context,
-			       struct ibv_comp_channel *channel,
-			       int comp_vector);
-int __ibv_resize_cq(struct ibv_cq *cq, int cqe);
-int __ibv_destroy_cq(struct ibv_cq *cq);
-int __ibv_get_cq_event(struct ibv_comp_channel *channel, struct ibv_cq **cq,
-		       void **cq_context);
-void __ibv_ack_cq_events(struct ibv_cq *cq, unsigned int nevents);
-struct ibv_srq *__ibv_create_srq(struct ibv_pd *pd,
-				 struct ibv_srq_init_attr *srq_init_attr);
-int __ibv_modify_srq(struct ibv_srq *srq, struct ibv_srq_attr *srq_attr,
-		     int srq_attr_mask);
-int __ibv_query_srq(struct ibv_srq *srq, struct ibv_srq_attr *srq_attr);
-int __ibv_destroy_srq(struct ibv_srq *srq);
-struct ibv_qp *__ibv_create_qp(struct ibv_pd *pd,
-			       struct ibv_qp_init_attr *qp_init_attr);
-int __ibv_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr, int attr_mask,
-		   struct ibv_qp_init_attr *init_attr);
-int __ibv_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr, int attr_mask);
-int __ibv_destroy_qp(struct ibv_qp *qp);
-struct ibv_ah *__ibv_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr);
-int __ibv_destroy_ah(struct ibv_ah *ah);
-int __ibv_attach_mcast(struct ibv_qp *qp, const union ibv_gid *gid,
-		       uint16_t lid);
-int __ibv_detach_mcast(struct ibv_qp *qp, const union ibv_gid *gid,
-		       uint16_t lid);
+#undef ibv_query_port
 
 int __attribute__((const)) ibv_rate_to_mult(enum ibv_rate rate)
 {
@@ -180,22 +136,26 @@ enum ibv_rate __attribute__((const)) mbps_to_ibv_rate(int mbps)
 	}
 }
 
-int __ibv_query_device(struct ibv_context *context,
-		       struct ibv_device_attr *device_attr)
+LATEST_SYMVER_FUNC(ibv_query_device, 1_1, "IBVERBS_1.1",
+		   int,
+		   struct ibv_context *context,
+		   struct ibv_device_attr *device_attr)
 {
 	return context->ops.query_device(context, device_attr);
 }
-default_symver(__ibv_query_device, ibv_query_device);
 
-int __ibv_query_port(struct ibv_context *context, uint8_t port_num,
-		     struct ibv_port_attr *port_attr)
+LATEST_SYMVER_FUNC(ibv_query_port, 1_1, "IBVERBS_1.1",
+		   int,
+		   struct ibv_context *context, uint8_t port_num,
+		   struct ibv_port_attr *port_attr)
 {
 	return context->ops.query_port(context, port_num, port_attr);
 }
-default_symver(__ibv_query_port, ibv_query_port);
 
-int __ibv_query_gid(struct ibv_context *context, uint8_t port_num,
-		    int index, union ibv_gid *gid)
+LATEST_SYMVER_FUNC(ibv_query_gid, 1_1, "IBVERBS_1.1",
+		   int,
+		   struct ibv_context *context, uint8_t port_num,
+		   int index, union ibv_gid *gid)
 {
 	char name[24];
 	char attr[41];
@@ -217,10 +177,11 @@ int __ibv_query_gid(struct ibv_context *context, uint8_t port_num,
 
 	return 0;
 }
-default_symver(__ibv_query_gid, ibv_query_gid);
 
-int __ibv_query_pkey(struct ibv_context *context, uint8_t port_num,
-		     int index, __be16 *pkey)
+LATEST_SYMVER_FUNC(ibv_query_pkey, 1_1, "IBVERBS_1.1",
+		   int,
+		   struct ibv_context *context, uint8_t port_num,
+		   int index, __be16 *pkey)
 {
 	char name[24];
 	char attr[8];
@@ -238,9 +199,10 @@ int __ibv_query_pkey(struct ibv_context *context, uint8_t port_num,
 	*pkey = htobe16(val);
 	return 0;
 }
-default_symver(__ibv_query_pkey, ibv_query_pkey);
 
-struct ibv_pd *__ibv_alloc_pd(struct ibv_context *context)
+LATEST_SYMVER_FUNC(ibv_alloc_pd, 1_1, "IBVERBS_1.1",
+		   struct ibv_pd *,
+		   struct ibv_context *context)
 {
 	struct ibv_pd *pd;
 
@@ -250,16 +212,18 @@ struct ibv_pd *__ibv_alloc_pd(struct ibv_context *context)
 
 	return pd;
 }
-default_symver(__ibv_alloc_pd, ibv_alloc_pd);
 
-int __ibv_dealloc_pd(struct ibv_pd *pd)
+LATEST_SYMVER_FUNC(ibv_dealloc_pd, 1_1, "IBVERBS_1.1",
+		   int,
+		   struct ibv_pd *pd)
 {
 	return pd->context->ops.dealloc_pd(pd);
 }
-default_symver(__ibv_dealloc_pd, ibv_dealloc_pd);
 
-struct ibv_mr *__ibv_reg_mr(struct ibv_pd *pd, void *addr,
-			    size_t length, int access)
+LATEST_SYMVER_FUNC(ibv_reg_mr, 1_1, "IBVERBS_1.1",
+		   struct ibv_mr *,
+		   struct ibv_pd *pd, void *addr,
+		   size_t length, int access)
 {
 	struct ibv_mr *mr;
 
@@ -277,9 +241,10 @@ struct ibv_mr *__ibv_reg_mr(struct ibv_pd *pd, void *addr,
 
 	return mr;
 }
-default_symver(__ibv_reg_mr, ibv_reg_mr);
 
-int __ibv_rereg_mr(struct ibv_mr *mr, int flags,
+LATEST_SYMVER_FUNC(ibv_rereg_mr, 1_1, "IBVERBS_1.1",
+		   int,
+		   struct ibv_mr *mr, int flags,
 		   struct ibv_pd *pd, void *addr,
 		   size_t length, int access)
 {
@@ -339,9 +304,10 @@ int __ibv_rereg_mr(struct ibv_mr *mr, int flags,
 
 	return err;
 }
-default_symver(__ibv_rereg_mr, ibv_rereg_mr);
 
-int __ibv_dereg_mr(struct ibv_mr *mr)
+LATEST_SYMVER_FUNC(ibv_dereg_mr, 1_1, "IBVERBS_1.1",
+		   int,
+		   struct ibv_mr *mr)
 {
 	int ret;
 	void *addr	= mr->addr;
@@ -353,7 +319,6 @@ int __ibv_dereg_mr(struct ibv_mr *mr)
 
 	return ret;
 }
-default_symver(__ibv_dereg_mr, ibv_dereg_mr);
 
 static struct ibv_comp_channel *ibv_create_comp_channel_v2(struct ibv_context *context)
 {
@@ -436,8 +401,10 @@ out:
 	return ret;
 }
 
-struct ibv_cq *__ibv_create_cq(struct ibv_context *context, int cqe, void *cq_context,
-			       struct ibv_comp_channel *channel, int comp_vector)
+LATEST_SYMVER_FUNC(ibv_create_cq, 1_1, "IBVERBS_1.1",
+		   struct ibv_cq *,
+		   struct ibv_context *context, int cqe, void *cq_context,
+		   struct ibv_comp_channel *channel, int comp_vector)
 {
 	struct ibv_cq *cq;
 
@@ -448,18 +415,20 @@ struct ibv_cq *__ibv_create_cq(struct ibv_context *context, int cqe, void *cq_co
 
 	return cq;
 }
-default_symver(__ibv_create_cq, ibv_create_cq);
 
-int __ibv_resize_cq(struct ibv_cq *cq, int cqe)
+LATEST_SYMVER_FUNC(ibv_resize_cq, 1_1, "IBVERBS_1.1",
+		   int,
+		   struct ibv_cq *cq, int cqe)
 {
 	if (!cq->context->ops.resize_cq)
 		return ENOSYS;
 
 	return cq->context->ops.resize_cq(cq, cqe);
 }
-default_symver(__ibv_resize_cq, ibv_resize_cq);
 
-int __ibv_destroy_cq(struct ibv_cq *cq)
+LATEST_SYMVER_FUNC(ibv_destroy_cq, 1_1, "IBVERBS_1.1",
+		   int,
+		   struct ibv_cq *cq)
 {
 	struct ibv_comp_channel *channel = cq->channel;
 	int ret;
@@ -476,10 +445,11 @@ int __ibv_destroy_cq(struct ibv_cq *cq)
 
 	return ret;
 }
-default_symver(__ibv_destroy_cq, ibv_destroy_cq);
 
-int __ibv_get_cq_event(struct ibv_comp_channel *channel,
-		       struct ibv_cq **cq, void **cq_context)
+LATEST_SYMVER_FUNC(ibv_get_cq_event, 1_1, "IBVERBS_1.1",
+		   int,
+		   struct ibv_comp_channel *channel,
+		   struct ibv_cq **cq, void **cq_context)
 {
 	struct ibv_comp_event ev;
 
@@ -494,19 +464,21 @@ int __ibv_get_cq_event(struct ibv_comp_channel *channel,
 
 	return 0;
 }
-default_symver(__ibv_get_cq_event, ibv_get_cq_event);
 
-void __ibv_ack_cq_events(struct ibv_cq *cq, unsigned int nevents)
+LATEST_SYMVER_FUNC(ibv_ack_cq_events, 1_1, "IBVERBS_1.1",
+		   void,
+		   struct ibv_cq *cq, unsigned int nevents)
 {
 	pthread_mutex_lock(&cq->mutex);
 	cq->comp_events_completed += nevents;
 	pthread_cond_signal(&cq->cond);
 	pthread_mutex_unlock(&cq->mutex);
 }
-default_symver(__ibv_ack_cq_events, ibv_ack_cq_events);
 
-struct ibv_srq *__ibv_create_srq(struct ibv_pd *pd,
-				 struct ibv_srq_init_attr *srq_init_attr)
+LATEST_SYMVER_FUNC(ibv_create_srq, 1_1, "IBVERBS_1.1",
+		   struct ibv_srq *,
+		   struct ibv_pd *pd,
+		   struct ibv_srq_init_attr *srq_init_attr)
 {
 	struct ibv_srq *srq;
 
@@ -525,30 +497,34 @@ struct ibv_srq *__ibv_create_srq(struct ibv_pd *pd,
 
 	return srq;
 }
-default_symver(__ibv_create_srq, ibv_create_srq);
 
-int __ibv_modify_srq(struct ibv_srq *srq,
-		     struct ibv_srq_attr *srq_attr,
-		     int srq_attr_mask)
+LATEST_SYMVER_FUNC(ibv_modify_srq, 1_1, "IBVERBS_1.1",
+		   int,
+		   struct ibv_srq *srq,
+		   struct ibv_srq_attr *srq_attr,
+		   int srq_attr_mask)
 {
 	return srq->context->ops.modify_srq(srq, srq_attr, srq_attr_mask);
 }
-default_symver(__ibv_modify_srq, ibv_modify_srq);
 
-int __ibv_query_srq(struct ibv_srq *srq, struct ibv_srq_attr *srq_attr)
+LATEST_SYMVER_FUNC(ibv_query_srq, 1_1, "IBVERBS_1.1",
+		   int,
+		   struct ibv_srq *srq, struct ibv_srq_attr *srq_attr)
 {
 	return srq->context->ops.query_srq(srq, srq_attr);
 }
-default_symver(__ibv_query_srq, ibv_query_srq);
 
-int __ibv_destroy_srq(struct ibv_srq *srq)
+LATEST_SYMVER_FUNC(ibv_destroy_srq, 1_1, "IBVERBS_1.1",
+		   int,
+		   struct ibv_srq *srq)
 {
 	return srq->context->ops.destroy_srq(srq);
 }
-default_symver(__ibv_destroy_srq, ibv_destroy_srq);
 
-struct ibv_qp *__ibv_create_qp(struct ibv_pd *pd,
-			       struct ibv_qp_init_attr *qp_init_attr)
+LATEST_SYMVER_FUNC(ibv_create_qp, 1_1, "IBVERBS_1.1",
+		   struct ibv_qp *,
+		   struct ibv_pd *pd,
+		   struct ibv_qp_init_attr *qp_init_attr)
 {
 	struct ibv_qp *qp = pd->context->ops.create_qp(pd, qp_init_attr);
 
@@ -568,9 +544,10 @@ struct ibv_qp *__ibv_create_qp(struct ibv_pd *pd,
 
 	return qp;
 }
-default_symver(__ibv_create_qp, ibv_create_qp);
 
-int __ibv_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
+LATEST_SYMVER_FUNC(ibv_query_qp, 1_1, "IBVERBS_1.1",
+		   int,
+		   struct ibv_qp *qp, struct ibv_qp_attr *attr,
 		   int attr_mask,
 		   struct ibv_qp_init_attr *init_attr)
 {
@@ -585,10 +562,11 @@ int __ibv_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 
 	return 0;
 }
-default_symver(__ibv_query_qp, ibv_query_qp);
 
-int __ibv_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
-		    int attr_mask)
+LATEST_SYMVER_FUNC(ibv_modify_qp, 1_1, "IBVERBS_1.1",
+		   int,
+		   struct ibv_qp *qp, struct ibv_qp_attr *attr,
+		   int attr_mask)
 {
 	int ret;
 
@@ -601,15 +579,17 @@ int __ibv_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 
 	return 0;
 }
-default_symver(__ibv_modify_qp, ibv_modify_qp);
 
-int __ibv_destroy_qp(struct ibv_qp *qp)
+LATEST_SYMVER_FUNC(ibv_destroy_qp, 1_1, "IBVERBS_1.1",
+		   int,
+		   struct ibv_qp *qp)
 {
 	return qp->context->ops.destroy_qp(qp);
 }
-default_symver(__ibv_destroy_qp, ibv_destroy_qp);
 
-struct ibv_ah *__ibv_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
+LATEST_SYMVER_FUNC(ibv_create_ah, 1_1, "IBVERBS_1.1",
+		   struct ibv_ah *,
+		   struct ibv_pd *pd, struct ibv_ah_attr *attr)
 {
 	struct ibv_ah *ah = pd->context->ops.create_ah(pd, attr);
 
@@ -620,7 +600,6 @@ struct ibv_ah *__ibv_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 
 	return ah;
 }
-default_symver(__ibv_create_ah, ibv_create_ah);
 
 /* GID types as appear in sysfs, no change is expected as of ABI
  * compatibility.
@@ -881,23 +860,26 @@ struct ibv_ah *ibv_create_ah_from_wc(struct ibv_pd *pd, struct ibv_wc *wc,
 	return ibv_create_ah(pd, &ah_attr);
 }
 
-int __ibv_destroy_ah(struct ibv_ah *ah)
+LATEST_SYMVER_FUNC(ibv_destroy_ah, 1_1, "IBVERBS_1.1",
+		   int,
+		   struct ibv_ah *ah)
 {
 	return ah->context->ops.destroy_ah(ah);
 }
-default_symver(__ibv_destroy_ah, ibv_destroy_ah);
 
-int __ibv_attach_mcast(struct ibv_qp *qp, const union ibv_gid *gid, uint16_t lid)
+LATEST_SYMVER_FUNC(ibv_attach_mcast, 1_1, "IBVERBS_1.1",
+		   int,
+		   struct ibv_qp *qp, const union ibv_gid *gid, uint16_t lid)
 {
 	return qp->context->ops.attach_mcast(qp, gid, lid);
 }
-default_symver(__ibv_attach_mcast, ibv_attach_mcast);
 
-int __ibv_detach_mcast(struct ibv_qp *qp, const union ibv_gid *gid, uint16_t lid)
+LATEST_SYMVER_FUNC(ibv_detach_mcast, 1_1, "IBVERBS_1.1",
+		   int,
+		   struct ibv_qp *qp, const union ibv_gid *gid, uint16_t lid)
 {
 	return qp->context->ops.detach_mcast(qp, gid, lid);
 }
-default_symver(__ibv_detach_mcast, ibv_detach_mcast);
 
 static inline int ipv6_addr_v4mapped(const struct in6_addr *a)
 {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
