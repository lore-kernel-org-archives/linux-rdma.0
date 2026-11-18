Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794978021;
	b=v2rfv3JLcqjPDbH6s/ux2PgPgm4wRAo6zpy0PZkxYvBXjIsDHEWnPWVjIQa73iU961bd
	 JYe2HCdgDCg4iiXVruPBoaT+9moOgXfZ5wA60qlet8llgeX+Dh2IrNwo9uFBpEnUlN8d/
	 1JZr4kkOLegvIE8xcCB4fwvxPxtQoDIf9znOGsal4FECreI3joL7RU6itxgdJuaeU1ZNt
	 HcTalsIRiUMcNbFb6QqCVDSbC4slztJQ7ddYYbD/zRslSz5mMmP10AaHzb1Eahby1ziK+
	 dgtc6O506z0/bZjUcwUznir/BdYiCEEOLSy8gbrBrnIiMkxmOG2VnjfJH/VXvP76wsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794978021;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8DVBHSbAo/8LsmOL19vSSpEjAOA9HGVc1Mf4MDO2GRo=;
	b=HHoxpPiegQbPDS3rqIvj5yNsjd7jr3WYYopfqXouW3QAc1icBHJRpjjl+htBp5K3MzLi
	 R3SrR1VExaT/piofh2rQN/iv8f/nKs4LGN7tDi86Hh6JliKStazrJ5eZjlFYNsvF7+gR7
	 EgM77ff9otHm+3a/kuPh3z5yPBwqSlYwTBZU3WFLu9/qvWvcQASgl8CemqSinhHNML9Fc
	 02lwWdbYdw77cKDal8keUbp74dsXG4gXPZZufm6ZiYWHOrS2IYWdbGoFfTFlpVAMKMCbu
	 /EPqTOtwFcFOIMjlWVWHgWk7pzGf/BaXvcKm54Xo4TDiCLuQG6ftZsVaoMVYf5HaiMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S6wGqrfr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516FB606A335;
	Wed, 18 Nov 2026 05:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S6wGqrfr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13F91F000C4;
	Wed, 18 Nov 2026 05:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794978021;
	bh=8DVBHSbAo/8LsmOL19vSSpEjAOA9HGVc1Mf4MDO2GRo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S6wGqrfrGVzcqwCltAphPq8AjCRCMb2rvDaeBGylRaw3reDDzbrBy2+qhVNG9jsDX
	 aVcx4fylk4FEoR1LCZojrvYnGaGz2QQFWDgyb1u0UisPhBbusC5FqIUDx4xB0vy/9W
	 QLnjSZlIEQqulXr3H0E+okOYj3/Q/HEySFTQQyGFWJsLwHTelA7i7QMoGvTnOIbRJd
	 SeV5Tt3yjqrTfKjHnNfwZPAEwALc2eDIS+Pp6vJEpEc0SfAL3sy7OhxoyxEdgrAelQ
	 xtbBcGZG/FKimNWu+6Ne17UAAo5MaLxBNXqeT0j4daijyDRR+ZLpBxuhXYm9rafjSE
	 uDRxNk8vEQH2g==
Message-ID: <sashiko-outbox-220132@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 2/5] ipv6: annotate data-races around icmpv6
 reply sysctls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261118045137.174026-3-jiayuan.chen@linux.dev>
References: <20261118045137.174026-1-jiayuan.chen@linux.dev>
 <20261118045137.174026-3-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 05:00:20 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> icmpv6_echo_ignore_all, icmpv6_echo_ignore_multicast,
> icmpv6_echo_ignore_anycast, anycast_src_echo_reply and fwmark_reflect are
> read without any lock while their sysctl handlers update them with
> WRITE_ONCE(). Add READ_ONCE() to the readers.
>=20
> KCSAN reports it when net.ipv6.icmp.echo_ignore_all is changed while
> ICMPv6 echo requests are received:
>=20
>   BUG: KCSAN: data-race in icmpv6_rcv / proc_dou8vec_minmax
>=20
>   write (marked) to 0xffffffff8ee2940d of 1 bytes by task 504 on cpu 0:
>    proc_dou8vec_minmax+0x1ab/0x1f0
>    proc_sys_call_handler+0x282/0x3a0
>    proc_sys_write+0x13/0x20
>    ...
>=20
>   read to 0xffffffff8ee2940d of 1 bytes by interrupt on cpu 3:
>    icmpv6_rcv+0x99d/0xd40
>    ip6_protocol_deliver_rcu+0x787/0x9a0
>    ip6_input_finish+0xb0/0x1b0
>    ip6_input+0xa8/0x250
>    ipv6_rcv+0x14b/0x1c0
>    __netif_receive_skb_one_core+0x8f/0xe0
>    ...
>=20
>   value changed: 0x01 -> 0x00
>=20
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118045137.1740=
26-1-jiayuan.chen@linux.dev?part=3D2

