Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794438824;
	b=VU5WwdPqS/DGwjuA2hMEFv6I+64sGqtZdgycl1s2wPypKl/T9qZjh1hwlHQAHVc5NWMH
	 gYoWmEqBi6l+JEJ4lpdhBnhR9OKEts113js/sOAgs1Xqsz0rHrviiKBeqkh8F0X7VeNy3
	 DpaYAn4DRpa8I6Lr0m1aOC8KZxljPGoU3JILBNNM8eAUWPB13q4I/dH1Gd5hJVzxRp0Fs
	 VYKwxxl+UB279tPVdlihKYuYu1Qq9kxRlfgtp4J1AVJFzrrf94PoCiMEkf5MWmwAUW3ZM
	 Ecm9v9pO9Al1kYcdUB7EplHgXHKn5XVfj2eREfyA42IVH5PVtEXl27NPoJrUprnvKzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794438824;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=zu6vlMUX21rjziSW6KC5ShGkA/KHuIILlnAqOhGw7Q4=;
	b=Yu2yK71aTTMLr5ZKG5Os7zzfQ6uVFFlWE2ou03iF40F2eTDPBE8MtDxKKUUHhLoS5nGZ
	 ab1g+wcDBOJyNzqu4O1Jm4BmmXK8DhOgKG7ZJqcSFFhrjiRSydEoAYsnhVjvphUwq4oYW
	 kSE4y0JOKWpITUd/GvcJm+4t4x7+vozv3YJYZqyN977jCvBkQE6tdT/gATq2x3+vB5QPC
	 0dduEEvXrwjprBoxxYaVx3QzxuKjQFsRC3S1K75DsPxOD/eQlRbswwYzUvpiR2uSjwnt/
	 itE+7LRi/bZBSZSs+I7uw93km2HcAOXY1BjoFBfrMncmaOEkLoIjUsScCAr46dRNxaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P3dJakYZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45FC606A321
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 23:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P3dJakYZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC761F00A06;
	Wed, 11 Nov 2026 23:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794438823;
	bh=zu6vlMUX21rjziSW6KC5ShGkA/KHuIILlnAqOhGw7Q4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P3dJakYZxew3KLmF08xscqhfpVyj4daV2e3GUYxuflaYs5+tZsjjdzTsitk60aFKi
	 VVBn5+0ALp/NsUntpMn74A+mmx8LqmBqaxD3LdLQ16IxEAwU3HDyRsFGl3GObI/WX9
	 7Ps8aoN2PChSprXz/f/eDL5+Bb1tOZIIN1ipFKFEVdtWQZ9w2PAescYHWrYYaqgPje
	 4XKhBDVhIGj3F4SUpICpOs9MBZNH7nvUbVrhAVPsJcHsKqjRqzmqOHCeyrVEUl1uhj
	 4dKKl13oGRlPIXmReeVH6XQZsNa2fdzn6QEjzQAE9syXN2VS8RpyE33yi8NPdnsVAp
	 ndVm1go95IXmw==
Message-ID: <sashiko-outbox-209848@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 4/5] net/mlx4: track whether a TX doorbell is
 pending
Reply-To: sashiko-reviews@lists.linux.dev
To: "Joe Damato" <joe@dama.to>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110231304.1859217-5-joe@dama.to>
References: <20261110231304.1859217-1-joe@dama.to>
 <20261110231304.1859217-5-joe@dama.to>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] net/mlx4: doorbell_pending placed in read-mostly cacheline of
  mlx4_en_tx_ring
--

commit c4a2c0626cb72780e7edec3e4335fdf04dad4de9
Author: Joe Damato <joe@dama.to>

net/mlx4: track whether a TX doorbell is pending

This commit adds a doorbell_pending flag to struct mlx4_en_tx_ring to track
when a TX doorbell write has been deferred due to xmit_more.

> diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/e=
thernet/mellanox/mlx4/mlx4_en.h
> index aab97694f86b3..601c09020f380 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> +++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> @@ -281,6 +281,7 @@ struct mlx4_en_tx_ring {
>  	unsigned long		tso_packets;
>  	unsigned long		xmit_more;
>  	struct mlx4_bf		bf;
> +	bool			doorbell_pending;
> =20
>  	/* Following part should be mostly read */
>  	void __iomem		*doorbell_address;

[Severity: Low]
Does placing doorbell_pending after struct mlx4_bf put a per-packet written
field into the read-mostly cacheline of struct mlx4_en_tx_ring?

On 64-bit SMP builds, the TX producer cacheline starting at prod (offset
0x40) is filled through bf.uar, while the read-only bf.reg pointer starts
the next cacheline at offset 0x80 alongside doorbell_address, size_mask,
buf, and tx_info, as arranged by commit e3f42f845390 ("mlx4: reorganize
struct mlx4_en_tx_ring").

Because mlx4_en_tx_write_desc() and mlx4_en_xmit_doorbell() write
doorbell_pending on every packet, placing it at offset 0x88 dirties that
read-mostly cacheline on every TX packet, causing false sharing with TX
completion polling in mlx4_en_process_tx_cq().  The 7 bytes of alignment
padding before doorbell_address also push bf_enabled and hwtstamp_tx_type
into a third cacheline.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110231304.1859=
217-1-joe@dama.to?part=3D4
