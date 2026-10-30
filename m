Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793366193;
	b=Gm/EpnMs12xUy4Y6H/0m0gbzzsipSHQcOV3VebJmD2r7Nx71pdDsIVSfsVgGkSRC6pzs
	 mXU82YUQJcwCBLWeuk8EclSO1JPjSmDeyY6EhXsj2fGYDHHZUmpOmXHcwzJ1pe5i83lQE
	 NlkAybRsmSn1ltnBwMbCoGt5Pw1ReWXt4HjBHj8R5iZDeNf1Didf3Whq0/LS8NwyoQCxm
	 0ZKGCAoIhqYmwh+l+5uQ0XfiFohnmPg+xXRRWkMKbyORIq2HTB+ETRBOW/r/tgIj4ijrx
	 1de/5opH8/8jRObpw0l/ahwq0AIpk9YWInc5ZgcCHibjE5lNwpteucVgo71Mueh3fjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793366193;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=zdx4hrXE6Fdc7m4/ZqjsO53wGrVsGn97eho1pHEc+Js=;
	b=u3cmttSImRdfg/nQoFnaTD5SIANyNFemkr9WkHX2yKRcJxCRiS+tan9l72Ryi9PY7b1b
	 1BsepB14BE9MjBoJafVp17Fk1aA1jWfJLWQxPOFtzjaijEwhuCFaBWPWt4F++KDeFJY19
	 7sFooIsCXuYsr1Vy4lSGDeiDYOyctKIMJVQ0PvIDtko+2O1CYT46xg+aLkiFqEus7QaSu
	 HXawKxPelC2jfpOYZWQO3jn4zp5ZCoYmQX622XEHG8PCp0PvK9g5mC7y3oTOSX79+CUq5
	 blEj7RCFFUSwDQbE96QC7mK7q3NByc20TxcUqIDkf53nplNoahanM69ft8DkK6HccOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kzi4ed3+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38F4606A31D
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 13:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kzi4ed3+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091B91F0093A;
	Fri, 30 Oct 2026 13:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793366192;
	bh=zdx4hrXE6Fdc7m4/ZqjsO53wGrVsGn97eho1pHEc+Js=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Kzi4ed3+H4UmeCGuj3pRK8JrSXwHEDG21xf/ZzgLXi2rclkp2K2xvivB3BpwSUiq+
	 yCrPHwLoSqmXEbsuQ09wEsvR5uspVrGM76coBx0RIHEmlT2RUEUa1w5MqadFNrB/V7
	 Xk85B2wwSnSk5r+8P3i4rt7mLpmJEoFOKaTOKzZeTZrG3dfnTWoMBKtE7jaEKn9mdB
	 0Kvb1brMHcXO6gz1rllRIZ37+HrAHh9WZI5Ew4Py6qPQpP4O6UQx5PzVBwQJasrq7J
	 F8t/YZ0osO1NFKuB5DLWi7H1kxngdA+F1oitW1Pi7m1VB7iGLN5JbwXIlY+jNsfixG
	 DGSRDKA7WVe2A==
Message-ID: <sashiko-outbox-191054@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v6 08/10] RDMA/mana_ib: Flush and notify CQs
 when kernel QPs enter ERR
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261030130038.4040789-9-kotaranov@linux.microsoft.com>
References: <20261030130038.4040789-1-kotaranov@linux.microsoft.com>
 <20261030130038.4040789-9-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 13:16:31 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Complete the RC software flush path by adding a kernel QP to the CQ
> error lists when it transitions to the ERR state.
>=20
> Invoke the CQ handlers after the transition to flush pending work
> requests.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030130038.4040=
789-1-kotaranov@linux.microsoft.com?part=3D8

