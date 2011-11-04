From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch 1/3] ib_srpt: fixup error handling in srpt_alloc_ioctx_ring()
Date: Fri, 4 Nov 2011 21:27:01 +0300
Message-ID: <20111104182701.GG5796@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Nicholas A. Bellinger" <nab-4mckEHfoRW3KI0RCH6AXYZqQE7yCjDx5@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We returned a freed value instead of NULL on certain error paths.
Complicated error handling generally more error prone, so I've tried
to simplify it a little by removing some gotos.

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 1c29679..937b4bc 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -680,21 +680,20 @@ static struct srpt_ioctx **srpt_alloc_ioctx_ring(struct srpt_device *sdev,
 
 	ring = kmalloc(ring_size * sizeof(ring[0]), GFP_KERNEL);
 	if (!ring)
-		goto out;
+		return NULL;
 	for (i = 0; i < ring_size; ++i) {
 		ring[i] = srpt_alloc_ioctx(sdev, ioctx_size, dma_size, dir);
 		if (!ring[i])
 			goto err;
 		ring[i]->index = i;
 	}
-	goto out;
+	return ring;
 
 err:
 	while (--i >= 0)
 		srpt_free_ioctx(sdev, ring[i], dma_size, dir);
 	kfree(ring);
-out:
-	return ring;
+	return NULL;
 }
 
 /**
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
