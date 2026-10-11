Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84264078EC;
	Sun, 11 Oct 2026 08:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791707996; cv=none; b=iNil8zzT2Xth9FkWzMX521kMB8mu/+HzBjMgTi2aNaICo+u0ilITGvdwpWg1tnO4rHu1MdS0GzTjEwZAIrE8YE4E61U7Vamj0bmAxnaEoPJ8H6d9YWPfACxqgPbtscbUCmOtiOzd2TwuWb773V564YbKJDc0ZHjdDuRKiqrxaDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791707996; c=relaxed/simple;
	bh=/Zl0sGOGJgCuT8Nh6lD51KhPhNoEmzAu01QY9NQyRYY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=NQ0y6WKBkDPIK+SOkaPxa1XlL9qcE9dlZA/RwfuBMfQfPYIElFNpw3oGaMQVOdyfaUudBfuMCgWYiZIq5tJ7Kolz2L6X7SyabfTiL7ED154frK2jJryX5I97zQhMF2Ye/FTImloR8ihTIN8k+FmNQnaGKo5JmL/akY+zZ5tTAQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ROVi5oz/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ROVi5oz/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E76A1F0089B;
	Sun, 11 Oct 2026 08:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791707995;
	bh=PpDBCkRoI9ma0sf9Y6Z82nl/Z17PRcGwJFvkWtm/GHU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ROVi5oz/jsio8Zhp3tqk+q7b7QuoHq8746ae1Rr7eJFQ/mDmGHi58S6YUFyOvSmWv
	 1xIfvtlFHm70daLb8q+DQ3EsdSSY36nxU2PqF8TO4bcbjGDr6lVtFnpG/Wnm0nJKxs
	 Phe3vV0qvVmq/Tqcj/zI4rh3K7ORPGGztsLJDLfq9oVeq+A+HI5G21+/OzHAgp5VP/
	 5rVggf9TuKwnEaB7+kMH83RMT1OUAJxSYge34LXMjPP4tudtQG4mRxv3pMILAGF8kw
	 CCjVTt5QjmpEjEHb0IvdAhuO23310LxSIeO8T5c3uFNdiieKc3peyGevHKMHa99Pm9
	 m6rslQFVMIs9g==
Message-ID: <sashiko-outbox-167127@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 3/6] net: skbuff: replace skb_page_unref()
 and __skb_frag_unref() with skb_netmem_unref()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>
Cc: linux-rdma@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <20261010083935.3274178-4-almasrymina@google.com>
References: <20261010083935.3274178-1-almasrymina@google.com>
 <20261010083935.3274178-4-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 11 Oct 2026 08:39:55 +0000
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
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261010083935.3274=
178-1-almasrymina@google.com?part=3D3

