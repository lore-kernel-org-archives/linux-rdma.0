Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794979468;
	b=5fspUVA9fOYcAB9mP27DAv+iKUmjXS0xprcktg3TmpONXVkqG21MkB5bOIiQCsb5tgnr
	 J1pp9mrlnpryxSic3nF/ScsbeLZb/WPq6erWWNSWustPMMXLMgC/SwkeUL1/4qVrLRo1p
	 wItZHO3GN0nM37qgjOFOlXBURxiS0tahf6hXYu6VE9PMZLLpfn2zNCA/qrUANOCToKAWR
	 WQwwjsXnIBLa2lhyEyMdblZcbxFkB/rG4/vQJSoyMr7lAykaXNoK/KNk63mFH7EVe4L/x
	 uOMg+sLUgl+5qQ+GlV8QwbsDYpy/qBLaMZ8Xe0eFTv5JLGmT5CKl90Tki9LXhl0+Idg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794979468;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hiP7wK7gxju6wuSms3bHeBb+D1kXHTsecvxJMj2IEc4=;
	b=B1djIZ4yAUiyqH46W5laXc7XJ8Yv++R4KkyjfhAP+innqHPq9xiEuWPnzhLWOn6roXNk
	 72QVE4xX6NeygciH65yYxnrcdrin9O2iCW2xSG3xQ2MAu5ntgNUt5nv8onJ7a+jk/SmH4
	 v77oZjAkWuj4F67aXQji3DC4PPBMpI6FR77hKCtf520zVvIO5BTs5wgOvyauLb9BvU9wj
	 RneOOeTYuolkih/1cJxTDJhWFfx3dZdqfB/jkcusJmHW3BInSV8O5qPhJIMX0ytgg4Rwq
	 y4/dCVGcU83KD2PA5Tpp67KZX9JUgiv7JEHd9qOfaerghh6cEVWdYjT5Z9+XRhvee/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MinpFUlj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1EC606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 05:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MinpFUlj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E4D1F000C4;
	Wed, 18 Nov 2026 05:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794979467;
	bh=hiP7wK7gxju6wuSms3bHeBb+D1kXHTsecvxJMj2IEc4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MinpFUljJWZyuftQ6lDm1n3VSTOWqXFtlfluYd/dFEGPL4Iep0feWevCETpnYsYIi
	 cxO6OPuzt8ny3cYeuywQe81+F1ZtTzgzSo+jYjCje3l+Ym7rdl5wvOmOr1f1Qo9sKs
	 Z8DFSBYbOhH7wg8EVCoHCs9jLhfQOX9yeH3fcDDeHZfJoI2R6u1Qq3k0n60NkPGsW2
	 5mVj6LYnY4cuLaSbgHDlEKvOnzHHilgVIuzSwcigUPjI9bEdX814gEdxXUSJK7e3mM
	 aKpdaNSfuHANgaX7+T1EZIZ3E5aPFpvop1hx5uAnpCvWLIQ+rI2ozc3ng4cXEDS05O
	 YVwUw0KVQcv2A==
Message-ID: <sashiko-outbox-220159@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5e: IPsec, Fix RX mapped ID leak when adding
 a rule fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Changyul Lee" <lcy8047@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261118051247.3885308-1-lcy8047@gmail.com>
References: <20261118051247.3885308-1-lcy8047@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 05:24:27 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> In switchdev mode, rx_add_rule() calls
> mlx5_esw_ipsec_rx_setup_modify_header(), which allocates a mapped ID for
> the SA in ipsec->ipsec_obj_id_map. If a later step fails, the error path
> frees the modify header but leaves the ID in the XArray, and
> mlx5e_xfrm_add_state() then frees the SA entry. Each failed inbound
> packet offload SA leaks one of the 2047 IDs. Once they are used up, no
> new inbound SA can be offloaded until the IPsec context is cleaned up.
>=20
> Remove the mapping where the modify header is freed, as
> mlx5e_accel_ipsec_fs_del_rule() does. The modify header is set only after
> a new ID was allocated, so the copy that mlx5e_accel_ipsec_fs_modify()
> passes in never loses the ID of the original SA. Outside switchdev mode
> rx_mapped_id is 0 and the call does nothing.
>=20
> Fixes: 91bafc638ed4 ("net/mlx5e: Handle IPsec offload for RX datapath in =
switchdev mode")
> Signed-off-by: Changyul Lee <lcy8047@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118051247.3885=
308-1-lcy8047@gmail.com?part=3D1

