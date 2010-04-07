From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 26/37] librdmacm: set src_addr in rdma_getaddrinfo
Date: Wed, 7 Apr 2010 14:14:17 -0600
Message-ID: <20100407201417.GJ15629@obsidianresearch.com>
References: <B7B5C575DF7D4C51AB84AFFAC7A5D5C5@amr.corp.intel.com> <20100407192810.GG15629@obsidianresearch.com> <4BAFD82633A744729F9685D44B250100@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4BAFD82633A744729F9685D44B250100-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 07, 2010 at 12:54:56PM -0700, Sean Hefty wrote:
> >I haven't looked through everything you posted to make a suggestion
> >here, but this bothers me..
> >
> >The resources should be allocated after the rdma_bind syscall, prior to
> >listen/accept or connect, IMHO.
> >
> >How does tha rai->ai_src_addr get used to allocate resources anyhow?
> 
> Maybe the patch description is off.
> 
> All this does (in a very non-sexy way) is set ai_src_addr.  It does
> not allocate any hardware resources.  A user can provide ai_src_addr
> as input into rdma_bind or rdma_resolve_addr.
> 
> The motivation is twofold.  First, the user can select the
> rdma_addrinfo for a connection by examining the src/dst address
> pair.  This may be desired for failover or performance reasons.
> Second, route resolution may require knowing both the source and
> destination addresses.  For example, IB ACM requires both addresses
> as input.

Huumm

I don't have a problem with ai_src_addr being set, when necessary, but
setting it unconditionally seems wrong to me. In most cases the kernel
should select the source during route resolution, not be forced to
something in userspace.

Certainly for AF_INET/6 I don't think this should be done..

Apps doing complex things for failover should supply a source address
in the hints and call rdma_getaddrinfo for each adaptor.

AF_IB has the scope ID in the destination to specify the adaptor for
link-local GIDs, so the source should not often be needed.

Not sure what you mean that ACM requires it? Doesn't ACM plug in at
the rdma_getaddrinfo stage? If so it can get the source on its own
like you did in this patch. I agree that ACM should always return
results with the source set, because it is providing path records
relative to a specific adaptor.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
