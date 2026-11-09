Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794236904;
	b=m+qBfmXO5FOV4b7YXUwDT3j/TLgw7omBeoAnjkQ8TpTzB+7mEtP36vWk/tJoiwMe230b
	 7uf116KavwVjIfWE9/U9MEZZnL5KzinqFRd4auO1OYX+fCvNwV6lrlc3xTxRDM9q7jlW+
	 zDH1on8masdVwo+JRqoTqClKRBR+H/CqFarCzxYQ7rScrNLsmP8hArJN/oNfhf3Yod9cV
	 CNGlFqdpjBHZ5pWEQErpaKSwpCeagPDlz1rGX9X/fpWSae7ilzzBjHnzx32sySmP/SZFt
	 Yug/dqzZg1lhg6QMCihWAz2WEsNc41c4IJNZdoCXmmSBCL1bK6UMoX9pmrNdLMv3qNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794236904;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=WqBC88Kf5Gg8WaTqVGB4FecTUmwVU6riL8WD0AYlF2E=;
	b=yJzcbCupxxqr5MQTZy9keNanmduKGnaE2r2+pRNErAlVNdAb9FdeRbUuU80ntv78kZX+
	 aQRclvaiMSq5Q0nbaa4+GjyXJbh9vo8JfpA1cn9HgxvILNL50+1/ByH72WHaWhswWsVrV
	 bw07Z0DVbYu8LwULxqERnuu6B325T7giFj7OXNjKqa00b3aq0HM6hlFdFw+0oLaSYKLFv
	 Zm0Ts/pK08+S8DfWDnYF9zX9hWsoogagB8VCWdzNIuHnQbS9UONJcrEsA9/JoHrlArmES
	 byjlT2wJIyXsQgEv9fGnP8NCG/7pen7R9SFTKVptT4rarDYvgF7YZBsIuVQ+/ve+LqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S364pSCo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D59606A321;
	Mon,  9 Nov 2026 15:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S364pSCo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7B71F0089F;
	Mon,  9 Nov 2026 15:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794236903;
	bh=WqBC88Kf5Gg8WaTqVGB4FecTUmwVU6riL8WD0AYlF2E=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=S364pSCoafvS1W+mfiQ+caIdfPCKwzKnPyYgqJpbO627TcwLe5sUi1HugBdZxzdE3
	 7pRQXudq2Cc9folIttQUjLuborkPEmrK78Mswy1LrX8ZmvIXMweXT0gJrrvWRgBPV8
	 JgHYgBXrzyjrpZUioibcbvChUUfLeOE8lNHBnq9dMRgOHwA+BADMP5Sve9YMAGAh0f
	 FOT2YHauulMdQk3RaS1U9Okwa5tvZ4bp6AgHeRbZ+vyNYhDORdGAjIYWKp9qnBs2i1
	 UzhYP2iK6qL0LMLPIBpdZ1DFZQObqKxPl6bxHFMYSMxj/Ul/ebK3KR4O2EoONky8/s
	 sta/HiaCuVVnw==
Subject: Re: [PATCH ipsec v2 3/7] xfrm: esp: use the current sequence number
 for AAD and offload
From: netdev-bot+sashiko@kernel.org
To: Jeremy.Jean@oss.cyber.gouv.fr
Cc: steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
 sd@queasysnail.net, davem@davemloft.net, borisp@nvidia.com, saeedm@nvidia.com,
 leonro@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, kuba@kernel.org
Date: Mon, 09 Nov 2026 15:08:22 +0000
Message-ID: <179423690220.994134.7379565121466002244@kernel.org>
In-Reply-To: <20261108142652.1330952-4-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20261108142652.1330952-4-Jeremy.Jean@oss.cyber.gouv.fr>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The commit message says the bug is a wrong ESN high word at
  the 2^32 boundary: (H, 0xffffffff) gets authenticated with H+1.

--

xfrm: esp: use the current sequence number for AAD and offload

This commit passes esp->seqno into esp_output_set_extra() and
esp_output_set_esn(), so the software ESN AAD takes its high bits from the
segment's own sequence number instead of the already advanced xo->seq.hi.

For hardware offload, esp_xmit() and esp6_xmit() now write the current
sequence number into both xo->seq.low and xo->seq.hi of the private
secpath copy after skb_ext_add().

> diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
> index 3a0aafe991f47..6f6ce9ea5c491 100644
> --- a/net/ipv4/esp4_offload.c
> +++ b/net/ipv4/esp4_offload.c
> @@ -358,6 +358,10 @@ static int esp_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features_
>  		if (!xo)
>  			return -EINVAL;
>  
> +		/* Keep the current sequence number in the private copy. */
> +		xo->seq.low = seq;
                ^^^^

[Severity: Medium]
Does the commit message cover everything this line fixes?

The message talks about the ESN high word being wrong at the 2^32
boundary. Restoring xo->seq.low here also changes the low half for every
GSO segment that is split in software and then encrypted in hardware. No
ESN wrap is needed for that.

Before this patch, esp_xmit() saved seq, advanced the shared counter and
only then called skb_ext_add():

    seq = xo->seq.low;
    ...
    if (xo->flags & XFRM_GSO_SEGMENT) {
        esph->seq_no = htonl(seq);

        if (!skb_is_gso(skb))
            xo->seq.low++;
    ...
    if (!skb_ext_add(skb, SKB_EXT_SEC_PATH))

skb_ext_add()->skb_ext_maybe_cow() memcpy()s the already advanced
xfrm_offload into the private copy, so each segment carried seq + 1. The
last segment keeps the shared copy, and that one has been advanced too.

mlx5e_ipsec_set_iv() then builds the on-wire IV from that value:

    seqno = cpu_to_be64(xo->seq.low + ((u64)xo->seq.hi << 32));
    iv_offset = skb_transport_offset(skb) + sizeof(struct ip_esp_hdr);
    skb_store_bits(skb, iv_offset, &seqno, 8);

As a result, segment L+i went out with IV L+i+1, and the last segment
(L+n-1) used IV L+n. The next non-GSO packet gets sequence L+n from
xfrm_replay_overflow_offload_esn(), so its IV is also L+n.

Isn't that AES-GCM nonce reuse under the same key and salt?

This path is reachable when a device has NETIF_F_HW_ESP set but not
NETIF_F_GSO_ESP. One example is mlx5 without swp_lso, where
mlx5e_ipsec_build_netdev() returns before it enables GSO_ESP. Another is
running ethtool -K tx-esp-segmentation off.

The only related text in the commit message is:

  "Restore both halves because drivers can also use xo->seq to generate
  the IV."

That sentence does not say that the low half was off by one for every
segment, or that IVs were being reused.

The low-half off-by-one appears to come from c7dbf4c08868 ("xfrm: Provide
private skb extensions for segmented and hw offloaded ESP packets"), which
added the skb_ext_add() call after the increment. That commit is not in
the Fixes: tags.

The code change itself looks correct. Could the commit message describe
the per-segment IV reuse and add a Fixes: tag for c7dbf4c08868, so stable
and security triage can tell what is being fixed?

The same applies to the identical hunk in esp6_xmit() in
net/ipv6/esp6_offload.c.

> +		xo->seq.hi = upper_32_bits(be64_to_cpu(esp.seqno));
> +
>  		xo->flags |= XFRM_XMIT;
>  		return 0;
>  	}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261108142652.1330952-1-Jeremy.Jean%40oss.cyber.gouv.fr
