Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B6B3563E1;
	Sat, 17 Oct 2026 15:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792251567; cv=none; b=gILBzxnBgSiaKh+d1RWDGhiqYBccgl2dHp9lvAD8vJVFb2Uy4loQM7m6gzTNPQWYK6E8lsmyNKlWlJnH9fl/QTvsx5dXV9LD+g/2tWHR2Z128DJihaQASwP1t5quigvhXwXXlsN4z6HwkIU5xkpZC21DJA9bUTolSI5p580l108=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792251567; c=relaxed/simple;
	bh=tmALeHcK0KPEf+il1XFk2vRPzdNQE4AjvIvXlyM3REU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Jn3ZkcWIpbR0Tbw5PMmJMNj6utehAmyOWJFZ7NVws5ne1hzxhw2u5Sr9Op3aOZ6AXrw9xaJUCF1uO2WD53d4oCbdTfK82hYBOkS442dbrcsJFX5ULjBeliTxmdk0Vq4SPKFRUl754IAVMQ3vMQL4pQkxn0n/oR15WOJD0YarBxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A/C6LEK7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A/C6LEK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27AEE1F000C6;
	Sat, 17 Oct 2026 15:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792251566;
	bh=JfSjsC1ZRTvX8XpcRipx1PJhuMWanUlD56R9jxPOl1A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A/C6LEK7BdpxRW7gVtivr3Q/DT5ofXvz3TfS9Uro/FngJyuQTszmFjpS7g4JeauNs
	 Ye1Zcq32B1p+/AYg6Tn+9mK0NgVo8bgiarHy1Ftt2sEIFKUsI2yG0aRNxggPr0iMLm
	 r7Fn+pusnuavDJ9WK8HZ6QhDO6WH6wJDKBtCSX6PFUK29Vg0k8EwZWeqDLPsZgRZG3
	 zAI27iBDJ6nxKapby8WxR5DYRs4KPcoVyyA0pWiwffEtYiBPnPkFZyOT2tjW6fS5zZ
	 CLW/UgSSvx9ppu+mwHn39cawgxjrLSDoEnFMqKNi79yLa3NjzkZVh5KNqXtY0ZjlKm
	 u/k4eo1JNiDlw==
Message-ID: <sashiko-outbox-175604@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 04/13] net: mana: swap queue sets in
 mana_set_channels
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <ec57f3853ef344a7d5ec8907ba530313b0163bae.1791710735.git.weh@linux.microsoft.com>
References: <cover.1791710735.git.weh@linux.microsoft.com>
 <ec57f3853ef344a7d5ec8907ba530313b0163bae.1791710735.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 15:39:25 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] bpf: concurrent writers to tx_stats->syncp without mutual exclusion
- [High] net: missing BH disable around u64_stats_update_begin() in mana_fo=
ld_rxq_stats()
--

commit 347c8bd66ee5005e7aea875ed691f7a765b23452
Author: Long Li <longli@microsoft.com>

net: mana: swap queue sets in mana_set_channels

This patch introduces a replacement queue set building before quiescing TX.
It drains the old TX queues and swaps pointers, handling statistics folding
upon successful or failed rollback.

> --- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
> @@ -59,6 +59,11 @@ int mana_xdp_xmit(struct net_device *ndev, int n, stru=
ct xdp_frame **frames,
>  	if (unlikely(!apc->port_is_up))
>  		return 0;
> =20
> +	/* Pair with the smp_wmb() in mana_publish_qset() before reading queue
> +	 * state.
> +	 */
> +	smp_rmb();
> +
>  	q_idx =3D smp_processor_id() % ndev->real_num_tx_queues;
> =20
>  	for (i =3D 0; i < n; i++) {

[Severity: High]
Does mana_xdp_xmit() require a lock when updating tx_stats->syncp further
down in this function?

This function acts as the ndo_xdp_xmit callback and maps CPUs to queues
using smp_processor_id() % ndev->real_num_tx_queues. If multiple CPUs map
to the same queue index, or if mana_start_xmit() runs concurrently on the
same queue, multiple threads could concurrently invoke
u64_stats_update_begin(&tx_stats->syncp).

Since there isn't a per-queue mutual exclusion lock acquired here (unlike
the core stack serialization in mana_start_xmit()), could this concurrency
corrupt the sequence counter and cause readers to spin infinitely on 32-bit
systems?

[ ... ]

> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
[ ... ]
> @@ -1123,6 +1161,58 @@ static void mana_free_queue_stats(struct mana_port=
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
> +	dst->packets		+=3D src->packets;
> +	dst->bytes		+=3D src->bytes;

[Severity: High]
Could this u64_stats_update_begin() call deadlock a preempting softirq
reader?

This function runs in process context under rtnl_lock(), which is a mutex
and does not disable bottom halves. Readers of network statistics (like
ndo_get_stats64) can be executed from softirq context.

If a softirq interrupts mana_fold_rxq_stats() on the same CPU while the
writer holds an odd sequence counter, the reader will loop forever in
u64_stats_fetch_retry().

Should this use local_bh_disable() or the _bh wrapper for the stats update
to prevent this scenario?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791710735.gi=
t.weh@linux.microsoft.com?part=3D4
