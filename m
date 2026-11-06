Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794004204;
	b=dV6CVbG3ADLQ2hvmsgtMNDnZOghUlpAyGEl1Fpf2GsNlGkrdqVpXsgI2bPbX/DWHlL2W
	 Omff5XdyQkNzPXAdzE09Rg6i+2m9eQB0bFqJ+dEHFykhOVtHn2rBbX57zUeSjFViLcFmB
	 Nqmj1lTqYnZ6hXNkdGii2DiZuKNxrQgyCH2pqN4k1zOa7MQAeJHZrDX9K/QrmC7v8naqC
	 ARv2OucFhNI5CPGRLEb5n7KadpprVXs3yD9paRlmqLLkX+595MSp8kMUH6KVGf950uOHm
	 vxAXdDA0ZnE7lhGFUJvQIx8+/qq4D6cUKlXe6reKwIOW8LnrVyjgcXwFEki8tyZHTjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794004204;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=oVrLYVHWGqqDV66bp5bsI2cfNY0PkRXdcDW/R+E5Ibg=;
	b=xGMfymJE6X1u4UTZnwVmN5XPDm/FfYSADwzzrm+LFtgNxRIDG0yM/BbLZypK8vPdKAPl
	 zQtfj9CKLsHh12EaNCVl1qWzDWCLHMcQ+cuhPA9rfUXeyQKwm5dj24ApO7TEz/sRRwXzh
	 AfLEKLUZUtFlha2/r4qUJid8Z572H1AKzAKwhjA11E3/nD+X2VjCVpjdYF/FXbtlO5Mg7
	 PEkxfQ2nX2lvJJ4+BvPUvkT/gRWmCET30hiale8sT6B3HgrKjzaSR7nzX9pwYpQbM0gHM
	 xeXV34nZc7lvfeNAB8otQSPRoB4OYHc1/0/4xxOQmthJxwUJV7fxaDtn9m6gTSn1MVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g5fD4IN5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9A8606A331
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 22:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g5fD4IN5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E701F008A7;
	Fri,  6 Nov 2026 22:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794004203;
	bh=oVrLYVHWGqqDV66bp5bsI2cfNY0PkRXdcDW/R+E5Ibg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g5fD4IN5JGCYh3932QyY4PKxS2H+cK2dOlC1ywybXWTq3418gT96cI4IBRzlSo6gT
	 zE6BB0M7O81fmz7L09XRPInBGILDWmKepZF/nIDz5ts2x9BLB0VSHE/C77Lm4tKoAE
	 CzmBEurhIaBbzxGS507Q12+pf4G01NAwnFByNRoO1PX0NdMBabHej4n861siT2jSxJ
	 cXOViPgu1EDfITNlXXcLzh0gW+I6cORuu/u8RC+hgJO809KlPGfTzlu9ceChTNcEfQ
	 veYcN65lDLkdPy5yN6yXA6uaYt0iXeT0HFgDR3eXiwsSNGpNC3/rXykpT3XGHQ9L2M
	 Wv/ylpQlkUpnQ==
Message-ID: <sashiko-outbox-202335@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 4/4] RDMA/irdma: Release SRQ slots during CQ
 scrub
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jacob Moroni" <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261106221201.2266301-5-jmoroni@google.com>
References: <20261106221201.2266301-1-jmoroni@google.com>
 <20261106221201.2266301-5-jmoroni@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 22:30:03 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> When the CQ is scrubbed during QP destroy, any unpolled SRQ
> completions are invalidated, which causes those SRQ slots to
> be leaked because the SRQ tail only advances when completions
> are polled.
>=20
> Fix this by releasing the SRQ slots whenever an SRQ CQE is scrubbed
> during QP destroy as well as during the small window prior to CQ
> scrub where the QP is marked as "destroy_pending".
>=20
> In practice, the leak only matters if a consumer posts new buffers
> to replace the ones tied to the discarded completions, but releasing
> the slots keeps the driver's SRQ accounting correct.
>=20
> Fixes: 563e1feb5f6e ("RDMA/irdma: Add SRQ support")
> Signed-off-by: Jacob Moroni <jmoroni@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106221201.2266=
301-1-jmoroni@google.com?part=3D4

