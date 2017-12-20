From: Mark Bloch <markb@mellanox.com>
Subject: Re: [for-next 01/11] net/mlx5: E-Switch, Refactor vport representors
 initialization
Date: Wed, 20 Dec 2017 21:21:51 +0200
Message-ID: <066d5ac8-e95a-f4ec-fda7-31716242cc05@mellanox.com>
References: <20171219203340.2600-1-saeedm@mellanox.com>
 <20171219203340.2600-2-saeedm@mellanox.com>
 <20171220.125734.63810464667583004.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171220.125734.63810464667583004.davem@davemloft.net>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>, saeedm@mellanox.com
Cc: dledford@redhat.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, leonro@mellanox.com
List-Id: linux-rdma@vger.kernel.org



On 20/12/2017 19:57, David Miller wrote:
> From: Saeed Mahameed <saeedm@mellanox.com>
> Date: Tue, 19 Dec 2017 12:33:30 -0800
> 
>> +int esw_offloads_init_reps(struct mlx5_eswitch *esw)
>> +{
>> +	struct mlx5_core_dev *dev = esw->dev;
>> +	struct mlx5_esw_offload *offloads;
>> +	struct mlx5_eswitch_rep *rep;
>> +	int total_vfs = MLX5_TOTAL_VPORTS(dev);
>> +	u8 hw_id[ETH_ALEN];
>> +	int vport;
> 
> Reverse christmas-tree please.
we need dev for  MLX5_TOTAL_VPORTS, so we can't have proper reverse christms-tree,
I'll just remove the initialization of total_vfs and do it after the declarations,
and switch between total_vfs and hw_id. 

> 
>> +	esw->offloads.vport_reps =
>> +		kcalloc(total_vfs, sizeof(struct mlx5_eswitch_rep),
>> +			GFP_KERNEL);
> 
> That looks really unpleasant:
> 
> 	x = kcalloc(y,
> 		    z, GFP_KERNEL);
> 
> would look so much nicer.
> 
No problem.

Thanks,
Mark.
