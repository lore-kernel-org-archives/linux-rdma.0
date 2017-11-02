From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: How far back does rdma-core X supports the kernel Y?
Date: Thu, 2 Nov 2017 15:35:40 -0600
Message-ID: <20171102213540.GX18874@ziepe.ca>
References: <BN3PR07MB2578883C85DD3855C496F367F85F0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20171101163915.GB1030@ziepe.ca>
 <BN3PR07MB257867500E3A15914B2AD075F85F0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20171101173324.GF1030@ziepe.ca>
 <BN3PR07MB257829836974C1D0F1257387F85C0@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BN3PR07MB257829836974C1D0F1257387F85C0-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 02, 2017 at 07:01:58AM +0000, Amrani, Ram wrote:
> > We have tended to use reserved to mean dont use. Someone should
> > inspect the git history before trying to use a reserved value..
> > 
> 
> When reserved are used in structures, usually for alignment, they are
> freely taken when a new field needs adding.

Even then you should check the git history to figure out why the field
is reserved. Padding ones are OK to steal, but we also have deprecated
struct members. :\

> Still, I think it is a better practice to give a more meaningful name
> and/or comment to differentiate. E.g.:
> 
> IB_QP_XXX_DONT_USE /* Kept for backward compatibility only */

It would be good to do this, yes.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
