Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795374935;
	b=NN7mSycLdq61kLDBVpytWZlX2sJqGxqFJGdJ7+NpTqRpwcj4iqrK5oaUggrKjOf9IpxQ
	 +fJOltkHpIOeWZviyMWnd5SXQmw/y3tLxIFgpXRfG1+TBA7ndXauhH0tRt4O/Q8euxY0w
	 UObBGElEd1rJXQKOzjRfrwmP9mloqh10SVtSjJnCHyvBm8PqLY/+0dFXWqk/1xqkIj7vz
	 2T+TWUA5VfurZSno1UJYDxWFAJ7aPLpDpErxRaN64dGf+aHtCxxA0qepve5zt7nEdr5ds
	 rFwNU5FcxPYNkO+ZML4/LaupMZ7X0WER3ILjIgHLO310zTzFIzm0/lPgBmav55IojoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795374935;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=NEUx23x+iFurFmm9o3uvAOqLamE7nrfqVkTBy7FS05A=;
	b=ItalxLir93ljhfXjeRZjmoQhpf+vYhStZ/KnSsqHciWMh+aR5oGwUn6XMTsx5t/mRjUI
	 HijOL9fVdSxdBqqs6oByCm7eKWtK7Tib2SFB4PkQ456GlReoIEwA/AFf+joNMqRIxtPtI
	 7kf8+PnZdpsIMT5AabWdI49253yr3WgB4qDfmCKLSo4R8M+2qs1YqMFrdgcHRdlZxZYpG
	 YwStnwmvhR61lMe5cmkN8LXyyN9wCZTnPtvAHnC+tuwCALP2/GcoKjKO9i8wm62Kaf7vX
	 blCB13jZB43cp8LX07vpu99rbRGoS/w3djoFMHzFPUy6i1JPGmR/RpR6rrGe6CyFmyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C8vg8AOR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6CB606A31A
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 19:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C8vg8AOR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6050D1F000CA;
	Sun, 22 Nov 2026 19:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795374934;
	bh=NEUx23x+iFurFmm9o3uvAOqLamE7nrfqVkTBy7FS05A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=C8vg8AORAcr5v+rUUF+mLe+dAEMHie6GcWpqYFRkyp1vnAJricC7rL35NKNDvPSqB
	 sVHgCZlF6q5i0pfEYyko+OFrjJb1CeR3VEx7ai+h0nQ9JZC48vhivXES62i4IWg/p8
	 EdmhCuWt8lJRgI0steEDlET4T5l+DCTO5PbfLe4/D6/+gJlilU5L+hjEvKTAFDRu11
	 24qtfdaFE+pxQIz4wHqkBhfyYrI4MPs8YzQkS4pobCWl0axfzHB3AXAJmrkNw+3AbJ
	 nwMd7idvqcX0BKETf8mRkzXXsbVJrQw1REbZD9A5bhIA7yMN411v57gOAimO/fdGCB
	 IEoNsRho+zIRg==
Message-ID: <sashiko-outbox-228238@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-rc] RDMA/siw: Don't send stale data for a queued
 zero length Read Request
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Stellman" <astellman@stellman-greene.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261122191122.65240-1-astellman@stellman-greene.com>
References: <20261122191122.65240-1-astellman@stellman-greene.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 19:15:33 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> siw_init_rresp() queues an inbound RDMA Read Request in the inbound read
> queue (IRQ) when the TX work request is busy. For a zero length Read
> Request the IRQ entry has num_sge 0, and siw_activate_tx() then leaves
> wqe->sqe.sge[0] as the previous work request left it.
> siw_qp_sq_proc_tx() sets num_sge to 1 for every Read Response, so the
> Read Response is built from the previous work request's sge[0]. RFC
> 5040, section 5.2.1, requires a zero length Read Response.
>=20
> A plain TCP peer that speaks MPA rev 1 sent two Read Requests in one
> write(): 64 bytes from an MR with remote read access, then a zero
> length Read Request. The second Read Response carried the same 64
> bytes of the MR:
>=20
>   Read Response, sink STag 0x11110000: 64 bytes "SIW016-REMOTE-RD..."
>   Read Response, sink STag 0x22220000: 64 bytes "SIW016-REMOTE-RD..."
> [ ... ]
> The fix and this changelog were drafted with Claude Opus 5.5 and
> reviewed by me.
>=20
> Fixes: f29dd55b0236 ("rdma/siw: queue pair methods")
> Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122191122.6524=
0-1-astellman@stellman-greene.com?part=3D1
