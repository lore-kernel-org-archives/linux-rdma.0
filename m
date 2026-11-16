Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794827552;
	b=Brjs6e4uLl1WW1Bxnv4BQRQektBRH9FyjHN716TP/XciLMcxy4cPQ8PeL0ZR1rKG+7f1
	 7+tviLfDtPqOQuTu7GPsdMxgkvonQOZ58ZdFFTZfCjNmLt/L8c3PsqWMRMeSa6FT3Gz5D
	 gpcML5VRZNHlUWJTs4n0QbWvwmL61ijTZ1wPS6wxlWirve27G2BHldLqUbX3EWqkS3Aw6
	 g4E4AHy+U+thEOK+wcETGSpjz2P8wBcYDHHcpPr7c4qRrmE+WVDfB/zh3Q5hlz5+Y/nln
	 WVRG9VyGlEHYmeiBuKczWsPCJlff00yiVfknXoDi4ASI6ML0I+hxYeVbQvEdLlKq+6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794827552;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=idUIUQPfDPvBUKiISQeHhn80wLFebQ4zudbmQ7xyxy4=;
	b=AqGVjs3CscBeg7ve/99wDOjJ05zfNRydR3MSeqOOjkU4jwvP5aNxCaH/kdFUDUfzBmYl
	 jZW2516zQTWFpmIQto7/aDLxrdJ4MAnDuSmtmrd0/oWaBMx4HvdbIgcEzVJkeUlEPbchP
	 mLzRPcWQNPIZwHO95niaJssLu8rgEh5lkYI/xX0zYk4IlhcxdWkJgmv1hn7fcL+8gQAHI
	 iQYIRcscQ5LxB02c9zOH0ySfZ7HAdtjgjrW7Yj8cLNayyvnpyBpVfC/laHXWgfzngYwRp
	 B1OimDCjeOcsRB5DVP8EJNW3WrXLZOGPgknrG3qwcCIrqxL+lUdDnq+KqgoQraOcgMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="clneI2h/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB8F606A88A
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 11:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=clneI2h/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734C61F000C5;
	Mon, 16 Nov 2026 11:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827552;
	bh=idUIUQPfDPvBUKiISQeHhn80wLFebQ4zudbmQ7xyxy4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=clneI2h/ipi6oytHmKO4Ni1PWdur/IRM3WI7rhrCtzzazR9NyabpYh3hJbNjY6ebo
	 U8CbrOchaFH9ldrqLWLEAIAFcROJrX7MMwULIFzxD6ez7ihtvqOm+UeFmo09sOjCgh
	 6fFukW+Sqzd7ON72AoQjQWZiv1qEwANcRiXi9vUYZPfpzBbEoVQ7tsu4Mw6PUNx8Ss
	 Qa18IVarXL3k0QRBAwGZC8YqoG2JM0B/+YAkxmkCeLAhtXkY/+Cgf8eN3ypBq2QRE1
	 L52Q+hb/NEVLxN1Oz3iev123XS7XSW1vVm/rDgGS11MQPf+YqJtNrrFO/SNB5P+srh
	 lvxLJDEtk6Byg==
Message-ID: <sashiko-outbox-216858@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next] net/mlx5e: kTLS, Simplify error unwind in
 mlx5e_ktls_set_feature_rx()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xuanqiang Luo" <xuanqiang.luo@linux.dev>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261116110830.2850785-1-xuanqiang.luo@linux.dev>
References: <20261116110830.2850785-1-xuanqiang.luo@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 11:12:32 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
>=20
> mlx5e_ktls_set_feature_rx() has become harder to follow: the error
> handling is nested in the conditions and the main flow is conditional.
>=20
> Handle the error cases in conditionals, keep the main flow
> unconditional, and destroy the accel TCP flow tables in a single
> place. Use goto to unlock on the early return.
>=20
> No functional change intended.
>=20
> Suggested-by: Simon Horman <horms@kernel.org>
> Link: https://lore.kernel.org/all/20261029134019.GG257209@horms.kernel.or=
g/
> Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116110830.2850=
785-1-xuanqiang.luo@linux.dev?part=3D1

