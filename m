Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DD049E141
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 13:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791552663; cv=none; b=k1jcbBuaVX1dndljX8sB1JFvaW2fMXocGXbteh4XhcO9Jen21HFaWnH+E7OmKcGBteZJcnZH2Yr+nPGuovbc5g7sAbuhEGUAKvw79m6189aYGw3jBMkYWFMCDT7LKm4m1ZFFud07Usakw6a5JULUy+skoRoVO6/RA6bpyVgkT2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791552663; c=relaxed/simple;
	bh=sQzmbCrSPTl5uwTPEzayXS+O99DPHsPuvYb2ByAFsLI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=OZQMWwVoNgvGHFpvbGCzMHEoy+ZuYBaRbk7GnowTOMLxkiNXhHaeofs8l4H8chZK7qClA1x/FFbEHznlLe6PHJEUq3qExUT9PwwFu2ynd2sGEDI6euXr+rGhCuGvfdAZ+Ce7vN7v8ronzKdu+cXYk9aNTPgTMLE9j+eI+KitIzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YjVU3Tws; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YjVU3Tws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5371B1F000FF;
	Fri,  9 Oct 2026 13:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791552662;
	bh=sQzmbCrSPTl5uwTPEzayXS+O99DPHsPuvYb2ByAFsLI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YjVU3Tws89ap7CZB7v1xt25//SU2y4/ep3w88eC272dgaDmH+XHUTwGPgrW1Cahqv
	 7BGZeBZbjOeuMc44CInA9f20Y3ecX5ygGxR1vYKcWvpHs6LXtAPKgeAJMrx5LmZuRR
	 luOkhhEcRLQ+jQOxEJzlTnTEj7kQDE4df2kTN3rW27NkfpFBousxmFiltBD0PZP+Lc
	 p0OVlxTPU4FzoHzoz/JOu1QHbUuXZ7a98knZgj8kAy0YwiYZTirvSuxQkENjtAD5qo
	 rOP7GqlaxRYBFzJBqEsZ8Isq6kkL6MX/OukFSnuVPMT07BaxkDGQIbZGgog7fNXWeD
	 +ZCgq3vmt0tsw==
Message-ID: <sashiko-outbox-165635@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 01/10] net/mlx5: Log the data direct to PF
 device mapping
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008132815.654147-2-tariqt@nvidia.com>
References: <20261008132815.654147-1-tariqt@nvidia.com>
 <20261008132815.654147-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 13:31:01 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> Emit an informational message when a data direct device is bound to a
> PF, showing the data direct BDF alongside the PF BDF (the mlx5_core log
> prefix), to make the mapping observable from dmesg.
>=20
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008132815.6541=
47-1-tariqt@nvidia.com?part=3D1

