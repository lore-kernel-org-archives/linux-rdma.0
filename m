Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794279695;
	b=WG3rYS893QEHh1UJeokP2UvYVdm47oxtLZ9am3hZwoWhuo3ElswKCURliX5wXd9gJXGF
	 VKFXh4t/mOJzAWn+qGunNN0hHkVl9rMkGDdJESRcktuAJcC4Z2HJt8AMbY7cuqxb1ksIX
	 IJqGhmRpVTQFa2HAQLJkL+PJL5u/+wlEEUPCh195qVjqg3zUwA4OlOfZ0rbFo9QpbzTZn
	 m0QkoyiUxWeC/ZopQ+eWdm7GQfvq9VUEaYGXzFGX6g6stnetYYvHWCfpWL/+6XdKfiNEx
	 txYLAFFg421fWkzgNbTl+wF9vwYm4YGSc90Im/hLik5AdcqB6pIDvQJOtLS8g6jkmZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794279695;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ze9768C3Ns7E/ppv0tDyoghZUfTObLOblA8hTJfwWDk=;
	b=pPTBxY3zVjrdmZDwNKvcycimPgZtAUT/a/Vlp6s4f8CrGvbF+kq/E5hFlHuVyR/rASJg
	 yxXkv7GOi9Ih6Ld1G7JjagH2FYUP+g5Txi+BLK2q9qBwo2y6HUKJ7oqp7tWiPAuwTU0XY
	 9ypijBD0ecMMuIXpq/2Cbrg07Z9x69eXEClk71JjDjohoEmyQ1T2Hhk413WJelHNQ3r7M
	 yvkLTlYG/RD2ffLMqlUsISOeRgUSPSXkZWSMAxgnsTRPw9qVvOdC1pXS92Rp1vRgBbma4
	 /cw/EjnlEH8LM44Fj5pO1cLB39v+OFa1euVFLllXG9acMfjYV5ck2E2GAMmCI/GFJ/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QUHKLbQa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21827606A33F;
	Tue, 10 Nov 2026 03:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QUHKLbQa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989531F0089F;
	Tue, 10 Nov 2026 03:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794279695;
	bh=ze9768C3Ns7E/ppv0tDyoghZUfTObLOblA8hTJfwWDk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QUHKLbQaREX7g443hbroqn2ixLk8lJ/6i0zdY/4L5dRsgd10YNM6HlM/NjDHuCkb6
	 bEen+BeyBBSlgjdmyK7RgsJOD2bqzddyb+AlJ0PoUDjOADuuMNW+Z5HiKbRI+zB3AD
	 5KInVpZhttIxc1dcKGLSUT146zjJM/GTGKZBJTnkzm9fg1TnI8rp3/2b9IQp7iauqx
	 0eMM0FzLwrUYqoSAQYvFTSu908K/JXL38OUalFWEibXyE7eLwJbOAFwj3y0DzPM4M9
	 it/CrF13X39t0G9cA4RQcapBFjTvpHBGOvDaNT6ZLHkFoKdRPNBuVyPNf3j8oIT2yH
	 9qJio9pll5baA==
Message-ID: <sashiko-outbox-206087@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 14/14] netfilter: cttimeout: annotate
 data-races around the default timeouts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Cc: linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261109025425.328445-15-jiayuan.chen@linux.dev>
References: <20261109025425.328445-1-jiayuan.chen@linux.dev>
 <20261109025425.328445-15-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 03:01:34 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> cttimeout_default_set() and cttimeout_default_get() hand the per-netns
> default timeout arrays to the l4proto nlattr_to_obj() and obj_to_nlattr()
> callbacks, which write and read them with plain accesses while the
> nf_conntrack_*_timeout* sysctl handlers update the same fields with
> WRITE_ONCE(). Use WRITE_ONCE() and READ_ONCE() in the callbacks.
>=20
> KCSAN reports both sides when the UDP default timeouts are set over
> nfnetlink while UDP traffic goes through conntrack, or while the sysctl
> is written:
>=20
>   BUG: KCSAN: data-race in nf_conntrack_udp_packet / udp_timeout_nlattr_t=
o_obj
>=20
>   write to 0xffffffffb0829bc4 of 4 bytes by task 457 on cpu 1:
>    udp_timeout_nlattr_to_obj+0x3b/0xf0
>    ctnl_timeout_parse_policy+0xc0/0x100
> [ ... ]
>    ...
>=20
>   value changed: 0x00001d4c -> 0x00001e46
>=20
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109025425.3284=
45-1-jiayuan.chen@linux.dev?part=3D14

