Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794083104;
	b=WdV+i3sHHalkCqMemsSGsudMmz8F4UCxm4zMuu6XSosLetdrNTa1lONrDoG8McZNtERs
	 wbiTcu4pO6DAniIwhynxLekfEQNkZprREcKNqlk8IL5fGLl5fN840wa+UVXUJKmThLBW4
	 ETQ4rOVMdzfKAzKPnMLeiBCPjJq+XitnM2Z6djaHeihTmD3MqSFZGAMpcEKo1jNAIh2Lo
	 30Xm57Si+Qj2gLf8nyybQwQ5zEEG9puBS3vdtEdoJsMT/i2xdN90DWQdXiqUSkkbjeYR2
	 Bt0ZwBBwCCvM6aFX34ODgbnm0Rx2PeYlgEV0dMhc3oTyhOizZrdhIaYqdrjkhcumJNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794083104;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=cbdqRrawWEmkj/VuzVVVo1aYDLOZxsMyrd3Ku/9wVWo=;
	b=RxZEO9JYna9wMv/l+2T7Da8zTlfLwbFMyx3goBIFvfY0zWhchG6FcfQD3nekbt6HT7f5
	 TWOHuJEq9lWBQY4Po+WBompHkBnBqMHs+XR18INpTGujZYKVqXt6xnsZcR3OvdKsU/btc
	 4JOS4GQ+CxXB2BYmisa4E6gPmONgsHk2jlso8hmcHbPJ3ZYuCd8uHMW0682Ct3ggjpWB6
	 q01utBquiSTmqeODewN8zHFhbXlFd3SYRnEjVFVbYFR3GpOtvtRii/P78+N5sIj3oKvZv
	 67eK0eOeILabJ69QINMwPNsoZmxlVqTZ59SzE/UUliDk9h2yb+RutbGOHPzAFu4xS9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L+7OW8zo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAF1606A339;
	Sat,  7 Nov 2026 20:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L+7OW8zo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFC41F008A1;
	Sat,  7 Nov 2026 20:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794083104;
	bh=cbdqRrawWEmkj/VuzVVVo1aYDLOZxsMyrd3Ku/9wVWo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=L+7OW8zoz9+jIu07FHzDf0sqjY95kdFAYBNrgNuoP6UBXnY5Xc+dX/ErkL2ZOernc
	 3cCkWzcVHeMHG5q1mzrX03fY86za7H82lBCBLKV+7kgJSpcG6me26Ecln3uW7Jd+jN
	 bHA2R1wKKlo55GaRxcPQjGXFuh7nNj0DQLXfZlHfhhgogfwihLuZdNdsa7/gmpbjti
	 abJrYq4RD0TPQKZR4o5OU5WaFmynraIpbXudm+1jHhUFWmeg60jI94GiieZFw1KY8l
	 hwLCXW1cVXEnoD9hUqB1+bB6cD5O6C56XRJ02+UkoqvW6NAOQsDiNFy0Bq91/02VRw
	 EoU/ciiOcmK4g==
Subject: Re: [PATCH rdma-next 18/23] RDMA/mlx5: Validate firmware RQ/SQ state
 before sqrq_trans[] lookup
From: netdev-bot+sashiko@kernel.org
To: yishaih@nvidia.com
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
 davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
 moshe@nvidia.com, maorg@nvidia.com
Date: Sat, 07 Nov 2026 20:25:03 +0000
Message-ID: <179408310322.994134.9461475387371859568@kernel.org>
In-Reply-To: <20261103163949.1554-19-yishaih@nvidia.com>
References: <20261103163949.1554-19-yishaih@nvidia.com>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The new check in sqrq_state_to_qp_state()
  (drivers/infiniband/hw/mlx5/qp.c:5084) bounds the firmware SQ/RQ state…

--

RDMA/mlx5: Validate firmware RQ/SQ state before sqrq_trans[] lookup

This commit adds a bounds check to sqrq_state_to_qp_state() in
drivers/infiniband/hw/mlx5/qp.c. Any SQ or RQ state returned by QUERY_SQ
or QUERY_RQ that is at or above the sqrq_trans[] table dimension is now
rejected with -EIO, which prevents an out-of-bounds read of the 5x5
table.

> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
> index 19cbf6b2b979d..05e8e75d734fb 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -5081,6 +5081,9 @@ static int sqrq_state_to_qp_state(u8 sq_state, u8 rq_state,
>  		},
>  	};
>  
> +	if (sq_state >= MLX5_SQ_NUM_STATE || rq_state >= MLX5_RQ_NUM_STATE)
> +		return -EIO;
> +
>  	*qp_state = sqrq_trans[rq_state][sq_state];

[Severity: Medium]
Should this check compare against the hardware state encodings instead of
the table size?

The hardware only defines three values in include/linux/mlx5/mlx5_ifc.h.
The RQC values are the same:

    MLX5_SQC_STATE_RST  = 0x0,
    MLX5_SQC_STATE_RDY  = 0x1,
    MLX5_SQC_STATE_ERR  = 0x3,

The table dimension comes from a driver-only sentinel in
include/linux/mlx5/qp.h:

    MLX5_SQ_STATE_NA	= MLX5_SQC_STATE_ERR + 1,
    MLX5_SQ_NUM_STATE	= MLX5_SQ_STATE_NA + 1,

That means firmware values 2 and 4 still get past the new check.

query_raw_packet_qp_rq_state() passes the raw 4-bit field through
unchanged, and mlx5_core_query_sq_state() does the same for the SQ:

    *rq_state = MLX5_GET(rqc, rqc, state);

query_raw_packet_qp_state() sets the NA sentinel by default and only
overwrites it for queues that exist:

    u8 sq_state = MLX5_SQ_STATE_NA;
    u8 rq_state = MLX5_RQ_STATE_NA;

    if (qp->sq.wqe_cnt) {
        err = query_raw_packet_qp_sq_state(dev, sq, &sq_state);
    ...

Take an SQ-only raw packet QP where firmware returns SQ state 4. Doesn't
that value alias MLX5_SQ_STATE_NA and land on sqrq_trans[NA][NA]?

    [MLX5_SQ_STATE_NA]	= MLX5_QP_STATE_BAD,

That entry reaches WARN(1, "Buggy Raw Packet QP state, ...") through
ib_query_qp()->mlx5_ib_query_qp()->query_raw_packet_qp_state(). A legal
SQ value on that QP always maps to MLX5_QP_STATE. The RQ-only case with
RQ state 4 behaves the same way.

Value 2 indexes a row or column that is never initialized, so it reads
as 0, which is IB_QPS_RESET. Would ib_query_qp() then report RESET with
no error and no WARN? On an SQ-only QP, any legal value would have
returned qp->state.

On a panic_on_warn system, a device-triggered WARN here becomes a panic.

Would it close this gap to accept only the RST, RDY and ERR encodings,
and only for the queues that were actually queried?

>  
>  	if (*qp_state == MLX5_QP_STATE_BAD) {

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103163949.1554-1-yishaih%40nvidia.com
