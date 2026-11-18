Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795003020;
	b=dyx69Hd81vrGhcDapHIuPFREeghkoWfTItAhnh+xK8q1eTbXewA50qsYsvVIk9k5y9yH
	 zhvmdx+xnj14cSQYDXhuiY8GDBVDa8gS2ZGzxymdvAkDvNeqOWEEqlxHpuQvhvzEaTmKC
	 rzn5TsG/g3b+TZFmkfv3TfylHX9r/t6KXrHWoQdNCfMrdmrUgdN/8FRv9SP4lB0+Jat1W
	 WayZnxPoDxvv+75ZQPs0sMeIkFuZBg+bjnG71RfS9Lp+wCccTp7aToj9bH5CbGsxds+bF
	 oQsQRW76HfcXWHhCeuE15f1uoqeU1zrYv5pVDi97fJw+GlMAnkt6rF9qriB75HyQKGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795003020;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=HA+RqLsG+fHr+H7pvBm1TLlQo7Wa0pDMu0qiPERUndk=;
	b=PzxlC1i2RXlofvzOL5DoMncX0kFYTUIgJ1DB59THAYkO6t18Rg5CYE5XL2MxNgyEzD0U
	 dR7o9fhYS84djlx7ejZRxkw+hK+n2Sa/C14f26AVfQn+0JKwOM41t+1lhA8c8g6/ZfGPr
	 Tz9xX0nIbXKJS9Tscg8hHnjKmyk9A/WHpr7md271d4FXkFSrrxyICTrdvhi9PrTROChLF
	 pNYxqiBIZaAzGuz39DmBnsBPHtuJuwK08hjw/KG12vY5FrrBzqI7+DBSH/44I3FdeS5TS
	 W9evU1XBdRGAlwYKoNa90FmHvmTm2sQnInyL3svOobtGfjc0FBXTiHhTYkUbpz8EEoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="e/byQGsi";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8FF606A31C;
	Wed, 18 Nov 2026 11:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e/byQGsi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDE81F000C4;
	Wed, 18 Nov 2026 11:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795003020;
	bh=HA+RqLsG+fHr+H7pvBm1TLlQo7Wa0pDMu0qiPERUndk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e/byQGsicpfKqCjmLkEcTqhza5lmcpQNEGw1wPngpikl2Dw/vvXsPc2NdjKVicPZZ
	 wQ1GVsZQ9okThBhXebSGnzdrG45WzCUPMq2yR920OXoBu0+a6qiz1BOfvam+X2f+6B
	 F/5mySQb0mufqRTmH5ATF4E6hs/w5aVIH3tfVqS7xxXBEweS317zyXNxHQtXD09CR0
	 xwtDjEQRpY1p1zPI4OcZx2Ctz+2p6SlV96HEr2QrK5cs94AvoUlujng+wGg+H2hozI
	 swWL/b3VJgBfjcCLjbJPPDv+fvkieKp4tJkvO11+QuIUgFLohavSwjM9+m53/t6j/s
	 Hy76FmBGdU6dQ==
Message-ID: <sashiko-outbox-220865@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/2] treewide: Use struct_offset()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bence Csokas" <bence.csokas@arm.com>
Cc: linux-rdma@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <20261118-offsetof-v4-2-95b385c10b22@arm.com>
References: <20261118-offsetof-v4-0-95b385c10b22@arm.com>
 <20261118-offsetof-v4-2-95b385c10b22@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 11:56:59 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Generated with a simple Coccinelle patch found in
> scripts/coccinelle/api/struct_offsetof.cocci
>=20
> Signed-off-by: Bence Csokas <bence.csokas@arm.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118-offsetof-v=
4-0-95b385c10b22@arm.com?part=3D2

