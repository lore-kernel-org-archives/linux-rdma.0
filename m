Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794401299;
	b=lUiuGGOtyHte6lE8qstQSu2yEqJ9eX/qLOFfKts1nTGlhw1ED3cMmV7DYoqrO7cY0awU
	 tMJhzpYI/K40oPf0k8KnRqjQn+J9aPAAXvBcPTeJbgWgfvhYOV4sGr4Ic0i4XLcNaHkGY
	 KxbPbiWqk4rjAogivnKwPnOSKgb+gu/KZf3GoNug9PkPNGpNNKbbEM3RRgjnsAsPkie9y
	 pEhGTfByn2Mne9EdMtsQ3oeyxYWtDQheEAewsauXznqxRzOu4z5VlmqO9l/wbkEur7voZ
	 FMljx0BVb4M19YAAznAj4ANSV4FbxFdlcRazk6bnsxdIqgl6Tz6v8OlioWfnWo20I0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794401299;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=AQ2V6Ozw3wWDoZHDqf9uKMnkqdReUuYe7nM93gvkuhc=;
	b=TcibUhNTX1rf+12hxe7kRmyzmBTqAqLx/LtK+JOowbs3IQfKMkyXZaRTeq3NfGpV07Zi
	 tdkoccyZZrt/0lNc6/skfSE7Lei3Ngw/4/YE2DB/uKeSCLUArcaZNdUQnV8FQZSsf+VDb
	 Z170m17dTkjOGZlgpnvrmLyGNp0GZpTSIji6quMHFWvl1DQB8Wt4a83aO4RxTJ9CsG4JK
	 JzmAXaG6UyPJqOMa7poBgmCmHKWpXQfqYdrXlyM4feX8nU3EqKiyY8u8mBo/9p0GbdUdy
	 ogtylB8r2rmUna2z32PGIXdVsPr4OjpS2hSOy/YDlGmQB9iuLwCgYK8g4KfjxnTaOSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m4lB7noN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341C3606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 12:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m4lB7noN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1581F00A05;
	Wed, 11 Nov 2026 12:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794401298;
	bh=AQ2V6Ozw3wWDoZHDqf9uKMnkqdReUuYe7nM93gvkuhc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m4lB7noNcP+Rol3AQYL2PRkbsc8SWP1O7+zNF+lqw7Fy318Cg9BRPhXiLS7zBCKHQ
	 bqv/ZMqjnZzKI5KmjnQugaAN+iM9BTpJskj4K2+Yw1AV3f0ucRaRKqI8DsdMmxJ8b2
	 9M2TKBNmHxsjhMjB5cako36QDvsjUlmb/uAszFA4dUJfz9KKO17QG563l7Lnt91lzt
	 EbanuorXsaVZujYRbGH6TTXdX2Eft6P9uCirx0KWguPXcL12U9W3L2NM7mgydNNTdQ
	 XBcKaA89bWzBsp18I6M4TwoRoI7ch7K51X1Rqk3x/YTam2aFV7iZ4uAMb8slT+RFxI
	 aCDZG3UxpBvHg==
Message-ID: <sashiko-outbox-209012@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v10 3/9] net/mana: Extend GDMA encoding for
 new RDMA WQEs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111121417.1265896-4-kotaranov@linux.microsoft.com>
References: <20261111121417.1265896-1-kotaranov@linux.microsoft.com>
 <20261111121417.1265896-4-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 12:48:18 +0000
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
> Extend mana_gd_post_work_request() to support extra-large OOB data and
> fixed-size WQEs. These formats are supported only for power-of-two WQE
> sizes.
>=20
> For fixed-size WQEs, use num_pad_sge to specify the padding size. Encode
> the WQE header fields required by RC QPs based on the WR flags.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111121417.1265=
896-1-kotaranov@linux.microsoft.com?part=3D3

