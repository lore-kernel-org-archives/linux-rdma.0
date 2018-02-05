From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Regression: Connect-X5 doesn't connect with NVME-of
Date: Mon, 5 Feb 2018 13:23:57 +0200
Message-ID: <dbda15f0-f678-9fab-dffe-5e8d2ae24ae1@mellanox.com>
References: <66a5332c-01ee-7a39-8224-189fa52a7298@deltatee.com>
 <e6cdfbe7-762c-c70c-be5f-397bdb08ee80@mellanox.com>
 <0d629a68-a1fa-7297-e371-5abbc2dd5fe7@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0d629a68-a1fa-7297-e371-5abbc2dd5fe7-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: he
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, linux-nvme <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sagi/Logan,

I've repro it with v4.14.1 (not happens on each connect).
Sagi's proposal below fix the issue of the "Failed to write to 
/dev/nvme-fabrics: Invalid cross-device link".

Sagi can you push (with my Tested-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> 
and Reviewed-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>) it or I will ?

The crush after the connection failure is fixed in my patches for NVMe 
core state machine fixes that are under review in the list.


> 
> So I think this should make the problem go away:
> -- 
> diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
> index a0610427e168..b82c4ae92411 100644
> --- a/include/linux/mlx5/driver.h
> +++ b/include/linux/mlx5/driver.h
> @@ -1238,7 +1238,7 @@ mlx5_get_vector_affinity(struct mlx5_core_dev 
> *dev, int vector)
>          int eqn;
>          int err;
> 
> -       err = mlx5_vector2eqn(dev, vector, &eqn, &irq);
> +       err = mlx5_vector2eqn(dev, MLX5_EQ_VEC_COMP_BASE + vector, &eqn, 
> &irq);
>          if (err)
>                  return NULL;
> -- 
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
