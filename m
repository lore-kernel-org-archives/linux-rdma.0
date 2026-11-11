Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404812;
	b=5smiE3blx62PnEXwO4MWgRhhp03Pm+mkKd+FyHJjoUFlGDTPNUNtUmBuafzltMNCqmYE
	 fBOOEiiIZOCiHAYeebWmZOE4pRIHmxeA9xHWnARE7odaXu6zG7vadsB004uurkyQKH/kH
	 wGXtimlm+3dda4YKm4meuWhRhXWddlQJLaQXdnCY6tidyTM9ecwIy3AraCBxYTw+Gs4+v
	 TXy9SCAuEf99BSpnOwONYEhbOPuLRA2HjwvxAUKw4fnhCjaDXx0mnQQNRTwhFdWgdJKDz
	 nL1kNki7Ff5HnoLxfznTrHXgmGgOXLHgMo5jBJ/H8uHQAqZv2ltC16mrhmmzupDrl7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404812;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=nhOCtmALi1qE/WbW6lCCI9gKLLwANvDDL81xjKy+zz4=;
	b=tMHLK7dN3tTsSyXdThBxmEWLRQrhIxUOEcH15sKpIJMTNL3V1yzaDQW5aPtgljXVg92A
	 Oc/ULBX3f7QF7kjqwp6O9h0LvEXYSwuNeXpcjKHteFMh7xhw7vc3x/rv28Z9kH66wu6OG
	 8ghNPvdz7Te88RHElfCKXa3rpL39GIfUjmdY+UBMoE0zbhZFxn6Qqfn+D7nbPcACd6Du+
	 Z0+lqo4CrmCFnSASHh5zpbIDdebM5KO/Nfjo0aJ1NALUUpK1w2KTzFN7901hqdKSQP5Vx
	 jKMVXUtd+ev5PMn/bxqUJCP3TNvZQMme1OfR8xU/zqKD6ZRkd9fXjlvJaGfd9wlGhfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A3U63NEt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C642606A882
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A3U63NEt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E789D1F00A08;
	Wed, 11 Nov 2026 13:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794404812;
	bh=nhOCtmALi1qE/WbW6lCCI9gKLLwANvDDL81xjKy+zz4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A3U63NEt0X6i3KqZGZfXq4xo+11l2lDXIKK5aIn2EFobWGj92jQcnF2URkqtdABHe
	 0JyAvQnE93+iKMYOPKK1RZiIu1NaS9OqusnpiB6iSov1CV7wLEyu+mHkFLPzTVQN6w
	 QYU5HA75buO1Sbf7O2WxaDWjZi71Xl4OYNTEsGqERk3QQXNGTFTwsotZUx4nONVAhE
	 HuKWtPguMsulND7smjR5MzMLhCCVGuxdC0zytv6XWIjt8SKC+FI7rj9adwFFl5G0kR
	 xGY+3e+EPRBvmO+z+GKBtT8bhs0635mpXK2qHGo0J8750lAX59frHjWPcenEStIpEb
	 nccm85p2HG7fg==
Message-ID: <sashiko-outbox-209097@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 12/24] RDMA/mlx5: Add shadow FIFO
 infrastructure for UMR completions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110134320.34408-13-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-13-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:46:51 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The UMR CQ is polled by the generic path, which finds the completed
> request by indexing qp->sq.wrid[] with the CQE wqe_counter. A hostile
> NIC can forge it to complete a request other than the one that really
> completed, or one that is not pending at all.
>=20
> The UMR QP signals every WR, and its send queue completes in posting
> order. In adversarial mode, keep a FIFO of the posted UMR contexts, so
> a follow-up patch can check each CQE against the oldest pending
> request instead of trusting it. Each context also records the
> SQ producer counter it was posted at, as its address alone doesn't
> identify the post: it is usually on the stack and reused across posts.
>=20
> Nothing consumes the FIFO yet.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110134320.3440=
8-1-yishaih@nvidia.com?part=3D12

