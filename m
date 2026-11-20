Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795184085;
	b=5dEab5avdx7ExfqAbz7oQXatJUsaE7WkNi4snSoooaRJ7iQxMb5qSY00QzYcSCd3ypW0
	 ZLoRSZEqdS4GTlw5ewgtzkm/eEg+8vrztOLvsKVbEbK5EAvARCiyhRVah13ST7oR1YEmb
	 05JMiwFYnNgy1j16qIcwr8Qa5UXChXqdmYz8FyLMoZh7LvjJb57tXp7s1sFI4Y6rP02Ns
	 hxnlaYg4zZcslmFfssl0UlLeR8rDEAbrxDHkXztMoEqQIFSp2pCnf+qBqnrw6JfRCr4u2
	 8dGKcTKGJLk90L4olMOAc5olMvMBtTNjPTk6hZqvLmwSQ+zrFuVkP8Tne03kUmnS8wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795184085;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Dih8O6UUev3+IkHLs1TRPo5TssEpPRfEIS77LoLz9NI=;
	b=tSrjbQFil/yoMbVpbCW1OtonOC7co0z4OxkB/htYZWPdY9TJE+MX/cirV2DA//5K2CRS
	 IYMUJr9n1vYtD5GBDlWyeUIXSDog/ixc441llRtMzoVpJ5PUgttzL65xyGV50SFdB401o
	 xhkS1TNHNKg4A3TFUWwQb9rW5aHp1UCY9sVj7NWWH4Nl9fH8JQGfnERuGGmnGj7Ymsn03
	 uWbMd4FTAiqWFdaDvtc+iTwjLD8fABdhfggc6y66JPNATjUAVgHoIL9oL+AM9/fQHZnFe
	 rcNtfMMSYdTLQe6wFGfQisYZbtxC5cU72KFwY/c0PyhJJDPuqgFPuJWzSYBBisU/scA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jgV7s1lt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F181606A325
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 14:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jgV7s1lt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F5C1F000D2;
	Fri, 20 Nov 2026 14:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795184084;
	bh=Dih8O6UUev3+IkHLs1TRPo5TssEpPRfEIS77LoLz9NI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jgV7s1lt38tBacL9bXdtxu9HlSLSqjJnCPdoxN+DztqFJCJZrIpMBAxe/Bywn5Gre
	 nKiSX5VO5fl33IiOYXOSII9fdz3ARJ+A7VHqibaU3Zec0JOMSC2gqgx6VBxPpKJXYM
	 kGVl5vQQTNRY94RlmcL8End2shu6w1NZILUrKWPLi+4Yo6mj1qqOyVMQf1B+nUqoJY
	 WOAwT5y/gEM88Nn0Ft89Gh4KBdUv1B6pp+gqepHoGmBisqfStWQ7n3Qkz98gzUrAe2
	 uXM8SYUo0rR4LTW93af3xoTfvJ/fgVHp5xSSJmei3kOBgGes0Id/NrcHYIf0B4XAe7
	 hgjzexy8awTyA==
Message-ID: <sashiko-outbox-225342@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-rc v2] RDMA/siw: Reject a zero length WRITE segment
 that announces more segments
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Stellman" <astellman@stellman-greene.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261120140552.62784-1-astellman@stellman-greene.com>
References: <20261120140552.62784-1-astellman@stellman-greene.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 14:14:44 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> siw_proc_write() returns early for a zero length tagged segment, before
> it looks up the sink STag. If that first segment has the L bit clear,
> the next segment is handled as a continuation of the same message and
> siw reads mem->stag through rx_mem, which was never set. A remote peer
> on an established siw connection can trigger this, and it panics the
> host:
>=20
>   Oops: general protection fault, probably for non-canonical address 0xdf=
fffc0000000004: 0000 [#1] SMP KASAN NOPTI
>   KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
>   CPU: 1 UID: 65534 PID: 119 Comm: siw001peer Not tainted 7.4.0-rc3-gaebb=
72744764 #16 PREEMPT(lazy)
>   Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1=
996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>   RIP: 0010:siw_proc_write+0x175/0x9c0
>   Code: 48 c1 ea 03 80 3c 02 00 0f 85 c3 07 00 00 48 8b ab 80 04 00 00 48=
 b8 00 00 00 00 00 fc ff df 48 8d 7d 20 48 89 fa 48 c1 ea 03 <0f> b6 04 02 =
84 c0 74 08 3c 03 0f 8e 31 07 00 00 39 75 20 0f 85 4f
>   RSP: 0018:ff1100006cf08318 EFLAGS: 00000202
>   RAX: dffffc0000000000 RBX: ff11000005880000 RCX: 0000000000000000
> [ ... ]
> The fix and this changelog were drafted with the same tool and reviewed
> by me.
>=20
> Fixes: 8b6a361b8c48 ("rdma/siw: receive path")
> Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120140552.6278=
4-1-astellman@stellman-greene.com?part=3D1

