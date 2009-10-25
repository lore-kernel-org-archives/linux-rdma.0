From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Sun, 25 Oct 2009 12:50:28 -0600
Message-ID: <20091025185028.GM26003@obsidianresearch.com>
References: <15ddcffd0910071523w4f229b14j905ad170ceb8c21f@mail.gmail.com> <9F4DE6A2B4F644698E94F00C4FEEF30A@amr.corp.intel.com> <0A383504E0E54C949DEF84405E3AE92F@amr.corp.intel.com> <15ddcffd0910081633q20d98abfg41a9f4e781e486b1@mail.gmail.com> <859D79BFCA4741F393AABF76BBCA4F7B@amr.corp.intel.com> <4ADD8F5F.3010008@voltaire.com> <9F76F7CD7B9048E8821A1B05CC5FAFE8@amr.corp.intel.com> <4AE07D41.7040300@voltaire.com> <20091022163904.GC26003@obsidianresearch.com> <4AE4374B.6020104@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AE4374B.6020104-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 25, 2009 at 01:32:27PM +0200, Or Gerlitz wrote:
> Jason Gunthorpe wrote:
> >So why not have a more general, flexible approach? Isolating ACM from 
> >librdmacm by using AF_IB is a good idea, it keeps them seperate and lets 
> >ACM and future go where ever. I hope Sean can make it work with the 
> >rdma_getddrinfo idea, that would completely seperate ACM and librdmacm

> Generally speaking, AF_IB/PS_IB sounds okay to me, even though I am not 
> clear what applications are going to use it, maybe some examples please?

Again, my hope with the rdma_getaddrinfo idea is that apps using that
API get *all* the features with no additional code changes. Things
like GID addressing, ACM, etc all just exist under the
rdma_getaddrinfo API, so the apps don't care.

So, any time a *user* wants to use native IB features - APM, user path
selection, GID addressing, IB routing, etc - or users that want to
work with native IB labels for partitioning, QOS and IB routing.

> I don't agree, the only place where librdmacm goes to ACM is to resolve 
> DGID and a route. This can be done with rdma_getdgidinfo & 
> rdma_getrouteinfo if you like (maybe you do the implementation?), or

I would not be interested in such a poor API as a rdma_getdginfo, 
rdma_getrouteinfo. Such a design ignores the hard won lessons of
IP.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
