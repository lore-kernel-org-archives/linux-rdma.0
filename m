From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH mlx5-next] net/mlx5: Fix DCT creation bad flow
Date: Tue, 12 Mar 2019 15:09:27 -0300
Message-ID: <20190312180927.GB17113@ziepe.ca>
References: <20190306172050.20033-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190306172050.20033-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Yishai Hadas <yishaih@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 06, 2019 at 07:20:50PM +0200, Leon Romanovsky wrote:
> From: Yishai Hadas <yishaih@mellanox.com>
> 
> In case the DCT creation command has succeeded a DRAIN must be issued
> before calling DESTROY.
> 
> In addition, the original code used the wrong parameter for the DESTROY
> command, 'in' instead of 'din', which caused another creation try
> instead of destroying.
> 
> Cc: <stable@vger.kernel.org> # 4.15
> Fixes: 57cda166bbe0 ("net/mlx5: Add DCT command interface")
> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/qp.c | 64 +++++++++++---------
>  1 file changed, 34 insertions(+), 30 deletions(-)

Applied to for-rc

Thanks,
Jason
