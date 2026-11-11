Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794422436;
	b=1/EO7sDaGQagHAG+7L/h8akQRxefTiY9ej8PS1V94G+cVroK0n7eFqUJaJddh9elQZ4X
	 jSV/6Vqagg63Ow02MYWfXhwzwJEpUrYr59t1w/GqfmUDESSIWYwa7dnRWKpIHL7GIVo2x
	 S0wXwFUKZWUSHGCkTmzVCsh8uFQFXtVIf8v8xnLgagB3wSYyhTLl+ArRTphmcXYiSoxUS
	 bbZiN0zMmV837jXzQ4Q9c615Z6+/PigOzpS9+RDnLmsYNNuhGw1yc/3BIcx5M2ac3CjLp
	 1cMfMC9chmBOAgRoMoiwlK8de+hTYIB92D2EMhlO0xaqxre6zR14CWOY/sbx8pvA4Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794422436;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=18RMdSZyajwh95XF9gAVFf++sRS+CEJoQndto6Qgcp0=;
	b=tFc1IapDJCoqusgTuJ0AaAb9xLDgZy7fXaI567QdKz9llhVR6OpjFqpp+h1rwS3xuD7a
	 oqPM7VUpDLG57bvxK9S4bUCHe3xHmQkT0eDRRFYCohdDmHyCiwNNY5AkWZDo08n9jqH/V
	 Rr6MbOQyM79IYJPwFiOTL6qiJsUI1rgOheJbdCdufCCin7gpm9SmmFkCyPhqTtWK6TB31
	 FMCQpkNUxAvmDsEMnhpO7yqd1mIAfeR42d3VFivtNwCYpqSlGpHmpCKB1s3DYIis+Hod9
	 moqzVxgjwoANv7DDcZttFKn0hY5oRnVZpwykrlL02s4W0c8T+MuPKRnDO2OGlZU2Xig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bbNggAX3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7440E606A338
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 18:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bbNggAX3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24BFC1F00A05;
	Wed, 11 Nov 2026 18:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794422436;
	bh=18RMdSZyajwh95XF9gAVFf++sRS+CEJoQndto6Qgcp0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bbNggAX3T4pa1dYGcLzi2yKjsNx9JHb+5ZHpN/yamE9A47CR2WCSx0vAWJHw164U0
	 JY3uZWuMmaiKewdcXRjD5Us1eeeLE39Q+EGlJwWfPx3J9TuziTtXTLxNEtEp2ccDbr
	 SliQfJ6T1cITHvDRlq4NaFd8M0ylF+JPSzS0I9y0wnWjejE2XliqEYSIe05lYYhnnl
	 60zyRnQIil9KtLiyhi/KmbvoYGVF3Qgip5ZL60CzPxrP9hFc9RBjNXHV+BzOzb8NQe
	 5ewi2husU5XsBRwnIRO3P3KJ2SuWnp3LYpLnpEjZbbQcOtGB059GwVqLAuK0zPxShc
	 7zlseMYznSKTg==
Message-ID: <sashiko-outbox-209476@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 08/13] net/mlx5e: Add data direct TX
 infrastructure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110183826.2927274-9-tariqt@nvidia.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
 <20261110183826.2927274-9-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 18:40:35 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> Data direct is a HW feature that allows a type of peer-to-peer DMA
> between the NIC and another device (e.g. GPU) going through a specific
> PCIe topology.
>=20
> For data direct to work on the TX path, a crossing mkey is necessary
> which is created as a mlx5e resource. This mkey is used by all SQs.
> For simplicity always create this resource and link it to the SQ
> if data direct is supported.
>=20
> An SQ state flag is added as well to signal to the TX data path that
> data direct is enabled.
>=20
> This commit has no functional changes. data direct mode will be
> enabled in a subsequent commit and mlx5e_queue_get_dma_dev() will then
> point to the right device.
>=20
> The data_direct private flag is not propagated to PTP SQs because
> the queue selector will direct devmem net_iovs to regular SQs.
>=20
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110183826.2927=
274-1-tariqt@nvidia.com?part=3D8

