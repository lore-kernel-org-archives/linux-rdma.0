Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBB538B7D2;
	Thu, 10 Sep 2026 22:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789079129; cv=none; b=GJ1NdaA89EkFtOmI1QDYAa4AqWhrTDos8Qt3aFLxPat/bHEyv4ZtGvo+jvWJtDQd7aep6ew4CXxj3wfnEqejtmkQ76qU26l5UyauUpUWUG5UjkCDD5s4vUVjplE15mEgluGNhC/bDbRT+UXkJ46yUBYRzJLaPOXTFppVvA3OkUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789079129; c=relaxed/simple;
	bh=hgCJZl6D2tmzuaehwRFL2OCYANpifIDXWCG8fGSj1Nw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UsVhRbMY6g8JBg2Hf1mWmQ7WJZXJHZxcb79uAJ8dZtJL5FqYnTpnyjtUus2j1pg/o9mHvt0R3V8gDSyv2V+DM/M4JlpIrkwsCTvla1giLRkIS2+FiR3GVNui3Q0j+T5Wfe1sOFNpVoplyTfz6jwfRh4bqVhXD34y2WuPe2JCsek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cOxK8JmE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cOxK8JmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8596D1F0089E;
	Thu, 10 Sep 2026 22:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789079124;
	bh=G6eGxMphi9Wop157wejDBOx0S0AwPAJtEK7f98ZErMQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cOxK8JmEUQimZ0vJWxYfQ+JXw7UE/rexS+P+CnRNo3Uaci8uJWL6PGHVfWIDN7EF5
	 kkrf1cnb20NLrGj45tnWIKcNZA/VH/Kf0fiMIDhjWIRqlXoA+xzALCO9Y/6OFW4CIJ
	 k+8mqoNUK9SLvVED4f3FCJjywrT3JWcSBJrQqOAo/KEtauTrKL9q7yZlTZcHWOUtyu
	 yyH8ca3KKxiUSdauWrb85inYa3qKmECw+wKfd593Et8LH8pZpt8QawQbKsnXMHciSR
	 1g6c1BZ2JUxIC8kGTUDewXmjZQLICN1O8wIeCK/XBQ19uO35aDK7xj9YEtLCN2F1qh
	 2vvLmB2hOuFBw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 09/13] net: mana: keep per-queue statistics
 in the port context
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20260909222416.884246-10-longli@microsoft.com>
References: <20260909222416.884246-1-longli@microsoft.com>
 <20260909222416.884246-10-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 22:25:24 +0000
Message-Id: <20260910222524.8596D1F0089E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] u64_stats_update_begin called with preemption enabled causes poten=
tial deadlock.

Pre-existing issues:
- [High] Missing Mutual Exclusion on tx_stats updates between mana_xdp_xmit=
 and mana_start_xmit.
--

commit 45f5d2a315921074d282869dd20e8233e5bb463b
Author: Long Li <longli@microsoft.com>
Subject: net: mana: keep per-queue statistics in the port context

Move RX/TX counters into port-lifetime arrays so queue rebuilds do not
reset them. Sum all max_queues slots for ndo_get_stats64(), keep the
current queue count for ethtool, and fold retiring RX queues count into
private drain_stats upon destruction.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net=
/ethernet/microsoft/mana/mana_bpf.c
> index debf0e7765862..2060e08d82277 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
[ ... ]
> @@ -73,7 +73,7 @@ int mana_xdp_xmit(struct net_device *ndev, int n, struc=
t xdp_frame **frames,
>  		count++;
>  	}
> =20
> -	tx_stats =3D &apc->tx_qp[q_idx]->txq.stats;
> +	tx_stats =3D apc->tx_qp[q_idx]->txq.stats;
> =20
>  	u64_stats_update_begin(&tx_stats->syncp);
>  	tx_stats->xdp_xmit +=3D count;
>  	u64_stats_update_end(&tx_stats->syncp);

[Severity: High]
This is a pre-existing issue, but is there a missing mutual exclusion
between mana_xdp_xmit() and mana_start_xmit() when updating tx_stats->syncp?

mana_xdp_xmit() bypasses the qdisc HARD_TX_LOCK and maps q_idx using
smp_processor_id(). As a result, it can run concurrently with
mana_start_xmit() which uses the skb's queue mapping. Because the skb
queue mapping could map to the same queue from another CPU, both
functions might run simultaneously on different CPUs and call
u64_stats_update_begin() on the same syncp. This would corrupt the
sequence counter.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/=
ethernet/microsoft/mana/mana_en.c
> index 5752e3745ccc6..98007bb3ef7ca 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
[ ... ]
> @@ -575,7 +575,7 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, stru=
ct net_device *ndev)
>  	/* Populated the packet and bytes counters based on post GSO packet
>  	 * calculations
>  	 */
> -	tx_stats =3D &txq->stats;
> +	tx_stats =3D txq->stats;
>  	u64_stats_update_begin(&tx_stats->syncp);
>  	tx_stats->packets +=3D num_gso_seg;
>  	tx_stats->bytes +=3D len + ((num_gso_seg - 1) * gso_hs);

[Severity: High]
This is a pre-existing issue, but this is the primary packet transmission
path that can run concurrently with the XDP transmission path in
mana_xdp_xmit() mentioned above, contributing to the lost updates on the
shared tx_stats struct.

[ ... ]
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
Does mana_fold_rxq_stats() need to disable preemption or bottom halves
before acquiring the sequence lock here?

This function executes in process context holding the RTNL lock, but it
calls u64_stats_update_begin() with preemption enabled. On 32-bit systems,
if the thread is preempted or interrupted by a softirq on the same CPU that
subsequently reads the stats via mana_get_stats64(), the reader could spin
infinitely waiting for the sequence lock to become even.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909222416.8842=
46-1-longli@microsoft.com?part=3D9
