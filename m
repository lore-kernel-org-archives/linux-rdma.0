Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6CD483809
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 05:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792386641; cv=none; b=LAf1jeS9UcGHfp6lgWTadLAOuaAXVBmPRsd7x14fB0MnmttP4A/DG+YIEArnBVC2hPosYSEG+1Xpsc/fiN6Rr18GR8LIomFb43ulwQImThwtihgRdEFwzwSJ9yXT7Q1tkkB55cD83GyuZkvb5u7CmYQZEYDpc8hv+BIvML0tU78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792386641; c=relaxed/simple;
	bh=C2eOKciMvI/KzS752c+N4ZhaRiUgc9b0JhwdnJzcV6c=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=FbIUyPYX7urNITCGq0gXKJ4qrH14Uqq9NLJZMVXYUE3y9z8dZozZiw4VOOjXpF4aqHbGfg3FK7khbRrkM/1Y7PE3BiP4rFd4y/TIRumdpREIxfqHA1ivVl6IFPfLnnLS0tANvySxvPLaNVCPd+mSjyPsuE1cVfHQqAstVeJ3j4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PiTKLS0o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PiTKLS0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA751F000C4;
	Mon, 19 Oct 2026 05:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792386631;
	bh=C2eOKciMvI/KzS752c+N4ZhaRiUgc9b0JhwdnJzcV6c=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=PiTKLS0odsIbzIptKwi3jnLRcxw5Xnz0EAHrri703GNoxtDJ36SDI1kJGXHcBfAmZ
	 FJwllWXtpn3FQj4cbfKYVyA0ynYPby89W02rp27vqYonhhR1erboPv168nxkmo1ir8
	 rQNbpGXgIhovFBuXOE8Nlj8BavyMNOWT8wSkh9hrN6GqTHU4paGoozx8pcYKf9AU4X
	 89MZVQJzkCjCBZr4FCCVxT/mWhIuMcPwqrQpbWB4xXXZfLwfHEDMjd+EkMUROR8Xfb
	 hfVhuMfcigpSkRQArdBbh9txa7TgLea3jU7hwnKCPQJgjPyuLClbxyiB9B4JM1aKHA
	 8fm5q+sL/Fqwg==
Message-ID: <sashiko-outbox-176660@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] RDMA/mlx5: Fix CQ resize destination index mask
Reply-To: sashiko-reviews@lists.linux.dev
To: lirongqing <lirongqing@baidu.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261019050503.2313-1-lirongqing@baidu.com>
References: <20261019050503.2313-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 05:10:31 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Li RongQing <lirongqing@baidu.com>
>=20
> In copy_resize_cqes, the destination CQE index is computed as
> (i + 1) & cq->resize_buf->nent, but resize_buf->nent is produced by
> roundup_pow_of_two(), so it is a power of two with exactly one bit set.
> Masking with a single-bit value can only yield 0 or nent itself. The
> buffer has nent entries, so valid indices are 0 .. nent - 1 and nent is
> one past the last slot; whenever the masked result is nent the following
> memcpy writes one entry out of bounds.
>=20
> Use (nent - 1) as the wrap mask instead. For a power-of-two nent,
> (i + 1) & (nent - 1) is the correct modulo-nent reduction, keeping the
> index within [0, nent - 1]. This matches get_sw_cqe(), which addresses
> the CQ buffer via n & cq->ibcq.cqe, where cq->ibcq.cqe =3D=3D entries - 1=
 is
> exactly the nent - 1 wrap mask.
>=20
> Fixes: bde51583f49b ("IB/mlx5: Add support for resize CQ")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019050503.2313=
-1-lirongqing@baidu.com?part=3D1

