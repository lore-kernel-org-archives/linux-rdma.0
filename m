From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next v2 06/17] RDMA/counter: Add "auto"
 configuration mode support
Date: Wed, 22 May 2019 14:15:29 -0300
Message-ID: <20190522171529.GC15023@ziepe.ca>
References: <20190429083453.16654-1-leon@kernel.org>
 <20190429083453.16654-7-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190429083453.16654-7-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Mark Zhang <markz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 29, 2019 at 11:34:42AM +0300, Leon Romanovsky wrote:

> +/**
> + * rdma_counter_unbind_qp - Unbind a qp from a counter
> + * @force:
> + *   true - Decrease the counter ref-count anyway (e.g., qp destroy)
> + */
> +int rdma_counter_unbind_qp(struct ib_qp *qp, bool force)
> +{
> +	struct rdma_counter *counter = qp->counter;
> +	int ret;
> +
> +	if (!counter)
> +		return -EINVAL;
> +
> +	ret = __rdma_counter_unbind_qp(qp, force);
> +	if (ret && !force)
> +		return ret;
> +
> +	rdma_restrack_put(&counter->res);
> +	if (atomic_dec_and_test(&counter->usecnt))
> +		rdma_counter_dealloc(counter);

An atomic that does kfree when it reaches zero should be implemented
with a kref.

Jason
