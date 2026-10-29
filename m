Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793284676;
	b=T2kE1L+Z+GQ1qp7JNAxXIgrVPJd/keWTNCc9+3k/jv8VqfwpJkZfvEsPNdJmZDFW0Lpw
	 4AWpBWHF8uNBYl4O9ZlKyEiCDisiipO87rvPTl6Ftn58Yco3xrJfKAlENWTBelsGgK6UG
	 0eJkuysOgvwDbO/J6It4jdmFTtoAGOdYMIfbFBxxZH1a5/BZdXxtAX1eks1XyDZy82d0N
	 wxsAjX0olhlc/+eMzK7OMavqascFxmj868cE+1kArZowIDwXUldOKcch7IrwrU9+atS/w
	 h6rxQTxTrfi7xai7QadGAIvTpDOvaldQweUaRK494HpHxrGXfgym7u6o1Iy0znP8xmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793284676;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7PezzHlP+DINnD4v7IGqRaEaeQpoK7FHDxISxw2KPtM=;
	b=GKwgpyDJT48y/c9zICvqaTkeJex0hH7eKagopmAu1ihNXSitnHoRy+6/DDf7fHZ4LEUe
	 Pj6xaTF7z+HDX66bJzzSHZd8o1V4cqDHhpVnDSZOQCoZm/Q2IU8+J4bF/+7cYmBTs6qUm
	 ghof9K7xhb16tnRscchWlxuufxDUfI/7GocUuiDYn/kQw9zggoa1wBcMT0jX4FGULOHR/
	 s339KWTQIO0sm3ICvlZ1bAkv673FvzR17yi12VCpIG3I8pdZSVQcy3XlMFr8MjJCEVz1+
	 60z83NnRaXgcu96mANmRb8+xFgljBuyI6Q5gBDvciIkTegwnwTb6hJmIasXntuy+vGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cETqZlzb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E07E606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 14:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cETqZlzb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E8C1F01825;
	Thu, 29 Oct 2026 14:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793284675;
	bh=7PezzHlP+DINnD4v7IGqRaEaeQpoK7FHDxISxw2KPtM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cETqZlzbMg0DJEk7Ius5voswMnf3UINpqBf1NqYkw8LRvJgxpUHJpyO/BSqlnlSs0
	 YS8acOsCYeHHFcp+PA1Z2vN3eQzfyLVSoFS5+o7f5vhu6pvvMDrjIVmJSCDd6aPR51
	 2Rmz4Va2tmSY/ZrDALUgi6zzyvI0fQEwOv9NkVxyiy/z/yZc+z3Y+xEen+AuVEjfG+
	 SDYhnBGsUedSAzDAb121zur/YukQwpyYrnmw5IfeY50+/++YRNE+WECPWi8ZfX5ep+
	 IufRXWAn5r9k1nKV5RP2zPbD6UAd0kJYP1GxdetI4pAPahc83JJkx1khFTwkw2tfkl
	 xAMzKGwfmjXrg==
Message-ID: <sashiko-outbox-189536@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND rdma-next 2/2] RDMA/irdma: Do not change mr->pd
 in driver during rereg_mr
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jacob Moroni" <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261029141849.1575012-2-jmoroni@google.com>
References: <20261029141849.1575012-1-jmoroni@google.com>
 <20261029141849.1575012-2-jmoroni@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 14:37:55 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Previously, IB_MR_REREG_PD would cause the driver to set
> iwmr->ibmr.pd to the new PD before reregistering with HW because
> irdma_hwreg_mr() retrieves the PD from there.
>=20
> ib_uverbs_rereg_mr() only moves the PD usecnt from the old PD to
> the new one and updates mr->pd itself after the driver's
> rereg_user_mr() call succeeds.
>=20
> So, if the rereg_user_mr() call fails, the MR is left pointing at
> a PD that does not account for it while the old PD keeps the reference,
> which means the old PD can never be deallocated, while the new PD can
> be deallocated even though the MR still points at it.
>=20
> Fix this by removing the PD update from the driver and just letting
> the core handle it. This required plumbing the PD as an argument
> through a few functions. This works because the core passes the
> PD unconditionally and provides the current PD if IB_MR_REREG_PD is
> not set.
>=20
> Fixes: 5ac388db27c4 ("RDMA/irdma: Add support to re-register a memory reg=
ion")
> Signed-off-by: Jacob Moroni <jmoroni@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029141849.1575=
012-1-jmoroni@google.com?part=3D2

