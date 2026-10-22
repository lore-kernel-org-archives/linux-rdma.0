Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792682155;
	b=cJhy6OgVAVPQPfMrh/P92Le7W1Mt19Gv4AbOKHlaPrYIQfPevOvaRiShCstxrBIZwzP1
	 TDZ1ZGUQW2VXb5/Q9fKG4tMQTGRwYjEA0B50OOUziuO7/sQ0eaV5BhsE1CbO8n/tVNK2Z
	 NC8YF2xg48qOXza51fB3jvClyQdGpt5vdr/6ibE1lAdLDgNQEu7MjC0d+txqzCoqux+su
	 C6/2QLCcWt+SFVXwPQZ9hkJydfWJIZKS3egaZFAsiJfSP1afOyoMM1UbJX0ARtpmDDlXF
	 tcsVuIq7iS3p2QQ1E9ULPOjYN3r66L6ewNEdSdni/wHrp/eOub8OUcg0MONz3k1qOmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792682155;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bThFfLAbI0VSxgNEsECuDzG5HK3j2ASdXtx6wJapPZY=;
	b=vGsl+eAhrGjXFcN/vYt+qB1WMBCQfg9ciBFVmm1TQjeyeC9ASGtqX9OMOG/zZWHlL6rZ
	 tEV6wpxaUV7iRORPvhrAJmJEw1CXkQE3qhGRiDOVtEOcl+lddqpqUQz/2LqdLSy04QnOP
	 3FJvNcxgSrosqxomF+4r1cTl9Bl4vIr/kc6vxjeBk9ccY2T73/D+pGDJnBBmuWXDi/e2J
	 DsiBBaT7DN+fBLAq7oJszMUTBcINtdOnMgfeFzu1aoob0RXYJ5D/3psVYK5gzvY/4TlC3
	 +fQdDD1mrbGj18XkbKtdNg070w3BMpMrykPkl40lo0qTrzw2R7gKk9uojUuDdqdf4Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ak8da4Oz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AA9606ACE3
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 15:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ak8da4Oz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E251F01828;
	Thu, 22 Oct 2026 15:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792682155;
	bh=bThFfLAbI0VSxgNEsECuDzG5HK3j2ASdXtx6wJapPZY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ak8da4OzdcQqeYLjznjgXDvfwNMfJfckzG5UbMqhcVuHkAO8bgSe+b+m4bO+1IFGD
	 ph6RzcLSq5x6EAx49dpKtyd6CLWwGAo6BPZWpHOEcu+bG5RV01Ho4MEwX0VOJ3PWX4
	 EmFxggbO6g66kLnYW+qYge5BR+hVdly9bHwaraQRvZsNj+XMTB1a2p1soj3ABaBsDz
	 BADcgB6h1o7VAvse3P8jPTcq77laWFqmFst+Bw1F5DliQ3nkbdvAltsYDoHDmJzZW9
	 VQBgJrfbntR1ycOTbEyEX0Vs9nEjJ1vyxbFhR0lh/K4WS5vkOTpYlWUBoVpGJKwy59
	 cIWOX8YdbFF/Q==
Message-ID: <sashiko-outbox-181680@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v9 1/4] net: mana: prepare HWC ownership for
 safe reinitialization
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <d4ea1c76b5cd1d22103788a7ea656087ccfdff58.1792679388.git.weh@linux.microsoft.com>
References: <cover.1792679388.git.weh@linux.microsoft.com>
 <d4ea1c76b5cd1d22103788a7ea656087ccfdff58.1792679388.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 15:15:54 +0000
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
> Link: https://lore.kernel.org/r/178910960115.219967.13830871915506436112@=
kernel.org
> Link: https://lore.kernel.org/r/179196575238.434549.10775387794024020898@=
kernel.org
> Link: https://lore.kernel.org/r/sashiko-outbox-170992@kernel.org
> Signed-off-by: Long Li <longli@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792679388.gi=
t.weh@linux.microsoft.com?part=3D1

