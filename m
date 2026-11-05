Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793873891;
	b=ZLbY7l2wyR+pswEJTuI68Vnls3zRDCWs0yKTnncHS3Otb1uvCWirtxuW7GfhRwEZYqYE
	 RunfnuFVOTHP62O8j+lvtabMcIINvh3/RCwm8Hdfd48FkLPJo+9fRHwh45BVjc4ucPULr
	 F8atsyr9yDP5a8AhJV10dBPL0xbKT2aAnfw3q7XSC6QTONvRAMKkLYPZVMMTd5OyCr3TX
	 zWKhSq3GehuXHqsgqWhid35ShRRfa9CUcH/Xadw+wwiTNxc9gG8ZUiCT9tws4lcSOdWQY
	 u5C42SA1pPhj9B3Giawfy/fh/FuKubQ5FEEylN80BDB8vfNsIoyZdKxPPBW1VJJHnOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873891;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=fNoQZtidaZo6zhv3wiVhqd0/wWG08cP0lxi0A62ZmmA=;
	b=ywzmq2a7SzpOqVH1svPrr7HxKhne3y+cpiaGb3r5XpZHgZkyu2zpKEdzzGyUg48P0+K4
	 qyswTw22gI+ah2CKQ5ytVnwNXCdNG1tNZLc/0T9pbJmdnwNIhvtWUf3OnbJcgU8gBS9Eg
	 D967AcQiWgt5GXEuhSR+hQtAPqwZgT0efplsXIowok435dCyhbDoWcf3ElrKLg74Wnfwk
	 LsN4Q39Uv2xmqrqEGs0B55q0R5GjEy/SaQ0pGA7QGFnBjZvTR7LBSFbOHigBYJeWRq5sG
	 RTm8kszP3xyJ8SgS0dt1qby7mpqhX0Mj52mhKVl+tpvVOzz/f33OypTZlxl0Ax3twZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Xbwt4e/s";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE14606A326;
	Thu,  5 Nov 2026 10:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xbwt4e/s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC5E1F00919;
	Thu,  5 Nov 2026 10:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873891;
	bh=fNoQZtidaZo6zhv3wiVhqd0/wWG08cP0lxi0A62ZmmA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Xbwt4e/sk5wfAFG8RufsuD9M1LhHyvHlI1OVKW8Qh7d72n6e6PaHvxsbQe67YNkTW
	 /6d6GQ8guetSlgE4/DVGE2IklVICBiPlAbJh/TTEbjLL6vxMYGHwrRVX16SaExGsuC
	 u8k71xaXtSsnb3FGjhVYdiXGvGXf6bKTBlwXmfCjPb6MhADh0lu5Hvn7V52SDrzAFr
	 ZI5KWDE25e77XFJsv06cHDbxJglYmatHyi7/vJSZsqmHbdGoU4nRMNV4jjr3avjP2a
	 ecwM5nAC700SxGdgsytr00VnhZugYDJFZazKqcPZm7sACF3hgGS4d0j1AFd+Dce4Zt
	 r7Vu89gYLBZfg==
Message-ID: <sashiko-outbox-198836@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 10/19] PCI/P2PDMA: Reject Translated Requests
 blocked by Translation Blocking
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-fix-p2p-acs-v4-0-v13-10-3dd065907c3b@nvidia.com>
References: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>
 <20261105-fix-p2p-acs-v4-0-v13-10-3dd065907c3b@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 10:18:10 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> ACS Translation Blocking rejects upstream Memory Requests with a Translat=
ed
> address before peer-routing controls apply. Ignoring it can report routes
> that reject the Requester's address type. Intel SPT PCH Root Ports store
> ACS Control at a nonstandard dword offset, so a standard word read also
> misses Translation Blocking.
>=20
> Scan every port traversed by each route and reject blocked Translated
> classes without host-bridge fallback. Read the Intel control dword through
> a device-specific accessor, preserving rejection of unreadable controls.
> Direct routes remain usable when only ports above the divergence block
> Translated Requests.
>=20
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-fix-p2p-ac=
s-v4-0-v13-0-3dd065907c3b@nvidia.com?part=3D10

