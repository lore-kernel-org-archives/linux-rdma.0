Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794840921;
	b=ym9u24yIcI0nVwEJxmjf95CLejevlB2E7eRjsyiVrfjBUJ7auoCVXpC3Z5vF1X/Nf7Rd
	 x1iWEiDZAn7MEG8tXVMjVxUPGOW6wlGYdGlLL/n4S7b4TJH/D269q9ziIOEhchTznKBTj
	 RfZ8rzhoRaxHubVoVePqdKLMbZzB8ocCRepIzHSCUfcqYO2jHdGa+FK0FPP6gt5j3onwr
	 Xncf3DOtzbJiGx9cYxwIqa/0hlOqno+3nwPQzYKDus/FrpVZyNHVnaTYOtq8IqBB01Agl
	 7n2GwZgvsHW/QwVWDGKrNCs3e5k4E5TSJ2h1bzt63HzJQ7tz90PREaXTmt3w5BP1EmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794840921;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=DL/jxO+R7bjo97WKt4B1VFFhuy2Yd9uzPkNiy8+s6Gk=;
	b=as4Uxc0ljP4T987VR4CRDKHkkKS4v+RBj8ANpaj+bM6GCX8cCu6rkEGXKQpRLrikfRtj
	 sqm5g+3rvlSGNono86jnpg8FZeDLAmh04jrKq9U+XeRXm7L5I/MD1DfQ47resbc2hTfqr
	 /ptonq0iGtevqff7yjW73KAgiZ8Q8shglPF0qrg8r2sVAxhJjfOo7NApYHsh/cdFL0Otl
	 GwMYCHA+sWglqCtkHqUqesPwdBmQ//rEGI2GF80dlFdDBnQ+F/lZ9A3vHxxwjvMCmDAP9
	 IH0mSj7GfaQPD2HgykRNokOd3HIAKNU/ux7vPy9rcKysSinhXk0Si0XtZq9GM6Aw65Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="DTcJ/9X/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90E3606A329
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 14:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DTcJ/9X/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2631F000C4;
	Mon, 16 Nov 2026 14:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794840921;
	bh=DL/jxO+R7bjo97WKt4B1VFFhuy2Yd9uzPkNiy8+s6Gk=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=DTcJ/9X/IIDjv1TrHqO1ScR/S6gLk+kO/uTeE4aeF4h1rn01GHz8v2xEH4mJXGnnm
	 1Ac3jPHrJFQTaRyeP1WZySf5j2lrX+y47ywNeTDujJGvJt4aj9iV4GAVnLvGBUS3vK
	 xiFxuPuldR8PmEoVyQIyRPqAgUu3z5Da+vXlwHzV1V/U7J2dfJ97aBddvVm03ZqMjC
	 5pzr3Wky+VZZsvYTR9T15DxDAPTCvwlFG/mjuqmOXlRU8zl2z7ijdUiM6P5ZVraXVy
	 b9JY247+qFlddL8i6C+XHAiGpc8Vny/8kzGv2kl2ym54/oseJvC3wQNpfptsajbNaw
	 vyP6P9kT4MXKw==
Message-ID: <sashiko-outbox-217202@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mlx5-next 1/3] net/mlx5: Extend nic_cap_reg layout to
 its full register size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261116144554.1194389-2-tariqt@nvidia.com>
References: <20261116144554.1194389-1-tariqt@nvidia.com>
 <20261116144554.1194389-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 14:55:20 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Moshe Shemesh <moshe@nvidia.com>
>=20
> Struct mlx5_ifc_nic_cap_reg_bits describes only the first 4 dwords of
> NIC_CAP_REG, while the register itself is 32 dwords long. The driver
> reads the register through mlx5_core_access_reg(), which derives the
> access length from the struct size, so today it issues a partial read.
> Partial reads of a register using access reg command are accepted by
> the device, hence nothing is broken and no fix is needed.
>=20
> It does mean, though, that naming any field deeper in the register
> changes the length requested on the wire as a side effect. Describe
> NIC_CAP_REG up to its full size, as is done for the other register
> layouts in mlx5_ifc.h, so that the access length is fixed and further
> fields can be added without altering it.
>=20
> Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Shay Drori <shayd@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116144554.1194=
389-1-tariqt@nvidia.com?part=3D1

