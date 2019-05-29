From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] mlx5: avoid 64-bit division
Date: Wed, 29 May 2019 13:08:00 -0300
Message-ID: <20190529160800.GA6680@ziepe.ca>
References: <20190520111902.7104DE0184@unicorn.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190520111902.7104DE0184@unicorn.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Kubecek <mkubecek@suse.cz>
Cc: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Ariel Levkovich <lariel@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 20, 2019 at 01:19:02PM +0200, Michal Kubecek wrote:
> Commit 25c13324d03d ("IB/mlx5: Add steering SW ICM device memory type")
> breaks i386 build by introducing three 64-bit divisions. As the divisor
> is MLX5_SW_ICM_BLOCK_SIZE() which is always a power of 2, we can replace
> the division with bit operations.
> 
> Fixes: 25c13324d03d ("IB/mlx5: Add steering SW ICM device memory type")
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/infiniband/hw/mlx5/cmd.c  | 9 +++++++--
>  drivers/infiniband/hw/mlx5/main.c | 2 +-
>  2 files changed, 8 insertions(+), 3 deletions(-)

Applied to for-rc, thanks

Jason
