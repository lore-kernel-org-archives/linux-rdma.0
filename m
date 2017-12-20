From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [for-next 07/11] net/mlx5: E-Switch, Create generic header struct
 to be used by representors
Date: Wed, 20 Dec 2017 21:22:02 +0200
Message-ID: <380bcff7-f40a-99da-d01a-88b5ae33376d@mellanox.com>
References: <20171219203340.2600-1-saeedm@mellanox.com>
 <20171219203340.2600-8-saeedm@mellanox.com>
 <20171220.125858.1378708055295289661.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171220.125858.1378708055295289661.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 20/12/2017 19:58, David Miller wrote:
> From: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Date: Tue, 19 Dec 2017 12:33:36 -0800
> 
>> +static int esw_offloads_load_reps(struct mlx5_eswitch *esw, int nvports)
>> +{
>> +	u8 rep_type = 0;
>> +	int err;
>> +
>> +	while (rep_type < NUM_REP_TYPES) {
>> +		err = esw_offloads_load_reps_type(esw, nvports,
>> +						  rep_type);
>> +		if (err)
>> +			goto err_reps;
>> +		rep_type++;
>> +	}
> 
> Please, don't obfuscate what is a normal for() loop:
> 
> 	for (rep_type = 0; rep_type < NUM_REP_TYPES; rep_type
In case of an error I'm using a while loop, wanted to use a
while loop on the good path as well, will change to a for loop.

> 
> Thanks.

> 

Thanks!
Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
