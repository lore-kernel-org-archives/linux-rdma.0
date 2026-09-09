Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38993B0AE2
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 06:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788936945; cv=none; b=PUt4tRrIbeHIdFhgszFTvWdTk44DK77jJOZmMJEh0F9jnbDV65Xj0tNJfegIR8jSMfm5xdyskoCJ7JKMlvZWQnq3HWSLPDh7wkP6HqcTtxaD8aC3dB4+qO5bkYNiMqgw8aKUytfeq5Z/rlFklv+yd7UYq010n14SLsfnyoYntTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788936945; c=relaxed/simple;
	bh=OGexAyBjS7uGHg1b8S5y0EIx1QJWHModTD2QIKCe384=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Lt7fCHOcj4gSEEcQV7wOp5NLdR/EqkDMgP6gkN7aMRh5+hq+JGEu+eMl2/3lzh/n7BxODkLjvUGEh9Mqb7kmMNhLiFfbX6nl2XXEifKvcj8240jxytt17oc3pNgZs0K3a6eJBoJj4vg4ltwoBauoNgqRyLgdZw0dANLO8VS9cHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X/ENJwT2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X/ENJwT2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1781F00A3E;
	Wed,  9 Sep 2026 06:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788936943;
	bh=lOQvkERdCrxhjeACzqeBLsseAjEveaBwwsM6fw7+Whs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X/ENJwT2rZidPDzEmFbVDwVFXerbenBWP0Tvuemsi10oxbddPgw5n9KeZUhu9+XXO
	 AOpSP+wLSBcxisXIWqdgNfuTEvkfpNqrng1k/TCRXnMDdiHQPnfpJHiomRNIgr18Kp
	 d/uVXL2jgJ4RF06SBhVi62DlVYarZxKkMPFx0tknRohKl4h6aBNqOmiUvcs/fFrnUn
	 rEKrtI2Lxpq/zJnMz9kmC0ecmFDt804TXp/fT4osaZ+03HKCBBRL7PqpQJngfRVx6i
	 ETfQNfgtNHi5guQuPpcmjHAEmT9m4SGT3yK0WHTDk+FCdlqHxmTuZn+fPyGxqvUMJX
	 ZmJYsZdz6/PaA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V4 09/14] net/mlx5e: psp: Add an rx_decap
 steering table
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260908065244.3799142-10-tariqt@nvidia.com>
References: <20260908065244.3799142-1-tariqt@nvidia.com>
 <20260908065244.3799142-10-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 06:55:43 +0000
Message-Id: <20260909065543.9C1781F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Cosmin Ratiu <cratiu@nvidia.com>
>=20
> Introduce an additional steering table for PSP transport mode
> decapsulation, containing:
> - one rule per supported PSP version which does:
>   - transport mode decap (removes UDP+PSP headers and PSP trailer)
>     - recomputes iph->tot_len
>     - recomputes IP checksum
>     - reparses packet headers
>   - copy SPI into reg_b (which ends up as cqe.ft_metadata)
>   - set a decap marker and the PSP version in the flow_tag, so the RX
>     handler can make sense of the packet
> - default drop rule for unsupported PSP versions (per PSP spec).
>=20
> Packets are forwarded to the previously added rx table, where:
> [ ... ]
> on HW GRO.
>=20
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908065244.3799=
142-1-tariqt@nvidia.com?part=3D9

