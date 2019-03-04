From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v3] RDMA/umem: minor bug fix in error handling path
Date: Mon, 4 Mar 2019 16:31:32 -0400
Message-ID: <20190304203132.GA1055@ziepe.ca>
References: <20190304194645.10422-1-jhubbard@nvidia.com>
 <20190304194645.10422-2-jhubbard@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190304194645.10422-2-jhubbard@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: john.hubbard@gmail.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Ira Weiny <ira.weiny@intel.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 04, 2019 at 11:46:45AM -0800, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
> 
> 1. Bug fix: fix an off by one error in the code that
> cleans up if it fails to dma-map a page, after having
> done a get_user_pages_remote() on a range of pages.
> 
> 2. Refinement: for that same cleanup code, release_pages()
> is better than put_page() in a loop.
> 
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: linux-rdma@vger.kernel.org
> Cc: linux-mm@kvack.org
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Acked-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/infiniband/core/umem_odp.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)

Applied to for-next, thanks

Jason
