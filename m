From: "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v4 2/2] IB/qib: use arch_phys_wc_add()
Date: Wed, 22 Apr 2015 20:32:29 +0200
Message-ID: <20150422183229.GK5622@wotan.suse.de>
References: <1429653035-19424-1-git-send-email-mcgrof@do-not-panic.com>
 <1429653035-19424-3-git-send-email-mcgrof@do-not-panic.com>
 <1429710878.45956.94.camel@redhat.com>
 <20150422153348.GD5622@wotan.suse.de>
 <1429721838.45956.142.camel@redhat.com>
 <20150422173728.GJ5622@wotan.suse.de>
 <1429724907.45956.165.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1429724907.45956.165.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Luis R. Rodriguez" <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org>, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cocci-/FJkirnvOdkvYVN+rsErww@public.gmane.org, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Suresh Siddha <sbsiddha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Antonino Daplas <adaplas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>Dave
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 22, 2015 at 01:48:27PM -0400, Doug Ledford wrote:
> On Wed, 2015-04-22 at 19:37 +0200, Luis R. Rodriguez wrote:
> > On Wed, Apr 22, 2015 at 12:57:18PM -0400, Doug Ledford wrote:
> > > On Wed, 2015-04-22 at 17:33 +0200, Luis R. Rodriguez wrote:
> > > > On Wed, Apr 22, 2015 at 09:54:38AM -0400, Doug Ledford wrote:
> > > > > On Tue, 2015-04-21 at 14:50 -0700, Luis R. Rodriguez wrote:
> > > > > 
> > > > > This:
> > > > > > +	/* MTRR was used if this is non-zero */
> > > > > > +	if (!dd->wc_cookie)
> > > > > >  		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
> > > > > 
> > > > > And this:
> > > > > > +		dd->wc_cookie = arch_phys_wc_add(pioaddr, piolen);
> > > > > > +		if (dd->wc_cookie < 0)
> > > > > > +			ret = -EINVAL;
> > > > > 
> > > > > don't agree on what wc_cookie will be on error.
> > > > 
> > > > Can you elaborate? The one below is the one that starts things,
> > > > and arch_phys_wc_add() will return 0 on PAT systems. For non-PAT
> > > > systems it will return a number > 0 *iff* a valid MTRR was added.
> > > > It will return negative onloy on error then.
> > > > 
> > > > The change above is meant to replace a check put in place to see
> > > > if PAT was enabled. The way we replace this is to ensure that
> > > > arch_phys_wc_add() returned 0.
> > > > 
> > > > If you disagree it'd be great if you can elaborate why.
> > > 
> > > Maybe I'm missing something, but in qib_enable_wc() you store the return
> > > from arch_phys_wc_add into wc_cookie.  That return is negative,
> > 
> > If and only if the system was non-PAT and mtrr_add() failed.
> > 
> > >  so you
> > > return from qib_enable_wc() to qib_init_one(), they see the ret value,
> > > they print out a warning about bad performance, then they clear the
> > > return value and continue with device initialization.
> > > 
> > > In all of this though, wc_cookie is never cleared and so it still has
> > > the error condition in it.  Then, much later at run time, you call
> > > mmap_piobufs() and you check the contents of wc_cookie, and if it's
> > > non-0 (which is still will be), you do the wrong thing, right?
> > 
> > Originally the code had it to run pgprot_writecombine() if PAT was going to be
> > used. After the code changes we check for !cookie which will be true when
> > cookie is 0 only. In case the cookie was an error, that is if mtrr_add()
> > failed, then this code would not run because (!negative) is false. The goal was
> > to trigger a run if the cookie was 0, which can only happen if PAT was enabled.
> 
> OK, the logic works, but as much as anything, it's the comment that's
> misleading.  The code would be clearer with a comment like this:
> 
> /* We used PAT if wc_cookie == 0 */
> if (!dd->wc_cookie) {
> 
> That would be more accurate as well since the original comment didn't
> account for the possible error code in wc_cookie, so it's possible you
> didn't use either PAT or wc if you have that error code.

Fair enough, will send a v5 follow up with the comment enhanced,
but will leave the first patch in this series as-is.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
