Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795714745;
	b=UA3ZDhFob7QG8fKG5K+bSoGPWq00YqG8HcT5+E1xqtG+1iN/RhR3oHAbRfpV4uS7tWae
	 HSnd5RC6DxJHganDNcGv2PMuAB+8FCO2aJdCSx+gbwdreWZmEo0wkXNo+QwYMVWjFc9p3
	 EYKy23VwKDwcM6aC2zwr18609Nun9aSR6jN+64I2A2SFfh9meSBBPAF0mlOdPGyPMqN1K
	 tDOckdQ5MkTE5zL6eFCec4fISV0+UevmcYOgYwvh+DPq0Ij/V0aRMmXta6i7nfMfXIO/4
	 MTLK5uszEue6ePy62etpgByRxdDxgwBAqOKwsWhu5GarMeHIeDnMyp8tzThxvWS1kwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795714745;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=VEFeQJ+dn7jMz9xVR17AivNM9/LowbCGZTeKv4wRSCM=;
	b=2t7r70EQb1uQNlbqzhnnYFzQu33r3YkNJH4sGUTiL6d9JsgH6kOaAtbu5m372K8zzg/j
	 d+wnG1WAjYvpjUA3SmoWOGJO335gxkW3u5IhJ0DUBzea91DEXslIzSyb2KgiDwUOUDF7M
	 9QxPO8UhrmSMG54burvOpvNyN84o+cmUnDNyenxlVBRi1Wxpj3uTxqnp9BNOxqLPD25sX
	 cP/Po3l5D8rO39dwu5ZN2r+VyrJ+FmuIV6VlO2faojDWxgqlkGLAqpfzox8zJCRvztxeK
	 uKObh5iveo3U8C5I6nKgfIodLLKrLHTQWK7kuonIq4uN0j3wkWEk2uQOzQNUmq9ipcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FsC1Smdw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F9B606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 17:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FsC1Smdw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984381F000C0;
	Thu, 26 Nov 2026 17:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795714745;
	bh=VEFeQJ+dn7jMz9xVR17AivNM9/LowbCGZTeKv4wRSCM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FsC1SmdwHtGJFSXhMhZIOZZ/jYJDEQvjREX6z8bxf5UnNHXP6Dt8qr8LBKkCpA9Vr
	 fofYlrr+L+suYZroiqqfz1JUx0aJyyk8+gFxS1jZzvU7EuNg6+irzqSpikkY4OTsb9
	 vHX/x6rF6i354udKbfBao0urQ9MYC1HHSE80vGl/llfAVFR5O7hB0PAXoA/Fue4ZLL
	 QNiuYUZ1sKMWntv/WAvNSVqt4xdjpIvaGFVw29CtSGYVv4n4HFXWstaE/EGhnvRKeT
	 JDKSqwg+HTEifL6vFgVEGU0wvWK4dIQw0Qw71MPxlT1tkX8rYNWwylE4H6fDy3+/S5
	 lt2lboJ2A0RiA==
Message-ID: <sashiko-outbox-235978@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next] RDMA/irdma: Add budget to CEQE processing
 loop
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jacob Moroni" <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261126173430.2097445-1-jmoroni@google.com>
References: <20261126173430.2097445-1-jmoroni@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 17:39:05 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> irdma_process_ceq() processes CEQEs until the CEQ is empty and
> runs in a tasklet. Under heavy load, CEQEs can be emitted as
> fast as they are processed, so the tasklet does not return,
> which leads to RCU stalls.
>=20
> Fix this by implementing a budget in the CEQ handling loop. If
> the budget is exhausted, the tasklet is rescheduled, which gives
> the kernel a chance to defer to ksoftirqd appropriately.
>=20
> Fixes: 44d9e52977a1 ("RDMA/irdma: Implement device initialization definit=
ions")
> Signed-off-by: Jacob Moroni <jmoroni@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126173430.2097=
445-1-jmoroni@google.com?part=3D1
