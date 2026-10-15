Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706D1551989
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 16:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792081723; cv=none; b=k0PzHjXsLlx48Vu1bXvA1Ps6aeLh3xZZR7mn/iuNvuZtqWxYghJ9JhyZcr0d6+jmB1pA3/aDrrgmz2/qoBfaQBwIWuszOBZfsZimAtIkjcFdgPmCHjdXhyGom2BrhMa+H89FIxbue6XJlXharvMqP/johh2uJZRGBNHo4Wh7TFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792081723; c=relaxed/simple;
	bh=bYRjHpxqjzexYZCOy9d+4gQ86QvOMxd+Q2EsVktYHs0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=aCH9GJ6T32N6dAZ+qbyZXtAmXka90724XbZOTqR+k4wyXFAnl217kgCEbJsBfQpcGsLDHVKrC1U/58HjvdA4ickkZ3kGNTj2D2+HvtBCpTitEVphwaQT5GBPLAI/0Am8C8NfHIleNyK+KexJ7JdcERB68YJqRmYudjhzPR8mou0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GCdbmCKB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GCdbmCKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE581F000C4;
	Thu, 15 Oct 2026 16:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792081708;
	bh=bYRjHpxqjzexYZCOy9d+4gQ86QvOMxd+Q2EsVktYHs0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GCdbmCKBIvrukO85SjbshYYB6aBMnrv18N86Hgv5mQLNNZhBZhUeM53YjE9bMGBBJ
	 abW680AtrCrpUrMROh71ZJGBAi2VZMOfKRAtLYg+fAwhleOoGpTq0a2/ljB8hIvTWI
	 txvnYvbRmmkkcxqeeOS7VwvBBkk2Lr1qBVNCKQZsYprcsVjlgrk/pZNH32MvSA6ZrM
	 Pi+CYxqv63ncxHgMDdlQvP3xSUjebRV8wmiDO0ye7WcNHhxzs2J8FzP5JzrgauIApY
	 JeY0LFJ/ht0L6gTOXLq382jzEUkKcq6gcWYVBULJiAWTBQ2JMe21kHQGXB8GWA5zfx
	 JMA6kXxu3JAjw==
Message-ID: <sashiko-outbox-173186@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/irdma: Fix FRWR IRDMAQPSQ_PBLADDR field population
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jacob Moroni" <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261015161756.3078300-1-jmoroni@google.com>
References: <20261015161756.3078300-1-jmoroni@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 16:28:28 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Previously, the IRDMAQPSQ_PBLADDR FRWR WQE field was being populated
> using a mask that was right-shifted, whereas it should have been the
> address being right-shifted.
>=20
> This ended up working fine in many cases because the lowermost 12 bits
> are always zero (the addresses are page aligned) and the uppermost 12
> bits are usually zero too, but it could break for DMA addresses that
> are wider than 52 bits.
>=20
> Fix this by right-shifting the address instead of the mask, similar
> to how it was done in the original i40iw driver.
>=20
> Tested with NFS over RDMA with some added debug logs to ensure it
> was hitting both the direct (single page) path as well as multi
> page (< 512).
>=20
> Fixes: 3f49d6842569 ("RDMA/irdma: Implement HW Admin Queue OPs")
> Signed-off-by: Jacob Moroni <jmoroni@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015161756.3078=
300-1-jmoroni@google.com?part=3D1

