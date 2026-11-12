Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794448380;
	b=NIswzw+eeRHno3zidExGcoV/PKELQrN+aQdAxk1zn7aUvUsM4kARFr/4uS3kManfy/74
	 9oANZ9vdvUFEfQ89a2hZk4GsnUk9UZ8wzaT7VwKr2BHA8HXjFNGeIBt5TetJD5muADYv3
	 AWXYH2duJueu6qkMTU1uFP6/zpaJIiGqBfKMDkh41ZuQ8n+SiUJvbSU1HWSnJ/2KE2Dgz
	 osxXqFABUp7Gz+tQsGT3YtHt2y057RRHh+rp1jPhoMZKgA6GM2cNRWisipPiYQ8XK/Ze+
	 aK/LBw0o6cQ2yfqDTosTTKS+f8KlZgT4ZKkoCbub0tnxRoO2YsZa6LNFzB+7BMY2Zlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794448380;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Ujqj6M7uAoap16ZQVldtsE7gvRXsLRMZlp3NMeUxSh0=;
	b=1/JxojrEVHhE6pZcvhDg/BsJtygCIFqePDEVDIXgyVQ35YYemJmA3b91i88Xw7jKKKX2
	 aXtFE0S++l4j1zn1cT8gx2e68M940z/YCeGI+4oQAQoLuEx4VAImXZBVi7vvlwdU+VlDv
	 zouI/YxD92Q7ft5qf4lTYpnNRwAJSLmBnU0N/TsXIEk+G0wTh8dyQVnoHXtHnnBQFLWAG
	 hVpuIrpNeInumKPsXSOVE+LHNUCDXRJa00yKrbf/z5XETGyY9DocHEArBMwAT2mcHTa4D
	 REYoOGjm5hb4WvQrtUeg7+hiPPvRsP8FTUmu3bQGIYut3a8969I0XVCYqeohF9iOF/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GdJiAR3b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E992606A321
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 01:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GdJiAR3b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB2D1F00A05;
	Thu, 12 Nov 2026 01:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794448380;
	bh=Ujqj6M7uAoap16ZQVldtsE7gvRXsLRMZlp3NMeUxSh0=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=GdJiAR3bmmYejpXN76kCvHtzUzjY6ezFE2echXmfvSFUfA2ZC28PZM85mL+A4OOA/
	 Rwo8ldkyFaOAcIjGAwEii5Rg0X9cgsq50tvkwBzrwgOHWXcmYMTHatCFPIsfbjpMze
	 yHJ8qO8NDKGiU2629MhWXKxQdfa0kuuFV+XHQdYcWWoiYBKjccjcap/K5GQAtYJbtN
	 xcMBdVyMMfFmzbu4hFI0XO8JHMCpN/KM5b2mwqqojFraAEE1IsXq2vTDJpVdjG9qzN
	 6updw1tSOobzC28xF+A0IGLJ66/0VbGvAtSnSIWHpI9WmwPe+iTe+99L5F3Xbct/+K
	 WVDGFcUWuIZZA==
Message-ID: <sashiko-outbox-210107@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 rdma-rc] RDMA/ucma: free a queued CONNECT_REQUEST
 with its new context
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yuehong Wu" <wuyuehong@cmss.chinamobile.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261112-ucma-conn-req-ctx-v2-1-yuehongwu@cmss.chinamobile.com>
References: <20261112-ucma-conn-req-ctx-v2-1-yuehongwu@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 01:52:59 +0000
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
> delivered to user space is queued on the listening context, but it also
> stores a plain pointer to the newly created connection context in
> uevent->conn_req_ctx.  That context is already live in ctx_table because
> ucma_finish_ctx() runs before the event is queued, so it can be
> destroyed without ever fetching the event: the ids are allocated from a
> global xarray starting at the lowest free value, and DESTROY_ID only
> requires the context to belong to the same ucma file.
>=20
> If user space destroys that context while the event is still queued, i.e.
> before it fetches it with get_event, the event is skipped here and stays
> in the listener's event list with a pointer to the freed context.
> Destroying the listener later
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
> Free the event in that case and return the backlog slot it consumed.
>=20
> Fixes: 8ae291cc95e4 ("RDMA/ucma: Do not miss ctx destruction steps in som=
e cases")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Yuehong Wu <wuyuehong@cmss.chinamobile.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112-ucma-conn-=
req-ctx-v2-1-yuehongwu@cmss.chinamobile.com?part=3D1

