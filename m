Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792565095;
	b=fNseAfo/t8UEaQr6hiC77CqTB+tw/7wPs336C487az/S3cBOktkyKOk1iLGD9ycy8THT
	 N/Cd+DeiGyU1Vsf2UZQOC9uWdhYBoO++KwILmdW0552YD4QXLWfoA6rEIFdYa8tPQoyaS
	 uVpx1JjfLUzRCWNBO9QXX4J7rjVcCs16NGLozx6di2NnfFMTccr7asJvhV44HslyJSYRI
	 IuijXRAXF/yXhhgLoWqSdILXkHytz0T+jaVAWL0S9+vJGyVFfyj1ts9uZW0IAOljxvLAH
	 j/ZVJYKewnS3njWVAw3NEIWqKNWbejCDNCW+indziOBOKor6FqonoYfgHv4lQtcDvGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792565095;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=yKYddmlM/ijDUkUDgAfrZGohH9ulbzcKWtBlKXf1ByQ=;
	b=sqnZE0oDtys7XyeVNkZTq7DB/sfza8RLz3f2FE8haKaPUxYVdZrDxZg2z25gQKJ2byG5
	 hv39g2dAqrepqWWX4TRF47IdkbDlnapnZwIakZoOQVhGcG3mPKPoBljAVSQhvEM+hB+zP
	 jK5pmH7VdCRqHNYKQhzMs6LoHSXbTVmhAwdDe7LCzRyX8XYQofyxd1gYsgplrs3ruZSyo
	 4AdELSiX3ytdYQ7aFwS+NCW4J4tAQSsWS3ms6trp3YvyKs7T1v0ofkzu+WkRRlvgeNbWB
	 U/SEwCj6mtEZMorFbDqBiHeWmKQPvmzgi80S13AIa/Dzv0hoDcGbrg4SpWojurWiZdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="KUXc/jj5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567C7606A319
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 06:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KUXc/jj5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF79C1F000C9;
	Wed, 21 Oct 2026 06:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792565094;
	bh=yKYddmlM/ijDUkUDgAfrZGohH9ulbzcKWtBlKXf1ByQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KUXc/jj57maw1yhkX9cIAIX3Mmoj+e3QreyPjbFX/pT8MpitzpjmcwRhcw79dfc0I
	 X82llRkWEqBQr3emN6x6tvbPtbNKKaUc78DoZucUTQr+YDvFonEDKRrPrDwb7UcIzT
	 nBntei7LYsnCYca59OJ0HnJiPK20izIMHIcnKlPu4/NcF+2XRgsFLd4PbNwW9j2J15
	 ziVJmvzTv/vyvY3oDpTXp5SGOvk+A5WIrTPPOX085ie4oJngqSMxpHwjNlurnAd5vx
	 Hw3rEuhapwXaiu4aMebRijJYeAg42AIhGmmsvIW699OkVkmAMyx2/95RZ5RDK6erc0
	 plr4+Z7WmOnlw==
Message-ID: <sashiko-outbox-179837@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net V2] net/mlx5e: SHAMPO: Do not merge PSP packets
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261021062805.3466208-1-tariqt@nvidia.com>
References: <20261021062805.3466208-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 06:44:54 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Cosmin Ratiu <cratiu@nvidia.com>
>=20
> PSP packets are UDP-encapsulated, and enabling HW GRO (SHAMPO in mlx5)
> makes it possible to merge those packets in a silly way:
> IP|UDP|PSP1|payload1|PSP2|payload2|...
>=20
> That happens because the HW GRO machinery doesn't know about PSP and
> considers it part of the UDP payload.
>=20
> Reject merging when the incoming CQE has PSP marker or the pending skb
> has the PSP extension.
>=20
> Fixes: 29d7f433fcec ("net/mlx5e: Add Rx data path offload")
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021062805.3466=
208-1-tariqt@nvidia.com?part=3D1

