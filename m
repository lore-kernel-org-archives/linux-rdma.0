Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794187379;
	b=ocfwwbNjSNkh/w5Nhj+BhVs64oNZw9lKedsT5mm3zB0luTiuF/IWZUEspUzxsskbGwPo
	 +Zb7gS+Q8KYNuLLTYXnaM4rv9ucm+xQnryUASHRN3yr7/so8RBzSUU0Reu5PROfG7ZGZ+
	 Cc1x8vi2noYfigfOS9ZM2GBWpWC4lgXt050NCiKUkxTzkYVKzctKBh+QwZ5bwqvbOpb9L
	 OmkgL6tC3cqEn5CQdQxRRn+4ep0nhtaNP6a1zqNj+2QPGYuFmOsXA2qfE1fQxl4SPt92o
	 FCkeRER70Lwcy8p79BG5nbaQ8gHVCwwtseUKN1NmDWjDCwEk+AwmD/Wej3vj+JxC39w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794187379;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=8pW4eoUoFBjt45/T7wxAAHU7qXhZjgsirRTlsHsjZ0A=;
	b=tMdSG3zD19trqPuYFTxsN3Sqq101mkJ7vo8/bOfQSOEwAiVSuHmPgNClbJhppvgiIjsA
	 W1cqYZzMCizfJC9nS5hddp7y91dY/MsMfvYpvAO7XQn8Fx59IdZeBdACoP52EGvfWH1Kr
	 QnvXNFRF+7Y3jNK54kno+5mUKZclHfOgf35QrzJsG6hoZBbp2sw006TXhj/66/NTpxow7
	 iTxZX5eDdaSUuTgqBPhHWLku5I0OzwcgG2L6ktGvUaJ9koZeyWXZ4m62wYiDoihLVRWVI
	 r6xKZRW/8/F7BMdY9jki3LD+fsVvkjHAWoDfFo4wCjzxOPz3vHMe0y/69U7CPz1+41A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SM7hLJSH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66577606EE84;
	Mon,  9 Nov 2026 01:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SM7hLJSH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2A21F008A6;
	Mon,  9 Nov 2026 01:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794187379;
	bh=8pW4eoUoFBjt45/T7wxAAHU7qXhZjgsirRTlsHsjZ0A=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=SM7hLJSHd5+AFw12MzAmxSxVbibhYITBmJA8aVgBYlj8hFxvLBeTOsFsSdfXAWrDc
	 08k/cpqJcOepBYtuqgG/w9hvljxgGhYBXzz/2RfFCAsj4dyf7bHso4mK/yD2P/YSOX
	 0wqKuVVvd0FPfROMzcDo7FcfdrvEHhVcUmbKNFkbWHYkKqLJirthZrasblprJdD2Dc
	 u6RV7lJYEBxfXsP6LQHJC1EKfRNM+BFgr2rgWSaTmCC9+t0EipIgH6WkKqKgxRgMOz
	 iKMtJ+X9VksbMGJyxx49zYq1MtJ7szgbfPJyVNFIHYVIDWLpInWV7ODXUOcEdEcwG1
	 pCSJUQ322/0+g==
Subject: Re: [PATCH net-next v3 4/9] net: devmem: add a per-device netmem TX
 frag size limit
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
Date: Mon, 09 Nov 2026 01:22:57 +0000
Message-ID: <179418737701.994134.5100743053640770189@kernel.org>
In-Reply-To: <20261105222058.944293-5-sdf@fomichev.me>
References: <20261105222058.944293-5-sdf@fomichev.me>
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

Critical: 0 · High: 0 (1) · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The new per-device cap is enforced in only one place, when
  zerocopy_fill_skb_from_devmem() (net/core/datagram.c:737) first…

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but
  tcp_clone_payload() (net/ipv4/tcp_output.c:2699-2703) can merge frags…

--

net: devmem: add a per-device netmem TX frag size limit

This commit adds a netmem_tx_max_frag_size field to struct net_device,
defaulting to PAGE_SIZE, and copies it into the devmem dmabuf binding
when the binding is created. zerocopy_fill_skb_from_devmem() then caps
each devmem TX frag to that limit.

> diff --git a/net/core/datagram.c b/net/core/datagram.c
> index 489d92fe6dae8..a8d3f87d38c58 100644
> --- a/net/core/datagram.c
> +++ b/net/core/datagram.c
> @@ -734,6 +734,7 @@ zerocopy_fill_skb_from_devmem(struct sk_buff *skb, struct iov_iter *from,
>  
>  		size = min_t(size_t, size, length);
>  		size = min_t(size_t, size, iter_iov_len(from));
> +		size = min_t(size_t, size, binding->tx_max_frag_size);

[Severity: Medium]
Is this the only place the new cap is enforced? The netmem.rst text added
by this patch says "Devmem TX frags are capped at
netdev->netmem_tx_max_frag_size". TCP MTU probing looks like it can merge
the capped frags back together later.

tcp_mtu_probe()->tcp_can_coalesce_send_queue_head() uses
tcp_skb_can_collapse(). That check only compares skb_pure_zcopy_same() and
skb_frags_readable(), so two devmem skbs pass it. tcp_mtu_probe() then
calls tcp_clone_payload():

net/ipv4/tcp_output.c:tcp_clone_payload() {
    ...
			if (lastfrag &&
			    skb_frag_page(fragfrom) == skb_frag_page(lastfrag) &&
			    skb_frag_off(fragfrom) == skb_frag_off(lastfrag) +
						      skb_frag_size(lastfrag)) {
				skb_frag_size_add(lastfrag, todo);
				continue;
			}
    ...
}

skb_frag_page() returns NULL for every net_iov, so for devmem frags only
offset contiguity is checked.

Suppose this line splits one large net_iov into two frags, for example
(niov0, 0, 4K) and (niov0, 4K, 4K). Those two frags would be merged into
one frag of up to probe_size bytes. tcp_transmit_skb() then hands it to
the driver, and nothing checks it against binding->tx_max_frag_size.

At this commit TX net_iovs are still PAGE_SIZE, because
netdev_nl_bind_tx_doit() passes PAGE_SHIFT. So the merged frag can't go
past the default cap yet.

The later patch in the series, "net: devmem: size TX net_iovs from the
dmabuf sg table", lets TX net_iovs grow to 2MB. After that, take a device
left at the PAGE_SIZE default that runs a jumbo MTU with MTU probing
enabled. It would get probe frags of roughly MTU size, which is above its
advertised cap.

In-tree drivers seem fine with this today. bnxt and fbnic advertise 32K,
mlx5 advertises U32_MAX, and gve already splits frags into its own
descriptors. Even so, the documented limit would not hold.

Could tcp_clone_payload() compare skb_frag_netmem() and stop merging once
the binding cap is reached? Another option is to skip MTU probe
coalescing for unreadable skbs.

[Severity: High]
This isn't a bug introduced by this patch, but the same merge check in
tcp_clone_payload() looks like it can also combine frags from different
net_iovs. skb_frag_page() returns NULL for both frags, so the page
comparison always passes and only the offsets are compared.

For example, take a single sendmsg on a devmem TX socket with
iov[0] = {dmabuf offset 0, len 2048} and
iov[1] = {dmabuf offset 6144, len 2048}. zerocopy_fill_skb_from_devmem()
builds:

    frag0 = (niov0, off 0, 2048)
    frag1 = (niov1, off 2048, 2048)

Suppose tcp_mtu_probe() then builds a probe that covers both frags.
tcp_clone_payload() sees that frag1's offset equals frag0's end, so it
extends frag0 to (niov0, 0, 4096) and never copies frag1's netmem.

Wouldn't the probe then carry dmabuf bytes [2048, 4096) instead of
[6144, 8192)?

The NIC computes the checksum over the wrong bytes, so the receiver
accepts them. If the probe is ACKed, tcp_eat_one_skb() has already
consumed the original skbs, so the stream stays corrupted.

The merged range stays inside niov0. So the result is wrong data from the
sender's own dmabuf, not an out-of-bounds DMA.

Should the merge test compare skb_frag_netmem(), the way
skb_can_coalesce_netmem() does? Nothing later in the series changes
tcp_output.c.

>  
>  		netmem_inc_ref(net_iov_to_netmem(niov));
>  		skb_add_rx_frag_netmem(skb, i, net_iov_to_netmem(niov), off,

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261105222058.944293-1-sdf%40fomichev.me
