From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH rdma-next 3/3] IB/mlx5: Introduce a new mini-CQE format
Date: Mon, 28 May 2018 10:11:48 -0600
Message-ID: <20180528161148.GD17491@mellanox.com>
References: <20180527104234.17261-1-leon@kernel.org>
 <20180527104234.17261-4-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180527104234.17261-4-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Yonatan Cohen <yonatanc@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, May 27, 2018 at 01:42:34PM +0300, Leon Romanovsky wrote:
> From: Yonatan Cohen <yonatanc@mellanox.com>
> 
> The new mini-CQE format includes the stride index, byte count and
> packet checksum.
> Stride index is needed for striding WQ feature.
> This patch exposes this capability and enables its setting
> via mlx5 UHW data as part of query device and cq creation.
> 
> Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
> Reviewed-by: Guy Levi <guyle@mellanox.com>
> Signed-off-by: Yonatan Cohen <yonatanc@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/infiniband/hw/mlx5/cq.c   | 42 +++++++++++++++++++++++++++++----------
>  drivers/infiniband/hw/mlx5/main.c |  4 ++++
>  include/uapi/rdma/mlx5-abi.h      |  2 +-
>  3 files changed, 37 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
> index 7b4ce1a19de0..ad39d64b8108 100644
> +++ b/drivers/infiniband/hw/mlx5/cq.c
> @@ -751,6 +751,28 @@ static int alloc_cq_frag_buf(struct mlx5_ib_dev *dev,
>  	return 0;
>  }
>  
> +enum {
> +	MLX5_CQE_RES_FORMAT_HASH = 0,
> +	MLX5_CQE_RES_FORMAT_CSUM = 1,
> +	MLX5_CQE_RES_FORMAT_CSUM_STRIDX = 3,
> +};

What is this??

> +static int mini_cqe_res_format_to_hw(struct mlx5_ib_dev *dev, u8 format)
> +{
> +	switch (format) {
> +	case MLX5_IB_CQE_RES_FORMAT_HASH:
> +		return MLX5_CQE_RES_FORMAT_HASH;

Used here..

> +		mini_cqe_format =
> +			mini_cqe_res_format_to_hw(dev,
> +						  ucmd.cqe_comp_res_format);

And format comes from a ucmd, so that enum is upai.

Put it in the right place and put the right comment beside
struct mlx5_ib_create_cq's cqe_comp_res_format..

And what is wrong with the user space patches? Where is the update to
enum mlx5dv_cqe_comp_res_format ? And why is this wrong?

struct mlx5dv_cq_init_attr {
        uint64_t comp_mask; /* Use enum mlx5dv_cq_init_attr_mask */
        uint8_t cqe_comp_res_format; /* Use enum mlx5dv_cqe_comp_res_format */
                                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^

No, it isn't, and there isn't even an enum for it. Are you sure this is
designed right? Looks pretty wrong to me.

Fix it all please, and you need to arrange things to share the uapi
header with dv just like verbs is doing.

No more of this lax attitude toward uapi!

Jason
