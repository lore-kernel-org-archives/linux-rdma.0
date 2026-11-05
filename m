Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793902568;
	b=OPbRgBTu/Cg4ChMIt+lwsU8dwcFyuJdVSeysjb+71PoJeJQQWCj0QLiNK6Ax7ZfYgMAy
	 Vi1WJeT7eBfa18NdhlxI6J5t3wJYpxTWk+oqrRH3YgVwYCxIi1JkCZNziK6NxGqnWQ2v7
	 7rVqS9v8G73t2fgnz8ouPGIykIzIKxwcX4IIw215efttlN4ITgECx3uoBsJoYLl/aRq+9
	 Xcm6a3K5sAfzK7HeoSmHWSN5uIGscL+4GvuXj6bZkP6Z10KMe59LIVDvOhxo7ov6ZTlFo
	 PJyHTlX5rPtdjPMCdeWcnykG8xtA+KtkazYh7weVLxeF08ck/DLvte2Qxb6nAfYjSLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793902568;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=g2a3bsWb9ANzI60S1La77alqKWeTPLsnUR76kH2hKnE=;
	b=0zxKMuYrxaMK9wBpItu9giIEReJbf7e2VuKfdTKYkijD03bCyKCP2iDP78EGDK9euZpR
	 xicVngYGbUOEizWvEzfQjFeCGv8wWL+v3JjmxrWXYPNbYyi80sLTMnm3gPefcDIms0Z1k
	 yVlwwETK4alwNuYuW6lok6qQ1SoL+KpLEncgiDscCFz6FagTk3Ly5aBVKsgrJBjtHs9bF
	 KoF25m9BGkY3eRytAUKbCl5kol6h4jEjbcXLYa1ZdFRx/j2D4OHhe0gh7VxpKPGhzW0Yw
	 x87IOq6D2hhUNaSxdaebt7X/Nv8Q+L8VspmHYdjv2ETRl+5tcINAebcH0Bkkng6eU4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OG26MwW5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25CD606A326
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 18:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OG26MwW5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C021F0093A;
	Thu,  5 Nov 2026 18:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793902567;
	bh=g2a3bsWb9ANzI60S1La77alqKWeTPLsnUR76kH2hKnE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OG26MwW5mnSHRUd7luQ42zKwdET0ahfk0iFJlGW5bJJ4KfuoZvxd9ydeWNDOwoyEU
	 ZFZqD8dwrkgFosnlVqBeldxlSRpe0YtsRkFowQ7gYoiZYToz9CogYsuVvFJXd5Qpy6
	 3IQ54VT8I8X126NclfyLhDIiYCUDh7RHspnpBMWzb05hn70OpI+Gupjr7OFSiTwLN2
	 DVTTpaJDBThgUYx+Z/Pr9LPo9P1ebT3wLvpF6r6nJT5qUlC4GAEfMEpSAF8qk72S7Z
	 BC2rXyCOtGaRT3wXr/X8BZgGfWvN/RjJK7ju2POhG3LmcxtDsYqEle74We+rMOAaZf
	 4lW44hOxq23MA==
Message-ID: <sashiko-outbox-199713@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v9 8/9] RDMA/mana_ib: Flush and notify CQs
 when kernel QPs enter ERR
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261105175928.1326682-9-kotaranov@linux.microsoft.com>
References: <20261105175928.1326682-1-kotaranov@linux.microsoft.com>
 <20261105175928.1326682-9-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 18:16:06 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Complete the RC software flush path by adding a kernel QP to the CQ
> error lists when it transitions to the ERR state.
>=20
> Invoke the CQ handlers after the transition to flush pending work
> requests.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105175928.1326=
682-1-kotaranov@linux.microsoft.com?part=3D8

