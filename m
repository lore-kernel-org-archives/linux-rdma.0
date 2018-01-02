From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB/ocrdma: Use zeroing memory allocator than
 allocator/memset
Date: Tue, 2 Jan 2018 14:05:58 -0700
Message-ID: <20180102210558.GA7614@ziepe.ca>
References: <1514648396-6964-1-git-send-email-himanshujha199640@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1514648396-6964-1-git-send-email-himanshujha199640@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Himanshu Jha <himanshujha199640@gmail.com>
Cc: dledford@redhat.com, devesh.sharma@broadcom.com, selvin.xavier@broadcom.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, mcgrof@kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Dec 30, 2017 at 09:09:56PM +0530, Himanshu Jha wrote:
> Use dma_zalloc_coherent for allocating zeroed
> memory and remove unnecessary memset function.
> 
> Done using Coccinelle.
> Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci
> 0-day tested with no failures.
> 
> Suggested-by: Luis R. Rodriguez <mcgrof@kernel.org>
> Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
> Acked-by: Selvin Xavier <selvin.xavier@broadcom.com>
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 19 +++++++------------
>  drivers/infiniband/hw/ocrdma/ocrdma_stats.c |  6 ++----
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |  8 +++-----
>  3 files changed, 12 insertions(+), 21 deletions(-)

Applied to for-next thanks

Jason
