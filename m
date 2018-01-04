From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 0/6] mlx5 profile infrastructure to add and
 remove stages
Date: Wed, 3 Jan 2018 20:04:27 -0700
Message-ID: <20180104030427.GB663@ziepe.ca>
References: <20180101110703.28759-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180101110703.28759-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 01, 2018 at 01:06:57PM +0200, Leon Romanovsky wrote:
> Changelog:
>  v0->v1:
>    * Moved ODP srcu initialization to be part of init stage.
>    * Added const to mlx6_ib_profile struct declaration.
>    * Remove ODP srcu cleanup callback.
> 
> Mark's patches continues e-switch series introduced in shared pull
> request and refactors the mlx5_ib initialization and cleanup logic to work in
> the stages.
> 
> Such modular separation provides an easy way to construct any initialization
> sequences and skip unneeded stages as we will have in RDMA/IB representors code.
> 
> The patches are available in the git repository at:
>   git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2018-01-01
> 
> 	Thanks
> 
> Mark Bloch (6):
>   IB/mlx5: Create profile infrastructure to add and remove stages
>   IB/mlx5: Move RoCE/ETH initialization to the corresponding stage
>   IB/mlx5: Move ODP initialization to the corresponding stage
>   IB/mlx5: Move hardware counters initialization to the corresponding
>     stage
>   IB/mlx5: Move loopback initialization to the corresponding stage
>   IB/mlx5: Move locks initialization to the corresponding stage
> 
>  drivers/infiniband/hw/mlx5/main.c    | 372 ++++++++++++++++++++++++-----------
>  drivers/infiniband/hw/mlx5/mlx5_ib.h |  32 ++-
>  drivers/infiniband/hw/mlx5/odp.c     |   9 -
>  3 files changed, 288 insertions(+), 125 deletions(-)

Applied to for-next, thanks

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
