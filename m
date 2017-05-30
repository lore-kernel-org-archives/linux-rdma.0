From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v2 2/2] IB/mlx5: set UMR wqe fence according to HCA cap
Date: Tue, 30 May 2017 13:48:56 +0300
Message-ID: <700d9410-56e7-d70f-9de4-87e4e37bca28@grimberg.me>
References: <1495957991-19223-1-git-send-email-maxg@mellanox.com>
 <1495957991-19223-2-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1495957991-19223-2-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
Cc: shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> +static u8 mlx5_get_umr_fence(u8 umr_fence_cap)
> +{
> +	switch (umr_fence_cap) {
> +	case MLX5_CAP_UMR_FENCE_NONE:
> +		return MLX5_FENCE_MODE_NONE;
> +	case MLX5_CAP_UMR_FENCE_SMALL:
> +		return MLX5_FENCE_MODE_INITIATOR_SMALL;
> +	default:
> +		return MLX5_FENCE_MODE_STRONG_ORDERING;
> +	}
> +}

Where are the MLX5_CAP_UMR defines declared? Am I missing something?

What is the value of MLX5_CAP_UMR_FENCE_NONE? if its zero then this
change is not backwards compatible with older FW.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
