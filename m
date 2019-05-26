From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2] infiniband/mm: convert put_page() to put_user_page*()
Date: Sun, 26 May 2019 04:06:31 -0700
Message-ID: <20190526110631.GD1075@bombadil.infradead.org>
References: <20190525014522.8042-1-jhubbard@nvidia.com>
 <20190525014522.8042-2-jhubbard@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190525014522.8042-2-jhubbard@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: john.hubbard@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Jason Gunthorpe <jgg@ziepe.ca>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Doug Ledford <dledford@redhat.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Christian Benvenuti <benve@cisco.com>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, May 24, 2019 at 06:45:22PM -0700, john.hubbard@gmail.com wrote:
> For infiniband code that retains pages via get_user_pages*(),
> release those pages via the new put_user_page(), or
> put_user_pages*(), instead of put_page()

I have no objection to this particular patch, but ...

> This is a tiny part of the second step of fixing the problem described
> in [1]. The steps are:
> 
> 1) Provide put_user_page*() routines, intended to be used
>    for releasing pages that were pinned via get_user_pages*().
> 
> 2) Convert all of the call sites for get_user_pages*(), to
>    invoke put_user_page*(), instead of put_page(). This involves dozens of
>    call sites, and will take some time.
> 
> 3) After (2) is complete, use get_user_pages*() and put_user_page*() to
>    implement tracking of these pages. This tracking will be separate from
>    the existing struct page refcounting.
> 
> 4) Use the tracking and identification of these pages, to implement
>    special handling (especially in writeback paths) when the pages are
>    backed by a filesystem. Again, [1] provides details as to why that is
>    desirable.

I thought we agreed at LSFMM that the future is a new get_user_bvec()
/ put_user_bvec().  This is largely going to touch the same places as
step 2 in your list above.  Is it worth doing step 2?

One of the advantages of put_user_bvec() is that it would be quite easy
to miss a conversion from put_page() to put_user_page(), but it'll be
a type error to miss a conversion from put_page() to put_user_bvec().
