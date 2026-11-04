Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793812426;
	b=CJnmoOSHRhR7VaDC9fC8xZhbRNqxTE17g22J12g+FDbt84ELgRPYpnusePIDuv+8yQ12
	 KwXB9TfW0P/Odc5SZVfnInRZvpn0wY9RTyoZWIAsWW7Qai18gRSV5gjniZ/A0HvJ0tKfX
	 n8+8Fhkpkwhak16DsrxibYrcOt0OiQGejSx0Gi+f8MnSmujdtlFpsoU9Coyh+1iMbFEgG
	 KkaEaswSmntgPQ89FCK9zD1LXrpfqimcgMivWH6Md0cOUu90vl1xu4HHIY45zdSxSCohh
	 AGRaARchFrnfmEzt1oWwAVrGw9m+uK8/7mIJlTVyZgL/+GwZdkiA8Am111BLEU6n7tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793812426;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6zZ0UNQ7Sx30+JfacFgrx4KLx1DKMXUFWx+kNQbGSes=;
	b=NeaR1dsszPx5lO92UzQDxXguw/QYWCz7wveAxDydKL6iug/mcNIsaTLuxNmRtdGb+4Zk
	 JTRfbzimP+26CSqwzyhy14ShTjsMchqbIKsmuYbAX5DSbKpNDz1HTL9RGQvCN1UMRGeiY
	 6ldkBL6bkHrPT8k2lA5UPOsYFOsH/Hk+H/F4tk5p70n2gJE+M5IKQUiA/R76KSDdNFvOO
	 OcKtvnknh8hD5cgBFot8AoULbakjpHR74UIj6uyzFkz9eKWHFg/B44iBKSd7n2X7tE6tn
	 kupQy9FKCqmgtF4YC3GkhmUKL1nEmLE6U3ltOElApuNgAtHgghsrQyDAbf794qydd6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="ARla/0Gq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E582606A336
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 17:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ARla/0Gq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B863D1F00919;
	Wed,  4 Nov 2026 17:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793812425;
	bh=6zZ0UNQ7Sx30+JfacFgrx4KLx1DKMXUFWx+kNQbGSes=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ARla/0GqOifTanThmmsU8j6s7cX6nCYgfjT7XZ2GzzwwXjGrSWnQfQka+qVDrhL4r
	 MJO8699C/Dc15h/bpUTtGx1lXxo1bBVP8SVm3cZETmnjmJpxi6LGcl7eXO+pxr1i9A
	 xGDpBu2MD5N+NqnUvyNofpOadnuLeKd1OWALPd8CaLFN2kH3WM9StPLYkePA9wTEbZ
	 xhYSN9a+M6WWS2mXyGxJ9YUpZgG2M3oXNJ2mVUVcxvL45DoMkfmVXtOsFd0oO3Ptdl
	 2E00piiWFCqtw2G0pTyMbu0/rDe7JL/7TM/Wgbv9JGcAIKJyopXgDCw0ShuDP6tl0C
	 qkgSQOmbyrwxA==
Message-ID: <sashiko-outbox-197731@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 04/15] net/mlx5: LAG, treat virt LAG as a
 software managed LAG
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103171009.563034-5-tariqt@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com>
 <20261103171009.563034-5-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 17:13:45 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Shay Drory <shayd@nvidia.com>
>=20
> mlx5_lag_is_sw_managed() (renamed from mlx5_lag_is_sw_lag()) marks the
> LAG paths the driver builds in software - the LAG demux and vport-LAG -
> which must skip the FW vport-LAG commands. A virt LAG is
> software-managed like an SD LAG.
>=20
> In the same manner, block multipath LAG over virt LAG as well.
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103171009.5630=
34-1-tariqt@nvidia.com?part=3D4

