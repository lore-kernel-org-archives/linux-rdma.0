Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336051;
	b=ToRIJdYswFuJR/SU2H/gk0d9MfH9jaBAYr5pHLiZjsTExPYdXXp8tcH1kUA3WcEVjKTQ
	 VpKbN55S5fjhuP6UQb+1htsJ06hLk5trIBQgpyZSdFn9q0Tk60+iEkCH6/z5Ac+6FlODL
	 CwxrDBwLCbg8s/eGsonpXJk1V9PqHrASikostDKaSuOuhJoyidgoN0u3OCP499xMHjJHw
	 IXHhn3slkAH83g48zf3vbFCy20cNtc4SHHW624OuJZutaOuBXU/vYejguuwDpNyfXd95s
	 dKSzqZqM3WAbRQPPqDoosKWgsfemq3WVGJMiMLGe4tN/Yyb6TZfNw/6WoCUJr2p4cug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336051;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=rGrOdYrIsWv32lHhJIBvoeBT9rRYp06RYYu8yHY0aAM=;
	b=Pvl+eJdmv6+HOqUbs14kXIKF0VzNpYMtHJTtgoF1epx5bdBvDla8caCcjldgIFpd1aH8
	 5TbMftzN2E55C0wLwuFTCJVpaekFPsIASim2WiF6aQdPaGjcU0qJ93AoXWClVl+odPBRx
	 UTb1UJybF0JIlIFqkbimhcH8Eamu+EEUJ2MxEzjSBNDhpSwy0Ne2IGV6m/7v+Ist1qA9V
	 pN0DGkfV+LjK5yG6aBsT7YNsm6HtKOpdwtY0tKE8fIJVCF2QeTaN2t5+K+NlNF+at9MYS
	 49bf27547yyF/VxpKU2ZiQ9FCtSsMF37ZyXh/sp9PXPR3nYm1OvppZfqCYUA3vh6QeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kg0VgOGR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08A2606A325
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kg0VgOGR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CBB01F000C1;
	Fri, 30 Oct 2026 04:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336050;
	bh=rGrOdYrIsWv32lHhJIBvoeBT9rRYp06RYYu8yHY0aAM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kg0VgOGRmEu4R6vEJk0qKaB74fxj1oiOv+i0jGaWLxoTO0/wg/1nNkkZ5NTkmgzvV
	 X47H/WxisV1dzWDLEWVyyX65/UDxp+EItFM0p5e6DdBCppFnCN/6/bBh4uGc4Zw+C/
	 uwPXhyZyFcBnnj1FRflilx5CtzO7xhRR2o0dWvMBsfKOYH9P3Qgf3DEpdfyDx10EuM
	 76EOub/Hbbg33hojIgrxsEKyNxkDnaT//S4WGSwOUqzpREWdNz3d1KdoTBgk9UC/ZV
	 XuS2z1YgYoT8GN55KuQeN1Ciqd3dygX73HIdFEH63KiP2puxgGndyDxs1ILMLC2WFz
	 gHSNyKaq+1xBg==
Message-ID: <sashiko-outbox-190415@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v8 4/6] net: mana: Use GIC functions to
 allocate global EQs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260508221202.15725-5-longli@microsoft.com>
References: <20260508221202.15725-5-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:54:09 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Replace the GDMA global interrupt setup code with the new GIC allocation
> and release functions for managing interrupt contexts.
>=20
> This changes the per-queue interrupt names in /proc/interrupts from
> mana_q0, mana_q1, ... to mana_msi1, mana_msi2, ... to reflect the
> MSI-X index rather than a zero-based queue number. The HWC interrupt
> name (mana_hwc) is unchanged.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260508221202.1572=
5-1-longli@microsoft.com?part=3D4

