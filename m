Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42307416872
	for <linux-rdma@vger.kernel.org>; Mon,  5 Oct 2026 08:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791190001; cv=none; b=fCHdbzAYUM7gKoFG0COOHrIhE/DW/1ONOfHmxTyy0kBHAPXJNGf+1MjrCUVceR4Qht7LmpsyGsEYsGONnMOlaN6tbqvw2hc72RcOSIGZdDz7NQFY0jx1iMa3SYLcftSY9nqcYadg2uzIysY6mDO5jMt/p4JSSR+mtEuG6Fkpohc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791190001; c=relaxed/simple;
	bh=bXamLxoCRRJNylU1W0UWjY5SjA335H658atfj3I5aZE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ECHUj2PNQostyBOrJexN9rsWWZyqfVgznt989pwDX49h51mTZaSckmryXcxOa33vbJl/oPYc4RZUTmLk168n+BZQDFoVWQpuO1TSX8Yvv8kPvhzCdJRsQm0k78xYfT36Fy2Pj22Z77K+2InR3B1Pv6c3E2ewTARtouWjpDXxsXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FyHcznmd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FyHcznmd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAAD31F00893;
	Mon,  5 Oct 2026 08:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791189999;
	bh=bXamLxoCRRJNylU1W0UWjY5SjA335H658atfj3I5aZE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FyHcznmd8yrl6AzhUF0gNmi2fOPHYegRAMyLRduUVkbeu/yovJ73ggiQaqmxDmg2C
	 c/GYlMK0h35xli2PVk28Rv5zD5PUMbaZVF/70ZCfD3dG44wpyVvY/HTu96RF0iZu5R
	 pPcM+djOXOISQdlHh6tw/A2LArbnOBMUHyWrqZJWJu3PmKb9Z8uJ+PcwNAXMRc4WP/
	 b95zibEnXQ9g6vJRr9pris5otY6uv1H+0hjnnJ8xbmHnZR1m9pwpxGEHqJi/frzhNi
	 j0cpYEVdaGFBv57S3hBlwbZSKLFrjGOPcS8scOa6c3iKnblHCIrOqNJgH+/+46AxLU
	 9pGZUmyVq6IoA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mlx5-next 2/2] net/mlx5: IFC, Add capability bits for
 virtual LAG
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261005084047.237081-3-tariqt@nvidia.com>
References: <20261005084047.237081-1-tariqt@nvidia.com>
 <20261005084047.237081-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 05 Oct 2026 08:46:39 +0000
Message-Id: <20261005084639.CAAD31F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Shay Drory <shayd@nvidia.com>
>=20
> Virtual LAG can also be built over virtual uplinks rather than physical
> ports.
> The support for this virtual LAG is indicated by multi_uplink_eswitch
> and port_select_eswitch caps bit.
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261005084047.2370=
81-1-tariqt@nvidia.com?part=3D2

