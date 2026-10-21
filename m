Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792569630;
	b=moepxgGCsknfiHqxJJcI3ueIFusGNQttNYJtorA7sInPE3aqhZ1NePps8X8P6hmjTbwf
	 s8ij1rh+RC8O1vHKOAz16cSWe9RKE1HFXz0iUkOJevfzwvS69d1KAflxnZvdEWfo4x/iL
	 KRYdAnGmWEGpDBx2G9eQ+fSUOKdb0kCQFGBX4GtSKv5Eepi6Isa6kPjTW1s14wF3n8B8V
	 vuvo25Uuv8gOSBNioyOm4ebUWOGN3eSA2H8cOWugfXpm+fGvNlE65UqlgNSHcoL9k4Thb
	 EgaQwJ9L7/jvyN9a8wMnHKaDKvhvThPWqY0vSwbQ248HUYMxLNCUB9tYG4/UYheEuYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792569630;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8Sy/wgJrPuaYnCGLsqZ7ULCpnWsvJtqeLqW19YJscE0=;
	b=zvtA49VH89siH0OCdiQ86ruffm5ldBvrac00c+XOvAsgEw0UY6RqBGrLIVa3BX4no0Pt
	 yPkwz7gfKQifzGUY1CGNRgwhaCCUDVUxGUKilBhUw4VLSe5U+dINtgHI5BQnSsOpXerju
	 RrFF2J5ctdDzSpXkpvLgWQhSACowEFSN1tF4Z+emwCEF++d37wpuADT4RiQJ9tVWXr/xN
	 m0IqstXoIfUvLiID8VEXSHMCJN7fXdrZU/gu2VtMQs7YXhkF7JBcDy61BbsHfmER92Q2O
	 SQORPmuIITaG5i/9sWG+QpNqskALHOtyEhzUF2Qitz4eXjxDUVnDnsv2mTJyZF8KqUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fGaUCRhx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D3B606A31A
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 08:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fGaUCRhx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A351F000CA;
	Wed, 21 Oct 2026 08:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792569630;
	bh=8Sy/wgJrPuaYnCGLsqZ7ULCpnWsvJtqeLqW19YJscE0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fGaUCRhxSyRTDTkOwqo72ufAyU7/LLWiFNfb1q5Aut45Ye7IkJbnJ6nsqUgbTg7xd
	 hcEs716d+OEQZTmRNs82nfoLx0ka643CrS5aa+v4z6fHcfDy/9XqxoSrCRPgwtp4jt
	 Oy+QlmqQg1ekszsZfjZTFhY1BgTEybmEhvQCRSuJZkjOjDqReSBy1bImfp1pfJ8Bdo
	 oVuKBy5FhNJtcQLuQEoHXZ7TYHDx4J2gkXrbA/JCAa3I+xN1AUEK/qxM9hn7FaWmTn
	 PDxiLHoiWcKn949PElctbq/VIzGyqAwnTxY0/Z0XgZQIju52+5IfG+fn2Q/8db7yCM
	 UPolirf9pen4g==
Message-ID: <sashiko-outbox-179934@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 2/3] net/mlx5: HWS, Fix heap buffer overflow in
 insert header action
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261021074949.3471704-3-tariqt@nvidia.com>
References: <20261021074949.3471704-1-tariqt@nvidia.com>
 <20261021074949.3471704-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 08:00:29 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
>=20
> hws_action_create_generic() allocates only a single action struct,
> but the loop writes to action[i] for each of the num_of_hdrs entries.
> When num_of_hdrs > 1 this overflows the allocated buffer.
>=20
> Use hws_action_create_generic_bulk() to allocate the right number
> of actions.
>=20
> Fixes: 504e536d9010 ("net/mlx5: HWS, added actions handling")
> Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
> Reviewed-by: Itamar Gozlan <igozlan@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021074949.3471=
704-1-tariqt@nvidia.com?part=3D2

