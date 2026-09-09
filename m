Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D993AAF6B
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 06:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788936946; cv=none; b=ds7aXzqrZqMZOImPfTD8VahblBVFeeO2BKF7f8y3E+Sfdkj7bIT3388Wnmxld4sLFpJmeMhzq97vBouiXKMOQnq/aKzzAjYchZ+0eCMCIwXPf9kyMkKBcOsXVBEWTbs+7nifCvuTu9uC4/tyG3YUOgmUGELQZSM7AWG31a7I66M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788936946; c=relaxed/simple;
	bh=+MxkDojoBb73BxekFL49/+viWeZDtlsx4Ejq4jCVZEE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=m7RO8FYwBB1is6Vi1OtzC0sZE9erWtMvPyTx+E9uuOkCyx21B9+nhNAcU5CR898ZxEB4zgeyeZB+SG1PuzT1BE7r5EcgwBYza/jCeitU/v3FXAVnM9dKqufKsPImhCNwdN8p60i58CBrbdsU0DkbkzfQOnP+epyFClWLiMEQ8/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aUiZcAFB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aUiZcAFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEDA1F00A3A;
	Wed,  9 Sep 2026 06:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788936945;
	bh=+MxkDojoBb73BxekFL49/+viWeZDtlsx4Ejq4jCVZEE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aUiZcAFBlwYAX3glYVD7MIyPsXJoQ3Ejhe9WzCm0ogbvWYkwCGWbl0zG+la1bL6oQ
	 z79XgOdWi0NXyU/OoSCN2HJrO32ShgWoeRHkn9RbHvvmanl01A0ptvztVmAaLqX/dJ
	 uupBoNaIxy+QdEUSIfsJyRBwFtCTeoWEGTCTd8/Fi5YwPgV7kY/24Oq3bLEDlmYqLP
	 acOaPwlMByk50xZv5J4Memu/ZQrCxpmso4TsHRTMgNmeEFMViBTcv3CAIVxXUHBDP9
	 Lj9zpXiCNhGckl7HCRJfdINWcTQ6lmzMQMg6nzB3fbrdMDW8yUvDnrWO0RWkCOMI3B
	 O9JHS7Q3404/g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V4 11/14] net/mlx5e: psp: Dynamically
 reconfigure based on SHAMPO mode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260908065244.3799142-12-tariqt@nvidia.com>
References: <20260908065244.3799142-1-tariqt@nvidia.com>
 <20260908065244.3799142-12-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 06:55:44 +0000
Message-Id: <20260909065544.DFEDA1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Cosmin Ratiu <cratiu@nvidia.com>
>=20
> Add an mlx5e_update_nic_rx() -> mlx5e_psp_update_rx() hook.
> This allows PSP steering to reconfigure when netdev features change.
>=20
> When this signal is received, toggle PSP between standard and
> decap modes when SHAMPO mode changes, optionally creating the decap
> steering table.
>=20
> The toggling of traffic is atomic (a single steering rule update), so no
> packets should get eaten/lost. It is probable though that the rxhash
> will change, and decapsulated packets will be received by a different
> core than before. Established PSP connections receiving traffic might
> experience reordering/retransmits as a result.
>=20
> Also enable decap when configuring the device if the mode indicates it.
>=20
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908065244.3799=
142-1-tariqt@nvidia.com?part=3D11

