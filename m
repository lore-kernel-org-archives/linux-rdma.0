Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794140199;
	b=Y5rYzYmGOt0f4T1dYE5tbr4/Sry5Pw7LEfUezKb2RKuNKK24ME0Ov8zvx/HKK1Ax4bYD
	 3ZceHen5ruWZC9f9EbcOUGA5RmoLkHIzmktzyiEAVynVuzWhMlKcakRB2TryB/hqvzV2s
	 uSBA02ybfiCMsm9Ke5jn2d9Zjk6tukbO9GBDu4IuttIuKUWms76FHB8R2eFu4M1ts+Aa4
	 JlJZCccT+Yl3AbTt5Q/5DClrHrzcfEGb4HJ7dSFufQqCrVgWoK6hqPdeesPL74fRN7Mdg
	 T4ol0cOgcXzU3VI9KJwYJ+TFPAkeK3v/7/YgCnICKB4ZcgYTvw4JE4BtJ2OrdMFwTjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794140199;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qJ557ubguD7akLNuo6proHNeTF7lGLlV1QWeKnfH/N4=;
	b=eL2jTFiPIUFfRIy3FIcDnFdLdtxwL+CGQCQcVfaqgIr3dk0JcByC1HKTSHIj58Npcjtb
	 ktqjplL0i5i+PDBXfsvHpE+K9Ma6KuBp4AswFwisrISmZReWfQvsXWmWU7TsaM6ZKDNDq
	 8VczviWOTVHGwb+pk8azi7O4gV4ykoZ4x64OA0LgUW1lBK6lDxAisiqqx3JB6Nv53nS4D
	 UJDUzUCj320EjNVa7LeCC81jhJU29wLvhjTeTUDf6kfH0g4k7x626d0zxfrWmg1JvG/n2
	 qE2F5pdyy4LqZDAhJmQUyp4GTdaXWl6+p1mOLTqFLktA6r6VY6xQ4lKh85egjTHhVSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BVhyyxTF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF2F606A31C
	for <linux-rdma@vger.kernel.org>; Sun,  8 Nov 2026 12:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BVhyyxTF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8301F0089F;
	Sun,  8 Nov 2026 12:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794140199;
	bh=qJ557ubguD7akLNuo6proHNeTF7lGLlV1QWeKnfH/N4=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=BVhyyxTFUDGukz05IZSEX+q+j2MtfBPlNfYPnIoscjbU6pQMIy5ZkhfsRv6cjPtvf
	 /kQUWVjW8/Y17+gHLrfMNrjw8LseLavouDEbOnKorzgbGKxjOwAu7RpLXPG2fWhpXl
	 TGmOoBzG/s4eCQ8TfOMyoHScDVLAOHBU6FTr6wIdCRjpwsFBBQwwVCVxOZnGZsG89G
	 M+AeTLj5OcUyWJbzPWHWfOJbOYFyot0qsoXlyF1EYj6wJ+4Kufoulot3J7dJqRaupo
	 JrO2jw0F06QrKKgjLi3LQrrpWMu+Q0tQdzfSt2W805JSzqcSeXGHytJMrPq5oDwonH
	 xfMYDTpKnxlWw==
Message-ID: <sashiko-outbox-203707@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 2/2] nvmet-rdma: use a separate lockdep class for
 the listening cm_id
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?U2hpbidpY2hpcm8gS2F3YXNha2k=?= <shinichiro.kawasaki@wdc.com>, linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org
In-Reply-To: <20261108120154.148824-3-shinichiro.kawasaki@wdc.com>
References: <20261108120154.148824-1-shinichiro.kawasaki@wdc.com>
 <20261108120154.148824-3-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 12:16:38 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] nvmet-rdma: wildcard listener child cm_ids keep default lockdep
  class
--

commit a129fce174ee6d77cacc5458875c55e53aa41b7e
Author: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

nvmet-rdma: use a separate lockdep class for the listening cm_id

This commit calls rdma_reclassify_id_for_listen() on the port's listening
cm_id in nvmet_rdma_enable_port() to give its handler_mutex a separate
lockdep class from connected queue cm_ids.

Link: https://lore.kernel.org/linux-nvme/at36um4zrsfOr3kh@shinmob/

> diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
> index b9e39d1657d29..94f6d8edb517f 100644
> --- a/drivers/nvme/target/rdma.c
> +++ b/drivers/nvme/target/rdma.c
> @@ -1914,6 +1914,8 @@ static int nvmet_rdma_enable_port(struct nvmet_rdma=
_port *port)
>  		return PTR_ERR(cm_id);
>  	}
> =20
> +	rdma_reclassify_id_for_listen(cm_id);
> +
>  	/*
>  	 * Allow both IPv4 and IPv6 sockets to bind a single port
>  	 * at the same time.

[Severity: Low]
Does this still leave the per-device child listening cm_ids in the default
handler_mutex lockdep class when port->addr is a wildcard address?

For a wildcard address, rdma_bind_addr() leaves id_priv->cma_dev NULL, so
rdma_listen() calls cma_listen_on_all() -> cma_listen_on_dev(), which
creates a per-device child dev_id_priv via __rdma_create_id() without
reclassifying its handler_mutex:

drivers/infiniband/core/cma.c:cma_listen_on_dev() {
	...
	dev_id_priv =3D
		__rdma_create_id(net, cma_listen_handler, id_priv,
				 id_priv->id.ps, id_priv->id.qp_type, id_priv);
	...
}

When nvmet_rdma_disable_port() later calls rdma_destroy_id(cm_id) under
nvmet_config_sem, _cma_cancel_listens() calls
rdma_destroy_id(&dev_id_priv->id) and takes dev_id_priv->handler_mutex,
triggering the same false-positive lockdep warning.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108120154.1488=
24-1-shinichiro.kawasaki@wdc.com?part=3D2
