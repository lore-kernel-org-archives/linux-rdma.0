Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795696153;
	b=Z8KBzyy06j2T9wwEVch875ZOl9Jfsbq+b0DJ4wG8hmwLDxn47tHlHFHa2iYgxcBz01zb
	 lbtzuAItPqms0H8ri/TymxqNaYwepk2veOc3F6b83+nEhCQR6xXOHDNYUETMot27AaOsf
	 Xs/h3nDVDYYobyJ1snT/r3lEGK6EZ8DknIbfs0qo5Cyh5mQOSDT1Oo6A9oX5MVh48UpcM
	 liEfHsJUV6i+n9ScYNn6mA+t8AAGenL8obcN8lKFalzgxgZOk3ffMa6qMwsNYhcEJuMiW
	 +3bYupihrcHvrNS4ReTSXcSMP6uUPmX56TSotnhvfkBXb//8iRaIFncZ0x1IWUj8qyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795696153;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=87tk6oFAUy5NNmqO9ERWckG5EF/ZCdLlSvK3TdtzVjI=;
	b=K/xegIhYKVgFnuwJhUZR2FmRdiT+mo/VDnbEcUOpxl8abulGAXiTy4p+sqPz43h58NEW
	 E/Pj0SGU725KO599fD4Jnjj9T8RT/qswY+WXe1wrRhoxIYJJ9D3dToBzzeogVgQ6aJakY
	 YK/3p8CC+E7O5Cd/wl2rxUw49Ey9sueYiiGnL9IIYDmb4tpvV6ucFkmMhnHhh57kEfhsd
	 jbwkyppbRLhMgga1o/bxKP4A5+L4bCuUCVpKv0ySas2Mb9UOk/b+6LDXQj8W82qNoq1GT
	 2QktgiSB3x+e/QCUFOMx1cUJKlM/jduulvNcVODISvnago+SvG2LnAFR8AbhPHyp2mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jBPVtIUl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59D5606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 12:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jBPVtIUl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6631F000C4;
	Thu, 26 Nov 2026 12:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795696153;
	bh=87tk6oFAUy5NNmqO9ERWckG5EF/ZCdLlSvK3TdtzVjI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jBPVtIUlVyBm9Xei5cZV/0dPIXpnVK5mXbbG10D8vzVNbRfpzyTWqvOCfS6Tw0fUD
	 gTl8w9M1qX9fGAk1dw2YKQRg9Orl9UpSPJKOgjcw4M0qcGaTzjEyemRR8p7va6aQya
	 XXp6Pt6eArF1gSQ7ILhDWqrFLF+v8fT9C2rskf82coIt3YB5T3xvoKQ3NJ9xlt4/gJ
	 9BG1hawgdAjv11rN1gJIIVrsnOikNTyJs9CFlEEuECiKTvYNCo/F4gByhNAx0AIhSQ
	 9gbpONnT+2U1VqkAKfXrlA4PFCO6iuxnIQwzQ472cHfzYl/FFDM8qs/AXx03kefmnz
	 2v5F7LrU83CRw==
Message-ID: <sashiko-outbox-235503@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5e: TC, Fix parse_attr leak on branch attr
 alloc failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261126122316.599831-1-tariqt@nvidia.com>
References: <20261126122316.599831-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 12:29:13 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> alloc_branch_attr() gets the branch attribute from
> mlx5e_clone_flow_attr_for_post_act(), which also allocates its
> parse_attr. When the branch action cannot be offloaded, the error path
> frees the attribute but not its parse_attr, leaking it.
>=20
> This happens, for example, when a police action's conform and exceed
> actions are both jumps: the exceed action fails with "Cannot offload
> flows with nested jumps".
>=20
> Free the parse_attr too.
>=20
> Found by LLM-assisted code inspection, while reviewing a fix for a
> double free on the same error path.
>=20
> Reproduced on ConnectX-6 Dx in switchdev mode, with kmemleak, by
> failing 50 times to offload such a filter on the uplink representor:
>=20
>   tc filter add dev $UPLINK ingress protocol ip flower skip_sw \
>           dst_ip 192.0.2.2 action police rate 1mbit burst 20k \
>           conform-exceed jump 1 / jump 1 action pass action drop
>=20
> Without this patch, kmemleak reported 29 unreferenced 4096-byte
> objects, all allocated by mlx5e_clone_flow_attr_for_post_act() from
> alloc_branch_attr(). With it, kmemleak reported none.
>=20
> Fixes: f86488cb4685 ("net/mlx5e: TC, initialize branch flow attributes")
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126122316.5998=
31-1-tariqt@nvidia.com?part=3D1
