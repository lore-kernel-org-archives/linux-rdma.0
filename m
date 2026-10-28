Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793177720;
	b=d9V0k/lW3vzIEZdXFP6j1UC7NGgz4MH8nWgjeRL91HZLRXKj8vEs6IbQRW03jKhEtmGm
	 XgrTh2gkm9HnuOEVkAbyOPiPN9qfDAjebNR84QwHw8A8lw9sLKjuJtKdx2VqwDt/pOXzJ
	 AtNuXO4Hg05xs39rn1t+bVrRNr0LdaiUC8Dt7ED4QwvQajZnntEP8rxI8E+/udinbS8vD
	 Y6V5W9qiDxcZ3xEbjVYtJVvVo3TBeOPtwWP6/StvDTkQ9LL1rjXtyQsEts+qyAQ9cworm
	 fo2VLvP1Z969Mk4a7DNmIkDxeK7dtkjICn7LfSbmJhWjq+zRgRp3zgUxaE2G5oGZUMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793177720;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bPCDJWOaMpfH2ZvtM3CM8lmKR+EICRjsIjgr999n6cs=;
	b=mjwka6sMnBm773wW5rV6+vz2dnjuspPYR3IoYLHlNiBHpBFaVqfryWDCo3oVp9kk16rB
	 GWMo5q/nrrvziYZiDCH52ZG1IOx9ZjgfJ1gMDbjFAISNfIYc00SBu7c02ehIoTowpRVnt
	 HQx52rZKKBYRhIEwo27Cq+2ICN0kFKsYKMUeoffHvPcqXjh8JK4LUuK1J8lemufaMkqOq
	 3b2W7IuS6hF1NhzUizZ/P42CT+aw7imTiMjgHOmSzPj02560pCjn5C1uzzVh3JTYojsDA
	 i2q0mO7Mi85D/PnkysSWD46sfxajcvTuoTUj+BQUuD04yw32BEyk0uvk7U8rGZJssmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hvj1Ia5z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90848606A31D
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 08:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hvj1Ia5z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1563A1F01825;
	Wed, 28 Oct 2026 08:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793177720;
	bh=bPCDJWOaMpfH2ZvtM3CM8lmKR+EICRjsIjgr999n6cs=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=hvj1Ia5zziJm+DFTOaPrD7/4QXLNoWKf8JL4ce1/BjsAoQyICtSadLoy19Tu9EtYb
	 Ww8GjGaBeO5SG47VWCrhgtVXvOOt3GtMjvuMW7DcAIJKjrLNuh97i4xAhC1bmRhiur
	 XPe4tIcgl4JiobLA4pnN7PATvsG1Ij8isi8CqjiStavN6oRCdW4+iLQQIQM1Mu41ci
	 GcxURwQIgovEc7rltwEk1NJvCx0qiLOEkXmE8Ucs6LdjpNjBvUnwFhXyhQ9FKYwAKh
	 vIN4XdiAT9h+Hqpdo+KWIXNA6LdNP43gg/TFD87AznLafqeCfsZSQD9WeBi46yBzBe
	 aDBhcd8eXUJRA==
Message-ID: <sashiko-outbox-187640@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v4] net: mana: Add support to process throttled EQEs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sahil Chandna" <sahilchandna@linux.microsoft.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261028084020.2051254-1-sahilchandna@linux.microsoft.com>
References: <20261028084020.2051254-1-sahilchandna@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 08:55:19 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> When an event queue nears full, the hardware coalesces the per-CQ
> GDMA_EQE_COMPLETION notifications into a single throttle EQE (type 4)
> that carries no cq_id. The driver does not handle this event type, so
> it falls through to the default case and is dropped. Any CQ whose
> completion notification was replaced by the throttle EQE can remain
> unserviced, causing its queue to stall.
>=20
> This was observed internally as a TX stall:
>=20
>   ens1: NETDEV WATCHDOG: CPU: 45: transmit queue 1 timed out 15133 ms
>   mana 7870:00:00.0: HWC: Request timed out: 60000 ms
>   mana 7870:00:00.0: Gf stats wk handler: gf stats query timed out.
>   ens1: NETDEV WATCHDOG: CPU: 20: transmit queue 0 timed out 15859 ms
>   ens1: NETDEV WATCHDOG: CPU: 15: transmit queue 0 timed out 31731 ms
>   ens1: NETDEV WATCHDOG: CPU: 21: transmit queue 0 timed out 47603 ms
> [ ... ]
> - Add a throttle eqe counter per queue.
>=20
> Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network=
 Adapter (MANA)")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sahil Chandna <sahilchandna@linux.microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028084020.2051=
254-1-sahilchandna@linux.microsoft.com?part=3D1

