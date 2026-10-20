Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792484387;
	b=ZPrua7I0w0qcGxeHtgoWhKcWr1VcLj4rtY+JALtR0fe/VqnqRym7+UwntTDvHYMvapOr
	 0l1DqR/8Vw+qTKLN8kNvLtNnn25McAHP6L42FECOHkO316Lkm7d+MuN+UEWuMEBsRjaTw
	 37xW4wAZdgojn9Dc4qlqcn0QHTgQlHx63A80V4fU40E4n/x8YZl19XGNUgG99d1mSPQ0k
	 WGZXsJIqn1Vkn+br6QbV3IfSJUBmv4wL0iVh6xLdS8S7mR6d+TXhVVyZLnOc8IkGiLbpn
	 xrZV8nuc6DSU40E+uyhIa2b4pUYPmrq7W96ZsdLcGVum+sqUSghd5zyVqbIcvhbZ2FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792484387;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=V557Bp3ORxIr8GmF6VDHajWXFInIGiqaktiS59kVVeY=;
	b=oJKJ5+GcyicL2FdkQDS/OulTANF1e1SyOHU/aG/SgsD+lMy3/9a/cDadHIDyfSyKwo53
	 HqIgqNcYZ/KTboM4Ch4MJz4ZqCx3NtQXztJTleXbaG2TaLQB5/b15t/EoHYCu9eVeevE0
	 7hfBpLlxtnjBXmN6OEr0oO3ZXlBh1n7/Mw6nmxEoyYRDMiSmqxdnJbkMoTd/lJO2RZJlM
	 Ntu9f0rgOcqkIZ0HE1P5GsfMBUGx6ECtk2lzjiW3No6eZyuZdyG+GkYkfj1iY1HeyQSbH
	 hpIq7KOICkW9l8T2bzpZbQnys/IHI4M8SJSWWAnITMNk+3GcAfYdkgN3lmH29wZdMJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yrvwsn3O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172E0606A319
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 08:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yrvwsn3O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817CE1F000C4;
	Tue, 20 Oct 2026 08:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792484386;
	bh=V557Bp3ORxIr8GmF6VDHajWXFInIGiqaktiS59kVVeY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Yrvwsn3O6OvfPlv/3XlsxeRmAfMWR6Z1Ta5vAumrMUaTurZRcFjD32nsw/xl3VLU6
	 fGPOpldO+h37nG/xD+67tbSNVG3OK8TLp3JsJxUWpWuxnN9jk+Oeyy0fKHxvh0iuJA
	 LtrJoXdUiQwAlV9UkuYw4WPEVnTxmSXCo8MrOVXWUqlRO2Khgtc+CW1f84HHNvijje
	 ZalhOJBhCNVvSJdEmJf5GHolNKl3zzpKLM26hkY37L63kGlIE6AajFxI27/Rtr7Vom
	 cGUFVYcGWHdx2iKy4m4n4cZ7CYwV6GTqAU1tpgMTRaeYpYEhqBtYsvm5EeZTilzlNX
	 08mdSJ3lP1xDA==
Message-ID: <sashiko-outbox-178520@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 03/13] RDMA/core: report the reliable
 unconnected device capabilities
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261019-uet-ib-core-v2-3-8bd654f25370@broadcom.com>
References: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
 <20261019-uet-ib-core-v2-3-8bd654f25370@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 08:19:46 +0000
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
> Add the capability bits a device uses to advertise reliable unconnected
> support alongside additional features. The transport itself, 64-bit
> immediate data, 64-bit memory keys, caller-chosen keys, and the four
> memory region access restrictions.
>=20
> Report the job, job key, and address table limits through the extended
> query_device response so userspace can size against them.
>=20
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019-uet-ib-cor=
e-v2-0-8bd654f25370@broadcom.com?part=3D3

