Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794279685;
	b=yDQNBqnFdLL07R250mrchlnT84ULQyfTnzldcsqJ54iYH/t37hADWlfraVSq40g+0tGT
	 ro2J8O+YAp0H7XZ1XCLtLT0oagjjCTLDX2olyHtAUw5H5urSt371ktL4iEy5WFnXeU4oU
	 HDaW5wypZ5I9mjt1Ul//uWTG1KQE97qSR6ANsk8N9YrsvtEOSOiqAJw7BK2+LC+EN3a/t
	 lRE33bhGX8rVHPj/X7ODCXA4+ynk2A3BNb4VBWTjOobkZY4PKo1wioNJm+axeKrQvbTIX
	 M2Wtmz1tgjmTy8Qx+W426+Vs0ZkfgO7QR7Iilaf6p/KF53O+Cm27twrOUdGv/vl3a7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794279685;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=aijXbiih6+UhwyoMr8I5sJ/gBGgvrlcnRZAMAHuzgNQ=;
	b=ramx5FFQpZEVkrBzwwPLLdr19B4Wsl1+gF3cU6783twgngj/Htdvf45deBUV37QczIyr
	 8WYeU9rpv5aouXglde3LhG5DtI5JsLO2BtHozCtikMa6Pl8+UtN0mEYVLDj254x+7b/wt
	 Ekm7YdwzygbxwBUp0d9okTK2ylv2Y6pNqdxVRFV4rPtVbc9gZtpt5fTYGFPMasDpt91Rw
	 UTfQ0aQ2TeimDhHJAeIG8BJqAYiayfNLXX9JW15Dv7fMVPaRN9Qwq0/YoF9XG1M0pTeUY
	 B6eaP7W8KWf1C0x8EM7PSCTlaGTNTOTdhtcvzGbfZDTEmqHh6B3r2HDxGaiT98CkILQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gHSRid25;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A06C606A330;
	Tue, 10 Nov 2026 03:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gHSRid25
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C7F1F008A6;
	Tue, 10 Nov 2026 03:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794279685;
	bh=aijXbiih6+UhwyoMr8I5sJ/gBGgvrlcnRZAMAHuzgNQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gHSRid25E5EtTsUfWnLr4YhW2ZBvST3p7ce3feuD8RvHywhDIKv4b3pw+mrpjh7dN
	 Fh/FKWf/aH5l2XVAOapDXRNpG5PVKq+RXoUsdg1uWsVGlswpdYiwtvMDE5xeYtFn5G
	 YDqRZdYIzYs0wBdJj2My325aWj2Abfu094yTt6Z42qmPio0zBfIH0ezTNAbF3D+1Nn
	 J2diX/cz+aXUp5NpfuNnA2aDCxZEYFDY2TPnlW5eFE7no+nDo2KqRy0cD279wfQSKO
	 BDdlnr5LYXPu5u4M/eiIC63ZiJtbVDt8FYLIGcdk/XtS94XeRwTWQ93Zke+scW1p5L
	 BcnBa4X5IzzXg==
Message-ID: <sashiko-outbox-206077@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 04/14] ipv6: annotate data-races around icmpv6
 reply sysctls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Cc: linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261109025425.328445-5-jiayuan.chen@linux.dev>
References: <20261109025425.328445-1-jiayuan.chen@linux.dev>
 <20261109025425.328445-5-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 03:01:24 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109025425.3284=
45-1-jiayuan.chen@linux.dev?part=3D4

