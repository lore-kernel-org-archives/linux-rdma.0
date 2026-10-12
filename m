Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E4132ABCA;
	Mon, 12 Oct 2026 13:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811226; cv=none; b=senRQD58zP5TSQcfPqSIV3FIuP/+2IpN8YAsuLR+dHxhCQdD/Xr02inVrUKNEle8DBIKRvJtk3+Zm6XJB8S1FGGYeEkAfWMa2ghG3P+v/DW9fUmxgCSdsGhG+TqEEMEuXKnAEp8pqjiPAobDsSPMYhaFN1LVhEwfx56pCpusO7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811226; c=relaxed/simple;
	bh=1QhUi/Eypm06QxXsczGu0b+m/a1gDlMPO8/nG1uCXO8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=FZnbJuajSNoVYSbBsNo6SFdda9hULP1ni0tQxQDET82RIew9+LYdtZPkDsIBUOqZWUzX9j8CSaFz0ysQYzR+TGFDn4WMkWd/WdzT5PQbOHM4C4uwHfKEzRNldFc6K1qOBYgMOjWc/+oBczv1EDdD5cOumyCk1Qti/7/oXzk5UYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WRBf3RZX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WRBf3RZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2784F1F0089C;
	Mon, 12 Oct 2026 13:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791811225;
	bh=1QhUi/Eypm06QxXsczGu0b+m/a1gDlMPO8/nG1uCXO8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WRBf3RZXF3UUIRGWD5ZZGYnOJ16O8SPKkN5SZ2Pp9bHWzEiN9NEmyju/NR+qd6au5
	 4y2P8x/QoPixFH2UepqPoyC2iEsTMZ2Clw1OmfQgV7eLtTEhYbZ4lkRd1nsk4kj8lv
	 fDL9UTqnwUco/Fy4oaRYamNDSRpKSYUHQKemC5xD8UJhiYnEaui98xqN6cQBaLzHPI
	 VA7lzsjsYRgiEoGC194RkysBtYWponEBAr8+sVcvEHSOED6sYydAUZJs7keRJGJvQo
	 lJJac5ct7dA0lUkXpeW+BS2GRJ1PqW79DvoAiqp7V5+LwPoUEz9zMaX5b//PDQaapE
	 uIqU8EqvXTk6Q==
Message-ID: <sashiko-outbox-168167@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 03/18] PCI: Reject unreadable ACS controls in
 isolation checks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: dri-devel@lists.freedesktop.org, kvm@vger.kernel.org, linux-pci@vger.kernel.org, media-ci@linuxtv.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261012-fix-p2p-acs-v4-0-v10-3-6ffe7b7a4517@nvidia.com>
References: <20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com>
 <20261012-fix-p2p-acs-v4-0-v10-3-6ffe7b7a4517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 13:20:24 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> pci_acs_flags_enabled() and the Intel SPT PCH quirk use ACS registers
> without checking config-space read errors. A failed read may leave control
> state indeterminate yet allow the device to satisfy requested isolation
> controls.
>=20
> Return false when either ACS capability or control state cannot be read.
> An unknown state cannot prove isolation.
>=20
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-fix-p2p-ac=
s-v4-0-v10-0-6ffe7b7a4517@nvidia.com?part=3D3

