From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/7] libibverbs: Add link layer field port attribute
Date: Tue, 19 Jul 2011 13:50:20 -0600
Message-ID: <20110719195020.GE18090@obsidianresearch.com>
References: <alpine.LRH.2.00.1107191223460.5580@ogerlitz.voltaire.com>
 <alpine.LRH.2.00.1107191226210.5580@ogerlitz.voltaire.com>
 <20110719170454.GD18090@obsidianresearch.com>
 <CAJZOPZ+=3jr18x8Uxt73jAfT0bdPhntOez9dyZfmiHOF5REOSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJZOPZ+=3jr18x8Uxt73jAfT0bdPhntOez9dyZfmiHOF5REOSw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 19, 2011 at 10:36:26PM +0300, Or Gerlitz wrote:
> > What zeros the field in the current library?
> 
> the kernel uverbs code either zeros it (old kernels) or sets it (new kernels)

ibv_cmd_query_port does a field by field copy of the port_attr, so
what the kernel does is not relevant to this case, and to me it looks
like the new value you added will be left uninitialized on old ibverbs.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
