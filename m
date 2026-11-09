Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794187387;
	b=i7GCvBx9PkYnP6pRA0jLFZ6XVk3vOde6DqITYe68JJxTIHPIiVkfWsU8fF2kbY4EvUwT
	 +IzlPq9wUxmi7lPSq/SxNWpICyttrTzR40RteGM/rWqAUX288BhWduoa5pPSZqT8xFD/n
	 gTuLgPsNR6JccCs6b/souyyAv66/JsvcPOehVDh1BmVSQ9v/4Ev/KCPRFIn1+SUMFYdKu
	 bjc5tPVq+ExflMrBbT3yZQLx1rDZUiIibSDFBksuVcVzZC+7VoXu9sRh6H0ucEyKORcYE
	 h9iEUQ5kjnrGT38dPKCjzOsQgGNu2upirg7eCpXXBcIv9VnXSuri6gr47H6p/RMX+ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794187387;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=iZ7ogG+JFo5k2Mr7tS6nDhVP6uMgvwh4bTdI7c17U0Q=;
	b=El0eItzTqmN9hjBubRnoHTXHZXkzqT5L7DN3XUupSJm/OYucaQ7ZSkbHcI0wcsbVC+3Y
	 sRaHgNUE/S4lqiJLC/5m2aRCf4ZrTV/8+mzgHPouvtmO4rdkle0xZVrd4uuJ8UIrc2WIY
	 iju37iWNFCvddPffIjL3V7a595EV5GxnM2o1TJUy4XyLaYBYF/02r9n/LFgTCfpJPjTaY
	 ltIQQhk7dyFsMH3XICqaF31N9mYbDWfSQXvObxrxGSZxQGs3cCqccWXMbHFyaDiZ5oP4z
	 9BvqRb9HGAJaqmLJvJ3vkfk6qajbgw6uqy8+tKjN0RXmS28Hn9PU3uDhvjCXpLS3rtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gQhvOGKK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B668560A5BC7;
	Mon,  9 Nov 2026 01:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gQhvOGKK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904A31F00A04;
	Mon,  9 Nov 2026 01:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794187386;
	bh=iZ7ogG+JFo5k2Mr7tS6nDhVP6uMgvwh4bTdI7c17U0Q=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=gQhvOGKKorP0lWdhew4VYHhPZ0HETKAjGg2F63PhurTUrKooGVDQxaAypbxPYqy56
	 EkLymIgPsj4cHmCA1nUwqx+Nl23bVtnHlLY4KCQUGUVS+3ZsG0Z0A2CJ1KwN1rSGO9
	 Av8uDE+y3sya7uaTWm9HM7NyoDBscLXVEQlDULT8GvTpT6oT61ZtkNE0xZlZzPkKtw
	 CCZyp4+WHaPUOOPuFzj/J6cKFcENZPlyf+ELMLkXKgRNSwCvoifEPtt0+NMsjnzme7
	 vrTgs8v/ACflsqINZ/kgSKTkTpPPLLGzYdhY9ynqTx34+CvEb5DvGVPzOAN4FSewqP
	 O2nwHbBROQoDw==
Subject: Re: [PATCH net-next v3 8/9] net: devmem: size TX net_iovs from the
 dmabuf sg table
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
Date: Mon, 09 Nov 2026 01:23:04 +0000
Message-ID: <179418738408.994134.12387400537759262351@kernel.org>
In-Reply-To: <20261105222058.944293-9-sdf@fomichev.me>
References: <20261105222058.944293-9-sdf@fomichev.me>
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

- [Medium] This patch makes TX net_iovs grow from PAGE_SIZE to as much as
  2MB.

--

net: devmem: size TX net_iovs from the dmabuf sg table

This patch changes how TX net_iovs are sized. Instead of PAGE_SIZE, each
TX net_iov is now the largest power of two from PAGE_SIZE up to 2MB that
aligns both the dmabuf size and every DMA segment in the sg table.
netdev_nl_bind_tx_doit() passes niov_shift == 0 to ask for this, so that
BIG TCP can build larger frags.

> diff --git a/net/core/devmem.c b/net/core/devmem.c
> index b607cf495980c..74de200f66be2 100644
> --- a/net/core/devmem.c
> +++ b/net/core/devmem.c

[ ... ]

> @@ -388,6 +401,17 @@ net_devmem_bind_dmabuf(struct net_device *dev, void *vdev,
>  		goto err_unmap;
>  	}
>  
> +	if (!niov_shift) {
> +		niov_size = SZ_2M;
> +		while (niov_size > PAGE_SIZE &&
> +		       (!IS_ALIGNED(dmabuf->size, niov_size) ||
> +			!net_devmem_sgt_aligned(binding->sgt, niov_size)))
> +			niov_size /= 2;
> +		niov_shift = ilog2(niov_size);
> +	}
> +	binding->niov_shift = niov_shift;
> +	niov_size = 1UL << niov_shift;
> +

[Severity: Medium]
netdev_nl_bind_tx_doit() now passes niov_shift == 0, so a hugepage-backed
dmabuf gets 2MB TX net_iovs. Can a devmem TX frag then end up larger than
dev->netmem_tx_max_frag_size?

The cap is only applied when a frag is first built:

net/core/datagram.c:zerocopy_fill_skb_from_devmem() {
    ...
		size = min_t(size_t, size, binding->tx_max_frag_size);
    ...
}

Later, tcp_mtu_probe()->tcp_clone_payload() merges contiguous frags and
never checks the binding's limit:

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

Before this patch, contiguous frags inside one net_iov could add up to at
most PAGE_SIZE. That is also the default netmem_tx_max_frag_size, so a
merged frag still stayed within the cap.

With 2MB net_iovs, contiguous TCP segments in the same net_iov can be
merged into one frag of up to probe_size bytes. On a path whose MTU is
above PAGE_SIZE, that frag is larger than the limit the device declared.

Documentation/networking/netmem.rst says:

    3. Devmem TX frags are capped at netdev->netmem_tx_max_frag_size,
       PAGE_SIZE by default.

The commit message says:

    frags are capped to the device limit when they are built

Is a cap applied only at build time enough to keep that contract?

The other merge paths are tcp_grow_skb() and SACK shifting. Both go
through skb_shift(), which bails out on skb_zcopy(), so tcp_clone_payload()
looks like the only path left.

All of these are needed to reach it:

  - an unprivileged bind-tx (NETDEV_CMD_BIND_TX has no GENL_ADMIN_PERM)
  - MTU probing turned on (tcp_mtu_probing=2, or 1 after black hole
    detection)
  - a path MTU above the device's frag limit

I could not find an in-tree driver that breaks today:

  - gve keeps the PAGE_SIZE default but splits buffers at
    GVE_TX_MAX_BUF_SIZE_DQO
  - bnxt and fbnic use 32K
  - mlx5 uses U32_MAX

A driver that relies on the documented cap would still get a frag larger
than it declared.

There is also a related issue in the same code. It is pre-existing and
was not introduced by this patch.

skb_frag_page() returns NULL for every net_iov frag. So for devmem frags
the skb_frag_page() comparison above is always true, even when the frags
come from different net_iovs.

Suppose the next frag's offset inside its net_iov equals the end offset
of lastfrag inside its own net_iov. Then lastfrag is extended over bytes
from the wrong net_iov, and the wrong dmabuf data is sent under real
sequence numbers. The extended range stays inside the first net_iov, so
there is no DMA outside the dmabuf.

Would either of these fix both problems:

  - compare skb_frag_netmem() and apply binding->tx_max_frag_size in
    tcp_clone_payload()
  - don't coalesce unreadable skbs when building MTU probes

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261105222058.944293-1-sdf%40fomichev.me
