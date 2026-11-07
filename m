Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794083109;
	b=E3Y9bCvx/CK+Xc9AyK4XDGQnsR+90hf94WIIJZgzLtiz24hqoPTU2vXfGhCqUuIY1x4q
	 CPioJMva+Vtf9YeFpiRCiWEeXuThISLQd424BWKDN+I7482G2nMsVkjJCqaZE7Pxbhva7
	 Rds5+lr6Yf7drcvpuWXAHy3cL8S5cBhldqdZQ0aEsxjz/zm8Re2WiYdHHkaDWUmcEDOA6
	 I50l+4r3Q4eN+0zpikZ4gq3j3JRvv5j9C0BpbapjIair3SAqOvgLUkM3hCdiXC7cldgsa
	 mHr4gzO+8gT4eqg6xyk+lF8QL36ikHFehrztfVpHidZUo6UVoFqUI5+aR0PtAimQVUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794083109;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=UOtCBSOn5V/eKHQPasnj6GmvDtV9GtzD6cyzFQmsMc0=;
	b=LPfMh1lhh55zqGVXe0FpeYqTQjyMAycakPArHz/UmtxwdRFgU8ysYQWLbv2KExWhOzHY
	 nim9985qaj2Md9Q+CLXn6CLuGHoBO7gZyGBwgtqcfcH2Ril3hz+4wAmbfbqEku3pfL2eH
	 7RHJN2yDzVm+SOUZcHvEyGMqfXTG20kAvq5HM7ll49ROF664+QLeLPzOKzsaSfH2gFdYN
	 2oBRlmdHhvcjWQuIoZbPiCqmcyQ9rJIuTklRNByf6VXt3j5Yj2J8A//U5KzZFa7Uc+Qss
	 35S0txRjKP/aKN9tnKcumTRC35lMJxx3Oxbvvk8vYK0LWx3WPXvTePwnfAsGTlnRUQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aaDlFMos;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB7B606EEA3;
	Sat,  7 Nov 2026 20:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aaDlFMos
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C741F008A2;
	Sat,  7 Nov 2026 20:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794083108;
	bh=UOtCBSOn5V/eKHQPasnj6GmvDtV9GtzD6cyzFQmsMc0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=aaDlFMos8NGprK1dc67qWLXWsbtACSDr+UDRch2SccFrngCDgaSvMWHfeV49sQFyx
	 P2VrXRCnuXVhXuFT8V0xAb8k9GJFp2LyJLZLcZS0YE2T01bVPM2RIPXSa7n4qsfbYo
	 sKEHvpaX9bE7f8auaWgrkk1mT2P7Px1K0xVibQu2CPF41EdDAAiUZQdgsLoEtu99IF
	 y1t13ExDw5Z9ELuc1vDzs++HnI5DKn2lbvKaoMLct61niIvrmiS/83NHfH8EbZzBjQ
	 vVsvrizz5FLqw5tPCmFDJsNwkJIjBbwsHqjvXxKnALRhvALAQVvymMgBn1EFqYQEew
	 4C1QxZ5gB9biQ==
Subject: Re: [PATCH rdma-next 21/23] RDMA/mlx5: Clamp log_max_* shifts in
 query_device and ucontext paths
From: netdev-bot+sashiko@kernel.org
To: yishaih@nvidia.com
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
 davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
 moshe@nvidia.com, maorg@nvidia.com
Date: Sat, 07 Nov 2026 20:25:07 +0000
Message-ID: <179408310732.994134.11296743978617194234@kernel.org>
In-Reply-To: <20261103163949.1554-22-yishaih@nvidia.com>
References: <20261103163949.1554-22-yishaih@nvidia.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] mlx5_ib_create_srq() (drivers/infiniband/hw/mlx5/srq.c) now
  takes its SRQ size limit from MLX5_CAP_GEN_LOGSZ_U32(log_max_srq_sz).
- [Low] The commit message does not fully match the diff.
- [Low] When FW reports log_max_cq_sz >= 31, mlx5_ib_query_device() now
  advertises props->max_cqe = MLX5_CAP_GEN_LOGSZ_U32(log_max_cq_sz) - 1…

--

RDMA/mlx5: Clamp log_max_* shifts in query_device and ucontext paths

This commit replaces the open-coded 1 << cap computations of FW log_max_*
capabilities with MLX5_CAP_GEN_LOGSZ_U32() and MLX5_CAP_GEN_LOGSZ_U64().
This covers the query_device, query_port, ucontext and SRQ create paths.
It also computes max_qp_wr in 64 bits and saturates the max_res_rd_atom
and max_total_mcast_qp_attach products at U32_MAX.

> The device, port and ucontext attributes and the SRQ size limit are
> computed as 1 << cap from 8-bit log_max_* FW capabilities. An untrusted
> NIC can report 31 or more, which makes the shift undefined. The same
> applies to 1ull << log_pg_sz with a value of 64 or more.

[Severity: Low]
This isn't a bug, but is the "8-bit log_max_*" description accurate? In
mlx5_ifc.h several of the converted fields are narrower, for example:

	u8         log_max_msg[0x5];

log_tag_matching_list_sz is also 5 bits wide. log_max_klm_list_size and
log_max_ra_req_qp are 6 bits.

The diff also changes the tso_caps computation in mlx5_ib_query_device():

	resp.tso_caps.max_tso = BIT(max_tso);

Here max_tso comes from the 5-bit Ethernet cap MLX5_CAP_ETH(max_lso_cap),
not from a log_max_* general cap, and the commit message doesn't mention
this change. The BIT() conversion itself looks correct.

Could the message be updated to cover this change and to fix the field
width?

> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index c29102260989f..ace4cdc95c9da 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c

[ ... ]

> @@ -1111,29 +1112,31 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
>  	props->max_send_sge = max_sq_sg;
>  	props->max_recv_sge = max_rq_sg;
>  	props->max_sge_rd	   = MLX5_MAX_SGE_RD;
> -	props->max_cq		   = 1 << MLX5_CAP_GEN(mdev, log_max_cq);
> -	props->max_cqe = (1 << MLX5_CAP_GEN(mdev, log_max_cq_sz)) - 1;
> +	props->max_cq		   = MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_cq);
> +	props->max_cqe = MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_cq_sz) - 1;

[Severity: Low]
If FW reports log_max_cq_sz >= 31, this advertises max_cqe as 2^31 - 1.
Can the CQ create path actually honour that value?

mlx5_ib_create_user_cq() in cq.c rounds the requested size up and then
checks it against INT_MAX:

	if (entries > max_cq_entries || entries > INT_MAX)
		return -EINVAL;

cq_roundup_entries() is 1ULL << fls64(cqe), so any cqe in
[2^30, 2^31 - 1] rounds up to 2^31 and gets -EINVAL. That makes the real
maximum 2^30 - 1.

Would a consumer that sizes its CQ from attrs.max_cqe then fail to create
the CQ? For log_max_cq_sz <= 30 the two values agree.

[ ... ]

> diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
> index 6a4a937d97ce9..3fbb0eaf12558 100644
> --- a/drivers/infiniband/hw/mlx5/srq.c
> +++ b/drivers/infiniband/hw/mlx5/srq.c
> @@ -198,7 +198,7 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
>  	size_t buf_size;
>  	int err;
>  	struct mlx5_srq_attr in = {};
> -	__u32 max_srq_wqes = 1 << MLX5_CAP_GEN(dev->mdev, log_max_srq_sz);
> +	__u32 max_srq_wqes = MLX5_CAP_GEN_LOGSZ_U32(dev->mdev, log_max_srq_sz);

[Severity: Medium]
With log_max_srq_sz >= 31 this limit now saturates at 2^31. Can the rest
of mlx5_ib_create_srq() handle queue sizes that large?

In adversarial mode the caps filter passes log_max_srq_sz through
unchanged (MLX5_HCA_CAP_ALLOW in caps_filter.c). A uverbs user could then
request max_wr = 0x7fffffff, which passes the
init_attr->attr.max_wr >= max_srq_wqes check. After that:

	srq->msrq.max    = roundup_pow_of_two(init_attr->attr.max_wr + 1);

This stores 2^31 into the int max field of struct mlx5_core_srq, which
becomes INT_MIN.

	buf_size = srq->msrq.max * desc_size;
	if (buf_size < desc_size)
		return -EINVAL;

When msrq.max >= 2^26, this size_t product is a power of two >= 2^31. It
passes the wrap check. However, create_srq_user() and create_srq_kernel()
take int buf_size, so the value is truncated to 0 or INT_MIN.

On the user path the truncated value becomes the min_size passed to
ib_umem_get_desc_check(), so a dmabuf descriptor of any size is accepted.

in.log_size = ilog2(srq->msrq.max) still describes the full queue to FW.
mlx5_cmd_create_srq()->create_srq_cmd()->__set_srq_page_size() then calls
get_pas_size(), which computes:

	u32 rq_sz	  = 1 << (log_srq_size + 4 + log_rq_stride);

Here the shift count is 32 to 36. That is the same kind of undefined shift
this commit removes.

The garbage result feeds the WARN_ON() that compares against
ib_umem_num_dma_blocks() in __set_srq_page_size(). A local user could
make that WARN fire, or create an SRQ whose FW-declared size doesn't match
the pinned buffer.

Finally, init_attr->attr.max_wr = srq->msrq.max - 1 is a signed overflow
when msrq.max is INT_MIN.

The downstream overflow could already be reached with log_max_srq_sz
values of 26 to 30. However, the commit message notes "the limits can now
reach 2^31" and fixes other consumers of 2^31 values.

Should the SRQ path get a tighter bound as well? For example, it could
reject msrq.max > INT_MAX / desc_size, or keep
log_size + 4 + wqe_shift below 32. The sibling patch "RDMA/mlx5: Clamp
log_max_cq_sz shift in CQ size checks" adds a similar INT_MAX bound for
CQs.

>  	__u32 max_sge_sz =  MLX5_CAP_GEN(dev->mdev, max_wqe_sz_rq) /
>  			    sizeof(struct mlx5_wqe_data_seg);
>

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103163949.1554-1-yishaih%40nvidia.com
