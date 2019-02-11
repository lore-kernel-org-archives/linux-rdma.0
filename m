From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 0/3] Add gup fast + longterm and use it in HFI1
Date: Mon, 11 Feb 2019 13:47:10 -0700
Message-ID: <20190211204710.GE24692@ziepe.ca>
References: <20190211201643.7599-1-ira.weiny@intel.com>
 <20190211203417.a2c2kbmjai43flyz@linux-r8p5>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190211203417.a2c2kbmjai43flyz@linux-r8p5>
Sender: netdev-owner@vger.kernel.org
To: ira.weiny@intel.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 11, 2019 at 12:34:17PM -0800, Davidlohr Bueso wrote:
> On Mon, 11 Feb 2019, ira.weiny@intel.com wrote:
> > Ira Weiny (3):
> >  mm/gup: Change "write" parameter to flags
> >  mm/gup: Introduce get_user_pages_fast_longterm()
> >  IB/HFI1: Use new get_user_pages_fast_longterm()
> 
> Out of curiosity, are you planning on having all rdma drivers
> use get_user_pages_fast_longterm()? Ie:
> 
> hw/mthca/mthca_memfree.c:       ret = get_user_pages_fast(uaddr & PAGE_MASK, 1, FOLL_WRITE, pages);

This one is certainly a mistake - this should be done with a umem.

Jason
