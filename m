From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 1/6] IB/uverbs: Allow CQ moderation with
 modify CQ
Date: Mon, 30 Oct 2017 09:52:36 -0600
Message-ID: <20171030155236.GC12392@ziepe.ca>
References: <20171029135140.32649-1-leon@kernel.org>
 <20171029135140.32649-2-leon@kernel.org>
 <20171029174345.GC4488@ziepe.ca>
 <20171029182808.GN16127@mtr-leonro.local>
 <20171030144807.GA12392@ziepe.ca>
 <20171030152815.GA16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171030152815.GA16127-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 30, 2017 at 05:28:15PM +0200, Leon Romanovsky wrote:
> > + * ib_modify_cq - Modifies moderation params of the CQ
> > + * @cq: The CQ to modify.
> > + * @cq_count: number of CQEs that will trigger an event
> > + * @cq_period: max period of time in usec before triggering an event
> > + *
> > + */
> > +int ib_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period);
> 
> I see it differently, this is extendable version of modify_cq, which is
> going to benefit all other users who will decide to extend it.

The only reason we have these goofy 'thick' APIs like modify_qp is
because people said they needed a very high rate of qp modifications
and could not tolerate the performance downside of a dis-aggregated
API.

I don't think CQ falls into that reasoning, so it should be
dis-aggregated.

Many things in verbs are terrible examples of how to make APIs, we
should not just blindly copy things..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
