From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 1/6] IB/uverbs: Allow CQ moderation with
 modify CQ
Date: Mon, 30 Oct 2017 08:48:07 -0600
Message-ID: <20171030144807.GA12392@ziepe.ca>
References: <20171029135140.32649-1-leon@kernel.org>
 <20171029135140.32649-2-leon@kernel.org>
 <20171029174345.GC4488@ziepe.ca>
 <20171029182808.GN16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171029182808.GN16127-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 29, 2017 at 08:28:08PM +0200, Leon Romanovsky wrote:

> > > +int ib_uverbs_ex_modify_cq(struct ib_uverbs_file *file,
> > > +			   struct ib_device *ib_dev,
> > > +			   struct ib_udata *ucore,
> > > +			   struct ib_udata *uhw)
> >
> > Is this really a good idea?
> >
> > Why not ib_uverbs_set_cq_moderation ?
> 
> It follows already existed ib_modify_cq(), see commit 2dd571622787
> ("IB/core: Add support for modify CQ")

And that function should have been called set_cq_moderation:

+ * ib_modify_cq - Modifies moderation params of the CQ
+ * @cq: The CQ to modify.
+ * @cq_count: number of CQEs that will trigger an event
+ * @cq_period: max period of time in usec before triggering an event
+ *
+ */
+int ib_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period);

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
