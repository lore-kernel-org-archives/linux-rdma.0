From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: interest in single core rdma library
Date: Tue, 12 Feb 2013 15:43:39 -0700
Message-ID: <20130212224339.GC31555@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A8237368B99DB4@ORSMSX101.amr.corp.intel.com>
 <20130212202953.GH1471@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A8237368B9A190@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237368B9A190-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 12, 2013 at 10:30:47PM +0000, Hefty, Sean wrote:
> > > The intent would be to construct a single library containing the
> > > core functionality -- data transfers, connection establishment, and
> > > subnet management -- required by most applications.  It could target
> > > combining libibverbs, librdmacm, and libibumad APIs.
> > 
> > If you are just going to combine all the existing APIs together, then
> > I'd say no..
> 
> Thanks for the input.
> 
> I wasn't wanting to change the APIs (or require app changes to be
> more precise).  Adding or extending APIs is a possibility, but in
> the short term I'm more interested in reducing maintenance costs,
> while making things simpler for users.

It might be worthwile to combine *source* repositories, keeping the
library build products exactly the same, but if you do that I'd pull
in the provider drivers too.

There is a lot of duplicity in the build systems and what not to
support what is in many cases one or two .c files.

Especially if you could get people to broadly agree on a bit of a
'maintainer team' concept for the lot of it?

FWIW, it is a huge pain to build enough of the RDMA libraries from
scratch to get a working system. I have a script for it someplace, and
it is long.. A single 'git clone' './configure' 'make' to have a
working core user space would be wonderful.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
