Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADD5568FDD
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 18:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792003453; cv=none; b=GQ4pa7XmEVA3wLn3MVAg7C4pi9W+/oMTmWlFt+cmSUTS1d9jTy5Om6OQ2rfmJ6sgsJeAPsP7KywT+3Yco9YYydbUolIVMa+wzya9nR6S6yC4kfI+wmGeks2V75MgSqrec5iRQsLlmOTPws13vSsAv+B/X0Ixv+wGBnZ/V+gWSLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792003453; c=relaxed/simple;
	bh=eYUdmv9Uve10hZ71+5BIh7v9ak80fOj1FDMYfyy3cLk=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=eztHoL7DIr8TT7SM4Q+pbTlcp3SvnsLFLcmLBS0BKs78kGAVR9obGT8rgFM10uCodyOmjm/+nqXWop9opROEzG6virgjVazYAAfiQ+6/h+BVs/vsHOq9uP5rXR0Ln/dh202mw4Sdrs93QJtATjYDi1I6KTWYWrqKNYo/2eG/hYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wn4hUxH9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wn4hUxH9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A731F000C9;
	Wed, 14 Oct 2026 18:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792003452;
	bh=eYUdmv9Uve10hZ71+5BIh7v9ak80fOj1FDMYfyy3cLk=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Wn4hUxH9myVc5ukV15jWdkWIlfsy34zOmWkd+DQtPcGfws5ukPSTfQtNg/GEYvMp9
	 7Xew1ISs0KmTmyK9WRLrXGkyYtYadBnkUpkrBRN3LZwJZ4o/9sj1UrA2a5S6/Qx2GL
	 YpvvO4SMzCo/1Q4FlhEiD8mAVcn8wH1+aCw/CEkHw6mcdGoex+YFMJSDB3bOPUG1Rw
	 r9HyuFlsLscy7A8JVTq9VKK6H6lrUiNky+PgCqQR2s+OMiZUUlhZnuewDSm062Lzkz
	 f8yef0ctA5VUnXLCVnT2FcS/+opJgnnvd61xKwyMMWlG9jIeb3pDYzVBfFw7VwqF2H
	 96+PlBBr/WuvQ==
Message-ID: <sashiko-outbox-171729@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 6/6] net: kunit: test netmem, page_pool, and
 skb frag refcounting
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261014173945.373295-7-almasrymina@google.com>
References: <20261014173945.373295-1-almasrymina@google.com>
 <20261014173945.373295-7-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 18:44:12 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Verify that non-pp (page._refcount / binding->ref) and page_pool
> (pp_ref_count) references stay balanced without cross-counter leaks or
> underflows across regular pages, page_pool pages, non-pp net_iovs, and
> page_pool net_iovs with both pp_recycle=3D0 and pp_recycle=3D1.
>=20
> Cover get/put_net_iov(), get/put_netmem(), napi_pp_get/put_page(),
> skb_netmem_ref/unref(), skb_frag_ref/unref(), pskb_copy(),
> skb_zerocopy(), skb_shift(), skb_split(), skb_try_coalesce(),
> skb_release_data() (clones, unclone ordering, pskb_extract(), and
> skb_morph()), skb_segment(), and devmem tcp_recvmsg_dmabuf() /
> SO_DEVMEM_DONTNEED.
>=20
> Export skb_shift() via EXPORT_SYMBOL_IF_KUNIT() so the test links when
> built as a module (CONFIG_NET_TEST=3Dm).
>=20
> Assisted-by: LLM
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014173945.3732=
95-1-almasrymina@google.com?part=3D6

