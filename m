From: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] net/mlx5e: hide an unused variable
Date: Wed, 3 Jan 2018 17:04:03 -0800
Message-ID: <be87f2c4-ef57-4176-9d9f-0de5cecdf0da@mellanox.com>
References: <20180103224022.3737385-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180103224022.3737385-1-arnd-r2nGTMty4D4@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Paul Blakey <paulb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 1/3/2018 2:40 PM, Arnd Bergmann wrote:
> The uplink_rpriv variable was added at the start of the function but
> only used inside of an #ifdef:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en_tc.c: In function 'mlx5e_route_lookup_ipv6':
> drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:1549:25: error: unused variable 'uplink_rpriv' [-Werror=unused-variable]
> 
> This moves the declaration into that #ifdef as well.
> 
> Fixes: 5ed99fb421d4 ("net/mlx5e: Move ethernet representors data into separate struct")
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

Acked-by: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thank you Arnd.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
