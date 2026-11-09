Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794194494;
	b=PTWxghGP/e5mzXWtiKwMQiLWaM+mmlo3dHK3N1LJUEKHy8rxpaDQrdkmNR4n5ZM+gw8Q
	 ZYKeLl46O5ENtya4iE99Nxr3hfM2eYW7xiiqyAYo/dYlqM/UOK/54XRzoBxrLSVVIWJ/G
	 t1hN0z3qu64EkmQzQDErQQHhzQ8pR1w9if16eMXiLbpQ6MPwxEC9AOJ9jwG2UaZfQdC7T
	 Px9LInp3zwSiXUsO/j96iJyMInTts7GcZI6xyUn3cH7f1IUHtRfwodTMvKcAaYZX0iVBY
	 o8xtgBWx03aNdt6u171c3FRNPGmm0Kv/xG1nQ0t+qG0xw71LjgjYUF//+ffhL5bNJyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794194494;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=IBmNdkq0B26ZcqwPNdL3HBXxTkLv32AVCUmtaFXS0wA=;
	b=g5OktgR6JIuyVL1a9Y19bVTWdaqEAqGX4FbJS3t9hI+rH3o5RC6frFVrS9PrSez0s7hg
	 qj1U8csYruQ0WdLuKWobpOWCLortn65hAUoqTddUbq6iDQVheAr+576bV2SGF0KwvKBTF
	 ux1/epRmtmiOpehjQruH+HXK5tHVhzVu+G6DgtQz6k63fotbdPjFt2FAV6mSGPgkVDGI3
	 hgQBRVVEC3bArs14ifwNvGWN7JEwd4GQy+xGNqM1Y23H4prxncWZ+gyNVpNMbFmcw3BWy
	 s+h34xl6upH/uFce6TU/tQ1DAOlWXitdACp/Jc+C2YW57sIpmoGAQi8QNYtVSXa6BRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NUh6rCPo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42E8606A31C
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 03:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NUh6rCPo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB9C1F0089F;
	Mon,  9 Nov 2026 03:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794194493;
	bh=IBmNdkq0B26ZcqwPNdL3HBXxTkLv32AVCUmtaFXS0wA=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=NUh6rCPoQda7aC2P/PJclREMR3e0S1KLpvTStI5ofHIa/3HEl4wlulxfIqU8Dl8vP
	 eMnSDOOPzPOegxKM8juXXgStrq3U9Kb5b8/1VHc0db3kFZxahHLgZsGT06Z4cPAswI
	 F/y5r/eFb1D+2nxdbNlP+jut0DdhyQCVi6KjYxYP02l4xolAsns/gWgTVt+4ZNRWr9
	 8OPsHgd0SkizKuJCoBvWUrboXtCyHTFNLfPDQZZZ3IwpvD2IGnai9iKxWREQmQoLCH
	 ZtoejILMKbGYkGncCMK10Q0bl71TRsp7Ny7IJIesoys6LNGXjsgyI6s5GoFQNq4DRg
	 In81JTMSEBpGA==
Message-ID: <sashiko-outbox-204369@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-rc] RDMA/ucma: free a queued CONNECT_REQUEST with
 its new context
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yuehong Wu" <wuyuehong@cmss.chinamobile.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261109-ucma-conn-req-ctx-1-yuehongwu@cmss.chinamobile.com>
References: <20261109-ucma-conn-req-ctx-1-yuehongwu@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 03:21:32 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> ucma_cleanup_ctx_events() only frees the events that belong to the
> context being destroyed.  A CONNECT_REQUEST uevent that has not been
> delivered to user space belongs to the listening context, but it also
> keeps the newly created connection context in uevent->conn_req_ctx, and
> that context is already reachable from user space because
> ucma_finish_ctx() published its id before the event was queued.
>=20
> If user space destroys the new id while the event is still queued, i.e.
> before it fetches it with get_event, the event is skipped here and stays
> in the listener's event list with a pointer to a context that
> ucma_destroy_private_ctx() then frees.  Destroying the listener later
> (which is what closing its file does) reaches the
> uevent->conn_req_ctx->id lookup in the xa_cmpxchg() below with a
> dangling pointer, and when the freed context was reallocated the
> comparison can match an unrelated live context, which is then detached
> from the id table and freed.
>=20
> The match in commit 8ae291cc95e4 ("RDMA/ucma: Do not miss ctx
> destruction steps in some cases") replaced "uevent->ctx =3D=3D ctx ||
> uevent->conn_req_ctx =3D=3D ctx" with a plain "uevent->ctx !=3D ctx" test=
 and
> lost the case where the new context is the one being destroyed.
>=20
> Free the event in that case and return the backlog slot it consumed: it
> was never delivered to user space, so it can no longer be acted upon.
>=20
> Fixes: 8ae291cc95e4 ("RDMA/ucma: Do not miss ctx destruction steps in som=
e cases")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Yuehong Wu <wuyuehong@cmss.chinamobile.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-ucma-conn-=
req-ctx-1-yuehongwu@cmss.chinamobile.com?part=3D1

