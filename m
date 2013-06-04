From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibverbs v6 3/7] livibverbs: Add support for XRC SRQs
Date: Tue, 4 Jun 2013 15:59:10 -0600
Message-ID: <20130604215910.GA5733@obsidianresearch.com>
References: <1370371791-15018-1-git-send-email-sean.hefty@intel.com>
 <1370371791-15018-4-git-send-email-sean.hefty@intel.com>
 <20130604204859.GA30182@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A823736FD2CF92@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736FD2CF92-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 04, 2013 at 09:44:24PM +0000, Hefty, Sean wrote:
> > >  enum verbs_context_mask {
> > >  	VERBS_CONTEXT_XRCD	= 1 << 0,
> > > -	VERBS_CONTEXT_RESERVED	= 1 << 1
> > > +	VERBS_CONTEXT_SRQ	= 1 << 1,
> > > +	VERBS_CONTEXT_RESERVED	= 1 << 2
> > >  };
> > 
> > Why is _RESERVED being re-numbered here? That worries me..
> > 
> > For that matter, what is it for?
> 
> I called it reserved, you can call it max.  It's to let libibverbs guard against vendor libraries built against future versions of the library, but run against an older one, using something like this:
> 
> 	if (mask >= VERBS_CONTEXT_RESERVED)
> 		abort...

Hurm, doesn't sound great, all this complexity is trying to avoid
aborts.

Better to have the driver set the things it supports during init, and
the have verbs mask off the things it doesn't support, so that the
result is what both verbs and the driver supports.

If the driver has a problem with missing verbs support then it should
deal with it internally. I expect in most cases it isn't an issue
since this is just structure over-allocation..

> > Frankly, I would ditch mask for verbs_context op members and other
> > structures that are size based. What does it mean if the size includes
> > get_srq_num, but VERBS_CONTEXT_SRQ is 0 and *get_srq_num is
> > null/non-null?
> 
> These mask values indicate to libibverbs that it can cast from
> struct ibv_* to struct verbs_*.

Okay, that make sense, but verbs_xrcd and verbs_srq don't have an ibv
counterpart, so these constants are never used?

A comment would help, and 'verbs_context_mask' is a poor name. It
looks like the usual comp_mask stuff applied to the structure it is
in.

verbs_supported_extended or something??

> > > @@ -103,4 +103,6 @@ IBVERBS_1.1 {
> > >
> > >  		ibv_cmd_open_xrcd;
> > >  		ibv_cmd_close_xrcd;
> > > +		ibv_cmd_create_srq_ex;
> > > +
> > >  } IBVERBS_1.0;
> > 
> > Hum, so drivers that implement XRC will need to be paired with a new
> > verbs... Bit disappointing, did we want to try and address that?
> 
> The extensions were added specifically to handle XRC.

At one point there was a desire to have the drivers able to work with
a range of ibverbs, if the driver links to these symbols then it will
only dynamic link with the latest ibverbs.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
