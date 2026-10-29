Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793284290;
	b=yDAPNTVTpXB5km1NpI7/0hoNEmnX4xXWfzPCH2+asPs64qktKADKyIi/nZIvKegUcc+w
	 4PHRYJ0zzIx8XD2f1zyvjz0GYU75kAWY8Ixxi8TTsCrtosNs7OkoKTHvZXfx3P8AXQEB/
	 9FKLRuR3SjWKYpyOPl2k38tUVHXAutwYpIjZ5OCqwrgV8jwnu84z/ESwPBa6FJ0YY7wOq
	 H9DM0YH6x0Rk8Tm3hLowIsKgIJ39heEcl59PP2yEISLcmT/pnb0Uq5FaE4U2SRsYvQ4nx
	 61zlQHZmb4FsXQONCJPcwhcT4Tfvz1W9jU0wh29tlmeXy6Rv+70tBi0dSYofAT2up6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793284290;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=BkfgqXNMvs4ki25aMkJ0SH437FJOAHaUWhTybA5wAMs=;
	b=Xk0ebNakvQqDb8HtZd5LoUi2GtBmJJf6Z2jEO8dtMdcMC1PJ8Ay9h7evHp0lNe/D1M26
	 /JTdZYxNie9Ckjh1o604fIVqYX7InK6AtCzBrryhCvJnGz2gGS1qXv/m2zJ+98iWmbM+n
	 XmHs3jyoWQv1YAa43SXfomXW/Nu6Q4U+vcj/0HDidYyMlqiK3H+JXQTdWlmSMEn6fDWkr
	 x+t+ZmvXIzLW4RfkWaURdQ8gX7YhrzIuPJJUuPUSaF3+1i4DcZRRag6a9om1lHt56IwWB
	 Jh0icRUroX9bW5ViOzlDnpAsNIHF08scbNWM8CFrqa97rDXFL1tZO353pRqJb+7PChg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F6uIFXF4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11155606A322
	for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 14:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F6uIFXF4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766EB1F031E0;
	Thu, 29 Oct 2026 14:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793284289;
	bh=BkfgqXNMvs4ki25aMkJ0SH437FJOAHaUWhTybA5wAMs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F6uIFXF4SE5ihixOF9WMWNO/mVcH+fW3bt1Gex2ATBTFz1p4hSxOT6h0bh0jagaZS
	 4F/RKIY6IZ9GjLdwmb1I+DJsTnFgjUCuv/DfJIHDSJx4W8J92B6cR8viiwpcbDy92M
	 MyCFM+rorYOH0EF+khxXP2f0tse5N8rvY0WmXenBQZAFi20UjNvjwTTGcYc8OuVPub
	 ninJBY7mUCkgEAUUYK8nMON9lpkw6VYVTL/8c55UvTNFwb8pD+9K/84tYRBD3mtoVF
	 LMjD2cuRxAar6Q7/rA/sJEL+lvmAQQEvmJ/s3yLrPgKYgHg9CVFrWXZk/W9527/On3
	 BaSWyK25+BQPQ==
Message-ID: <sashiko-outbox-189522@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND rdma-next 1/2] RDMA/irdma: Do not allow rereg_mr
 to revive defunct MRs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jacob Moroni" <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261029141849.1575012-1-jmoroni@google.com>
References: <20261029141849.1575012-1-jmoroni@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 14:31:29 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> An MR can become "defunct" if a previous rereg_mr happened
> to fail in between deregistering the old MR in HW and
> reregistering it (e.g., due to ib_umem_get_va() failing
> in the IB_MR_REREG_TRANS case).
>=20
> In this case, the MR is left in a state where the umem may
> have already been released.
>=20
> If rereg_mr then runs again, but without IB_MR_REREG_TRANS,
> it will end up reregistering the MR with stale translation
> info.
>=20
> Fix this by rejecting any attempt to reregister an MR that
> has previously failed during rereg_mr after the point where
> the MR has been deregistered in HW.
>=20
> Fixes: 5ac388db27c4 ("RDMA/irdma: Add support to re-register a memory reg=
ion")
> Signed-off-by: Jacob Moroni <jmoroni@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029141849.1575=
012-1-jmoroni@google.com?part=3D1

