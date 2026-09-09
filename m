Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22511344052
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 06:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788936943; cv=none; b=nGBsL6WhLsKg7xl2Hwg/amP2CuAfxgGLrabInNE4Ji2aQqotVtxKynGJa2GLQsTzT4CJU71MwSYbYRv39i5NDyydkjnp8hm6O2Tgy52tgpfOGK4992dBRDuQilY00U/36ufD7fIBCj8ICxtOhHEf3EL+MDMZ5GkZHuMKiUQb9Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788936943; c=relaxed/simple;
	bh=Vj90T5VuoLZcJ7KQYgcEaa9I1F9oVPUn1/LQS95kNLk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JzbCs7jwAnk44dMIIJeRvKbABVCySUmPbU9PrXwl5g9JRqR687b0x/Hnhv550t+C8iRoyrnBi3jKTRqxWtqCWS37Y+eLIOT5L9zfCTE+i38UMNGyNChaHMTkSuc6Cy0xkUwQmM34pbUUBurW19cjgggfFO0F/yQa/CdAaQhJM1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BPZz6UUH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BPZz6UUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B711F00A3F;
	Wed,  9 Sep 2026 06:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788936941;
	bh=Vj90T5VuoLZcJ7KQYgcEaa9I1F9oVPUn1/LQS95kNLk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BPZz6UUHCQNYnPGfYJWlWa22BMobjGX7zQm60wqJaekUUbx5pReF8G7tB0vH2sm1d
	 3vslhsoyZDgSP7knvT/+ajz39hSb/fMAh6FndGAtfl497Qcr33VnR8moYfFP0n27wU
	 Zgq+1WzTHVg185Iwzpen8+P8GKAZAkuxecdujM036PJeE/DDPzkBZ+MtE4Shg4+eX+
	 8HuWHkA8xVJMwrJ9UI9GSIVKIm4XcoNjVUD+/3kAqNTYWEwn4OLLpUGAK05qgFd44o
	 96nyEyYc4dstuaDtENoBDr/CL9AA7dOoi7lQbzXPaJwLYz4gP5pgpjQuDFcbDoKM18
	 a2nJcUF9sMnOA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V4 06/14] net/mlx5e: ipsec: Move RX marker from
 ft_metadata to flow_tag
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260908065244.3799142-7-tariqt@nvidia.com>
References: <20260908065244.3799142-1-tariqt@nvidia.com>
 <20260908065244.3799142-7-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 06:55:41 +0000
Message-Id: <20260909065541.A1B711F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Cosmin Ratiu <cratiu@nvidia.com>
>=20
> IPsec used BIT(31) in cqe.ft_metadata as a marker for ingress
> IPsec-decrypted packets. This will conflict with PSP which stores SPI
> in ft_metadata - an SPI with bit 31 set would falsely trigger
> mlx5_ipsec_is_rx_flow().
>=20
> Define a new marker for IPsec in flow_tag and use it in steering rules.
> The obj_id stays in ft_metadata bits[23:0].
> Remove the unused MARKER and SYNDROM (sic) macros.
>=20
> This is only done for IPsec NIC RX flows. The esw path uses a different
> mechanism and is unaffected: RX handling in mlx5e_rep_tc_receive() makes
> use of a few bits in ft_metadata to detect and hand off IPsec packets to
> mlx5e_ipsec_offload_handle_rx_skb().
>=20
> An additional complication is that mlx5e_cqe_regb_chain() used the high
> order bits of ft_metadata to differentiate between TC chains and
> protocol markers. With the IPSec marker moving to flow_tag, this would
> falsely trigger mlx5e_cqe_regb_chain() to believe the chain is set, when
> in fact, ft_metadata is something completely different. Solve that by
> requiring that the new flow_tag proto is NONE, since only those packets
> can carry a chain id in ft_metadata.
>=20
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908065244.3799=
142-1-tariqt@nvidia.com?part=3D6

