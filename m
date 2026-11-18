Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022032;
	b=NWRVKTrMTVbDCdsA0HqqjT07zv7Rge7qEoQStIk5g1A0gjxTczrJcQOIibvkpI/r18lI
	 d8u+GxGbyOdS0KOylpsK6istI0poe6dvcouTBas+P816umQ8oRWjnVh32TZn77cJFY4sq
	 YZVy6nmy15qpbNKh61aV2BLj/uNLa0w6fG3IFxaYr76GHeN4czWD1eDeq3Pqb+86Ns+nj
	 ExWhQxyTYVWf6lSto7/iagnOSnImIOE+YE0RaFMdUeh8v4xxWHzvg2wlFKuQnToFN709y
	 h3ixJeImBoXbY31AmzBylQbsFOufVIgMbG5UIXvWdre1o+RMR2G2f0wPOUq9wHLAN7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022032;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bK3Y53hTTpnmVOpgF3zHKHnKFqO4NmXQ/iWdVDleRY0=;
	b=ohOpXtL8Y6W4EnXjf9jU387gz5ijDVrmZBxj1yAYwJNcs/QJAtX4bISZpaL4JkayGsgM
	 o7kIBfxh3NYxThii44w65LxanKWm0Y+5fcZ6+MV+CgoxoGpM7t0CZaFBt5QOHRxk6dBfk
	 XLewbbCABqJshMh9S+P0bVmAUtWn3UB+kpmJ2M4iuPlfv2Tu+8mlwl/qCO8lYKpnnbycF
	 Yzj1MmBEWMLMLHtZgThNqp4HMX+Z9lq3rKN7DcQuq9lQoEqtXA9/z2cfORehE82HgvAWM
	 Wo/IQgABS0TLybT8gDDGb7xSKU5lkApi8fsLZbBZsb7Z+mk6/taijIUcc+OqOp7afrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="JZFs2/jc";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E0060A260B
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 17:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JZFs2/jc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D313C1F000C5;
	Wed, 18 Nov 2026 17:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795022032;
	bh=bK3Y53hTTpnmVOpgF3zHKHnKFqO4NmXQ/iWdVDleRY0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JZFs2/jcWxlfEfvr54KKA8HhyLHOccEVjHaDJixcsRLHPp1Ew3b2AzfPqEnEQzcNM
	 2tBv7fdK5KE0s6bOnHGogM4+e9LDqLBbEzCUMG95pzAwW/JnOjT/MBRvh7dWbTbYH3
	 7BaJN9ScoviYmjx2r/USOoKlpIQ3BfkYyeXWm4RtVpBmm/OrG3tEZV48881iFTn7j0
	 7qvC6qOmKot+uk0BMOpgyRi5TjXbc99YgOVWpL2Fsjq1Py8RbeVTr/cfZEqK9mPEA9
	 B7XeROOicBGg4cS9w7kWnL0QDrbymeZQP+2DGp4FP+YHxRzmIto8obWKVw1e/HZzOg
	 eG5MVx6j4Vd7g==
Message-ID: <sashiko-outbox-221618@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V2 rdma-next 17/21] RDMA/mlx5: Validate firmware RQ/SQ
 state before sqrq_trans[] lookup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117170914.27410-18-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-18-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 17:13:51 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] RDMA/mlx5: sqrq_state_to_qp_state() accepts invalid FW states
  2 and 4
--

commit 3eeb50e819c6aa09e6f32a3af53732e8d4d484f9
Author: Yishai Hadas <yishaih@nvidia.com>

RDMA/mlx5: Validate firmware RQ/SQ state before sqrq_trans[] lookup

This commit bounds-checks the RQ and SQ states returned by firmware
against MLX5_RQ_NUM_STATE and MLX5_SQ_NUM_STATE before indexing
sqrq_trans[] in sqrq_state_to_qp_state().

> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5=
/qp.c
> index 19cbf6b2b979d..05e8e75d734fb 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -5081,6 +5081,9 @@ static int sqrq_state_to_qp_state(u8 sq_state, u8 r=
q_state,
>  		},
>  	};
> =20
> +	if (sq_state >=3D MLX5_SQ_NUM_STATE || rq_state >=3D MLX5_RQ_NUM_STATE)
> +		return -EIO;
> +
>  	*qp_state =3D sqrq_trans[rq_state][sq_state];
> =20
>  	if (*qp_state =3D=3D MLX5_QP_STATE_BAD) {

[Severity: Medium]
Can an untrusted NIC still return invalid hardware states 2 or 4 from
QUERY_SQ and QUERY_RQ and bypass this check?

In mlx5_ifc.h, the defined hardware states are RST (0x0), RDY (0x1), and
ERR (0x3).  State 2 is undefined in the hardware interface and indexes an
uninitialized row or column in sqrq_trans[][], which evaluates to 0
(IB_QPS_RESET) and overwrites qp->state with IB_QPS_RESET.  State 4 is the
driver-internal sentinel MLX5_SQ_STATE_NA / MLX5_RQ_STATE_NA (used when
wqe_cnt is 0), which either misreports the QP state or maps to
MLX5_QP_STATE_BAD and triggers the WARN(1) below.

In addition, query_raw_packet_qp_sq_state() and
query_raw_packet_qp_rq_state() assign sq->state and rq->state before
sqrq_state_to_qp_state() validates the state, so an invalid firmware value
still corrupts the cached queue state even when the query fails:

drivers/infiniband/hw/mlx5/qp.c:query_raw_packet_qp_sq_state() {
	err =3D mlx5_core_query_sq_state(dev->mdev, sq->base.mqp.qpn, sq_state);
	if (err)
		goto out;
	sq->state =3D *sq_state;
    ...
}

Validating that the firmware state is RST, RDY, or ERR inside
query_raw_packet_qp_sq_state() and query_raw_packet_qp_rq_state() before
assigning sq->state and rq->state would avoid both issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117170914.2741=
0-1-yishaih@nvidia.com?part=3D17
