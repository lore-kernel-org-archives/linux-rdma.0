Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795133274;
	b=rmI0TohN9zCgRMLNCv4cB4b+BwnTzT+gWnvdfceGUh+YA9VsC9bdNwenNc3k3lZdKgUZ
	 yYpRb3eqSSE+x41cOwvOos9PsJY381E3PVlWVHK7+j4hnBn3Y6HALOeY5EIWL7OeLdaQU
	 IbbAHAiibSNSK9ExSoaBxMmf7U5uqavILTXIFZJccqYkA5I2M15OkIe9qNX5kQ+PMSK2n
	 dp45LCApwi8N+6t5/N+++fKrWgQz7vOH/+4wpVgp6I5B01cnSt4iTN0zzRs0Ws15AJQvK
	 CuC+3u5++TZMf/UOZbAYxNiX2ouw2DdF4vkKKLzGvfZ+COAe0A/wPA+gymaLI4iIuNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795133274;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=p14ky9LT7qEdihKdrqhkp032AxKw2lTrFwt9WHV3UjM=;
	b=Y8Ag8r/axgiwg6n9ijX4fx10Lij28dEDnmYfZ8YBNzU+VtxUGg8pMGx1y1YXrc8A9Gor
	 nP1HVmP7c/kR6f0aZxg1Bh4q7ZPxiHOr5O5UGR3Z7GaFI2YbkYcPYWOJRZW8W3EE3/Es0
	 l8pw5Dj3yhsRUe30B5ThQo2jADf3O8Ert9Cm1FcMYzc46cSnMoPREppuFU+ZA3neG82Zb
	 IXFIIuqgQL8rgOLRo25ij/9oqS9xixrCYAnzqEYqFtWrTWQ89JE+zlFAekXYW5BsbKehh
	 lhiknw0G14L2OHgH8kyBUF5oTLJFt0EEMmoKfkRzf2CtgWMmgzzTyP4Zem6gsViZjuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PltXTqhT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD06060A2626
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 00:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PltXTqhT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF1D1F000CF;
	Fri, 20 Nov 2026 00:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795133274;
	bh=p14ky9LT7qEdihKdrqhkp032AxKw2lTrFwt9WHV3UjM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PltXTqhTNa7oBXTTnuL6aHxG6N8jFzjroceW6q1dWr+FF1OhrXo4g4swUaPM22UzO
	 fWLja9GKbD0MUAquR1A0EZXtIB/YFJngAN17QYLZfO2J42NxMVxAD5R1VYs90aVfmG
	 bkCox3IMmDKtTgQ060bO6hqfKqwmE9rjRCMuHSxBMVZo6PBgcftdPIb4YZm/71uQSL
	 U6zBVcep1svxlnO4RX9SqRhl9oCrxd5AMHFk5uUFvTUC53L4FdZNDPG1zC/mZsiWIk
	 WklOkDzjG/FXeOZYfd58n9usgSmW18dLo0g/bH894E/68v/YbIet6kcOqmEatZUFN0
	 5enKuhvy0Nf7A==
Message-ID: <sashiko-outbox-224230@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-rc] RDMA/siw: Reject opcodes a user send queue may
 not use
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Stellman" <astellman@stellman-greene.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261120000211.63217-1-astellman@stellman-greene.com>
References: <20261120000211.63217-1-astellman@stellman-greene.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 00:07:54 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> A user QP's send queue is mapped into the process, and
> siw_activate_tx_from_sq() only checks that an SQE's opcode is below
> SIW_NUM_OPCODES. siw-abi.h marks SIW_OP_INVAL_STAG and SIW_OP_REG_MR as
> valid for in-kernel clients only, but a user process can still post
> them. For SIW_OP_REG_MR, siw_fastreg_mr() then uses the user supplied
> base_mr value as a kernel pointer to a struct ib_mr.
>=20
> The uverbs device is mode 0666, so once an administrator has created a
> siw device any local user can trigger this. With an unmapped base_mr,
> as an unprivileged user under KASAN:
>=20
>   Oops: general protection fault, probably for non-canonical address 0xe0=
00042828282002: 0000 [#1] SMP KASAN NOPTI
>   KASAN: probably user-memory-access in range [0x0000414141410010-0x00004=
14141410017]
>   RIP: 0010:siw_qp_sq_process+0x38b/0x3c10
>   Call Trace:
> [ ... ]
> The fix and this changelog were drafted with the same tool and reviewed
> by me.
>=20
> Fixes: f29dd55b0236 ("rdma/siw: queue pair methods")
> Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120000211.6321=
7-1-astellman@stellman-greene.com?part=3D1

