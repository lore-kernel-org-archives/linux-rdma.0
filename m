Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794187375;
	b=BraBxLLaY3l+/5HE9JhZPyI/Ed5KW8LRrxWByM++ss0X78PE7MqNFACaPZ8pFstkCBZW
	 B1OauzV9xMJ49Z/QAMNmMniiNSugsDctLFjj9SNrhkKR1pScRQt4HU+FDznhFWDTYTBKh
	 G95XLNL6PW1CRc5K2ejTpSFWxx9q2CwjIXQxYpjHI4lmuu0vBXBrDB95ZcrTPqWZN8t2s
	 BnviR8A1T4yqcv/gtRst9xpuUnCmG2AtEHt97bDFZUaFy55Morhdi2voZ3GEZvj41Mx6y
	 Ml0kS4s6AVnnJqz80UWiTGrXk6AgS3X1t17PPRZmASTf93eubbt+fjTTqLeP8PpOd2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794187375;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=uu4b4q9g+ZAPloji05p+CCMtBgpxRHYFQ7AS0/TwBHc=;
	b=bpzXhPP/V6qas6ZYsSF+cECshihInCxV6ro3LzxCVAfLrk8GCNfLW/j7Ew0FrDZHNtpp
	 7QmCeCw/pqPBHq7MPFZbkKpk4Ss4/KahxOvRi/xMprtCat65jz+O2kfpGjdKEKrdW6FMq
	 +yd/ZleC4sZZaK61DdyipVq/Qx5lLBcww4e+GOCCNwEHGjE2dWPgkcy+5zVh+i4rEYFxk
	 TWdAobibxSl3LOsEvZ9cd1VFdM+cfyHBwfdgrQI2uApB6vxRS4NzyrpQ5g95bPwb6tCUO
	 Qw1qg0wyrvn2p/98SVW3i35IRAfnVyagTDVGncJwJ6aq9zsaCpucuraDCXPysipI0Fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ci25x92W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183E6606A322;
	Mon,  9 Nov 2026 01:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ci25x92W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65011F008A2;
	Mon,  9 Nov 2026 01:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794187374;
	bh=uu4b4q9g+ZAPloji05p+CCMtBgpxRHYFQ7AS0/TwBHc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Ci25x92We9LQDp/BzLsL3hLWF7dXU8H8VmIjEskiWc94CTiila4wXQqE6HAowUH1B
	 Qga+SpdoDITwuPEILfgjqKjSSAifvxY7GGA5UBFlZhlo8dOcK1G9LZ4DN8LJZqGxXE
	 2iIkQLAXUA7CaH0jNAnO36t43eFI50nYnmE82YARF3g/+9I2cs2CqIO/pbOX2iZFtT
	 jPSKiX1g5SunKcVF5nwb1pAkHZb1TRltiyGEouZoHtWWAzZdYJjZ/rgm0uxYeiqJv7
	 NrvGiYw+bDKNmfwwSq+/Dfu8lSwId7uSxfj/Y24x7ShuNTCwMAtM2QTx03Uu5kD22G
	 XsVAZguAlr1Wg==
Subject: Re: [PATCH net-next v3 1/9] bnxt_en: let the stack segment GSO skbs
 with too many frags
From: netdev-bot+sashiko@kernel.org
To: sdf.kernel@gmail.com
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, andrew+netdev@lunn.ch,
 edumazet@kernel.org, horms@kernel.org, corbet@lwn.net,
 skhan@linuxfoundation.org, rdunlap@infradead.org, michael.chan@broadcom.com,
 pavan.chebbi@broadcom.com, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, alexanderduyck@fb.com, kernel-team@meta.com,
 sdf@fomichev.me, dimitri.daskalakis1@gmail.com, almasrymina@google.com,
 dtatulea@nvidia.com, bobbyeshleman@meta.com, asml.silence@gmail.com,
 daniel@iogearbox.net, razor@blackwall.org, leitao@debian.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org, leon@kernel.org
Date: Mon, 09 Nov 2026 01:22:52 +0000
Message-ID: <179418737248.994134.10509157155829463489@kernel.org>
In-Reply-To: <20261105222058.944293-2-sdf@fomichev.me>
References: <20261105222058.944293-2-sdf@fomichev.me>
X-sashiko-severity: Low
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

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The patch fixes real functional bugs in existing bnxt code, but
  it has no Fixes: tag and is not routed to stable.
- [Low] Clearing NETIF_F_GSO_MASK in bnxt_features_check() makes the
  stack segment a GSO skb with nr_frags > TX_MAX_FRAGS.

--

bnxt_en: let the stack segment GSO skbs with too many frags

When MAX_SKB_FRAGS > TX_MAX_FRAGS, this patch clears the GSO features in
bnxt_features_check() for skbs that have more than TX_MAX_FRAGS frags.
The stack then segments those skbs, and bnxt_start_xmit() no longer
linearizes them. Non-GSO skbs with too many frags are still linearized in
the xmit path.

Link: https://lore.kernel.org/all/CANn89i+ps_CozfOyRnKav0_LUmSekJ9ExB5JkDbTAVf_ss_98g@mail.gmail.com/

> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index 33c4cacc8ffe3..f20b61180ab2d 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -14320,6 +14320,11 @@ static netdev_features_t bnxt_features_check(struct sk_buff *skb,
>  				skb_shinfo(skb)->gso_size))
>  		features &= ~NETIF_F_GSO_MASK;
>  
> +#if (MAX_SKB_FRAGS > TX_MAX_FRAGS)
> +	if (skb_shinfo(skb)->nr_frags > TX_MAX_FRAGS)
> +		features &= ~NETIF_F_GSO_MASK;
> +#endif

[Severity: Low]
Should this patch have a Fixes: tag?

Commit b91e82129400 ("bnxt_en: Linearize TX SKB if the fragments exceed
the max") added the unconditional linearize in bnxt_start_xmit():

bnxt_start_xmit() {
    ...
#if (MAX_SKB_FRAGS > TX_MAX_FRAGS)
	if (skb_shinfo(skb)->nr_frags > TX_MAX_FRAGS) {
		...
		if (skb_linearize(skb))
			goto tx_free;
	}
#endif
    ...
}

bnxt calls netif_set_tso_max_size(dev, GSO_MAX_SIZE), so a BIG TCP skb
can be linearized into a head larger than 64KB. That length is then
encoded here:

	flags = (len << TX_BD_LEN_SHIFT) | TX_BD_TYPE_LONG_TX_BD |
		TX_BD_CNT(last_frag + 2);

TX_BD_LEN_SHIFT is 16 and flags is a u32. The upper bits of the length
are lost, so the BD length no longer matches the DMA mapping.

bnxt also sets dev->netmem_tx = NETMEM_TX_DMA. For devmem GSO skbs,
skb_linearize() always fails, because __pskb_pull_tail() returns NULL
when !skb_frags_readable(). Those skbs are dropped at tx_free.

The commit message describes both problems. Without a Fixes: tag, stable
kernels that carry b91e82129400 won't pick up this fix.

[Severity: Low]
Can the segments that the stack produces here still have more than
TX_MAX_FRAGS unreadable frags?

Only the GSO features are cleared, and nothing limits the frag count of
each resulting segment. zerocopy_fill_skb_from_devmem() adds one frag per
iovec entry and does not merge adjacent ranges:

net/core/datagram.c:zerocopy_fill_skb_from_devmem() {
    ...
		size = min_t(size_t, size, iter_iov_len(from));
		netmem_inc_ref(net_iov_to_netmem(niov));
		skb_add_rx_frag_netmem(skb, i, net_iov_to_netmem(niov), off,
				       size, PAGE_SIZE);
    ...
}

Suppose a devmem sender uses small iovecs: frags averaging under about
47 bytes at a 1500 MTU, or under about 290 bytes at a 9K MTU. Then a
single MSS-sized segment from skb_segment() can span more than 30 frags.
__copy_skb_header() also carries over skb->unreadable to that segment.

Such a non-GSO segment then reaches skb_linearize() in bnxt_start_xmit(),
which fails for net_iov frags, and the segment is dropped at tx_free.
TCP retransmissions rebuild the same layout, so the flow may stall.

This is not worse than before the patch, when the whole GSO skb was
dropped in the same way. However, the commit message gives "always fails
for unreadable skbs" as a reason for the change, and for these flows that
failure can still happen after segmentation.

Could the commit message mention this limitation? Fully closing the gap
would need a fallback that handles unreadable frags, or a frag limit per
MSS window at sendmsg time, rather than skb_linearize().

>  	switch (vlan_get_protocol(skb)) {
>  	case htons(ETH_P_IP):
>  		if (!skb->encapsulation)

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261105222058.944293-1-sdf%40fomichev.me
