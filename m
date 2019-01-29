From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 3/5] RDMA/uverbs: add owner parameter to ib_umem_get
Date: Tue, 29 Jan 2019 09:56:19 -0700
Message-ID: <20190129165619.GC10094@ziepe.ca>
References: <1548768386-28289-1-git-send-email-joeln@il.ibm.com>
 <1548768386-28289-4-git-send-email-joeln@il.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1548768386-28289-4-git-send-email-joeln@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joel Nider <joeln@il.ibm.com>
Cc: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 29, 2019 at 03:26:24PM +0200, Joel Nider wrote:
> ib_umem_get is a core function used by drivers that support RDMA.
> The 'owner' parameter signifies the process that owns the memory.
> Until now, it was assumed that the owning process was the current
> process. This adds the flexibility to specify a process other than
> the current process. All drivers that call this function are also
> updated, but the default behaviour is to keep backwards
> compatibility by assuming the current process is the owner when
> the 'owner' parameter is NULL.
> 
> Signed-off-by: Joel Nider <joeln@il.ibm.com>
>  drivers/infiniband/core/umem.c                | 26 ++++++++++++++++++++------
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c      | 10 +++++-----
>  drivers/infiniband/hw/cxgb3/iwch_provider.c   |  3 ++-
>  drivers/infiniband/hw/cxgb4/mem.c             |  3 ++-
>  drivers/infiniband/hw/hns/hns_roce_cq.c       |  2 +-
>  drivers/infiniband/hw/hns/hns_roce_db.c       |  2 +-
>  drivers/infiniband/hw/hns/hns_roce_mr.c       |  4 ++--
>  drivers/infiniband/hw/hns/hns_roce_qp.c       |  2 +-
>  drivers/infiniband/hw/hns/hns_roce_srq.c      |  2 +-
>  drivers/infiniband/hw/i40iw/i40iw_verbs.c     |  2 +-
>  drivers/infiniband/hw/mlx4/cq.c               |  2 +-
>  drivers/infiniband/hw/mlx4/doorbell.c         |  2 +-
>  drivers/infiniband/hw/mlx4/mr.c               |  2 +-
>  drivers/infiniband/hw/mlx4/qp.c               |  2 +-
>  drivers/infiniband/hw/mlx4/srq.c              |  2 +-
>  drivers/infiniband/hw/mlx5/cq.c               |  4 ++--
>  drivers/infiniband/hw/mlx5/devx.c             |  2 +-
>  drivers/infiniband/hw/mlx5/doorbell.c         |  2 +-
>  drivers/infiniband/hw/mlx5/mr.c               | 15 ++++++++-------
>  drivers/infiniband/hw/mlx5/odp.c              |  5 +++--
>  drivers/infiniband/hw/mlx5/qp.c               |  4 ++--
>  drivers/infiniband/hw/mlx5/srq.c              |  2 +-
>  drivers/infiniband/hw/mthca/mthca_provider.c  |  2 +-
>  drivers/infiniband/hw/nes/nes_verbs.c         |  3 ++-
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c   |  3 ++-
>  drivers/infiniband/hw/qedr/verbs.c            |  8 +++++---
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c  |  2 +-
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c  |  2 +-
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c  |  5 +++--
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c |  2 +-
>  drivers/infiniband/sw/rdmavt/mr.c             |  2 +-
>  drivers/infiniband/sw/rxe/rxe_mr.c            |  3 ++-
>  include/rdma/ib_umem.h                        |  3 ++-
>  33 files changed, 80 insertions(+), 55 deletions(-)
> 
> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
> index c6144df..9646cee 100644
> +++ b/drivers/infiniband/core/umem.c
> @@ -71,15 +71,21 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
>   *
>   * If access flags indicate ODP memory, avoid pinning. Instead, stores
>   * the mm for future page fault handling in conjunction with MMU notifiers.
> + * If the process doing the pinning is the same as the process that owns
> + * the memory being pinned, 'owner' should be NULL. Otherwise, 'owner' should
> + * be the process ID of the owning process. The process ID must be in the
> + * same PID namespace as the calling userspace context.
>   *
> - * @context: userspace context to pin memory for
> + * @context: userspace context that is pinning the memory
>   * @addr: userspace virtual address to start at
>   * @size: length of region to pin
>   * @access: IB_ACCESS_xxx flags for memory being pinned
>   * @dmasync: flush in-flight DMA when the memory region is written
> + * @owner: the ID of the process that owns the memory being pinned
>   */
>  struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
> -			    size_t size, int access, int dmasync)
> +			    size_t size, int access, int dmasync,
> +			    struct pid *owner)

You need to rebase this patch on rdma's for-next tree, the signature is
different.

Jason
