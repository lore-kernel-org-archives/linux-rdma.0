From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: EINVAL when INIT -> RTR on RoCE
Date: Thu, 26 Jul 2012 11:44:37 -0600
Message-ID: <20120726174437.GC7596@obsidianresearch.com>
References: <B2CAB3C7-6049-4B8B-90C1-9DD2180857EE@gmail.com>
 <CAL1RGDUEMiuNKBjShYUmj2OTAS=YDGgpK7d5Li090r2ot8VanQ@mail.gmail.com>
 <CAL1RGDUsk2YV4GwYF7doina+bDGqw6VAHAEajJ7Qg7PJhF6aew@mail.gmail.com>
 <F0AFA058-856F-48A0-99A1-2FB5398B31B6@gmail.com>
 <2159AA50-F259-4963-BAB3-C300171C37BE@gmail.com>
 <20120726171043.GA7596@obsidianresearch.com>
 <CEED54B9-B3F4-4D7D-92DF-9314059FFC02@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CEED54B9-B3F4-4D7D-92DF-9314059FFC02-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "\"Xavier R. Gu?rin\"" <guerinx-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 26, 2012 at 01:38:03PM -0400, "Xavier R. Gu?rin" wrote:

> > It is the source GID of the local adaptor. Generally you can just use
> > index 0, particularly on RoCEE..
> 
> thanks, this fixed my problem.
> 
> A couple questions:
> 
> is there any overhead associated with using GIDs?

Yes, the GRH adds an extra 40 bytes per packet, so it should be
avoided on IB. It is mandatory on RoCEE.

> man ibv_post_recv tells me that the GRH is written into the first 40
> bytes of the receive buffer for UD QPs. Is that behavior only
> restricted to UD QPs, or should I plan the presence of this headers
> when using RC QPs ?

Yes, only for UD QPs, and the 40 bytes is always reserved for the GRH,
even if the packet had none.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
