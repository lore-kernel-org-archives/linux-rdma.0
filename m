Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD223568FDE
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 18:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792003452; cv=none; b=h+sSjwAfjqi7Ww8E6dxKKM8RpIW6acy74j7TybyJ70ybS0Ix3TIqTm4a7aKuownf4d5tm7NHkcCRJJrhJdI5O6GZcK8dMHNYFY5ieSJtvb2wTMwOk5mqHg/VkQTRrq/sqPxarRqWz4EpqyjgpHQznLfrQrP4sCeKGw2XMQcosZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792003452; c=relaxed/simple;
	bh=4UE9QsUC5AxreApwBbojC2h7UTjRZAzukaH+jkcTlrc=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=uK673pHZ+0eUE010o0svgf6GVisVVEuKbTKaqgriE3Sfk8v5/amujUWC5AnvsqegPwhpIldomdjKPK99NB6izb3dSNtnKo5sil6dQ4KblGOYtZM1w3Qq5JONaezAgO/WvJhVzL34jNlXLUXUkxIGChlBb3/Pz6cyghzKbLBuVf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oldOs7xP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oldOs7xP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB6F1F000C7;
	Wed, 14 Oct 2026 18:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792003451;
	bh=Nsc79lFYLRGMzt+YkJUklZjNTx88mJLNTfja+hwpJxE=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=oldOs7xPxOwRKX98s0xp/nU6vGid6Qg+hxAFNEO189gYcUDuLltfF2ESRsyw5kN6p
	 yFY3DzaBJpKkSKYJ/HW91aGFSsqJgPo1TnDn8zgPpkWNfRWJT3UP5XkmXJ3uMT/+WR
	 H4pNL4MHD3vseWgmuP3peWD+wywUDF9GPwxRUjC73NYMKpI3fs16/pthkdhUGr8vbe
	 +9d6/T89858ES2XV+VYYOMhPaRmd2ApXSijM2PKQ6KiUAiVNXyi1i2Su/vhOC+QMsN
	 m34Jo5zM8UrL0GgJzSOSqkWzXR+Tden/QkUCs0pRImhRibAR2M1zzxoK4Un9LxP+Cq
	 nDAEo6Ux3S1LQ==
Message-ID: <sashiko-outbox-171727@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 4/6] net: skbuff: replace __skb_frag_ref()
 with symmetric skb_netmem_ref()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261014173945.373295-5-almasrymina@google.com>
References: <20261014173945.373295-1-almasrymina@google.com>
 <20261014173945.373295-5-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 18:44:11 +0000
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
> [ ... ]
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Jesper Dangaard Brouer <hawk@kernel.org>
> Cc: bpf@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014173945.3732=
95-1-almasrymina@google.com?part=3D4

