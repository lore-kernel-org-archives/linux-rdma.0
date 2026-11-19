Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795101558;
	b=P8qcE/o4Ncdxri6cipYzu67liaMX1nA+q9bCfkBS4QfeMC8RI1L3rG5kJVrSqKpfd60S
	 1OPdo2sQ1Fi2p3kBEv7jd9509LvCQbEKp0aXJD5rHy6BIwjZwi4OJVWBR8/6rquQ/AE3P
	 vcw2z35PhvHeFeDHjtvyXcPZRy3MIqQAiR5FqbdwIlsQ3HJzzRhCIyEU1u9BCNBUNGuDT
	 mPKkwGjBu2AjI4WHWBxbnunWjzjw4rTn4JP3YgXKd5u3ZEEAHw3vXZnYnjVKcjT8HldHf
	 1TUDiM2ld9UtV9/HefS61lyRDag9z+bdcX/Nnpc4pB8nMDnxsagEXXUzrZMu3pYkncQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795101558;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8EVzqKZz5gzPeNKCIvkQKKREFp0iZh0BSCmOIqpErwY=;
	b=gAnpXdnFBLkR8utDEJxLNDaUVQWVu4JTdcli0He5F+gFrBlZQtrRdxglE7ifTnBjP5lU
	 qmzOZXt+cyWKc1A01AFMQzaHeoswDG7TFEl94qZ8lw70oYN/IfHTdAA+Iet0Q9iLE8atO
	 iCycug8Re6iJ5Tg4DrCg6wiXj0jBdJM+hSZCnVmKY6WeQNjkBDsNck7hVke6LX/fKxLuk
	 y71XzK5dErm2Puxj09+6EytQLaA4rx/CS3VV57++7PrTtsCSQHbtlkhFNn3ht3IHhjEMo
	 sPuaMqeYf6b75Nudz1rlZUqW8KRgDhDX58UXVgJuUAatUL+vIrrKlJdFQEar3QmR3LQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TMT1TE6f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0B5606A337
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 15:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TMT1TE6f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8631F000C4;
	Thu, 19 Nov 2026 15:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795101558;
	bh=8EVzqKZz5gzPeNKCIvkQKKREFp0iZh0BSCmOIqpErwY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TMT1TE6fsEPHMVQ2fvHhl66ampsBcNCVPzIpfQD898UIDV1Dphz7VjcqwRQDnuRnN
	 SH7wCSc7slETpHdMmQAnuiDRYOtW2hPYPqErBPaPkHBWIaIC0b852U97xSE4NOyxds
	 INtcbE+ZIluTxAxp3LZHHXRfkb/R3G7U3ncy6C1wKZQZIdA3uKmVpGKim+nFdUtkeU
	 fIsf2mclenThGmYVpIYncV7FZvGVcqfO696H2yun3LufNVcfpxyL4/GZemsRKBl6+e
	 ZcsOj0Advg27MhyjQWpMAjENLV1vgt34JdTCxj/BvpnihxXjJLMaYRmw1K2iR3zQz8
	 qRMu7ifHRhFIQ==
Message-ID: <sashiko-outbox-223362@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next] RDMA/rxe: Fix NULL dereference when
 invalidating an unbound MW
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Stellman" <astellman@stellman-greene.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261119151327.95446-1-astellman@stellman-greene.com>
References: <20261119151327.95446-1-astellman@stellman-greene.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 15:19:17 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> A type 2 memory window has no QP or MR attached while it is in
> RXE_MW_STATE_FREE, which is its state after it is allocated and again
> after it is invalidated. rxe_check_invalidate_mw() rejects
> RXE_MW_STATE_INVALID but not RXE_MW_STATE_FREE, so invalidating a FREE
> window reaches rxe_do_invalidate_mw(), which dereferences the NULL
> mw->qp and mw->mr.
>=20
> An IB_WR_LOCAL_INV for the rkey of a type 2 MW that was never bound
> panics the kernel. So does a second IB_WR_LOCAL_INV for the same rkey
> after a bind and an invalidate, and a received SEND with Invalidate
> naming a never-bound window's rkey.
>=20
> The first case, run by an unprivileged user under KASAN:
>=20
>   BUG: KASAN: null-ptr-deref in rxe_invalidate_mw+0x156/0x310
> [ ... ]
> The fix and this changelog were drafted with the same tool and reviewed
> by me.
>=20
> Fixes: 3902b429ca14 ("RDMA/rxe: Implement invalidate MW operations")
> Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119151327.9544=
6-1-astellman@stellman-greene.com?part=3D1

