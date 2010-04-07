From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 17/37] librdmacm: expose ucma_init to other internal modules
Date: Wed, 7 Apr 2010 10:12:44 -0700
Message-ID: <2653AC7C0BAC48EAA4A399E9E2DB02F7@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
References: 
In-Reply-To: 
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Remove static property from ucma_init and expose its
definition in cma.h.  The address resolution module will
need access to this function.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 src/cma.c |   14 +++++++++-----
 src/cma.h |    2 ++
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/src/cma.c b/src/cma.c
index 6ef4b96..8aa7b05 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -188,13 +188,17 @@ static int check_abi_version(void)
 	return 0;
 }
 
-static int ucma_init(void)
+int ucma_init(void)
 {
 	struct ibv_device **dev_list = NULL;
 	struct cma_device *cma_dev;
 	struct ibv_device_attr attr;
 	int i, ret, dev_cnt;
 
+	/* Quick check without lock to see if we're already initialized */
+	if (cma_dev_cnt)
+		return 0;
+
 	pthread_mutex_lock(&mut);
 	if (cma_dev_cnt) {
 		pthread_mutex_unlock(&mut);
@@ -271,7 +275,7 @@ struct ibv_context **rdma_get_devices(int *num_devices)
 	struct ibv_context **devs = NULL;
 	int i;
 
-	if (!cma_dev_cnt && ucma_init())
+	if (ucma_init())
 		goto out;
 
 	devs = malloc(sizeof *devs * (cma_dev_cnt + 1));
@@ -301,7 +305,7 @@ struct rdma_event_channel *rdma_create_event_channel(void)
 {
 	struct rdma_event_channel *channel;
 
-	if (!cma_dev_cnt && ucma_init())
+	if (ucma_init())
 		return NULL;
 
 	channel = malloc(sizeof *channel);
@@ -396,7 +400,7 @@ int rdma_create_id(struct rdma_event_channel *channel,
 	void *msg;
 	int ret, size;
 
-	ret = cma_dev_cnt ? 0 : ucma_init();
+	ret = ucma_init();
 	if (ret)
 		return ret;
 
@@ -1712,7 +1716,7 @@ int rdma_get_cm_event(struct rdma_event_channel *channel,
 	void *msg;
 	int ret, size;
 
-	ret = cma_dev_cnt ? 0 : ucma_init();
+	ret = ucma_init();
 	if (ret)
 		return ret;
 
diff --git a/src/cma.h b/src/cma.h
index 92e771e..06ca38c 100644
--- a/src/cma.h
+++ b/src/cma.h
@@ -82,5 +82,7 @@ static inline void *zalloc(size_t size)
 	return buf;
 }
 
+int ucma_init();
+
 #endif /* CMA_H */
 



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
