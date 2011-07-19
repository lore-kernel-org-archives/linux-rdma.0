From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/7] libibverbs: Add link layer field port attribute
Date: Tue, 19 Jul 2011 15:39:02 -0600
Message-ID: <20110719213902.GH18090@obsidianresearch.com>
References: <alpine.LRH.2.00.1107191223460.5580@ogerlitz.voltaire.com>
 <alpine.LRH.2.00.1107191226210.5580@ogerlitz.voltaire.com>
 <20110719170454.GD18090@obsidianresearch.com>
 <CAJZOPZ+=3jr18x8Uxt73jAfT0bdPhntOez9dyZfmiHOF5REOSw@mail.gmail.com>
 <20110719195020.GE18090@obsidianresearch.com>
 <CAJZOPZ+2S=agGurUC6393e7mqQy4Ob1jaseeoWxeZe2Yu-kCLg@mail.gmail.com>
 <20110719203140.GG18090@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373136EFE8F@ORSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373136EFE8F-P5GAC/sN6hlcIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 19, 2011 at 09:20:25PM +0000, Hefty, Sean wrote:
> > More clearly: what initializes the memory you've redefined to be
> > link_layer in libibverbs 1.1.5 ? I see nothing.
> 
> Why does the value in an older library cause an issue?

ABI compatability means if dynamic linking succeeds then the result
works, so the behavior of a new app, using new functionality when it
links to the old library must work.

The commit comment states the goal is to have new apps see
IBV_LINK_LAYER_UNSPECIFIED for all possible combinations of old stuff
underneath.

> Or, how will this library version interact with an older kernel?

The kernel interaction is not what I'm talking about - AFAIK, the
kernel interaction is OK. Old kernels zero the entire ib_port_attr
structure before copy_to_user so the reserved bytes are guaranteed to
be 0.

The problem is with the userspace ABI out of libibverbs. Current
libibverbs does not zero its ib_port_attr structure before returning.

Build this with Or's patch applied, then run it against libibverbs 1.1.5

 struct ibv_port_attr attr;
 attr.link_layer = 100;
 ibv_query_port(..,&attr);
 assert(attr.link_layer == IBV_LINK_LAYER_UNSPECIFIED); // Fails!

That is an ABI breaking issue that is not dealt with by Or's patch.

Couple choices:
 1) Require and document callers using ibv_query_port to zero attr
    before hand when using link_layer
 2) Crank the symbol version on ibv_query_port so dynamic linking
    fails
 3) Inline the memset in ibverbs.h:

    static inline int fixed_ibv_query_port(...)
    {
       attr->link_layer = 0;
       return ibv_query_port(...);
    }
    #define ibv_query_port(...) fixed_ibv_query_port(...)

#2 might be the best?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
