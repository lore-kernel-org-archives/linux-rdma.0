From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] RDMA/umem: updated bug fix in error handling path
Date: Wed, 6 Mar 2019 14:45:54 -0400
Message-ID: <20190306184554.GG1662@ziepe.ca>
References: <20190306020022.21828-1-jhubbard@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190306020022.21828-1-jhubbard@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: john.hubbard@gmail.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Artemy Kovalyov <artemyko@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Ira Weiny <ira.weiny@intel.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 05, 2019 at 06:00:22PM -0800, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
> 
> The previous attempted bug fix overlooked the fact that
> ib_umem_odp_map_dma_single_page() was doing a put_page()
> upon hitting an error. So there was not really a bug there.
> 
> Therefore, this reverts the off-by-one change, but
> keeps the change to use release_pages() in the error path.
> 
> Fixes: commit xxxxxxxxxxxx ("RDMA/umem: minor bug fix in error handling path")
> Suggested-by: Artemy Kovalyov <artemyko@mellanox.com>
> 
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: linux-rdma@vger.kernel.org
> Cc: linux-mm@kvack.org
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  drivers/infiniband/core/umem_odp.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)

Applied to for-next, thanks

Jason
