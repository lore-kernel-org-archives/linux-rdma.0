Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795101820;
	b=SJKmpb0JH1YJqyloOWsJA7TY4TMmvViQJPxVE8LzJzzt2FpPjP9XXagUrz8KuohR8OVd
	 5h6aIfjR6aiYYC1Y6OglUusic+fW7Q9dDSwJwsuB+bVZkvIM016agHAa00LbVcNY9XOmV
	 fKFG9pGlP72ZYAsEhTKKcwgEBt1qrPXiAv4CQp3r6Fs9nkZ6XpE69g4Im4NUaFxR6yeZ9
	 r1OBswoQnKoFzakbMm0ubMQufOr9v7AdwIfe0VzSNkm/RDNRpp0eeewX6iaJqPWaXKdaI
	 JAG2AICm8KuS6t7Eze53NtneVtpVW861C6bPwtHtloX+69Yy5CINnRWXuyq8QSX7ZZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795101820;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ZgMSkj8IBp+A1nhH+wEwHRNPhVqTBdzxsJBHVlvK7i4=;
	b=2fQULQBvP88KnK5+owdDeDoy1g1YEYBTIVbgrJugas0Jc0nnNLQpnRD0hbSVC8VWmTEv
	 I3nsrweNywNwkG8smgB38Vf6owX3qgL+aK3vjCWqqmq6n0RrDybKEVzcfi/KibCZ8fpnu
	 Q8ln0FhS5sAidI3C9SYCs3ssS8gG2o9QRWit1r42L/mg3Sg0XLtBMHvNS/HXR61PXicD5
	 FeZ/Z+SSXqlAKFhVk8/gr1q2PwTArlBbxrk5pxGYY1krJYIqddvgCcmSDC/fu2bnSs84L
	 OaPebhL8xr9YbCedSn0Tj9SYFL+B+UFJG2OMrC+hZ7EcFWqEcZko423s+86lEzoxFzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dX8Mjgr2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33E7606A325
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 15:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dX8Mjgr2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708501F000C4;
	Thu, 19 Nov 2026 15:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795101819;
	bh=ZgMSkj8IBp+A1nhH+wEwHRNPhVqTBdzxsJBHVlvK7i4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dX8Mjgr2Gjts37xPfnmm7asHCF1hPY9OMC/6SnRN6WiTq5IAiBrQMBgV1ZVRX2rcV
	 qSVZVSkbIjoEeVb26hSUHCJxD14ipt1VTNiq69kRsDsS9AM+ImpffGUjxCNgfaBEPy
	 X8ue/qzXwYlTJVEGD8/Bat3o3h4pUIFLMPHMnQG3K7YTe0RhdusOtvGNYlDC1wTTZ4
	 QwgCcId44A7tY2h4EfwMd/0PG2dzrSmlelVFrU3t0Yl+UQxaEOO1HfIdxVxbpO7G51
	 sS9Zj1B+P73+B05XB6BsqbiB/ZzZCPz0QHjWpg7F7CnsGO8veUWfyZgxM8vWaTl6xn
	 yDV91ld33WvqA==
Message-ID: <sashiko-outbox-223376@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next] RDMA/rxe: Require a responder resource for
 FLUSH
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Stellman" <astellman@stellman-greene.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261119151332.95466-1-astellman@stellman-greene.com>
References: <20261119151332.95466-1-astellman@stellman-greene.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 15:23:39 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> process_flush() keeps its state in a responder resource from
> rxe_prepare_res(), as READ and ATOMIC requests do. check_resource()
> refuses those requests when max_dest_rd_atomic is 0, but it does not
> check FLUSH. With max_dest_rd_atomic 0, qp->resp.resources is
> ZERO_SIZE_PTR, and rxe_prepare_res() writes through it in
> free_rd_atomic_resource().
>=20
> A FLUSH sent to an RC QP with max_dest_rd_atomic 0 oopses the
> responder:
>=20
>   KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
>   Workqueue: rxe_wq do_work
>   RIP: 0010:free_rd_atomic_resource+0x15/0x50
>   Call Trace:
>    rxe_receiver+0x5f6e/0x9a20
> [ ... ]
> The fix and this changelog were drafted with the same tool and reviewed
> by me.
>=20
> Fixes: ea1bb00ee9a5 ("RDMA/rxe: Implement flush execution in responder si=
de")
> Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119151332.9546=
6-1-astellman@stellman-greene.com?part=3D1

