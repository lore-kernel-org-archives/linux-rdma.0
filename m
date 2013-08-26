From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Handling incoming RDMA CM connections when there is more than
 one IB HCA in a system
Date: Mon, 26 Aug 2013 13:35:33 -0600
Message-ID: <20130826193533.GB20192@obsidianresearch.com>
References: <CACyXjPzPJ=cZ1WkjYJ_o_4uLE50mn-TX93Answz7nw2rn619-Q@mail.gmail.com>
 <20130826174844.GD12296@obsidianresearch.com>
 <CACyXjPxyU6LO_31EVf9D_CwsX-aohEh_UbAQx97jJFh6PaLfgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACyXjPxyU6LO_31EVf9D_CwsX-aohEh_UbAQx97jJFh6PaLfgw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 26, 2013 at 12:17:11PM -0700, Richard Sharpe wrote:
> > From what I read about the SMB protocol it looks completely valid to
> > bypass the TCP first stage and go directly to RDMA. Or go from TCP to
> > TCP, or RDMA to TCP, or whatever.
> 
> Microsoft tells me that they never do an RDMA-only connection. It is
> always TCP first then RDMA.

Sure, but the SMB protocol allows for more than just that one case. Be
careful not to architect yourself into a corner that can't do things
allowed by the spec, but not performed by clients of the day..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
