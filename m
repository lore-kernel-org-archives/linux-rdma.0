From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 0/3] Add gup fast + longterm and use it in HFI1
Date: Mon, 11 Feb 2019 15:22:08 -0700
Message-ID: <20190211222208.GJ24692@ziepe.ca>
References: <20190211201643.7599-1-ira.weiny@intel.com>
 <20190211203417.a2c2kbmjai43flyz@linux-r8p5>
 <20190211204710.GE24692@ziepe.ca>
 <20190211214257.GA7891@iweiny-DESK2.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190211214257.GA7891@iweiny-DESK2.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 11, 2019 at 01:42:57PM -0800, Ira Weiny wrote:
> On Mon, Feb 11, 2019 at 01:47:10PM -0700, Jason Gunthorpe wrote:
> > On Mon, Feb 11, 2019 at 12:34:17PM -0800, Davidlohr Bueso wrote:
> > > On Mon, 11 Feb 2019, ira.weiny@intel.com wrote:
> > > > Ira Weiny (3):
> > > >  mm/gup: Change "write" parameter to flags
> > > >  mm/gup: Introduce get_user_pages_fast_longterm()
> > > >  IB/HFI1: Use new get_user_pages_fast_longterm()
> > > 
> > > Out of curiosity, are you planning on having all rdma drivers
> > > use get_user_pages_fast_longterm()? Ie:
> > > 
> > > hw/mthca/mthca_memfree.c:       ret = get_user_pages_fast(uaddr & PAGE_MASK, 1, FOLL_WRITE, pages);
> > 
> > This one is certainly a mistake - this should be done with a umem.
> 
> It looks like this is mapping a page allocated by user space for a
> doorbell?!?!

Many drivers do this, the 'doorbell' is a PCI -> CPU thing of some sort

> This does not seem to be allocating memory regions.  Jason, do you
> want a patch to just convert these calls and consider it legacy
> code?

It needs to use umem like all the other drivers on this path.
Otherwise it doesn't get the page pinning logic right

There is also something else rotten with these longterm callsites,
they seem to have very different ideas how to handle RLIMIT_MEMLOCK.

ie vfio doesn't even touch pinned_vm.. and rdma is applying
RLIMIT_MEMLOCK to mm->pinned_vm, while vfio is using locked_vm.. No
idea which is right, but they should be the same, and this pattern
should probably be in core code someplace.

Jason
