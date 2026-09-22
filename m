Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6FE2264A3
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 01:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790042282; cv=none; b=gjbgs0LlvTxwJ09L5x+XwOTBXp+NUVoHneJnCoUuv1oGDgNTk7g5dtuAfjnlGAFHcRV65x06IqXhx0nFQkmD8uJZlXFcTab0oV7cmQTVP03pU2WKAgVhBar7nN4Zqo3Yk9PkgObTXx6PGPUjc1p3O7CBaf6MLwkG9RUVpVqgHK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790042282; c=relaxed/simple;
	bh=M1FkE5CCB7kCUNd9cSZoeR9MulEH9PT4X5r6O46rp6w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dsJW9ojyeuqnLq4XfjnhtHVtl+1WpIXDWdmwAwtNr0vfHAM4hsOXOTFpk/guAWupAvzAOVomQJTAFPPpUj11YWUb86wrtZDvaZe9AK5cMTR6dSrdn8Lo0SGVo8giqKKffcBCu+RULWP+eMA19gm6/9GacN7eZSofxSWzY+AbnDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QI3p2ywb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QI3p2ywb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC60B1F00893;
	Tue, 22 Sep 2026 01:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790042281;
	bh=M1FkE5CCB7kCUNd9cSZoeR9MulEH9PT4X5r6O46rp6w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QI3p2ywbtvfOcfkNOHdpoLhJIsCWrBd5jH4Ug76ozbNfxfjS4QISh2URJvzLUKvew
	 FC9WHmTCcSS3bRLAHtHpaxuKcXkx8IzyI7yVUnvWdYvcAdktFWbUWTcxQRr76ioGj3
	 nW150Q1HcBkOarVEidMd/vDluAGJNlCiWG3TU+CcjrbfE2gzr2wI6bv8DknF29i3mJ
	 8KsK/xJvK4DiISqSR9g0C9yFO/WygEV9EFWR8VzZ3v+t45QPfhjI9NkOdJXGY64cNJ
	 vXuFFGUQdjftEyhJewTFCsQJlmhfTUDzsJa4efV/c6sUbutXcDWelyg42VgFF1CZbZ
	 bKxzXDkWE26rA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 3/5] svcrdma: fix a page leak in backchannel sends
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chuck Lever" <cel@kernel.org>
Cc: "Anna Schumaker" <anna@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20260922015128.240977-3-cel@kernel.org>
References: <20260922015128.240977-1-cel@kernel.org>
 <20260922015128.240977-3-cel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 01:58:00 +0000
Message-Id: <20260922015800.CC60B1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> svc_rdma_bc_sendto() takes an extra reference on the page that
> holds the backchannel Call message, so that the page is not
> returned to the allocator while the Send that reads it is still
> posted. Send completion once dropped that reference, back when the
> page sat in the send context's page array. Commit 99722fe4d5a6
> ("svcrdma: Persistently allocate and DMA-map Send buffers")
> switched the backchannel to svc_rdma_map_reply_msg(), which
> DMA-maps the buffer and records no pages. Send completion no
> longer touches the page, but the get_page() stayed.
>=20
> xprt_rdma_bc_free() drops the allocation reference and nothing
> drops the extra one, so every backchannel Call sent over RPC/RDMA
> leaks its send buffer page.
>=20
> The extra reference is still needed. A Call at or above
> RPCRDMA_PULLUP_THRESH is DMA-mapped in place. The RPC client frees
> rq_buffer when the callback task times out or is killed, whether
> or not the Send has completed. Record the page in the send
> context's page array so that svc_rdma_send_ctxt_release() drops
> the reference after Send completion.
>=20
> Fixes: 99722fe4d5a6 ("svcrdma: Persistently allocate and DMA-map Send buf=
fers")
> Signed-off-by: Chuck Lever <cel@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922015128.2409=
77-1-cel@kernel.org?part=3D3

