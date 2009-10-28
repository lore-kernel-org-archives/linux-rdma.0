From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH RDMA] Fixup IPv6 support and IPv4 routing corner cases for	RDMA CM
Date: Wed, 28 Oct 2009 01:08:33 -0700
Message-ID: <4E89386C612E46C9A33501CEC2521BAF@amr.corp.intel.com>
References: <20091028054253.GA22882@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091028054253.GA22882-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, leo.tominna-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Here is how I think this should all go. I can't steal some machines to
>test it right now (prolly can't till after SC|09), but David/Sean maybe
>you can have a look at it?

I will try to test it some this week.

>AH, there is still another oopsie I just noticed, rdma_resolve_addr
>does not check that dst_addr and src_addr are the same AF

I was actually considering making use of this to allow AF_INET or AF_INET6 to
communicate with AF_IB.  There's not a protocol limitation to supporting this.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
