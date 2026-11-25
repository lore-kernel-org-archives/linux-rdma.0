Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795635789;
	b=nu3LWheMd/PSSb1wOKC2MG0PCJi8ZRbFAGLQvNH02xGp2wD1Mb7wXoNyTH8xEzYVtOi+
	 84ZQGIckw0hW40uzd98xW1WT2JLCfx0gR+O4/7s6s6nURM8eNWv7dM09HP/k25ImaaOQ7
	 1c/9EgLo+m1vK8J7JFbwR5YiN+flThUmYpFYMVdKeNtzLOHd/0w8XENDusZ0SQ3M+YMFy
	 4ZjMTfGOnWIq/r8lq1UGId5J04/s3FTTHY3yJmlmZJLFsuO6HYEGg9KU7vjFngmKmZMMC
	 gzY6/DIJjIQyQXJqe7pl/xbZ+faBZeDsjoqZOmGNOppwDwITtzoKSKedyBtZNW1iEJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795635789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=MLc4/6k9Z6sxMwo5Ugfr+gMYCrDQyFv5j935bfc4lHg=;
	b=0+j9OmUKBgDnpXmxqqXR7VXlVd57wa/S3/JDFylYumfqlkk0nP9+/CU3FKJCelvhpegm
	 qQG+bcoaqaGvIeJdMRPqkKAfHyctjGxvZcq2q1Nzo2McCK3ZlYjtegKF1oxqqpXLLt/dD
	 vbhOUQHcuNrQ3/qX6yO8tQCrL506hb1VjIxxx5bfFq+dBWt05DswG9TD7xj6ckXYwvpJR
	 B8XoKXirqzwuLYdRihrebYDwjMdfdFoV8LK0q5rC/sxaDPRzYD5oyGGzamaDtFjJmJdNg
	 0E4P0tN0zOkNLxc1Tz7nJivYnOYfSJwCJjVvxSCbKQHtpgakxwDn/8yx01WfXRErXxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IlB4xbnc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6667606A321;
	Wed, 25 Nov 2026 19:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IlB4xbnc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B731F000C0;
	Wed, 25 Nov 2026 19:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795635789;
	bh=MLc4/6k9Z6sxMwo5Ugfr+gMYCrDQyFv5j935bfc4lHg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=IlB4xbncT7TdKfveO1rm1FT2gCv4IrTSQ05brtd2009HIOI86yf1t3YO9xQcOpuqm
	 plQ3clS+mv14LdeWvVQeB80S43PeuiptlMEkhkm7cvp4Zc0wqB9563ctgrQ+Fi2TMq
	 sLGpJdYdnBreL+XLlfv1CXxOCcvZ1CNSI24CocAOUeNwUwRrfpnACcwrDRfjpuPgpH
	 s7/V3e5TEknLqvfFLiOoFQ+VvEaIl4LLR0jAZ92VEtv7Zo2MQs03phRdNTCbhi+zQl
	 WQGXej1P1//AE8xrQwLbF466qrnPQPcZCp8bOtqmfAvdFovymXQuqLh8M2zCmK3wX9
	 N6hMNK3MH/JTw==
From: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To: netdev-bot+sashiko@kernel.org
Cc: magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, andrew+netdev@lunn.ch, ast@kernel.org,
 daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
 andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com,
 ilias.apalodimas@linaro.org, alexanderduyck@fb.com, saeedm@nvidia.com,
 tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 michael.chan@broadcom.com, pavan.chebbi@broadcom.com, corbet@lwn.net,
 shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
 stuclar@meta.com, sdf@fomichev.me, horms@kernel.org, martin.lau@linux.dev,
 almasrymina@google.com, song@kernel.org, yonghong.song@linux.dev,
 jolsa@kernel.org, emil@etsalapatis.com, ihor.solodrai@linux.dev,
 rdunlap@infradead.org, kernel-team@meta.com,
 dimitri.daskalakis1@gmail.com, bobbyeshleman@meta.com,
 mohsin.bashr@gmail.com, kees@kernel.org, leitao@debian.org,
 maxime.chevallier@bootlin.com, cuitao@kylinos.cn,
 vadim.fedorenko@linux.dev, mike.marciniszyn@gmail.com, kuniyu@google.com,
 jiayuan.chen@linux.dev, mkarsten@uwaterloo.ca, razor@blackwall.org,
 dw@davidwei.uk, asml.silence@gmail.com, linux-rdma@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 03/15] net: Add memory providers that only feed
 XDP
In-Reply-To: <179561568417.3135.7506567631056689365@kernel.org>
References: <20261124125654.183091-3-bjorn@kernel.org>
 <179561568417.3135.7506567631056689365@kernel.org>
Date: Wed, 25 Nov 2026 20:43:05 +0100
Message-ID: <87h5h4ofxy.fsf@all.your.base.are.belong.to.us>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

netdev-bot+sashiko@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 1 =C2=B7 Low: 0
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
>
> - [Medium] This patch adds MP_XDP_ONLY providers, which by design sit
>   next to native XDP and AF_XDP.
>
> --
>
> net: Add memory providers that only feed XDP
>
> This patch lets a memory provider mark itself XDP-only with MP_XDP_ONLY.
> Such a provider needs no header split and does not block native XDP. A pa=
ge
> pool takes it only when the driver sets PP_FLAG_ALLOW_XDP_ONLY_NETMEM. The
> XDP install, XDP propagate and ethtool rings checks move from
> dev_get_min_mp_channel_count() to the new dev_mp_blocks_xdp().
>
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 4ca8a9f5a7a5c..8a1d5a284e53c 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>
> [ ... ]
>
>> @@ -11146,6 +11146,23 @@ int dev_change_xdp_fd(struct net_device *dev, s=
truct netlink_ext_ack *extack,
>>  	return err;
>>  }
>>=20=20
>> +/* Native XDP runs next to XDP-only providers only, see %MP_XDP_ONLY */
>> +bool dev_mp_blocks_xdp(const struct net_device *dev)
>> +{
>> +	const struct memory_provider_ops *ops;
>> +	unsigned int i;
>> +
>> +	netdev_assert_locked_ops_compat(dev);
>> +
>> +	for (i =3D 0; i < dev->real_num_rx_queues; i++) {
>> +		ops =3D dev->_rx[i].mp_params.mp_ops;
>> +		if (ops && !(ops->flags & MP_XDP_ONLY))
>> +			return true;
>> +	}
>> +
>> +	return false;
>> +}
>> +
>
> [Severity: Medium]
> Should the AF_XDP zero-copy setup paths use this helper too?
>
> Two callers still use dev_get_min_mp_channel_count(). It counts every
> provider by mp_priv, including XDP-only ones:
>
> net/xdp/xsk_buff_pool.c:xp_assign_dev() {
>     ...
> 	if (dev_get_min_mp_channel_count(netdev)) {
> 		err =3D -EBUSY;
> 		goto err_unreg_pool;
> 	}
>     ...
> err_unreg_pool:
> 	if (!force_zc)
> 		err =3D 0; /* fallback to copy mode */
>     ...
> }
>
> drivers/net/netkit.c:netkit_xsk() {
>     ...
> 	if (!create || !dev_get_min_mp_channel_count(phys))
> 		ret =3D phys->netdev_ops->ndo_bpf(phys, &xdp_lower);
>     ...
> }
>
> Later in the series, xsk_sink_bind() installs an MP_XDP_ONLY provider
> (xsk_sink_ops) on q0. After that, a classic AF_XDP socket that binds q1 on
> the same device would see this:
>
>   bind with XDP_ZEROCOPY fails with -EBUSY
>   bind without a mode flag falls back to copy mode and does not report it
>   XSK pool creation through a netkit leased queue returns -EBUSY
>
> The result also seems to depend on bind order. Suppose the classic
> zero-copy socket binds q1 first. The sink can then still be installed on
> q0, because __netif_mp_open_rxq() only checks the pool of its own queue:
>
> net/core/netdev_rx_queue.c:__netif_mp_open_rxq() {
>     ...
> 	if (rxq->pool && !xdp_only) {
>     ...
> }
>
> So the same end state (sink on q0, zero copy on q1) is accepted in one
> order and refused in the other. Is that intended?

No, that's not intended. The device-wide check in
xp_assign_dev()/netkit_xsk() predates this work, and a sink on another
queue does not stop native XDP. I'll switch both to dev_mp_blocks_xdp()
in the next version, so the bind order no longer mattters.

