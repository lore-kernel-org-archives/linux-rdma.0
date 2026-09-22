Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3ED376A0A
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 01:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790042281; cv=none; b=maGRoh+ERJcTDJ5IZlDEcIuQskECxBVGLDP9LbSmLhjtnXaQjiE3bK/62QhqgbHjJtP9rTfeZvERpYoj1bMqfKN2OOG2Y/K0BlKsa3trcSGMhhy11ZoUFz1Kst0dzGlpMq+a6hmWqWaLq4MpKqzTL9YeFOZZlIHvWQrfcKx73IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790042281; c=relaxed/simple;
	bh=W2nn70UZ7BMnGj9irDcPXp4ZTP+PD17goR9Q7aTE/4Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Q+Dgm5zXy5sFXs6K23k8diuNc6oyRy4mz0g5pzq9ufjeeH4YW0K4TbLBw6Bsh+K5oCOBtceBtpYJwTlDZXnFQE5/xnwYJ0SS/Ldl9kTPxtlhrg5MEa7uETAKGy9eBy4Gl0zzbSMNd33sK0t2MZU7iorlzBB0N87/Zl7XPJ7/0kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OOrCvvTJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OOrCvvTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39AB1F000FF;
	Tue, 22 Sep 2026 01:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790042280;
	bh=W2nn70UZ7BMnGj9irDcPXp4ZTP+PD17goR9Q7aTE/4Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OOrCvvTJztgTdbTL1ZP1IQW3M8wuEPcTB+oEJOxUoxB1iVRMjMM/k5pmt35Zju7lt
	 se6x1mLliSB3YHEqUtPrCXVzEAGKLqFWjZo2jJw7f0poIzA11E+5DOd9QpXHPBctkm
	 aXL7/EQ1jBaNOltXQY8TOlRzUVUeOuZeFleSqxkwIXpDglbmSm2z0w3JNs1VHpAgJW
	 1rRVO5LLmcTKWp6hfGqW6USVhXSF0Hy89OyIfVF+PN910L61IF51zPyKT7/5Cc/IzO
	 +lMNly8g/JZZd8OipuKrx+9/i+anV0+19Z6p4rAX9De1ybgSu/iFkOj57mi030X03f
	 G0Hd/NFnhIJHg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 5/5] svcrdma: release a receive context stranded by a
 partial Read post
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chuck Lever" <cel@kernel.org>
Cc: linux-rdma@vger.kernel.org, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>, "Chuck Lever" <cel@kernel.org>
In-Reply-To: <20260922015128.240977-5-cel@kernel.org>
References: <20260922015128.240977-1-cel@kernel.org>
 <20260922015128.240977-5-cel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 01:57:59 +0000
Message-Id: <20260922015759.E39AB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> When ib_post_send() rejects a WR mid-chain, svc_rdma_post_send_err()
> returns zero and svc_rdma_post_chunk_ctxt() reports the Read chain
> as posted. The only signaled WR in the chain is its tail, so a chain
> cut before the tail posts nothing that completes.
> svc_rdma_process_read_list() then reports the Read in progress, and
> the receive context waits for svc_rdma_wc_read_done(), which never
> runs. No list the transport destructor walks holds the context, so
> it leaks past teardown along with its rw contexts and their DMA
> mappings.
>=20
> The caller cannot release the context on the error, because the
> posted Read WRs still write into pages it owns. Nor can the error
> path drain the Send Queue. The drain's marker WR needs an SQ slot,
> and a provider that has just rejected a WR cannot be trusted to
> have one.
>=20
> Park the receive context on a per-transport list, as the Send path
> does, and release it from svc_rdma_free() after the drain and before
> the rw contexts are destroyed. svc_rdma_post_chunk_ctxt() posts only
> Read chains, so pass it the receive context itself rather than the
> embedded chunk context.
>=20
> Reaching this path needs a provider to reject a WR after accepting
> earlier ones in the same chain. That has not been observed.
>=20
> Fixes: f13193f50b64 ("svcrdma: Introduce local rdma_rw API helpers")
> Signed-off-by: Chuck Lever <cel@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922015128.2409=
77-1-cel@kernel.org?part=3D5

