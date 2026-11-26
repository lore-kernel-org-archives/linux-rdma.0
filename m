Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795674283;
	b=FzTF6r0o4OCOYMiQIzq8p4WP1XmxGjQ/0t+s9OYTzyRCq2FgJPC6EqQ+ZDBMOBVN+f25
	 Y2c7GUPLDqhzWSDWGbrEIxOJKHkka8U8RF14Mipn5nsRCP2sHk/lJ8p+5/N5xSugbtDkY
	 vyENK30NoKNbbZOEqoXEnnuNm9WBG5nv0Bslh3tjXd32CKeDFP1m0YKdysS75qq82NyQ8
	 IWjhgZECLnPbPRVSBeJ00sZ/QYIf/lbAqw7PtDUfRCGUvZv0JLMgOoiWIEfB/M3VeWmtp
	 dHG4xhTjL4K2aIdgTJD9SX21X/UpMyVt0PIq777tXXF+WtVPw/v+rSG//HANy+7IK/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795674283;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=XVIRc8mdbwOXZPOn2oD9nWNMFUTW9f6E8vEr1fvWTWs=;
	b=lCHwifOK+6/0o0W+vv1ZrIDmkaxL7fTt0B7Ga2gCQb5nF2Tjo4r9ZBB+4VnSdkklkOlq
	 4UG5/vaIksigg4UCmq5CCIdDyxsK4ub+Jsuo6iPQjQ/3++ao41kWQbQ6kHKTNP9ISWmSo
	 5JUQYQ1L0YQfm1fiY+sj8Runu1usEjjhmIm7+6COEA/wSboA5M991o1/v1YXZ4FSf/fWB
	 8eQkGAM8qcgONj4w6AvDyVa0TcVX1enGVLyPIWsuaz55Xp0LdFG2Z2jXiRWCRmhEQO4gf
	 JTxgsu0ASXBfSc96Bvl/pe3veYSK1owBIi4BfiFGCyH5MEBX2ZN8Uf90nr10A3Is3yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zd9bqmAB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA62606A321
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 06:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zd9bqmAB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C5D1F000CF;
	Thu, 26 Nov 2026 06:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795674283;
	bh=XVIRc8mdbwOXZPOn2oD9nWNMFUTW9f6E8vEr1fvWTWs=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Zd9bqmABWQLGloyaO32zz8oUYreg1ojLSitHCch4GJLShWfycaK/ThY2TTQEFjzTA
	 2pdlDLrcrc0+KmPWmfy9AqvWSaaKKohlymWcKiOJY8PHIuY3WYUc8B8FMhXN6QQwgc
	 88SNqh1rzXlhb6eKxgPQKxj2BpnFN/KAn5GZ05yHN4ty278Uyq7En3byDTDbMGnoDp
	 +gwCv3V5e7Rb/8hiBJzeS78Yi7dcTOrEFY9AAA+rP7o6FyL9HBoSQHZ7ZPPI0WGOFP
	 3ExR7B7OHOxJh4d5PlMtQGRlKJ7EfMr4+p+ADSc07ZtVEK69d780QabJmOSaql4aY/
	 50gN60Vz3LOCg==
Message-ID: <sashiko-outbox-234840@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mlx5-next] net/mlx5: Add PSP header extension length
 match field
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261126061904.387686-1-tariqt@nvidia.com>
References: <20261126061904.387686-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 06:24:42 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Cosmin Ratiu <cratiu@nvidia.com>
>=20
> Expose the PSP header extension length (hdr_ext_len), so steering rules
> can match PSP packets with extension headers (such as the virt cookie).
>=20
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126061904.3876=
86-1-tariqt@nvidia.com?part=3D1
