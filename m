From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] rdma cm + XRC
Date: Tue, 10 Aug 2010 11:14:05 -0600
Message-ID: <20100810171405.GM11306@obsidianresearch.com>
References: <4C5331DC.9080109@systemfabricworks.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954BA1C@orsmsx501.amr.corp.intel.com> <4C618334.7010106@systemfabricworks.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954C0C2@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954C0C2-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 10, 2010 at 09:59:50AM -0700, Hefty, Sean wrote:

> > The general parameters would be the same as for RC. Should we create a new
> > ai_flag ? or a new port space ?
> 
> There's a ai_qp_type field available.  I think the RDMA TCP port
> space would work.

Not sure the port space matters at all?

Is there anything additional CM information for XRC other than
requesting an XRC QP type? (XRCSRQ or something?)

> > Is it really necessary to support rdma_getaddrinfo, rdma_create_ep and the
> > new APIs ?
> 
> I think so, yes.  At least XRC needs to be handled, even if some of
> the calls just fail as unsupported.

I'd like to see a strong rational for leaving any of the new API
unsupported for XRC - IMHO it should all be doable. The new API is
supposed to be simplifying, we want people to use it..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
