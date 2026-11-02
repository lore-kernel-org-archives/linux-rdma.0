Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793637937;
	b=seHm7MSW+Virol28NU1f0y6yacuRbyCbKCxKVXj6wg5/bGPDpF28t9as9mwg9AcNe1of
	 yVHzF0Ds1nY5n9sUKdh9OxTd3JJ0wUuLYh0KbkzrArwgcU2NWbKAQR3yeP0W4Kva6V5uz
	 fU5FUEc1dhGP/9AcEv8VCyAAughgn9VEYw+BJc/SLl2Qk/HMXwacfwLRYIz/8WLI8brHn
	 GgFFceHwQKJxMvvdeMpZd/qR2V2IpGXwtYSoxmS2ejHTfyjEQYm0I35SsLHTSzMmeO8kI
	 XKYQbxEQiRnBidVmy01f55IXEZw6fo92Ens0elx2dJ5z6KNPpOeVYHowwqpZvOnixgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793637937;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=iQj0r9yfGZcSOsplqmqcMZeeWqiPMzPSMNByg301M80=;
	b=2z1b3SuNnjFh05nOXu4iYw8YolOMSoQjtMgOXoGvw7SrUjni8K+Fzcz9tBdJT9axo6uc
	 pR4r1BfsHlzos5loMQZWLtcV/9bPNEo5At+i29aR3671pgIln2LG7bD5lVyp+tSbJjuur
	 Jm0J/dsK6F+oBKOChSDr2DCuQRobiSoEFkGDV3KmtQvpwPC3yix9TBOhstdTjXjwADOHe
	 y5Lyb+Q1yt4532QSJ2//ZpYd9vQBk+v62l8h/6i7FNsf2cCylJPuewpGx3Fwy0cegPRlM
	 qd6GEAxl6LtiK2P4tKV4NUdbGzzRr5nOFPIqjBGxnN8Wyy3m7m7a4VUpU3dCViZ9gzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=egxXlFC+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6343606B1D1
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 16:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=egxXlFC+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FEFD1F00A16;
	Mon,  2 Nov 2026 16:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793637936;
	bh=iQj0r9yfGZcSOsplqmqcMZeeWqiPMzPSMNByg301M80=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=egxXlFC+0uuWmz5xvCf7eVzUtKt1X/bVk4wBB8mM4AL53YP7Z0KOKyDHgPdvR7PMD
	 WwUUlKm5yMaB8IB30reOodGf1YBkCXJcw98rEh8WU4JQU7JQm/u+KK7nYTh7tDIdJe
	 hjdpD/fiK0X9mgFxxwSl0EYxs/ZjDnZGlkHC3VUiafEBYUZi40ChSiQZ+abgVONowf
	 MmVD7pr+5eKAq0UVU6vj+EV4UzCSSSggeqGUKJnYsLERaPpsmXyrD9VeO0+a6KBSom
	 uOjzsNQWrQKDWiVeV+0kKR4SqU/jdJ420SqI2fiFoWL8XAki4c5ypanBM05dw4Sln4
	 qANtLQxJFjmEQ==
Message-ID: <sashiko-outbox-193769@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v7 8/9] RDMA/mana_ib: Flush and notify CQs
 when kernel QPs enter ERR
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261102162505.501853-9-kotaranov@linux.microsoft.com>
References: <20261102162505.501853-1-kotaranov@linux.microsoft.com>
 <20261102162505.501853-9-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 16:45:35 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Complete the RC software flush path by adding a kernel QP to the CQ
> error lists when it transitions to the ERR state.
>=20
> Invoke the CQ handlers after the transition to flush pending work
> requests.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102162505.5018=
53-1-kotaranov@linux.microsoft.com?part=3D8

