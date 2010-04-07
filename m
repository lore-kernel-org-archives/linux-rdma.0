From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 26/37] librdmacm: set src_addr in rdma_getaddrinfo
Date: Wed, 7 Apr 2010 12:54:56 -0700
Message-ID: <4BAFD82633A744729F9685D44B250100@amr.corp.intel.com>
References: <B7B5C575DF7D4C51AB84AFFAC7A5D5C5@amr.corp.intel.com> <20100407192810.GG15629@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100407192810.GG15629-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>I haven't looked through everything you posted to make a suggestion
>here, but this bothers me..
>
>The resources should be allocated after the rdma_bind syscall, prior to
>listen/accept or connect, IMHO.
>
>How does tha rai->ai_src_addr get used to allocate resources anyhow?

Maybe the patch description is off.

All this does (in a very non-sexy way) is set ai_src_addr.  It does not allocate
any hardware resources.  A user can provide ai_src_addr as input into rdma_bind
or rdma_resolve_addr.

The motivation is twofold.  First, the user can select the rdma_addrinfo for a
connection by examining the src/dst address pair.  This may be desired for
failover or performance reasons.  Second, route resolution may require knowing
both the source and destination addresses.  For example, IB ACM requires both
addresses as input.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
