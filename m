From: "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: ioremap_uc() followed by set_memory_wc() - burrying MTRR
Date: Wed, 22 Apr 2015 19:07:31 +0200
Message-ID: <20150422170731.GH5622@wotan.suse.de>
References: <CALCETrV0B7rp08-VYjp5=1CWJp7=xTUTBYo3uGxX317RxAQT+w@mail.gmail.com>
 <20150421224601.GY5622@wotan.suse.de>
 <20150421225732.GA17356@obsidianresearch.com>
 <20150421233907.GA5622@wotan.suse.de>
 <20150422053939.GA29609@obsidianresearch.com>
 <20150422152328.GB5622@wotan.suse.de>
 <CALCETrWYRazYgovguNEodVZUwO3sCmzvg9-q73nTfJ2ahNrBxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWYRazYgovguNEodVZUwO3sCmzvg9-q73nTfJ2ahNrBxw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Mike Marciniszyn <infinipath@intel.com>, linux-rdma@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>, Toshi Kani <toshi.kani@hp.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Suresh Siddha <sbsiddha@gmail.com>, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Roland Dreier <roland@purestorage.com>, Juergen Gross <jgross@suse.com>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Borislav Petkov <bp@suse.de>, Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>, Davidlohr Bueso <dbueso@suse.de>, Dave Hansen <dave.hansen@linux.intel.com>, Jean-Christophe Plagniol-Villard <plagnioj@>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 22, 2015 at 09:53:03AM -0700, Andy Lutomirski wrote:
> On Wed, Apr 22, 2015 at 8:23 AM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> > On Tue, Apr 21, 2015 at 11:39:39PM -0600, Jason Gunthorpe wrote:
> >> On Wed, Apr 22, 2015 at 01:39:07AM +0200, Luis R. Rodriguez wrote:
> >> > > Mike, do you think the time is right to just remove the iPath driver?
> >> >
> >> > With PAT now being default the driver effectively won't work
> >> > with write-combining on modern kernels. Even if systems are old
> >> > they likely had PAT support, when upgrading kernels PAT will work
> >> > but write-combing won't on ipath.
> >>
> >> Sorry, do you mean the driver already doesn't get WC? Or do you mean
> >> after some more pending patches are applied?
> >
> > No, you have to consider the system used and the effects of calls used
> > on the driver in light of this table:
> >
> > ----------------------------------------------------------------------
> > MTRR Non-PAT   PAT    Linux ioremap value        Effective memory type
> > ----------------------------------------------------------------------
> >                                                   Non-PAT |  PAT
> >      PAT
> >      |PCD
> >      ||PWT
> >      |||
> > WC   000      WB      _PAGE_CACHE_MODE_WB            WC   |   WC
> > WC   001      WC      _PAGE_CACHE_MODE_WC            WC*  |   WC
> > WC   010      UC-     _PAGE_CACHE_MODE_UC_MINUS      WC*  |   UC
> > WC   011      UC      _PAGE_CACHE_MODE_UC            UC   |   UC
> > ----------------------------------------------------------------------
> >
> > (*) denotes implementation defined and is discouraged
> >
> > ioremap_nocache() will use _PAGE_CACHE_MODE_UC_MINUS by default today,
> > in the future we want to flip the switch and make _PAGE_CACHE_MODE_UC
> > the default. When that flip occurs it will mean ipath cannot get
> > write-combining on both non-PAT and PAT systems. Now that is for
> > the future, lets review the current situation for ipath.
> >
> > For PAT capable systems if mtrr_add() is used today on a Linux system on a
> > region mapped with ioremap_nocache() that will mean you effectively nullify the
> > mtrr_add() effect as the combinatorial effect above yields an effective memory
> > type of UC.
> 
> Are you sure?

Well lets double check.

>  I thought that ioremap_nocache currently is UC-,

It is.

> so mtrr_add + ioremap_nocache gets WC even on PAT systems.

https://www-ssl.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-manual-325462.pdf

    As per Intel SDM "11.5.2.2 Selecting Memory Types for Pentium
    III and More Recent Processor Families" the ffect of a WC MTRR
    for a region with a PAT entry value of UC will be UC. The effect
    of a WC MTRR on a region with a PAT entry UC- will be WC. The
    effect of a WC MTRR on a regoin with PAT entry WC is WC.

And indeed as per table 11-7 mtrr WC on PAT UC- yields WC. So ineed the above
table needs adjustment for this. So for PAT systems write-combing would be
effective with mtrr_add(), but once strong UC (_PAGE_CACHE_MODE_UC) is used by
default for ioremap_nocache() what I mentioned will be true. Furhtermore if we
switch the drivers to use arch_phys_wc_add() then for sure write-combining will
also not be effective.

Jason, Andy, is the change still a reasonable compromise? We'd just be asking
users to boot with noat for users for ipath, ivtv until the drivers gets proper
PAT support with a split.

There are two motivations for this:

  * help move to strong UC as default
  * bury MTRR

> Going forward, when mtrr_add is gone, this will change, of course.

Indeed.

  Luis
