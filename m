From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH v6 7/8] mm/mmu_notifier: pass down vma and reasons why
 mmu notifier is happening v2
Date: Thu, 11 Apr 2019 14:50:33 -0700
Message-ID: <20190411215033.GH22989@iweiny-DESK2.sc.intel.com>
References: <20190326164747.24405-1-jglisse@redhat.com>
 <20190326164747.24405-8-jglisse@redhat.com>
 <20190410234124.GE22989@iweiny-DESK2.sc.intel.com>
 <20190411054130.GY3201@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190411054130.GY3201@mtr-leonro.mtl.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: jglisse@redhat.com, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Jan Kara <jack@suse.cz>, Andrea Arcangeli <aarcange@redhat.com>, Peter Xu <peterx@redhat.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Jason Gunthorpe <jgg@mellanox.com>, Ross Zwisler <zwisler@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Michal Hocko <mhocko@kernel.org>, Ralph Campbell <rcampbell@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, kvm@vger.ker
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 11, 2019 at 08:41:30AM +0300, Leon Romanovsky wrote:
> On Wed, Apr 10, 2019 at 04:41:57PM -0700, Ira Weiny wrote:
> > On Tue, Mar 26, 2019 at 12:47:46PM -0400, Jerome Glisse wrote:
> > > From: Jérôme Glisse <jglisse@redhat.com>
> > >

[snip]

> > > diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> > > index 62f94cd85455..0379956fff23 100644
> > > --- a/include/linux/mmu_notifier.h
> > > +++ b/include/linux/mmu_notifier.h
> > > @@ -58,10 +58,12 @@ struct mmu_notifier_mm {
> > >  #define MMU_NOTIFIER_RANGE_BLOCKABLE (1 << 0)
> > >
> > >  struct mmu_notifier_range {
> > > +	struct vm_area_struct *vma;
> > >  	struct mm_struct *mm;
> > >  	unsigned long start;
> > >  	unsigned long end;
> > >  	unsigned flags;
> > > +	enum mmu_notifier_event event;
> > >  };
> > >
> > >  struct mmu_notifier_ops {
> > > @@ -363,10 +365,12 @@ static inline void mmu_notifier_range_init(struct mmu_notifier_range *range,
> > >  					   unsigned long start,
> > >  					   unsigned long end)
> > >  {
> > > +	range->vma = vma;
> > > +	range->event = event;
> > >  	range->mm = mm;
> > >  	range->start = start;
> > >  	range->end = end;
> > > -	range->flags = 0;
> > > +	range->flags = flags;
> >
> > Which of the "user patch sets" uses the new flags?
> >
> > I'm not seeing that user yet.  In general I don't see anything wrong with the
> > series and I like the idea of telling drivers why the invalidate has fired.
> >
> > But is the flags a future feature?
> 
> It seems that it is used in HMM ODP patch.
> https://patchwork.kernel.org/patch/10894281/

AFAICT the flags in that patch are "hmm_range->flags"  not
"mmu_notifier_range->flags"

They are not the same.

Ira

> 
> Thanks
> 
> >
> > For the series:
> >
> > Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> >
> > Ira
> >
> > >  }
> > >
> > >  #define ptep_clear_flush_young_notify(__vma, __address, __ptep)		\
> > > --
> > > 2.20.1
> > >
