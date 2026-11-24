Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795512054;
	b=DqwScwpYZpwyPDwp9dvtfv2Y4DJo+vq8OIvGWTlK712vE3vhJXAi67w9eDp6B1gnrvUR
	 yesgoh968sYJJD+/kCZkIXwehaxeMuaHZzqJHvasCIQogS/m6KBqleRAhuZtdegAwZKv5
	 cJSFLuv1gHlQfTVsqxLjRRHmvsH6Y90V1gl3U5rUN0apEUKrhebzeFVxqDfp3wr148aMp
	 ZQnqJ6iDuwxwJS0lGGobHXHBTk1TZy32Q046P1ShEBrOJWw13noQqOOZuhNOIo/YHLbBU
	 k2j9OoF8mKO3Bgk4l8BrnV+8ido9mlzzjOnWZP6VUyibh9W2iGUIxdFo+f4STxzobyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795512054;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=pHzQ2pmNiYCtQxJOo9+LNciG+A7cJheXKoOPoQS4Kfc=;
	b=Fhceozo8pVMTmhlR2raFfnQh6WRuEpOzzofNylBVspux7rlJHCtnEi8W/kGhLy4wO+KB
	 VDZ8Fa53lF+HsT1hmLjraJXUooKuDJXNZTkeAMxXs5WoVvXMy91ddoxH0RIN3H9iUYt/B
	 mbv2n11aIHKPAdlF1/kxALVasdviX7nCVL8JXQHGdEIKw1rOK/ghBm9ZhRZzYzX4CdQCh
	 Z66GdRdGTDRqvMJeEEJptXzdyeyiGMy25ex36aLtJ6Pq+2GgHjSmB9RZ8RqI86wyCpwQm
	 3eKeZ4lQXhBgsXfttvh/MIJAGe+5TLtXKOkLzJBpyKW0kvg9e72OK/timmgA4xn5j1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jCN8gvWt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E10606A68E
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 09:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jCN8gvWt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E161F000EE;
	Tue, 24 Nov 2026 09:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795512054;
	bh=pHzQ2pmNiYCtQxJOo9+LNciG+A7cJheXKoOPoQS4Kfc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jCN8gvWtETw6ivqPxGreomInZlk/xjvNG6e/7PDbUqSXgoyE+B4YfN4c+J03zVGnD
	 YAut6BPxrDtuOWeJ3ABaZl55IkVoE9jFT5wFPzy/jWxSXA2HozrUOhrbjSEJzaKZHB
	 Pv+QAVYg0rfNbi1/QgnzJnSFCcZZ7lMcp+X5ePL4J0nejGRanDE/bcHTqtQbURSHk7
	 JHuu7TysGf7/B5dOA8YlvrjEkmhP9NxSIzRDysqPLwBqNmna7CMR5NWUgWodhmrgOJ
	 EpLalCoEK1t2I1IYqPLfVgKcQh+6Jr10fyK/W2mLxTzbujRL9aBa0klD2SLyCh9lIG
	 43vGBiJKkMMog==
Message-ID: <sashiko-outbox-230824@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v4 1/1] net/mlx5e: fix NULL pointer dereference in
 arfs_create_groups()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jin Qi" <jinvas@126.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261124091455.1714-2-jinvas@126.com>
References: <20261124091455.1714-1-jinvas@126.com>
 <20261124091455.1714-2-jinvas@126.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 09:20:53 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> arfs_create_groups() creates up to two flow groups in ft->g[], and
> increments ft->num_groups for each group that was created successfully.
> If creating the second group fails, the error path frees ft->g and sets
> it to NULL, but leaves ft->num_groups at 1.
>=20
> The only caller, arfs_create_table(), calls mlx5e_destroy_flow_table() on
> the error path, which calls mlx5e_destroy_groups(). The latter walks
> ft->g[] from ft->num_groups - 1 down to 0 and dereferences ft->g[0].
> Since ft->g was freed and set to NULL, this is a NULL pointer
> dereference, and the kernel oopses.
>=20
> The same error path also leaks the flow group that was created
> successfully before the failure, since ft->g is freed without the group
> being destroyed.
>=20
> [ ... ]
> The fix has not been tested: the patched kernel was not booted, only the
> original crash was reproduced.
>=20
> Fixes: 3c6d5189246f ("net/mlx5e: fix a double-free in arfs_create_groups")
> Signed-off-by: Jin Qi <jinvas@126.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124091455.1714=
-1-jinvas@126.com?part=3D1
