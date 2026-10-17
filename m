Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18B9391E50;
	Sat, 17 Oct 2026 15:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792251569; cv=none; b=oYMk2frN8n7HtMCN4Pp5Kxi5qJoPeBbBFcFmY4srVX/pchXkM0yiG2R5cuyVYxajwrO2loxs8MS4jeGVbygpw1joTHaPok2RsE2xDfHd9EbaNA2NiieR098b1omiHXu6mjELrEbY/V7Sk1u2jbDcf4vewLwMgcqa5qzPo2o42v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792251569; c=relaxed/simple;
	bh=K75VGTg+wMZ9smxNF4K1EKCFh2PD/vGyN/tsLlEiWLs=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=o/blwV4dlijXvDI4CBz7A2Glw9STZm+z3SqK6f9ktJ/x30ZCan/avDMQIsfLnKJGkZWMFme1eLQT587SGF8pBPEmG4IN7DXfOrW4oxzamMjHJw2EhwP906gVVkbTJwsdUY9zcl9liAiz1THhezBptNNV9VhztLMy0DsYz5jiI/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XLjB6hnB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XLjB6hnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4AA1F000C4;
	Sat, 17 Oct 2026 15:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792251568;
	bh=zAOpyM8ar87SySk7Bi+OPuDbjdEon619d1UFNMC63ws=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XLjB6hnBs+7E7t0pFnGJxvkdsi/+1k42F4tXDUQTuA/6m3yW+7PWbdMUcgNwpnKBB
	 LFwTiS4cxGq79BMkkWYp4uYbt1JXnUEldZSMYnaNzuR6XO/Fo0DDdaCTyrx8hNUDJv
	 4NOdIHS5oI4SV2OQOsZzTBybR9gkkl86P1RbppMzx3kpKdsSdtj51kmKP1d+5WHoDe
	 LTuqh1I6brwzhEjNELrj2ppyeZiZ3jRfwZ3ph+60v8IXT5sLuOOLczX6xjSanCWILa
	 RFnOA+vkwR0enWicABGlXHimOKe1JKoNUiEZN3mZPFPFqjTB3htehrT0ta96Y1+hgE
	 VtQsgYcJTo6gg==
Message-ID: <sashiko-outbox-175607@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 07/13] net: mana: swap queue sets in
 mana_change_mtu
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <87e016ed7479a33be87128b01bb07d2e1807c87d.1791710735.git.weh@linux.microsoft.com>
References: <cover.1791710735.git.weh@linux.microsoft.com>
 <87e016ed7479a33be87128b01bb07d2e1807c87d.1791710735.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 15:39:27 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mana: data race on TX stats syncp in mana_xdp_xmit
--

commit 03c88ebc19bffbae5acfce1a1948eb4cb597ee75
Author: Long Li <longli@microsoft.com>

net: mana: swap queue sets in mana_change_mtu

Carry the MTU in the queue set and size replacement RX buffers from it.
Publish ndev->mtu after RSS configuration succeeds; allocation failure
leaves the live queues and advertised MTU unchanged.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net=
/ethernet/microsoft/mana/mana_bpf.c
> index 484f061bc75e4..687b9ce7d9a3b 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
> @@ -68,7 +73,7 @@ int mana_xdp_xmit(struct net_device *ndev, int n, struc=
t xdp_frame **frames,
>  		count++;
>  	}
> =20
> -	tx_stats =3D &apc->tx_qp[q_idx]->txq.stats;
> +	tx_stats =3D apc->tx_qp[q_idx]->txq.stats;
> =20
>  	u64_stats_update_begin(&tx_stats->syncp);
>  	tx_stats->xdp_xmit +=3D count;

[Severity: Medium]
Does this stats update in mana_xdp_xmit() lack mutual exclusion when racing
with other CPUs?

When multiple CPUs redirect traffic via ndo_xdp_xmit, they can map to the
same q_idx (since q_idx =3D smp_processor_id() % real_num_tx_queues) and
execute u64_stats_update_begin() concurrently.

This could also race with mana_start_xmit(), which updates the same
per-queue syncp:

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/=
ethernet/microsoft/mana/mana_en.c
> index 489558176a5de..c1ff4d9b8d45f 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -551,7 +579,7 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, stru=
ct net_device *ndev)
>  	/* Populated the packet and bytes counters based on post GSO packet
>  	 * calculations
>  	 */
> -	tx_stats =3D &txq->stats;
> +	tx_stats =3D txq->stats;
>  	u64_stats_update_begin(&tx_stats->syncp);
>  	tx_stats->packets +=3D num_gso_seg;

While mana_start_xmit() holds __netif_tx_lock, that lock does not protect
against lockless mana_xdp_xmit() calls.

On architectures where u64_stats_update_begin() uses seqcounts, could this
concurrent modification corrupt the seqcount and cause readers (like
mana_get_stats64()) to infinite loop or read torn values?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791710735.gi=
t.weh@linux.microsoft.com?part=3D7
