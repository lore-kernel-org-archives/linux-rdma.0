Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38733432BD9
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 05:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790141419; cv=none; b=ErTPm0UTPF0RQtv378mLKFzfJ9PSFX6y2wORXI0WrLwu5o6I+cPyhvN49SCpS7cjvIcEaAxFyrx9vde6XEtS1umu5JLrSFDw7+UmKgU0IcWwcQ7mCGOAX/KhHLv60brQoFhF81Y5Oz4XOl+n7HIdpIwNqbGqYCtsBbUHkQv2EWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790141419; c=relaxed/simple;
	bh=nb+Q7c8hqZvnXpVBLCulgFF910HRQzqe2WoD2oeKgf4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=h1DIZJINqFDXWD4o+VFTNQ0elcVQQJSFY7lCeyA7NVhuoloSE9M2eqEwExe/TXLFG0tupAw3VhpNw2b/327cTwvXvFRJcrhnobvgPxsa3ZnwDpr3vXndlaSHBmsjxnltAgrPMjRqcbc8RLaVCt+J/MrO5yavqBrTyLKN8Mjw3v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lOVo1YWf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lOVo1YWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986ED1F000FF;
	Wed, 23 Sep 2026 05:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790141417;
	bh=ZUrBQ+TeJR4JUhSm2qFqroSx3u8Hf2AfgvlbEgItxgA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lOVo1YWfAqLAkMYocC/uLo6ea2JWXmACJwdZskBgCo+WIzFw4TEfar/rcZqdK/P1U
	 I8BVdzwMPhyZDCNvTvM2h1KTgzFXl/tCyJ+VuQGH3sCnv6YAKSHGx7R5api3maD2j4
	 WScOsZuqHjRurGMipGXvC80NeKMMMtJlGmFFvPVX55ouxa+MvVCrYNZnb4ToI7DiE+
	 9vO7JkorQdul0dCyw0/8np61zl7Q/vp1I4rK3LJ3BKZLFy/UUPcK6RYKv19TswZcxf
	 kI4M4sug2O135qSWxVCA29MkzqIJqMNiXWSp44Yu4ullNw/x3RJ+RchMuUeNxCgBPb
	 RTiImzFwIoSoQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1] RDMA/rxe: unpublish the per-net tunnel socket before
Reply-To: sashiko-reviews@lists.linux.dev
To: "Binbin Deng" <18983559317@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260923051800.244740-1-18983559317@163.com>
References: <20260923051800.244740-1-18983559317@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 05:30:17 +0000
Message-Id: <20260923053017.986ED1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> KASAN reports a slab-use-after-free in ip6_route_output_flags()
> reached from rxe_find_route(), with the free in __sk_destruct() after
> rxe_sock_put(), and a user with CAP_NET_ADMIN can remove the device with
> "rdma link del rxe0" while RoCE v2 over IPv6 traffic keeps looking the
> socket up.
>=20
> BUG: KASAN: slab-use-after-free in ip6_route_output_flags+0x300/0x360
> Read of size 4 at addr ffff888115ddd794 by task kworker/u32:6/309
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x53/0x70
>  print_report+0xd0/0x630
>  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
>  ? ip6_route_output_flags+0x300/0x360
>  kasan_report+0xce/0x100
> [ ... ]
>=20
> Fix by clearing the per-net pointer before the last reference is dropped.
>=20
> Fixes: f1327abd6abed ("RDMA/rxe: Support RDMA link creation and destructi=
on per net namespace")
> Signed-off-by: Binbin Deng <18983559317@163.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923051800.2447=
40-1-18983559317@163.com?part=3D1

