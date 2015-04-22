From: "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [PATCH v4 1/2] IB/qib: add acounting for MTRR
Date: Wed, 22 Apr 2015 17:28:21 +0200
Message-ID: <20150422152821.GC5622@wotan.suse.de>
References: <1429653035-19424-1-git-send-email-mcgrof@do-not-panic.com>
 <1429653035-19424-2-git-send-email-mcgrof@do-not-panic.com>
 <1429710292.45956.90.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1429710292.45956.90.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, infinipath@intel.com, roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, luto@amacapital.net, mst@redhat.com, linux-kernel@vger.kernel.org, cocci@systeme.lip6.fr, Toshi Kani <toshi.kani@hp.com>, Suresh Siddha <sbsiddha@gmail.com>, Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>, Juergen Gross <jgross@suse.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@redhat.com>, Antonino Daplas <adaplas@gmail.com>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 22, 2015 at 09:44:52AM -0400, Doug Ledford wrote:
> On Tue, 2015-04-21 at 14:50 -0700, Luis R. Rodriguez wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > 
> > There is no good reason not to, we eventually delete it as well.
> > 
> > Cc: Toshi Kani <toshi.kani@hp.com>
> > Cc: Suresh Siddha <sbsiddha@gmail.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Juergen Gross <jgross@suse.com>
> > Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> > Cc: Andy Lutomirski <luto@amacapital.net>
> > Cc: Dave Airlie <airlied@redhat.com>
> > Cc: Antonino Daplas <adaplas@gmail.com>
> > Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> > Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > Cc: Mike Marciniszyn <infinipath@intel.com>
> > Cc: Roland Dreier <roland@kernel.org>
> > Cc: Sean Hefty <sean.hefty@intel.com>
> > Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
> > Cc: linux-rdma@vger.kernel.org
> > Cc: linux-fbdev@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> > ---
> >  drivers/infiniband/hw/qib/qib_wc_x86_64.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/infiniband/hw/qib/qib_wc_x86_64.c b/drivers/infiniband/hw/qib/qib_wc_x86_64.c
> > index 81b225f..fe0850a 100644
> > --- a/drivers/infiniband/hw/qib/qib_wc_x86_64.c
> > +++ b/drivers/infiniband/hw/qib/qib_wc_x86_64.c
> > @@ -118,7 +118,7 @@ int qib_enable_wc(struct qib_devdata *dd)
> >  	if (!ret) {
> >  		int cookie;
> >  
> > -		cookie = mtrr_add(pioaddr, piolen, MTRR_TYPE_WRCOMB, 0);
> > +		cookie = mtrr_add(pioaddr, piolen, MTRR_TYPE_WRCOMB, 1);
> >  		if (cookie < 0) {
> >  			{
> >  				qib_devinfo(dd->pcidev,
> 
> Skip this patch please.  You remove this line entirely in your next
> patch, so this becomes a single kernel out of all possible bisectable
> kernels with this accounting enabled, and then the very next kernel does
> away with it.

No, the next patch uses accounting enabled as well, it also makes somse
other changes. This change is done in order to add accounting to match
the grammar used by arch_phys_wc_add() so it is in fact an atomic
comittiable and highly recommmended bisectable commit to be present.

> It makes no sense to have a single outlying bisectable
> kernel like that.

This is an atomic difference worth keeping record of.

  Luis
