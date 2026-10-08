Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FFA35C692;
	Thu,  8 Oct 2026 21:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791495094; cv=none; b=RQ2+d8HZInj256RBTQ5FdwhFj0Uo9AtXZhevaCombwbGfWs94is1WId28U9cIZjrcC0jo7iigV3JRxaW45gFnc4L3swGKHXerVawGgsAHHDNDCRSmxCy3WtfO3CyoX+Y/WNENg8vKlwVnyAPRx9a15IDv2YrzvDi2IIXEJxz83M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791495094; c=relaxed/simple;
	bh=QW3Fxw9Ri3EirGkkoFgQyV2IxlNY4MFImPRWlsQplsI=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=X2j5iDvMvgqPZRe8+vomv8+vYu+ZyWkhSfeVeML71W40TTKDeIG7FPGTpGvamR6w/xXuGoptD3a4bS0zmRSRPQhsutmhShmIjrBgcBM0hjqi7nwLibYX5lETTILBjFmjk8peiIw7xNBQfyBpUy6QkH/P2GF3KzB/0ZLT0h8I8Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BCp/0fQO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BCp/0fQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FA01F000FF;
	Thu,  8 Oct 2026 21:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791495092;
	bh=elwTlGsGIEAUxLqe0dTIpTBpzp3+HyabLtiZ0xgNSAg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=BCp/0fQOtFuIOcrAJXCoouPA6rc3xayTuyzfq1YBFqHD317EGLlW/ARoHuzMcs42n
	 EQY3WQ0u4xWZ3C6UD5aqFkCJ0HaGwV44/C/oklkOtDNcjU9yh4/BTDJBM9BEaCvZeg
	 ngJsqFljQleUPOJy0FMftIZ+3SIh9OknPIQ/gaLWLzvlS2JCTV4tNcCAR8Q752Afk7
	 J2SNCXnPKVG/8FdEoFG1dOX/v0j1v4aixws9hhrIWpX/GHI751744jsCm/TR/X2P0p
	 MLI3TVnuBTpHvqG6xBja+B+fbd0PaTYZ0zfQZeaIYTfY3vWc4LZ4KIvP7rmW8KW/iV
	 BpGuFx8MlU1iQ==
Subject: Re: [PATCH net-next 1/3] net: selftests: use skb_share_check() in the
 loopback receive hook
From: netdev-bot+sashiko@kernel.org
To: nb@tipi-net.de
Cc: davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, o.rempel@pengutronix.de,
 maxime.chevallier@bootlin.com, andrew+netdev@lunn.ch,
 mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
 Jose.Abreu@synopsys.com, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, leon@kernel.org, dtatulea@nvidia.com, alazar@nvidia.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-rdma@vger.kernel.org
Date: Thu, 08 Oct 2026 21:31:30 +0000
Message-ID: <179149509090.434549.9918598206439291164@kernel.org>
In-Reply-To:
 <20261007-nb-net-selftest-shared-net-v1-1-458369bfa1ba@tipi-net.de>
References:
 <20261007-nb-net-selftest-shared-net-v1-1-458369bfa1ba@tipi-net.de>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 0 (1)

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The series fixes only part of this bug class.

Pre-existing issues:
- [Low] Pre-existing weak length validation in
  net_test_loopback_validate() (net/core/selftests.c).

--

net: selftests: use skb_share_check() in the loopback receive hook

This patch replaces skb_unshare() with skb_share_check() in
net_test_loopback_validate(). With the change, a shared but non-cloned skb
is cloned before skb_linearize() runs. Without it, a non-linear frame that
reaches the hook while another ETH_P_IP handler is bound to the device can
hit BUG_ON(skb_shared()).

> diff --git a/net/core/selftests.c b/net/core/selftests.c
> index 36b949ae520b3..80029a67b2d2b 100644
> --- a/net/core/selftests.c
> +++ b/net/core/selftests.c
> @@ -170,7 +170,7 @@ static int net_test_loopback_validate(struct sk_buff *skb,
>  	struct tcphdr *thdr;
>  	struct iphdr *ihdr;
>  
> -	skb = skb_unshare(skb, GFP_ATOMIC);
> +	skb = skb_share_check(skb, GFP_ATOMIC);
>  	if (!skb)
>  		goto out;
>  

[Severity: High]
This change looks correct for net_test_loopback_validate(). The same
pattern still seems to be present in stmmac_test_vlan_validate() in
drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c, though.

A later commit in this series, "net: stmmac: selftests: use
skb_share_check() in the loopback receive hook", converts
stmmac_test_loopback_validate(). The second copy of this handler in the
same file is left as:

stmmac_test_vlan_validate() {
    ...
	skb = skb_unshare(skb, GFP_ATOMIC);
	if (!skb)
		goto out;

	if (skb_linearize(skb))
		goto out;
    ...
}

__stmmac_test_vlanfilt() and the other VLAN tests register this handler as
a device-bound packet_type. The type is ETH_P_IP, ETH_P_8021Q, or either
one depending on svlan:

	tpriv->pt.type = htons(ETH_P_IP);
	tpriv->pt.func = stmmac_test_vlan_validate;
	tpriv->pt.dev = priv->dev;

Suppose another handler for the same type sits later in the device's
ptype list, for example an AF_PACKET socket bound to ETH_P_IP on that
interface. deliver_skb() then increments skb->users, so the hook gets an
skb that is shared but not cloned. skb_unshare() only checks
skb_cloned(), so it returns that skb unchanged.

For a non-linear frame with less tailroom than data_len, this path
follows:

skb_linearize()
  __pskb_pull_tail()
    pskb_expand_head()
      BUG_ON(skb_shared(skb));

Should stmmac_test_vlan_validate() get the same skb_share_check()
conversion, so the series covers every copy of this hook?

The xgbe sibling, xgbe_test_loopback_validate(), does not seem to be
affected. It already calls skb_share_check() before it expands a shared
skb.

[Severity: Low]
This is a pre-existing issue that this patch did not introduce. The
length check further down in net_test_loopback_validate() looks too
short for what the function parses afterwards:

	if (skb_headlen(skb) < (NET_TEST_PKT_SIZE - ETH_HLEN))
		goto out;

NET_TEST_PKT_SIZE in include/net/selftests.h covers only ethhdr, iphdr
and netsfhdr. That guarantees 33 bytes past the network header and does
not include the TCP/UDP header.

The function then reads:

	thdr = (struct tcphdr *)((u8 *)ihdr + 4 * ihdr->ihl);
	...
	if (shdr->magic != cpu_to_be64(NET_TEST_PKT_MAGIC))

It never checks ihl >= 5, the IP version, tot_len or the L4 header
length, and double_vlan adds another 4 bytes.

Could an IPv4 frame that arrives during ethtool -t make the hook read up
to about 64 bytes past skb->tail? Examples would be a minimum-size TCP
segment or a frame with ihl=15.

The over-read seems to stay inside the skb head allocation, because
skb_shared_info follows skb->end. If so, the only effect is a possibly
wrong selftest result.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261007-nb-net-selftest-shared-net-v1-0-458369bfa1ba%40tipi-net.de
