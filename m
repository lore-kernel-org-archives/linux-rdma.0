Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02B84908A6;
	Wed, 14 Oct 2026 20:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792008786; cv=none; b=GVO6pArL0bVNMgGUO8QE2Be4cWGXhEbwQd5cG1MlS9qjAI93gdO/BXTEGnf3bNFkiE/+vADpotQ78R1dWHK7EOi5Dykg0ukM01SapWn5nhM5l1Ekf/KkV/G7eqg2Y+U0q7NNVq+2E6mPeZzAImF8C5ai0Quw9b+I0BqGpkIisow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792008786; c=relaxed/simple;
	bh=974tGcdGJsi6VCBzoIR0aGYWTuX+fNq3qu8r7uKeAT4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=cnGPald5hRKhJhGeOUnpXZICd/14go2ry4DLrGDy6gixF5wrJnAunkL0lC+1LbGj373zk8TIRcXL4PfupgJJqCIby2gjYZ5ueydGocGJt2uxTO1uAKJ1E8mGa3D3BEwOo4cIJDEC3+jauwXjHpdHc+dG6GenWoOh59rZMdXf4iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KW0CpYS2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KW0CpYS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860ED1F000C6;
	Wed, 14 Oct 2026 20:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792008775;
	bh=974tGcdGJsi6VCBzoIR0aGYWTuX+fNq3qu8r7uKeAT4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KW0CpYS2yLZNeM+kSjVz7AWREm/v1M5Y734Bbc5M0cZeT+JceN+A3zGoM19TZ5P3z
	 veHIoUDsKM1Nx9tPQ8IOBzAjEzYcfrUubTU+K+nHEcgFzqHt/BRLzEsVPgR3UFL0xh
	 yuB75+knC2T20M83bA38hU57gtNajoIMvqy3hmF1Chkye4DWZPUunElTy7lfeLRSXk
	 evyF9UEID8nMY3yjcl2YCJ/D6CxtJhTSmDreN2cSQzdbMsg0+dn3g947faxU80quMx
	 C381viL91x8HjM9oA5yOjIBcMz76kZuP9e/pciNSlxpjDAG38kDCikVSIpmROtQPjn
	 IbU6WlilHXDpg==
Message-ID: <sashiko-outbox-171845@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v7 4/4] net/smc: bound the link failover cursor
 advance to the send buffer
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-disp-f345196c-v7-4-ef3dddfbfa68@proton.me>
References: <20261013-b4-disp-f345196c-v7-0-ef3dddfbfa68@proton.me>
 <20261013-b4-disp-f345196c-v7-4-ef3dddfbfa68@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 20:12:55 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Bryam Vargas <hexlabsecurity@proton.me>
>=20
> On SMC-R link failover, smc_switch_cursor() rewinds the send and
> producer cursors to their values at the last completed CDC send, then
> advances them by however far the peer's consumer cursor is ahead. That
> cursor comes from the wire, so a forged one adds an arbitrary amount to
> sndbuf_space and to the cursors. smc_curs_add() wraps them only once, so
> the next RDMA write can take its source past the send buffer and its
> destination past the peer's RMB.
>=20
> A conforming peer keeps its cursor count inside its RMB and cannot
> consume past the data in the send buffer. Advance only for such a count,
> and no further than tx_curs_prep. The pre-failover tx_curs_sent cannot
> be the bound: an earlier failover may have rewound it below the peer's
> cursor.
>=20
> Fixes: c6f02ebeea3a ("net/smc: switch connections to alternate link")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-disp-f3=
45196c-v7-0-ef3dddfbfa68@proton.me?part=3D4

