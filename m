Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022027;
	b=I7xSB56PTrM3CX726xlLcbibin+HGZkZRb/EAWTGsBSKz0KQgeBu+qS1oHQWC6zn6YPv
	 W/6YEgpZb1OrMyOJzR0Uzp5ceVT50L/OGHuoc8bEbxivQi3tK2UkleWT67Nf+3v2O7SC6
	 F9c5Re7OeeHiV7XxfL3OnXp35pvJ2mZgQS2CMqcjvLGGOr5n81XYRLekEh/IlFwWCcSwn
	 0OsXWn1WfBuh5k1hruaBeNPhsIhJzrDR4t790TO9VF5WSnPwOPDpWdQ7xDstfTQ9ScE2Q
	 4wFH0p2UeuCACgXJ7QyrFhj90v6r81oqdmpC16qr7jeAGewYram5b5IEcVvKsTp4XPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022027;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=vviQGxoJYJIJPUQexZ6YoVV6krsAmXRkFruzYOWbyfA=;
	b=S1jAf5CKjjPcVacywFpwnQ6oL6QBVwOX24SiHqUKlJiEqj8aoDKzfyLD1jSN1tuh6Ctr
	 o2zdw2zvfkZWKnCnagAYi3G2VOZZBcnp43HeUi26VYm+akBTpsVX+1uYiH1JwD/u/rxI+
	 19Z2h/7zyOwreSDiNBqnSrotZK7c+QW9IsYqdYoV7EzXFc0kWhXHwtZke/CbdZGx3CMUt
	 SYJQGalxvtIe4FXvVepQXQ0o3vEd/bvZKfA5kLLBUJOdXQ9beViR7cdC2LHc7+KK9b8BB
	 fp1o1DBszZSq2/FbkBTyrbOx6PtNCcjREkeVxQwPvad1SAhzoNsyi6UiMTKfWZMJEnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="ToucxLs/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F11606A331
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 17:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ToucxLs/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384551F000C4;
	Wed, 18 Nov 2026 17:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795022027;
	bh=vviQGxoJYJIJPUQexZ6YoVV6krsAmXRkFruzYOWbyfA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ToucxLs/y46IYTSb5nEFkLgnLLvplw2U8OBfMM/IPkndkmqietyelXgGfgXvQY1Ok
	 nfyTGOL2LWsD1gBczFJThDPKHGlv9Ec/0iLcbisshWHAgDpi2ZHmM3EUp+kg092kE4
	 QnEr8GQWMYfjVkxasum2Z8RDAspWXt41xh1qe4jfZIh955Y/D5mXoxmsr+hIOwLC4l
	 59TzHs9O8dise5DqDghK1QKkzXwu7uPG+E11K1Ls3YakpKwyzRoQ9uIiaNt3TSLnHT
	 mae8RtsQK86945qUKlBSMtgL60caB3wo9DTOuMdjQKgetshFm55OdeFuCYQvslzfgC
	 t0H/kOzs6n8dw==
Message-ID: <sashiko-outbox-221611@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V2 rdma-next 10/21] RDMA/mlx5: Remove duplicate
 mlx5_ib_umr_context struct
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117170914.27410-11-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-11-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 17:13:46 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> mlx5_ib_umr_context in mlx5_ib.h and mlx5r_umr_context in umr.h have
> identical layouts: an ib_cqe, a status, and a completion.  The done
> callback used mlx5_ib_umr_context via container_of, while every other
> site in umr.c used mlx5r_umr_context.
>=20
> Remove the duplicate and use mlx5r_umr_context consistently throughout.
> No behaviour change.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117170914.2741=
0-1-yishaih@nvidia.com?part=3D10

