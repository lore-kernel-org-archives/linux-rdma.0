Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795010661;
	b=wDxbtSQJFXL3SlXI6O8Pm8yENfRJJ8sI7hL5VPUmKmzXNH9KtaXWOPikchqfuhRymK/6
	 mI2RzuMDo//0w8AbfSItpoalU/SKuwnub4dnQ8Tvhrou5xe3yw+r5XwBIFne6gGjBk5tC
	 Bwl6AjMnNJy4SiTwI/7CkjnakbHCjgvp6DIoBhdG67x6SVQ6nwKtg+8lBrvC/YAwKu5Q4
	 0i/g9urOqRmcuSGr5/AcnrINmb6wtVJphJgQIknw6uFAb/a+ArQxBW7OZex0755EIA2V1
	 ZAdYl9wSPEaM9CDrkf2/ip4L7MLyhC6RqljqQtyd7cM/Ro3JfmHGRpRAMOj47ayJeKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795010661;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5ue/GPdsiI3jraTpSgHkStd9UPfcpGI+X6xulhMBRk0=;
	b=kY04wVGKSK7F42HGerKIoUw3zBputwjBLeSADMmA+xi/ublRCi0mzBtVng7T7xJRmeXT
	 jiRHppu0rwFHfG/vvezNGMwlnjdti8XCrLyb2dkjfeYNjNjUk0JChZtGkCkpolOBxFzb8
	 YIfdh1hmt17tPG3BQ/bRhHZsgvP96igfgjDueeJVF5txrvBIAaPf6wIu2/nkiZ41iOjKI
	 PMqnJKXAEolT8qluDHDZkcYgoIjjslPgCEWyw+fQm/k5l7+6Te++7fwqMkU2TuSgXWCKr
	 Of6Pf4QZuvjAWC+JoO0PxE9x53vSKQG6OdYOHeH8Mzd0SgfbrlAovc6VGx0kIA/M1MQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Z6nWWd/g";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615B9606A33F
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 14:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z6nWWd/g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152431F000C4;
	Wed, 18 Nov 2026 14:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795010661;
	bh=5ue/GPdsiI3jraTpSgHkStd9UPfcpGI+X6xulhMBRk0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z6nWWd/gYLjXjHegIfLKNUzekJ/7qo7WJQyTLNtPSS+Xqg1ywUnoDmsTrT8nb8hM9
	 k9SwN7b/zZ3BdXjeS2LQiGEqXgedE77bSRT5HIr6hLQEBEON79TCzptGGH5JJaDY5K
	 fHiIVRsY+YfCyAqx7UD5o0Ufp9j3IDNIqAcEQApTCj5I4n65AVtQ0U8B4af3To6nbd
	 8kXyDXT9jrM9VB/9eVBrsZ7EakA6Pnxsqq3/oUW4rp0h+5HLZcSyiaxXHZZ1+3PnwB
	 mkOmHayTSIMLHvOp7QyCT+N/unKS+IlXyWVZbRZeAtuSBNbHsMm0tWhnsMDNFYgIL5
	 nARyFZu50bAwg==
Message-ID: <sashiko-outbox-221140@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 11/11] RDMA/mlx5: Resolve UAR and mmap core
 devices via the ucontext
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Srouji" <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117-mlx5-sd-prep-v1-11-8efd124c7895@nvidia.com>
References: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
 <20261117-mlx5-sd-prep-v1-11-8efd124c7895@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 14:04:20 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Akiva Goldberger <agoldberger@nvidia.com>
>=20
> The ucontext is tied to one core device, so resolve the core device from
> the ucontext instead of mlx5_ib_dev::mdev across the UAR allocation,
> transport domain, ucontext response and mmap paths.
>=20
> No functional change.
>=20
> Signed-off-by: Akiva Goldberger <agoldberger@nvidia.com>
> Reviewed-by: Michael Gur <michaelgur@nvidia.com>
> Signed-off-by: Edward Srouji <edwards@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117-mlx5-sd-pr=
ep-v1-0-8efd124c7895@nvidia.com?part=3D11

