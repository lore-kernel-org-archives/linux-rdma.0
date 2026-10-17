Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC831891A9;
	Sat, 17 Oct 2026 15:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792251566; cv=none; b=m39kTLXfUHz0/iKj2oqxusc1NODXicuiRoP3BSYUHCQ9hcPQDFYLFV3rRsfkELEUM6XHV6HQ2ingl3PEhMXO7dBMHQ2CrskIwfgDXtEV1rTja8+T6tiKSxhfgQnPqpUNMnD7pWv4RHRxAm8BUBq/Vrn7qLC0FLXBCunnpO1pIGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792251566; c=relaxed/simple;
	bh=/aXwcNPlzWVqM2gu34fKcxS8GkqIThmYtnI2IbyUIXs=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=BTMONSShwaEwUfFc9xU0yw1dVIqyhWexIA9mvUNlfH6rDB9XZ9amcgXDn6ztDzhwfg1jVb0tvrWfIWWFPCBxMwRjc9CVGP2k3t229PvpicUDBcgRqIlG5ZJ+fQ6sJQP+dQsvLFDinK7CelmLQTEJ06lIRfhRihmq6aKx6alr/KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fqCr92dw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fqCr92dw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7A51F000C4;
	Sat, 17 Oct 2026 15:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792251565;
	bh=i8zGrPxhNtTzVIvygXJY+DqG5D/cDXM25pCqeHXIqk8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fqCr92dw0xMtei6/GWoM4eEukgkLEgc6W+HM3hv+NCiXQBaeo3HefJ7bnrSWMwzT1
	 F5MK1HipuuWVEawecTbXazFifb5PWYCUAfowR4D4UwHsDHOkw1qGF6PcGjaL+mkVT3
	 2JmK+K9HJj6YQb0JoEGlktruFD8NVW+QUsB5DWIpAiS2MswyrvIAeDaPozKpj2cU+p
	 Oj6jzgYbJ1OhOrJbAqeCGkzNnLsWxKECSU0xYTSzjCIO3deKSRVFYqNxhw1D66P+jG
	 bI5Ozb1028BFfi2rGzRDb2eJiUiHx6ZENM8hBl1+B4N4Dyhm22/2SGmMuPtmiYUh0E
	 9vDjyO20RZYcA==
Message-ID: <sashiko-outbox-175603@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 03/13] net: mana: keep per-queue statistics
 in the port context
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <b27034466c0db8228409db5473e747db7c3177c5.1791710735.git.weh@linux.microsoft.com>
References: <cover.1791710735.git.weh@linux.microsoft.com>
 <b27034466c0db8228409db5473e747db7c3177c5.1791710735.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 15:39:24 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] networking-core: RCU Use-After-Free of queue stats arrays in mana_=
remove
--

commit 18790cf70c36793724e3d46fb56949164d33f7af
Author: Long Li <longli@microsoft.com>

net: mana: keep per-queue statistics in the port context

Prepare port-lifetime RX/TX statistics before introducing live queue
replacement. Allocate max_queues slots before netdev registration,
unwind probe failures, and release them only after unregistering the
netdev.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/=
ethernet/microsoft/mana/mana_en.c
> index 4b2c8039b8fa3..744d5ebe8dbbb 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
[ ... ]
> @@ -597,15 +597,15 @@ static void mana_get_stats64(struct net_device *nde=
v,
>  			     struct rtnl_link_stats64 *st)
>  {
>  	struct mana_port_context *apc =3D netdev_priv(ndev);
> -	unsigned int num_queues =3D apc->num_queues;
>  	struct mana_stats_rx *rx_stats;
>  	struct mana_stats_tx *tx_stats;
> +	unsigned int num_queues;
>  	unsigned int start;
>  	u64 packets, bytes;
>  	int q;
> =20
> -	if (!apc->port_is_up)
> -		return;
> +	/* Report even while down; dev_get_stats() zeroes its output. */
> +	num_queues =3D apc->max_queues;
> =20
>  	netdev_stats_to_stats64(st, &ndev->stats);
> =20
> @@ -615,7 +615,18 @@ static void mana_get_stats64(struct net_device *ndev,
>  	st->rx_missed_errors =3D apc->ac->hc_stats.hc_rx_discards_no_wqe;
> =20
>  	for (q =3D 0; q < num_queues; q++) {
> -		rx_stats =3D &apc->rxqs[q]->stats;
> +		rx_stats =3D &apc->rxq_stats[q];
> +
> +		do {
> +			start =3D u64_stats_fetch_begin(&rx_stats->syncp);
[ ... ]
> @@ -4525,6 +4591,7 @@ void mana_remove(struct gdma_dev *gd, bool suspendi=
ng)
> =20
>  		unregister_netdevice(ndev);
>  		mana_cleanup_indir_table(apc);
> +		mana_free_queue_stats(apc);

[Severity: High]
Is it possible for concurrent RCU readers to trigger a use-after-free of
the queue stats arrays here?

In mana_remove(), unregister_netdevice() unlists the device but does not
synchronously wait for existing RCU grace periods to finish. The necessary
synchronize_net() happens later in netdev_run_todo() after the lock is
released.

Because this patch removed the !apc->port_is_up safety check from
mana_get_stats64(), concurrent RCU readers that have already acquired the
ndev pointer can still call dev_get_stats() and unconditionally iterate and
dereference the apc->rxq_stats and apc->txq_stats array pointers.

If the arrays are freed by mana_free_queue_stats() while the reader is
inside mana_get_stats64(), it would result in memory corruption or crashes.
Does the mana_free_queue_stats() teardown need to be deferred until after t=
he
RCU grace period, such as in the ndo_uninit or destructor callback?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791710735.gi=
t.weh@linux.microsoft.com?part=3D3
