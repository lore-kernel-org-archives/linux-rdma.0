Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794408193;
	b=k4WnkPgWBG8VxTzMMyanKveiKyzLBmKIJDjRlxQ3myvmZjG99KskErBZ7D76x3ZnhS53
	 oC4DkR28NjlzaRbTK0gtWnyZ19lWsbDix2+D86jiyW8kD6zmYHWfXAynT7sUt1+heZb3w
	 nxgk+IjXGtpZcYOYq4u4b1XT37VH46Yxs0/jvVTJteBaSQSIA0Di195h4VvxuFG5dWcmf
	 my5A6Sfzw4zbtVRyg1xLYSbUWsexayP2Z7W0B01btRSUcpxjxevXY3CcAMOMFqODalZZq
	 O0VIJpXmg2hhOU2Pz2RB9UDZo0Lh0+ga+dBCK3kk2VZQWFvMDZwpC60f/Ys8B/652TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794408193;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=QZ/jjMaavQFC9NFDjTTyQN/mahaSvEO/Smbts2yoNvA=;
	b=FQ60vHihfZsH5oV6/j78iVeD+cP1KPn6KtH/OFkM7RK/cAM6wbS7pN656GUS5UpfaK2b
	 e4aZeSHEcPByl2YEarf6SRIjAFdIuDhzR6Qf9JksLOLaBtDbH3NIxSEOGXyZ1uICS6swu
	 PDjP2fCUq/9WhwX6/aFc2qsdbg7ynq57KUx42hQTIRs1MRvn8ev8k1nnabJs1oTOw56OW
	 7hSs4pdBdk0tUkVElERz42CvIXC4+6IZZhA16g0i/DRGk947LBj8OzUuSVzNXG59wvepZ
	 XSQp2wY8aLgqhaw/0aKzXc5X5VWpPwBtgXpRXCT+lSeeKFv/ah4263EkEJvyU2gzykw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NbBagsV0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF629606A338
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 14:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NbBagsV0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07DB1F00A05;
	Wed, 11 Nov 2026 14:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794408193;
	bh=QZ/jjMaavQFC9NFDjTTyQN/mahaSvEO/Smbts2yoNvA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NbBagsV06u6/zzDJV7rJN46W5hMNXQ8cr067C9pjzKtfBrJAhJqJNYFL3nZ/BwQn9
	 WnhbgHHcZWKCi0vfScyfMeDdG6mc6kgrwb+U4zgbvNv7aOxLwVHuCaxvcY+Gq9J1nV
	 UuYu29Pwh993F8AaY1uPEO+oupStRmYWMZ3JAKJqdAXws0VpXon1mhpEO48Xirjpbt
	 3NrD+zYy7vc9ou4WnpiQuEaJ4BQRko6GHd+l6GbTWQXExNYYmtqrpw+JtCfWop6XyB
	 XgsHwAr1SbsRqSw7eZtiU3SStzChmdjYgUDKCbRoHsg6UVoZ+xPCdILVlXCcax60Yr
	 VY0Mt2B69kj4w==
Message-ID: <sashiko-outbox-209180@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 3/3] RDMA/core: Don't warn on oversized
 bundle allocations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Srouji" <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111-devx-umem-mailbox-overflow-v2-3-1e7ca8237b58@nvidia.com>
References: <20261111-devx-umem-mailbox-overflow-v2-0-1e7ca8237b58@nvidia.com>
 <20261111-devx-umem-mailbox-overflow-v2-3-1e7ca8237b58@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 14:43:13 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Uri Dar <udar@nvidia.com>
>=20
> _uverbs_alloc() serves requests that do not fit in the bundle's internal
> buffer from kvmalloc(), prepending a small list header. The requested
> size can be derived from userspace input, and since commit 7661809d493b
> ("mm: don't allow oversized kvmalloc() calls") kvmalloc() WARNs on any
> request above INT_MAX unless __GFP_NOWARN is given.
>=20
> mlx5 DEVX UMEM registration is one such caller: its CREATE_UMEM mailbox
> scales with the size of the user's UMEM, and a mailbox that passes the
> driver's INT_MAX check can still exceed INT_MAX once the header is
> added.
>=20
> As with memdup_user(), an allocation sized by userspace should fail
> quietly rather than warn. Pass __GFP_NOWARN so such requests fail with
> -ENOMEM.
>=20
> Fixes: 461bb2eee4e1 ("IB/uverbs: Add a simple allocator to uverbs_attr_bu=
ndle")
> Signed-off-by: Uri Dar <udar@nvidia.com>
> Signed-off-by: Edward Srouji <edwards@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-devx-umem-=
mailbox-overflow-v2-0-1e7ca8237b58@nvidia.com?part=3D3

