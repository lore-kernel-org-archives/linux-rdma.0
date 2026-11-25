Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795615688;
	b=zA5xj6ZrNAqc1ygUusVmz/zDcDUkfAWZ4omf7fa9ceRA2QW6l6+M/01LYOTNhdIp8LTE
	 I1wulqrLjmQxKlUmkM/DVsRm0HEoMNbUlnUc1+KpSJUkv2PazzBInrZ4dVRExBbwsqFuw
	 oyePnx9FfU22PHYhoNwrBYyBcdUZO/ujuCDRdzLt7FflwkDmqeUpdqUwU0Yulz5Fv4G2n
	 O8wfx5H82gkHlrx/WX3d6P/WIl/3jVSVB/tCAKGYcTqkCBMMCJDm9Ly5Yp/5/gzEf4WNg
	 dsxp/OyXiw6AW/w8GeeNY3gZw6831v7IXhGWLg/B1DD6+SysmxsLxnMy5MX9aHnf0KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795615688;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=DbX3kn/Ze5xIjQfpzp+2KyS5qm64xHA6hXYjOn6Tc1U=;
	b=BQgAXynK3MFcHDkUXrtprwnLwJdDVMjtZ89Qi+ApsDjZPkXiR0GsNKDnogimAtJz38ki
	 QG1roHedPgIfiNWQlMe1hBQkuJRQQ3lpVQHHpUaKTOsa1bTTbBtjQ5mFGpumShuCeaF8n
	 CMF8vzoilDzmYJ3OZq579967fwV5161HQQJDxqFHBFEbDvcZdMWVKzYUaRpHR4mbcJ4u3
	 hsdu+J16berFCead404uFyTzkA+b/rKBeGju4yDd47p224QLET09eBQts0BxMAWu+6IXB
	 IlJuUIz+qgJKTV5muzRq4eJNfpDIq06iJU0x8LZg72gB/DH86VLAt4aY1bmWy7fYP7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jp2w8Kru;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A38C606A337;
	Wed, 25 Nov 2026 14:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jp2w8Kru
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ABCD1F000E6;
	Wed, 25 Nov 2026 14:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795615687;
	bh=DbX3kn/Ze5xIjQfpzp+2KyS5qm64xHA6hXYjOn6Tc1U=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Jp2w8KrunVgtxiDH4wXbOA+u4JFNrwblxiDUSqbJ4Ow8rnq41Oy/JXrWLab4eW/xj
	 iSwEShRFrLY/HwaC9fEcbltSpK1zj6lcA3y5g50YdemMbCoNiQt8G6qCUAERDvQgk+
	 gV0KdQh9qlBOWwrLmSf7wzAbl0WJtxy/oSqS/q4CKgRk7S32tRccB0HioFudZXdCAM
	 aEps6jbm50ozKx4v1EtRiOWrYxXAAlQsbw+75lutFHA9HIt5qMo+7RV8UKPBAsC/Xu
	 5vnRZhaJZB/rI/0x2kmy3SVRTQcOOxmWsLdwmQ6zDWrbHy9ByOYaqdORA3LFZuCh7W
	 tYwBNuNgs2mwg==
Subject:
 Re: [PATCH net-next 03/15] net: Add memory providers that only feed XDP
From: netdev-bot+sashiko@kernel.org
To: bjorn@kernel.org
Cc: magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
 john.fastabend@gmail.com, andrii@kernel.org, eddyz87@gmail.com,
 memxor@gmail.com, ilias.apalodimas@linaro.org, alexanderduyck@fb.com,
 saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 michael.chan@broadcom.com, pavan.chebbi@broadcom.com, corbet@lwn.net,
 shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
 stuclar@meta.com, sdf@fomichev.me, horms@kernel.org, martin.lau@linux.dev,
 almasrymina@google.com, song@kernel.org, yonghong.song@linux.dev,
 jolsa@kernel.org, emil@etsalapatis.com, ihor.solodrai@linux.dev,
 rdunlap@infradead.org, kernel-team@meta.com, dimitri.daskalakis1@gmail.com,
 bobbyeshleman@meta.com, mohsin.bashr@gmail.com, kees@kernel.org,
 leitao@debian.org, maxime.chevallier@bootlin.com, cuitao@kylinos.cn,
 vadim.fedorenko@linux.dev, mike.marciniszyn@gmail.com, kuniyu@google.com,
 jiayuan.chen@linux.dev, mkarsten@uwaterloo.ca, razor@blackwall.org,
 dw@davidwei.uk, asml.silence@gmail.com, linux-rdma@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2026 14:08:04 +0000
Message-ID: <179561568417.3135.7506567631056689365@kernel.org>
In-Reply-To: <20261124125654.183091-3-bjorn@kernel.org>
References: <20261124125654.183091-3-bjorn@kernel.org>
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

- [Medium] This patch adds MP_XDP_ONLY providers, which by design sit
  next to native XDP and AF_XDP.

--

net: Add memory providers that only feed XDP

This patch lets a memory provider mark itself XDP-only with MP_XDP_ONLY.
Such a provider needs no header split and does not block native XDP. A page
pool takes it only when the driver sets PP_FLAG_ALLOW_XDP_ONLY_NETMEM. The
XDP install, XDP propagate and ethtool rings checks move from
dev_get_min_mp_channel_count() to the new dev_mp_blocks_xdp().

> diff --git a/net/core/dev.c b/net/core/dev.c
> index 4ca8a9f5a7a5c..8a1d5a284e53c 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c

[ ... ]

> @@ -11146,6 +11146,23 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
>  	return err;
>  }
>  
> +/* Native XDP runs next to XDP-only providers only, see %MP_XDP_ONLY */
> +bool dev_mp_blocks_xdp(const struct net_device *dev)
> +{
> +	const struct memory_provider_ops *ops;
> +	unsigned int i;
> +
> +	netdev_assert_locked_ops_compat(dev);
> +
> +	for (i = 0; i < dev->real_num_rx_queues; i++) {
> +		ops = dev->_rx[i].mp_params.mp_ops;
> +		if (ops && !(ops->flags & MP_XDP_ONLY))
> +			return true;
> +	}
> +
> +	return false;
> +}
> +

[Severity: Medium]
Should the AF_XDP zero-copy setup paths use this helper too?

Two callers still use dev_get_min_mp_channel_count(). It counts every
provider by mp_priv, including XDP-only ones:

net/xdp/xsk_buff_pool.c:xp_assign_dev() {
    ...
	if (dev_get_min_mp_channel_count(netdev)) {
		err = -EBUSY;
		goto err_unreg_pool;
	}
    ...
err_unreg_pool:
	if (!force_zc)
		err = 0; /* fallback to copy mode */
    ...
}

drivers/net/netkit.c:netkit_xsk() {
    ...
	if (!create || !dev_get_min_mp_channel_count(phys))
		ret = phys->netdev_ops->ndo_bpf(phys, &xdp_lower);
    ...
}

Later in the series, xsk_sink_bind() installs an MP_XDP_ONLY provider
(xsk_sink_ops) on q0. After that, a classic AF_XDP socket that binds q1 on
the same device would see this:

  bind with XDP_ZEROCOPY fails with -EBUSY
  bind without a mode flag falls back to copy mode and does not report it
  XSK pool creation through a netkit leased queue returns -EBUSY

The result also seems to depend on bind order. Suppose the classic
zero-copy socket binds q1 first. The sink can then still be installed on
q0, because __netif_mp_open_rxq() only checks the pool of its own queue:

net/core/netdev_rx_queue.c:__netif_mp_open_rxq() {
    ...
	if (rxq->pool && !xdp_only) {
    ...
}

So the same end state (sink on q0, zero copy on q1) is accepted in one
order and refused in the other. Is that intended?

Nothing can hit this at this commit, since no provider sets MP_XDP_ONLY
yet. It becomes reachable with "xsk: Receive in the device's buffer
layout". At the end of the series, both call sites still use
dev_get_min_mp_channel_count(). Documentation/networking/af_xdp.rst does
not describe the restriction either.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261124112707.118678-1-bjorn%40kernel.org
