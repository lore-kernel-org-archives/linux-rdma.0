Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795686285;
	b=FoDL/vErN3grMcTRTPVUbJCtliFDSBruh9dd/Kp5DQkQxjxaz6vLBAYjGifi2j7QXL0w
	 mmzTduj/WWsOoDITYPXhFlkZ5mtfJ+sQ5NG8sR+HURbCKIEpm5m0Gbqy6AXeqkF0VRNeH
	 vTMj6Y/U1zTSA5ozs2pPIychlzjJUB3/H0rN4e4dgzSMhWWMD1B4aXdu5XKhnhD9IQOx8
	 lUIoxmx8LXDecycIjfwqA2NsJ3aB4jbQWWgjE2J6fNyKv+ncNJZgsnJSc/4/amq/Zn2qA
	 IKg2u7/vQJh4+QUt0SYMfUiYRZrKSEQuIl3OTBY6qEhn6P9lQCuay5vzMRAFwkIowxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795686285;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ol0OlyUUyORXatfiQdLP3mpVPwTL7qSIByRCAak00To=;
	b=LIYJEdD5Ml9vZxQi9VEHnqged4Cn0mmgkJXRtb490B3Bo9o7pJpP7I/TkIOxEmbQSpQA
	 tL2A2A1fVhkARxErXLJjJ65N5hZQ72u5uM0CzvE2TZV5Urm5Mpnw0iB2KcZN+ZqeCZvnD
	 YhmzR7bdz+9MX+86ARt0tFrmaAcACoFJQBZY7uC/sO7DgIb82hHRfv1C3NSP+YN9AHAgO
	 392SpRPQzjbIUh6SX7mDNR/JuxAfTlr1l/qTCD0Dj05r3VWa5soHmiBiSBFOCckhfFY82
	 xAkpwdYYdBGef6Q/IBDAW9BWy+zUSbeTboy6tI2xh74bRimzcS1LMrXh8Yor3zcRUFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iJ+neX65;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06090606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 09:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iJ+neX65
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9971F000C0;
	Thu, 26 Nov 2026 09:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795686284;
	bh=ol0OlyUUyORXatfiQdLP3mpVPwTL7qSIByRCAak00To=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=iJ+neX65S4TJ024162W+0xG+UJq3+mvDPcmSLb+cdyqjTbVGjk7q/j13iR9nC/riS
	 EI27hxuPdeGKt+IyOSvMDVbGvf2U+CeJpEPSJpz8G8nE5HL9VEnXsubT27Df7KDZ4w
	 XLQAv7F7a9iJSFFBG4mkg7GOP5jw9cjALLuswaFgZtB2PkGRJYSIm6Y/h13JTA4Gnx
	 BVcagP571gC1sEYv+Qr9yOZB01AptO4TmDagXQ4AUOgXBaco5VcAkT+m8nPAoLWhyP
	 ioDNpMVQcgDXVJocSix8shhxR3BzbHY0oKolrPGMJAdmZXSxBBRI9cTNWwSqGw9PuT
	 V/KH3dVQFaLqg==
Message-ID: <sashiko-outbox-235169@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v5] net: mana: Avoid waiting on dead HWC after
 device reset
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sahil Chandna" <sahilchandna@linux.microsoft.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261126093032.816436-1-sahilchandna@linux.microsoft.com>
References: <20261126093032.816436-1-sahilchandna@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 09:44:43 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> After device reset is issued due to TX drain timeout in
> mana_dealloc_queues(), hardware channel (HWC) state is non-functional.
> However, the driver continues to issue HWC commands (mana_disable_vport_r=
x,
> mana_fence_rqs, mana_destroy_wq_obj) which will each wait for a
> completion that never arrives.
>=20
> The first such command (MANA_CONFIG_VPORT_RX) blocks for the full
> hwc_timeout (60s as set by the firmware on the tested system), after
> which the timeout is reduced to 1 ms for subsequent commands. This
> causes the calling thread to hold the RTNL lock for over 180 seconds
> (120s TX drain + 60s HWC timeout), triggering hung task warnings and
> blocking all other networking operations on the system.
>=20
> Fix this by:
> 1. Replacing the sleep-based TX drain with a CQE polling approach:
> [ ... ]
> Cc: stable@vger.kernel.org
> Co-developed-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
> Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Sahil Chandna <sahilchandna@linux.microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126093032.8164=
36-1-sahilchandna@linux.microsoft.com?part=3D1
