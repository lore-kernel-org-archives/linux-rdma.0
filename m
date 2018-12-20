From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH mlx5-next] IB/mlx5: Prevent allocating UMEM and UCTX as
 some general object
Date: Thu, 20 Dec 2018 14:01:36 -0700
Message-ID: <20181220210136.GA10207@ziepe.ca>
References: <20181219142815.21480-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181219142815.21480-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Yishai Hadas <yishaih@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Achiad Shochat <achiad@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 19, 2018 at 04:28:15PM +0200, Leon Romanovsky wrote:
> From: Yishai Hadas <yishaih@mellanox.com>
> 
> The driver needs to prevent a user space application to create a
> UMEM and UCTX via the general object command.
> 
> The UMEM must go through the kernel UMEM_REG method to prevent the user
> from setting physical addresses by himself.  The UCTX is some internal
> kernel object and shouldn't be exposed.
> 
> As of not being any more part of the general object the caps bits were
> moved to be some log_xxx indication in the general HCA caps, 0 means not
> supported.
> 
> The firmware code was adapted as well to match the above.
> 
> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> Reviewed-by: Achiad Shochat <achiad@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/infiniband/hw/mlx5/devx.c | 34 ++++++++---------
>  drivers/infiniband/hw/mlx5/main.c |  3 +-
>  include/linux/mlx5/mlx5_ifc.h     | 62 +++++++++++++++++++++----------
>  3 files changed, 58 insertions(+), 41 deletions(-)

Applied to for-next

Thanks,
Jason
