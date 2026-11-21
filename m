Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795286644;
	b=xjWCMkjkQ9CDeTibNeXAqjoWYWOsJFS1qGxR/XmCjnYDRrPbUKv2HvYbYSgEKJwDTfPq
	 vlunOf2JDqQonFkD3yMm+HZzrPRRBA3Gwc//JR83LAUr0ZFF4YD0+dQARoxrt4iw38rzq
	 +RIjvklNLQJtalguJPiOTqh9Dxpvy8Ea4s8Gx7B6dVveC8HS63EiLoqshFPfzbxGqWsUo
	 pg4FeCoikEOOlBzcDPzzGTVxqHxLB3FyPl1swlrWkOY01irncx8Pi1OR0ZIBJTwKk6oK3
	 oLeairuS5ZiAxxZzefDSmefcnF2eRnEd6e1pGr2VIzAQFHZTcL8MxHndv+VxXaXAF5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795286644;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Oo+diVxmTnfZUt2xI6xcR1nRTldyDak0go2MYaenUaE=;
	b=sZ/gjFy4G9R/lBJnAWJFQQR4vRKF397rOTG76J+S/s8saP4tET3mrERCSbjGv7ys6lVM
	 KJm57IMNYN44ImIbIXF29XJaq+KYyuQWu6xvWC6QL0b6qqfsFTei+igMiESIeeYe/H9Wk
	 YayKlg7M8ziDJ1lRR0bW+jzbuUzy8KZD7ooPJ8x3G7l34gs4Su2IuO3YCQ72fc8zYM7Xp
	 FDd0kawKkxBT7L1Le5p9nzJc+NceVy0j7lUDBIr5kKN2IOb0KZOsGe5evg2x7yw36h81E
	 WoeZhumnMn0LUHu6BDmSK0LdwwJEDr170WEx1X8AKJWTv8cBAtcIb5T0wJpwuHtPiFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mHTSLiFJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D38606A320
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 18:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mHTSLiFJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12C41F000C0;
	Sat, 21 Nov 2026 18:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795286643;
	bh=Oo+diVxmTnfZUt2xI6xcR1nRTldyDak0go2MYaenUaE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mHTSLiFJeFDVBUy2fotTb/e5EUWUbzHrmxbRfS2+2Es68DtuZsG5CL5gUlBZ90IS5
	 Pmad1i/kPyKYJFaYNk+D6Y6MU7MElousDWE5eq3JiHYuwCm26yTB98xLG2dVO8T/M6
	 ABha5CpE0f6jLnOyilMPgY7HJUdvspN6IG/k51L7LCn/u/yAJ+6VuBwmznOLIH6SC7
	 X/gLYGEe53RnqVar8B63e9BvxhyRUZpe9Eo55JBxaoYIjv40gWaBDbpEaSrCyyL08N
	 QcIDc82MqNSLsXxFfwxVWplTmRBG2byKbdWbyJ5POr128mLPJ2MXAQrvnqLTtDM04L
	 TY7/oh4XPBNOA==
Message-ID: <sashiko-outbox-227270@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v3 0/2] net: keep the TCP fixed-ID flags on the
 header they describe
Reply-To: sashiko-reviews@lists.linux.dev
To: "Julius Bairaktaris" <julius@bairaktaris.de>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <cover.1795284858.git.julius@bairaktaris.de>
References: <cover.1795284858.git.julius@bairaktaris.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 18:44:03 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Sashiko has reviewed this 2-patch series and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1795284858.gi=
t.julius@bairaktaris.de
