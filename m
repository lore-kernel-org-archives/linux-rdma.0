Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794994194;
	b=WYpXEk5n1cf4SL76l3kFhLVQswhbocNJqteW/B9MIE3mSIu86l/R656adelSHZPfhfOR
	 Loivy0OwZzE0e8uN/ZUVHV6ggwv2sIaSda7SxgKdVMf0IwbFK6jYkUFIRVlvFkCY58ZSd
	 zpFIeDrFGD/m+XlM7O0FMv7fJ1/B6UvhXX/K4YVhC8DjNgl6hIGETyBafWzCm7C7WUZz3
	 9o734LD4yAjZwg5yqHyEqV0idXvP1wyRupyiu4KNfW91+0/9eypRzq1lrjUDIGw0R7fDC
	 43M8nX1jld+xaWxWmPh3niC7owgzOWDD1xozRXW8Q83sfG99HLA4ylGG91ZYisfpxPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794994194;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=c7v/b2cTf+IdeT/B0m/mLb2GE/ZL/cchC3ar31nrXU0=;
	b=S7K84H+2wgtQvlTIyOc1xqabDkx6SgvArAoWJFYrgVKUF9QrBFX+9hw31iZrHH+/xcbS
	 VecCxCuQZenfNDOnbYEpqyK6X8ElDJsuJ9/7ZwjxjfDzTIb4rDuM/z93xTPMcGnaNwHV6
	 oCx2rXzIsKx13oz2rDf1sTHXhkb0H4GWAtNNa/+7ipVoRwsJixqKMm/bh8YWV/NIgY5/l
	 IMlAdQ1W1ZHPtdKCrQGc3tQvmO4zBj6Q0zr9UMooCycL2Qty0uttCgQtdSX5Gpffly1o9
	 ghqwRzd9Mf/HVkveYedIrZpgGSgKYuMHJLaozJJYvRcNo4/qST9WnfwPM2Jk5QE1xpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bEOs7YCQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7C8606A32F
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 09:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bEOs7YCQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13021F000C4;
	Wed, 18 Nov 2026 09:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794994193;
	bh=c7v/b2cTf+IdeT/B0m/mLb2GE/ZL/cchC3ar31nrXU0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bEOs7YCQAKIZfMqLd4Tly2hnjx6kfLnM6j3Bk2bs/ATMZxfEq52Tbzf7Z0jb3R6eG
	 lwtraWsjBMkq8BCMEKN3QmaeM1wghgeDGgSOnYbWMU/YeBCfDzRHHCI6zyJYw4Qypm
	 Ml4l+nUTnYU9pGUmfJ3QAwF14+1EaswUb80fD7QD3JJap6fjAjd58830vCkzBpkFhW
	 hAJIauPb4OTZvxS5WraZDOUyTvYtwZCTbi56m2hYYfxclZyMz5gvy+UQBhjbQXFusK
	 5T75EbpkF6Z3rpaXQSVwGnY2d5RvPeFerclRol31xcx8LKKGl+1ZcNsaCjHJFNS6oB
	 jwzBYAk/Hzn4g==
Message-ID: <sashiko-outbox-220567@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 06/10] net/sched: cls_flower: add enc_key_id
 mask
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117092915.255194-7-acassen@corp.free.fr>
References: <20261117092915.255194-1-acassen@corp.free.fr>
 <20261117092915.255194-7-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 09:29:53 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Flower only matches enc_key_id exactly. A block of tunnel keys takes one
> filter per key. Add an optional mask. Without one the match stays exact.
>=20
>   tc filter add dev <dev> ingress protocol ip flower \
>       enc_key_id 0x100/0xf00 action ...
>=20
> cxgb4, mlx5 and nfp program the mask. sfc does when its firmware supports
> it. hns3 and ice reject a partial one. The previous patches make bnxt and
> mlx5 tunnel mapping reject it too. i40e and iavf never program the value
> of enc_key_id, with or without this patch.
>=20
> Hardware holding a 24 bit VNI truncates the mask too. This is correct when
> the key fits the VNI. The previous patches enforce this on cxgb4, nfp and
> mlx5. On cxgb4 a mask without a VNI bit would also drop the tunnel match,
> and the cxgb4 patch refuses it.
>=20
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117092915.2551=
94-1-acassen@corp.free.fr?part=3D6

