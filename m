Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8497040926E;
	Sun, 11 Oct 2026 08:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791707997; cv=none; b=H4WRI+knr+2SmYoHsDWTKee80AhryA1LzeBCi4AmH4KkuYl+ZA0MmdbImqcqojjd8vHZtg06VcadhmVLQyxvwQlkZR9swQeM9EFoSUvBeVgO88NqN1ylAuI6gK0qsC+ylV6dn2ZME2nvNeYYpfsePYPNghbNkHPrMAOQxYJrnLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791707997; c=relaxed/simple;
	bh=uacxaQUVKKA17+ct7siUkoazZmSYfG3IWOpzRG7qljw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=r/L8czyiTlT8/gtsVR1DhcePKDAwvTIUKZhREEvYvKxrewfB3B/nDTtbUKIeVmU/ZkEeOrRKFl7cQl064kC8u/+10WmBi2CAtxni3QSpTLfZcLtcA4Nezd1a85wvXSuXG2M1+wt02uJIEP74oGRYl80bUCylwWkr5mcf0iWBXo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YrUuuwv2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YrUuuwv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C181F0089C;
	Sun, 11 Oct 2026 08:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791707996;
	bh=dsFWkHM3o69qYz/IN3NirQPwn7L0BIvuMDz3GtZXvwg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YrUuuwv2BCo+LXmjScfG4mc0sL3Kl4GFnR1MaEmz5O9epvGRDkzzQ72UCN5jMvVmN
	 nRimQL7r6I4pxahb8G0JCXFMaHqVwoAmR/LOe+RuoGchi/8ZMq/zD8Ruf2KvODtVT0
	 kvA96REatoQlnkRdsL5KHOd8mCPD0sYnK8DC9wO24JvzgXIRoAg/Bmo5BnWDnsEqzk
	 vYeotw4G/oQ1jObu1NJHOvshYKoB7/abOL4vc17AE4M69Ek5eYJVBdemCWxKEtV99h
	 jfPz/HDLo6BOJ7oGBf4WYTPr6I0gvgmlFaNxH36pGBu4xR6yPNjWTvL8dn0PnIjOcX
	 wedgviO9yHeQA==
Message-ID: <sashiko-outbox-167128@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 4/6] net: skbuff: replace __skb_frag_ref()
 with symmetric skb_netmem_ref()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>
Cc: linux-rdma@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <20261010083935.3274178-5-almasrymina@google.com>
References: <20261010083935.3274178-1-almasrymina@google.com>
 <20261010083935.3274178-5-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 11 Oct 2026 08:39:55 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Previously, __skb_frag_ref() and skb_frag_ref() unconditionally
> incremented the non-pp backing refcount via get_netmem(), while
> skb_frag_unref() decremented pp_ref_count whenever skb->pp_recycle was
> set. Ref-ing a page_pool fragment into a pp_recycle=3D1 SKB (or clearing
> pp_recycle=3D0 on an uncloned SKB while clones still held pp_recycle=3D1)
> leaked the backing non-pp refcount and underflowed pp_ref_count across
> IP-TFS, skb_split(), skb_shift(), and cloned unclone paths.
>=20
> Replace __skb_frag_ref() with skb_netmem_ref(netmem, recycle) as the
> exact counterpart to skb_netmem_unref(netmem, recycle):
>=20
> - Keep skb->pp_recycle intact in skb_release_data() so uncloning paths
>   (pskb_expand_head() and pskb_carve_inside_{header,nonlinear}()) keep
>   trading pp_ref_count references symmetrically across clones.
> - Propagate pp_recycle and call skb_frag_ref() on the destination SKB in
>   __pskb_copy_fclone(), skb_zerocopy(), skb_split(), skb_shift(), and
>   skb_segment().
> - Use skb_frag_ref() in xfrm_iptfs, chcr_ktls, and cassini, and call
>   get_netmem() directly in veth and tls_device_fallback where callers
>   explicitly take a raw non-pp reference.
>=20
> Cc: Stanislav Fomichev <sdf@fomichev.me>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Jesper Dangaard Brouer <hawk@kernel.org>
> Cc: bpf@vger.kernel.org
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261010083935.3274=
178-1-almasrymina@google.com?part=3D4

