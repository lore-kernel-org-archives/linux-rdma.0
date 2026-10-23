Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792783925;
	b=KxBhCPpeDLK+j/tGhIT6bX+NSKhjHtEBPubO1PJLqQIPdzLZdogatDRWs9GJBYOPjjg0
	 GKTM4TY880oXsKYgkDLDYl8YcSluTP5/IA1Wjxt3iQ2o3YDCPZ0wnYUscJWQZMAoCBzs8
	 KsG1K78L78MuRS8/HNRJC3ONbGnq3DKCzXEgGz37oyivfpDF5j+89jnVDz2C1vHppUQ/y
	 Zy9JsiFh/jtf2NMIWHnPtSxA3cnO1ossLPLrXTdOcgWudFGAaLKgE+Vji7MAO+0Ge85zz
	 5whHOEWeA0IGiVNAcswMPfRzC+7gyFEf6zj/HR+mb/+ERmKkTIDBqFDrbCRpBGgtJgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792783925;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1480HGnkPTpnDf3lbamcEfAr+Wvvappo1ezNhLWyVL0=;
	b=iIZqrmTUJomfACDewrF1VsZ6R/kcdGo3G2WH6TuBG2zCfdvlroZHaCQTu9uRljMtz2Es
	 CPjmc7bYwng1IhgVjgL0IQeV3+z5mD5hIiY2DRpEW9rJ3QGaxsgeHa/bNd7eJZjcoK4dc
	 ipG5I3CnAHaQc5MWxnG+GuypQx03mY9MWY0Znoibut9RhLSkqUjrOL5zMlzVlcfSAK3XC
	 naUyRhXfm2cX4XqHJ6qipWYXDPCY5Sb21Ut3Wki3PTfdhSGg+TNoFL9aer4ax0R3nWB3C
	 IoDtc8nVeRWRswfsjpxkVcwKV69mutjoTqpsyll0QAV7Py2iZTrkc8wuKEqeYJK/yZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iatostPw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CD7606A31F;
	Fri, 23 Oct 2026 19:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iatostPw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B931F01828;
	Fri, 23 Oct 2026 19:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792783924;
	bh=1480HGnkPTpnDf3lbamcEfAr+Wvvappo1ezNhLWyVL0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iatostPwHwoxCfBtD725dLVntU+rak3cQUbL1nj9tHCtT0FgD2YJbvOvOEaZczWYe
	 otsMbFv4Whk2cG70I5D+rxcVWd00ZHpCuIkrLaTpZrb6opvcid2C9ednLZ2ineashL
	 HO/Rx814EgIS28HXPgYGgP/uATqf8sin6vcI/tCZjDoVbImhRWtp5h8Ur8gPkfpKnb
	 CY0i2PUe1oE/GlNpr9gxt1QFe/wAnEFTGoHiP9KdJ+JE65VXJERHAH1lE/QkhiYuvn
	 Kg75uCEjEpe8uqp/YN1oDCPa3UpArYgEGtyoLeUKCTqq1T5N+z5L0daJmxJzbZsFWX
	 kxObjsdQ3ddZA==
Message-ID: <sashiko-outbox-183121@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net V2 2/4] net/mlx5: Lag, limit aggregated TX speed by
 PCIe bandwidth
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261022193053.3815866-3-tariqt@nvidia.com>
References: <20261022193053.3815866-1-tariqt@nvidia.com>
 <20261022193053.3815866-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 19:32:04 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Or Har-Toov <ohartoov@nvidia.com>
>=20
> FW initializes max_tx_speed to the minimum of the port speed and the
> PCI bandwidth. Modifying it with a value computed by different rules
> changes the meaning of the field rather than updating it.
>=20
> Limit the aggregated LAG TX speed by the PCIe bandwidth. Clamping each
> uplink separately and then summing could let the aggregate reach a
> multiple of the link's real bandwidth, so clamp the sum once instead,
> counting only the ports that contribute to it.
>=20
> This assumes the bonded PFs share a single PCIe link, which holds when
> they are functions of the same device. In Socket Direct, each port spans
> multiple mdevs on separate PCIe links, so the PCIe budget for that port
> is the sum of its mdevs' PCIe bandwidths. Where Socket Direct ports do
> [ ... ]
> Fixes: 50f1d188c580 ("net/mlx5: Propagate LAG effective max_tx_speed to v=
ports")
> Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Reviewed-by: Shay Drori <shayd@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022193053.3815=
866-1-tariqt@nvidia.com?part=3D2

