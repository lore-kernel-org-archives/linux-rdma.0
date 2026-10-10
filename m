Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4A123BD06
	for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 07:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791616268; cv=none; b=eLL2Kjs1gHYgg16hofCkJnvHl3PbRxEXLvcGb4jfgIrQpJYyBd1+X+vl5NuGHVARAn0atVo4XdOAVPJg9skkEck/UmNuEmhqtGlsaq342oiSqV9wyVawypUd/l3npe3zoemV7OM3a4i/EXg3vxaYHbpBqyEI0fXRdN2LvTTyajY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791616268; c=relaxed/simple;
	bh=F0xG5s3XsJ3QLpGipXF4KtqY47fYRvsWT60Mb6VCC1w=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ZN+RB7hL6f0E/1GQsiwBMNL7utYxR4+vAwXEesgySalT3gySP9RO/yj4XiNo4opRYeKQSAfAylXYTdSLRiIRTptZE6Sf2R7ymFnNp+Vid4fYvROhHOhnhJKkKrq28E8dCVd9bK4RB7S0HmRd+Z3Dewcr3C2B/Q+ayy3dIS7wi8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EhnHm1z/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EhnHm1z/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3862C1F000FF;
	Sat, 10 Oct 2026 07:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791616267;
	bh=F0xG5s3XsJ3QLpGipXF4KtqY47fYRvsWT60Mb6VCC1w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EhnHm1z/Y+TdKy1BSdbsxBTMTRpFx+HDnJm8V4pr2Jb5wVoiVDppOAZLy/peqnsuk
	 TjcGlOnOef3F94vP6+s2HDPLSI/Kq7c/y95fz22qKiTNm3FhhqjTajaiefOV7/tjed
	 jFKaYVglQfeuJ++1g/zpvKreevz3E7kNUibJx5dWYCYdhbRWZ88/a49Wjw28zEOyGa
	 dRR8Kij6xRtU45PlYpJ4WDpbEmGSCERlh2BUuzqLn9YS4GY9R+ZONUqr1+QajC5XJO
	 Fptz1Oeywpq1KwctneU9MsfBneqKpPECbnA6bUAI8MncYLNidjGwni1FS9CdD+UzoZ
	 UWH1KztZB+GBA==
Message-ID: <sashiko-outbox-166300@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v4 09/10] RDMA/mana_ib: Handle error CQEs for
 RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261010065443.3554193-10-kotaranov@linux.microsoft.com>
References: <20261010065443.3554193-1-kotaranov@linux.microsoft.com>
 <20261010065443.3554193-10-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 07:11:06 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Decode hardware error CQEs and process them on the corresponding work
> queue. Complete the failing shadow entry with the vendor status from
> the CQE.
>=20
> Defer transitioning RC QPs to the ERR state so that the other work
> queues can be flushed.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261010065443.3554=
193-1-kotaranov@linux.microsoft.com?part=3D9

