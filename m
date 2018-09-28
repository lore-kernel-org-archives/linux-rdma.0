From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 3/4] infiniband/mm: convert to the new put_user_page()
 call
Date: Fri, 28 Sep 2018 09:39:22 -0600
Message-ID: <20180928153922.GA17076@ziepe.ca>
References: <20180928053949.5381-1-jhubbard@nvidia.com>
 <20180928053949.5381-3-jhubbard@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180928053949.5381-3-jhubbard@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: john.hubbard@gmail.com
Cc: Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Doug Ledford <dledford@redhat.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Christian Benvenuti <benve@cisco.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 27, 2018 at 10:39:47PM -0700, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
> 
> For code that retains pages via get_user_pages*(),
> release those pages via the new put_user_page(),
> instead of put_page().
> 
> This prepares for eventually fixing the problem described
> in [1], and is following a plan listed in [2].
> 
> [1] https://lwn.net/Articles/753027/ : "The Trouble with get_user_pages()"
> 
> [2] https://lkml.kernel.org/r/20180709080554.21931-1-jhubbard@nvidia.com
>     Proposed steps for fixing get_user_pages() + DMA problems.
> 
> CC: Doug Ledford <dledford@redhat.com>
> CC: Jason Gunthorpe <jgg@ziepe.ca>
> CC: Mike Marciniszyn <mike.marciniszyn@intel.com>
> CC: Dennis Dalessandro <dennis.dalessandro@intel.com>
> CC: Christian Benvenuti <benve@cisco.com>
> 
> CC: linux-rdma@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> CC: linux-mm@kvack.org
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
>  drivers/infiniband/core/umem.c              | 2 +-
>  drivers/infiniband/core/umem_odp.c          | 2 +-
>  drivers/infiniband/hw/hfi1/user_pages.c     | 2 +-
>  drivers/infiniband/hw/mthca/mthca_memfree.c | 6 +++---
>  drivers/infiniband/hw/qib/qib_user_pages.c  | 2 +-
>  drivers/infiniband/hw/qib/qib_user_sdma.c   | 8 ++++----
>  drivers/infiniband/hw/usnic/usnic_uiom.c    | 2 +-
>  7 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
> index a41792dbae1f..9430d697cb9f 100644
> +++ b/drivers/infiniband/core/umem.c
> @@ -60,7 +60,7 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
>  		page = sg_page(sg);
>  		if (!PageDirty(page) && umem->writable && dirty)
>  			set_page_dirty_lock(page);
> -		put_page(page);
> +		put_user_page(page);

Would it make sense to have a release/put_user_pages_dirtied to absorb
the set_page_dity pattern too? I notice in this patch there is some
variety here, I wonder what is the right way?

Also, I'm told this code here is a big performance bottleneck when the
number of pages becomes very long (think >> GB of memory), so having a
future path to use some kind of batching/threading sound great.

Otherwise this RDMA part seems fine to me, there might be some minor
conflicts however. I assume you want to run this through the -mm tree?

Acked-by: Jason Gunthorpe <jgg@mellanox.com>

Jason
