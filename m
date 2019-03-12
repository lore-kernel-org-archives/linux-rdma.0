From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH mlx5-next] IB/mlx5: Use mlx5 core to create/destroy a
 DEVX DCT
Date: Tue, 12 Mar 2019 15:09:44 -0300
Message-ID: <20190312180944.GC17113@ziepe.ca>
References: <20190306172142.21036-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190306172142.21036-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Yishai Hadas <yishaih@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 06, 2019 at 07:21:42PM +0200, Leon Romanovsky wrote:
> From: Yishai Hadas <yishaih@mellanox.com>
> 
> To prevent a hardware memory leak when a DEVX DCT object is destroyed
> without calling DRAIN DCT before, (e.g. under cleanup flow), need to
> manage its creation and destruction via mlx5 core.
> 
> In that case the DRAIN DCT command will be called and only once that
> it will be completed the DESTROY DCT command will be called.
> Otherwise, the DESTROY DCT may fail and a hardware leak may occur.
> 
> As of that change the DRAIN DCT command should not be exposed any more
> from DEVX, it's managed internally by the driver to work as expected by
> the device specification.
> 
> Fixes: 7efce3691d33 ("IB/mlx5: Add obj create and destroy functionality")
> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/infiniband/hw/mlx5/devx.c            | 34 +++++++++++++++-----
>  drivers/infiniband/hw/mlx5/qp.c              |  4 ++-
>  drivers/net/ethernet/mellanox/mlx5/core/qp.c |  6 ++--
>  include/linux/mlx5/qp.h                      |  3 +-
>  4 files changed, 34 insertions(+), 13 deletions(-)

Applied to for-rc

Thanks,
Jason
