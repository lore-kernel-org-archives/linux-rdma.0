From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RDMA] Fixup IPv6 support and IPv4 routing corner cases for	RDMA CM
Date: Wed, 28 Oct 2009 10:50:43 -0600
Message-ID: <20091028165043.GD1966@obsidianresearch.com>
References: <20091028054253.GA22882@obsidianresearch.com> <4E89386C612E46C9A33501CEC2521BAF@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4E89386C612E46C9A33501CEC2521BAF-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, leo.tominna-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 28, 2009 at 01:08:33AM -0700, Sean Hefty wrote:
> >Here is how I think this should all go. I can't steal some machines to
> >test it right now (prolly can't till after SC|09), but David/Sean maybe
> >you can have a look at it?
> 
> I will try to test it some this week.

Thanks, probably won't work right away, but I feel it is closer..

Do you have any idea about the ARP things? Is whoever did this
originally still around?

> >AH, there is still another oopsie I just noticed, rdma_resolve_addr
> >does not check that dst_addr and src_addr are the same AF
> 
> I was actually considering making use of this to allow AF_INET or AF_INET6 to
> communicate with AF_IB.  There's not a protocol limitation to supporting this.

Hum.. Not sure how that would work? src = AF_INET, dst = AF_IB?

I guess I was hoping you'd be able to do the private data in userspace
and avoid those kind of special cases..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
