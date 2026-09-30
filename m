Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51383B19C6
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 12:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790771153; cv=none; b=o5IPHgnzVIyqLb1h5MrZW4qfAW2o3lOVs0swWnLzZTdi54fyQB/2HY0TM5ig1Ul5IdD/u80w0DYGK7qRQyb1ekHDZ4c/oZAjI6bXupEMNsB8gTZL/p37T1NkqKYplRcP7hVq2QvCq1mTLbuYkHULJkV884uaDy0cOPMvx6wQMM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790771153; c=relaxed/simple;
	bh=AT87T1sq0GVxAk737AGCAyVjO2uueFy/Kf6NKzOOOq0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QqRgiAS5Rrpk/GAoPVh/sQ48RldEN4X9vDds/q2cnEyViUUqTl5sy5NWFp/hfRAdBQcDZF5cTcpc4BESjHyVkHKJyw75WMbeUqhHYepf/udgnC/gGCUCEOIsg+KZQYR+Zt/8TC2PCK/cptjO7AkKRReUPOoGXTHf/QiElufClBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g+KGnFmm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g+KGnFmm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680CF1F000FF;
	Wed, 30 Sep 2026 12:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790771152;
	bh=AT87T1sq0GVxAk737AGCAyVjO2uueFy/Kf6NKzOOOq0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g+KGnFmm27A7HHowcL3qacnMApkw1ckjzdVtI9J1GSqxvw1T7JP3ZY4ACafQ9z7aN
	 oY+r0gqZ1mLdslAx9KWeusRCP3liAtDrA257N8i+rpmXi3aSeKijkvATCI2vG5GsMw
	 b//q6kiH4RPxRBmEadrwqQxKjW8XmZk+oL5zfI2tBTgOlQo0IJPp2O2X+lsma3FHwl
	 NWGsOujfcSDrLkQ6ZL/XUrk5NxDjrb0wJtT9oDeAOIOHmfYv85Od5eEfUDppjEWA0t
	 Kl0LxhenhVCWyKqYnRWcZN+22OSAq4/ojW2XMNocVArV2aPmxpwtl5zTJQJ4GnzwuA
	 ZYDdgyzoeKI7g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net V2 2/4] net/mlx5e: ipsec: Block eswitch mode changes
 before accessing priv->ipsec
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930121119.141953-3-tariqt@nvidia.com>
References: <20260930121119.141953-1-tariqt@nvidia.com>
 <20260930121119.141953-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 12:25:52 +0000
Message-Id: <20260930122552.680CF1F000FF@smtp.kernel.org>
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
> Move the mode block before saving the IPsec context and validating the
> state, and release it on all error paths. Retain an early availability
> check to preserve software fallback when IPsec is unavailable, and check
> the context again after taking the mode block. Keep the atomic
> acquire-placeholder path exempt, since it creates no hardware state and
> cannot take sleeping locks.
>=20
> As in policy creation, do not check eswitch users when taking this
> temporary mode block. This allows states to reuse existing IPsec tables
> when TC rules exist on VF representors, instead of rejecting them
> unconditionally. New RX/TX tables still check eswitch users, and the
> TC/IPsec exclusion counters still reject conflicting packet offloads.
>=20
> Fixes: 22239eb258bc ("net/mlx5e: Prevent tunnel reformat when tunnel mode=
 not allowed")
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930121119.1419=
53-1-tariqt@nvidia.com?part=3D2

