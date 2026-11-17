Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794911806;
	b=2Cqwzh09rrXjBXWeq+tWw4k7H1ZPPxPC6AOzFJ+6bFlyZBA2/pIcwBfGGvPu+FWy6YF6
	 cZpR4wp4SM/JgtfTMxi0oASGCAUo39BXhH5CVtT7ZnL3bt3hXEZq0a4psQyFNk1yjW5IP
	 4Tjqt5eBjX9tefcwPhSDdE9byiRMNXZc8RYgaxaOFH+UEoUtDPDkpN1ndgmHxP7J8R4PG
	 viT/NqgDxuPCPgRgV072q9wMx0tp1zH+0sOeFObcXpo4jf4ksfsuqUmEloOFZIsWsOVqS
	 eU/lIKWYmMzBwalJBqnq5M0g8VVnqRrtWwj3gQUaP0FFVHgnoUdL2PYTDWtgtOOg85Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794911806;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jPtNQCTV9hrDdhWyV7GgpSDzYZcAWuyahA8gG8zAiEM=;
	b=kpUwHyvsZ93s87JXPB5L5rszptRzmlhY0YD+WVfAfx/93KB/swfAJr7KgtYOUbjVR4Fb
	 1/lb3+04I2F43zn0+oRuWI7jcG3kS9PZ5UJZg4yy0nVdqMNuH3JxBHLkLwpEAVFOz5KFI
	 CQohr2/RBjD/pQQt8JN2n1GSpGasTU6OI+lgNnuPLcv+XHWx9rmQfsUapgRdFRUj+jLF4
	 WlvuIeBQsX3/t+zR7ySzu8XRPuWraASOS5aAt0TmXU0EOrSi8RBDa8XowRM0zSrrC1Bbk
	 Wl/cffJQY0WBTjDWo5y7f7K/st75qvOGOBPXWXb2b6sywb7RgrIbo867OoXP62199HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GZEGybrR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E28A606A883
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 10:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GZEGybrR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DE61F000C9;
	Tue, 17 Nov 2026 10:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794911806;
	bh=jPtNQCTV9hrDdhWyV7GgpSDzYZcAWuyahA8gG8zAiEM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GZEGybrRXjR9CHt2wMZlcBOtbhmCp2EfjphcZZnqki4TPfPRRCuFqvfOvc7hX89NJ
	 gnKOmzZgh3H0DmFJthOA1dsHfKZDRWOcw/S4fHrioCqYheFw5gtUG8f4ZhiYJDlHx2
	 W8qlYFfsCu3RxGKbZ3+NGZqn/snWqLUPu3zcHN0u4c+wGAJaGoMsuRESj3NG+cQfNy
	 wdVGFhA3B0zoo/jdbiRkovWOTqnIFH8K0s1wMu4I++z1XTP/ChnHg3zylQlgfMMqR5
	 zUh2YyhwJFnC57NwJ9uRcFwBi01W3HxLWYLnCoirAUs8uDVPCw7VOM6N/pnYS+rjlj
	 otUIgv/aju1rg==
Message-ID: <sashiko-outbox-218634@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 06/10] net/mlx5: LAG, rename PF naming to fn
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261116103010.1129666-7-tariqt@nvidia.com>
References: <20261116103010.1129666-1-tariqt@nvidia.com>
 <20261116103010.1129666-7-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 10:36:45 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Shay Drory <shayd@nvidia.com>
>=20
> The LAG member bookkeeping is named after physical functions: the xarray
> is ldev->pfs, the lookup helpers are mlx5_lag_pf(),
> mlx5_lag_pf_by_dev(), mlx5_lag_pf_by_dev_idx() and
> mlx5_lag_dev_get_master_pf(), and the local variables holding the result
> are pf.
>=20
> A follow-up series enables virt LAG, which means LAG members won't
> always be physical functions.
>=20
> Rename the xarray to ldev->fns, the helpers to mlx5_lag_fn*(), and the
> locals to fn, so the naming matches struct lag_fn.
>=20
> No functional change.
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116103010.1129=
666-1-tariqt@nvidia.com?part=3D6

