From: "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
Subject: Re: ioremap_uc() followed by set_memory_wc() - burrying MTRR
Date: Wed, 22 Apr 2015 00:46:01 +0200
Message-ID: <20150421224601.GY5622@wotan.suse.de>
References: <CALCETrV0B7rp08-VYjp5=1CWJp7=xTUTBYo3uGxX317RxAQT+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrV0B7rp08-VYjp5=1CWJp7=xTUTBYo3uGxX317RxAQT+w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Suresh Siddha <sbsiddha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Andy Walls <awalls-Xoej9cPu4Z+RGvkDC/A1pg@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Davidlohr Bueso <dbueso-l3A5Bk7waGM@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syr>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 15, 2015 at 01:42:47PM -0700, Andy Lutomirski wrote:
> On Mon, Apr 13, 2015 at 10:49 AM, Luis R. Rodriguez <mcgrof-IBi9RG/b67k@public.gmane.org> wrote:
> 
> > c) ivtv: the driver does not have the PCI space mapped out separately, and
> > in fact it actually does not do the math for the framebuffer, instead it lets
> > the device's own CPU do that and assume where its at, see
> > ivtvfb_get_framebuffer() and CX2341X_OSD_GET_FRAMEBUFFER, it has a get
> > but not a setter. Its not clear if the firmware would make a split easy.
> > We'd need ioremap_ucminus() here too and __arch_phys_wc_add().
> >
> 
> IMO this should be conceptually easy to split.  Once we get the
> framebuffer address, just unmap it (or don't prematurely map it) and
> then ioremap the thing.

Side note to ipath driver folks: as reviewed with Andy Walls, the
ivtv driver cannot easily be ported to use PAT so we are evaluating
simply removing write-combing from that driver on future kernels.

> 
> > From the beginning it seems only framebuffer devices used MTRR/WC, lately it
> > seems infiniband drivers also find good use for for it for PIO TX buffers to
> > blast some sort of data, in the future I would not be surprised if other
> > devices found use for it.
> 
> IMO the Infiniband maintainers should fix their code.  Especially in
> the server space, there aren't that many MTRRs to go around.  I wrote
> arch_phys_wc_add in the first place because my server *ran out of
> MTRRs*.
> 
> Hey, IB people: can you fix your drivers to use arch_phys_wc_add
> (which is permitted to be a no-op) along with ioremap_wc?  Your users

ipath driver maintainers:

The ipath driver is one of two drivers left to convert over to
arch_phys_wc_add(). MTRR use is being deprecated, and its use is actually
highly discouraged now that we have proper PAT implemenation on Linux. Since we
are talking about annotating the qib driver as "known to be broken without PAT"
and since the ipath driver needs considerable work to be ported to use PAT (the
userspace register is just one area) I wanted to review if we can just remove
MTRR use on the ipath driver and annotate write-combining with PAT as a TODO
item.

This would help a lot in our journey to bury MTRR use.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
