From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH rdma-next 3/4] IB/mlx5: Verify that driver supports user
 flags
Date: Sun, 7 Oct 2018 13:13:45 -0600
Message-ID: <20181007191345.GD20234@mellanox.com>
References: <20181007090337.21037-1-leon@kernel.org>
 <20181007090337.21037-4-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181007090337.21037-4-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Yonatan Cohen <yonatanc@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 07, 2018 at 12:03:36PM +0300, Leon Romanovsky wrote:
> From: Yonatan Cohen <yonatanc@mellanox.com>
> 
> Flags sent down from user might not be supported by
> running driver.
> This might lead to unwanted bugs.
> To solve this, added macro to test for unsupported flags.
> 
> Signed-off-by: Yonatan Cohen <yonatanc@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/infiniband/hw/mlx5/qp.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
> index bae48bdf281c..17c4b6641933 100644
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -1728,6 +1728,15 @@ static void configure_requester_scat_cqe(struct mlx5_ib_dev *dev,
>  		MLX5_SET(qpc, qpc, cs_req, MLX5_REQ_SCAT_DATA32_CQE);
>  }
>  
> +#define MLX5_QP_CREATE_FLAGS_NOT_SUPPORTED(flags) \
> +	 ((flags) & ~(                            \

This needs a cast, it would be better to add something like the check
comp mask function in rdma-core than this goofy macro thing.

Jason
