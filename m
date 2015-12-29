From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 1/7] IB/mlx4: Query RoCE support
Date: Tue, 29 Dec 2015 17:19:53 +0200
Message-ID: <5682A499.9040701@mellanox.com>
References: <1451395447-5198-1-git-send-email-matanb@mellanox.com>
 <1451395447-5198-2-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1451395447-5198-2-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/29/2015 3:24 PM, Matan Barak wrote:
> @@ -905,6 +906,8 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
>   		dev_cap->flags2 |= MLX4_DEV_CAP_FLAG2_EQE_STRIDE;
>   	MLX4_GET(dev_cap->bmme_flags, outbox,
>   		 QUERY_DEV_CAP_BMME_FLAGS_OFFSET);
> +	if (dev_cap->bmme_flags & MLX4_FLAG_ROCE_V1_V2)
> +		dev_cap->flags2 |= MLX4_DEV_CAP_FLAG2_ROCE_V1_V2;

Did you make sure that the query dev cap wrapper unsets this bit when 
proxing VF queries?

>   	if (dev_cap->bmme_flags & MLX4_FLAG_PORT_REMAP)
>   		dev_cap->flags2 |= MLX4_DEV_CAP_FLAG2_PORT_REMAP;
>   	MLX4_GET(field, outbox, QUERY_DEV_CAP_CONFIG_DEV_OFFSET);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
