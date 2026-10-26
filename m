Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793005076;
	b=y9HTyghLALXTx01rXS/PMzAz1EJjRCglUZ/HxRHmvrMTVjZXfQRDzl9QneSznZrD1bTZ
	 by/OhsSMP1yQRwu0X9W/1HUJEWFbSN+Aemu1d0TIWyAbZIk54F78XljaskiTD/MOXGxhs
	 7vCfIN0xixs2Uc8sv4Gj7tT0lQYUtwQIKOlCR40hK971cSLLyJwRXtS3Ni5+z8822IR2K
	 4O8KOQcGkVisftJHNElgNHN9bbVpf7q/SRtp9rreST+fZldvyW6SYl3Kp7grZWZHDXhYk
	 2+QGQx2lDwZa/u/uZBkQXbgEU85P/r9/BBJjznZ+2CrHRgJzoQhUjotU+OCWyTHXajQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793005076;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=zDxEt6zBSRxh4d74yYjA/AzTjLN8kt2tdT59ornz3nU=;
	b=T2a2/m7QfEjZnzH/9OOeCKcxI/tFYGcis3iMyDL8T4bOJiuZcCMc2yv7FSAYXKruCeWJ
	 PXuOgtvqZLFnD65EtY+/GbOrNwExRFvdJ41wDC+skE+RIfmmqCBbsm4EUCkRTOYSAKw4g
	 Xri8yhxpP1B6qj3YIgEDs2grolKVCsericNDsWyHR9h+UQGTZLnuhdgjbNgd0evVXM78r
	 8pw9YNnu0mAzjHJW38bZnDO0lWk84BFvZcPtl/JJ//ISlDCFL2VERNoKiFIokdAzR70Ar
	 NkqTZ545jqLe1qdykcThyqXjvAjzuKms9qoAsACSMthukm5jkKAFMYanAnykNtZIGCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OTvSsav7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0936606A323
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 08:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OTvSsav7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8BB1F01828;
	Mon, 26 Oct 2026 08:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793005075;
	bh=zDxEt6zBSRxh4d74yYjA/AzTjLN8kt2tdT59ornz3nU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OTvSsav7xEZVRIrNrhOzbJWLV59GOYBy44mqUoHUwBlmyUOYVAb1yRsbl3xIKILMu
	 WnMB/NsYMl6KWkWNBxAv3sP1rYD7JTbNj2V5cyoqejtYo2EF2cwn3cZ/ie6tc/v2/k
	 c4cUUqRNQOSw3z6DvTugrvZb2T8bxsAi7sx8mG2+jB14xKM64AxhRrl3AIZ1vgYqNF
	 WPE17ChrbnODBoNDEeAh2u/4I9zfJcN1SP+uSzhkNK8VTPZMvZRcdTnwKLmnlKqC/s
	 8ZED5973NZmlZoBtrxpXTiy+16/Lzo7IEEfat/nfwCu/h5SNgt1DQm0cw8n906PH8N
	 jFIU9kzUPJF8Q==
Message-ID: <sashiko-outbox-184712@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5e: Fix false WARN_ON_ONCE in flow steering
 cleanup during RX init failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261026072253.4118892-1-tariqt@nvidia.com>
References: <20261026072253.4118892-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 08:57:55 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Alexei Lazar <alazar@nvidia.com>
>=20
> In mlx5e_init_nic_rx(), a failure subsequent to
> mlx5e_create_flow_steering() initiates an error cleanup flow, where
> mlx5e_destroy_flow_steering() calls mlx5e_del_vlan_rules() that contains
> WARN_ON_ONCE(fs->state_destroy).
> This warning fires because state_destroy is set before flow steering is
> fully initialized.
>=20
> To fix this, initialize NIC flow steering with state_destroy cleared,
> and set state_destroy only after profile->init_rx() succeeds.
> This keeps the flag cleared while mlx5e_create_flow_steering() is
> building its tables, so its internal error paths can destroy partially
> created flow steering without triggering the warning.
>=20
> [ ... ]
> Fixes: 8c7353b6f716 ("net/mlx5e: Fix VLAN cleanup flow")
> Signed-off-by: Alexei Lazar <alazar@nvidia.com>
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> Reviewed-by: Shahar Shitrit <shshitrit@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026072253.4118=
892-1-tariqt@nvidia.com?part=3D1

