From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Thu, 8 Oct 2009 18:33:03 -0600
Message-ID: <20091009003303.GA5191@obsidianresearch.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com> <F451C333D8CB45E4B4642C6BD1EDD3C3@amr.corp.intel.com> <4ACAF913.3050909@voltaire.com> <AA7E7C8FC2A04B9688CD69CEB7355DF8@amr.corp.intel.com> <15ddcffd0910071523w4f229b14j905ad170ceb8c21f@mail.gmail.com> <9F4DE6A2B4F644698E94F00C4FEEF30A@amr.corp.intel.com> <0A383504E0E54C949DEF84405E3AE92F@amr.corp.intel.com> <15ddcffd0910081633q20d98abfg41a9f4e781e486b1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <15ddcffd0910081633q20d98abfg41a9f4e781e486b1-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 09, 2009 at 01:33:56AM +0200, Or Gerlitz wrote:

> However, I don't manage to follow on your port space discussion with
> Jason. Some apps may have client in user space and server in the
> kernel or vise versa. I wouldn't tie PS_IB or a like with ACM. The ACM
> ARP replacement protocol will reply only if the ip address specified
> in the broadcast request is an ip of this host on that pkey and a port
> connected to that fabric, correct?

The PS and sockaddr type are linked together, it makes no sense to use
a PS_TCP and a sockaddr_ib together - sockaddr_ib doesn't have a port
number, or IP address.

So AF_GID/IB must also use PS_IB.

The real complex question is if the scheme should have a transparent
way for something like rdma_get_addr_info to return a description that
uses PS_IB but sets things up to be compatible with a PS_TCP listener.

It would be easy to do this..

I really don't know, bypassing the IP stack so completely is really
not a great idea from an administration standpoint..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
