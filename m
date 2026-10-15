Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0907322A4E1
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 01:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792027952; cv=none; b=fwXIVwUQMwkl77ETQnnH/s9ZsSS31p7mn381Dxo4IwN9ZC2HWkYIvR8HmUHokAeEJDeI+FVFqnvFQvf2LtfgCiw4PCJDHCYgwsvBolWX6P2X/84/9zX102EI2GC2MOifoiCRML+wVVOuXT9oaK3jTN22Ew3VEp4q75EbDNKCvOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792027952; c=relaxed/simple;
	bh=Xrzz3wyL3FBGGZr8IC83NMv/UzRnqmITa5oyd61TWUA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=eo1QTKF6Ai7nlb4BzOnF51t4ID97VVME7LOchNTvlSloyuYFsIyRmQdKLK+SPuBQrhOarAzo6NInSrI1QmLS4m9goKsnUxN48iCmhLJBAovGGvEu52o5OOAqlZayCOZBk8BBi7knwBl1IuuC22PANOO7CoD58z+/xcFPGf4yYe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RSnLjsqF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RSnLjsqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCFB1F000C4;
	Thu, 15 Oct 2026 01:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792027949;
	bh=Xrzz3wyL3FBGGZr8IC83NMv/UzRnqmITa5oyd61TWUA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RSnLjsqFtfnI5Ytx38pVIiCjNR/hJOmEXbfIoOHm5qkWHPoIloUeyQOCT1d9zFdcW
	 5FLeKSwvyrlG6X4MXji2wfini7lQnItZd0KEzIqODLzRDERt1bvuHTJ5VGnoWuNVHT
	 Z2WSsAUtZERdn0hPACPDET/9JcggnWnbuxTK6YpomWMSMvZkifDDXLrIBGI2OzxGcw
	 ofX2vkYR9uK8Hi0ig5Q0bgekRzAzDUJjh2YI7LRPGjfWBiD4UYxQL1Oi6H+hyNnROe
	 77F7FkOcKdoYkRr689dxbrauFjn2DClHDFlXkIYt+ATd+VGZDnvhaDOLbwty15NEK4
	 7k1Xe5AUy0f2w==
Message-ID: <sashiko-outbox-172096@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 6/6] RDMA/irdma: Support UMEM attribute for
 SRQ creation
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hu" <dhu@x6u.co>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261015011940.4122452-7-dhu@x6u.co>
References: <20261015011940.4122452-1-dhu@x6u.co>
 <20261015011940.4122452-7-dhu@x6u.co>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 01:32:28 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: David Hu <xuehaohu@google.com>
>=20
> Support the standard 1-step queue buffer creation for SRQ by
> `UVERBS_ATTR_CREATE_SRQ_BUF_UMEM` via `ib_umem_get_attr()`.
>=20
> Set up hardware pble directly from the pinned SRQ umem via
> `irdma_setup_q_pbl_from_umem()`.
>=20
> Proper umem and pble cleanup, and error unwind are added into existing
> `irdma_srq_free_rsrc()` upon SRQ destruction.
>=20
> We maintain backward compatibility for the legacy 2-step registration if
> the UMEM attribute is not provided.
>=20
> Signed-off-by: David Hu <xuehaohu@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015011940.4122=
452-1-dhu@x6u.co?part=3D6

