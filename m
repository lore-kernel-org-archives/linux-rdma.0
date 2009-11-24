From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 9/9] ib/addr: fix ipv6 routing lookup
Date: Mon, 23 Nov 2009 23:56:58 -0700
Message-ID: <20091124065658.GH1966@obsidianresearch.com>
References: <2449CF17D7E94FCBA643A743473246A5@amr.corp.intel.com> <20091123194847.GL6188@obsidianresearch.com> <913F7AE25239487A9AF368E608F30A34@amr.corp.intel.com> <20091123222652.GM6188@obsidianresearch.com> <89DF931E4E7549858A9BF7A31912F2F7@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <89DF931E4E7549858A9BF7A31912F2F7-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 23, 2009 at 07:43:34PM -0800, Sean Hefty wrote:
> >The sin6_scope_id must be ignored in all cases except LL
> >addresses. Fixing this will break the path that sets the bound_dev_if
> >starting from rdma_resolve_addr. This is why my version was setting
> >bound_dev_if directly in rdma_resolve_addr.
> >
> >Did you change it to be like this because you found something wrong
> >with the way things were in my big patch?
> 
> I was wanting to have all of the code paths go through rdma_bind_addr(), with
> source address checks there to things as easy to follow as possible.

OK. Then I'll send a patch to do it the other way, processing
sin6_scope_id for the non-link-local case is worth fixing.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
