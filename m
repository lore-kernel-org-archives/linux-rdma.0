From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 26/37] librdmacm: set src_addr in rdma_getaddrinfo
Date: Wed, 7 Apr 2010 16:22:11 -0600
Message-ID: <20100407222211.GK15629@obsidianresearch.com>
References: <B7B5C575DF7D4C51AB84AFFAC7A5D5C5@amr.corp.intel.com> <20100407192810.GG15629@obsidianresearch.com> <4BAFD82633A744729F9685D44B250100@amr.corp.intel.com> <20100407201417.GJ15629@obsidianresearch.com> <569EDABAE9F84A029ED7AC84AA5767D6@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <569EDABAE9F84A029ED7AC84AA5767D6-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 07, 2010 at 03:10:36PM -0700, Sean Hefty wrote:

> >Not sure what you mean that ACM requires it? Doesn't ACM plug in at
> >the rdma_getaddrinfo stage? If so it can get the source on its own
> >like you did in this patch. I agree that ACM should always return
> >results with the source set, because it is providing path records
> >relative to a specific adaptor.
> 
> Yes - the code to set the source could move from librdmacm into ACM.
> 
> I can change rdma_getaddrinfo to only set the source address if
> either the user provides one through a hint, or if resolved through
> ACM.

That would be my preference. I think the kernel calls should use a
null source address in the common case and a set source should be an
exceptional case. This matches sockets very well.

I'd see two cases for setting a source address, an app that wants to
control the bind port - this is similar to socket cases, and is
generally an exceptional case.

The other is that an app wants the connection to be usable with a
certain PD. This is more like the DAPL case, as far as I understand it
(ie resources have been allocated against a PD prior to the addresses
being known). This would be best served by having the hints include a
PD and have rdma_getaddrinfo generate a source address that works with
that PD. A PD is more general than a source address - in single HCA
cases a PD will be usable with all ports.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
