From: "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
Subject: Re: ioremap_uc() followed by set_memory_wc() - burrying MTRR
Date: Wed, 22 Apr 2015 01:39:07 +0200
Message-ID: <20150421233907.GA5622@wotan.suse.de>
References: <CALCETrV0B7rp08-VYjp5=1CWJp7=xTUTBYo3uGxX317RxAQT+w@mail.gmail.com>
 <20150421224601.GY5622@wotan.suse.de>
 <20150421225732.GA17356@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150421225732.GA17356-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, awalls-Xoej9cPu4Z+RGvkDC/A1pg@public.gmane.org, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Suresh Siddha <sbsiddha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Davidlohr Bueso <dbueso-l3A5Bk7waGM@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ville
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 21, 2015 at 04:57:32PM -0600, Jason Gunthorpe wrote:
> On Wed, Apr 22, 2015 at 12:46:01AM +0200, Luis R. Rodriguez wrote:
> 
> > are talking about annotating the qib driver as "known to be broken without PAT"
> > and since the ipath driver needs considerable work to be ported to
> > use PAT (the
> 
> This only seems to be true for one of the chips that driver supports,
> not all possibilities.
> 
> > userspace register is just one area) I wanted to review if we can just remove
> > MTRR use on the ipath driver and annotate write-combining with PAT as a TODO
> > item.
> 
> AFAIK, dropping MTRR support will completely break the performance to
> the point the driver is unusable. If we drop MTRR we may as well
> remove the driver.

To be clear, the arch_phys_wc_add() API will be a no-op when PAT is
enabled on a system. Although some folks think PAT is new, its not,
its just that our implementation on Linux lacked a bit of push, recent
changes however make PAT support complete and that means now we'll have
PAT enabled on systems that likely didn't before on recent kernels.

There are other important motivations to use PAT:

 * Xen won't work with MTRR, having a unified PAT enabled kernel
   will ensure that when Xen is used write-combinging will take
   effect

 * Long term we want to make strong UC the default to ioremap() on
   x86, right now its not, its UC-, we need to convert all drivers
   that want write-combining over to use ioremap_wc() for their
   specific area, and it must not overlap. There are issues with
   using mtrr_add() on regions marked as UC-, since its the default
   this  means that mtrr_add() use on ioramp'd areas on PAT systems
   will actually make write-combining *void*. Refer to this table
   for combinatorial effects for non-PAT / PAT of wc MTRR:

   https://marc.info/?l=linux-kernel&m=142964809710517&w=1

So as the train of PAT enablement moves forward it means systems
that have PAT enabled now might not have write-combining effective.
In order to get the best of both worlds, non-PAT and PAT systems
we must design drivers cleanly for the non-writecombining and
write-combining areas. This mean using ioremap_nocache() for MMIO
and ioremap_wc() *only* for the desired, write-combining area,
followed by arch_phys_wc_add().

> Mike, do you think the time is right to just remove the iPath driver?

With PAT now being default the driver effectively won't work
with write-combining on modern kernels. Even if systems are old
they likely had PAT support, when upgrading kernels PAT will work
but write-combing won't on ipath.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
