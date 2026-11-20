Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795163662;
	b=kjPLduBLknQuS7jMNCbN/zc+XtsIqWhbg/NzXbFTL8RUkcWc1czpFXSMTXU3W5tLy2RN
	 qIVTJTcVUDuwlR6qz7NPB+eCm66vXrB2JOyZ0huICfbzukQLrsChO85Q2PNz9KGYgxN8F
	 nZYH4IgeSycnnt5fu5WuvBqyw4BBdKaltm/95dURvHax5yZHKBr/PKaVrze5qnAxUmbYC
	 Ucxj4JgByYSAjfxi0O3InXTVRtGmTcRb67uzIZb4If2173Hs4ifXo1csc6xrBhH1uShPF
	 KN5kkHg2HwqW4/eF1hwifHijCwo4P1Os5oxdLtmICcEjx6kEd35qtgjyg7JrsSkWufg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795163662;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8NlMqCWZdc5XaNCmdCfckQsoZChgm8yQBcZ/xC3gNOg=;
	b=CqT27zuSK5WBTPHtoVGAOI86DokxqjxU5DK2mKNomVryWk+5V73Jixln1zrKAKYXg+TL
	 x/Q5U+7vi9HAnYlg/vI/6FUEwsvpqN3A1v9uBXI45hMN26Nprfk6T04bTa5LqtMS9kaYV
	 EnShkW8DjOJK9jXap5gF2n6d8SHfp6pHdxt5sEKjppNYvPaFHJaF10DVvh3MRJsYHDlKz
	 556V+OQOhG73SMDzStSyudEUz2d3at0TQeRvUGQKPhznedZgDsqWaTwn/hLfpBzCyOPJi
	 bCkfZOCEXO2mNMLTBV42Q5HlZknhSs4RITWnGjxucSUujR3HHIBSF4SFdZLbDQPFUcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WjaFSYVL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60881606A32A
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 08:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WjaFSYVL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDC51F000CA;
	Fri, 20 Nov 2026 08:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795163661;
	bh=8NlMqCWZdc5XaNCmdCfckQsoZChgm8yQBcZ/xC3gNOg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WjaFSYVLL+hjuvjcp1nO4PsxYj81o5qJXdnzO+9PZVIEfF6m+uOtv1706d34pb6CJ
	 iltFYylahVstC69h9/oOyj+cNMY2L32EUnbgzEuWoG+TA0P6FlCBPkeHfrcCKRdjqC
	 5APMss4c3qxWqbOXDcB0KmMf3Rw89AvlNZBs3HAfhMZP/7Cq0y9XgaU4e97kaMJZjD
	 cqrNcJ4sajskzdbzyVy3teVa6tUXGE+QJGJgtcpHdVoXdPDvTwD7uWtE0GLbppXkaq
	 akcLv5q6Mx8SODKIk0pqE1b4jp9ODNm/Ag6HK0rgXiBGmY2dFkk66uf+jtZpbZxxT8
	 ChlJaES21dbOQ==
Message-ID: <sashiko-outbox-224744@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 1/2] net/mlx5e: Remove documentation of
 nonexistent counters
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261120083050.2540739-2-tariqt@nvidia.com>
References: <20261120083050.2540739-1-tariqt@nvidia.com>
 <20261120083050.2540739-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 08:34:21 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Gal Pressman <gal@nvidia.com>
>=20
> - rx_bits_phy never existed.
> - rx_mpwqe_frag was removed by [1].
> - dev_out_of_buffer never existed, and looks like a duplicate of
>   dev_internal_queue_oob.
>=20
> [1] Commit 7e426671704d ("net/mlx5e: Single flow order-0 pages for
> Striding RQ")
>=20
> Fixes: 8ce3b586faa4 ("net/mlx5: Add counter information to mlx5 driver do=
cumentation")
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> Reviewed-by: Nimrod Oren <noren@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120083050.2540=
739-1-tariqt@nvidia.com?part=3D1

