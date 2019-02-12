From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH 2/3] mm/gup: Introduce get_user_pages_fast_longterm()
Date: Mon, 11 Feb 2019 16:08:10 -0800
Message-ID: <20190212000810.GA24207@iweiny-DESK2.sc.intel.com>
References: <20190211201643.7599-1-ira.weiny@intel.com>
 <20190211201643.7599-3-ira.weiny@intel.com>
 <20190211203916.GA2771@ziepe.ca>
 <bcc03ee1-4c42-48c3-bc67-942c0f04875e@nvidia.com>
 <20190211212652.GA7790@iweiny-DESK2.sc.intel.com>
 <fc9c880b-24f8-7063-6094-00175bc27f7d@nvidia.com>
 <20190211215238.GA23825@iweiny-DESK2.sc.intel.com>
 <20190211220658.GH24692@ziepe.ca>
 <CAPcyv4htDHmH7PVm_=HOWwRKtpcKTPSjrHPLqhwp2vhBUWL4-w@mail.gmail.com>
 <20190211232510.GP24692@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190211232510.GP24692@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dan Williams <dan.j.williams@intel.com>, John Hubbard <jhubbard@nvidia.com>, linux-rdma <linux-rdma@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Daniel Borkmann <daniel@iogearbox.net>, Davidlohr Bueso <dave@stgolabs.net>, Netdev <netdev@vger.kernel.org>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 11, 2019 at 04:25:10PM -0700, Jason Gunthorpe wrote:
> On Mon, Feb 11, 2019 at 02:55:10PM -0800, Dan Williams wrote:
> 
> > > I also wonder if someone should think about making fast into a flag
> > > too..
> > >
> > > But I'm not sure when fast should be used vs when it shouldn't :(
> > 
> > Effectively fast should always be used just in case the user cares
> > about performance. It's just that it may fail and need to fall back to
> > requiring the vma.
> 
> But the fall back / slow path is hidden inside the API, so when should
> the caller care? 
> 
> ie when should the caller care to use gup_fast vs gup_unlocked? (the
> comments say they are the same, but this seems to be a mistake)
> 
> Based on some of the comments in the code it looks like this API is
> trying to convert itself into:
> 
> long get_user_pages_locked(struct task_struct *tsk, struct mm_struct *mm,
>                            unsigned long start, unsigned long nr_pages,
> 			   unsigned int gup_flags, struct page **pages,
> 			   struct vm_area_struct **vmas, bool *locked)
> 
> long get_user_pages_unlocked(struct task_struct *tsk, struct mm_struct *mm,
>                              unsigned long start, unsigned long nr_pages,
> 			     unsigned int gup_flags, struct page **pages)
> 
> (and maybe a FOLL_FAST if there is some reason we have _fast and
> _unlocked)
> 
> The reason I ask, is that if there is no reason for fast vs unlocked
> then maybe Ira should convert HFI to use gup_unlocked and move the
> 'fast' code into unlocked?
> 
> ie move incrementally closer to the desired end-state here.

If the pages are not in the page tables then fast is probably going to be
slightly slower because it will have to fall back after walking the tables and
finding something missing.

For PSM2 (MPI) applications are performance improvement was probably because
the memory in question was in the page tables and very much in use.

Ira

> 
> Jason
