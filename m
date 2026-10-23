Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792799746;
	b=O0CpkcYrQI+aiI3RcEh4L6rvHyeh4kZxwRw6W+HAEJVjhbaZujktkFbQ7hT1xiTvtpQQ
	 4qRcXTIGuR9G/V+80oJ/zlFcxD6l0TdUvhZEFPiUFtycsMG4ObQXHi2rBYo7iChbl5GpO
	 E9UP6D8clC2qu7Ow5GwS8qxvupcgK+Y4osSLu7T7ElnsCaVrQ/UoAjvULbKd6d/onHcln
	 O+aKeiudV50bdNGvJgnbp74qUXLf4W9qMzPsuRlqs0uIQniY6/fegrmXMmZMbTIoG1Q15
	 kBrsCH3P/Q0RI+X3Qki0APFZOH2p9AnAIl+uSQ3TEfDTfcJG+yZYHKgf1U7ZrJcZomQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792799746;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=iDKDuMEDsm8f1/M0SDuQZlUY/c//ezNfbtlUfGrIGhA=;
	b=M28qnd19Wn+ZTtwYpXoOpmuesa5b1BTRvr0D52Y660SqAsOWdXcbZ5dIZVAhOZGDvyIP
	 krVsgcp50hlR5U8EfIOwbWWaERhOApU+pwlhlLuualO07/rbwW0MXKQd+3Jz2nyJPyTXs
	 4QNX4uqFC5de8h9LiQxx7zcqaup4UfZKmgqK5R3Xyc6qG78uHRd+j8hb9T0A8kQ/yM82g
	 0i75W6P10gZBBIXr/n1ZShtFJ6hkL4vnwXQR77mnhYOuBcSWg/9qit19vDzsW1B+YgqR2
	 C110uXrZderW7ITgK1CfNy9RLCfsvLIIBCTdgoAkDJXttLVAMYYCi8P+PwaiBIY+zNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I+C8LNM6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C93C606A31B
	for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 23:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I+C8LNM6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089161F01828;
	Fri, 23 Oct 2026 23:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792799746;
	bh=iDKDuMEDsm8f1/M0SDuQZlUY/c//ezNfbtlUfGrIGhA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I+C8LNM6KuLYqdah13GE4vzkhM20y+ZNvi0+rDS/PEVSQWDOaGwklRVMmPQVjRQlY
	 RVMQCRd9UY2x2fNUV3YeXfUByauPseuP4kNLMw7gF5jl1EbjE4SHEBB0cf3kcKOEBo
	 QRWWOEiRFY2gnmLKrPdl5lsqwvcxUeili3cQ8Mc/u7IuLw0Wi3yvZYdiPUdwMjvF42
	 J+vTF0CavcX8xduHDTyXt5+1PSFLa6O+uS9CfMiAzO/Ra6F8FV7rK4zj9eMoyCm/P4
	 f8t/CgHjm0uPezb6qHO6aYm6gJR1Nlf8GaSmlDCd+FNGBtkfbCFq69rIDj1yWF7Sm+
	 o6krKml0VU3og==
Message-ID: <sashiko-outbox-183439@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v3 1/4] net/mlx5e: psp: tso: replace only the length
 in checksum seed
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261023234640.1459291-2-toddfreed@meta.com>
References: <20261023234640.1459291-1-toddfreed@meta.com>
 <20261023234640.1459291-2-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 23:55:45 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> for psp tcp with tso,
>=20
>  - __tcp_transmit_skb() -> tcp_v6_send_check() or tcp_v4_send_check()
>    computes the checksum seed using the addresses on the socket and the
>    total length, then
>=20
>  - mlx5e_psp_handle_tx_skb() recomputes the checksum seed using
>    addresses from the packet's l3 header, and the length of one segment
>=20
> the length difference is expected by the device. however, the
> difference in addresses is incorrect in cases where the l3 header daddr
> is an intermediate hop (e.g. IPV6_RTHDR). this causes every segment of
> the tso packet to go out with a bad tcp checksum, in this case.
>=20
> the fix is to replace only the length in the seed which tcp had already
> computed. this is also what tcp_gso_segment() does.
>=20
> tested on connectx-7 with the rest of this series applied, with a psp
> tcp socket whose segment routing header's first hop isn't the final
> destination, and the peer checking tcp checksums in software.
>=20
> Fixes: e5a1861a298e ("net/mlx5e: Implement PSP Tx data path")
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023234640.1459=
291-1-toddfreed@meta.com?part=3D1

