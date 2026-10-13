Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB41397338
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 08:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879732; cv=none; b=EiqYhkHoewUieN1H1lj6YgIos/k6qySmy9fhqTSXc2zQkfrNH8RIl2f2t8xIHNQE9cV7UaeR/2BHhMwczw3EjTCF0sS80XzfgHNltQOLSouzCLEWEBD5400kGn5fC9A6roe5UhwivIFrJG7UhblaLZdeCKi7GpTMqc8c7CpRj4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879732; c=relaxed/simple;
	bh=USC89mOKMJoV82k1jrf2pDwXVWGRiC8k2/LAZB1RWG0=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=klzfN8xQ/QjDbxcMvCznyDj5fDIil38L9x4xEOFfMYWN4qlDanXFJ9s+Ac2SHZOl/obK3BTqrVFkYjTp7jtPd2RTWdCkOJe2CH/8d/dSnRyT5ZAONGMg5ZynNexgnVWNeUHfDe+2Y46TyUL8SRa4HlJ4d3N1U9HEk7BKXlmz9hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KiNBMxzn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KiNBMxzn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A62561F00898;
	Tue, 13 Oct 2026 08:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791879731;
	bh=6nKbeMy0D0/2O2XdQWpvOhKaYXtQN47ru+McsDzoIp0=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=KiNBMxznSflZUFalkJJCHFUQ7Jxo10MZ4g8bu4j8K1ADmkuxcVrm0JnG9xprzPEEM
	 LIApeGotengXPXrgsq33nvblBuNgPyhMZst55//hMjp6m3oebN1Lp+fN9LUT9KfB6t
	 sEnLhw4xGHXSrpaC40N8SxdkZZo3jNpe9cGV7v2/wWokSX11iS7XUSLptA1AtzN6lm
	 1MpjErbXkIwnh2FLWNUsvuKoqj5XgRi0X8mKm2rvnzknQXQUV7/zV8JeqTLiUSAq83
	 a0IsjbyuDukpmzmTkwJ8oMkzkTlmFLzKqHIn5LjdpS2sZfnFrSKFYLSbuxSxlNK4c1
	 cRAg4OG/jOj2A==
Message-ID: <sashiko-outbox-169235@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 3/6] net: skbuff: replace skb_page_unref()
 and __skb_frag_unref() with skb_netmem_unref()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261012082148.1698596-4-almasrymina@google.com>
References: <20261012082148.1698596-1-almasrymina@google.com>
 <20261012082148.1698596-4-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 08:22:11 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Unreferencing a page_pool fragment with recycle=3Dfalse decrements the
> non-pp backing refcount instead of pp_ref_count, underflowing the page
> refcount when the fragment was owned via page_pool (as on mlx4's RX
> error path). Having both skb_page_unref() and __skb_frag_unref(frag,
> recycle) made it easy for callers to pass hardcoded recycle=3Dfalse on
> SKB-owned fragments.
>=20
> Replace skb_page_unref() and __skb_frag_unref() with
> skb_netmem_unref(netmem, recycle), which dispatches to
> napi_pp_put_page() when recycle is true and put_netmem() otherwise:
>=20
> - Use skb_frag_unref(skb, ...) on SKB-owned fragments in mlx4, sky2,
>   tls_strp, and skb_shift() so unrefs always match skb->pp_recycle.
> - Use put_netmem() directly in tls_device's destroy_record(), which
>   releases raw non-pp page references outside an SKB.
>=20
> Found by code inspection and confirmed with the KUnit tests added later
> in this series; not observed in production. The mlx4, sky2, and TLS
> call-site changes are compile-tested only.
>=20
> Assisted-by: LLM
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012082148.1698=
596-1-almasrymina@google.com?part=3D3

