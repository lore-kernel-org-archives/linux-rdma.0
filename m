Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B764BA9E1;
	Thu, 24 Sep 2026 17:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271792; cv=none; b=gJr18eMCCBgMbHCE4T5NQ2sUUOgF1MfSLSWnUN1nUt4HkDN1/IjSEWSIvOMlVOwOOjkUHBi7aEs4GKQmR+0Im/8lYxvCWEDt7GUK7NC2AQZf/2FjyGUpiiKRu7VKozLV5RjLOgt2TZx+1FXRF422TlZy8ubDivrcDIuwCKjPNBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271792; c=relaxed/simple;
	bh=2jYuhORGqEKfpmNTGSiG7cDhUi5iV/dZ/xO4JA96Rzw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sZSyRhau3uQre0PIZEEOBFCigNN9B6h9fxQleTmDyHK4KGPcAhslmxQ2clNoej8gIuYZAFLwqmW8iOjYbuwXA7RKv7Mxz3g7dFpu9j/IAXjm+UhP7XWfGz4GasoGrrVpXn14M3gUoZfJQmBL/zdaw+SX0d9pa/nWkdDSfFJ6xrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M1YwZm40; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M1YwZm40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A531F00893;
	Thu, 24 Sep 2026 17:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790271791;
	bh=2jYuhORGqEKfpmNTGSiG7cDhUi5iV/dZ/xO4JA96Rzw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M1YwZm40TM4UynNDUO46Dyahngq8SIoqRawRU9x+1tL+o2vTn10dMNWbDPTeUlw0A
	 foccC3W4D9CV9Llx1QKt3kgAdMq2WjMSsCkJrsriYiYzBTaHGdZo4NM0sW+dAbGVkf
	 1gFWZDYQlRleWdgG5bdS/O9zaePwi1bGY4YvVjfGRECuWqCMVPO3Cq9Pe3ZribqA9C
	 QJqfzBljYvUaQbc6jM92r0o31QA7uTL1Z6htJluxBcBOobMO+xDhOrzIeNj/LDvbpK
	 5p+FDW3EDBlCTj6tukbCa+Rpy3hreYMiOngTy7RXq+qEFxBFeedShyJ8aIntwhgHb3
	 etb25n7k+t/uA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 2/4] net: mana: Move PCI transport code into
 gdma_pci.c
Reply-To: sashiko-reviews@lists.linux.dev
To: "Manish Awasthi" <mawasthi@linux.microsoft.com>
Cc: bpf@vger.kernel.org, linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20260924173054.589291-3-mawasthi@linux.microsoft.com>
References: <20260924173054.589291-1-mawasthi@linux.microsoft.com>
 <20260924173054.589291-3-mawasthi@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 17:43:10 +0000
Message-Id: <20260924174310.D8A531F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Move PCI transport code and driver callbacks from gdma_main.c into
> gdma_pci.c. Keep shared IRQ bookkeeping in the core and update build
> wiring.
>=20
> Signed-off-by: Manish Awasthi <mawasthi@linux.microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924173054.5892=
91-1-mawasthi@linux.microsoft.com?part=3D2

