From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH 1/1] infiniband/mm: convert put_page() to put_user_page*()
Date: Thu, 23 May 2019 11:31:33 -0400
Message-ID: <20190523153133.GB5104@redhat.com>
References: <20190523072537.31940-1-jhubbard@nvidia.com>
 <20190523072537.31940-2-jhubbard@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190523072537.31940-2-jhubbard@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: john.hubbard@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Jason Gunthorpe <jgg@ziepe.ca>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Doug Ledford <dledford@redhat.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Christian Benvenuti <benve@cisco.com>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@mellanox.com>, Ira Weiny <ira.weiny@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 23, 2019 at 12:25:37AM -0700, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
> 
> For infiniband code that retains pages via get_user_pages*(),
> release those pages via the new put_user_page(), or
> put_user_pages*(), instead of put_page()
> 
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
> 
> [1] https://lwn.net/Articles/753027/ : "The Trouble with get_user_pages()"
> 
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
> Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>
> Cc: Christian Benvenuti <benve@cisco.com>
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
> Acked-by: Jason Gunthorpe <jgg@mellanox.com>
> Tested-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Reviewed-by: Jérôme Glisse <jglisse@redhat.com>

Between i have a wishlist see below


> ---
>  drivers/infiniband/core/umem.c              |  7 ++++---
>  drivers/infiniband/core/umem_odp.c          | 10 +++++-----
>  drivers/infiniband/hw/hfi1/user_pages.c     | 11 ++++-------
>  drivers/infiniband/hw/mthca/mthca_memfree.c |  6 +++---
>  drivers/infiniband/hw/qib/qib_user_pages.c  | 11 ++++-------
>  drivers/infiniband/hw/qib/qib_user_sdma.c   |  6 +++---
>  drivers/infiniband/hw/usnic/usnic_uiom.c    |  7 ++++---
>  7 files changed, 27 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
> index e7ea819fcb11..673f0d240b3e 100644
> --- a/drivers/infiniband/core/umem.c
> +++ b/drivers/infiniband/core/umem.c
> @@ -54,9 +54,10 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
>  
>  	for_each_sg_page(umem->sg_head.sgl, &sg_iter, umem->sg_nents, 0) {
>  		page = sg_page_iter_page(&sg_iter);
> -		if (!PageDirty(page) && umem->writable && dirty)
> -			set_page_dirty_lock(page);
> -		put_page(page);
> +		if (umem->writable && dirty)
> +			put_user_pages_dirty_lock(&page, 1);
> +		else
> +			put_user_page(page);

Can we get a put_user_page_dirty(struct page 8*pages, bool dirty, npages) ?

It is a common pattern that we might have to conditionaly dirty the pages
and i feel it would look cleaner if we could move the branch within the
put_user_page*() function.

Cheers,
Jérôme
