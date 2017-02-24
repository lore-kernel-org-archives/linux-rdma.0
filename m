From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] libibmad: Fix conflict with new umad.h header
Date: Fri, 24 Feb 2017 14:55:40 -0700
Message-ID: <20170224215540.GA29289@obsidianresearch.com>
References: <1487914827-339-1-git-send-email-ira.weiny@intel.com>
 <20170224182449.GE22491@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510E67C5743A@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E67C5743A-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 24, 2017 at 09:23:26PM +0000, Weiny, Ira wrote:
> 
> Perhaps...
> 
> The question is do you want to rely on BSD or gnu extensions?  My
> reading of the various man pages leads me to the same path as you.
> That the BSD htobe* has become the standard in glibc.

If you go down that rat hole then __BYTE_ORDER__ isn't portable
either..

Which ever you choose, both places should use an identical construct,
introducing two different definitions is evil.

bswap_64 is a tiny bit better because it does not rely on __USE_MISC
which means the public header might compile with -std=c11/-ansi/etc

However I did a little check and some of our public headers already do
not support that mode...

So my conclusion was to go with the simple solution, and mark it
deprecated so we can remove it some day and avoid this worry.

I guess it could get wrappered in '#ifdef htobe64' though - then it
would still support -ansi mode.

> > > +#define ntohll(x) x
> > 
> > missing () around the x.
> 
> Yea missed that...

It is also problematic in that it doesn't force the output to a
consistent 64 bit type, so big/little builds get different types which
is never fun.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
