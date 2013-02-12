From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: interest in single core rdma library
Date: Tue, 12 Feb 2013 13:29:53 -0700
Message-ID: <20130212202953.GH1471@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A8237368B99DB4@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237368B99DB4-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 11, 2013 at 07:18:48PM +0000, Hefty, Sean wrote:
> I wanted to gauge if there was support or opposition in creating a single RDMA library, librdma.
> 
> The intent would be to construct a single library containing the
> core functionality -- data transfers, connection establishment, and
> subnet management -- required by most applications.  It could target
> combining libibverbs, librdmacm, and libibumad APIs.

If you are just going to combine all the existing APIs together, then
I'd say no..

If you want bring them all to some kind of common language (ie you can
open a port and use it interchangably for umad, rdamc, ucm, verbs
etc), then I think that is more interesting.

But there is so much code out there relying on the existing APIs??
Plus things like DAPL and CCI trying to be a generic API for rdma.

You might want to look at my python-rdma's 'rdma module', which is a
combined API for verbs and umad:

https://github.com/jgunthorpe/python-rdma

Where the unification mostly comprises using the same language/API for
talking about paths, end ports, devices and errors.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
