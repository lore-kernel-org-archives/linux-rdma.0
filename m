From: "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: ioremap_uc() followed by set_memory_wc() - burrying MTRR
Date: Wed, 22 Apr 2015 17:23:28 +0200
Message-ID: <20150422152328.GB5622@wotan.suse.de>
References: <CALCETrV0B7rp08-VYjp5=1CWJp7=xTUTBYo3uGxX317RxAQT+w@mail.gmail.com>
 <20150421224601.GY5622@wotan.suse.de>
 <20150421225732.GA17356@obsidianresearch.com>
 <20150421233907.GA5622@wotan.suse.de>
 <20150422053939.GA29609@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150422053939.GA29609@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Andy Lutomirski <luto@amacapital.net>, mike.marciniszyn@intel.com, infinipath@intel.com, linux-rdma@vger.kernel.org, awalls@md.metrocast.net, Toshi Kani <toshi.kani@hp.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Suresh Siddha <sbsiddha@gmail.com>, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Roland Dreier <roland@purestorage.com>, Juergen Gross <jgross@suse.com>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Borislav Petkov <bp@suse.de>, Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>, Davidlohr Bueso <dbueso@suse.de>, Dave Hansen <dave.hansen@linux.intel.com>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, Thomas Gleixner <tglx@linutronix.de>, Ville
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 21, 2015 at 11:39:39PM -0600, Jason Gunthorpe wrote:
> On Wed, Apr 22, 2015 at 01:39:07AM +0200, Luis R. Rodriguez wrote:
> > > Mike, do you think the time is right to just remove the iPath driver?
> > 
> > With PAT now being default the driver effectively won't work
> > with write-combining on modern kernels. Even if systems are old
> > they likely had PAT support, when upgrading kernels PAT will work
> > but write-combing won't on ipath.
> 
> Sorry, do you mean the driver already doesn't get WC? Or do you mean
> after some more pending patches are applied?

No, you have to consider the system used and the effects of calls used
on the driver in light of this table:

----------------------------------------------------------------------
MTRR Non-PAT   PAT    Linux ioremap value        Effective memory type
----------------------------------------------------------------------
                                                  Non-PAT |  PAT
     PAT
     |PCD
     ||PWT
     |||
WC   000      WB      _PAGE_CACHE_MODE_WB            WC   |   WC
WC   001      WC      _PAGE_CACHE_MODE_WC            WC*  |   WC
WC   010      UC-     _PAGE_CACHE_MODE_UC_MINUS      WC*  |   UC
WC   011      UC      _PAGE_CACHE_MODE_UC            UC   |   UC
----------------------------------------------------------------------

(*) denotes implementation defined and is discouraged

ioremap_nocache() will use _PAGE_CACHE_MODE_UC_MINUS by default today,
in the future we want to flip the switch and make _PAGE_CACHE_MODE_UC
the default. When that flip occurs it will mean ipath cannot get
write-combining on both non-PAT and PAT systems. Now that is for
the future, lets review the current situation for ipath.

For PAT capable systems if mtrr_add() is used today on a Linux system on a
region mapped with ioremap_nocache() that will mean you effectively nullify the
mtrr_add() effect as the combinatorial effect above yields an effective memory
type of UC.  For PAT systems you want to use ioremap_wc() on the region in
which you need write-combining followed by arch_phys_wc_add() which will *only*
call mtrr_add() *iff* PAT was not enabled. This also means we need to split
the ioremap'd areas so that the area that is using ioremap_nocache() can never
get write-combining (_PAGE_CACHE_MODE_UC). The ipath driver needs the regions
split just as was done for the qib driver.

Now we could just say that leaving things as-is is a non-issue if you are OK
with non-write-combining effects being the default behaviour left on the ipath
driver for PAT systems. In that case we can just use arch_phys_wc_add() on the
driver and while it won't trigger the mtrr_add() on PAT systems it sill won't
have any effect. We just typically don't want to see use of ioremap_nocache()
paired with arch_phys_wc_add(), grammatically the correct thing to do is pair
ioremap_wc() areas with a arch_phys_wc_add() to make the write-combining effects
on non-PAT systems. If the ipath driver is not going to get he work required
to split the regions though perhaps we can live with a corner case driver that
annotates PAT must be disabled on the systems that use it and convert it to
arch_phys_wc_add() to just help with phasing out of direct use of mtrr_add().
With this strategy if and when ipath driver gets a split done it would gain WC
on both PAT and non-PAT.

  Luis
