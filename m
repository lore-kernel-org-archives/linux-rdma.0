Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6639A41B8C6
	for <linux-rdma@vger.kernel.org>; Thu, 10 Sep 2026 10:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789037190; cv=none; b=itG0qKshINWJRCOrXypKoaTxa52JiUeAqR66Iycrap5ZG+IJH5H3dQ9I2eTabzN0YjSiyr3SUTFnotM8oNvYoII2oz3Vnmnu0jF6GoiiW9UdBhph3Uu7y5C1TFONtC2f4eNh8PphTkRqNNiSPz7fvEzI9HehiX70zj6Ef1wdNh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789037190; c=relaxed/simple;
	bh=G4RY7D45IifV5UwqvXALSWhEvnDn9orHjiP6HfPiY2g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jQ6zmHdkf2RKk51iavvP1DUs58917DC574IHZvIevrgh0a1booa0QSR2TG11crpbCA7Spo/am5W2RtlgRx8DKtACNcaGNDhUMfIDCelMLm5iZ77NemvdCOBQWjk8bAINi7C2XFePAPVOT+rlGVPf7pYSO5FUiWlL+fLiDYAsz1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MOBYM2ND; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MOBYM2ND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092C21F00898;
	Thu, 10 Sep 2026 10:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789037189;
	bh=G4RY7D45IifV5UwqvXALSWhEvnDn9orHjiP6HfPiY2g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MOBYM2NDewFR9qRFFc9ZbXKz2Mdp+J57cBkb0ouUs8pTxqcV5WrP8/Jgrke79sUGS
	 jSIluZXS2iaV+xig2xtPiTaFy/ES6//90Rqv8C1UBIntfxqQc1hfOlisGUzaj6EYYG
	 iCPGJvD1zbmJKcdgr2JBqxvHYP0O1lIfn6jsCQwX8WmlsussnpvPelBEGhWwibXWd3
	 Xicfur/AqLCOROxq4rDm76E95AieEzQaH0XwjQ+uV5RWcuyBQ5pMYwYvCHQQ2JM5Bj
	 za6xkdWpPe6d28fLpT8IPU4DK2d4+3uCaQKqOL5G1W5Jaq45m2mxuKUEwCjwD0m6X7
	 0qQaSuV42ZmPg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 3/5] {RDMA,net}/mlx5: cache and use TX-enabled
 aggregate speed for vports
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260910102432.3845360-4-tariqt@nvidia.com>
References: <20260910102432.3845360-1-tariqt@nvidia.com>
 <20260910102432.3845360-4-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 10:46:28 +0000
Message-Id: <20260910104629.092C21F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Or Har-Toov <ohartoov@nvidia.com>
>=20
> Cache aggregate TX-enabled speed we calculated, and use it instead of
> querying the bond speed so we can, in the following patch, limit it by
> the PCI bandwidth.
>=20
> The bond speed takes the calculation from PTYS, and PTYS is not bounded
> by the PCI bandwidth of the NIC.
>=20
> Fixes: 50f1d188c580 ("net/mlx5: Propagate LAG effective max_tx_speed to v=
ports")
> Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
> Reviewed-by: Shay Drori <shayd@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260910102432.3845=
360-1-tariqt@nvidia.com?part=3D3

