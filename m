Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795141253;
	b=UuPNqiGe7jJBFwpafbfHuAs+miUJU0ape2mxXNyzmr6DigltU5xg2g8H5dvp9xB+yXkp
	 YovQV+Ab7JRvqfbnOJPYTMkFu6K8p/EXTcvjIeulJtTHiWn+ts20n2dCVALylYKQl3x81
	 lzDA+ici7gIwIf6bbWG4NrF2wiQAWz/nzYThQx0Z7LwOzQAoaV7FT5JGkSexvIzl/Uis9
	 TBcXkWX2xlLtELNptUIklMExnW2YtnH4rtCqR2f0z6/DOc4VxP2rfAOS/oqZx53dIXp6O
	 S+TWnsrGbpoKoAhdAnCv2DTU/c2ftJsU4/pf3GRrRXdrGoSArWaRE1bImoI7cJP0jAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795141253;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wRDq3TPYEoZh4i6noPdHBhPHL6Lyryo8YwFPp+A9MeQ=;
	b=v6xS5ylNTUNvK6CN6eDVxyF6Gc7FZk4lyVwdmkUco9FHMEcJnWHSBvz/gLZbIRSu9/91
	 qKxXp4HFz7twf+oIBOK97tfOJrCCaf9+fddehC7gkgD1oi+2VDAXPGaOjrQTrcuwW713P
	 AAZ2ARrzhApPns5thKcLW1fgdvkuEcEtQixIWmdx2T0oTdINqWnyv0ttAXD5omqPrho9D
	 5iNxf9fT0dhKuiMQ+6qLlDqAug3xFjjNUIY8GdQLxmqSrnS2MgYTRjLymaKypQKIdDtHn
	 MzRjc7ZuUzkp8mf4LbTwXSmAy/D9W/cut+6JC/TgT8mTBU92ueeU+xfEwB07ZzmBcPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kTAEzq0Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2E8606A320
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 02:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kTAEzq0Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413281F000C4;
	Fri, 20 Nov 2026 02:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795141253;
	bh=wRDq3TPYEoZh4i6noPdHBhPHL6Lyryo8YwFPp+A9MeQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kTAEzq0ZnnOIGrHzeCWhHnMoWk9ewYmjpEo9R4BvcFi9ygUy6ZXwxxeC/P0vhDXjH
	 L9eNfyKR00uYWQrGOLPl06jroHw0C99Ws3rzp6oR9ZRzExCFf6uOe2ASFPTVO1lK5N
	 xR2mpuDEeqtIp2HYBwsX7l3Oy3xh6qtWW5PzWzhyBBOVSM/PS93cZDPhOCMLWVx+BR
	 Fows9jV9uzmfE2BqpIKf7Vn7KrK8EPvd/d6rBqwBg6fiM4F261IadHctAg7W+n+dd4
	 No9wflyMs2gRFASNo/z4LprrIHR4BS5lLBrdPiSPWaiWm/5j2y9dtVdzTco/Cgiavl
	 eQusckvgqMwwQ==
Message-ID: <sashiko-outbox-224349@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2] net/mlx5e: Skip hairpin entries not ready in
 debugfs dump
Reply-To: sashiko-reviews@lists.linux.dev
To: "Changyul Lee" <lcy8047@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261120021557.1630138-1-lcy8047@gmail.com>
References: <20261120021557.1630138-1-lcy8047@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 02:20:52 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> mlx5e_hairpin_flow_add() adds a new hairpin entry to hairpin_tbl and
> drops hairpin_tbl_lock before creating the hairpin, and sets hpe->hp
> only after mlx5e_hairpin_create() returns. Other users of the entry wait
> for res_ready, but debugfs_hairpin_table_dump_show() does not, so
> reading hairpin_table_dump in that window dereferences a NULL hpe->hp,
> or an ERR_PTR when the creation fails.
>=20
> Skip entries whose res_ready is not completed or whose hp is an error.
>=20
> Fixes: 8a0594c09610 ("net/mlx5e: Add more information to hairpin table du=
mp")
> Signed-off-by: Changyul Lee <lcy8047@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120021557.1630=
138-1-lcy8047@gmail.com?part=3D1

