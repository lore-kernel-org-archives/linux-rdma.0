Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795197159;
	b=iSXNo9CBpPYJGLvEHTuKwnheuKZXRkXCwVr/gpwtKuMTpAyEyJYEyMW4qU1tQV6ezJDM
	 C3eN1OhLz5LxCILhyho3Zu0IAt6zzLc0kkBIB8if/hzYAIblCsqzqfYJIL/giH67BQ7S7
	 Z9mhhaALcEVUp/21fLzmUQHEwurVwvTylx5+HcfnJ9KGwGh4TMVcnv8D1cccoTBiOxSVA
	 iOZ9CUcFFMlvdH52ZaNZW14Xj5b8TzITLQMyWcG2Ps96Vq83q77D25tlN/iZ3Gqr9R7b3
	 Ct4g1yfzS1303Hv39g8XEY5UbA0QzPEJzq7sjVhawZ9nQ1eTBlwMkMXKjyJjtyBczAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795197159;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=aC+F90XTsDMurfzTCT4vbyxLMGc9VEAet2pAICchXk4=;
	b=bZ8stmLz/vIEPScDMuuuLGSgKpPcJDFdzm/pipiTeM+IKqQHpoiechSVhkikclW+WjvE
	 kWpmPlpqEvGSWZg3XQC1HxABZ4PtsJWTOYrHKAGYu6JVPpbqJnvUReSaSi8ee7XfH0OO0
	 u5uo0ysEON2Xw0K2AMSBggTWFLC3ffd9IB5XUU8dOUPUdO25ZwJDCNvrdpFdMYABHxIqR
	 XyRydrq6an0+OPe7wV0H01UWP0nYdcbin9Yyi9nQWg4GRlz8H8w3b4pM/ByR2w1OJEhtx
	 tZ1ofY/fyNGNjMg+zw2Qm6TaVB1M3Vx859m1M2HHeGvE3FgdHxbAmpOMKgPzL4QFj7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gyTSSHhZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8077C60A2611
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 17:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gyTSSHhZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12B81F01572;
	Fri, 20 Nov 2026 17:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795197158;
	bh=aC+F90XTsDMurfzTCT4vbyxLMGc9VEAet2pAICchXk4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gyTSSHhZduGD77rICfE6X+9wp+1pY/y/UsVQTc4adnzUAg1u91o7dX3/ovRcIyJ5h
	 svVR1q2LQpt5A9SiLUxcZSq7duy/OMEKOv2RZC8rVpvXv0boJdNqMICMjYGx2rEoH5
	 I4fvUMAaY0HgSwqDJUtPyYcv2hLasS7QNC8AW/RV7ldqQj78BK/8EpLC6EkY/SbFdn
	 EYmwW9CjeCvVX6cBCDJCl1evjpSwyYS5GkjMb0TrxqWAhD7xEsFuqlX1doiWI8KfSc
	 DaS/J/2LOYaq8XSeIFXfl518HvESdp2FpqR8Qr1IF/3w0Tyom1JDNQ1rBHdzZ8oK4f
	 3nImUyBrKy+MA==
Message-ID: <sashiko-outbox-225735@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/ucma: reject a second join of the same
 multicast address
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Misiurov" <amisiurov@cloudlinux.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261120174405.2761262-1-amisiurov@cloudlinux.com>
References: <20261120174405.2761262-1-amisiurov@cloudlinux.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 17:52:38 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> ucma_process_join() permits multiple joins of the same address on one
> cm_id. Each join has its own ucma_multicast, but rdma_leave_multicast()
> searches by address and removes the first match. A leave can therefore
> destroy another join's cma_multicast and free the requested ucma_multicast
> while its cma_multicast still refers to it. A later event then accesses
> freed memory.
>=20
> Reject duplicate addresses with -EADDRINUSE. Hold ctx->mutex across the
> duplicate check, mc_list insertion and rdma_join_multicast(). Use
> xa_alloc() to reserve the multicast ID; dropping the XArray lock during
> allocation cannot let another join bypass the check while the mutex is
> held.
>=20
> On leave, erase the handle under the XArray lock to claim the multicast
> object, but keep it on mc_list until ctx->mutex is acquired. Hold the
> mutex continuously from list removal through rdma_leave_multicast(),
> event cleanup and freeing the object. Otherwise a rejoin after unlinking
> could create a new membership before the old address-only leave, which
> would destroy the new membership and leave the old one referencing freed
> memory.
>=20
> Fixes: c8f6a362bf3e ("RDMA/cma: Add multicast communication support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Andrey Misiurov <amisiurov@cloudlinux.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120174405.2761=
262-1-amisiurov@cloudlinux.com?part=3D1

