Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794279684;
	b=bUNODVuXlrhP7uPoMdiCJ6TTnT4DLV0MPjxHWfsYSNNaqQjO6HPlDWl6vGH2ZZLAKE/k
	 dz/3z86yKAc1ZOvGHYMdNRhvAbTTazK0ABwSZ9uLnzGe95+Jqc0Z85TqdEXNM6ASsRc6i
	 b3H1Ijib7dMIAjQeE4KeGKhRNNjWfulDtUFcb+rhGNC13GPJ6IvwAc8QAJaWyJ7KzSrA8
	 4mVaE7VFNPex5dHaoqGFOx+r9iq2yNHUI+Gf7SRPi0f36YfY5yW5DBxMrM43fUVXS9/G7
	 2D7lODQa9CSChKYJFyeUdEGbwfrTVYk/s6fJ52Dz5btdbM4lg7CJi4cFIa5L3L/XgQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794279684;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=aMsuIxc8kIKxrDEASkQltDe/dWGte8a6srEKggwzfK4=;
	b=1DPKGYQOYoHHaHQwSYkGNSq5sdEjaBKUV/YPEzVo3eOmg1P9peCTvpBVcmzNirBCeoBm
	 H7yx/+XoLRHcZzVR6tta7hHPsXa3u9XZlhigDUcIcl46VCCseVWCCh/Kx1QF/QOte0ogX
	 IBkA4YxsraUhlEXgx8fGzb1xkhufjdLUt01uYGxIX78ZMoXc+mqKg/CmY9BnpUVW37+k7
	 QNTvKIyzosKigObXz1i1KiWUgXAC2PcbncbGPUROyJTIPrCh3UnON6+IolPOq2HLMs6JW
	 fthvE/ctWMpwqD6+2gCutqSJry5dVJ+u+kO/VneHPHnYt2WQ/uIfAeDKeWeNujVH4Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WBA8MIak;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D95606A339;
	Tue, 10 Nov 2026 03:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WBA8MIak
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A41C1F008A5;
	Tue, 10 Nov 2026 03:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794279684;
	bh=aMsuIxc8kIKxrDEASkQltDe/dWGte8a6srEKggwzfK4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WBA8MIakIIrm4GxO5drslfdyk6Dr+S9+cOlR1WB+1nxXjFXBMhoL0YFpvvvjlZctK
	 yFe9nNGB4odEGUf0HprUJmYBZw8km8KIvlno6QvRIpqfLIc4k64w+x15tmssnyu2CE
	 NqYHl7SH2mlTYW8M+83qyvV3v1drbCw7K85KNlGN9mZ77rVjE+xrFznfjeCTc+Q0SJ
	 A7zxdPdAh1zyirDp09iCCk+j5/r8Mjg/Be+s58rU8wXON9Z+kwQ+CMbR35kSIB62S5
	 aSe24PbV4q4N2ydC+EOwkCf9rKtcNFglEN28K3j9PqwjT2XBaKF+Thow8LKayctRiG
	 LRlK80G5kVsyg==
Message-ID: <sashiko-outbox-206076@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 03/14] ipv6: annotate data-races around
 addrconf sysctls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Cc: linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261109025425.328445-4-jiayuan.chen@linux.dev>
References: <20261109025425.328445-1-jiayuan.chen@linux.dev>
 <20261109025425.328445-4-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 03:01:23 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The forwarding setting of conf/all, the per-device autoconf, accept_ra,
> accept_ra_min_lft, addr_gen_mode, ra_defrtr_metric, disable_ipv6 and mtu6
> settings, and the per-netns idgen_retries and idgen_delay, can be read
> concurrently with the sysctl handlers that update them with WRITE_ONCE().
> Add READ_ONCE() to the readers.
>=20
> KCSAN reports it when net.ipv6.conf.<dev>.autoconf is changed while
> Router Advertisements are received on the device:
>=20
>   BUG: KCSAN: data-race in addrconf_prefix_rcv / do_proc_int_conv
>=20
>   write (marked) to 0xffff8d7250116df4 of 4 bytes by task 767 on cpu 2:
>    do_proc_int_conv+0xa9/0xd0
>    proc_vec_conv+0x21/0x40
>    proc_vec+0x21e/0x6f0
> [ ... ]
>    ...
>=20
>   value changed: 0x00000001 -> 0x00000000
>=20
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109025425.3284=
45-1-jiayuan.chen@linux.dev?part=3D3

