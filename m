From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 1/6] IB/uverbs: Allow CQ moderation with
 modify CQ
Date: Sun, 29 Oct 2017 11:43:45 -0600
Message-ID: <20171029174345.GC4488@ziepe.ca>
References: <20171029135140.32649-1-leon@kernel.org>
 <20171029135140.32649-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171029135140.32649-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 29, 2017 at 03:51:35PM +0200, Leon Romanovsky wrote:
> From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Uverbs support in modify_cq for CQ moderation only.
> Gives ability to change cq_max_count and cq_period.
> CQ moderation enhance performance by moderating the number
> of cookies needed to create an event instead of application
> having to suffer from event per cookie.


Like the other recent uAPI patches, lets us see the rdma-core side and
man page first please..

Can you organize all of them into a rdma-core branch someplace?

Not really sure what a cookie is, or why this should be needed when we
already have the means to indicate if CQE's should be signalled or
not.

I guess it is for UD applications where the existing signalled stuff
isn't applicable?

> +int ib_uverbs_ex_modify_cq(struct ib_uverbs_file *file,
> +			   struct ib_device *ib_dev,
> +			   struct ib_udata *ucore,
> +			   struct ib_udata *uhw)

Is this really a good idea?

Why not ib_uverbs_set_cq_moderation ?

We don't have to keep making these thicker and thicker APIs if there
isn't a reason :(

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
