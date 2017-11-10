From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 1/6] IB/uverbs: Allow CQ moderation with
 modify CQ
Date: Fri, 10 Nov 2017 14:16:52 -0700
Message-ID: <20171110211652.GG17451@ziepe.ca>
References: <20171029135140.32649-1-leon@kernel.org>
 <20171029135140.32649-2-leon@kernel.org>
 <20171029174345.GC4488@ziepe.ca>
 <20171029182808.GN16127@mtr-leonro.local>
 <20171030144807.GA12392@ziepe.ca>
 <20171030152815.GA16127@mtr-leonro.local>
 <1510341329.3735.19.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1510341329.3735.19.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 10, 2017 at 02:15:29PM -0500, Doug Ledford wrote:

> signature of ib_modify_cq to a generic, extendable signature, or we need
> to change the name as Jason points out so we match name and parameter
> signature in the same spirit.

The kernel side should focus on setting cq moderation, as I understand
we have ULPs that want to adjust this dynamically so higher
performance through a simplified API makes the most sense. No need to
mirror libibverbs.

> Let's please make this consistent before merging.  BTW, because so much
> of the rest of the API uses things like modify_qp with an attr struct
> and a single entry point, I'm leaning towards following that here for
> the sake of API consistency.

Should we introduce a create_cq_ex as well at this point? It is really
weird in verbs to have a modify attrs without a create also accepting
the attrs.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
