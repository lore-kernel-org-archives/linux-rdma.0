Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD163563295
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 18:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792003452; cv=none; b=AtBNNQZWqUbt6q1alcvzlU1e0lg8kH0sdz0CkI9mF0qP0JowMFu4QO2KcGaXFf2qFF9nJVI3ukkau+aYkJgYXBYX0mwG0m28m30ei/08c0IwcGCm9+Ba2+ZgYdwYITmHQhgipwfRvDP0uydkGI56dldQh7y+g2CSt/I/ZKQI0b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792003452; c=relaxed/simple;
	bh=6s7dzmJKuFg1XuJVLGiOby0JA1y6uNIlHrO7jIRImLs=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=iLoQPoUN1VD+jZwTBKS/ebC6n0fhuEEALgIQH6D5urSbHXJIvfVwAUtUTIOsHI7z0XKgcB2se1ScYZDiZsUUodUdnXGpJxcbpk97di5yqFXAMYf2et/Ov2Agd8W45x+XQ5T4I80SImSwVbBqkHLSqe2Z/hLTx3VnPjH6PgGq2lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bd/s5c9I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bd/s5c9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E281F000C6;
	Wed, 14 Oct 2026 18:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792003451;
	bh=os5CB4aEsFg2BAd7wPwEkEPieZaJF591AskB9HKY5mo=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Bd/s5c9IXDUcqiJefCngHwel29RoGaO4BQinLZ3QVKDTGr3rHJPyy/gn9tJlHgJEw
	 QdYFQ6MgZnOoLTNPsPeZnGrixCicKxq0UI5m/7e/S/tqtjo0JWbeGUsIL01ue4EPPX
	 V27UsO9N5V7XHq5sSGxaXwdDTlvO9gJbyKVJIIBt495NF9Sbbk7V8ihCARY5Vc3JMj
	 dOH98gOFNz9ooUs7T+fieg1V6Pqod2U31hSos6xE+x6Q2+YlEXHzL/Sarj1kIUiTUH
	 ETMxZ2o+C8dRyidDaSwv03MwFhtRimV1Orumstc34YoePALeblixCqAB/ou2h2CO4e
	 duTX/qXyebzpw==
Message-ID: <sashiko-outbox-171726@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 3/6] net: skbuff: replace skb_page_unref()
 and __skb_frag_unref() with skb_netmem_unref()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261014173945.373295-4-almasrymina@google.com>
References: <20261014173945.373295-1-almasrymina@google.com>
 <20261014173945.373295-4-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 18:44:10 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014173945.3732=
95-1-almasrymina@google.com?part=3D3

