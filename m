Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792783903;
	b=mjrXFt9I4+YMTG8sGHIXoz0GESYLhJF7V+kWdBIcAKhS2zL4zJeIRoHqc96WZjDfsTMw
	 wqG6kRmBzuinuj0BAN46yRj51Yoa4XSb5hM3YvNJuEbW12+vOEPOcQ87SLTCQPly3/Vvv
	 BAIdD/QnVateRsyrsCH8hfirS410M74igXf5y2AWNyPbx60R7eaqJX4BsVGMo0oNzopOP
	 iTT35hT/XivlYvsNGT9Nnbwg6+R/DzmNAqzuPpkJAeI76t1lw0cM+Q9oKS/lM9CS+dhOD
	 nzInAiU8dL28WSiTVyOWCdCOfdIhAMkIPcABuM67+Jo7pT9FeuXrxoFYs7pLtQnsvTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792783903;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Nt+siwDrXS8gm7ExYJ81zHbFU/NGH4bdDxFlV4gxnOA=;
	b=g19il/nLO4ebG3hHL+S2DGTel5XH3i8G9hEAKh2kOeTpps8E5QGLjcD6FZHxN9lSWAu6
	 Rx+TKsaCKB2e6apncZBma3YHWVfPnjw0devxv5OyhmF+4I9JYcjf9oqbDUGsPbI8LPK4D
	 f05aC7q9zo6ZDGhhV3qR4+8xVQgDRuwAhJdAIYydc3dXl9Lrvv/BjDd7OozpO/hIi3z1I
	 FEimGV6Cf6s6W2b+EN8eHFIS8lsn8XcrHlMHgyq/use6UEXSs1u9z741Iqnp0b2Txuszl
	 Wod0U2fSv2V0eKr+pCY1h1PtXjZDSMZbI8GhkgAHYzJLbArStqKRXUF4B2X5Idi4x+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d3WchMsJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF99606A31B
	for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 19:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d3WchMsJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4A01F01825;
	Fri, 23 Oct 2026 19:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792783903;
	bh=Nt+siwDrXS8gm7ExYJ81zHbFU/NGH4bdDxFlV4gxnOA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d3WchMsJ8ImSWtDkXKh7nEALQgvCRv1DJA8AxKDzoDlzoz0UOr2g4+ZIhugHBCIpE
	 buZdJxxyp3cMeKdvu9LGu+QefWJsA1rfXMc0rxgpNG0j+eg2GWSTPy/58v0N6+CwNL
	 aXMnK76DysWaTSDOXvm7GyY7Hak67T683l/ZJ2PtO+gDN4uwkT1iGm2I8WUCZqVFpv
	 rWHnocMP+hvjhgKMKeuQyQOTYtnVKWpYIqulkS6J/iq6QKkQs+Qg1X41d0VlfwsbTS
	 hSkUZT+oHgAwVAXO9+GvFz7pZ82ouopa91zfXmItNO/sJAW5XeR3d358XsRGZok8Fi
	 rEmxK0p8Bd/9w==
Message-ID: <sashiko-outbox-183119@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/mthca: Fix off-by-one in mthca_map_user_db()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Serhat Kumral" <serhatkumral1@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261023192348.11070-1-serhatkumral1@gmail.com>
References: <20261023192348.11070-1-serhatkumral1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 19:31:42 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> db_tab->page[] has uarc_size / MTHCA_ICM_PAGE_SIZE elements, so valid
> doorbell indices are in the range [0, uarc_size / 8 - 1]. Allowing
> index =3D=3D uarc_size / 8 results in an out-of-bounds access at
> db_tab->page[npages]. Use '>=3D' instead of '>' in the bounds check.
>=20
> Fixes: 56483ec1b702 ("[PATCH] IB uverbs: add mthca user doorbell record s=
upport")
> Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023192348.1107=
0-1-serhatkumral1@gmail.com?part=3D1

