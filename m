Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C524FECC8
	for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 13:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789567032; cv=none; b=a7NN7AiRdcaST759cvslB0AAdWSn44QrFAYofxv2ctFDzHDcYhWflvgYNwylnPpiQTwO4zVE90KhZjOwqg5dW2P5HPkHkcOY01PnDpxYdmgULDZp4txjw0ug650bN6DW4vRUloo6xJeaDK53pvUpZk7uQW5992JCr/Lb5yiBn7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789567032; c=relaxed/simple;
	bh=te2WRD7NuVv6mmFQop+25koEoXciYqEhVzA7KT9FQI4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JZ7FU2bTNUS1NU/ILDyWZJH3piECBnl+ogo8cquh3LUTIQrQqCt2He5pcwOLcNrTvaHyjza3L0/yEDMokkKrMl/p82OBxgEW1Fx0IDV8knAMmnasFk23FwEbRMUvvbfVpv4KFCzDhCoAdYli5Gkmkxw5KZA65FOLnur5AQVBmck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GZAjx1SV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GZAjx1SV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95F51F000FF;
	Wed, 16 Sep 2026 13:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789567025;
	bh=te2WRD7NuVv6mmFQop+25koEoXciYqEhVzA7KT9FQI4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GZAjx1SVdIFN/YPMn13mX0SGgr+j18RRNHMk9LRm6ZYGaFtue/PTI8j9BI+2S2oVc
	 tWBf/xyAtMdAL7htEoI9joyDuYVSOjflgMo5+C2eKjAPq+CqtXzJW/aPAkX4JoXDCp
	 RuCKOctR4a4fCd94LAz8AqlFZK6CtwxBI4LpXW+4kdRTwTmOcWzedOuVFMcXkCSQwN
	 MHVGSA8gNAGI7/zh0+zi4Pmp3VUgaRFN8eBK9Csmj14Byk7OG8zkJYaeOHbYQM+sKW
	 W/H74+HofP0pGx7uw+VkojztBHtBltYWebtW01vRs0ok4giozEhnERZtOODB/WPYI+
	 uAPWpHqd0ZxEA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 3/5] RDMA/mana_ib: Revise UD receive posting
 with GDMA_WR_IB_SGL
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260916134835.2380971-4-kotaranov@linux.microsoft.com>
References: <20260916134835.2380971-1-kotaranov@linux.microsoft.com>
 <20260916134835.2380971-4-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 13:57:05 +0000
Message-Id: <20260916135705.C95F51F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Pass receive verbs SGEs directly to GDMA instead of copying them into
> a small stack array. Accept the receive SGE limit, supply a dummy SGE
> for zero-length requests, and ring once after each successful batch.
>=20
> Introduce GDMA_WR_IB_SGL, its request union, and the wrap-aware verbs
> SGE writer together with their first consumer. These shared GDMA pieces
> must precede the later extended-WQE patch so this receive path does not
> depend on definitions or encoding support introduced after it.
>=20
> Address verbs SGEs by ring offset so both scattered-page boundaries and
> ring wrap preserve the local kernel baseline's non-contiguous buffers.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916134835.2380=
971-1-kotaranov@linux.microsoft.com?part=3D3

