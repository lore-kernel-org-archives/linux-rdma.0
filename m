Received: from mail.tipi-net.de (mail.tipi-net.de [194.13.80.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746363AEF50;
	Fri,  9 Oct 2026 06:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.13.80.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791528558; cv=none; b=UMetTizweKxlRJ1kB7TtKuPBRXNF+wTT7c1tuSt8Q2AmF6bCbK0GXVg1cRE9Nv3pzAiUOkusRtMga8San48WYwVADw1sruNb300EXhEbGGgfAMAEZTSizWS/tcN3djl7F39DyfonuTYLSV1qcyn//+5yNR5uaDR2UgBdAeb3gjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791528558; c=relaxed/simple;
	bh=7w6WtgOAooBhMLzwKrrQuDQCvTsa7DPrL70+gYLvitY=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=ctUnP2Q+4oENu0TX/DuHh11qzozRC5b4mcF/NgY2Lp2m3/reXn6QRszxfCdhrV9BIX0kcEmqe6ncMDzHOcCTQmB5/oAX2xLFyI6KVrZ0j4teNNHBvFwQ9ZPRYw4TZPBT/C7B1yofDwyF+c1jkLTKnXq4lGz55PM5L62RAG+o9o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tipi-net.de; spf=pass smtp.mailfrom=tipi-net.de; dkim=pass (2048-bit key) header.d=tipi-net.de header.i=@tipi-net.de header.b=kZFuYIPz; arc=none smtp.client-ip=194.13.80.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tipi-net.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tipi-net.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tipi-net.de header.i=@tipi-net.de header.b="kZFuYIPz"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 125E7A1545;
	Fri,  9 Oct 2026 08:49:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tipi-net.de; s=dkim;
	t=1791528548; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=lcrb/n6yq9rUogTadFHg4X4Vn+bgruUv47sFAGOzlDo=;
	b=kZFuYIPzYEsMBF16NbUxECIKID0eVOFlNivAcf8B7RmcGRTJnFUDgWTEb+PS7FvFSjwj/1
	8+3+RMYjhVY4RsK8ZFeGRt88EUqXpQX1f5hENOyPHDC6aZFjaaaehf9TN5n6SYUyaG3x77
	KJSehPNwPCnZhU1gduLne/X3t2a7kO/6c+P3cGRlM1A+pqLGgoMo5hPQXAfSEqH1vhTLjT
	QNFwKsC70h3bUNtvjheIQUAhgbvbuYODR8QVA7qpq28ir4W9rRxRx7EJauo3ZzdfoGSfxg
	dNPId/Wbkx0rEzev4bTN5gFtwIvFv2Dj9hLpZOCSkBTeD2STbqzDgLd4JHwmgQ==
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 09 Oct 2026 08:49:02 +0200
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
Subject: Re: [PATCH net-next 1/3] net: selftests: use skb_share_check() in the
 loopback receive hook
In-Reply-To: <179149509090.434549.9918598206439291164@kernel.org>
References: <20261007-nb-net-selftest-shared-net-v1-1-458369bfa1ba@tipi-net.de>
 <179149509090.434549.9918598206439291164@kernel.org>
Message-ID: <533b88ce917b59f4f59f52145d2f035f@tipi-net.de>
X-Sender: nb@tipi-net.de
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3

Hi Clashiko

On 8.10.2026 23:31, netdev-bot+sashiko@kernel.org wrote:

> [...]

> [Severity: High]
> This change looks correct for net_test_loopback_validate(). The same
> pattern still seems to be present in stmmac_test_vlan_validate() in
> drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c, though.
> 
> A later commit in this series, "net: stmmac: selftests: use
> skb_share_check() in the loopback receive hook", converts
> stmmac_test_loopback_validate(). The second copy of this handler in the
> same file is left as:
> 
> stmmac_test_vlan_validate() {
>     ...
> 	skb = skb_unshare(skb, GFP_ATOMIC);
> 	if (!skb)
> 		goto out;
> 
> 	if (skb_linearize(skb))
> 		goto out;
>     ...
> }
> 
> __stmmac_test_vlanfilt() and the other VLAN tests register this handler 
> as
> a device-bound packet_type. The type is ETH_P_IP, ETH_P_8021Q, or 
> either
> one depending on svlan:
> 
> 	tpriv->pt.type = htons(ETH_P_IP);
> 	tpriv->pt.func = stmmac_test_vlan_validate;
> 	tpriv->pt.dev = priv->dev;
> 
> Suppose another handler for the same type sits later in the device's
> ptype list, for example an AF_PACKET socket bound to ETH_P_IP on that
> interface. deliver_skb() then increments skb->users, so the hook gets 
> an
> skb that is shared but not cloned. skb_unshare() only checks
> skb_cloned(), so it returns that skb unchanged.
> 
> For a non-linear frame with less tailroom than data_len, this path
> follows:
> 
> skb_linearize()
>   __pskb_pull_tail()
>     pskb_expand_head()
>       BUG_ON(skb_shared(skb));
> 
> Should stmmac_test_vlan_validate() get the same skb_share_check()
> conversion, so the series covers every copy of this hook?

No, AFAIU the VLAN tests can't get a shared skb here. They set
capture_all, so stmmac_sft_add_pack() registers stmmac_sft_filter()
instead, which passes stmmac_test_vlan_validate() its own clone.

> 
> The xgbe sibling, xgbe_test_loopback_validate(), does not seem to be
> affected. It already calls skb_share_check() before it expands a shared
> skb.
> 
> [Severity: Low]
> This is a pre-existing issue that this patch did not introduce. The
> length check further down in net_test_loopback_validate() looks too
> short for what the function parses afterwards:
> 
> 	if (skb_headlen(skb) < (NET_TEST_PKT_SIZE - ETH_HLEN))
> 		goto out;
> 
> NET_TEST_PKT_SIZE in include/net/selftests.h covers only ethhdr, iphdr
> and netsfhdr. That guarantees 33 bytes past the network header and does
> not include the TCP/UDP header.
> 
> The function then reads:
> 
> 	thdr = (struct tcphdr *)((u8 *)ihdr + 4 * ihdr->ihl);
> 	...
> 	if (shdr->magic != cpu_to_be64(NET_TEST_PKT_MAGIC))
> 
> It never checks ihl >= 5, the IP version, tot_len or the L4 header
> length, and double_vlan adds another 4 bytes.
> 
> Could an IPv4 frame that arrives during ethtool -t make the hook read 
> up
> to about 64 bytes past skb->tail? Examples would be a minimum-size TCP
> segment or a frame with ihl=15.
> 
> The over-read seems to stay inside the skb head allocation, because
> skb_shared_info follows skb->end. If so, the only effect is a possibly
> wrong selftest result.

The length check is pre-existing, will address that in a follow-up 
patch.
