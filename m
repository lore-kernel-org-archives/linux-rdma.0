Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794820017;
	b=5cVqpnsjNiTXCY3B0oKIqANSN63T65gqBmqFHco421iDQLehr6sYqkCXynmh5NXfjjdk
	 Bj8od6SewJ8j30GZzJad2BjK7uV1hNl55kyHQSYdtdW7YEngRF7wDnza/0ffnpDG6B7E9
	 288/Wfzm2cZaCydeBW5Wf62i8qiiLUuhOLO43OCyMpB7ra9pnI4VzDR+NwIasBLU83ZGR
	 J+6jHwX/yCfAeFjwT8ji/SH4xqUx21tjGoW5tK92z3Ck4pB6HYFhEAXzAi11B81Ke4AUb
	 6sd0zoxrAHYjLbTrvaICZLqCk5vt/osGCZ9rVfr2ELDSB5gp6G42WOrWdxKQdTdvHYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794820017;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=HzdFWao8nHMu2yPSIorlZRQ2GzCXWpvPZ8IlfEMR3o8=;
	b=EOQneq9gnliQyCebVUu6Bv4CDcpAAlYn0Ac3jK/LceOk5DWeQ5W4bBYKnd6fx6wZqhWY
	 BqLG7r6sMJ1FruJ9Vb9hk9CUWY3BG1XG2+dikWy6mCSAbP+h3vuEhm+Nyr547MlgmVpzG
	 +liYCq+q1L4ZW1IVK3ytvUxPP5DIy9oU6XY9b5Qr/Sa5iC4cvj2Ce0ixqa/YFR2ByS7+1
	 p5vVnN4EiTIfA4OxJg+QE+bVxk2pf9nSPYrq7vICJtepZKuIM4vAr3iW1ZAkrmqpCGyCA
	 /6q5100c5ZF71CSzurPkd4aMqjBp5VvgnWBpW1WIY7lmEF2Nj80wCA5jmcbzeWt5OOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZYH9Cbpk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1456C606A31C;
	Mon, 16 Nov 2026 09:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZYH9Cbpk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C3A1F000C7;
	Mon, 16 Nov 2026 09:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794820016;
	bh=HzdFWao8nHMu2yPSIorlZRQ2GzCXWpvPZ8IlfEMR3o8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZYH9CbpkF8jZNGpDn/tzJlFp7sjGDNM9JrH0ksokOFYsYIMI3JdzuxgiggfSnk2Zf
	 xgH1p3c3i2eusMJCdKDHwUhS3KE3G6CgLUJYsm8x4PNGKP05z8c9wElhhFj9sgMovM
	 rgwy/IKg+pHtu6dic4LILzUoC3FAPmOoPF64vKslCjEC4uBGFWwN3gjCoKc1ooi5ey
	 +MAeOuL4+KXNDdEPn19Wc4btraNZr6T+bCdwWndq4fRBd+f9NWkHH8Oq2JZDR/9oVI
	 F0EKXE9ml2kJ9GHgRSEvGgDJlkEJ/HhONeskhWnqeqP/Re807Ki18gzXxGRfP5Kv7Z
	 XtyGQTMX3X5+Q==
Date: Mon, 16 Nov 2026 11:06:53 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
	saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com,
	kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
	davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
	moshe@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 rdma-next 22/24] RDMA/mlx5: Clamp log_max_* shifts in
 query_device and ucontext paths
Message-ID: <20261116090653.GD11319@unreal>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-23-yishaih@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110134320.34408-23-yishaih@nvidia.com>

On Tue, Nov 10, 2026 at 03:43:18PM +0200, Yishai Hadas wrote:
> The device, port and ucontext attributes and the SRQ size limit are
> computed as 1 << cap from log_max_* FW capabilities. An untrusted NIC
> can report 31 or more, which makes the shift undefined. The same
> applies to 1ull << log_pg_sz with a value of 64 or more, and to the
> max_tso computed as 1 << max_lso_cap, which can be 31.
> 
> Use MLX5_CAP_GEN_LOGSZ_U32() and MLX5_CAP_GEN_LOGSZ_U64() for these
> values, and BIT() for max_tso. As the limits can now reach 2^31,
> compute max_qp_wr in 64 bits and saturate the max_res_rd_atom and
> max_total_mcast_qp_attach products at U32_MAX. Cap max_cqe at 2^30 - 1,
> the largest CQ size the create path accepts.
> 
> The SRQ size limit then lets the rounded up SRQ size overflow the int
> srq->msrq.max, and the SRQ buffer size exceed the int passed to
> create_srq_user() and create_srq_kernel(). Reject both above INT_MAX,
> computing the buffer size with check_mul_overflow().
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/infiniband/hw/mlx5/mad.c  |  2 +-
>  drivers/infiniband/hw/mlx5/main.c | 65 +++++++++++++++++--------------
>  drivers/infiniband/hw/mlx5/srq.c  | 14 +++++--
>  3 files changed, 46 insertions(+), 35 deletions(-)

<...>

> +	/* The CQ size is a power of two that fits in an int */
> +	props->max_cqe = min_t(u32, MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_cq_sz),
> +			       rounddown_pow_of_two(INT_MAX)) - 1;

<...>

> +	props->max_res_rd_atom	   = min_t(u64, (u64)props->max_qp_rd_atom * props->max_qp,
> +					   U32_MAX);

Avoid min_t() where possible: it silently casts operands to the specified
type instead of checking that their types match.

<...>

> +	props->max_total_mcast_qp_attach =
> +		min_t(u64, (u64)props->max_mcast_qp_attach * props->max_mcast_grp,
> +		      U32_MAX);

<...>

> +	/* srq->msrq.max is an int */
> +	max = roundup_pow_of_two(init_attr->attr.max_wr + 1);
> +	if (max > INT_MAX)

Please fix types instead of doing this check.

> +		return -EINVAL;
> +	srq->msrq.max    = max;
>  	srq->msrq.max_gs = init_attr->attr.max_sge;
>  
>  	desc_size = sizeof(struct mlx5_wqe_srq_next_seg) +
> @@ -238,8 +243,9 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
>  	srq->msrq.max_avail_gather = (desc_size - sizeof(struct mlx5_wqe_srq_next_seg)) /
>  		sizeof(struct mlx5_wqe_data_seg);
>  	srq->msrq.wqe_shift = ilog2(desc_size);
> -	buf_size = srq->msrq.max * desc_size;
> -	if (buf_size < desc_size)
> +	/* create_srq_user() and create_srq_kernel() take an int */
> +	if (check_mul_overflow((size_t)srq->msrq.max, desc_size, &buf_size) ||
> +	    buf_size > INT_MAX)

Same

Thanks.

>  		return -EINVAL;
>  
>  	in.type = init_attr->srq_type;
> -- 
> 2.18.1
> 
> 
