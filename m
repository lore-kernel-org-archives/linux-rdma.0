Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794835572;
	b=zI3+wN5lBvWwSUbkPKcgr2tJLZv5g/VvvFbTw5o9RKbf7FMEcTrN9afjBQRuw1Kozr6g
	 78ynwI2hP0pmcRauiQVIERyvRad6CVMpV/qnfa0Cv2Xh5NWaLhsexyZ8sahv2+AMHSPtB
	 TedtQIjw/09xEkDzY7+WiOURXU3N9iQY5OGGCCTK00LKaVHX4QZaQj5whcf9Tz7xpQn7d
	 m8k8Za6hwogUmR5Irh+3+LFhyKUaZKducl8C586iGRzdvS4Rx69695JctPtK3a+RJyCal
	 xfy1XtA/TOEynOeL1kSzDsDyJ2nlmxgvzIqYdfMzhpub1M9bTdU4jFUoBI2WvSFz+1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794835572;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=YZWcoCKE9FqOUTqzMPHcZGiqg15Flmhu3ai2aXaF7LA=;
	b=PYDus2aaFC8iIChuyiVVKw8CBgtGDK/35poxs/+ouWCDmt01Y6cxkE34qxwGF+eWmNgP
	 bX14vN6pnvov/s/qLQUNAh7EIOJjdGw2rk8N+rQuJTkkNt6/lTchHWc6FaxC2lVpLqDsv
	 oJAaA1VfEMBZ/FiWVr7p7+WgSzxsW3dT09CGy5+YLJ/L1PfMU+uJgBDchmUfwUHFshqI5
	 G4/5D9IWFUAFRPnSelQqH5oOQ+TadzY8ufPjNiIbVocDiz1fGZNiTrtc0LSpfzkktOLI/
	 f8sKrpANpcSEq3L0D5Mob6ENJDF18IpK02OT2S2AFGIbOgpRWZwzBmOQASWng1/LMoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lo5SyyOy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C26606A323
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 13:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lo5SyyOy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278FB1F000C4;
	Mon, 16 Nov 2026 13:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794835572;
	bh=YZWcoCKE9FqOUTqzMPHcZGiqg15Flmhu3ai2aXaF7LA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lo5SyyOybZBqYcz7jfv0P4wKewxUZVE2EgGpM6OdA5z6R5gE5frncaPIrtEh0dpj2
	 w4gqZpqdTOi8BX+DGYTfDPw1jrNI8eZ5Lk8bHIuckgpDxyr2TzSuvJ9rPAVEH3H7Rl
	 rafNCV55sKNPIOza7y7Kv9f/cU67/PzQUPkqd3lNZIUjD9kzKqdz+Mt+RJUpipBy6Z
	 wcpVJlXYXruGHroHCm1LGWget70RVCmoapQCqfXCceAa1QKz1oljD4Kz/3lleWfTk6
	 /OALFi2aZnJwn+npwRrLC2nOaElUufIBzicbuqwbumJo/kEcHQbXv5tEOPXqNUp0UY
	 UEIR/Uxf7i2vg==
Message-ID: <sashiko-outbox-217071@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/hfi1: free CPU to SDMA map nodes after an RCU
 grace period
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ziheng Wei" <zihengw03@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261116130940.1629295-1-zihengw03@163.com>
References: <20261116130940.1629295-1-zihengw03@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 13:26:11 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> sdma_select_user_engine() looks up the per-CPU sdma_rht_node in
> dd->sdma_rht under rcu_read_lock() and reads rht_node->map[vl],
> map->mask and map->sde[].  sdma_set_cpu_to_sde_map(), called when the
> cpu_list sysfs attribute of an SDMA engine is written, removes a node
> whose maps have become empty with rhashtable_remove_fast() and then
> kfree()s the maps and the node right away.  There is no RCU grace
> period between the removal and the free, so a user SDMA submission on
> that CPU can read the node and the map after they have been freed.  If
> the memory has been reused, the map pointer and the engine pointer read
> from it are arbitrary, and the caller goes on to use that engine.
>=20
> Writing cpu_list requires CAP_SYS_ADMIN.  The reader is reachable by any
> user that can open /dev/hfi1_N, when the task submitting user SDMA
> requests is pinned to a single CPU.  So this needs an administrator to
> change the SDMA engine CPU lists while jobs are running.
> [ ... ]
>=20
> Fixes: 0cb2aa690c7e ("IB/hfi1: Add sysfs interface for affinity setup")
> Fixes: af3674d62d34 ("IB/hfi1: Add new debugfs sdma_cpu_list file")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ziheng Wei <zihengw03@163.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116130940.1629=
295-1-zihengw03@163.com?part=3D1

