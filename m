Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F10366075
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 06:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788936939; cv=none; b=YA/66nsqdxWVB8nv0OSHYVmJsRYWU4V5RJ3oCLcRqS4t2fspKppjnzcraMZ07EvRqSRRtBFNteB+innaQawZ5u74OkOoB6YGLp6C/H7sbTaN3aSEsId4vU5ZLH+nQa9HKHQslSUxP3/mszF5mpjdmaQZRWwchShhzw5VWAkegSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788936939; c=relaxed/simple;
	bh=UC3Um8PZzh6KI4HDNgrAJTyXk/fvT7dd2nECHdkux/4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cuRTn2LMXNq6QEhetRPMhOVsQHTp+bzHZUDTxQ5RMRdOPg0+OlUUZc6cUimHqXK1G93D3PnFntI80YkZ0ZZI+xZbnA5rEwVcPWFA0JuA7vWwaVo+J6P79epZLx3GrO/6LWBwyC7qE966qQBiYX7azNkL4RwXB73JfmWZykgskpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SDN0GFy7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SDN0GFy7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 436C41F00A3E;
	Wed,  9 Sep 2026 06:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788936938;
	bh=UC3Um8PZzh6KI4HDNgrAJTyXk/fvT7dd2nECHdkux/4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SDN0GFy7OfqScrwe3J9q0tCIhhVCEk1lNpG4bcwDvaGToS3sKyoR73SQrBjyk6wbe
	 T9pFwSLIj0GW0rIcKJwKL8iC2ZpLCL6TpBo8fvrbIUKTNKDCFP5Q+ksLABqGOcgobL
	 JxuNI7dCHRmRiw22ueiNzu5o+XrD667AwvpDsDHIeP8Hqta1ahpmqUJxBy9p/V2dMx
	 Jm0TUV6sKuPZAAM5bsytQItgA6aH0fdbqFpEb5A6L64FopvYmzKEML6Diz92albmqK
	 y+nkAyY9aDwYj3dYivO8fz1jw8ScvEMfKNkYulBjq/J5Cq9vaZmK3SlTSwadT3BX/8
	 gp1Z4q5iBf9Tg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V4 01/14] net/mlx5e: Generalize TC <-> IPsec
 mutual exclusion
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260908065244.3799142-2-tariqt@nvidia.com>
References: <20260908065244.3799142-1-tariqt@nvidia.com>
 <20260908065244.3799142-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 06:55:37 +0000
Message-Id: <20260909065538.436C41F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Cosmin Ratiu <cratiu@nvidia.com>
>=20
> There is a mechanism to mutually exclude TC offload and IPsec offload
> from the same interface (commit [1]) due to ordering issues between SW
> and HW paths.
>=20
> TC offload makes use of flow_tag to carry the tc mark (even when 0).
> Upcoming changes to accel protocols will make use of flow_tag to carry
> the protocol marker. As the flow_tag cannot be partially modified by a
> steering rule, the last rule setting the flow_tag will overwrite any
> previous ones.
>=20
> This means that TC offload cannot be active at the same time with any of
> the currently implemented accel protocols (IPsec, MACsec, PSP).
>=20
> [ ... ]
>=20
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908065244.3799=
142-1-tariqt@nvidia.com?part=3D1

