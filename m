From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RESEND v1 rdma-next 5/6] RDMA/nldev: provide detailed MR information
Date: Wed, 14 Feb 2018 10:31:11 -0600
Message-ID: <039b01d3a5b1$39a44e20$acecea60$@opengridcomputing.com>
References: <cover.1518552800.git.swise@opengridcomputing.com> <be7f33b8ce1e7311e9ed408267d8475166e48d9b.1518552800.git.swise@opengridcomputing.com> <20180214134346.GZ2197@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180214134346.GZ2197-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey Leon,

...

> > diff --git a/drivers/infiniband/core/uverbs_cmd.c
> b/drivers/infiniband/core/uverbs_cmd.c
> > index 256934d..3f026c4 100644
> > --- a/drivers/infiniband/core/uverbs_cmd.c
> > +++ b/drivers/infiniband/core/uverbs_cmd.c
> > @@ -694,6 +694,8 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file
> *file,
> >  	mr->pd      = pd;
> >  	mr->uobject = uobj;
> >  	atomic_inc(&pd->usecnt);
> > +	mr->res.type = RDMA_RESTRACK_MR;
> > +	rdma_restrack_add(&mr->res);
> >
> >  	uobj->object = mr;
> >
> > @@ -819,6 +821,7 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file
> *file,
> >  	struct ib_uverbs_dereg_mr cmd;
> >  	struct ib_uobject	 *uobj;
> >  	int                       ret = -EINVAL;
> > +	struct ib_mr *mr;
> >
> >  	if (copy_from_user(&cmd, buf, sizeof cmd))
> >  		return -EFAULT;
> > @@ -828,6 +831,9 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file
> *file,
> >  	if (IS_ERR(uobj))
> >  		return PTR_ERR(uobj);
> >
> > +	mr = uobj->object;
> > +	rdma_restrack_del(&mr->res);
> > +
> 
> It is wrong function to rdma_restrack_del(). The best place to put
> rdma_restrack_add() is right after device->xxx() call and
> rdma_restrack_del() is right before device->yyy() call.
> 
> Thanks

You're right.  In fact, the resource is already being deleted from the
restrack db in ib_dereg_mr() called by uverbs_free_mr().  So the above chunk
is not needed at all.

Thanks,

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
