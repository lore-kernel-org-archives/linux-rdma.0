Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793531599;
	b=ND4csk9sayOlNeHBqJNKPDYEbXw14wCP6zHpSxva4ZX1toPkhAd9xLzqPNW1UTnGyoad
	 ls9nekbR0PPmBC+6GCAjEB7ZI+SIzCkoJNBazl5eD/RW9j5xTt20ShwZNXkqVbNp4gvQa
	 z/wjzaVxaNGK5WfkU/QLki0/rP3Lwy62t1/pezX1wnRNAJHbhrOYIZ0Gbjg9YKViH5K7j
	 JUcYv9MbccehwAPJ/6VEDBsmf0lUin5UkjKHEXCfuSq4hmNR4gMRE7L2hzBrl5+E+KiG+
	 Rd4JO7yfiUvl9gj2nmanzIPssE54xvEuoOivKVdVGnWh/DfMrWbe/kuzGMlCWFzoH3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793531599;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=WRGy3L+Y8UdxMVtO+wEhpi3G0JU+wQ/hWKbFIlJam34=;
	b=x8Jyg7fQejSRX8K8IwVJCpKt2uxqSMOO3iXXzrtwDPNSEej776S/7XkGVlbmlWvunUNs
	 1p7OIUibfJmcdno883F7iS600pWPgp++BqPCrHecm+aYjw7dzUX9qGLrkoh8g52NECGKA
	 WThsrWp0vQgGeAv2/+3sCoO3arwNdX0GKkrqageFMW21icaUUfl4C0/XwyAp6Xy+oK9NX
	 KlJI7y/rnnHy9AnhBPXT1oZIKc/yKLEKPN9+OhcIMwW1YIJKZIltO8DiMPifqNP0vrQFn
	 z2PWej4EQXC2Se9FMTCoWSE5UgaG9rY/DaWpijsiw2qsSROMFxpTHrMPCvqu+SzSKIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IrE7oLpP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD333606A324
	for <linux-rdma@vger.kernel.org>; Sun,  1 Nov 2026 11:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IrE7oLpP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EBB41F000C1;
	Sun,  1 Nov 2026 11:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793531598;
	bh=WRGy3L+Y8UdxMVtO+wEhpi3G0JU+wQ/hWKbFIlJam34=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IrE7oLpPFeMokSXpNiSdwBztefyt0ni83dClVXip0kQgbqtTeUqdNR6+bOkymkdxu
	 KThqswuq7dnuYbgaiF8+p1lydNk+qpv9QIAM40buaNVN4uH31LJCrJMUGvidW69pc2
	 ELRUzeK9/NWsw13bdIVRSUmO6Ae8mmlPCLjAaXtsqqOj5Jw5O0U0DfuUNZQH9dvPVH
	 yEaROSh6PI5gdohXm7fPWo9i8myOMeBVdSFv0GJ7esMUqqGG5TwCpt4ALM0OjOAvVM
	 AQCcqkjmT+gICAQ6I5v5QQZBRhousanGh5tRCU8gBkoqLWlIawNzEaqqW0LRhYkWx1
	 MHsfw7+6oq1Jg==
Message-ID: <sashiko-outbox-192379@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/cma: Don't warn when device removal races with
 rdma_resolve_addr()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Deepanshu Kartikey" <kartikey406@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261101105615.20253-1-kartikey406@gmail.com>
References: <20261101105615.20253-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 01 Nov 2026 11:13:17 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] RDMA/cma: missing comment in resolve_prepare_src() promised by comm=
it message
--

commit b9b0fc41a9bfe112cf7965b88795f6ea037bc2e0
Author: Deepanshu Kartikey <kartikey406@gmail.com>

RDMA/cma: Don't warn when device removal races with rdma_resolve_addr()

This commit removes the WARN_ON() in resolve_prepare_src() when
transitioning an RDMA CM ID from RDMA_CM_ADDR_BOUND to RDMA_CM_ADDR_QUERY
after cma_bind_addr(), as a concurrent device removal can legitimately
change the state to RDMA_CM_DEVICE_REMOVAL.

>     Drop the WARN_ON() and keep returning -EINVAL, and document in a comm=
ent
>     that the state may change because of device removal.

[ ... ]

> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 337a49d1acf72..a30f367753241 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -4117,8 +4117,8 @@ static int resolve_prepare_src(struct rdma_id_priva=
te *id_priv,
>  		ret =3D cma_bind_addr(&id_priv->id, src_addr, dst_addr);
>  		if (ret)
>  			return ret;
> -		if (WARN_ON(!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND,
> -					   RDMA_CM_ADDR_QUERY)))
> +		if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND,
> +				   RDMA_CM_ADDR_QUERY))
>  			return -EINVAL;

[Severity: Low]
This isn't a bug, but the commit message mentions documenting in a comment
that the state may change because of device removal, whereas the diff in
resolve_prepare_src() in drivers/infiniband/core/cma.c only removes the
WARN_ON() around cma_comp_exch(). Was that comment accidentally left out of
the patch, or should the commit message be updated?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261101105615.2025=
3-1-kartikey406@gmail.com?part=3D1
