From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v4 0/1] Use HMM for ODP v4
Date: Thu, 23 May 2019 12:41:49 -0300
Message-ID: <20190523154149.GB12159@ziepe.ca>
References: <20190411181314.19465-1-jglisse@redhat.com>
 <20190506195657.GA30261@ziepe.ca>
 <20190521205321.GC3331@redhat.com>
 <20190522005225.GA30819@ziepe.ca>
 <20190522174852.GA23038@redhat.com>
 <20190522235737.GD15389@ziepe.ca>
 <20190523150432.GA5104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190523150432.GA5104@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jerome Glisse <jglisse@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, Artemy Kovalyov <artemyko@mellanox.com>, Moni Shoua <monis@mellanox.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Kaike Wan <kaike.wan@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 23, 2019 at 11:04:32AM -0400, Jerome Glisse wrote:
> On Wed, May 22, 2019 at 08:57:37PM -0300, Jason Gunthorpe wrote:
> > On Wed, May 22, 2019 at 01:48:52PM -0400, Jerome Glisse wrote:
> > 
> > > > > So attached is a rebase on top of 5.2-rc1, i have tested with pingpong
> > > > > (prefetch and not and different sizes). Seems to work ok.
> > > > 
> > > > Urk, it already doesn't apply to the rdma tree :(
> > > > 
> > > > The conflicts are a little more extensive than I'd prefer to handle..
> > > > Can I ask you to rebase it on top of this branch please:
> > > > 
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/log/?h=wip/jgg-for-next
> > > > 
> > > > Specifically it conflicts with this patch:
> > > > 
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/commit/?h=wip/jgg-for-next&id=d2183c6f1958e6b6dfdde279f4cee04280710e34
> > 
> > There is at least one more serious blocker here:
> > 
> > config ARCH_HAS_HMM_MIRROR
> >         bool
> >         default y
> >         depends on (X86_64 || PPC64)
> >         depends on MMU && 64BIT
> > 
> > I can't loose ARM64 support for ODP by merging this, that is too
> > serious of a regression.
> > 
> > Can you fix it?
> 
> 5.2 already has patch to fix the Kconfig (ARCH_HAS_HMM_MIRROR and
> ARCH_HAS_HMM_DEVICE replacing ARCH_HAS_HMM) I need to update nouveau

Newer than 5.2-rc1? Is this why ARCH_HAS_HMM_MIRROR is not used anywhere?

> in 5.3 so that i can drop the old ARCH_HAS_HMM and then convert
> core mm in 5.4 to use ARCH_HAS_HMM_MIRROR and ARCH_HAS_HMM_DEVICE
> instead of ARCH_HAS_HMM

My problem is that ODP needs HMM_MIRROR which needs HMM & ARCH_HAS_HMM
- and then even if fixed we still have the ARCH_HAS_HMM_MIRROR
restricted to ARM64..

Can we broaden HMM_MIRROR to all arches? I would very much prefer
that.

> So it seems it will have to wait 5.4 for ODP. I will re-spin the
> patch for ODP once i am done reviewing Ralph changes and yours
> for 5.3.

I think we are still OK for 5.3.

If mm takes the fixup patches so hmm mirror is as reliable as ODP's
existing stuff, and patch from you to enable ARM64, then we can
continue to merge into 5.3

So, let us try to get acks on those other threads..

Jason
