Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794451078;
	b=DGXg3lcrplweeD9FJQvz56Ut7uUCM4W4U+Sv5cMKUOdkf76PIq8b3TB9i8bi/y5L53c0
	 7u2UKK4oepoacci+h4kNsTzx9327dAIAEjHkiRCldjJAaNPN8A2LolqHglJeRfnmTNJ5J
	 k1E2oAAz9NsJonp4mzSNQRmbHUdTRw0J6olGS1XYDFmVlhOvJ0MMC9FRhb4iS6wmLKWqI
	 8p7/QSKT8QVLxuG3zwNnpKN0p2+c6PWplz7TiUjxeikCbpt7oijSxzJb4VA3oe7twsvPW
	 0V55v3MSjagzhOEjv4qZtmfxGw20w2eIPdbYstPK1nPAj29hnARYzl77vJZSn/3t3cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794451078;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Pc0PAXiL5bd5SZju0Q78TlUmIssl03IYgwuMMhZiJSY=;
	b=0gPFWXqTY/FFk6P6/zldpYC+cmZfqX9IzlE0TJ+4TRUjuWC8D8HNGK17LDzcmtJUg/uX
	 g4WVPckQiYI1tT91UYsTptHhgbFel0Qhepa1FsYkYst0M5kx+GyDowX1Q7B6OKbBus7pt
	 BobXeRh/L0wnRbaylmf3F5f3V5lq8Yr58Rc+NNmT1YG3EOpgnmt+DTUfG0c60gmBsoVJb
	 8N2ktJGLD6aViSNpDfTUkrU3/IVoX8Dq6Oef8zE/LYIS2gGCRWXvemzP7B7tBo2y4ybZ9
	 XBislIROXONlmcJPKS7LnYaPE+hqpwXsJCU8qMfWHnOaGdqfx8vr8kjxGXqiICMD0SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eTfy4Lj4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B89F606A321
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 02:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eTfy4Lj4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A351B1F00A05;
	Thu, 12 Nov 2026 02:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794451077;
	bh=Pc0PAXiL5bd5SZju0Q78TlUmIssl03IYgwuMMhZiJSY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eTfy4Lj4tb1pWi85RfsbljWca99RkjKCkb6phO80r0DQjTRZsZhFrQ1rxcSg2QLsC
	 3YLIPI9y/9ukc9f8eFnvP8Uwws1Jvs9ceIhEsgh2hs3DvwmwuCjOoAPVVMLmEAZMI9
	 PT0XsZ2Z8wlmc4guI6M5vcP6yzfc8GqIcRcdc4SQQ2cybFRSLupfDAwrYZl+KK2xIF
	 UcSCndpTZgqwWQ85nL9jfOipL0Zn3CK1Sywl3dzst5pRt+fgppNeu6TjQ/bg4+0ahS
	 x6SS7Krwwu0x6lL9c/JuT2pDYOhpcNt7gSjq9cHle4o2yO416pFYpz7JbF1mEV66Mr
	 XuY3Ka8hWiVxQ==
Message-ID: <sashiko-outbox-210211@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/mlx5: Return ENOMEM when allocating a MEMIC
 operation fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhu Jun" <zhujun2@cmss.chinamobile.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261112023108.118187-1-zhujun2@cmss.chinamobile.com>
References: <20261112023108.118187-1-zhujun2@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 02:37:57 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> When a MEMIC operation is not already mapped, map_existing_op() leaves
> err set to -ENOENT. If allocating the new operation entry then fails, the
> handler returns that stale lookup error instead of -ENOMEM.
>=20
> Set err to -ENOMEM before allocating the operation entry.
>=20
> OpenAI Codex assisted with analysis and patch preparation.
>=20
> Fixes: cea85fa5dbc2 ("RDMA/mlx5: Add support in MEMIC operations")
> Signed-off-by: Zhu Jun <zhujun2@cmss.chinamobile.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112023108.1181=
87-1-zhujun2@cmss.chinamobile.com?part=3D1

