Received: from mail.tipi-net.de (mail.tipi-net.de [194.13.80.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED44B3BE179;
	Fri,  9 Oct 2026 08:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.13.80.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791535055; cv=none; b=WgVrNxD+Ti2Knb28v6qBFzbi2JYgm/IDE8Ky4tQaK5Jwy4OJQxNuDLQCNgc140WapQoGkEbifNVWgaSsqKWJIuoIYQemAFxmKPjgQWsFmKJaq+TjsGIqy/GNIyG/QUCAYK17RBRiME6wlo6pRnsc6RKgwBWFtXzhGnwKTJFLfQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791535055; c=relaxed/simple;
	bh=6kBGKdI4xRgmH+upwAe8YgkIdImCBWYu4BA78K8w4Bk=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=PgVBh69H34bTMQskXwtYVWd0zoOhGdbKAHk3G8/lMpE5whF7uuzue2RT2G0hdknlIIWEWkL/0X4A7E3LdnSiV1/nPIie+3AzIMwEAtYLAXtqQbWSNi7OGKq1WB4ncWe+FLcXEsvYnq89Q7D71SvykEKe2+Vv603/yU29waIkjNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tipi-net.de; spf=pass smtp.mailfrom=tipi-net.de; dkim=pass (2048-bit key) header.d=tipi-net.de header.i=@tipi-net.de header.b=x9O41Ioi; arc=none smtp.client-ip=194.13.80.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tipi-net.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tipi-net.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tipi-net.de header.i=@tipi-net.de header.b="x9O41Ioi"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 7B591A1561;
	Fri,  9 Oct 2026 10:37:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tipi-net.de; s=dkim;
	t=1791535049; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=1jl9tQJWjV8nksZpR7yDPWHvqkEBuwYygti9sXjrMe4=;
	b=x9O41IoiaA1sMC21CzEWXcQnk55P4GigN1uHSPsC+Xtwt2d2EL0M+tos8ltfSemhW41AK8
	kD003tpHzLnlGAegyXUbN/wPwAvt5fhftLLFE1jpRbTjZ603yJsSal9NWqgvUuMItqT+Or
	/PXjWcCZmvj46iJ7m6LuI7uTgvFIiRrtHN2OIasf3FdXGqof8nYskGFaSVHJeRch8pUA2X
	csndNPDuhOhHJdEQCT5AmFngKcWovukqFeQbTXLnGqMcH5pNpjrQWs5vvUANXIVUxt5BUT
	30y71+BxBLLKuTrz85C71kghZPYenrZsTHCT0czszyn7iHFlU8KUC+L6PXmquQ==
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 09 Oct 2026 10:37:26 +0200
From: Nicolai Buchwitz <nb@tipi-net.de>
To: netdev-bot+sashiko@kernel.org
Cc: davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, o.rempel@pengutronix.de,
 maxime.chevallier@bootlin.com, andrew+netdev@lunn.ch,
 mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
 Jose.Abreu@synopsys.com, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, leon@kernel.org, dtatulea@nvidia.com, alazar@nvidia.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net/mlx5e: use skb_share_check() in the
 loopback selftest hook
In-Reply-To: <179149509264.434549.15492783775949444420@kernel.org>
References: <20261007-nb-net-selftest-shared-net-v1-3-458369bfa1ba@tipi-net.de>
 <179149509264.434549.15492783775949444420@kernel.org>
Message-ID: <b90df783d996dbad672656dc81c8f5de@tipi-net.de>
X-Sender: nb@tipi-net.de
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3

On 8.10.2026 23:31, netdev-bot+sashiko@kernel.org wrote:

> [...]

> [Severity: Low]
> This isn't a bug, but the comment just below this hunk in
> mlx5e_test_loopback_validate() now contradicts the new code:
> 
> 	if (skb_linearize(skb))
> 		goto out;
> 
> 	/* We are only going to peek, no need to clone the SKB */
> 	if (MLX5E_TEST_PKT_SIZE - ETH_HLEN > skb_headlen(skb))
> 		goto out;
> 
> skb_share_check() calls skb_clone() whenever the skb is shared. After
> that, skb_linearize() can modify or reallocate the skb head.
> 
> Should this comment be dropped or reworded? A later reader could take
> "no need to clone" at face value and remove the skb_share_check().
> stmmac_test_loopback_validate() uses the same skb_share_check() +
> skb_linearize() sequence and has no such comment.

Yes, it is stale. I'll drop it if a v2 is needed.

> [...]

> [Severity: Low]
> This is a pre-existing issue and was not introduced by this patch.
> Further down in mlx5e_test_loopback_validate(), the UDP header is
> located using iph->ihl, which comes from the packet and is never
> checked:
> 
> 	/* Don't assume skb_transport_header() was set */
> 	udph = (struct udphdr *)((u8 *)iph + 4 * iph->ihl);
> 	if (udph->dest != htons(9))
> 		goto out;
> 
> 	mlxh = (struct mlx5ehdr *)((char *)udph + sizeof(*udph));
> 	if (mlxh->magic != cpu_to_be64(MLX5E_TEST_MAGIC))
> 
> The only length check is this one:
> 
> 	if (MLX5E_TEST_PKT_SIZE - ETH_HLEN > skb_headlen(skb))
> 		goto out;
> 
> That guarantees 44 bytes: 20 for IP, 8 for UDP, and 16 for struct
> mlx5ehdr, which includes the padding before magic.
> 
> The hook is registered with dev_add_pack() for every ETH_P_IP frame on
> priv->netdev. While the loopback test is running, could an external UDP
> frame sent to the port MAC with ihl up to 15 make this code read
> udph->dest and mlxh->magic up to 40 bytes past skb_headlen()?
> 
> Those bytes stay inside the skb head allocation, in the tailroom or
> skb_shared_info, and they are only compared against constants. The
> result could be a spurious selftest outcome or a KMSAN uninit-value
> report. Would it make sense to check 4 * iph->ihl against skb_headlen()
> before using it?

Yes, pre-existing. I can send a separate patch for this.
