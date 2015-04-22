From: "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [PATCH v4 2/2] IB/qib: use arch_phys_wc_add()
Date: Wed, 22 Apr 2015 19:37:28 +0200
Message-ID: <20150422173728.GJ5622@wotan.suse.de>
References: <1429653035-19424-1-git-send-email-mcgrof@do-not-panic.com>
 <1429653035-19424-3-git-send-email-mcgrof@do-not-panic.com>
 <1429710878.45956.94.camel@redhat.com>
 <20150422153348.GD5622@wotan.suse.de>
 <1429721838.45956.142.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1429721838.45956.142.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, infinipath@intel.com, roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, luto@amacapital.net, mst@redhat.com, linux-kernel@vger.kernel.org, cocci@systeme.lip6.fr, Toshi Kani <toshi.kani@hp.com>, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Roland Dreier <roland@purestorage.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Suresh Siddha <sbsiddha@gmail.com>, Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>, Juergen Gross <jgross@suse.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Antonino Daplas <adaplas@gmail.com>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>Dave
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 22, 2015 at 12:57:18PM -0400, Doug Ledford wrote:
> On Wed, 2015-04-22 at 17:33 +0200, Luis R. Rodriguez wrote:
> > On Wed, Apr 22, 2015 at 09:54:38AM -0400, Doug Ledford wrote:
> > > On Tue, 2015-04-21 at 14:50 -0700, Luis R. Rodriguez wrote:
> > > 
> > > This:
> > > > +	/* MTRR was used if this is non-zero */
> > > > +	if (!dd->wc_cookie)
> > > >  		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
> > > 
> > > And this:
> > > > +		dd->wc_cookie = arch_phys_wc_add(pioaddr, piolen);
> > > > +		if (dd->wc_cookie < 0)
> > > > +			ret = -EINVAL;
> > > 
> > > don't agree on what wc_cookie will be on error.
> > 
> > Can you elaborate? The one below is the one that starts things,
> > and arch_phys_wc_add() will return 0 on PAT systems. For non-PAT
> > systems it will return a number > 0 *iff* a valid MTRR was added.
> > It will return negative onloy on error then.
> > 
> > The change above is meant to replace a check put in place to see
> > if PAT was enabled. The way we replace this is to ensure that
> > arch_phys_wc_add() returned 0.
> > 
> > If you disagree it'd be great if you can elaborate why.
> 
> Maybe I'm missing something, but in qib_enable_wc() you store the return
> from arch_phys_wc_add into wc_cookie.  That return is negative,

If and only if the system was non-PAT and mtrr_add() failed.

>  so you
> return from qib_enable_wc() to qib_init_one(), they see the ret value,
> they print out a warning about bad performance, then they clear the
> return value and continue with device initialization.
> 
> In all of this though, wc_cookie is never cleared and so it still has
> the error condition in it.  Then, much later at run time, you call
> mmap_piobufs() and you check the contents of wc_cookie, and if it's
> non-0 (which is still will be), you do the wrong thing, right?

Originally the code had it to run pgprot_writecombine() if PAT was going to be
used. After the code changes we check for !cookie which will be true when
cookie is 0 only. In case the cookie was an error, that is if mtrr_add()
failed, then this code would not run because (!negative) is false. The goal was
to trigger a run if the cookie was 0, which can only happen if PAT was enabled.

Please let me know, I'd like to get this right too.

> And what
> about at shutdown when you call qib_disable_wc() and your cookie still
> has an error code in it as well?

Well fortunately arch_phys_wc_del(negative) and arch_phys_wc_del(0) will be
a no-op. Its what helps us remove so much clutter.

 Luis
