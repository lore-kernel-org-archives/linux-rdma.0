Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404812;
	b=ozH4XlMsAxz4IMy9TQ6Lb06TMMfZJjwdGKdvMMYIEDHBYOul0//CRTFE68LHdpV8xzbC
	 XZkNVxx9FRXqt2vSGgm1slqy1znPqGE5LBWdiEbgAILPEVNxA8wzoEyDhcG4T9bQgzAr/
	 Sr32OWDDKuNIPIYookUujr2zSygTLbCBfv1JDyOnz2GLmJulwArl6RqSGxUPZ9c6crfmQ
	 uvUjFjCTmZE/TYRLb8RGkW5+CoWNpM4WLYsXiW5z5yxavK7VAEasokytBwaWOXzsJnNjj
	 ihv16/B/cX249UQ1xiR6klzggEm61Jd3swyQ5Rf99FFoeXURapyz7shyWFarBR3ozgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404812;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wIAzsn090CpXR/N8GStBnq3Y1TI/Nt/l0DCGPfg4d0A=;
	b=M/rwk8JTQLHoSZFMMzUnmQY4fTxNFeBR0OTrEFjDmy+rde1rjYXqnoCwcF1A4c3FIlX0
	 fnEsaReDcSKk8YIa7f1PRnkbcEEkKbBMXZzBwO7/x9AGyYegbNY1NBZP6yy/tsqONH2+4
	 WJ6mg+OG9nwHhpPaFhrlw9GdxFUSpDiY4xNVAnIa2qdN2zBhWk/MDMcATG9QA8biMPMMi
	 xvSvBYoSoWCfsG5A6OPvkPpPErj+EmYAE1WaABydX3nm0jmTAkEAI5FjzAJYQdzkt5qDQ
	 bHh8dx2H0wClJs5nfI00XU9M1kmOPqQi6HwqelNXkmsHM49ao2gMybua8SNR15K0J9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N5Gqq15V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF132606A884
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N5Gqq15V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB971F00A05;
	Wed, 11 Nov 2026 13:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794404812;
	bh=wIAzsn090CpXR/N8GStBnq3Y1TI/Nt/l0DCGPfg4d0A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N5Gqq15VgCCvQYCX9tEfX511XdCGhpOUfR2Imyg6yUXPLXnzuL2wS+5Cnqr+5liin
	 UqernFFicDCPJT1rZ5IcMdP4JwBdfgonD7blXGgSdQ2UBqExDbyHAAkWJ26r/eW76E
	 biPRHQZbykfYtYuRv2zrMqvJNLszvc6zHhjk8Ud5ygOWN4y3vee0d3UKPmQYx4hhxN
	 k1XT7E3yr8m6NGM3c8mhKtAL1KcylQ4qfUMZcdhll9uS8ZUrPOID9OzOqANfc9NRkm
	 KpleL1Nzg8Q9yCSRglJUbLHKeqO3yHoSADwXA2fBLCuIQpQlpOt36NtC8OqRI1VCG4
	 PLRxZWQOF1BaQ==
Message-ID: <sashiko-outbox-209098@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 13/24] RDMA/mlx5: Verify UMR CQ polling
 against a hostile NIC
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110134320.34408-14-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-14-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:46:52 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The generic poll path trusts the CQE content: its opcode, QPN and
> wqe_counter decide which request is completed and which waiter is woken.
> A forged CQE can therefore complete a request the driver never posted,
> or one that already completed. The driver then writes through a context
> it no longer owns, which corrupts memory, as the context is usually on
> the waiter's stack.
>=20
> In adversarial mode, install a dedicated poll_one for the UMR CQ that
> does not take the CQE's word for it. The driver keeps a shadow FIFO of
> its posted requests, and a CQE is accepted only if its opcode and QPN
> match the UMR QP and its full wqe_counter matches the oldest pending
> request, one already passed to the doorbell. The context is then taken
> from the FIFO, never from the CQE. This cannot prove that the NIC
> really executed the request, as it can always report the oldest one as
> completed; it ensures that the driver completes only a context it owns,
> [ ... ]
> On teardown, stop polling the CQ before destroying the UMR QP, so a CQE
> for the destroyed QP, or for a reused QPN, is never completed to a
> waiter.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110134320.3440=
8-1-yishaih@nvidia.com?part=3D13

