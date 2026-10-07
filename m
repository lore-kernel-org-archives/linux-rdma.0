Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2F83B9618
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 16:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791390262; cv=none; b=fp7R6htfu/6t8CAinSVf8U2gp8MZDwuMR53KAuMzCY2iwi8kEU7PwQ2F4AX2pwWtjHdo87+jYbhqWRjqJDhJYK/U8VxTBIhmu4LC036/k+BaLeTC5U9I43750Ob9PGigwm3Abuzan4IDJu73TvTPUrD6s3NoyHeeiuKxeZdj5Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791390262; c=relaxed/simple;
	bh=8V0ESsHykB3/zLCc6O1v0d8kAMJjK535kXtf2dvFw+4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=FQMkB7K3gDqIq8HxlG8xKEUxGApoyOPBzglcPbFGlWOrXfMg1pagVVLFOyo4sMc6MBKqSCPeksEt98DTkXN0QrDeHbQMXUkAANsS15wT46AHGqNTdKN9Ijm+T26M1toNXewdOFcoHNekQ3i/xQRdVau/QwjGsMTgg5XBfUMmmew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fm/trGen; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fm/trGen"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5861F00893;
	Wed,  7 Oct 2026 16:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791390260;
	bh=8V0ESsHykB3/zLCc6O1v0d8kAMJjK535kXtf2dvFw+4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fm/trGend8BNc1Fi6n465tgG+X4E2sApAnyjclFymY1Ir0QGq2Tu0JYjMkmYeWRlw
	 vuTtiYWujOwupU9dJklGUqTSovEonFV8cmZpVZl4nO8uz6rkdC0zqQZiPZKehDfOjz
	 C1dWNEMjfJanYwyGLUAXkxZj9JhgH9okZGRnWI+MWpbi5Vo3Z9OEcSeYN8CyuOmEFy
	 r3KhJyGWOlAopwjau91YxrMqERAWJ8dDI7VecA8nQsxEbpQBtREZlnTLvXw3RSmT30
	 DyRnMErl3lNKMHGkYAXj2I4OoNmtYWDH2SaqvvVJEIM8EePK8xy8U0T3viIeHwdKN8
	 RbLxSfejWshTg==
Message-ID: <sashiko-outbox-163191@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [net-next v2 2/3] bnge: Update HSI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Siva Reddy Kallam" <siva.kallam@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261006161256.1493672-3-siva.kallam@broadcom.com>
References: <20261006161256.1493672-1-siva.kallam@broadcom.com>
 <20261006161256.1493672-3-siva.kallam@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 16:24:20 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Saswati Das <saswati.das@broadcom.com>
>=20
> Add support for 64-bit doorbells and Mid Path Channel (MPC) firmware
> commands/completions.
>=20
> Signed-off-by: Saswati Das <saswati.das@broadcom.com>
> Signed-off-by: Siva Reddy Kallam <siva.kallam@broadcom.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006161256.1493=
672-1-siva.kallam@broadcom.com?part=3D2

