From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [for-next 01/11] net/mlx5: E-Switch, Refactor vport
 representors initialization
Date: Wed, 20 Dec 2017 14:45:40 -0500 (EST)
Message-ID: <20171220.144540.251766956053019535.davem@davemloft.net>
References: <20171219203340.2600-2-saeedm@mellanox.com>
        <20171220.125734.63810464667583004.davem@davemloft.net>
        <066d5ac8-e95a-f4ec-fda7-31716242cc05@mellanox.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <066d5ac8-e95a-f4ec-fda7-31716242cc05-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Wed, 20 Dec 2017 21:21:51 +0200

> 
> 
> On 20/12/2017 19:57, David Miller wrote:
>> From: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Date: Tue, 19 Dec 2017 12:33:30 -0800
>> 
>>> +int esw_offloads_init_reps(struct mlx5_eswitch *esw)
>>> +{
>>> +	struct mlx5_core_dev *dev = esw->dev;
>>> +	struct mlx5_esw_offload *offloads;
>>> +	struct mlx5_eswitch_rep *rep;
>>> +	int total_vfs = MLX5_TOTAL_VPORTS(dev);
>>> +	u8 hw_id[ETH_ALEN];
>>> +	int vport;
>> 
>> Reverse christmas-tree please.
> we need dev for  MLX5_TOTAL_VPORTS, so we can't have proper reverse christms-tree,

I know that there is this dependency.

> I'll just remove the initialization of total_vfs and do it after the declarations,
> and switch between total_vfs and hw_id. 

Exactly.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
