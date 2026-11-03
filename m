Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793745303;
	b=hfG85Cxy+Rs0EJ4uhFet9rUW22uIYmGxpSpYpTO/1bwLTdzEpikC37/j1izK67KFF72q
	 2sUXHxA5Ms9kXxstF+F2hAqxEM4MAYMOQMTK5tQ4c4dOuEYq1F47ujBQLkuMA/2ooEdgw
	 +ki/pJNRVOReJErr46eY/2XHspzqyD3g+KrO21dDwUFF/wXXVA++5IwJ8DUi2/MmNGLyY
	 9Z4WjnWIHC1+x9J3C2V4fr8sgrnl5JBLsgYq/BRRhMgtboALOaxwVN6Xz3YaPI66hDGz0
	 7laLe5rXHOXMZQlqF90sHZgnYN1pJwABpl3MLJQ+P7UtB/xsW1DLeH5Whc/uzP0fKsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793745303;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=nPInPnEBnx3K4IHFwwzg8qrMCZcqj2DfYlGwLIR91RU=;
	b=wpJtLPrxIm8HzwWQ5wA4NsGklF8SBhINbj50rMNirAhS882nWtqFrgESqtEMLyJpQYSH
	 Mml18H2oqnAEm5BitAsJ2lqmg3ChfRx3ipc1cvMcdCnVZuphT1i1RAvtcXslgH/FscpsQ
	 kFb2iWdGxIyf3D7VtwhvdKvZpOIF/fhFDKDokegQb+KcK16gBgK0Puxoq3RIbENSdNUIk
	 KRhpaP1Dlg/BXaVxi+KXJXi/rNa15rLEs8PcIs4wa4suZl6x8K6veHMpXQFNZKImcdfjx
	 WbYSdJukIBsCSC4HLKrdydIrx1tST4a6CYgQTiqZtYVsH2hmYqKt1jKhphuWD/usrAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F7UdqSFL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB68606A329
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 22:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F7UdqSFL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435671F000C1;
	Tue,  3 Nov 2026 22:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793745303;
	bh=nPInPnEBnx3K4IHFwwzg8qrMCZcqj2DfYlGwLIR91RU=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=F7UdqSFL+EjWH5brzgTR1AZSU/GIXTVzMpaypuL2189u6TIHUtGzCjUR3vBSUaBj/
	 akkaajzVV1SoV1/pOUb6ebnjt+2wnTtPsjf8FfdzDSYn2HMG2na5xqH86gCYe5qZOT
	 IeOtfuiXHVEYwYgJ5u+/M0As1p9Oein8VWl2C08QiWjKDjOXr06GFHEdoN9ljpNlci
	 rNG/BUGzXDHUCBlUsqNFEmPz/kOPAnH8xdzvs4pODihd6mmWMyM9M95vSNY201pIsI
	 FqDwmmO+QnOryH8HxeQGt+IQ/qMeOz82RrcHwuM+82porLLLJBqGgH2feJQQJmdS5r
	 WGcCBjRK4H1WQ==
Message-ID: <sashiko-outbox-196136@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 11/15] RDMA/mlx5: Enable relaxed ordering
 on ODP null mkey
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael Gur" <michaelgur@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261102223325.2115128-12-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
 <20261102223325.2115128-12-michaelgur@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 22:35:02 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Enable relaxed ordering on the ODP implicit-MR null mkey.
> This allows supporting implicit ODP on HW that restricts memory
> registration with strict ordering.
>=20
> No functional change as this is a null mkey with no memory mappings.
>=20
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Michael Gur <michaelgur@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102223325.2115=
128-1-michaelgur@nvidia.com?part=3D11

