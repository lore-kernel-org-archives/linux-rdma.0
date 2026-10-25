Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792893538;
	b=hGEwKZpwmU/FdE5rPhV3rOyNeCFgC9EWw+9ti2Ornro3syvxlyUtwL2KrMQw3hzNokBs
	 pMRrJ6KO1DECLvrmvVo2B6k5NOQjJpVJv4xXWEiXrMfFK48VwuqQ4UTK4PKp7lOvOLgMn
	 VVUwZ/BXIlX7VnkLyw5rrMtJ3k9zdYnGh3XQu70nStC8ePszKBdmOKkC5SLYP2hjTBAHj
	 nR+qY/B+ftRQW8R+sknQQDjw2m00y8IA2HoBJb2CgHoIMuj34uqnyxxr5mdwDqAMaI2Kx
	 Q7W/Q7H32A4jJ+mCH/lApPxprQTOU7y0axQFUjeIbrIGueexLnaNc8wHFYlSgjYmJ+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792893538;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=UOuKnNrxCYDoTnewNzAmCRN7Mdk6NhglfhFG7gSMrUk=;
	b=1ImbyZyf5X9j632aBgB2gknaRt2bFN3ltzOBic91uzx/isMpw2DCA51uo/Fi5symEI9L
	 NorXjDe8BUUCuFTgj5FcU4y9k0xelZKzdUDiF1keg4Lx4f7gy8KjI78CpqblMhNosR45A
	 XnvNYrJkKt+K0o3q84fhLjnaIhZcNKxGNtIyMfWE7w5s7azyYh73oQZtsDDtlGNEX8jwx
	 6lRs38XWIqqYnwg2sRTiqyqNbQBn5MfwuczqHBF84aVzT+0XbrSbqXJuHvGU0mk5q9mjg
	 UJ7ooqckADDl53VoHX8ST4QoIAYAPL0JNrxUz/ICY7c+IGj3+PMQkoItKFB60RvjqtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DhHiXay7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D24606A31B
	for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 01:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DhHiXay7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F261F01825;
	Sun, 25 Oct 2026 01:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792893537;
	bh=UOuKnNrxCYDoTnewNzAmCRN7Mdk6NhglfhFG7gSMrUk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DhHiXay7MEUn44shfma84MPC/rytwLewpb0N7wFSvIn749wa4SReiVVtD3TSSUQIA
	 Vnk69rB77ZvlIZeNNDasEo/C2CadYKwKvwHp+P08F3zfDD0gsler53lnaFBU64vt/z
	 8XpX4Bb6D+4Sq08U7M+pLsdlS6zGXpfB87J00XVR2kuSTZqct46+a+Lx2+YjbycP/h
	 qqnrxPGFw6VLGjYf7egZJ7AQnJiYhimE9fDzkAm0bUyul840ltV5ZYlIIz5golyrcN
	 ioXd3N3BZ/3C6xpMu2AivzifsdfVBk9TPQMENd9NXhnZE93IXGc37Kz9HfgS8JF9Eq
	 SDeWrnsZTFjxQ==
Message-ID: <sashiko-outbox-183973@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 2/3] RDMA/srpt: reject zero-length buffer descriptors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261025013748.3755639-3-yhlee@isslab.korea.ac.kr>
References: <20261025013748.3755639-1-yhlee@isslab.korea.ac.kr>
 <20261025013748.3755639-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 25 Oct 2026 01:58:57 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> srpt_alloc_rw_ctxs() takes each buffer descriptor length straight from the
> wire and hands it to target_alloc_sgl(), which has no length check of its
> own.
>=20
> For the single descriptor of a DIRECT request, and for the last descriptor
> of an INDIRECT table, chainable is false, so a zero length makes
> sgl_alloc_order() compute nalloc zero. kmalloc_objs() answers that with
> ZERO_SIZE_PTR, which is not NULL, so the allocation looks like it
> succeeded and sg_init_table(sgl, 0) runs. That reaches sg_init_marker(),
> which does sg_mark_end(&sgl[nents - 1]) with nents unsigned, so the index
> is 4294967295 rather than minus one and the read modify write of page_link
> lands far outside any allocation.
>=20
>   Oops: general protection fault, probably for non-canonical address 0xdf=
fffc03fffffffe: 0000 [#1] KASAN PTI
>   KASAN: probably user-memory-access in range [0x0000001ffffffff0-0x00000=
01ffffffff7]
> [ ... ]
> been allocated yet.
>=20
> Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API=
")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261025013748.3755=
639-1-yhlee@isslab.korea.ac.kr?part=3D2

