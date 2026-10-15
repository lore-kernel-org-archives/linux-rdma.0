Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00375221D7
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 12:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792068513; cv=none; b=sn0FkSUBu2SsFKz5R1XQ62dyydbR7CrO/O3SvR7ueRqPN/Zq1LqyoNt1F2wwQ/zUQQrRieralp5KJX9B77j6oeT/OKCgchHQkDL3fE244CRU1kn3TYdvmvJJv1qOU3zkEcl9wZ3zdPwlOsf3SRz2688KZwKLGNGw4mFPULuYgWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792068513; c=relaxed/simple;
	bh=psfrRCAktmOlb77X9GwQc4DoJk87B0oKeKLo1gw/TrQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=tio+IFcvjEN2LCU5Mpvrho8DZkFK+nhXWPDZ3Bzg9Aw7FZ9BOki5dYyO+YNddUUFbzpc9pPS6CUM9+sARyM7rxKCQrCbiamNbVPYjmGzqKCTNtDhegrbo1wbPQLOCJlxjcqoRePVPDUyeJLZvnEFWB/EEIESpO5OMltkCes5clU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nAq8TJeA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nAq8TJeA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A7F1F000C4;
	Thu, 15 Oct 2026 12:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792068512;
	bh=psfrRCAktmOlb77X9GwQc4DoJk87B0oKeKLo1gw/TrQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nAq8TJeAdnSYo8pYDjQDsODATeA9UpfpGWqphDEItD2ZJjZ8rOtqWE4E1Yvi+1Y0A
	 nAscUmeB6HaiyITNL5lt5w8Lu6GNRJjJSefU0CRy/RcEQWj/W/m9aUW22KTohjwDG+
	 zwG+e8ph8v0s6EN/PpHw75cAHnTf+OlWHCtKLiCI20M8eEIPFTqFKqnhjH7uNYSu8G
	 xPmPT5sGgRqBUkl8g9B02e1GrM15AGnAGL2nuMh5Spl+/9VFaS7ggaF2UTRUGMvGwn
	 GeCzK01kC3iKRgcgD+2+aPDJZX2J7624imn2lI5HN0fnIQ9UBzk/FGUgzjMLtq5pwB
	 sqdapsXBTD03A==
Message-ID: <sashiko-outbox-172867@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 3/3] net/mlx5e: Expose CQE moderation mode on
 representors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261014124704.1017782-4-tariqt@nvidia.com>
References: <20261014124704.1017782-1-tariqt@nvidia.com>
 <20261014124704.1017782-4-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 12:48:32 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Yael Chemla <ychemla@nvidia.com>
>=20
> commit bc541621f8ba ("net/mlx5e: Support ethtool cq mode") added
> ETHTOOL_COALESCE_USE_CQE to the NIC ethtool ops but omitted it from
> mlx5e_rep_ethtool_ops.supported_coalesce_params. The ethtool netlink
> layer rejects any attempt to set cqe-mode-rx/tx on a representor
> with EINVAL.
>=20
> Add ETHTOOL_COALESCE_USE_CQE to mlx5e_rep_ethtool_ops.
> mlx5e_ethtool_set_coalesce() already handles it correctly.
>=20
> Fixes: bc541621f8ba ("net/mlx5e: Support ethtool cq mode")
> Signed-off-by: Yael Chemla <ychemla@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014124704.1017=
782-1-tariqt@nvidia.com?part=3D3

