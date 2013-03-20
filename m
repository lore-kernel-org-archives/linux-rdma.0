From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [Fwd: Re: [PATCH] libibmad: Fixes for failures when not all
 ports of HCA are connected]
Date: Wed, 20 Mar 2013 13:02:08 -0600
Message-ID: <20130320190208.GA23478@obsidianresearch.com>
References: <5140E1A3.9070706@oracle.com>
 <51427819.7000505@oracle.com>
 <514278CA.8010809@oracle.com>
 <2807E5FD2F6FDA4886F6618EAC48510EBB3F62@CRSMSX102.amr.corp.intel.com>
 <514A0156.2070009@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <514A0156.2070009-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: brendan doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pramod Gunjikar <pramod.gunjikar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 20, 2013 at 06:35:02PM +0000, brendan doyle wrote:

> As far as I can see the library is not documented at all, I can't
> find any man pages. So setting errno is not breaking the interface,
> and I would argue that if it adds value, which it does in this case,
> then what is the objection. Additionally I think if the approach is
> that errno is not set unless documented in a man page, then we
> should have some consistency, a quick grep of errno in libibmad
> reveals that errno is being set in other parts of the library, in
> libibumad too, we see errno set, but again it is not documented in
> the umad man pages.

Ideally we would have consistency amongst the IB libraries - try hard
to return -ERRNO like verbs, and only use errno for cases where an int
return is not possible.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
