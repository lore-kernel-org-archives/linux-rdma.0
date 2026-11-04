Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810625;
	b=0fcOTQcaDXeai1kGBfDMscplrq5inR+UWVUl2EpWwQZNN2FELhpVNIVrucbeRkK2XL8u
	 DKKNtbgxXDNDprrICm9P37CT/rNz0LpBL9guT0h4uaQ01571iPMEtyxTTAJXheDL8xpxI
	 YmrtGJVyh2aPIHeZXRoVdgJaJ9H0BfRSY9fcNXzdnwjoTVItE1EL0wUr2lEhQbXKtJHIw
	 V5N8/YWRtBHzIAOnGi68KeJXBtta7M1N3le6BsbzQiCjG9d9HbZ6WgT8wc6zWycXPnTZ1
	 jAsd8ywC4sLJlfdSq4sUrbJDiDONnHZ5bmay+Hfzm+p86idOoc3k63Q0fImkTYALyog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810625;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ovrW24O4ax5vNDbZP6r9co3KOrXSlgEpFUmAaPVOELA=;
	b=J07nM2JhMLyMPJ6ULs0FFs6+gqNAqgLWdmRIkPK7TE9HOh5vG56AuliUzv7qw8+LOjzW
	 E7ekP35OPejKdx6a/7uXi+B/JXE/O8GTDVfS+anezudziZK7g/QyqhMKrdiCQOu0NBHSV
	 o4zsN5FTelYVpNEuCq7MX6SkskqcUcCsl2kodn2WDFC+cm5XjTdpXLbYI7sBstA3apzqb
	 LdJLWwuxc2lv7q0i1n/A5Xx2AA2jSje7DoPkm6KeLkaiJhMWUJPksmbnl+z1j0H4CrS+3
	 /O4DYgPOKT75cVT8EcvRCRHC2RkM/SkJdQ8BRHoRLqGTU5YTRqxYUVj6Hm3+c8mGxtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kSfYeRmr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60024606A32F
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 16:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kSfYeRmr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C1C1F00A02;
	Wed,  4 Nov 2026 16:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810625;
	bh=ovrW24O4ax5vNDbZP6r9co3KOrXSlgEpFUmAaPVOELA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kSfYeRmrpaZGYxn7aF5lQ5zy8WCmu3AxogA4dmYQXUT0INwLoTPAq8AM++q5vHBIs
	 VhOtu6lcEpmJ4ki0TyNqh7cBMgLN619WgtDkaVI7N0opr7B/2lWCYI9a1IEnN01cXJ
	 5xisUMLaWDTsdQo7fEUfqFnlVMUOUbKl4vxsYfd9mEjlZRSVmSLn5XgVxe9LUuFejI
	 hjG5tw+PGHAgsojouYmWUTtLxYd+jR5HhRWii2qLlCz355TyzpMfU2vx+sy/vSO0Ap
	 GmHZA/yFo13acF6Fh7tX+emTnBNqP+qs+iUZ2rHQ7cAkZwDh1vUQuVslhxDuOoGlu4
	 eorNG0/zw2Ohg==
Message-ID: <sashiko-outbox-197660@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 07/23] RDMA/mlx5: Derive
 mlx5_ib_adversarial_mode global from mlx5_core adversarial API
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103163949.1554-8-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-8-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 16:43:44 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Use the mlx5_core mlx5_is_adversarial() exported API to set a
> module-level static bool mlx5_ib_adversarial_mode at init time,
> instead of a per-device bit field. This avoids propagating the flag
> through every mlx5_ib_dev pointer and makes the module-wide policy
> clear at the call sites.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103163949.1554=
-1-yishaih@nvidia.com?part=3D7

