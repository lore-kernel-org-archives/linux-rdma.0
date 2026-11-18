Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794994278;
	b=t1fTw3+ovnMVXryWrG1cRoT2VrOpydcHam6zNgjxC62L34urDqZ1QvNwuwQd0bkv6fNB
	 JySR6qzt3ME5Pw3RFEwB3lqq4gSY5JyrCC4uN0H9Dl3aLK6cFcsS9MOrh/XHJjtE9xYRP
	 aNWRpu3DZ2pynNl0gyfEgB/UyitM04eEWDrSTzh/uA876xCxYoLOObA+YIGnctxt1V3Ng
	 Sge5d8kEXO1ykQMskMQpfRY91IuIW9EXJ2cZ1OaM3f4u1qr78Py/AuilSDLRTMFTJYC6L
	 Reumii8EXRKSC019ci69H7D5i4Nv9ksY5rSYARpzuyyDFUsDQY9VrqmR1q0utD4eUVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794994278;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wGxYELy3LEaSN1oEBT+S8WdpPfzyTw5b2IxHceXN3T4=;
	b=zf+jKbnKRtzd6oKZIYuq8SKz2p5MdJmFJAVjOAES79WlcYC5D0LJCMInYQjepOBIq65B
	 lMDbA/hReFs8zH8KUDoG3vPa8c1nptGeS5bcE2I/G/vd1cwTCVt/DVh4T111GM04K+LlB
	 1xCcXa0HAjEV9o4B824oIXtt5zWa/F0ceW/2h84gIbCDMwXdk+CcnSUX7Xcr84gJp7gz1
	 ncr4tEvMFRdStWFETIAoTe5H6NVVtcL9TjC6Ty+Z52UBdsZ5wQwrvV2NHH4uo3Ce7ANje
	 Na8lwd2+jWo9K/rQ53omG2BKcbSe2mWHOoPf+xkWqBEcAA5Y228+O1TYfG0bRrwyCZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YjL1hMBt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB68606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 09:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YjL1hMBt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC991F000C6;
	Wed, 18 Nov 2026 09:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794994278;
	bh=wGxYELy3LEaSN1oEBT+S8WdpPfzyTw5b2IxHceXN3T4=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=YjL1hMBtqeV4XXY0rgVfkVkYR2V7Uh7k207t0g6T4E6Plf5mynXB2ZK6u/kfYGEoE
	 6hWdTacqO2SHe/gLFIgsxWT/52UsYGKPHzrDAPtJlvYKncvu+bErtbELHtwd7xVhMT
	 yOrPoa5cpwgXMxruHy8uc8A8u/ziBpguaLY5XvsS8m07hbPq2on/hSiA5ElFU4vRVe
	 MSPC3GJTxB0Lbssy8/UrtS0mWyXQYIbxhtE3ZIp992x3+/QAGrN4e6s1/a/L9eYpXg
	 qIHOmIOTAE9x5pZEUEsuwGgtN+Zh32E4/UMBY6iNz+A+g067WP5S15fw6HQN9m4odt
	 MlHxUJy8VZP2g==
Message-ID: <sashiko-outbox-220575@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v4] net: mana: Avoid waiting on dead HWC after
 device reset
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sahil Chandna" <sahilchandna@linux.microsoft.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261118091436.3985155-1-sahilchandna@linux.microsoft.com>
References: <20261118091436.3985155-1-sahilchandna@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 09:31:17 +0000
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
> Fixes: a7dfeda6fdec ("net: mana: Fix MANA VF unload when hardware is unre=
sponsive")
> Cc: stable@vger.kernel.org
> Co-developed-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
> Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
> Signed-off-by: Sahil Chandna <sahilchandna@linux.microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118091436.3985=
155-1-sahilchandna@linux.microsoft.com?part=3D1

