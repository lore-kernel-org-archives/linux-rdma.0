From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 26/37] librdmacm: set src_addr in rdma_getaddrinfo
Date: Wed, 7 Apr 2010 15:10:36 -0700
Message-ID: <569EDABAE9F84A029ED7AC84AA5767D6@amr.corp.intel.com>
References: <B7B5C575DF7D4C51AB84AFFAC7A5D5C5@amr.corp.intel.com> <20100407192810.GG15629@obsidianresearch.com> <4BAFD82633A744729F9685D44B250100@amr.corp.intel.com> <20100407201417.GJ15629@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100407201417.GJ15629-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>I don't have a problem with ai_src_addr being set, when necessary, but
>setting it unconditionally seems wrong to me. In most cases the kernel
>should select the source during route resolution, not be forced to
>something in userspace.

Just to be precise, the source is selected during address resolution, and the
existing APIs allow the user to indicate that a specific source should be used.

This is a requirement of some applications.

>Not sure what you mean that ACM requires it? Doesn't ACM plug in at
>the rdma_getaddrinfo stage? If so it can get the source on its own
>like you did in this patch. I agree that ACM should always return
>results with the source set, because it is providing path records
>relative to a specific adaptor.

Yes - the code to set the source could move from librdmacm into ACM.

I can change rdma_getaddrinfo to only set the source address if either the user
provides one through a hint, or if resolved through ACM.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
