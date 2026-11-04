Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810624;
	b=XKWO9me9bG5w0AHDgoQ3lu/WpEk5f6tLuZrJYHYUD6tqpETVeyg413bhuwj1sUIRSc3w
	 Ip84zxaf7dmp2pMZVeDman/SJUp/jkRO7i3SoMOIHvFY/ogK9hHzgVDrsq+xGeQW+QWAc
	 N76ld3mO8NYppoHW8bLp4doKtIwEYTZt2zGeFq5AN0IlEUIpdrkRPr1YsWxCXyN6s4QDt
	 YuAj1k+2meJcFt2JltVlP8wnHgtUkJND5E8EjwBsGBLJP+3+9ChW04k5XhaNXYD97IuZy
	 sJC8mP+GLiR4m/UwgevdNDdtwfIKflii+ZjKD0ogRAYLS4r8n6g2/oLW2SxPG1GZS3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810624;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=GIVfFR3DMcr8GdCqubw2Oz9XGOeQDlYzNdsVRG8MpBY=;
	b=SERI1A26U2K2tt/WpDWNf5awYXI+Tk+16NI5kdHDfTck3K8YFcgvrJ44GAP5L3TBOn8U
	 /AwAnunVxGlW3nvJlqm61XzZdoN3cf2oO5ofq1qJcY9ULP6DfSKgl/mQ9M6AJcRT6QLUq
	 Uuk7WkYbuIolyWI6QORyho2iCGi1vCI/mBH2+GBBL2rj7xhwumFz3seHW3KQ7hfX1b6++
	 xGj5dyMmYLjO9CdazULXcA4yq7Ynyd4ktHQImV6RyT/536tOlwncPv8p0e2Ar4mNlhZJ0
	 03lGDc88Zui0gprMPE03JwUgTTO/5H8VM7lEERxgcrV0HNs4vOuosgUjI4cPizQvqHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XEt057al;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C2D606A32C
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 16:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XEt057al
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01AC1F000C1;
	Wed,  4 Nov 2026 16:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810623;
	bh=GIVfFR3DMcr8GdCqubw2Oz9XGOeQDlYzNdsVRG8MpBY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XEt057algqPj+U1+dg/SSetXZL/351rVcA+32xJmH9CwJC9itl1qE0dfnlV9HuyYJ
	 /XnxEyfd5oR+8Q0mFS0Gk4KfO4F7762ngM61B+NRKAqc3G1f+jD9fMSH4Zp1FHPXHq
	 r8y67ZDc6k7AeDKfJABQXkNMIDfVSPTLg3EUF+//8eDiKS2UJlmFxeaBi+cVs1Rgb8
	 yB632TPOgyWqJnFmHCFJwXKwTOoZnoMt9mPP/9mXSda/phsJm+fWvHT4PuEKEpSX0S
	 /Rvt7z7tcpgakBUxVXF5/6zDH305z6pFsmKRtrC9mcyKyGliHBvUPRhFUQnoPxzJGF
	 BlTGRUWuPe9pA==
Message-ID: <sashiko-outbox-197658@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 05/23] RDMA/mlx5: Reject QP transport types
 not enabled by FW capability
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103163949.1554-6-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-6-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 16:43:43 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> check_qp_type() checks the FW capability only for XRC and DC. RC, UC
> and UD QPs are created even if the FW does not report the matching
> capability bit.
>=20
> Check the rc, uc and ud capabilities as well, so that QP creation is
> refused for a transport the FW does not support.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103163949.1554=
-1-yishaih@nvidia.com?part=3D5

