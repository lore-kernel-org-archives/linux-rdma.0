From: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: bug report: dereferencing before check
Date: Mon, 31 May 2010 16:15:52 +0200
Message-ID: <20100531141552.GW5483@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,

I was going through some smatch errors and I was wondering if you could
help me.

drivers/infiniband/hw/mlx4/cq.c +401 mlx4_ib_resize_cq(56)
	warn: variable dereferenced before check 'cq->resize_buf'

   385          err = mlx4_cq_resize(dev->dev, &cq->mcq, entries, &cq->resize_buf->buf.mtt);
                                                                  ^^^^^^^^^^^^^^^^^^^^^^^^
	Dereference "cq->resize_buf" here.  (Ok.  Technically we
	dereference it inside the function).

   386          if (err)
   387                  goto err_buf;
   388
   389          mlx4_mtt_cleanup(dev->dev, &mtt);
   390          if (ibcq->uobject) {
   391                  cq->buf      = cq->resize_buf->buf;
   392                  cq->ibcq.cqe = cq->resize_buf->cqe;
   393                  ib_umem_release(cq->umem);
   394                  cq->umem     = cq->resize_umem;
   395
   396                  kfree(cq->resize_buf);
   397                  cq->resize_buf = NULL;
   398                  cq->resize_umem = NULL;
   399          } else {
   400                  spin_lock_irq(&cq->lock);
   401                  if (cq->resize_buf) {
                            ^^^^^^^^^^^^^^
	Check here.

   402                          mlx4_ib_cq_resize_copy_cqes(cq);

Can "cq->resize_buf" be NULL here?

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
