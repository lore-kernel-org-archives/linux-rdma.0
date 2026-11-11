Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794438824;
	b=kutjxG88/90DNeOWV6SISVlzCVXU7qw+ncC+c8/7d8RzhpwnbWWJ0636B9UQrvYv6R6G
	 tBO1DgWpz2wFIp5cB0OOSA5fRJS0RwBiWd7yYFhywHHpV06VhYFikedEUe3A29XM8CHVn
	 okufdCk31hn/aW8YmEvq0FkQAc6r+/rvdqShimBpzYB/X+nR7Od7dxAaCPth4RukPv8Dn
	 7ERMMmJ7FtXMcOW3a+ALuePLyu6bUzG+7bHKLEJ7b3srpR0iWeBapmH9pXrrqas2eQVSB
	 vxtVMWoGXjQMOlIE5eFCOfbd6lcZxVND6sVjHsRGGfu7oxgRho46zFVTZ/V8R0vStTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794438824;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=d0oLmoHltHpv+jhhl+Ta8LiuvtzIB/qkVEpKzt55/5k=;
	b=z6vhz/1/CQ7Y0d2qcI0WuOcg6mTXXG6fyP75s+uEv8Q7HtxLG+NFE5lhV6fLZzMhfPrh
	 O6KEjmcXvkqwQl0GVoNCw5PA4FRqDuELM0xYE/pXnwx8b/QZTWwuMA+EpfRiQ3oZx87Cy
	 sf1OfycwNq6njrwR9UEiHQc5DrwJJ5Cgh5hXiTmmP0Q71CkLTglFGT6gwrGL+boQZ8Ip8
	 K/EashFVx+brobc6cWtdLTpQ/aSi9qiHenBNa6L2rEqYpCi6ld+bYNdx2AuTN9CLuiEk6
	 z7z8t8gwnhcUkoXVNjJ2a+7cdBQfePuRNDl/BdnQxNhPk90YkltCV7hUtIfgOxTgDLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aB84wEuj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56229606A335
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 23:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aB84wEuj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6C31F00A05;
	Wed, 11 Nov 2026 23:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794438824;
	bh=d0oLmoHltHpv+jhhl+Ta8LiuvtzIB/qkVEpKzt55/5k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aB84wEujHHcJ656vv0OahT+Cc6zU12/6wxlfVLnDEbhzR94DXUrWmL1LMBV+Ud2dq
	 W+cg+1T2VsO6Kmy3wBFV0Y7TDp+L+he6DPwUpFOJ8LNJydm3RNWBJie70kb9sT3uFe
	 Y0Ty9ZXmDDXcw4jiKro2XlrNo5ALJoZcXrwUCwG3wpwIZiLads4qaQNLRiz6suAEv3
	 93dEp2lE/H+XA3kUgIb21uj8a2PzwS/864xNttx/zf8SKdSZI9HpeT+jIWr/uV/kmw
	 k/3AHIQxSqmZlxhHDqeGV25boYD5xfotBzpdMvVQHmSV9qEH6s2XLDcKZ2m0/Ep0Ju
	 Sg7pdMAvV358Q==
Message-ID: <sashiko-outbox-209849@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 5/5] net/mlx4: flush pending doorbell when
 dropping a TX skb
Reply-To: sashiko-reviews@lists.linux.dev
To: "Joe Damato" <joe@dama.to>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110231304.1859217-6-joe@dama.to>
References: <20261110231304.1859217-1-joe@dama.to>
 <20261110231304.1859217-6-joe@dama.to>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 23:13:43 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> If mlx4_en_xmit drops an skb (for example because DMA mapping fails) and
> that skb happens to be the last one in the batch, the doorbell for the
> WQEs posted earlier in the batch isn't written.
>=20
> The queue stays awake, though, so those WQEs are eventually announced to
> the HW after the next TX, but that depends on traffic and could induce
> latency.
>=20
> Avoid all of that by writing the pending doorbell in the drop path.
>=20
> Signed-off-by: Joe Damato <joe@dama.to>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110231304.1859=
217-1-joe@dama.to?part=3D5

