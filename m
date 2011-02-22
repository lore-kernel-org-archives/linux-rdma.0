From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 0/2] Improved node descriptions
Date: Tue, 22 Feb 2011 16:43:04 -0700
Message-ID: <20110222234304.GA21731@obsidianresearch.com>
References: <20110217213017.25708.95042.stgit@homer>
 <AANLkTim5MrHMVjaNFtHeWBy82dag4XNxdBcjBEW+d1yb@mail.gmail.com>
 <20110219192458.GB4506@obsidianresearch.com>
 <4C2744E8AD2982428C5BFE523DF8CDCB4A20B28B17@MNEXMB1.qlogic.org>
 <AANLkTi=1rmRckZz1iAXLpakf5bMuBp4koGOyO-FUDz_M@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTi=1rmRckZz1iAXLpakf5bMuBp4koGOyO-FUDz_M-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 22, 2011 at 03:13:47PM -0800, Roland Dreier wrote:
> On Mon, Feb 21, 2011 at 11:26 AM, Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org> wrote:
> > The biggest problem with that is that patching existing boot scripts
> > is always going to vary from distro to distro and is always going to
> > have problems when dealing with files that were already edited for
> > site-specific reasons.
> 
> This is the wrong way to look at it.  Really it would make sense in
> the long term to add required support to native distros -- piling hack
> on hack in OFED is clearly a long-term disaster.  So I don't think
> saying "it's hard to make a single RPM" is a very good argument.

Indeed, considering that OFEDs entire purpose is to manage packaging
IB stuff for distributions this doesn't seem like a good argument..
Nor do I think OFED should even try to have one RPM for all distros,
good packaging isn't like that.

> In this case I do think it makes sense to add this support to the
> kernel, since the kernel handling is so simple.  In fact based on
> Jack's question it might make sense to go further and have more
> flexible expansion... what if we do something like adding primitive
> format expansion, ie

Doing it in userspace makes generating the node description changed
trap simpler?

What about other drivers? I didn't see ehca in Mike's patch..

I just wonder if this is a big pain to do right, what about charsets, IDN,
and ugly details like that?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
