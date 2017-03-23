From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 rdma-core 4/6] verbs: Expose verbs init CQ helper API
Date: Thu, 23 Mar 2017 15:55:27 +0200
Message-ID: <1490277329-8738-5-git-send-email-yishaih@mellanox.com>
References: <1490277329-8738-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490277329-8738-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch exposes to providers an helper function to init a CQ
post its creation.

The internal library code was refactored to use this helper
API to have a shared code for all creation flows (i.e. create_cq and
create_cq_ex).

As part of this refactoring reduced the scope of the lock that was taken
as part of creating/destroying a CQ to protect only what it was intended
to do. (i.e. channel->refcnt)

It's the application responsibility not to call concurrently to create a
CQ with a given completion channel and in the same time destroy it from
other thread, no change at that point from the original code.

The helper function going to be used in downstream patch in this
series.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/device.c       | 38 +++++++++++++++++++++++---------------
 libibverbs/driver.h       |  3 +++
 libibverbs/ibverbs.h      |  2 +-
 libibverbs/libibverbs.map |  3 ++-
 libibverbs/verbs.c        | 26 ++++++--------------------
 5 files changed, 35 insertions(+), 37 deletions(-)

diff --git a/libibverbs/device.c b/libibverbs/device.c
index 6ef670a..ebf4970 100644
--- a/libibverbs/device.c
+++ b/libibverbs/device.c
@@ -132,6 +132,26 @@ __be64 __ibv_get_device_guid(struct ibv_device *device)
 }
 default_symver(__ibv_get_device_guid, ibv_get_device_guid);
 
+void verbs_init_cq(struct ibv_cq *cq, struct ibv_context *context,
+		       struct ibv_comp_channel *channel,
+		       void *cq_context)
+{
+	cq->context		   = context;
+	cq->channel		   = channel;
+
+	if (cq->channel) {
+		pthread_mutex_lock(&context->mutex);
+		++cq->channel->refcnt;
+		pthread_mutex_unlock(&context->mutex);
+	}
+
+	cq->cq_context		   = cq_context;
+	cq->comp_events_completed  = 0;
+	cq->async_events_completed = 0;
+	pthread_mutex_init(&cq->mutex, NULL);
+	pthread_cond_init(&cq->cond, NULL);
+}
+
 static struct ibv_cq_ex *
 __lib_ibv_create_cq_ex(struct ibv_context *context,
 		       struct ibv_cq_init_attr_ex *cq_attr)
@@ -144,23 +164,11 @@ __lib_ibv_create_cq_ex(struct ibv_context *context,
 		return NULL;
 	}
 
-	pthread_mutex_lock(&context->mutex);
-
 	cq = vctx->priv->create_cq_ex(context, cq_attr);
 
-	if (cq) {
-		cq->context		   = context;
-		cq->channel		   = cq_attr->channel;
-		if (cq->channel)
-			++cq->channel->refcnt;
-		cq->cq_context		   = cq_attr->cq_context;
-		cq->comp_events_completed  = 0;
-		cq->async_events_completed = 0;
-		pthread_mutex_init(&cq->mutex, NULL);
-		pthread_cond_init(&cq->cond, NULL);
-	}
-
-	pthread_mutex_unlock(&context->mutex);
+	if (cq)
+		verbs_init_cq(ibv_cq_ex_to_cq(cq), context,
+			        cq_attr->channel, cq_attr->cq_context);
 
 	return cq;
 }
diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index e3ac3f7..ec87afd 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -130,6 +130,9 @@ verbs_get_device(const struct ibv_device *dev)
 typedef struct verbs_device *(*verbs_driver_init_func)(const char *uverbs_sys_path,
 						       int abi_version);
 void verbs_register_driver(const char *name, verbs_driver_init_func init_func);
+void verbs_init_cq(struct ibv_cq *cq, struct ibv_context *context,
+		       struct ibv_comp_channel *channel,
+		       void *cq_context);
 
 int ibv_cmd_get_context(struct ibv_context *context, struct ibv_get_context *cmd,
 			size_t cmd_size, struct ibv_get_context_resp *resp,
diff --git a/libibverbs/ibverbs.h b/libibverbs/ibverbs.h
index 3b08476..eb304ba 100644
--- a/libibverbs/ibverbs.h
+++ b/libibverbs/ibverbs.h
@@ -48,7 +48,7 @@
 #define default_symver(name, api)                                              \
 	asm(".symver " #name "," #api "@@" DEFAULT_ABI)
 #define private_symver(name, api)                                              \
-	asm(".symver " #name "," #api "@@IBVERBS_PRIVATE_13")
+	asm(".symver " #name "," #api "@@IBVERBS_PRIVATE_14")
 
 #define PFX		"libibverbs: "
 
diff --git a/libibverbs/libibverbs.map b/libibverbs/libibverbs.map
index 656c21d..5401241 100644
--- a/libibverbs/libibverbs.map
+++ b/libibverbs/libibverbs.map
@@ -86,7 +86,7 @@ IBVERBS_1.1 {
 
 /* If any symbols in this stanza change ABI then the entire staza gets a new symbol
    version. Also see the private_symver() macro */
-IBVERBS_PRIVATE_13 {
+IBVERBS_PRIVATE_14 {
 	global:
 		/* These historical symbols are now private to libibverbs */
 		ibv_cmd_alloc_mw;
@@ -138,4 +138,5 @@ IBVERBS_PRIVATE_13 {
 		ibv_query_gid_type;
 		ibv_register_driver;
 		verbs_register_driver;
+		verbs_init_cq;
 };
diff --git a/libibverbs/verbs.c b/libibverbs/verbs.c
index e84a2dd..e54fd77 100644
--- a/libibverbs/verbs.c
+++ b/libibverbs/verbs.c
@@ -441,23 +441,10 @@ struct ibv_cq *__ibv_create_cq(struct ibv_context *context, int cqe, void *cq_co
 {
 	struct ibv_cq *cq;
 
-	pthread_mutex_lock(&context->mutex);
-
 	cq = context->ops.create_cq(context, cqe, channel, comp_vector);
 
-	if (cq) {
-		cq->context    	     	   = context;
-		cq->channel		   = channel;
-		if (channel)
-			++channel->refcnt;
-		cq->cq_context 	     	   = cq_context;
-		cq->comp_events_completed  = 0;
-		cq->async_events_completed = 0;
-		pthread_mutex_init(&cq->mutex, NULL);
-		pthread_cond_init(&cq->cond, NULL);
-	}
-
-	pthread_mutex_unlock(&context->mutex);
+	if (cq)
+		verbs_init_cq(cq, context, channel, cq_context);
 
 	return cq;
 }
@@ -477,15 +464,14 @@ int __ibv_destroy_cq(struct ibv_cq *cq)
 	struct ibv_comp_channel *channel = cq->channel;
 	int ret;
 
-	if (channel)
-		pthread_mutex_lock(&channel->context->mutex);
-
 	ret = cq->context->ops.destroy_cq(cq);
 
 	if (channel) {
-		if (!ret)
+		if (!ret) {
+			pthread_mutex_lock(&channel->context->mutex);
 			--channel->refcnt;
-		pthread_mutex_unlock(&channel->context->mutex);
+			pthread_mutex_unlock(&channel->context->mutex);
+		}
 	}
 
 	return ret;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
