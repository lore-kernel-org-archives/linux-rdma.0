Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017687;
	b=hZGe8XZGCPU3Sh4TlR7c40a2hNRCDW1PNR39gK2lAJJD//h9oBo5saqYpZ4EKpem4w3O
	 eDUleOgX+HQd/ir5Pe5ik734EPgreojzNVae8KrZ/M1ndZxW+5VfksdfpiP5taf6LeDPn
	 F40LGJccQhBDtoceboLj1/AHZCR9WeZ/5WPhJ6AaHUPnyFTVh5At8m+eLL/lnvs04Z8AP
	 vcHRHQbeMAXtH27H28ou1nNJQQ4ANaGxHZVILVspccUBuksl10UfICJzxPJ62R+OrMMsJ
	 h3ZatP5JhLAAE7Bj80EI8u0VeTCE2CA13mmCNWVPI+oL/ahZOLr4yWzm9q8LmnIt9TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017687;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=XNuPlvBN1Xzsui3OdXik32hyzgdl+loB3H54DE2udXY=;
	b=g6ByYeVeFXoZ6ky+AXz4UzQVzsagRYsHvbTIWvplofO9oLbGiaECBcBTKJFD3LBq7c3r
	 ViJbWNyEtJTHCNH2/W/yafixRwZW+/lj+C/XkJ/mwAR4JetWrnCm8sNC0YoZY7D3+MWYF
	 hVq/+uLJ0Y0P+eEG91lxBdtLY6hxLZBtZnETS1YvWAWINTBN2WE9brVDnZ2+zWdFEwCva
	 dJKZRirIiC7QOS+qmFEIPffiokkvE65SakzdGTa6QJEUfY0s3OZFJDEz5ZbcAwD3NxI/e
	 Al/2VVmwAgXMtFdyvohvxbgy74K47asth32E4obnLdRrTnN5sqTS4clKhoxFkwKCc3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MbPbdYCZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983C1606A330
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 16:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MbPbdYCZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A521F000C4;
	Wed, 18 Nov 2026 16:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795017687;
	bh=XNuPlvBN1Xzsui3OdXik32hyzgdl+loB3H54DE2udXY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MbPbdYCZQFikpVk2AfAzKFEO03qyxikgnPGU7q2hfyzUjxtycYjbWe7lhJ4/zf307
	 PXgo0JM8BwnGwIF/TeKunQSuLzdGpVwVi31CUmiewlhfzJdBOgJG/e6SYV4rrZuJPE
	 +eyrPVZWWVdr15xzPi5a4gxNMRL3BkBJFKLpbz64xyllqnkNux1sHILMJXVW9xht56
	 h6TcTRFmASg2A9TL2ymaJBp3HmbXBcODgWGRAEaTCegoPcq/46yrwhDMURgIYRpFGN
	 5NeKqlZ/3nRJCKgUuRNguphz3SOI79FAZTLlX0SMoKB9V+ejmbl6EQURW6qhejTCOy
	 FF2MlRzXyjErw==
Message-ID: <sashiko-outbox-221400@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v11 1/4] net: mana: prepare HWC ownership for
 safe reinitialization
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <f94c7f71d4228c7c30838f9c901b429ec5b1428c.1794751992.git.weh@linux.microsoft.com>
References: <cover.1794751992.git.weh@linux.microsoft.com>
 <f94c7f71d4228c7c30838f9c901b429ec5b1428c.1794751992.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 16:01:26 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Long Li <longli@microsoft.com>
>=20
> Dynamic HWC queue sizing tears down the bootstrap queues and establishes a
> second channel before publishing it. Prepare the existing HWC ownership a=
nd
> teardown paths so that sequence cannot free or reuse state still reachable
> by either the PF or an EQ handler.
>=20
> The shared-memory aperture carries one request at a time. Serialize the
> complete ESTABLISH_HWC and DESTROY_HWC transactions, including possession
> polling and response validation. Record setup_active immediately before t=
he
> MMIO submission and clear it only after DESTROY_HWC is acknowledged.
>=20
> Treat an unacknowledged destroy as retained PF ownership. Fence the HWC EQ
> and withdraw its CQ from dispatch, but keep all queue memory and wrappers
> for a later teardown retry. A new channel creation retries that retained
> [ ... ]
> Link: https://lore.kernel.org/r/179196575238.434549.10775387794024020898@=
kernel.org
> Link: https://lore.kernel.org/r/sashiko-outbox-170992@kernel.org
> Link: https://lore.kernel.org/r/179455239601.2199510.13335902064048081755=
@kernel.org
> Signed-off-by: Long Li <longli@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1794751992.gi=
t.weh@linux.microsoft.com?part=3D1

