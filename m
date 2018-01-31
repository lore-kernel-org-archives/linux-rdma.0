From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [bug report] RDMA/bnxt_re: Add SRQ support for Broadcom adapters
Date: Wed, 31 Jan 2018 09:32:38 +0300
Message-ID: <20180131063238.ch4mcl7c6ps7ykxe@mwanda>
References: <20180130124546.GA9394@mwanda>
 <CANjDDBiiL1TtH5OZ9gYuiZquKu2=AV+u9nJDQ--qibOP5CXgYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANjDDBiiL1TtH5OZ9gYuiZquKu2=AV+u9nJDQ--qibOP5CXgYg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 31, 2018 at 11:16:55AM +0530, Devesh Sharma wrote:
> On Tue, Jan 30, 2018 at 6:15 PM, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> > Hello Devesh Sharma,
> >
> > The patch 37cb11acf1f7: "RDMA/bnxt_re: Add SRQ support for Broadcom
> > adapters" from Jan 11, 2018, leads to the following static checker
> > warning:
> >
> >         drivers/infiniband/hw/bnxt_re/ib_verbs.c:1317 bnxt_re_destroy_srq()
> >         warn: 'srq->umem' isn't an ERR_PTR
> >
> > drivers/infiniband/hw/bnxt_re/ib_verbs.c
> >   1313                  dev_err(rdev_to_dev(rdev), "Destroy HW SRQ failed!");
> >   1314                  return rc;
> >   1315          }
> >   1316
> >   1317          if (srq->umem && !IS_ERR(srq->umem))
> >                                   ^^^^^^^^^^^^^^^^
> > We never store error pointers to srq->umem.  It's pretty consistently
> > checked for error pointers though so maybe that's fine.  It causes a
> > static checker warning because error pointer confusion is a pretty
> > common source of bugs.  Anyway, feel free to ignore if you want...
> Thanks for reporting Dan,
> 
> Is there a way out, I want to call ib_umem_release only if it was valid.
> I think if ib_umem_release checks for the validity of pointer then I
> can get rid of this?
> There are other places also in bnxt_re driver where such checks are present.

Yeah.  Those places generate warnings as well, but I thought one was
enough.  It's fine if you want to ignore the warning, no one will be
upset.  :P

[ snip ]

> >   1342          bytes = (qplib_srq->max_wqe * BNXT_QPLIB_MAX_RQE_ENTRY_SIZE);
> >   1343          bytes = PAGE_ALIGN(bytes);
> >   1344          umem = ib_umem_get(context, ureq.srqva, bytes,
> >   1345                             IB_ACCESS_LOCAL_WRITE, 1);
> >   1346          if (IS_ERR(umem))
> >   1347                  return PTR_ERR(umem);
> >   1348
> >   1349          srq->umem = umem;
> >                 ^^^^^^^^^^^^^^^^
> > Set here, I guess.
> Yeah, the checker is confused due to this.

It does bother me that you're saying the "checker is confused".  The
checker is printing a 100% accurate, factual warning...  :/  We have an
IS_ERR() check when the pointer can not possibly be an error pointer.

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
