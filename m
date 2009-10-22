From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Thu, 22 Oct 2009 10:39:04 -0600
Message-ID: <20091022163904.GC26003@obsidianresearch.com>
References: <4ACAF913.3050909@voltaire.com> <AA7E7C8FC2A04B9688CD69CEB7355DF8@amr.corp.intel.com> <15ddcffd0910071523w4f229b14j905ad170ceb8c21f@mail.gmail.com> <9F4DE6A2B4F644698E94F00C4FEEF30A@amr.corp.intel.com> <0A383504E0E54C949DEF84405E3AE92F@amr.corp.intel.com> <15ddcffd0910081633q20d98abfg41a9f4e781e486b1@mail.gmail.com> <859D79BFCA4741F393AABF76BBCA4F7B@amr.corp.intel.com> <4ADD8F5F.3010008@voltaire.com> <9F76F7CD7B9048E8821A1B05CC5FAFE8@amr.corp.intel.com> <4AE07D41.7040300@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AE07D41.7040300-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 22, 2009 at 05:41:53PM +0200, Or Gerlitz wrote:

> If from other reasons, people want the rdma-cm to support AF_IB and/or 
> PS_IB, we can do that as well, but why force doing that behind the cover 
> each time ACM is used?!

My view is that ultimately ACM has at best a niche application. The
various limitations with the approach are not suitable for many cases.
I also don't think it would be the final word on this subject.

So why not have a more general, flexible approach? Isolating ACM from
librdmacm by using AF_IB is a good idea, it keeps them seperate and
lets ACM and future go where ever.

I hope Sean can make it work with the rdma_getddrinfo idea, that would
completely seperate ACM and librdmacm.

Attempting to bake it into AF_INET means that librdmacm, possibly the
kernel and maybe even the apps need to be contaminated with ACM
specific code, and that just doesn't seem desirable to me. What
happens when someone invents BCM or CCM? More mess.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
