Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9806145519D
	for <linux-rdma@vger.kernel.org>; Sat, 19 Sep 2026 10:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789812372; cv=none; b=GLmOJansyJFVSWj82rdq5ud0CvmwLIbbKp5N7QUJGjMpJYhjpdgyNV2chIckbRl40E3pcKmJtmeuTWs/IYipP2iJ/nSPcUK4J4gXoqTHqXcnC3YufjMVShNYjs/RH+hOLcjzobQMEWeXRdlqzwc2AUpCw2/TeVzvacI4TeqbBjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789812372; c=relaxed/simple;
	bh=+BLXxkSWwnPquViIT44hMv9dvCJUIVb321vq01JZaV4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=h2poKhAgV5PKwHSvjmFwPXqcXZxOPDNRVl1O63WdA6chjb5par+zipunJDNqy0NzDHox/woqkycGJ1QK2tqbHYMPA5CUVKKFwAHCdvN6nfmjRuT5GIfrOxS3D2hs22TgWf40ZLHQZ98LbUzPZTbrxjiw9gM7rNHqaTUK9paXsnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=foWoHEn/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="foWoHEn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732391F000FF;
	Sat, 19 Sep 2026 10:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789812369;
	bh=EVZ2uBiC/JH5r0SsOTbOeXWJJNTomfUE0CN8lVLjQKM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=foWoHEn/qZITnuMO/pJwqzlTch9WUtKSSqlE1+WQD7JXrhKMW7+D3vJiHONt2gA0c
	 lqPzJnTyNcnqte3CIDwLTQVmoahtUIJFKT5EVCunJX9BP77TlAc1oM/BpVXmaJf/Bo
	 selDBHpWeR+55ekYtN7oZpJg2gijF5po1DxbUmVE4y51KbMMRHcBSTrhOD+9UT2/s/
	 k8RwQA0Jt8WC+noEYcVJkRbGdGiHXx5VYNyYyQ8/FcjTO1wDqrTdqSBCZtUyYtUlh/
	 NSMCXtWuOSjqlSdw1bWKCrMgBELOFsvjVete++NJpuoQd/3RaZQQ1DwxVAAg6RMfAd
	 5TjuzMZEmYR6w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/mlx5: Add poll-EQ callback for ULP recovery
Reply-To: sashiko-reviews@lists.linux.dev
To: "Praveen Kumar Kannoju" <praveen.kannoju@oracle.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260918100537.1214162-1-praveen.kannoju@oracle.com>
References: <20260918100537.1214162-1-praveen.kannoju@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 19 Sep 2026 10:06:08 +0000
Message-Id: <20260919100609.732391F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] rdma: ib_reap_eq() silently sleeps, causing schedule-while-atomic
--

commit 849787a8c3532fe1c3027a0b390b27451b5ded2d
Author: Praveen Kumar Kannoju <praveen.kannoju@oracle.com>

RDMA/mlx5: Add poll-EQ callback for ULP recovery

This commit introduces ib_reap_eq() as an optional RDMA device operation to
allow upper layer protocols (ULPs) to poll a completion event queue (EQ). It
implements this callback for mlx5 by mapping the CQ to its EQ and using
mlx5_eq_poll_irq_disabled() to poll it.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/e=
thernet/mellanox/mlx5/core/eq.c
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c

[ ... ]

> @@ -154,15 +154,36 @@ u32 mlx5_eq_poll_irq_disabled(struct mlx5_eq_comp *=
eq)
>  {
>  	u32 count_eqe;
> =20
> +	mutex_lock(&eq->poll_lock);
> +	disable_irq(eq->core.irqn);

[Severity: High]
Could this lead to a scheduling while atomic panic or deadlock?

A ULP detecting a missed EQ notification might call ib_reap_eq() from an
atomic context, such as a timeout timer or while holding a spinlock.

The call chain reaches mlx5_eq_poll_irq_disabled(), which calls mutex_lock()
and disable_irq(). The disable_irq() function calls might_sleep() and
synchronously waits for running IRQ handlers.

[ ... ]

> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h

[ ... ]

> +/**
> + * ib_reap_eq - Poll the event queue associated with a CQ.
> + * @device: Device that owns the CQ.
> + * @cq: CQ whose associated event queue should be polled.
> + *
> + * Poll the device event queue associated with @cq to recover completions
> + * after a missed event queue notification. This is an optional provider
> + * callback.
> + *
> + * Return: 0 on success, %-EINVAL for invalid input, and %-EOPNOTSUPP wh=
en
> + * unsupported.
> + */
> +static inline int ib_reap_eq(struct ib_device *device, struct ib_cq *cq)
> +{
> +	if (!device || !cq || cq->device !=3D device)
> +		return -EINVAL;
> +
> +	if (!device->ops.reap_eq)
> +		return -EOPNOTSUPP;
> +
> +	return device->ops.reap_eq(device, cq);

[Severity: High]
Since CQ polling and timeout mechanisms typically run in atomic contexts
(like softirq), does exposing this API without a might_sleep() check or
documentation risk ULPs misusing the API and crashing the system?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918100537.1214=
162-1-praveen.kannoju@oracle.com?part=3D1
