From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH} librdmacm: fix race initializing library
Date: Mon, 19 Oct 2009 09:30:16 -0700
Message-ID: <70A923FFB18B4139984C5F6D2DE67C51@amr.corp.intel.com>
References: <OF77296F68.F34EB189-ONC225764C.003E31BE-C225764C.003F7FF9@il.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OF77296F68.F34EB189-ONC225764C.003E31BE-C225764C.003F7FF9-7z/5BgaJwgfQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Nir Naaman' <NAAMAN-7z/5BgaJwgfQT0dZR+AlfA@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Multi-threaded code can race with ucma_init().  When ucma_init() is called
it can set cma_dev_cnt before it is done initializing the library.  If
a second thread checks cma_dev_cnt and finds it non-zero, then it will
skip the call to ucma_init() and assume that the library is ready for use.
This can lead to an application crash during startup.

Do not set cma_dev_cnt until the end of ucma_init(), after all
initialization has completed.  Adjust the error handling code in
ucma_init() accordingly.

Bug reported by Nir Naaman:
Looking at cma.c we see that ucma_init initializes things under a lock but
it sets cma_dev_cnt right at the start and many other functions (like
rdma_create_event_channel in our case) do not check this variable under a
lock. So if two threads call rdma_create_event_channel at the same time
one of them will do the initialization but the other may see cma_dev_cnt>0
and continue before the first thread completed the initialization.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Nir, can you give this patch a try?  If it works for you, I'll push it
into my git tree and create a new release.

 src/cma.c |   40 ++++++++++++++++++++++++----------------
 1 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/src/cma.c b/src/cma.c
index 70dbe1c..87e73ac 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -205,30 +205,32 @@ static int ucma_init(void)
 	struct ibv_device **dev_list = NULL;
 	struct cma_device *cma_dev;
 	struct ibv_device_attr attr;
-	int i, ret;
+	int i, ret, dev_cnt;
 
 	pthread_mutex_lock(&mut);
-	if (cma_dev_cnt)
-		goto out;
+	if (cma_dev_cnt) {
+		pthread_mutex_unlock(&mut);
+		return 0;
+	}
 
 	ret = check_abi_version();
 	if (ret)
-		goto err;
+		goto err1;
 
-	dev_list = ibv_get_device_list(&cma_dev_cnt);
+	dev_list = ibv_get_device_list(&dev_cnt);
 	if (!dev_list) {
 		printf("CMA: unable to get RDMA device list\n");
 		ret = -ENODEV;
-		goto err;
+		goto err1;
 	}
 
-	cma_dev_array = malloc(sizeof *cma_dev * cma_dev_cnt);
+	cma_dev_array = malloc(sizeof *cma_dev * dev_cnt);
 	if (!cma_dev_array) {
 		ret = -ENOMEM;
-		goto err;
+		goto err2;
 	}
 
-	for (i = 0; dev_list[i]; ++i) {
+	for (i = 0; dev_list[i];) {
 		cma_dev = &cma_dev_array[i];
 
 		cma_dev->guid = ibv_get_device_guid(dev_list[i]);
@@ -236,28 +238,34 @@ static int ucma_init(void)
 		if (!cma_dev->verbs) {
 			printf("CMA: unable to open RDMA device\n");
 			ret = -ENODEV;
-			goto err;
+			goto err3;
 		}
 
+		i++;
 		ret = ibv_query_device(cma_dev->verbs, &attr);
 		if (ret) {
 			printf("CMA: unable to query RDMA device\n");
-			goto err;
+			goto err3;
 		}
 
 		cma_dev->port_cnt = attr.phys_port_cnt;
 		cma_dev->max_initiator_depth = (uint8_t) attr.max_qp_init_rd_atom;
 		cma_dev->max_responder_resources = (uint8_t) attr.max_qp_rd_atom;
 	}
-out:
+
+	cma_dev_cnt = dev_cnt;
 	pthread_mutex_unlock(&mut);
 	ibv_free_device_list(dev_list);
 	return 0;
-err:
-	ucma_cleanup();
+
+err3:
+	while (i--)
+		ibv_close_device(cma_dev_array[i].verbs);
+	free(cma_dev_array);
+err2:
+	ibv_free_device_list(dev_list);
+err1:
 	pthread_mutex_unlock(&mut);
-	if (dev_list)
-		ibv_free_device_list(dev_list);
 	return ret;
 }
 



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
