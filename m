From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 9/9] ib/addr: fix ipv6 routing lookup
Date: Mon, 23 Nov 2009 19:43:34 -0800
Message-ID: <89DF931E4E7549858A9BF7A31912F2F7@amr.corp.intel.com>
References: <2449CF17D7E94FCBA643A743473246A5@amr.corp.intel.com> <20091123194847.GL6188@obsidianresearch.com> <913F7AE25239487A9AF368E608F30A34@amr.corp.intel.com> <20091123222652.GM6188@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091123222652.GM6188-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>The sin6_scope_id must be ignored in all cases except LL
>addresses. Fixing this will break the path that sets the bound_dev_if
>starting from rdma_resolve_addr. This is why my version was setting
>bound_dev_if directly in rdma_resolve_addr.
>
>Did you change it to be like this because you found something wrong
>with the way things were in my big patch?

I was wanting to have all of the code paths go through rdma_bind_addr(), with
source address checks there to things as easy to follow as possible.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
