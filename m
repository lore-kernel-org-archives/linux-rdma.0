Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794474146;
	b=BwW+cBWFRWMv6cBNA1N0MHHLlBZjKl02eEjylkI9S0ADoHAl16E5j1UP+jvCJj2v1L3z
	 AtgleGXOAEexEbpBQA/+JpU4b0yqcm1VhlkksFr2+EASvySFIvRIwOpUFAm7d6HZ5JM9V
	 +K7+BCn7Tb0QmlP53XidMXQH3fxHyOnTCVWBrNcLoDQT3llqtHMboTa9+xe1BHoHFi3Lr
	 nOu+V66J2wjEbfH/V6uVVKv8IYyzMaTguSStSuCtcDmBoXm2M3dnpUf8F9nTPoq1pUGgm
	 L1IQ9Jgqga+SBpFAEApnjdITc5iFUznBVgkrC0npJuRsHasyiPhcAyJimFSZHsvQIrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794474146;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=AthuKdznxFTkEq9KwgBSAtW9qH6H6XdG+T2r9dLXb2I=;
	b=k1FYisEA7cMrvHu59cPbc+cxnRNVdVOfZ5xu5Oi4V4YSYIbqlSP80eaBsBQS0r/Kycjx
	 gtxldvS4PT9vH9iPb7rVrLK8KvheU1C9GjMkERU+N175QRyartb1Nmzj88NNM9fC1vTAA
	 Bq2ajjXQ9BjjSsy2IuaqyMqLqwMCsDNkQ6ynE6DYL+nzofWtUfF3xNJJppEBsFz9IGjOo
	 xvBQhaQg1a9ufSvO55kFMEJqsTBG7yAEA4HAKJTrC1jiYgtgHommUGFxzNmLRSy4i680K
	 TfpXRcAuNe/QpD2s2PoHJlhB6HtEUGtUMC/HQ1JD0QAeru/vaxfmX8LqupwySeBobBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mO0+5Ru9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E693B606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 09:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mO0+5Ru9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58ABA1F00A05;
	Thu, 12 Nov 2026 09:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794474145;
	bh=AthuKdznxFTkEq9KwgBSAtW9qH6H6XdG+T2r9dLXb2I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mO0+5Ru9PoQ9b0qrZgft3d0QC6FZD3KdJKRcQcqkytQp1/2UsRg/CEEotlWLcjVjs
	 y9YyMaBV/95svu5+7mAZbySkg0g6dwLKpUc3TWUBJ9JXwhJHeifHr4FNoNYYFmxuCL
	 KylrGpulxilAPskw5A7sebXHeTz3ZBwGF8oMGtMdhcYV/iYJfaGLGQf/15Spvv2pSO
	 llpoHpASlzv9mNt59yZjFTVR19JdkNWIw5HuBSNrFQ25sOT9Z+TAaEw8lRUjKMuwGg
	 kw8AlY7IcYvnaGOZton7V2UyudVzgtE5Q87CvS+MVXfleWkaKae9MPGtHK+Y7d5YAT
	 /ZjHP039Cad5Q==
Message-ID: <sashiko-outbox-210816@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v11 3/9] net/mana: Extend GDMA encoding for
 new RDMA WQEs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261112084716.1483342-4-kotaranov@linux.microsoft.com>
References: <20261112084716.1483342-1-kotaranov@linux.microsoft.com>
 <20261112084716.1483342-4-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 09:02:24 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Extend mana_gd_post_work_request() to support extra-large OOB data and
> fixed-size WQEs. These formats are supported only for power-of-two WQE
> sizes.
>=20
> For fixed-size WQEs, use num_pad_sge to specify the padding size. Encode
> the WQE header fields required by RC QPs based on the WR flags.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112084716.1483=
342-1-kotaranov@linux.microsoft.com?part=3D3

