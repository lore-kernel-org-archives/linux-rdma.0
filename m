From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] librdmacm: lazy initialization for ib devices
Date: Thu, 10 Apr 2014 05:33:44 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388D55026@ORSMSX109.amr.corp.intel.com>
References: <20140325065839.GA3794@shamir-pc>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140325065839.GA3794@shamir-pc>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> LIBRDMACM currently opens a device context per configured HCA. This is
> usually done in rdma_create_event_channel() or first time whenever
> ucma_init() is called. If a process is only going to use one of the
> configured HCAs/RDMA IPs then the remaining device contexts are not
> used/required. Opening a device context on each device apriori limits the
> maximum number of processes that can be supported on a node to the maximum
> number of open context supported per HCA regardless of number of HCAs
> present
> in the system.

This patch didn't quite work.  Specifically, it has issues with datagram rsockets
that results in the application crashing.  I reworked the patch, and it appears
to be working so far.  (See end of email for updated patch).  Can you try it
and let me know if it works for you as well?

I'm not thrilled about the updated patch because it has some inefficiencies,
like getting the device list multiple times, but I didn't see a clean way to
make the code more efficient.

See a couple of comments below:

> 
> Signed-off-by: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  src/cma.c | 152 ++++++++++++++++++++++++++++++++++++++++++++++++----------
> ----
>  1 file changed, 118 insertions(+), 34 deletions(-)
> 
> diff --git a/src/cma.c b/src/cma.c
> index 0cf4203..56bfa14 100644
> --- a/src/cma.c
> +++ b/src/cma.c
> @@ -74,7 +74,7 @@ do {						\
>  } while (0)
> 
>  struct cma_device {
> -	struct ibv_context *verbs;
> +	struct ibv_context *lverbs; /* Lazy initialization */

nit - I wasn't fond of this name change

>  	struct ibv_pd	   *pd;
>  	uint64_t	    guid;
>  	int		    port_cnt;
> @@ -130,13 +130,20 @@ static fastlock_t idm_lock;
> 
>  static void ucma_cleanup(void)
>  {
> +	struct ibv_context *verbs;
> +	struct ibv_pd *pd;
> +
>  	ucma_ib_cleanup();
> 
>  	if (cma_dev_cnt) {
>  		while (cma_dev_cnt--) {
> -			if (cma_dev_array[cma_dev_cnt].refcnt)
> -				ibv_dealloc_pd(cma_dev_array[cma_dev_cnt].pd);
> -			ibv_close_device(cma_dev_array[cma_dev_cnt].verbs);
> +			verbs = cma_dev_array[cma_dev_cnt].lverbs;
> +			if (verbs) {
> +				pd = cma_dev_array[cma_dev_cnt].pd;
> +				if (cma_dev_array[cma_dev_cnt].refcnt)
> +					ibv_dealloc_pd(pd);
> +				ibv_close_device(verbs);
> +			}
>  		}
> 
>  		fastlock_destroy(&idm_lock);
> @@ -202,11 +209,77 @@ static void ucma_set_af_ib_support(void)
>  	rdma_destroy_id(id);
>  }
> 
> -int ucma_init(void)
> +static int ucma_lazy_dev_init(int dev_index)

I updated this call to take the cma_dev pointer directly.


> @@ -1022,11 +1101,16 @@ static int ucma_modify_qp_err(struct rdma_cm_id
> *id)
>  static int ucma_find_pkey(struct cma_device *cma_dev, uint8_t port_num,
>  			  uint16_t pkey, uint16_t *pkey_index)
>  {
> +	struct ibv_context *verbs;
>  	int ret, i;
>  	uint16_t chk_pkey;
> 
> +	verbs = ucma_get_verbs_guid(cma_dev->guid);
> +	if (!verbs)
> +		return ERR(ENODEV);
> +
>  	for (i = 0, ret = 0; !ret; i++) {
> -		ret = ibv_query_pkey(cma_dev->verbs, port_num, i, &chk_pkey);
> +		ret = ibv_query_pkey(verbs, port_num, i, &chk_pkey);
>  		if (!ret && pkey == chk_pkey) {
>  			*pkey_index = (uint16_t) i;
>  			return 0;

I didn't understand why a change was made to this call.

updated patch:

librdmacm: Support lazy initialization

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

librdmacm currently opens a device context per configured HCA. This is
usually done in rdma_create_event_channel() or first time whenever
ucma_init() is called. If a process is only going to use one of the
configured HCAs/RDMA IPs then the remaining device contexts are not
used/required. Opening a device context on each device apriori limits the
maximum number of processes that can be supported on a node to the maximum
number of open context supported per HCA regardless of number of HCAs present
in the system.

Signed-off-by: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/cma.c |  133 ++++++++++++++++++++++++++++++++++++++++++++-----------------
 src/cma.h |    2 -
 2 files changed, 98 insertions(+), 37 deletions(-)

diff --git a/src/cma.c b/src/cma.c
index 0cf4203..0dc229e 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -122,6 +122,7 @@ struct cma_event {
 
 static struct cma_device *cma_dev_array;
 static int cma_dev_cnt;
+static int cma_init_cnt;
 static pthread_mutex_t mut = PTHREAD_MUTEX_INITIALIZER;
 static int abi_ver = RDMA_USER_CM_MAX_ABI_VERSION;
 int af_ib_support;
@@ -134,9 +135,13 @@ static void ucma_cleanup(void)
 
 	if (cma_dev_cnt) {
 		while (cma_dev_cnt--) {
+			if (!cma_dev_array[cma_dev_cnt].verbs)
+				continue;
+
 			if (cma_dev_array[cma_dev_cnt].refcnt)
 				ibv_dealloc_pd(cma_dev_array[cma_dev_cnt].pd);
 			ibv_close_device(cma_dev_array[cma_dev_cnt].verbs);
+			cma_init_cnt--;
 		}
 
 		fastlock_destroy(&idm_lock);
@@ -205,8 +210,6 @@ static void ucma_set_af_ib_support(void)
 int ucma_init(void)
 {
 	struct ibv_device **dev_list = NULL;
-	struct cma_device *cma_dev;
-	struct ibv_device_attr attr;
 	int i, ret, dev_cnt;
 
 	/* Quick check without lock to see if we're already initialized */
@@ -236,37 +239,15 @@ int ucma_init(void)
 		ret = ERR(ENODEV);
 		goto err2;
 	}
-		
-	cma_dev_array = calloc(dev_cnt, sizeof *cma_dev);
+
+	cma_dev_array = calloc(dev_cnt, sizeof *cma_dev_array);
 	if (!cma_dev_array) {
 		ret = ERR(ENOMEM);
 		goto err2;
 	}
 
-	for (i = 0; dev_list[i];) {
-		cma_dev = &cma_dev_array[i];
-
-		cma_dev->guid = ibv_get_device_guid(dev_list[i]);
-		cma_dev->verbs = ibv_open_device(dev_list[i]);
-		if (!cma_dev->verbs) {
-			fprintf(stderr, PFX "Fatal: unable to open RDMA device\n");
-			ret = ERR(ENODEV);
-			goto err3;
-		}
-
-		i++;
-		ret = ibv_query_device(cma_dev->verbs, &attr);
-		if (ret) {
-			fprintf(stderr, PFX "Fatal: unable to query RDMA device\n");
-			ret = ERR(ret);
-			goto err3;
-		}
-
-		cma_dev->port_cnt = attr.phys_port_cnt;
-		cma_dev->max_qpsize = attr.max_qp_wr;
-		cma_dev->max_initiator_depth = (uint8_t) attr.max_qp_init_rd_atom;
-		cma_dev->max_responder_resources = (uint8_t) attr.max_qp_rd_atom;
-	}
+	for (i = 0; dev_list[i]; i++)
+		cma_dev_array[i].guid = ibv_get_device_guid(dev_list[i]);
 
 	cma_dev_cnt = dev_cnt;
 	ucma_set_af_ib_support();
@@ -274,10 +255,6 @@ int ucma_init(void)
 	ibv_free_device_list(dev_list);
 	return 0;
 
-err3:
-	while (i--)
-		ibv_close_device(cma_dev_array[i].verbs);
-	free(cma_dev_array);
 err2:
 	ibv_free_device_list(dev_list);
 err1:
@@ -286,12 +263,93 @@ err1:
 	return ret;
 }
 
+static struct ibv_context *ucma_open_device(uint64_t guid)
+{
+	struct ibv_device **dev_list;
+	struct ibv_context *verbs = NULL;
+	int i;
+
+	dev_list = ibv_get_device_list(NULL);
+	if (!dev_list) {
+		fprintf(stderr, PFX "Fatal: unable to get RDMA device list\n");
+		return NULL;
+	}
+
+	for (i = 0; dev_list[i]; i++) {
+		if (ibv_get_device_guid(dev_list[i]) == guid) {
+			verbs = ibv_open_device(dev_list[i]);
+			break;
+		}
+	}
+
+	if (!verbs)
+		fprintf(stderr, PFX "Fatal: unable to open RDMA device\n");
+
+	ibv_free_device_list(dev_list);
+	return verbs;
+}
+
+static int ucma_init_device(struct cma_device *cma_dev)
+{
+	struct ibv_device_attr attr;
+	int ret;
+
+	if (cma_dev->verbs)
+		return 0;
+
+	cma_dev->verbs = ucma_open_device(cma_dev->guid);
+	if (!cma_dev->verbs)
+		return ERR(ENODEV);
+
+	ret = ibv_query_device(cma_dev->verbs, &attr);
+	if (ret) {
+		fprintf(stderr, PFX "Fatal: unable to query RDMA device\n");
+		ret = ERR(ret);
+		goto err;
+	}
+
+	cma_dev->port_cnt = attr.phys_port_cnt;
+	cma_dev->max_qpsize = attr.max_qp_wr;
+	cma_dev->max_initiator_depth = (uint8_t) attr.max_qp_init_rd_atom;
+	cma_dev->max_responder_resources = (uint8_t) attr.max_qp_rd_atom;
+	cma_init_cnt++;
+	return 0;
+
+err:
+	ibv_close_device(cma_dev->verbs);
+	cma_dev->verbs = NULL;
+	return ret;
+}
+
+int ucma_init_all(void)
+{
+	int i, ret = 0;
+
+	if (!cma_dev_cnt) {
+		ret = ucma_init();
+		if (ret)
+			return ret;
+	}
+
+	if (cma_init_cnt == cma_dev_cnt)
+		return 0;
+
+	pthread_mutex_lock(&mut);
+	for (i = 0; i < cma_dev_cnt; i++) {
+		ret = ucma_init_device(&cma_dev_array[i]);
+		if (ret)
+			break;
+	}
+	pthread_mutex_unlock(&mut);
+	return ret;
+}
+
 struct ibv_context **rdma_get_devices(int *num_devices)
 {
 	struct ibv_context **devs = NULL;
 	int i;
 
-	if (ucma_init())
+	if (ucma_init_all())
 		goto out;
 
 	devs = malloc(sizeof *devs * (cma_dev_cnt + 1));
@@ -348,7 +406,7 @@ void rdma_destroy_event_channel(struct rdma_event_channel *channel)
 static int ucma_get_device(struct cma_id_private *id_priv, uint64_t guid)
 {
 	struct cma_device *cma_dev;
-	int i, ret = 0;
+	int i, ret;
 
 	for (i = 0; i < cma_dev_cnt; i++) {
 		cma_dev = &cma_dev_array[i];
@@ -358,9 +416,12 @@ static int ucma_get_device(struct cma_id_private *id_priv, uint64_t guid)
 
 	return ERR(ENODEV);
 match:
+	if ((ret = ucma_init_device(cma_dev)))
+		return ret;
+
 	pthread_mutex_lock(&mut);
 	if (!cma_dev->refcnt++) {
-		cma_dev->pd = ibv_alloc_pd(cma_dev_array[i].verbs);
+		cma_dev->pd = ibv_alloc_pd(cma_dev->verbs);
 		if (!cma_dev->pd) {
 			cma_dev->refcnt--;
 			ret = ERR(ENOMEM);
@@ -2292,7 +2353,7 @@ int ucma_max_qpsize(struct rdma_cm_id *id)
 	if (id && id_priv->cma_dev) {
 		max_size = id_priv->cma_dev->max_qpsize;
 	} else {
-		ucma_init();
+		ucma_init_all();
 		for (i = 0; i < cma_dev_cnt; i++) {
 			if (!max_size || max_size > cma_dev_array[i].max_qpsize)
 				max_size = cma_dev_array[i].max_qpsize;
diff --git a/src/cma.h b/src/cma.h
index 4c991b4..a7bab0f 100644
--- a/src/cma.h
+++ b/src/cma.h
@@ -158,7 +158,7 @@ static inline int ERR(int err)
 	return -1;
 }
 
-int ucma_init();
+int ucma_init(void);
 extern int af_ib_support;
 
 #define RAI_ROUTEONLY		0x01000000


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
