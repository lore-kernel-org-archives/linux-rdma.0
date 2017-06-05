From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/6] IB/uverbs: Enable QP creation which is
 associated to underlay QP
Date: Mon, 5 Jun 2017 09:26:24 -0600
Message-ID: <20170605152624.GB20182@obsidianresearch.com>
References: <20170530071602.8139-1-leon@kernel.org>
 <20170530071602.8139-3-leon@kernel.org>
 <20170530073352.GA1838@nanopsycho>
 <1496583794.7171.134.camel@redhat.com>
 <20170604135122.GC1910@nanopsycho.orion>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170604135122.GC1910-6KJVSR23iU488b5SBfVpbw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Pirko <jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jun 04, 2017 at 03:51:22PM +0200, Jiri Pirko wrote:

> I understand all the reasons why this breakage should not cause any
> harm, don't get me wrong Doug. It's just, it is a breakage, no matter
> how pink you paint it :) Either the uapi is guaranteed to be backward
> compatible, or not. Nothing in between. Just saying...

The uapi is *binary* compatible, not necessarily source compatible at
the kernel header level, which is something we have been willing to
accept.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
