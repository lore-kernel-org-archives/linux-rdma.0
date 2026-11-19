Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062482;
	b=pBzU+FWAC9I2O0uRtyo5AIO+f+um2/NmVQdn++aBO1dGLawl51aFwnQjgCiePrRW8uSD
	 Ib/JlWhEOcVRDavUxkqZjPxhGDf+GkLcvfda4M+sbtXmHUT+rDpl9tgQxCgw2ym7xlRb9
	 tZwXS+xTBBFxImKrRvmv7K1GxIBcvzCHXtvBrBuVYNrOc8VgOxh/H+Q065bpMycfwkO70
	 Npp69j/b5Tck4yfF5a71sJp40w5TOeVRoFesqZVeFGd4ErmdY144WbEdZFOx9acu3gx0g
	 ScWXfx794yTnMODT5FEZT0BdOuUSOrig8TigYBcEkHfDLUqbpXolQkUtjU1JOBUlmNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062482;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+4CFzieproqvdxIUhFXHkgAjkDTHHeByYlEj0m0gD7I=;
	b=C8WAyiy0kHOBb+aUB9eS946vhl048DrlxUgEKyga2awdZnh6gpspaqbHEW6ujIwEQT5S
	 T+EKZ6zyaw7slm3S2JR3Ygn6WZPa5hyn5sCe62FSDivKo01ZFxL+q5toEmFM05KX61JnS
	 Ew1JMtgRwZp1DKViSovag/jEuTl9gdrUEzbzZ8sGl+uE1VjYdsGfrVCIcv/kIX+sjQ3hc
	 +I65ezwhzHxw6Sc4G/ItBLqCYisNKE4FDuJ9bbz3/rhMYfYwMD9E/qHILtK0kzzHKIj14
	 rdhDTf3dGynoozvKcTJ6ge+jUwq9KK9s5rJsUSbCQ1962xWaqL9j4X2PwjYDOJOcJiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NND9GcOL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821B9606A320
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 04:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NND9GcOL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC381F000C4;
	Thu, 19 Nov 2026 04:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795062481;
	bh=+4CFzieproqvdxIUhFXHkgAjkDTHHeByYlEj0m0gD7I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NND9GcOLWHAd6IRyWtxuNmhm7h4DOxE/IX/WYM7rWKWmN1KX1V6GhW23mpekRLMyt
	 A44ZHbPxITquXEok6Gd6SRJmrBTCgca19JJqT41Dg3Icsht5jKlsaGePmLJA/8vlMb
	 EVEH5NOckcplrDTNDGbgmDrNS8O1qoAhy0HWGPzJYSjrEfOZKEMJ/lzmGHmk/QtK8/
	 8w5pFWC4PkQ01TYZYuQqJjZjDwJFRfmTBsSkLWFojcyY6noTmQbFMevY32NDhHXfno
	 s1qyh2UqIQPZHvxvfppchdv3NZQnE9pGIke28kEkrspFT4CM17YZklJaTbrheOzxBo
	 YYKzyYsNAGpNw==
Message-ID: <sashiko-outbox-222446@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2] net: mlx5: Allow police as the last action
 of a TC rule
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mohsin Bashir" <mohsin.bashr@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261119040010.1405900-1-mohsin.bashr@gmail.com>
References: <20261119040010.1405900-1-mohsin.bashr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 04:28:01 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Mohsin Bashir <hmohsin@meta.com>
>=20
> In switchdev mode, mlx5 offloads police only when other actions follow
> it. TC needs no extra action for a police-only rule to work. The mlx5
> driver makes every police rule forward to the post meter table, but for
> a rate police it adds that forward only after verify_attr_actions() has
> checked the rule, so the check rejects it. The ok result of police is
> also handled as pipe. In TC, ok accepts the packet and ends the action
> list, whereas mlx5 goes on with the actions after police.
>=20
> Support police as the only action of a rule. Set the forward while
> parsing police, as is already done for police with mtu, and forward
> an ok result to the end of the TC chains, as the driver does when it
> offloads the gact ok action. This also changes existing offloaded rules
> where police is followed by other actions. Before, an ok result ran the
> [ ... ]
>     ip_proto udp dst_port 5201 \
>     action police rate 100mbit burst 1m conform-exceed drop / jump 1
>=20
> Cc: Carolina Jubran <cjubran@nvidia.com>
> Signed-off-by: Mohsin Bashir <hmohsin@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119040010.1405=
900-1-mohsin.bashr@gmail.com?part=3D1

