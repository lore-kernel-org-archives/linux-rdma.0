From: David Miller <davem@davemloft.net>
Subject: Re: [for-next 07/11] net/mlx5: E-Switch, Create generic header
 struct to be used by representors
Date: Wed, 20 Dec 2017 12:58:58 -0500 (EST)
Message-ID: <20171220.125858.1378708055295289661.davem@davemloft.net>
References: <20171219203340.2600-1-saeedm@mellanox.com>
        <20171219203340.2600-8-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171219203340.2600-8-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: saeedm@mellanox.com
Cc: dledford@redhat.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, leonro@mellanox.com, markb@mellanox.com
List-Id: linux-rdma@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Tue, 19 Dec 2017 12:33:36 -0800

> +static int esw_offloads_load_reps(struct mlx5_eswitch *esw, int nvports)
> +{
> +	u8 rep_type = 0;
> +	int err;
> +
> +	while (rep_type < NUM_REP_TYPES) {
> +		err = esw_offloads_load_reps_type(esw, nvports,
> +						  rep_type);
> +		if (err)
> +			goto err_reps;
> +		rep_type++;
> +	}

Please, don't obfuscate what is a normal for() loop:

	for (rep_type = 0; rep_type < NUM_REP_TYPES; rep_type++)

Thanks.
