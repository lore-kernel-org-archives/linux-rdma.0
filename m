Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B224368D7E
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 06:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791010513; cv=none; b=Y5PwHg7ZiysWptvVdZcTymdSFpgu4WnZnKz+7Y76SRc4iCnejcTCNaCsSeCfJFyMWc3G9p9kfmcAl4foVMN0kQD0FhEojz84EZJN5bBHlm9XgKG2iGPmia6anL9fWytJbme1+ZC1mwkEzDq3KMPdcdTjywiiXIRgXU+sMkaGAA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791010513; c=relaxed/simple;
	bh=13y924RJ/gbB3zJ3mpq7ncf7F9rSjF7oOpMnUjO9eOc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EXn0TmaU8arhxCZeHY7U23Bggkc3EicrOSKvDor1xUFSumo3CaULJFp+QKLPIowHeGigh5nKxt6BQSb9CptHoxoKagVwb4buUujWo2U5Jp8cACoP432wwW9Cx3eCGzQneJlpdxcFgL1G331SBjikA+3mzYFveFksyN1LWDtUslY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BV2JO4PP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BV2JO4PP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDF21F0089B;
	Sat,  3 Oct 2026 06:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791010511;
	bh=13y924RJ/gbB3zJ3mpq7ncf7F9rSjF7oOpMnUjO9eOc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BV2JO4PPW9zkxUUCMTS9Ax5KMi/aHzWGIrgDfRdWBGgTsTHd6B2VbGbNRH7l9F49v
	 L88FpQCizNuO+OdcVUOQtECReGcevYIt97JAI8TWJxNvFynW54Csnt4JgkxJjGVXTv
	 VskF3Lvv/4Te4I4EdS8mAgRZtcXi6OxJrwQzS2bg0S+dTJ4sEdUU7r4zg4wdAEviYT
	 gyz+QUgAmmHpDh/ZhnuMwYpoX0DxG81LampSNjuFENqAefjxo9JITMWUkbR0bBlcdC
	 mf4rgbvs2UczOkTEF/Q1pod/sTQ08G6GkuONRWPKUZL3uSEbozoaO2dc4lt5h+R7JH
	 ya2ZRfGR+PV6A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 02/10] RDMA/mana: Create and destroy kernel
 RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261003064037.2092669-3-kotaranov@linux.microsoft.com>
References: <20261003064037.2092669-1-kotaranov@linux.microsoft.com>
 <20261003064037.2092669-3-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 06:55:10 +0000
Message-Id: <20261003065511.5CDF21F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Implement kernel RC QP creation and destruction. This feature requires
> extended-WQE and power-of-two-SQ support from the HW.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003064037.2092=
669-1-kotaranov@linux.microsoft.com?part=3D2

