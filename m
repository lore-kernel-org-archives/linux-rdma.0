Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F255851B177
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 18:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789755157; cv=none; b=DAUOgO2KAn4bHugAPrvQXqcY5YRCjP7C5rjqK6paRtUTbaaZ/K8eEyhK3vhbGJhbCqeNYpgoUuCviqt7jc9OdBk5G0fX2M4xLZ6e6zIinTnsQv+Il+XWX9feDwAQ7FYl4XNdRTEO6ASPDeZSVmPZX355FDNx95oA6kQPKhtWF1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789755157; c=relaxed/simple;
	bh=5ISpNzwPNUikv0K6t7K7A3DPHt9h5UGmqgU422w3IY8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=N/Cu6/fcqdh889gTGFrH1VID8z1EJsOgLlqbKW0t0uunwhoakPB4evBk3FWExdnFt+y4d+QXn8fb3Orf6/hI1zrFglsPfTjeGE8zDgpyLPq4XLTU4zs2eIfdgiyjBcETk610NyIUraOv7IGuVAZpLIXbpL0Rd38NrCng2PwgJ40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QtzT8Gvj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QtzT8Gvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A0F1F0089A;
	Fri, 18 Sep 2026 18:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789755155;
	bh=5ISpNzwPNUikv0K6t7K7A3DPHt9h5UGmqgU422w3IY8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QtzT8Gvjk+VyQZFBiIcTD/G/8w2mFBjFpT2kIMJzPyfjXSQ8qJD2kB7Cv22/wni5M
	 T/iTeBD0WcTlAgrPxjcbE+UfFpoC03tEc0Kayv1e6+R7hBL85e6BXWcqBmLc+d1dIp
	 YTyFY6cJbstnT+bLgsq/Pv3iOtFkKNni0OsGsiSi91VE9yDqk0BHNxqmauLIyi3bJO
	 jNbB758FzQQLAm1dxnvEiJc1OgCSEdEc0kgLEXRw3bozqY09Eq4M+RwLKJbU53qVgt
	 cemdfLsgmqw+edGycL/VeczlP5X7sKQ8bU81Y4m1i90aI2Ux4EJ/DOhhgEVTwYjtU1
	 AAuUm1/iFHMaQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 2/7] net/mlx5e: ipsec: Block eswitch mode changes
 before accessing priv->ipsec
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917175433.4090878-3-tariqt@nvidia.com>
References: <20260917175433.4090878-1-tariqt@nvidia.com>
 <20260917175433.4090878-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 18:12:35 +0000
Message-Id: <20260918181235.B2A0F1F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Cosmin Ratiu <cratiu@nvidia.com>
>=20
> mlx5e_xfrm_add_state() reads priv->ipsec and validates mode-dependent
> capabilities before blocking eswitch mode changes. A concurrent profile
> change can free the saved IPsec context and cause use-after-free.
>=20
> Move the mode block before the first context access and release it on
> all error paths. Keep the atomic acquire-placeholder path exempt, since
> it creates no hardware state and cannot take sleeping locks.
>=20
> Fixes: 22239eb258bc ("net/mlx5e: Prevent tunnel reformat when tunnel mode=
 not allowed")
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917175433.4090=
878-1-tariqt@nvidia.com?part=3D2

