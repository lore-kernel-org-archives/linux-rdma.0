Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794083086;
	b=CXHTppegYTYM6Mfxo7KQ4XwlBUgyUxq+FRpywk1DH0zW0v4ByKyykZPLMd3SKgTQrQ/b
	 CvMIa+9XW80MXD2hrunyCnszwSpSnxPGvaVZzkkTgrxfN6akpn43Fj33E8objmSNolQrm
	 sVspq2Z9mj7k7EnulizGPUQT540r5k+Sm46FvTtH9zlVPi+1gRMRHQUryppletdOnc4dY
	 +A9yrGGRfdUaBHSW4ZDMl8shVkkOsecPD8WXorxTWCFiQ+WFgttVfDVI5410tMvwQ8Qbf
	 vMw2koJZ50NvniJ0DAoaQuophyeJYWxayHnF4McNYpjfG1NGu8EiLkWHKKhYBCUvXMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794083086;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=ie2u8JN+L70ROsnYxsyM45Ac6lHUETJNMiYrIxdveY0=;
	b=ffI1Zs5wt0L/P0JE3G9AHGiBrG7U+f2kkAI236oJ4q7OiFquh/c/9vukVFOy9ljNGj7o
	 +5Fj/rlJjv9y1Vlwf8aSAM7X4KdJMAaXBHarBizRxnM0j8B0e4ldQPEj65Jt1uMjFHNXh
	 Ht8L1NCrB2XpmFZ/iYcpxplcJ8J+VHFV6J7tMuo/x7zwFWKBmkj2lWznF/Tsls7E0W0gq
	 2HhTI/Oh5/rm7VFNeaxpLXZ46eeiPg4S49Je9a0lEe7UlF2a+VO6aYSJsX0SnRHqXOpWA
	 F4wRJEkSV4Qdh3W5jioQ91Ys/xObXRRfLAw4OG8DkdDol9VR+iTe3SegbGkLahcL45Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=at073aq9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A005606A336;
	Sat,  7 Nov 2026 20:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=at073aq9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E9B1F008A4;
	Sat,  7 Nov 2026 20:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794083085;
	bh=ie2u8JN+L70ROsnYxsyM45Ac6lHUETJNMiYrIxdveY0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=at073aq9q6GB6Cvc7s9pCP3Cpm4fCkGjfNh9CxTyDGamoRg7c7tJPWMEAyRwVglQr
	 uChLQH+bIYajcg9oRkTKApMaq/yaWF6fzyD1mkIc87n0Rxqj9jcN96oqojA4veltSH
	 ZBDWQWRp3qSpK+bpNAUzC7b/fah3Ec+wryUGBzRYu5b24X4Z83+Bdohr8n/LtdRXya
	 EYAo4AflwWdJOb1LPAVLXBg2MUrVehL9al1XaqZktY0GIWKlxM/xpitjl1MahyFavG
	 D7P9RhG6rh6CqnyY+s4dGfM616Z79iFDXtVH74ikllCHxeHfAmQktY+d2FC1gVzNs1
	 OTFKkX4f8VORw==
Subject:
 Re: [PATCH rdma-next 04/23] net/mlx5: Add macros for reading log-based caps
From: netdev-bot+sashiko@kernel.org
To: yishaih@nvidia.com
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
 davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
 moshe@nvidia.com, maorg@nvidia.com
Date: Sat, 07 Nov 2026 20:24:44 +0000
Message-ID: <179408308473.994134.1350427296218795820@kernel.org>
In-Reply-To: <20261103163949.1554-5-yishaih@nvidia.com>
References: <20261103163949.1554-5-yishaih@nvidia.com>
X-sashiko-severity: Low
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

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The concern says MLX5_GET_LOGSZ_CLAMP(), MLX5_CAP_GEN_LOGSZ_U32()
  and MLX5_CAP_GEN_LOGSZ_U64() in include/linux/mlx5/device.h are added…

--

net/mlx5: Add macros for reading log-based caps

This commit adds MLX5_GET_LOGSZ_CLAMP() and the MLX5_CAP_GEN_LOGSZ_U32()
and MLX5_CAP_GEN_LOGSZ_U64() accessors to include/linux/mlx5/device.h.
They compute 2^cap for log2-encoded capability fields, with the shift
clamped to the largest shift that is defined for the result type.

> diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
> index 37727b5ab78f2..f45454f65d5c0 100644
> --- a/include/linux/mlx5/device.h
> +++ b/include/linux/mlx5/device.h

[ ... ]

> @@ -47,6 +48,16 @@
>  #error Host endianness not defined
>  #endif
>  
> +/* Largest shift count that is defined behaviour for a value of type @T. */
> +#define __mlx5_max_shift(T) (BITS_PER_TYPE(T) - 1 - is_signed_type(T))
> +
> +/* Calculate 2^@fld from a log2 cap field. Exponents that don't fit in @T
> + * saturate to the largest representable power of two (not to the type
> + * maximum), avoiding undefined shifts.
> + */
> +#define MLX5_GET_LOGSZ_CLAMP(typ, p, fld, T) \
> +	((T)((T)1 << min_t(u32, MLX5_GET(typ, p, fld), __mlx5_max_shift(T))))
> +

[ ... ]

> @@ -1096,6 +1107,15 @@ enum mlx5_qcam_feature_groups {
>  #define MLX5_CAP_GEN_MAX(mdev, cap) \
>  	MLX5_GET(cmd_hca_cap, mdev->caps.hca[MLX5_CAP_GENERAL]->max, cap)
>  
> +/* 2^cap for log2-encoded general caps */
> +#define MLX5_CAP_GEN_LOGSZ_U32(mdev, cap) \
> +	MLX5_GET_LOGSZ_CLAMP(cmd_hca_cap, \
> +			     mdev->caps.hca[MLX5_CAP_GENERAL]->cur, cap, u32)
> +
> +#define MLX5_CAP_GEN_LOGSZ_U64(mdev, cap) \
> +	MLX5_GET_LOGSZ_CLAMP(cmd_hca_cap, \
> +			     mdev->caps.hca[MLX5_CAP_GENERAL]->cur, cap, u64)
> +

[Severity: Low]
This isn't a bug, but MLX5_GET_LOGSZ_CLAMP(), MLX5_CAP_GEN_LOGSZ_U32() and
MLX5_CAP_GEN_LOGSZ_U64() have no callers in this commit.

Their users show up later in the series, in "RDMA/mlx5: Clamp log_max_cq_sz
shift in CQ size checks", "RDMA/mlx5: Clamp log_max_* shifts in QP and WQ
limit checks" and "RDMA/mlx5: Clamp log_max_* shifts in query_device and
ucontext paths". Those patches convert call sites in cq.c, qp.c, main.c,
mad.c and srq.c under drivers/infiniband/hw/mlx5/. For example, in
mlx5_ib_query_device():

    props->max_mr = MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_mkey);

Could the commit message mention these follow-up users and the reason for
the clamping?

The macro itself looks correct. min_t() limits the shift to 31 for u32 and
to 63 for u64.

The next point is a pre-existing issue that this patch did not introduce.
At the end of the series, net/mlx5 core still open-codes some of these
shifts. One is in get_init_bulk_query_len() and get_max_bulk_query_len()
in fs_counters.c:

    return min_t(int, MLX5_INIT_COUNTERS_BULK,
                 (1 << MLX5_CAP_GEN(dev, log_max_flow_counter_bulk)));

Another is mlx5e_mpwrq_max_num_entries() in en/params.c:

    u32 klm_limit = min(MLX5E_MAX_RQ_NUM_KSMS,
                        1 << MLX5_CAP_GEN(mdev, log_max_klm_list_size));

These shifts are exposed to untrusted firmware values by the earlier patch
"net/mlx5: Add capability filtering in adversarial mode". There,
mlx5_adversarial_filter_general() lets both caps through
MLX5_HCA_CAP_ALLOW without checking their range.

Would it make sense to convert these sites to the new helpers too?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103163949.1554-1-yishaih%40nvidia.com
