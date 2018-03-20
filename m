From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v4 2/6] IB/mlx4: Eliminate duplicate barriers on
 weakly-ordered archs
Date: Tue, 20 Mar 2018 08:48:51 -0600
Message-ID: <20180320144851.GF19744@ziepe.ca>
References: <1521514068-8856-1-git-send-email-okaya@codeaurora.org>
 <1521514068-8856-3-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1521514068-8856-3-git-send-email-okaya@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>
Cc: linux-rdma@vger.kernel.org, timur@codeaurora.org, sulrich@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 19, 2018 at 10:47:44PM -0400, Sinan Kaya wrote:
> Code includes wmb() followed by writel(). writel() already has a barrier on
> some architectures like arm64.
> 
> This ends up CPU observing two barriers back to back before executing the
> register write.
> 
> Since code already has an explicit barrier call, changing writel() to
> writel_relaxed().
> 
> Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
> ---
>  drivers/infiniband/hw/mlx4/qp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>

> diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
> index f045491..74b27b0 100644
> --- a/drivers/infiniband/hw/mlx4/qp.c
> +++ b/drivers/infiniband/hw/mlx4/qp.c
> @@ -3880,8 +3880,8 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
>  		 */
>  		wmb();
>  
> -		writel(qp->doorbell_qpn,
> -		       to_mdev(ibqp->device)->uar_map + MLX4_SEND_DOORBELL);
> +		writel_relaxed(qp->doorbell_qpn,
> +			to_mdev(ibqp->device)->uar_map + MLX4_SEND_DOORBELL);
>  
>  		/*
>  		 * Make sure doorbells don't leak out of SQ spinlock
> -- 
> 2.7.4
> 
