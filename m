From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: How far back does rdma-core X supports the kernel Y?
Date: Wed, 1 Nov 2017 11:33:24 -0600
Message-ID: <20171101173324.GF1030@ziepe.ca>
References: <BN3PR07MB2578883C85DD3855C496F367F85F0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20171101163915.GB1030@ziepe.ca>
 <BN3PR07MB257867500E3A15914B2AD075F85F0@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BN3PR07MB257867500E3A15914B2AD075F85F0-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 01, 2017 at 05:27:22PM +0000, Amrani, Ram wrote:
> > WTF is this?
> > 
> > Based on the comment it should be:
> > 
> >          if (attr_mask & ~((1ULL << (IBV_QP_DEST_QPN + 1)) - 1))
> > 
> > To match the comment. And other places have the same mistake.

> > This was broken recently by 3ca7a1031486b588a7fbe0d262f8f89738215b58
> > 
> > Bodong??
> > 
> 
> Oh yeah, that too.
> But my point is that even after I've fixed this (I haven't checked other locations),
> then backwardly compatibility is foo because the above check fails.

> If you take a look at that kernel you can see it sets IB_QP_SMAC in attr_mask
> and returns it to the user space. When modify QP is invoked it fails on that
> check (IB_QP_DEST_QPN < IB_QP_SMAC).

rdma-cm sets it?

> This happens perhaps for the other bits. Haven't checked it yet.

Yes, that test should pass all the historical bits supported by
all older kernels.

// Anything including and beyond RATE_LIMIT must use the _ex API
if (attr_mask & ~((1ULL << IBV_QP_RATE_LIMIT) - 1))

> Also, currently they are marked in ib_verbs.h as reserved. This is misleading as
> it hints they are for future use. We should mark them as don't ever use.

We have tended to use reserved to mean dont use. Someone should
inspect the git history before trying to use a reserved value..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
