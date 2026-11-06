Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794003708;
	b=BTQxe8XJSJPl4JpPt7Pdf6E3krVROKkCQS7op2GyWLlMTQ37XhEwk6GKkIr1+hPTY15H
	 yXUVIJZoYhgCu3Htc/H7MxWtk8BuN26K9t/X4YQlBZcBZWAXFjT/cZZ4fpQG6VF0g4UzE
	 XXCrTSHHDVm0/SBdRK9BPH+bH8Gi1bLz5+/3wZs4GAy2pRBdJVwN2aH27s/A0+I4dLy5n
	 wAcpo/LwQ0m8xj48dMRG4eNWdayV2PjrAnLe5Axle/W8dR2+/jCiYcPSNyJATX16rrA45
	 ztoON7MRLN7jCC51BWS06XkvMwBoXKsgna30Az49vX3Zp/SSMcO9G1T3MpuPuOQvJJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794003708;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=h2I/2nnLN84F8Q1iw3QbtaOGqr4+Bt/hvRnZt+wh35c=;
	b=2EJ08jn+EoS+5KgTzcOdb6x2cdEp8HW5qu3jws91y4kbmlbA1hfYG2OJqnPu8R1GlcUL
	 TSDEJuHFd9EWqAxA59BKGVvhy8qPrpSzUrRuL6TJIMGCJX6qW+ndlS3VzTJ6cRPbMnPSw
	 7ZTE+nor8n3U+oTrHwm1Deo8AjlZOBIgESVWChVWQRIeaRWA7XaBkDqHVfCC0Wscvh/gE
	 l0zG3kMKcH6GylsxpOQ017oue83R0takx/I/CmApoTxrbivr7BB3EnKhMo0ZfguR7SRpU
	 2S9QBGdrNtxm5aAki7VwkFfivyp5Acfd3EOn3xWcyMd7mBoc/QtcqJ8D6Zzh2GHlw+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EiDScCMs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA20B606A326
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 22:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EiDScCMs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6553F1F0089F;
	Fri,  6 Nov 2026 22:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794003707;
	bh=h2I/2nnLN84F8Q1iw3QbtaOGqr4+Bt/hvRnZt+wh35c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EiDScCMsVjg1tMUPUzKJNDfCoimfvY0Rz4xVb3b8kefMbLNtsyQjmue8dPQ9OWLn+
	 rHT9YT0rNTG3yfBcl42vXeyY6R8lje3zdzohADT2iH9wlp21fIGZxUSzffQocCTT08
	 9UWy/iSHAPOOvW8sO/BD7dBw9KsK3QDuBJ8RWfqmdrbxy2f309V/X5wz8DBPWaH46r
	 oujT36eWVzpt2OV3lIIMlBWGtvrQ6mmP0W3qrg2VB6a13SpM9RkMtYGOwLoBSEBrXR
	 4hz6xL5x0hboUHvPL0fHS1C2SYn8Q3VkQz6yI1yVbnqQa0t6w5ysz31HcCUu9pUusN
	 7jKW1osbULtNw==
Message-ID: <sashiko-outbox-202326@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 1/4] RDMA/irdma: Fix QP handle assignment for
 SRQ completions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jacob Moroni" <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261106221201.2266301-2-jmoroni@google.com>
References: <20261106221201.2266301-1-jmoroni@google.com>
 <20261106221201.2266301-2-jmoroni@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 22:21:47 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The QP handle comes from a different location in the CQE depending
> on whether it's an SRQ or normal completion. For normal SQ/RQ CQEs,
> it comes from offset 8, but for SRQs, it comes from offset 40.
>=20
> This was correctly handled when the QP handle was initially loaded
> in irdma_uk_cq_poll_cmpl(), but there was a leftover re-load of
> the QP handle later on in that function which unconditionally
> loaded it from offset 8. This would result in a bogus QP handle
> being used when processing SRQ completions.
>=20
> Fix this by removing the extra QP handle load.
>=20
> While at it, load the QP handle into the u64 comp_ctx and cast
> it rather than loading directly into the QP pointer since this
> could overflow on 32 bit systems.
>=20
> Fixes: 563e1feb5f6e ("RDMA/irdma: Add SRQ support")
> Signed-off-by: Jacob Moroni <jmoroni@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106221201.2266=
301-1-jmoroni@google.com?part=3D1

