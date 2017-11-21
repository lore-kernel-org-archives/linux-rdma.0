From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 0/7] i40iw: Fixes in i40iw for 4.15
Date: Tue, 21 Nov 2017 16:02:50 -0600
Message-ID: <20171121220250.GA932@horosco-MOBL2.amr.corp.intel.com>
References: <20171121184502.14056-1-henry.orosco@intel.com>
 <20171121185217.GI29826@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171121185217.GI29826-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 21, 2017 at 11:52:17AM -0700, Jason Gunthorpe wrote:
> On Tue, Nov 21, 2017 at 12:44:55PM -0600, Henry Orosco wrote:
> > The following patches are for the 4.15 kernel.
> 
> These all seem reasonable to me, but again, can you revise the
> commit messages so they are acceptable for -rc?
> 
> Linus did not entirely like the commit messages last cycle, so please
> lets all try harder to be clear, think of writing your commit messages
> in terms of:
> 
>  - What is the bug this is fixing? How does the user perceive the bug?
>  - How did this work before? Did it?
> 
> Many of these messages are just describing what the patch is doing,
> without providing context why it is an acceptable change for RC.
> 
> Eg here:
> 
>  Use sqsize instead of I40IW_CQP_SW_SQSIZE_2048 to initialize
>  cqp_requests elements in the for-loop as sqsize is used
>  to allocate memory for cqp_requests.
> 
> That obviously desribes what the patch does, and I can learn the same
> thing by reading the patch, but it does not help anyone understand
> what the bug is, how the bug presents to the user, or if it this
> patch should be in -rc.
> 
> Jason

Sorry, I incorrectly labeled
"i40iw: Use sqsize to initialize cqp_requests elements" as
a bug fix. This will be deferred to for-next.

Additionally, the author is needed to re-evaluate the commit
description for following patch "i40iw: Reinitialize add_sd_cnt",
but is currently out this week. It will be removed from this patch
series and sent later.

I will send a new series shortly.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
