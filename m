From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: bug report: dereferencing before check
Date: Mon, 31 May 2010 20:19:10 -0700
Message-ID: <ada4ohnv3rl.fsf@roland-alpha.cisco.com>
References: <20100531141552.GW5483@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100531141552.GW5483@bicker> (Dan Carpenter's message of "Mon,
	31 May 2010 16:15:52 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > drivers/infiniband/hw/mlx4/cq.c +401 mlx4_ib_resize_cq(56)
 > 	warn: variable dereferenced before check 'cq->resize_buf'
 > 
 >    385          err = mlx4_cq_resize(dev->dev, &cq->mcq, entries, &cq->resize_buf->buf.mtt);
 >                                                                   ^^^^^^^^^^^^^^^^^^^^^^^^
 > 	Dereference "cq->resize_buf" here.  (Ok.  Technically we
 > 	dereference it inside the function).
 > 
 >    386          if (err)
 >    387                  goto err_buf;
 >    388
 >    389          mlx4_mtt_cleanup(dev->dev, &mtt);
 >    390          if (ibcq->uobject) {
 >    391                  cq->buf      = cq->resize_buf->buf;
 >    392                  cq->ibcq.cqe = cq->resize_buf->cqe;
 >    393                  ib_umem_release(cq->umem);
 >    394                  cq->umem     = cq->resize_umem;
 >    395
 >    396                  kfree(cq->resize_buf);
 >    397                  cq->resize_buf = NULL;
 >    398                  cq->resize_umem = NULL;
 >    399          } else {
 >    400                  spin_lock_irq(&cq->lock);
 >    401                  if (cq->resize_buf) {
 >                             ^^^^^^^^^^^^^^
 > 	Check here.
 > 
 >    402                          mlx4_ib_cq_resize_copy_cqes(cq);
 > 
 > Can "cq->resize_buf" be NULL here?

Hi, this is a tricky one.  The short answer is yes, resize_buf can be
NULL at the time it's checked.  This function is handling resizing a
queue, and it first allocates a new queue, then later switches over to
it.  However, in the middle of all this, another context might want to
use that queue (possibly from interrupt context), and that might free
resize_buf asynchronously.  cf the code after the comment "Resize CQ in
progress" in mlx4_ib_poll_one().

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
