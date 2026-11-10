Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794311412;
	b=0RIksrQ+DxPXtepDQEseEbTC7U1N09BVzmbUDtXEiyLU9wLjty6NWAnpo4CqnTloQbR8
	 2Ru3SFnoWPPXkFOYQLzR40Jqvkb/8HnxNTq2D+8v5FbvPjvSPm1zR3eEJlJTz/DmxeLRS
	 0cxxDeRhUXkCCmcf8HH1iFgSsFuLCOFR7En958QTpTkq/i2lCLzIGrHnE44VEFeVnjRTY
	 vmrIeIo26wgBqHX5JDAooi6gkYJcdsOAYKp770a0FhW0tD2bQ6UTzQipZ0CiLGgTyRaVb
	 R+oSc0kK+7FnzBLwsje3sS6+u+Ab5f7TjIUPPQcsuC6xXPtVa8ws5dWHQEtChPAktcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794311412;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3UmsQMPSULmn7BylvIK38MEmdd2Yoe9umeF3AiCvo1U=;
	b=EoLrTEXqkEX18myxsRnSx4gO6ujeTi6HUB5IT7VexwwcgD50RNFH0/jXlRpKibr8vxJd
	 LJ8BAfJhypxessNhPgSZdz/P+zxKXQ1WT8xJBbM0OzOoSQNKA36LSM0jDwNCZ7YE0gtI3
	 Z5JaEDt7YIbDKkyENc65ozV24YZioR/KahXV7vUW7I8w+Cmml1jEfJsRnR2TogoQRlNtu
	 u8EPFD1Ga7CdpZhPNs0tJWC3mnPAHc0w9/hesTfZZc+8UOqJRG1zeBT1r5Kr1yP3ZtJ+a
	 aKlOIuQhcRa/D00/nQqPaOjODNwafQ5RS5cbVwDa/Ffajo/Xm4N2pS6bUx1cJlRx+nA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AKwpHbCS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98441606A9B2
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 11:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AKwpHbCS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510611F008A1;
	Tue, 10 Nov 2026 11:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794311411;
	bh=3UmsQMPSULmn7BylvIK38MEmdd2Yoe9umeF3AiCvo1U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AKwpHbCSz1PYhqJ2F/e4AlLmz+TOWXSUzt4S935pExSRpk4v8hbCdYxyujWITYKj+
	 B3H6/GyQcWJks+LgL1EDW2/1fFwXOHKkbZi83Cgo1/KKUrlDHcsF6Jwb5HDRulNiX1
	 S7F9UBqaIl/V5zyVQXBYkDWxY5lt7PEXH21NAnIZdQ35p2xRPr4OEjXu8ZcWyBJ+UL
	 gQN9l8cxZGsfU0rLHanBuLiqVmo43Bv2QI0gP5sd8uYki0hXjFo7X1H6NVAh2h7V+1
	 fye39bDjX/luHXS3DfdLuU7zROWqpbCEweX3ZiTzFvQ9PzYvwlHcl8FOIGJqT2gCUe
	 bkFVHt/LmV4Tw==
Message-ID: <sashiko-outbox-206954@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC net-next 2/7] net/mlx5e: kTLS, Resync TX fully after its
 WQEs were lost
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109114734.2087878-3-tariqt@nvidia.com>
References: <20261109114734.2087878-1-tariqt@nvidia.com>
 <20261109114734.2087878-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 11:50:10 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The driver tracks the TIS state of a kTLS TX connection in software:
> expected_seq is the TCP sequence that the TIS expects next, and
> crypto_info.rec_seq is the record sequence of the last posted static
> params. It assumes that the WQEs it posts for an skb execute, which does
> not always hold:
> - The skb is dropped after its kTLS WQEs were posted, or after
>   expected_seq was advanced past its data: a failed resync, or a DMA
>   mapping error of its SEND.
> - An SQ error flushes the pending WQEs.
> - Closing an SQ (channels reopen, TX timeout recovery, HTB leaf delete)
>   destroys its pending WQEs.
>=20
> The TIS state is then off from the software state, and the next skb is
> not resynced:
> - An in-order skb is encrypted with a stale record state, corrupting the
> [ ... ]
>=20
> Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
> Reported-by: Rishikesh Jethwani <rjethwani@everpuredata.com>
> Closes: https://lore.kernel.org/netdev/CAKaoeS1hj9XuM7ojLBCjGA=3DEXc2M-b+=
eRjC2Sk=3D8L_8XYeJ18w@mail.gmail.com/
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109114734.2087=
878-1-tariqt@nvidia.com?part=3D2

