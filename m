Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E1A3B0AE2
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 06:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788936946; cv=none; b=aSUjA5s4l1PMKKB39lkPiZLAgor9JPcDtf7fbz3hXSrMyTC1omlCUea9uOTVcTwxB1CZkYOVaE1vIqoG5HXbi049MrhndQ2OUqNCYP44VvtoQFDYJF6uzlXGy9TTwvQpCe/oxYWoBOD3FsTR2TCRulDn0z+adqJpD7CCq8vAmKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788936946; c=relaxed/simple;
	bh=1gWcowAqN7KoSusd5pHiuIrKrSl7DM3rB+r77kPRZ+c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rie6gYbF1xAWF/gPRgn+htGSIWGBfThZjbS8tZZ242/hzV7MiBd8rX+snDP3gUyBgjGeJZFQhFSE8/IISeoueQbttxGcS7MsDEg3CSWMi3vCQvlRfKtBm6YDrWj3vgorePw9TN6TDp3ejG56CWBTO/ng7AHb0Jr0BWt9qc28PuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BJJ3wXB1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BJJ3wXB1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863F41F00A3E;
	Wed,  9 Sep 2026 06:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788936945;
	bh=1gWcowAqN7KoSusd5pHiuIrKrSl7DM3rB+r77kPRZ+c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BJJ3wXB1ISncE617fyyWSYsUqkvEwdAIWVRL1AU/xtqGxaXI1eP41jnfmjiBt6WR9
	 dVaXsnDos6Mb1v5OhrIeF5ji3/NlSNKkZHI6hTWcEVt+w7vfq9XT4hP08UHjCmrcaN
	 hYtdgrMRoM9OeLEwlVvqsN5IrNXh0kKUfSj65g90jvGEEQTCQCN8mrIO1UpCMRUvj0
	 QBH77tQCgCulHZ0ct4jq+KqTkFEWAzodOVBDQEXCuXmYiBg9XQPcNrPTWyHyQXg983
	 h/2Kk4g8/nc7O/rbF1TOIv93UblIJ918ow1DQy7654ZpHD/UJudw+qpvSSnpe2cAgx
	 YMAEUhsfTfcww==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V4 12/14] selftests: drv-net: psp: Extract
 shared helpers into psp_lib.py
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260908065244.3799142-13-tariqt@nvidia.com>
References: <20260908065244.3799142-1-tariqt@nvidia.com>
 <20260908065244.3799142-13-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 06:55:45 +0000
Message-Id: <20260909065545.863F41F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Cosmin Ratiu <cratiu@nvidia.com>
>=20
> Put init_psp_dev() and the logic for requiring a psp version into a
> shared lib, since they will soon be used by a second test file.
>=20
> No functional change for psp.py.
>=20
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908065244.3799=
142-1-tariqt@nvidia.com?part=3D12

