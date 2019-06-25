From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [for-next V2 08/10] linux/dim: Implement rdma_dim
Date: Tue, 25 Jun 2019 15:02:04 -0700
Message-ID: <bfa2159e-1576-6b3c-c85b-ee98bd4f9a47@grimberg.me>
References: <20190625205701.17849-1-saeedm@mellanox.com>
 <20190625205701.17849-9-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190625205701.17849-9-saeedm@mellanox.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Tal Gilboa <talgi@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Yamin Friedman <yaminf@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org


> +void rdma_dim(struct dim *dim, u64 completions)
> +{
> +	struct dim_sample *curr_sample = &dim->measuring_sample;
> +	struct dim_stats curr_stats;
> +	u32 nevents;
> +
> +	dim_update_sample_with_comps(curr_sample->event_ctr + 1,
> +				     curr_sample->pkt_ctr,
> +				     curr_sample->byte_ctr,
> +				     curr_sample->comp_ctr + completions,
> +				     &dim->measuring_sample);

If this is the only caller, why add pkt_ctr and byte_ctr at all?
