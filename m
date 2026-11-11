Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404815;
	b=dQc4inG377TRxYu2Ql9IMmuNCOvuqv4TDA1wotWnBM/ZDXSSltVgHJdImpz28/joU+cc
	 X/OsKVcnPc+JWdcsy1f0n9YqsEYeUl7LWgmjTLiUoPnnG6q77PXJX6MZmernpVyxlfXly
	 mrZq3Mjfrh869utkznAb8DyL5ADVLO39SKI6u+zIT9+B1T/zguTcVbk4TqFl4jbgXu2Hh
	 ZkoJe2uu3FlHmINDJVUOeTpTkRKn94JrIaNIwd74Zpx5TARyKANI19izn0ULfwwn9bkLx
	 gf43LpnYXvjWxECzQApg6sQF3rkIQpMsNDwklJEy7afnZTZRglcmRq/8+VpWtwcq0Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404815;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=uZIlLwVLxM59C31w2KCxkL8QutdgLGBjIyI1iWX3Dec=;
	b=AsUA/aHrmZ5xZ4Fh0c70SoqwB3Vt7fzeW/Bi5lBQCIYywOo8N/i9Ph8r0EgLpD5Fwdbb
	 cb34bSzB3rDxAGAH1m67jgu8WoCe+u4SU6aMa1wnFpH50/hGYMyvpuZbNXUwdj7Zj0UXf
	 Aluqp8o6apUx99pKgT1VT7B3dwZEMqDQBFXVoUUj9FcC0aD6I1U0jql9VZ0vuwwz3Q8oG
	 34Gn/XYDssiGUToqT/QrBR/YCEuXY/2n1Y+bHVW60B/XnuEq5/gklWDt/b8fHHObmWuqh
	 oXZyVheZkTD3NOV0obWo0Bq3XJ3HrU8ayyiCTLuwgTX1CyrHtHIBZ12Vnh+Q2jN+ppg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Hx4/Nxpu";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5C9606A886
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hx4/Nxpu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3191D1F00A06;
	Wed, 11 Nov 2026 13:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794404815;
	bh=uZIlLwVLxM59C31w2KCxkL8QutdgLGBjIyI1iWX3Dec=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Hx4/NxpupUkkvNo8U6Gfg0oXy8CQajlM0hIkxUrUwei2j5m6wvnM1AGGVeWk/ZTOB
	 fzG1m8iHp8xHZIm3jtEo4Ecpm7W/3h71XgTsmY3QsSTv52ALpnUXJrp1hRyT77cbCm
	 WTroPpXnJ8hOtXzjc+2h28A/tKkRBoAHvUFuCN4OG93bBUW60ZdIDNJl4qOHLMC1jr
	 Ovkv3V2X/smKdX2az6BfB8wGehxAjJ+0IYp3U67aDQLECu7yWi0YeBigMV7vpVd61L
	 0G46X6IhY3p0MCZ4tIyD0LJ2cio7NBkmuwF69s8dFbsGjrBLPhkFlGO9GGEl6sWqv9
	 lhHikh87ipVIQ==
Message-ID: <sashiko-outbox-209102@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 17/24] RDMA/mlx5: Ignore completion events
 for a kernel CQ that is not ready
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110134320.34408-18-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-18-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:46:54 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> A kernel CQ can be reached from the completion interrupt before it is
> set up: __ib_alloc_cq() sets its poll context and handler only after
> ops.create_cq(), and devr->c0 has no handler, as it is never armed.
>=20
> A trusted NIC raises no event for a CQ that is not armed, but a hostile
> NIC in adversarial mode can. For devr->c0 that ends in a NULL call. For
> a CQ from __ib_alloc_cq(), on a weakly ordered CPU, the interrupt can
> see the handler but not the poll context, and crash in irq_poll.
>=20
> In adversarial mode, give kernel CQs their own event callback, which
> ignores events until the first arm, the point where the core has
> finished setting up the CQ. mlx5_ib_arm_cq() marks the CQ ready with a
> release before the doorbell, and the callback checks it with an
> acquire.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110134320.3440=
8-1-yishaih@nvidia.com?part=3D17

