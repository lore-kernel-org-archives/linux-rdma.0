From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: ioremap_uc() followed by set_memory_wc() - burrying MTRR
Date: Wed, 22 Apr 2015 10:17:55 -0600
Message-ID: <20150422161755.GA19500@obsidianresearch.com>
References: <CALCETrV0B7rp08-VYjp5=1CWJp7=xTUTBYo3uGxX317RxAQT+w@mail.gmail.com>
 <20150421224601.GY5622@wotan.suse.de>
 <20150421225732.GA17356@obsidianresearch.com>
 <20150421233907.GA5622@wotan.suse.de>
 <20150422053939.GA29609@obsidianresearch.com>
 <20150422152328.GB5622@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150422152328.GB5622-B4tOwbsTzaBolqkO4TVVkw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, awalls-Xoej9cPu4Z+RGvkDC/A1pg@public.gmane.org, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Suresh Siddha <sbsiddha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Davidlohr Bueso <dbueso-l3A5Bk7waGM@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ville
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 22, 2015 at 05:23:28PM +0200, Luis R. Rodriguez wrote:
> On Tue, Apr 21, 2015 at 11:39:39PM -0600, Jason Gunthorpe wrote:
> > On Wed, Apr 22, 2015 at 01:39:07AM +0200, Luis R. Rodriguez wrote:
> > > > Mike, do you think the time is right to just remove the iPath driver?
> > > 
> > > With PAT now being default the driver effectively won't work
> > > with write-combining on modern kernels. Even if systems are old
> > > they likely had PAT support, when upgrading kernels PAT will work
> > > but write-combing won't on ipath.
> > 
> > Sorry, do you mean the driver already doesn't get WC? Or do you mean
> > after some more pending patches are applied?
> 
> No, you have to consider the system used and the effects of calls used
> on the driver in light of this table:

So, just to be clear:

At some point Linux started setting the PAT bits during
ioremap_nocache, which overrides MTRR, and at that point the driver
became broken on all PAT capable systems?

Not only that, but we've only just noticed it now, and no user ever
complained?

So that means either no users exist, or all users are on non-PAT
systems?

This driver only works on x86-64 systems. Are there any x86-64 systems
that are not PAT capable? IIRC even the first Opteron had PAT, but my
memory is fuzzy from back then :|

> Another option in order to enable this type of checks at run time
> and still be able to build the driver on standard distributions and
> just prevent if from loading on PAT systems is to have some code in
> place which would prevent the driver from loading if PAT was
> enabled, this would enable folks to disable PAT via a kernel command
> line option, and if that was used then the driver probe would
> complete.

This seems like a reasonble option to me. At the very least we might
learn if anyone is still using these cards.

I'd also love to remove the driver if it turns out there are actually
no users. qib substantially replaces it except for a few very old
cards.

Mike?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
