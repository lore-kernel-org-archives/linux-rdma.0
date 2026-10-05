Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F4E79CD
	for <linux-rdma@vger.kernel.org>; Mon,  5 Oct 2026 00:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791160515; cv=none; b=rlS5ZuR+8MMxeTonzjpoUGq4lNfbqy49ewCiZdoCA5LmTblSN7Hfd+r7n12l3HYZ18GrTT8lBACwEkI9VVlJ0vNZ/vrGDLU2ewxZfJgSmtGkiM4BFjMLc9tYKjcW1R/tBHHJWgB0h3WIyvteEJvTU37I+R7kyXL7G2A/QpTj5zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791160515; c=relaxed/simple;
	bh=mO57K/pImexJNHCc8bwaxgQj+ek92QBkvey0/kvlNKc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tUtsalsZ1c2hIooov+RHuy7gckQQ/CnAJFUj5KwlHvy6j8hazaK9oOGziddo9hmDjRgWdxluvE5aAw8LmlTOCs+jfqJrZklWaUMjnE7eAoRsmkz1rDCPiQo+oNO6cwpW8magXiEbl1W13I8qU9RVVlxSvC1/p325MmNfKn1t0aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZhsKkogL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZhsKkogL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1917A1F000FF;
	Mon,  5 Oct 2026 00:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791160514;
	bh=cJ41xvFXoFoi0ELY8qFW4Vd4/qTuDC1zeid7f49OBwA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZhsKkogLmiUjB8Y5vcgrwciwTLMtbRVNnFM1f6OXB8Dw3hGRtpVTpMjdwPJZrvcoN
	 IQrlA9wjqbh8ihQMxbQTMpwgj487tSF1wrJc+iRyY116eNGGDqNKHnX25CBI+ASvfk
	 UzViQLuhYfyEa18KUGQuwocWWFGGE7ws1f9cjfvwbBCL/C487iFEyG6BvyxzFunob6
	 R4vvJLEc9jOH67DrC7I04Y8GpHOX6405ayjU4VQv54qsa+HDQHlGaaUKGZEnz3J4Ik
	 Nryo6l6TVa3o0Wv7hoOHt6fFk0EbfykxeHGBBdEH632yErNjNb9PBBr/udsPotgchb
	 0mAimUwUcUo6g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc] RDMA/siw: Enforce IB_ACCESS_REMOTE_READ for read
 responses
Reply-To: sashiko-reviews@lists.linux.dev
To: "Haitam Lazaar" <haitam@lazaarsec.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <1a10973a2a8.17e04b672219.8760522594078806286@lazaarsec.com>
References: <1a10973a2a8.17e04b672219.8760522594078806286@lazaarsec.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 05 Oct 2026 00:35:13 +0000
Message-Id: <20261005003514.1917A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> When generating an RDMA READ response (SIW_OP_READ_RESPONSE),
> siw_check_sgl_tx() unconditionally passes 0 as the required permission
> mask:
>=20
>     /* Reference memory to be tx'd w/o checking access for LOCAL_READ */
>     rv =3D siw_check_sgl_tx(qp->pd, wqe, 0);
>=20
> Because perms is 0, siw_check_mem()'s authorization test:
>     if ((mem->perms & perms) < perms)
> evaluates to (mem->perms & 0) < 0, which is always false. Consequently,
> an untrusted remote peer can issue an RDMA Read targeting any valid
> STag in the Protection Domain, even if the memory was registered strictly
> as write-only (IB_ACCESS_REMOTE_WRITE) without IB_ACCESS_REMOTE_READ.
>=20
> Enforce that the target memory region was granted IB_ACCESS_REMOTE_READ
> when answering SIW_OP_READ_RESPONSE work queue entries, while preserving
> perms =3D 0 for standard local sends.
>=20
> Fixes: b9be6f18cf9e ("rdma/siw: transmit path")
> Cc: stable@vger.kernel.org
> Signed-off-by: Haitam Lazaar <haitam@lazaarsec.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1a10973a2a8.17e04b6=
72219.8760522594078806286@lazaarsec.com?part=3D1

