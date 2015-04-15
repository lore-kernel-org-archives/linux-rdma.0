From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: ioremap_uc() followed by set_memory_wc() - burrying MTRR
Date: Wed, 15 Apr 2015 13:42:47 -0700
Message-ID: <CALCETrV0B7rp08-VYjp5=1CWJp7=xTUTBYo3uGxX317RxAQT+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Suresh Siddha <sbsiddha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Andy Walls <awalls-Xoej9cPu4Z+RGvkDC/A1pg@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Davidlohr Bueso <dbueso-l3A5Bk7waGM@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <syrjala-ORSVBvAovxo@public.gmane.org>, Linux
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 13, 2015 at 10:49 AM, Luis R. Rodriguez <mcgrof-IBi9RG/b67k@public.gmane.org> wrote:

> c) ivtv: the driver does not have the PCI space mapped out separately, and
> in fact it actually does not do the math for the framebuffer, instead it lets
> the device's own CPU do that and assume where its at, see
> ivtvfb_get_framebuffer() and CX2341X_OSD_GET_FRAMEBUFFER, it has a get
> but not a setter. Its not clear if the firmware would make a split easy.
> We'd need ioremap_ucminus() here too and __arch_phys_wc_add().
>

IMO this should be conceptually easy to split.  Once we get the
framebuffer address, just unmap it (or don't prematurely map it) and
then ioremap the thing.

> From the beginning it seems only framebuffer devices used MTRR/WC, lately it
> seems infiniband drivers also find good use for for it for PIO TX buffers to
> blast some sort of data, in the future I would not be surprised if other
> devices found use for it.

IMO the Infiniband maintainers should fix their code.  Especially in
the server space, there aren't that many MTRRs to go around.  I wrote
arch_phys_wc_add in the first place because my server *ran out of
MTRRs*.

Hey, IB people: can you fix your drivers to use arch_phys_wc_add
(which is permitted to be a no-op) along with ioremap_wc?  Your users
will thank you.

> It may be true that the existing drivers that
> requires the above type of work are corner cases -- but I wouldn't hold my
> breath for that. The ivtv device is a good example of the worst type of
> situations and these days. So perhap __arch_phys_wc_add() and a
> ioremap_ucminus() might be something more than transient unless hardware folks
> get a good memo or already know how to just Do The Right Thing (TM).

I disagree.  We should try to NACK any new code that can't function
without MTRRs.

(Plus, ARM is growing in popularity in the server space, and ARM quite
sensibly doesn't have MTRRs.)

--Andy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
