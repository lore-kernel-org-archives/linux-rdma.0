Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69904AA028;
	Sat, 10 Oct 2026 14:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791643332; cv=none; b=gYHS2nFtQcDWRr0v0qgX6/bOjd5/6+BBMfWILIg5wUEHvBiYETbKzd87YGTXW7iLTt3qVygIzTix9XW0ckY/kvm4T/KYwxJuo+EDAFvXXcY4gBjowai84HvvWGjL2n1lP/2Yz3eqaCDk5SJoidsw8IcYTspNKuVV3srprMly5k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791643332; c=relaxed/simple;
	bh=bijLCHoTl1XWeBsHkUhxJdXM84WJOkVDca4r/OrMj9c=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=OEvFsYnUoOiTDut4RpMARCVoD6b6TREavxWMRevgOXekVoJ0vKau5+DT1xnLPEdoyEx7W6j1ZKlOEkremr1sd2Jp6h36hpxDRicUL47+jFk8Q3+3LaB/aUy4GSi9rAe3kCdpkLjCibYnxijKsSD5YXc9KNX08gF2M9tvYgP5i28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WmaHJxpP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WmaHJxpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75801F00893;
	Sat, 10 Oct 2026 14:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791643331;
	bh=ncy+Qj9eK5h0bJfNo03z4CzbLalTBn1FGjvUrQIOBCQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WmaHJxpPn3o0WJCZRugAyuK8IZqbYuSc/9l4gFFiXq0oJmy1O/TFViX0Ziw/lIGiQ
	 CKSiEuko72SjC1J2L8NpF1hyPYe+HW43ytlVAW/R6WJ+Hak6pXjY9CJ32EdPDjnJOf
	 I9F+KQIW5R2tHzTrd5wOg9ojsnOmQa0vlQqF6bf8nbA9RL22iiEL1SShIqfY8sZO8p
	 mRUN0empXO4B2jDuGriUpt4KoM3gVWPX+szgYQfev4hy1+7bf+aFJsoh+v0eu3op1P
	 xor3SEmynqmb4XyLgKDvU8EcISgzfsgOfBflOxAvXsW6ZVoBv8EO6f5OGJIU09n6ab
	 h0Uv41Aiz3U9g==
Message-ID: <sashiko-outbox-166665@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 04/13] net: mana: swap queue sets in
 mana_set_channels
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <a4bef0e79343469ce47507a44d0094d63e7bc131.1790795005.git.weh@linux.microsoft.com>
References: <cover.1790795005.git.weh@linux.microsoft.com>
 <a4bef0e79343469ce47507a44d0094d63e7bc131.1790795005.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 14:42:10 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] networking: u64_stats_sync writer in mana_fold_rxq_stats does not =
disable preemption/BH
--

commit 93d72a1c224b35993067fa6f5051dfe42f90cf43
Author: Long Li <longli@microsoft.com>

net: mana: swap queue sets in mana_set_channels

Build a replacement queue set before quiescing TX. After closing the
TX/XDP gate and draining its readers, wait up to 120 seconds for ALL
old TX queues before changing pointers, queue counts or RSS.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/=
ethernet/microsoft/mana/mana_en.c
> index 02cd5f7656ed8..10225c09f5b7f 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c

[ ... ]

> @@ -1094,6 +1132,58 @@ static void mana_free_queue_stats(struct mana_port=
_context *apc)
>  	apc->txq_stats =3D NULL;
>  }
> =20
> +/* Fold under RTNL after drain_stats writers quiesce. Clear drain_stats =
to
> + * prevent double counting on rollback.
> + */
> +static void mana_fold_rxq_stats(struct mana_port_context *apc,
> +				struct mana_rxq *rxq)
> +{
> +	struct mana_stats_rx *src =3D &rxq->drain_stats;
> +	struct mana_stats_rx *dst;
> +	unsigned int i;
> +
> +	ASSERT_RTNL();
> +
> +	if (!apc->rxq_stats_ret || rxq->rxq_idx >=3D apc->max_queues)
> +		return;
> +
> +	dst =3D &apc->rxq_stats_ret[rxq->rxq_idx];
> +
> +	u64_stats_update_begin(&dst->syncp);

[Severity: High]
Does this code expose a sequence counter race window to lockless readers?

The mana_fold_rxq_stats() function runs in process context under RTNL, but
it calls u64_stats_update_begin() without first disabling preemption or
bottom-halves (softirqs).

The u64_stats_sync API strictly requires writers to run with preemption
disabled, and BH disabled if readers can be in softirq context. On 32-bit
architectures, this macro increments a sequence counter.

If a reader (like ndo_get_stats64 invoked via dev_get_stats() from a
softirq or another thread) preempts the writer on the same CPU while the
sequence counter is odd, the reader could spin infinitely in
u64_stats_fetch_retry() waiting for it to become even, causing a hard
deadlock.

Should the update be wrapped in local_bh_disable() and local_bh_enable(),
or use the _irqsave variant?

> +	dst->packets		+=3D src->packets;
> +	dst->bytes		+=3D src->bytes;
> +	dst->xdp_drop		+=3D src->xdp_drop;
> +	dst->xdp_tx		+=3D src->xdp_tx;
> +	dst->xdp_redirect	+=3D src->xdp_redirect;
> +	dst->pkt_len0_err	+=3D src->pkt_len0_err;
> +	for (i =3D 0; i < ARRAY_SIZE(dst->coalesced_cqe); i++)
> +		dst->coalesced_cqe[i] +=3D src->coalesced_cqe[i];
> +	u64_stats_update_end(&dst->syncp);
> +
> +	src->packets		=3D 0;
> +	src->bytes		=3D 0;
> +	src->xdp_drop		=3D 0;
> +	src->xdp_tx		=3D 0;
> +	src->xdp_redirect	=3D 0;
> +	src->pkt_len0_err	=3D 0;
> +	for (i =3D 0; i < ARRAY_SIZE(src->coalesced_cqe); i++)
> +		src->coalesced_cqe[i] =3D 0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1790795005.gi=
t.weh@linux.microsoft.com?part=3D4
