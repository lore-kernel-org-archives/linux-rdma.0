Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794422434;
	b=JfraPeT6BpriM322KKn076xYT8NcrVstGIJ64NfIQaygnxLbkGoYt7SgATYB8cmcMvuS
	 UPPNQ5WIESU3UtjqzylpLv3CaiWK3RESgQ/gFlo2sx2FRrtdvZyXNSNCRCY2NpRLsGyiI
	 CrMvvtFtkgGveagLZDe2u/vhVnyeQLaenTYk9fAF42N4d6cwpOlPANJacrRi/OgHgluNe
	 FG5JWAIC0S+t9twHkGGaEt6hh68mxawwo75BvGfpF5/gB7I3lFUpu707ZSqt+uK+oEYnZ
	 JYPxxmn8FqLjyoBL06WLd7YKX3oJktkZivQ0TDHcONeEdcZGYCc7cdDNvkzqH0Wf/Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794422434;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=nqdgIqee+0QNFPagWJsd6Lapgy6raEpFm8Y/EFJEMV0=;
	b=P8t4Ws5lOY9jgeSJTcg/4dPw2g9lu16ep4dVmFr5r1M2N7HjHnm6bE7eQOnmq4KNsYDV
	 aA4I/mQp/p859pueFyO6qH35qQSwOA1iEYtRZdx4kI9oQ7Bp8eFr83Dmh+3T9Q1DS4sta
	 gnD1ETYrvIoXUTbVHGwePmhFIGydZWeTGZaIm34LlLD3yBfx7ZuGXD/EVpbZMO6U3AgBs
	 m9umdpJe6ylHV/DaDchVX9dTeLOw9wYgm//A3m/gmY890NE87mXmffHJBaUI1ZwGD1sF8
	 09FR51AmtbJQ1wXOp4jVRQm/oV3XmhHpQyCG8HDTOIVoY/Jsc+TBpd6qnrYfBJsXoLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FqP4sRp7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C32606A32D
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 18:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FqP4sRp7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312B31F00A05;
	Wed, 11 Nov 2026 18:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794422434;
	bh=nqdgIqee+0QNFPagWJsd6Lapgy6raEpFm8Y/EFJEMV0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FqP4sRp7WbWlLunnznvUtivA1s+dGhppm1HCZzN8AVmeuIsAPbt3FnxAuSayV3TNh
	 KIz2WtY4+KZmxTgXGsBVobmmkgWxHZWuIKavlQ+jERI7pCQDZPJpHPcL0v65RuJ1az
	 uI5EZbGWwVqscov/o7g9spdhowXc+lND2OlUB4zW8HThd+6c7AU4cU9J1QQSHG9aqy
	 53wgJK+9pRy7/VdVly1UgnuZoPg9Lpd6dH9mv3oZCJLIZDf2QdDsENwaS466itoXFP
	 CHNN+JF63srevThdWP9+UsmIyUKSnTfHBHkrCGRLF03g/lF1q7x6wq4S68zXdnMhB/
	 Hxs0fEjd6p2XA==
Message-ID: <sashiko-outbox-209473@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 05/13] net/mlx5e: Add data direct ethtool
 private flag
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110183826.2927274-6-tariqt@nvidia.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
 <20261110183826.2927274-6-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 18:40:32 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> This patch adds the data direct private flag infrastructure.
> The MLX5E_PFLAG_DATA_DIRECT flag is needed in the follow-up patches to
> detect the configuration of data direct from the user side.
>=20
> For now the flag can't be actually set. This will be implemented in a
> follow-up patch once all pieces are put together.
>=20
> This patch doesn't introduce any functional changes.
>=20
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110183826.2927=
274-1-tariqt@nvidia.com?part=3D5

