Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CB7384CE5
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 08:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879735; cv=none; b=o4PrHHb9QmcaUkilOL5cHKD9h03S1hnGPwk63ouljhA0KEKAULMY/GdeJ09G9ATCPNYQ3ivbBX16T14XbA6XYlxgjro5zZtxJm+Jfcgg3SFN4hP6hu475lA+eXF8eNM5BRbGPr85b/EsOFM5I/t91N68kNz6g+F3U05UCtWj6X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879735; c=relaxed/simple;
	bh=MuF8scdArSeE+ajqkntz75JHgOw46zNNK+gnOLPBPDo=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=MtYKV/aUpuk+CRfr8yX/aWJGMRie8F7DD1N6At4vW3V2abhjqIz3ZRDb57NzLiMBjPRSgHTP7xxZEcVkukMMvW3g2eSj+JrPGSMsTJMzFZvmbxIkzxhsNq/gMnkfbjE4TGpD7YVJvZDbylyOWA8VZaIm7g9r9bwA9v9n/I0D4CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L0ZkwuOq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L0ZkwuOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF041F000FF;
	Tue, 13 Oct 2026 08:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791879734;
	bh=SGJn5vuwlVMiJsIu31Won9qkddqB7F4jr9ynP8MNm2k=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=L0ZkwuOq06FR3fQvB0si9k+fQAftC25BRxCzB4aQmXUfwY105oj7dHyRtszDWPQtN
	 KWWQgbKvlPHC6aUCoU5YUCp5LHlPAhVEUIdOCVtI8at8M2vT85UTlU8aC/7Akp3ntf
	 CQeIxL4UnsNgZ22ccj3WgcPqL5pMNOnO+KFHcKU+S3uwYqXDTI9y7lDo4BeyUYUqPX
	 pKc2p66Io/oSaP3uklr0AP3yb6ubgq2rDh3eVgakTEA93db0hymvAT6Pjf5K3wJL7r
	 nC11fl1KI+WtaHi5Tyb7U29IrezQgJfBRE7F0f8fcwGaL/uOS4HVvDDveoUIhR1AMz
	 JX/aOTg+A+tSg==
Message-ID: <sashiko-outbox-169238@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 4/6] net: skbuff: replace __skb_frag_ref()
 with symmetric skb_netmem_ref()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261012082148.1698596-5-almasrymina@google.com>
References: <20261012082148.1698596-1-almasrymina@google.com>
 <20261012082148.1698596-5-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 08:22:13 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012082148.1698=
596-1-almasrymina@google.com?part=3D4

