Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792484210;
	b=ESJm4ftrDBgpoRAEyHyuiJzF/KiVa3KB1MF7CaAtw6sgSOrgpdurEtfPdK5ZagI/WMN7
	 910Xp8cmTmoSNQrMkNYBQV7dqv/G2b90WcaRIT1wPDLTcEyis9rLCmslJeNdZvZQpSOis
	 sdTh+CdcdgufsCUDr207HbETKmz3A+AgT5Mig8nRJas/9qgjS69kqLCEHyDOde2laFn7b
	 ldtYZWDCzShJqQ1XdrT6kY27NwUPPYdSClvsC87W8AhuxrP+GDLiObHfod/iethwD4MGA
	 Xtu2dz4EwohAZFTugyipG6X8dRVqRxR9hE8il2yypnAoFdVcTVvZ+UjB8EPqxZjA2/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792484210;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=J8kiEbM8nvVifEG/jD7fS48TlKJ+i76fF14/V3zdmtk=;
	b=Zsz0B1Oi9oeIAeWgBRshR+6RfTV9cNL8EhosvLgJbadndMzWKMJElARj1yTQcBTnp1s6
	 qch5d3RdIoiQW44PcFDfqJSjrBGJ80XJhUSp/UV/V02k+FO5Lwb7C6AHHtlqfHvSox+YB
	 XspA8/LhfoDOHOqawVZle0NchelP8313lxLW3yldt+ypqxCbXSIaVI7oWGzoiI1fC0ehQ
	 YSZh9VpBllZw+Qbrrjfi3+QGzyeOG9J8lJebcArk4/6DcxV6OpSrE3z9j+OWFVFJaSDKs
	 mPuwZOvDfMmLcnvu3w6mK6I8P2s1rvaKDdv1Q1z4ymz+OfD3piHj+Ojr6/fZoLI1Xrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cZ9sxeCj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D39606A31B
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 08:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cZ9sxeCj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26751F000C5;
	Tue, 20 Oct 2026 08:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792484210;
	bh=J8kiEbM8nvVifEG/jD7fS48TlKJ+i76fF14/V3zdmtk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cZ9sxeCjtVqHsjr3Qrr9LKVNgN8Q9X9cBIwLA2wd4Z09VHVhiKCOB2c3LaBCTidIt
	 9sHj6N9p91Asi8ThgnOuZfYVLeiV7BUrd8OKvxaQ/Mozei0IpuDCFrgcbZHYdJCcki
	 k4WU42AgIUjcx+by+NC5ByoBHmgw7uP2//pGyxG9S09VUEDn0GXUV0AqLHbaRW3SlA
	 0Yx9m9lPrzW9XdWeUQcZTSog6M6lBTFTH1x6QFU17RpKvHFUntAlYdu/FmpCf9yJPA
	 B5TO9RiPtgU/xAld2Nm5zN2l24fjUmURIxlJgbbAyhtGZcvFW4BAIjWTyN1mDym+P6
	 sXx+qOrJys4aQ==
Message-ID: <sashiko-outbox-178508@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 02/13] RDMA/core: add the UET GID types
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261019-uet-ib-core-v2-2-8bd654f25370@broadcom.com>
References: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
 <20261019-uet-ib-core-v2-2-8bd654f25370@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 08:16:49 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Eric Davis <eric.davis@broadcom.com>
>=20
> Ultra Ethernet runs over two encapsulations: UDP and IP. Each becomes
> a new GID type. A port can then hold both UET and RoCE GIDs, with the
> transport following from the GID a queue pair is given, the driver
> enforces that.
>=20
> These UET ports build their GID table from a netdev, as RoCE does. Added
> rdma_port_gids_from_netdev() and use it where the code tested for RoCE
> alone.
>=20
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019-uet-ib-cor=
e-v2-0-8bd654f25370@broadcom.com?part=3D2

