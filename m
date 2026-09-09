Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384F73AAF6B
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 06:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788936944; cv=none; b=LWuiAOZ7Tgtjc+tFiHp/n1SahwJeqXZh7pHstUjYx28NZBSKD89PwxfekxG2SCFE5koyf83Cu0DaFeKjO6pNcuwPHtlvPut3RlJ0yMdWG6ZZ5R+OrvANb6BkLlMfY4WNi9KZoSZfEzESt+4HQ9lr0rPNZR6BIwVhwWAn0vhIQcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788936944; c=relaxed/simple;
	bh=8PQNoKloHOI9OosnAx0OW6dlo7efAEULjz7tutnp4rE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=t7gSKs+3zBnCYL1CsP5v+D5Iuzxg8u2cr86VWhZt0mpjeEryiC3WWaRmqMR9WW7b9vA1FOV/AR+QJ2zCY5DwmuUe/AT0fvA+24pOJ9r6xOzeg8HoHtyPsLOfOfajPsdGC80Ec/+RsatIxs6jYVg0HxaOKJXZ3eFPhNB9X2lZkSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=odKlG9Sb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="odKlG9Sb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2A91F00A3A;
	Wed,  9 Sep 2026 06:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788936943;
	bh=8PQNoKloHOI9OosnAx0OW6dlo7efAEULjz7tutnp4rE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=odKlG9SbbMuFSyoQL5hYj6OeJSJABr4uVgzujKmhDg9xN6PQXkOvPg3K8yzdbl4Z/
	 D4fdvBL9nlctIP6iGXH5OhqcjwvBzL7G2xJVf/Q9kLPAElqwpyQ1eHPOWmlJ0P9fQe
	 1fE9XYtolPzBL/h2ul1HBlnzF0VtJHNYLgXj2wMfDt25r125c1LfFZAttVuHnfeZcM
	 z+zZl3vTukOcYPiILxdYSNzkvkxzK2z6vkXjpF6IjeIYR43Uc/BAKVEOXauFhR/DiW
	 dfUjzbFEmYR+RVmgZnNDuCN+17YQDWwb1Vz3C8wNuVxGt2XqeZzxI9vc9gD+SWFn+O
	 jkcapzZWo7gYA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V4 08/14] net/mlx5e: psp: Handle
 HW-decapsulated RX PSP packets
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260908065244.3799142-9-tariqt@nvidia.com>
References: <20260908065244.3799142-1-tariqt@nvidia.com>
 <20260908065244.3799142-9-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 06:55:42 +0000
Message-Id: <20260909065542.EA2A91F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Cosmin Ratiu <cratiu@nvidia.com>
>=20
> mlx5e_psp_offload_handle_rx_skb() handles RX PSP packets.
>=20
> Add an additional flow tag marker and helpers for decapsulated PSP
> packets and extend the handler to construct the PSP skb extension from
> the CQE fields (SPI in ft_metadata and PSP version in flow_tag).
>=20
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908065244.3799=
142-1-tariqt@nvidia.com?part=3D8

