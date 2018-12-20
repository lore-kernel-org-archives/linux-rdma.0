From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 0/2] Fix to mlx5 devx interface
Date: Thu, 20 Dec 2018 14:01:07 -0700
Message-ID: <20181220210107.GA10152@ziepe.ca>
References: <20181219142811.21301-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181219142811.21301-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 19, 2018 at 04:28:09PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Hi,
> 
> This small fix to mlx5 devx interface is separated to two, so we can
> apply first patch to mlx5-next.
> 
> Thanks
> 
> Yishai Hadas (2):
>   IB/mlx5: Introduce uid as part of alloc/dealloc transport domain
>   IB/mlx5: Use uid as part of alloc/dealloc transport domain
> 
>  drivers/infiniband/hw/mlx5/cmd.c | 2 ++
>  include/linux/mlx5/mlx5_ifc.h    | 4 ++--
>  2 files changed, 4 insertions(+), 2 deletions(-)

Applied to for-next

Thanks,
Jason
