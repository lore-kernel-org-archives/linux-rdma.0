Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DBE38B14F
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 06:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792219705; cv=none; b=vCYbSc7debHIMZuUkxj4DXSQQoK7ffOk6ppzXNXWBA3C9ZB1+FgYk5UPLo90upAt2Ig9qoM62hOjfpHPsEPMMb0hSFaKoNOdKAxaS7U34WvDTPOlEPwRzJnPM8fJZX0RJ5BSCxnQnKcqn+/iTaXezhkZFjelkOgj2hkwzkDDhl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792219705; c=relaxed/simple;
	bh=E/Cmi9TZsIA6APf2PN1I0wEHOw/dFT4CbLrAZPkh/Gc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=BbnvhJAaFadeXAeEs98YyFW7us+4oO8BfqSkEkTrtq+u/3t41Rm5fZRKj6mgrhAMGQTG4/4BTAPTLOySO37Zvhisd0HjzhMHOYZ9jBOmaQd7N1LHwJaej+zfU/sk45K4zGK8R9hsIY4eVsDH+RU6tuQYn3+7iub4WbLMryizmBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qz90PjCF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qz90PjCF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA221F000C4;
	Sat, 17 Oct 2026 06:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792219703;
	bh=E/Cmi9TZsIA6APf2PN1I0wEHOw/dFT4CbLrAZPkh/Gc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Qz90PjCFmkOlwZklsH8zXyST2+hPstgzhVKXGnfDrPDMjGVptAjUhW9zVI1lWhnwl
	 yCgPjiKz1Pw9R2AnDPpsK2G4sET6MhD0P4qa9UYBUCZA6tNDqo1NuJzs6SHasBFGcH
	 NKMmV+Muz8x/RXaLwPp+3Iuq4/EvK5kLiVQhfMC1D/hH1wsALyk73QK7SUxaJ6/sGh
	 saFiYJPMFgVpl66CBZFpy/5f7MOHwTpcubo0U25HFC375oweOxgYirXRaIHMZek0xm
	 MzKoBpUpU399b1obRzXCW4Za90Ag3ezymmNGXrQV6cSCgyUNUgUy7rfSJck3W9jlu0
	 q1JOjavjyQj8w==
Message-ID: <sashiko-outbox-175349@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v5 05/10] RDMA/mana_ib: Post receive WRs on
 kernel RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261017064413.995985-6-kotaranov@linux.microsoft.com>
References: <20261017064413.995985-1-kotaranov@linux.microsoft.com>
 <20261017064413.995985-6-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 06:48:23 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Implement receive request posting for RC QPs. When posting a batch of
> WRs, ring the doorbell periodically to prevent the u8 counter from
> overflowing.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017064413.9959=
85-1-kotaranov@linux.microsoft.com?part=3D5

