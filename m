Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442969;
	b=ZC98DiR+DL5lxiad9CJfo9QRf1U6WMHrCxZW0Aeap26Vbkn/Qe1YvuHDlo7T4sExPkeU
	 2F1plUPnpCAVSGlresBeBaylTMyBttcT3Vra8VsxOwVkSaGzVcYuoLegM32Fk0Y8H36WR
	 6AEjhgux/Yg3FJzqqNV8TAwqA1zzdaCzjrZyj+rkO93Oa9WtAPQOyEcc30DvFo5/CpbWl
	 Fp8+UAD/jF963jhOSCaQjkanHiPTve9oJmEKzHNpm/Az/upeK78XhcXieDvhU+kGx72QN
	 8hGEm5mmkPfZEmBAZ4oto+kQsYE7jEEph3WgGMDTD9+2nD52RA+H4l23eAYDWVSgMmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442969;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=oTGSn9qe8rLrlzJPvUc/96/oj20XWjWdXShIWr4W+zU=;
	b=l0hwBvJ3crc4XaaPiu+o94O7F4LRV1ibttuXlLJu+N0O1jH/032khLm6kJndQq8tn4Y5
	 v9rkP25Ajgw6riACY3EYIS7ZvH6JvqyU9/rQYMgZN4Xro1khsdPqB1OiSFfEZK2lm3612
	 dY/i5MW//KxjIaeEiVm4Ggc6KtzZizkJy3zFhEmcxVOM37bjpiCloSatGHVJK65daNZ2t
	 BQYHEdWSlwr/h2Lp6JjElrbARXT0Q20APwkwQ1pODoUBHMHYKG91LgtxFDLQeY5+NUqI0
	 sUXjZINsuzWy+Z7bviYhMyrThYuSdmC7DBJWDz0RLnafMsTOrEZrkMfcCRaln/vVITw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YGLQ5ji5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8961606A6A6
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 14:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YGLQ5ji5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209A71F000D3;
	Mon, 23 Nov 2026 14:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795442968;
	bh=oTGSn9qe8rLrlzJPvUc/96/oj20XWjWdXShIWr4W+zU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YGLQ5ji5pjX3Y9vaynDd8njVacVX00e1OQ5ESMdI5sLyb3V5tz8VEI+e9+ab80ZT9
	 HarpCOcfw0MO6CdbKTFNZ0iuTNoa3hh4uAeFLBnvWsOuyI9yo3IKd5wURzaUBGds/v
	 cHPyky7416d7Z/QqbfQQdKRRXrO5RoPaRxW2j+wZJVEdZBm3gJIzZvMTdjpDkWt9pD
	 +wURq01XZIjlPrjTN7IbdHdeFcA1QUbuDdv7DIPEQ/cNWzPcyM+JVIri9sD/P48XAQ
	 UpJx9shU/n+Ge0DUd0u9y0zRiv56Ebp6Pe5Wkj7rkHKYGyRkgwSeNsp8EzYlNaUInl
	 22Z8yi3oD6i0A==
Message-ID: <sashiko-outbox-229379@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-rc] RDMA/rxe: Zero struct rxe_mmap_info on
 allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Stellman" <astellman@stellman-greene.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261123140620.64393-1-astellman@stellman-greene.com>
References: <20261123140620.64393-1-astellman@stellman-greene.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 14:09:27 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> rxe_create_mmap_info() allocates the structure with kmalloc_obj() and
> does not set info.pad. do_mmap_info() copies ip->info to userspace with
> copy_to_user(), so the 4 pad bytes of struct mminfo come from
> uninitialized kernel heap memory.
>=20
> On x86_64 v7.4-rc3 under QEMU with init_on_alloc=3D0, an unprivileged
> user (CapEff 0) issued 300 CQ_CREATE ioctls on rxe0 and read the driver
> response. After the guest had run ls -lR on /proc and /sys and read
> /proc/*/status and /proc/*/stat, 101 of the 300 pads were nonzero. In a
> separate boot with slub_debug=3DP, all 300 pads were 0x6b6b6b6b. With
> this patch, all 300 pads were zero in both configurations.
>=20
> Allocate the structure with kzalloc_obj() so the pad is zero.
>=20
> The issue was found by Claude Opus 5.5 running Quality Playbook, an LLM-d=
riven code review tool:
> https://github.com/andrewstellman/quality-playbook
> The fix and this changelog were drafted with Claude Sonnet 5.5 and review=
ed by me.
>=20
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123140620.6439=
3-1-astellman@stellman-greene.com?part=3D1
