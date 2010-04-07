From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 26/37] librdmacm: set src_addr in rdma_getaddrinfo
Date: Wed, 7 Apr 2010 13:28:10 -0600
Message-ID: <20100407192810.GG15629@obsidianresearch.com>
References: <B7B5C575DF7D4C51AB84AFFAC7A5D5C5@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <B7B5C575DF7D4C51AB84AFFAC7A5D5C5-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 07, 2010 at 10:12:43AM -0700, Sean Hefty wrote:
> RDMA requires the user to allocate hardware resources before
> establishing a connection.  To support this, the user must know
> the source address that the connection will use to reach the
> remote endpoint.  Modify rdma_getaddrinfo to determine an
> appropriate source address based on the specified destination,
> when a source address is not given.

I haven't looked through everything you posted to make a suggestion
here, but this bothers me..

The resources should be allocated after the rdma_bind syscall, prior to
listen/accept or connect, IMHO.

How does tha rai->ai_src_addr get used to allocate resources anyhow?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
