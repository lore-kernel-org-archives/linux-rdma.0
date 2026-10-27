Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793136541;
	b=qEcxYHyrvz2Qjs0rGOZPXnO4eBtjTTDfoi05DaibWbFatwVhvZpdrC8eu6N95HiYb2S1
	 igAuK57RuHkM7/N00E1TaV0sTQNkhCyRfyAaddtSXvd154CkAVQTsbhAtT6hk+43gER/O
	 hvS+o9yBFQho5mXciOQHAgIy5oxLO29eruI4rXSlnvkQ+/N7adD8n0v7PaIXwC62xa1i1
	 J50WpZN8DKeLVA0/H1oHR1PI4GtqqnDWDWWpHsr+n08Honoj8CgCuFZGfBhrFJ41OkD1R
	 ZxOnmXSJsi/WVRgnAQfOWRi7OkutOI8EVcDGzShmhkrD0thyXKJuHI2Kx4CY4kZTwqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793136541;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=WWWcVhVxOqdQnoFg8JcI83d9vlW3+m4zDR4iRyVRsZM=;
	b=v2tsAPT6RXavEj6qwP+pvhhh0P6APAGEjJOynGdlEkOTYD18M73CQdYQcvJXBt+SaUMe
	 9WmpwkQJFCcXZIPaBepJbJf+mKp11favgO3Fwiclgbcl5IJFPP8/s7s9wb64j53O08HOr
	 uGzMJjZYxb60k/pwxF6huGwmX8oNFAn/PJXrzNeXYFFc9WJND1T63kzrMj3OIHHU+ICc6
	 988kd958BF3zsdYtoKV/BbkdsI7RibYSyW5Z6rBk4kEARJhf8Qx4MJxH6bnLVK2XXZnwg
	 17h0JJ1yfYutf5Hn3xAyKOAOGk80wzxMCFjSlGz1EvhatNDMLLtSdYRSVO+9IAdA8RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e1EF79C4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE740606A31A
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 21:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e1EF79C4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771D91F01825;
	Tue, 27 Oct 2026 21:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793136540;
	bh=WWWcVhVxOqdQnoFg8JcI83d9vlW3+m4zDR4iRyVRsZM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e1EF79C4R2/WD5PaUabxZfcmQsLuuMa9IJQuFl/yQkROJy/6FEye7BuQgyR7IgSJp
	 jcbne9E+QwvHHkFcyDBQTnON6hGZ+wv6KeF7VDERsqMA9anso41+J8f5Wzz/8GHrLW
	 +9i6HDnhUo2KQEK/anTjn5uBwZowkAqMgdH3Wt2VuysWbHhMBx+Rc/OxmO1OayyUq8
	 R229hWdJi4LJYXKFcSaEWtER/TIrdcyRKovYsUDI/gyaLXiaw3+HwmhFEg8n4BbY37
	 k6trHAllLxfXxmLJSR0ZXPAk5+NMkABj0HWWMJqJU31wAxdz7Kb0Zro75G8xMTl0IY
	 UBHxDGm7UiiGQ==
Message-ID: <sashiko-outbox-187121@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2] net/mlx5: macsec: free struct mlx5_fs_id after
 an RCU grace period
Reply-To: sashiko-reviews@lists.linux.dev
To: "Joas Antonio dos Santos" <joasantonio108@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <179313582625.87630.11382992904624255106@gmail.com>
References: <179313582625.87630.11382992904624255106@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 21:29:00 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> macsec_fs_id_del() removes a struct mlx5_fs_id from its rhashtable with
> rhashtable_remove_fast() and then frees it with kfree() right away.
>=20
> The TX (SCI) table is read locklessly from the transmit path:
> mlx5e_macsec_handle_tx_skb() and mlx5e_macsec_tx_build_eseg() call
> mlx5_macsec_fs_get_fs_id_from_hashtable(), which does
> rhashtable_lookup() under rcu_read_lock() and then reads
> mlx5_fs_id->id. A transmit that looked the entry up just before it was
> removed reads freed memory.
>=20
> Before commit d4ece08f4b1d ("net/mlx5: Maintain fs_id xarray per MACsec
> device inside macsec steering") the SCI table held struct
> mlx5e_macsec_sa directly, and mlx5e_macsec_del_txsa() freed it with
> kfree_rcu_mightsleep(). That commit moved the table into macsec_fs.c
> with the new struct mlx5_fs_id, but frees it with a plain kfree().
>=20
> Add an rcu_head to struct mlx5_fs_id and free it with kfree_rcu().
>=20
> The same issue was flagged by the Sashiko AI review as a pre-existing
> problem while reviewing the HW-GRO for PSP series.
>=20
> Fixes: d4ece08f4b1d ("net/mlx5: Maintain fs_id xarray per MACsec device i=
nside macsec steering")
> Link: https://lore.kernel.org/all/20260909065542.4B80D1F00ACA@smtp.kernel=
.org/
> Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/179313582625.87630.=
11382992904624255106@gmail.com?part=3D1

