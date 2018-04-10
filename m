From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] net/mlx5: remove some extraneous spaces in indentations
Date: Tue, 10 Apr 2018 17:22:54 -0600
Message-ID: <20180410232254.mg7stooh5tytv6m2@ziepe.ca>
References: <20180409124336.29274-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180409124336.29274-1-colin.king@canonical.com>
Sender: netdev-owner@vger.kernel.org
To: Colin Ian King <colin.king@canonical.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>, Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 09, 2018 at 01:43:36PM +0100, Colin Ian King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There are several lines where there is an extraneous space causing
> indentation misalignment. Remove them.
> 
> Cleans up Cocconelle warnings:
> 
> ./drivers/net/ethernet/mellanox/mlx5/core/qp.c:409:3-18: code aligned
> with following code on line 410
> ./drivers/net/ethernet/mellanox/mlx5/core/qp.c:415:3-18: code aligned
> with following code on line 416
> ./drivers/net/ethernet/mellanox/mlx5/core/qp.c:421:3-18: code aligned
> with following code on line 422
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/qp.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)

applied to for-next thanks

Jason
