From: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [patch] infiniband: potential double free
Date: Tue, 16 Mar 2010 11:09:26 +0300
Message-ID: <20100316080925.GC5331@bicker>
References: <20100315082332.GF18181@bicker> <20100315141846.GA1477@holoscopio.com> <20100315150735.GM18181@bicker> <15ddcffd1003160027q47286fcqa1344c964fe472b0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <15ddcffd1003160027q47286fcqa1344c964fe472b0-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Thadeu Lima de Souza Cascardo <cascardo-DmMZpsCg3uxeGPcbtGPokg@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We shouldn't free things here because we free them later.  The call 
tree looks like this:
iser_connect() => iser_cma_handler() => iser_route_handler()
        => iser_create_ib_conn_res()

                We fail here and return failures back down the tree.

iser_connect() => iser_conn_release()

                Double free.                                                                                                 

Also "ret" is already initialized to -ENOMEM so there is no need to
set that here.

Signed-off-by: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 308d17b..fde2c93 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -148,10 +148,8 @@ static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
 	device = ib_conn->device;
 
 	ib_conn->login_buf = kmalloc(ISER_RX_LOGIN_SIZE, GFP_KERNEL);
-	if (!ib_conn->login_buf) {
-		goto alloc_err;
-		ret = -ENOMEM;
-	}
+	if (!ib_conn->login_buf)
+		goto out_err;
 
 	ib_conn->login_dma = ib_dma_map_single(ib_conn->device->ib_device,
 				(void *)ib_conn->login_buf, ISER_RX_LOGIN_SIZE,
@@ -160,10 +158,9 @@ static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
 	ib_conn->page_vec = kmalloc(sizeof(struct iser_page_vec) +
 				    (sizeof(u64) * (ISCSI_ISER_SG_TABLESIZE +1)),
 				    GFP_KERNEL);
-	if (!ib_conn->page_vec) {
-		ret = -ENOMEM;
-		goto alloc_err;
-	}
+	if (!ib_conn->page_vec)
+		goto out_err;
+
 	ib_conn->page_vec->pages = (u64 *) (ib_conn->page_vec + 1);
 
 	params.page_shift        = SHIFT_4K;
@@ -183,7 +180,7 @@ static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
 	ib_conn->fmr_pool = ib_create_fmr_pool(device->pd, &params);
 	if (IS_ERR(ib_conn->fmr_pool)) {
 		ret = PTR_ERR(ib_conn->fmr_pool);
-		goto fmr_pool_err;
+		goto out_err;
 	}
 
 	memset(&init_attr, 0, sizeof init_attr);
@@ -201,7 +198,7 @@ static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
 
 	ret = rdma_create_qp(ib_conn->cma_id, device->pd, &init_attr);
 	if (ret)
-		goto qp_err;
+		goto out_err;
 
 	ib_conn->qp = ib_conn->cma_id->qp;
 	iser_err("setting conn %p cma_id %p: fmr_pool %p qp %p\n",
@@ -209,12 +206,7 @@ static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
 		 ib_conn->fmr_pool, ib_conn->cma_id->qp);
 	return ret;
 
-qp_err:
-	(void)ib_destroy_fmr_pool(ib_conn->fmr_pool);
-fmr_pool_err:
-	kfree(ib_conn->page_vec);
-	kfree(ib_conn->login_buf);
-alloc_err:
+out_err:
 	iser_err("unable to alloc mem or create resource, err %d\n", ret);
 	return ret;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
