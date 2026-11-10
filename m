Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794283832;
	b=5NY3BUxDZrS2YDGhcIz5EOq9XddOL56t08zhxemIU3i9vDhNaxdSmDXtI0x4fZ9m5USN
	 GLRURYPd1kg94L4rvrFMd3UZPL6ZXmoL9w8HyTJ3vVA9oMDbT7mNmsaeNT/NT54Fk9EQx
	 LvD6SvdW5Yz7G84U6EyYY6NZUGD2WdWXebe5Mo2f558xnB4WVo9PJGHk/RQg7nllnlcPc
	 sA2K85xuyKqEyugfuFeQPxkSkPkIwY3ZI6gXfCdNxHroaq6h2pdhqd4YwGzgacNTVU53S
	 4XiPr9Q2M/UX20URtrrTjQi5SbdxV1XoiQjutJ0d45cQhvwcQ6YLi4Cqf0RkngczX1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794283832;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=L2IGNMpxCdXFF/q5WNQ/g69eOa5vd1/rTbbZKn36arM=;
	b=hUC6ekRxAe0qvVaz6jMVKr33wvjpBMRKXcBGSWVTF081v/gUEhW5IwL3SX1wGtePCGN9
	 Kj7tsJf9Ke6XMRa/4CmsCPBPDe1pM1tlnTahDk2ai015b6WGvLB+b/uzbOH9NdfQSmmZl
	 LQDVwjt9p66r1pltjU5bzxO4C5ZiC0zpB0q2MglV2YLsYVeBPhiUwGRYnBG1G6POepNS2
	 VJNMYkjQgFZBUrTAWLIRpz2G7hZ4+RtWab2UC096XoajpJkz/cA7LWEf8qpy168rfcam0
	 9+txjmiPConQs+rZSOMTocxiTClAIe4l0afgzfGCjvUlbkjLh6DbJ1y/R4+yuB/gw3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="M/wl/PZK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE5C606A31C
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 04:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M/wl/PZK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17CEB1F008A4;
	Tue, 10 Nov 2026 04:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794283831;
	bh=L2IGNMpxCdXFF/q5WNQ/g69eOa5vd1/rTbbZKn36arM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M/wl/PZK4CLO3beNGrzbW/PxTT1bIu8EY/Z99BvR9f6e2lEsLy7L6tGQRCHd3xXRi
	 UojJoFBTL+FLEtpqMOY364xys2fLB/316/P7kWfjY+Ef0nXvZoQkz/xWl+D2cXRxS3
	 UVF1ORdalWVPvTRQp3A0wJr6Mc18dTCMwy6fbjoypap/yBPL+01rF5KH99T/2L72oV
	 nvB/kV+zSTH85kokW6VpZibGg52FGjkA4RT2ZacQAzjacwMYfRkk0mv8obOkn1CFy4
	 X/ynS+ROEstM4TwXTFdXbPktqIPGz10R0K55i/ePtOodUSzpDX8qcDrC1Ezw4xlG7U
	 qEAKIiGU3ZvUA==
Message-ID: <sashiko-outbox-206175@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 01/13] RDMA/core: widen the uverbs object
 key
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109-uet-ib-core-v3-1-3e7e7ffed2e9@broadcom.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
 <20261109-uet-ib-core-v3-1-3e7e7ffed2e9@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 04:10:30 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Eric Davis <eric.davis@broadcom.com>
>=20
> Three more core objects would leave drivers nine object keys, and mlx5
> alone uses ten. Add a bit to the object key.
>=20
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-uet-ib-cor=
e-v3-0-3e7e7ffed2e9@broadcom.com?part=3D1

