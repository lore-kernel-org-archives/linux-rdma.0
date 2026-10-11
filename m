Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E8740B112;
	Sun, 11 Oct 2026 08:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791707999; cv=none; b=rkcaCsIBbg7Y+lsEf3LVLZ98eopvpnlJ4YAIN8M7IK4kiw7qBB0OFplD7TukvlT8t9bI8uO/M2uSQcXPdDczd5/ZlWgnHJdQ95FCz6Wz5bVVNQUnrg01+ZpoS7osk6m/Xhg6EqT+1dj43aZjPmkxkF5jikU8jRAzR0nlzGzf6m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791707999; c=relaxed/simple;
	bh=Oe7Oh/VCZxTutAfp/c7xiHbqhTEUPrhIFxriuIAXwyY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=PZye8e5drXl62PPyZ+HlZeBlet6lTLfYCtQTfdqIdWnAOvEogz98DiLF+psh66QWjO5MjxR9KnYZCjP2sD/N0bsZpq+NoYGGGHdocrl7f96mbJ/k0j0yy6+2aemGVvmLi9hNforRrPeOm7xjeCMeC1+nlfwGqijOCwDFRiQgZD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sy3f1hg/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sy3f1hg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A773A1F0089C;
	Sun, 11 Oct 2026 08:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791707997;
	bh=zm3FWve671G8sGn/zrJVT49cqts98GwQP908ydifGLY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Sy3f1hg/qoASBvlFKKKmgt2YJ1IFdU+FjRuNXqt3V+JfLDcxu8NryD/uHPgZvy1xZ
	 y13TePVHIWG9mzZEQ6o07C8Arf1xXrBUw2NxaplPb5aideAdkTPyzMx3AskNMgbQhT
	 2scgcfBbI1amMZXk7D9NJ+OSpYRYxkwK9s8f3ibgnmJfnsY1TqohEWdeJw9CZac6h3
	 Xs6zIKNL8ef7HF87qqWgEUD7sEOq3du75+sx60JiAUhxJzOQjcSUgswG//J7JeFrSa
	 AdWyMCVLNuiKTY0nccRnMHDhaeG+jfyKwLRuttliOm1VS7yE+Q5ordVN5JR4NnCg1U
	 K43pJSv8uRMVg==
Message-ID: <sashiko-outbox-167130@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 6/6] net: kunit: test netmem, page_pool, and
 skb frag refcounting
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>
Cc: bpf@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261010083935.3274178-7-almasrymina@google.com>
References: <20261010083935.3274178-1-almasrymina@google.com>
 <20261010083935.3274178-7-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 11 Oct 2026 08:39:57 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] test: uninitialized mac_header causes out-of-bounds memcpy in skb_=
segment
- [Low] test: unchecked skb_clone allocation failure causes NULL pointer de=
reference
--

commit ab0c57271e2a8950e7df2bcb1c3668cf67f6f94b
Author: Mina Almasry <almasrymina@google.com>

net: kunit: test netmem, page_pool, and skb frag refcounting

Verify that non-pp (page._refcount / binding->ref) and page_pool
(pp_ref_count) references stay balanced without cross-counter leaks or
underflows across regular pages, page_pool pages, non-pp net_iovs, and
page_pool net_iovs with both pp_recycle=3D0 and pp_recycle=3D1.

> diff --git a/net/core/net_test.c b/net/core/net_test.c
> index 9c3a590865d26..f9f50f9159902 100644
> --- a/net/core/net_test.c
> +++ b/net/core/net_test.c

[ ... ]

> @@ -370,10 +370,757 @@ static void ip_tunnel_flags_test_run(struct kunit =
*test)

[ ... ]

> +	/* skb_segment on pp_recycle=3D1 skb propagates pp_recycle to segments =
*/
> +	skb->protocol =3D htons(ETH_P_IP);
> +	skb_reset_network_header(skb);
> +	skb_shinfo(skb)->gso_size =3D 16;
> +	split =3D skb_segment(skb, NETIF_F_SG | NETIF_F_HW_CSUM);
> +	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(split));

[Severity: High]
Can this missing MAC header reset cause a massive out-of-bounds memcpy?

Without calling skb_reset_mac_header(), the mac_header defaults to an
uninitialized value of ~0U (65535). Inside skb_segment(), this creates a
massive negative offset when calculating doffset, leading to a 64KB
out-of-bounds read via skb_copy_from_linear_data_offset() that will likely
crash the test with a kernel panic.

[ ... ]

> +	page_pool_ref_netmem(netmem);
> +	clone1 =3D skb_clone(skb, GFP_KERNEL);
> +	clone2 =3D skb_clone(clone1, GFP_KERNEL);
> +	KUNIT_ASSERT_NOT_NULL(test, clone1);
> +	KUNIT_ASSERT_NOT_NULL(test, clone2);

[Severity: Low]
Does this code dereference a potential NULL pointer if memory allocation fa=
ils?

If the first skb_clone() returns NULL for clone1 under memory pressure, it
is immediately passed to the second skb_clone(clone1, GFP_KERNEL). Because
skb_clone() dereferences its first argument unconditionally, this causes a
kernel panic before the test has a chance to safely fail at the subsequent
KUNIT_ASSERT_NOT_NULL() check.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261010083935.3274=
178-1-almasrymina@google.com?part=3D6
