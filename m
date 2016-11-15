From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Rework special QP creation error path
Date: Tue, 15 Nov 2016 10:48:31 +0200
Message-ID: <bbc87569-1852-28b8-122a-2fa72b51fe6e@dev.mellanox.co.il>
References: <3a41daa7-cfb8-7374-5dab-dfa3b1bf83ff@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3a41daa7-cfb8-7374-5dab-dfa3b1bf83ff-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/14/2016 6:44 PM, Bart Van Assche wrote:
> The special QP creation error path relies on offset_of(struct mlx4_ib_sqp,
> qp) == 0. Remove this assumption because that makes the QP creation
> code easier to understand.
>
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx4/qp.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
> index 570bc86..b63d6be 100644
> --- a/drivers/infiniband/hw/mlx4/qp.c
> +++ b/drivers/infiniband/hw/mlx4/qp.c
> @@ -644,7 +644,7 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
>  	int qpn;
>  	int err;
>  	struct ib_qp_cap backup_cap;
> -	struct mlx4_ib_sqp *sqp;
> +	struct mlx4_ib_sqp *sqp = NULL;
>  	struct mlx4_ib_qp *qp;
>  	enum mlx4_ib_qp_type qp_type = (enum mlx4_ib_qp_type) init_attr->qp_type;
>  	struct mlx4_ib_cq *mcq;
> @@ -933,7 +933,9 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
>  		mlx4_db_free(dev->dev, &qp->db);
>
>  err:
> -	if (!*caller_qp)
> +	if (sqp)
> +		kfree(sqp);
> +	else if (!*caller_qp)
>  		kfree(qp);
>  	return err;
>  }
>

Looks fine, thanks.
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
