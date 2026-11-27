Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795818735;
	b=VKAUi//1f4v0F56vxcs0J5Kh7DC6a01t/4fnWg8W1ryV9RISsc1I4/yA2fzdeFtlU0wo
	 chDEASqJGDEViyCD9yp7Y8fTi/c4Wx7td5GXD+drYkL6rkpU6p0stuhKVKB/xhPSirSIP
	 IFJU2EIieeCO8ERhmUYpayR7YkCKvO9LtwWarhtj02daL18oJ1nmOhkSqTx0bHMIczOo4
	 AHuxl/j5ptP66YuQkyPWtbexZggDeAavWIDfdo80QgGoj2E/65rcUaXfM0K/BSeqXHJ2x
	 8fETXL3LkQzHeKjpzcKG8xQLTsB9cvrFbWZfHw7HpDr9Du4AZRlyp6JDMkwY4X3Yr5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795818735;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=u72xTXVvYB/9IUxRBnyZjZslgn01rWlXQAM57XGcgvo=;
	b=yXJsOApQHiRuUgB1KncNU5QaeZznfNJ5APKN9GJyS2EcLhlVLjMFTKX+LYafcDD4hsGH
	 nok/a0EdZQjFypBkCoUt83AqJG5TA4V3BH5T3vfYHeOHOinyL3ZAaWXI4+GNOTW4C6kCY
	 /veNfwln19J6hDq3vePX2NBQbL9AcGcHafwz7sXMc8M2nJWEKDiAEVobft3huXsZOd+i2
	 f+XLS6vb5xVEMmq3zVOU23vMqtWzG3r/GFViAdnH576uo2awkDrUEiMiRflzzZrMk6t7k
	 zmlDrf/KgMS/txtJWRG99M+bkUPPyTdVpP6E0mLzKCj4dDIY3f0oug+Zh4irZba/XHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bA64pSbp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7024606A321;
	Fri, 27 Nov 2026 22:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bA64pSbp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4261F0092A;
	Fri, 27 Nov 2026 22:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795818735;
	bh=u72xTXVvYB/9IUxRBnyZjZslgn01rWlXQAM57XGcgvo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=bA64pSbpLy4zZGX5vKWzhtx52dF9QJ9db3RM5wAA15Xpx303abDCRI46yt7ley9xm
	 cgNSBWFhM8QF0Zp2/WsbkfuHwJDt6dKgzhzfKrfSL6RqB113aWbABgucgSfFj2mnQw
	 NLwyDOVRYe9oCColPyl/rlEyzfmgNjObMwzP8cZa65rFOW0BWxykkd3DJZZu4CFYtS
	 K1yfxQImpneKpLRsAzlJv7Mlz+KgRNpIkgdbwXRxORCY6MNhxkpGkjA9lIKAMgIL+v
	 +K2zyW1arQX1U+LxWVPWk7pBlae/UZrxXST45HPDbf7+nGUxybNTdnZ0GFMIQnYqfE
	 MXynmv95WMrVQ==
Subject: Re: [PATCH net 05/10] net/mlx5e: Drop IPsec tunnel traffic if the
 neigh cannot be created
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 willemb@google.com, parri.andrea@gmail.com, borisp@nvidia.com,
 cratiu@nvidia.com, eedmunds@nvidia.com, gal@nvidia.com, jmassar@nvidia.com,
 jianbol@nvidia.com, kuniyu@google.com, leon@kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, phaddad@nvidia.com,
 raeds@nvidia.com, saeedm@nvidia.com, horms@kernel.org,
 sridhar.samudrala@intel.com, steffen.klassert@secunet.com
Date: Fri, 27 Nov 2026 22:32:13 +0000
Message-ID: <179581873325.3135.13078869091632134545@kernel.org>
In-Reply-To: <20261126215614.792598-6-tariqt@nvidia.com>
References: <20261126215614.792598-6-tariqt@nvidia.com>
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 3 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The patch only covers the case where neighbour creation fails.
- [Medium] Setting attrs->drop = true when the neighbour cannot be
  created permanently stops the SA's software lifetime worker.
- [Medium] The new 'attrs->drop = true' on neighbour-creation failure in
  mlx5e_ipsec_init_macs() (ipsec.c:371) is not limited to the TX…

--

net/mlx5e: Drop IPsec tunnel traffic if the neigh cannot be created

This patch moves the attrs->drop assignment in mlx5e_ipsec_init_macs() so
it happens before the IS_ERR() check on the result of ipv4_neigh_create().
When the peer neighbour cannot be created, the tunnel packet offload SA
is now installed as a drop rule. Before, it forwarded traffic with an
all-zero destination MAC.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> index ea7a1ae2056fa..4daad648460fe 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> @@ -368,10 +368,10 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
>  	n = ipv4_neigh_lookup(netdev, pkey);
>  	if (!n) {
>  		n = ipv4_neigh_create(netdev, pkey);
> +		attrs->drop = true;
>  		if (IS_ERR(n))
>  			return;

[Severity: Medium]
Should this drop be limited to XFRM_DEV_OFFLOAD_OUT?

For an inbound SA, mlx5e_ipsec_init_macs() sets src = attrs->dmac (the
netdev's own MAC) and dst = attrs->smac (the peer MAC). The unresolved
peer MAC only becomes the source MAC of the L2 header that
setup_pkt_reformat() adds to the decrypted inner frame:

drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c:setup_pkt_reformat() {
    ...
	ether_addr_copy(eth_hdr->h_dest, attrs->dmac);
	ether_addr_copy(eth_hdr->h_source, attrs->smac);
    ...
}

Before this patch, an RX SA in this state still delivered decrypted
traffic to the host, with h_source set to 00:00:00:00:00:00. With drop
set, rx_add_rule() now installs CRYPTO_DECRYPT|DROP:

drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c:rx_add_rule() {
    ...
	if (attrs->drop) {
		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
		rule = mlx5_add_flow_rules(rx->ft.sa, spec, &flow_act, NULL, 0);
    ...
}

n is an ERR_PTR here, so neigh_event_send() is never called and no
resolution starts.

Could inbound traffic for this SA stay blackholed until some unrelated
event creates and validates the neighbour? That can't happen while the
table is still full.

The commit message only describes the TX case ("add the TX SA ...").

[Severity: Medium]
Does setting drop here permanently stop the software lifetime worker for
this SA?

mlx5e_xfrm_add_state() queues sa_entry->dwork once, MLX5_IPSEC_RESCHED
after install. mlx5e_ipsec_handle_sw_limits() returns early when drop is
set and only re-queues itself at the end:

mlx5e_ipsec_handle_sw_limits() {
	...
	if (sa_entry->attrs.drop)
		return;
	...
	xfrm_state_check_expire(x);
	spin_unlock_bh(&x->lock);

	queue_delayed_work(sa_entry->ipsec->wq, &dwork->dwork,
			   MLX5_IPSEC_RESCHED);
}

This IS_ERR() branch sends no probe. Drop is therefore almost certainly
still set when the worker first runs, and the worker is never queued
again.

If the neighbour resolves later, mlx5e_ipsec_handle_netdev_event()
clears the flag and reprograms the rules to forward:

	attrs->drop = false;
	mlx5e_accel_ipsec_fs_modify(sa_entry);

It does not re-arm the dwork. Would the SA then forward traffic without
any xfrm_state_check_expire() calls, so the soft and hard byte limits
are never enforced?

Before this patch, the IS_ERR() branch left drop false and the worker
kept running. The root cause seems to be that attrs->drop means both
"expired" and "neighbour unresolved".

A later commit in the series, "net/mlx5e: Copy back only replay_esn
after an IPsec ESN update", fixes the ESN rebuild variant of this
problem. At the end of the series, the early return in
mlx5e_ipsec_handle_sw_limits() and the missing re-arm in
mlx5e_ipsec_handle_netdev_event() are both still there.

>  		neigh_event_send(n, NULL);
> -		attrs->drop = true;
>  	} else {
>  		neigh_ha_snapshot(addr, n, netdev);
>  		ether_addr_copy(dst, addr);

[Severity: Medium]
The commit message says this makes creation failure behave "as for a
created but still unresolved neigh". Does that hold outside the create
branch of the fallback path?

In this else branch, ipv4_neigh_lookup() can return an existing
neighbour that is INCOMPLETE or FAILED. Its zero ha is copied into dmac,
drop stays false, and no probe is sent.

The route path earlier in mlx5e_ipsec_init_macs() shows the same
symptom. dst_neigh_lookup() goes through
ipv4_dst_neigh_lookup()->ip_neigh_gw4(), which calls __neigh_create()
on a miss. It returns a new unresolved neighbour instead of NULL, so the
fallback is never reached:

	n = dst_neigh_lookup(rt_dst_entry, pkey);
	...
	neigh_ha_snapshot(addr, n, netdev);
	ether_addr_copy(dst, addr);
	if (attrs->dir == XFRM_DEV_OFFLOAD_OUT &&
	    is_zero_ether_addr(addr))
		neigh_event_send(n, NULL);

attrs->drop is never set on that path, and tx_add_rule() chooses the
action from attrs->drop alone:

drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c:tx_add_rule() {
    ...
	if (attrs->drop)
		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
	else
		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
    ...
}

Suppose a route to the peer exists but the next hop is not resolved yet,
for example the first SA toward a new peer. Won't the TX SA still be
installed with dmac 00:00:00:00:00:00 and forwarding enabled? That is
the symptom this commit describes.

Commit 9ab89bde13e5 describes this route path case ("the hardware rule
is programmed with an all-zero destination MAC address") but only adds a
probe, not a drop. The route path still has no drop at the end of the
series.

A later commit in the series, "net/mlx5e: Validate neighbour events
before updating IPsec SAs", fixes the related problem that gateway
neighbour updates were never matched.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261126215614.792598-1-tariqt%40nvidia.com
