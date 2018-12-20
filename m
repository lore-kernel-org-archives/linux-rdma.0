From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH V3] net/mlx4: Get rid of page operation after
 dma_alloc_coherent
Date: Thu, 20 Dec 2018 10:43:18 -0700
Message-ID: <20181220174318.GA21404@ziepe.ca>
References: <20181219182031.8675-1-swarren@wwwdotorg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181219182031.8675-1-swarren@wwwdotorg.org>
Sender: netdev-owner@vger.kernel.org
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tariq Toukan <tariqt@mellanox.com>, xavier.huwei@huawei.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Christoph Hellwig <hch@lst.de>, Stephen Warren <swarren@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 19, 2018 at 11:20:31AM -0700, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> This patch solves a crash at the time of mlx4 driver unload or system
> shutdown. The crash occurs because dma_alloc_coherent() returns one
> value in mlx4_alloc_icm_coherent(), but a different value is passed to
> dma_free_coherent() in mlx4_free_icm_coherent(). In turn this is because
> when allocated, that pointer is passed to sg_set_buf() to record it,
> then when freed it is re-calculated by calling
> lowmem_page_address(sg_page()) which returns a different value. Solve
> this by recording the value that dma_alloc_coherent() returns, and
> passing this to dma_free_coherent().
> 
> This patch is roughly equivalent to commit 378efe798ecf ("RDMA/hns: Get
> rid of page operation after dma_alloc_coherent"). That patch was
> described as:
> 
> > In general, dma_alloc_coherent() returns a CPU virtual address and
> > a DMA address, and we have no guarantee that the underlying memory
> > even has an associated struct page at all.
> >
> > This patch gets rid of the page operation after dma_alloc_coherent,
> > and records the VA returned form dma_alloc_coherent in the struct
> > of hem in hns RoCE driver.
> 
> However, this patch reworks the code to store all information about
> coherent chunks separately from the sg list, since using sg lists for
> them doesn't make sense. Hence, the structure of this patch is quite
> different compared to the hns patch.
> 
> Based-on-code-from: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> v3:
> - Rework chunk data structure to store all data for coherent allocations
>   separately from the sg list. Code from Christoph Hellwig with fixes by
>   me. Notes:
>   - chunk->coherent is an int not a bool since checkpatch complains about
>     using bool in structs; see https://lkml.org/lkml/2017/11/21/384.

:( bool is much more readable and there is no performance concern in
this struct. I think checkpatch is overzealous here.

>   - chunk->coherent is used rather than chunk->table->coherent since the
>     table pointer isn't available when creating chunks. This duplicates
>     data, but simplifies the patch.
> v2:
> - Rework mlx4_table_find() to explicitly calculate the returned address
>   differently depending on wheter the table was allocated using
>   dma_alloc_coherent() or alloc_pages(), which in turn allows the
>   changes to mlx4_alloc_icm_pages() to be dropped.
> - Drop changes to mlx4_alloc/free_icm_pages. This path uses
>   pci_map_sg() which can re-write the sg list which in turn would cause
>   chunk->mem[] (the sg list) and chunk->buf[] to become inconsistent.
> - Enhance commit description.
> 
> Note: I've tested this patch in a downstream 4.14 based kernel (using
> ibping, ib_read_bw, and ib_write_bw), but can't test it in mainline
> since my system isn't supported there yet. I have compile-tested it in
> mainline at least, for ARM64.
> ---
>  drivers/net/ethernet/mellanox/mlx4/icm.c | 92 ++++++++++++++----------
>  drivers/net/ethernet/mellanox/mlx4/icm.h | 22 +++++-
>  2 files changed, 75 insertions(+), 39 deletions(-)

I think this needs an ack from the driver maintainers, and I gather
they are all on break for the next two weeks or so.

Lets revisit in January?

But at first glance it looks OK to me, though I would tidy the commit
message somewhat, your new leading paragraph fully explains the
problem, no need for the hns quote - and we can now see that the hns
should't have used a sgl either...

Jason
