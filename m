Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793008196;
	b=sUt9fxrNSIkdNLG0mMeRAN1OFu2X32vyg2IZoseO9/6ffkV2tcBz0qf15MTDXSpoRbGD
	 7ZozL5hkRp7lF8dhEicGdFM/gHBdNJTTGyjs8EqoSmD60zpHAj7dQnRp8U7dTMe7OBX9j
	 aeDpruXc5K8YfSux8lZZkgzuXSqvOWrQHExTqT2vmfr7bxoXMalKXLhC7qdTJvlLuVEMj
	 x4wb27P1C+WZRHMFeZ3z59TM0uaa3DZwJ7+DzZW2ct+lDpzSKDj1RLFq9EoTzAhdYrJ+9
	 GsLuwiL7HYqp0wZtYgg5tE7ZxD1gths/HKsoBhySpNkmkT17OSIgKx3mVON9rUHbAIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793008196;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=m7Bb3lmIPMoRwicxSMfnkD9ChOITeFgcVwhQCOjZH+s=;
	b=Fmp+D1JuC+Cp0UDWMq5Tm5O5Ker1QsJDHjDQxDJOOeuRPz3KZxPsmotWjnnf69xQ1Q5Q
	 mRqOy9tw14nCePLU5LJrPpBTuuVo1D5Jj4Y6HQ2z3e9zN2A6jVNsXtdypm/FY6cDl+Z6d
	 Rg0IwSYp/Zv9eLfddA+kE4T33NnFDR/3SDyFcwq/IjMJStGVGQKfaWDOHHe9xPJJ89CCb
	 LadKyBRPgW+0BE7L3lkJ9rFbdBOvHLHZJbJ2UI1rpF0JtRJiygG+iRE7Er5wiwjD9/BdM
	 sdQ7PlPbzA96M1pxenGc/hY1127szTNoDyCpDP53MH/8T5ghEaZxGfyaGIRUJf722/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fCBXKkhA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDA2606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 09:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fCBXKkhA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C778F1F01825;
	Mon, 26 Oct 2026 09:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793008196;
	bh=m7Bb3lmIPMoRwicxSMfnkD9ChOITeFgcVwhQCOjZH+s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fCBXKkhAOgDznirRkWf3syPltRRj5cG+twC/dfBKnUf6Fs1E2dJXZLjaPqY7Gja4I
	 C8DZuv0tH2vKbGQ1sZ0jFVbB2usCyqeNQl2RS5h2BBQCoFUrtlHqN0/lX0f6ky/H1I
	 EVgg18yHf91miDSwuULJR16mja2XK97q0afoXk3gkHTRiWECKemFoShqBEyMiE7hLk
	 YS9GSQY5tZbwmXkge9N0oaKgDCnZE11iLGt3UQzeRbz79vO8ko1opYasDBFPLd90e7
	 26dTU/wefqtVoEHXxFdGm2i8wBIwUJ7zAtzSYcE7oUDtK9MHCUozpi0o7uHQJE6vz7
	 Bakg0r42lK8+g==
Message-ID: <sashiko-outbox-184839@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 21/26] treewide: Rename
 dma_buf_map_attachment(_unlocked) to dma_buf_sgt_
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261026053623.202642-22-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-22-apopple@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 09:49:55 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Jason Gunthorpe <jgg@nvidia.com>
>=20
> This map function only works with SGT importers.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> [ also rename the io_uring zcrx caller, which the unmap rename
>   used to pick up, so that this commit builds with CONFIG_IO_URING_ZCRX -=
 apopple ]
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026053623.2026=
42-1-apopple@nvidia.com?part=3D21

