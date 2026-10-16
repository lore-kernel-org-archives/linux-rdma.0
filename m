Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C113D093F
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 20:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792182713; cv=none; b=ohx8PLtghFd2Iq7XuTcbbsHvk+mp15BMGp4bxK/zn61By2EbROqKRx4l7ht3Duizi6rtIeHPPiB15wQEf8Dh0FUcLPgIrC9ckQ8zzKW7XDGau5SeYKSdUNtf3wtjKVjg2G2yvq3Htk6NchRSf5SE+Wrum+e7lfLqsaQ1Xi8H3FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792182713; c=relaxed/simple;
	bh=if309bQYyh0kJRLpHf6v76pkp4ZqWK6hYN8DZC3CJQY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=KXXEFbP5nSku10vXHzMla4Ev7ZMZA9e0bMwUrbIsIog64pI6SabTy2m6CJF96jPZejg5G7L2MmBBAOWyPT/u637694JbdXE8eKOpEjf7yRPu9JtVcZvQr/bAGmnQBGjycRRWPZ82nTFhcm+O3E+5W8898ErGm3SyXpWdaj3fJUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f3O6nd+9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f3O6nd+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2081F000C4;
	Fri, 16 Oct 2026 20:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792182710;
	bh=if309bQYyh0kJRLpHf6v76pkp4ZqWK6hYN8DZC3CJQY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f3O6nd+9uyeFa9Q/yh5JLM+Nq3Du2ujwwvLNB8QKEyXCwg+7F0P3CXRtPONpLYztK
	 7MDHFhXe67eAykFzi8zbXdvMQmrXE+UsVpQhWG3DwXWVt0G2A05m1IvAaFG7Rx/eNQ
	 C3xxaxYnTz2eiUNHGaIhSWj1TiY2Kzosfi44MiPS8BIieCxd32fITFjS29qJ8nkZZ1
	 3fKjWvqkJr/YW18bBcokL6EqWHpnj+IHh1yG+TSvQcuNoRi/DtGHnbyR1/87UYVi+Q
	 cKOwJcOCAweito68du09maaJBJxJ13jjWn4CkPbku7Uooi+TIp40QL2HLWdNVUr7fS
	 RfrG2IqBbolew==
Message-ID: <sashiko-outbox-174915@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 1/6] RDMA/irdma: Plumb uverbs_attr_bundle
 for QP, SRQ
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hu" <dhu@x6u.co>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261016202909.1289496-2-dhu@x6u.co>
References: <20261016202909.1289496-1-dhu@x6u.co>
 <20261016202909.1289496-2-dhu@x6u.co>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 20:31:49 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: David Hu <xuehaohu@google.com>
>=20
> In preparation to support modern UVERBS ioctl attributes (such
> as UVERBS_ATTR_UMEM for CoCo DMA bounce buffers), we pass down
> `uverbs_attr_bundle` for inner QP, SRQ routines. Since standard
> uAPIs provide `ib_udata`, we derive it via the helper macro,
> `rdma_udata_to_uverbs_attr_bundle`. `irdma_create_cq()` supports
> `uverbs_attr_bundle` already, therefore, this patch fills the gap for QP
> and SRQ.
>=20
> QP, SRQ uAPI will now have `ib_udata`, and CQ uAPI has `uverbs_attr_bundl=
e`
> as a top level input. However, we think it is a future project to unify
> them.
>=20
> Signed-off-by: David Hu <xuehaohu@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016202909.1289=
496-1-dhu@x6u.co?part=3D1

