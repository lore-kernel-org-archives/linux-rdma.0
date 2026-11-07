Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794083093;
	b=PUumcsUWn+ob4GU498sixWU2HXPrFKuVo1QqmNrOyr+ooQe86Hv6MVpqbAeGdc85JmGE
	 gdpeDmA+XOkwZn06h0PDRk4NIxGnbI/o4RHJpPA50MmwUjsLbCbM7mKa27Uo2EjjA0QYG
	 GmOYzUBeqB/XshReVsfVq0L1rK4QFv6GMuNQZj7RoqOAhhzF5VytdAmopv7nt60o3tFLf
	 YqHL8hpar+PRpXmZF3QqiVzzJ3ImiCS0+uwMe+RuUZXW0UycKPgYWLyYT35oeLUcjX3zM
	 KCAj5Wc2uK8kJwcBs3e+++zb1fnexDCcLRbNCfJrUN6ESm6c8K1h0grkN/nDyi9mTCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794083093;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=eJ88kR2RZv5479E9n8qD0nMND7wbcrif7/eT10RPNAo=;
	b=ycYD4b8n76eHVFE82qWLHxzzteri94UnZI3t6UY8hAsLxnSmUv1TNXBfihO2C+4LJvmy
	 8HcMGnTtb9/zKWfUO74BKhS/DSPG1yggqyKWYo3TZt/iiXwHz43/RKXMG8U3D08/9r/LZ
	 QlwRp72Q+4HuWZgnkmiqcuhucapsG4t7VbQKbHwf49EEVDql1Bx4qs0bWXCCW6YkMkExq
	 8lYM5BJZCfk8E1C6w2kv1kZdvprGNbMPxLC6502RQ1V4fPdGuvUN2PL+u9rkiQqBREAK7
	 bmEggHef1wq6qxnvKnPjJ5OLhpfDTuciRLy6ATSlYq85EYTooGGFvq/MXqVDcidqUrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=COuxbkd0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1AB606A33E;
	Sat,  7 Nov 2026 20:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=COuxbkd0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6431F008A4;
	Sat,  7 Nov 2026 20:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794083092;
	bh=eJ88kR2RZv5479E9n8qD0nMND7wbcrif7/eT10RPNAo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=COuxbkd0MLNwLJS/YBpMvrERMT5wDnXvES8Np7Shf+84OE+U4yPwaU+GajnLoy79v
	 sF1jk5tq+awKlPEXlqWu59SaR3vdTgYvZ26zY03gbAaziMwc4GpPubAAnS4B84ymud
	 18/RXZn3x+19n1gbqhtLEvCBoc8kS1Op55HbzMrPtpLbxkk0QQnI7mvBw45p9LNCop
	 nWzOsxLLcvMm3r2nTpEJgIIpvp6U0XLLbU1N20wKOF5hLZGyNBxEt0XLFFCIQQFjQQ
	 gnnjtXwAu8wFu/xJUSgigf5ztnxucXJl9UD1wmZSiEWhz4jxy7zwCWqcD4JGu5rkuA
	 l3VUXCiKfUurA==
Subject: Re: [PATCH rdma-next 10/23] RDMA/mlx5: Introduce per-CQ poll_one hook
 in mlx5_ib_cq
From: netdev-bot+sashiko@kernel.org
To: yishaih@nvidia.com
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
 davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
 moshe@nvidia.com, maorg@nvidia.com
Date: Sat, 07 Nov 2026 20:24:51 +0000
Message-ID: <179408309154.994134.2462822873146851293@kernel.org>
In-Reply-To: <20261103163949.1554-11-yishaih@nvidia.com>
References: <20261103163949.1554-11-yishaih@nvidia.com>
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

- [Low] The commit message calls this "a pure refactor with no behaviour
  change", but it changes the per-CQE fast path.

--

RDMA/mlx5: Introduce per-CQ poll_one hook in mlx5_ib_cq

This adds a poll_one function pointer to struct mlx5_ib_cq. It is
initialized to mlx5_poll_one() in mlx5_ib_create_cq() and
mlx5_ib_create_user_cq(), and mlx5_ib_poll_cq() now dispatches through
it. A follow-up patch uses the hook to install a specialised poll_one for
the UMR CQ.

> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
> index 55ffd7d4de517..11c1153747c24 100644
> --- a/drivers/infiniband/hw/mlx5/cq.c
> +++ b/drivers/infiniband/hw/mlx5/cq.c
> @@ -633,7 +633,7 @@ int mlx5_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
>  		soft_polled = poll_soft_wc(cq, num_entries, wc, false);
>  
>  	for (npolled = 0; npolled < num_entries - soft_polled; npolled++) {
> -		if (mlx5_poll_one(cq, &cur_qp, wc + soft_polled + npolled))
> +		if (cq->poll_one(cq, &cur_qp, wc + soft_polled + npolled))
>  			break;
>  	}

[Severity: Low]
The commit message says:

  This is a pure refactor with no behaviour change.

Does that hold for the per-CQE fast path?

Before this patch, mlx5_poll_one() was static and had one caller, this
loop in mlx5_ib_poll_cq(), so the compiler could inline it.

The patch stores its address in cq->poll_one in mlx5_ib_create_cq() and
mlx5_ib_create_user_cq(). As a result, every polled CQE on every mlx5 CQ
now goes through an indirect call. On kernels with Spectre-v2
mitigations, that call goes through a retpoline thunk.

Only the UMR CQ needs a different implementation, which the later commit
"RDMA/mlx5: Verify UMR CQ polling against a hostile NIC" installs. Even
so, every in-kernel consumer polling an mlx5 CQ (NVMe-oF, iSER, SRP,
NFS/RDMA, SMC-R, RDS, IPoIB) takes the indirect path:

ib_poll_cq()->mlx5_ib_poll_cq()->cq->poll_one()

The end of the series doesn't seem to restore a direct call for the
common case, and there is no INDIRECT_CALL_1() use under
drivers/infiniband/. Would something like this avoid the cost?

    if (INDIRECT_CALL_1(cq->poll_one, mlx5_poll_one,
                        cq, &cur_qp, wc + soft_polled + npolled))

The final mlx5_poll_one() also already has an
unlikely(mlx5_ib_adversarial_mode) check, which a cheap dispatch here
could reuse.

If the indirect call stays, could the commit message mention this
trade-off rather than say there is no behaviour change?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103163949.1554-1-yishaih%40nvidia.com
