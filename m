Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794443460;
	b=mdfW9gsqNwO0NBE5zqB27VNawmZMIsG9k++qPVBAhrIwhLog6Fw8VtGxQfyClcKk50/S
	 M7MXKh1KeQRATSDuRg4kARgCIrFtKLWI9xkekPZYJz6/Cn38RABILM1ua5EHFO4G6AE8D
	 VEymUVZV1Je0/Jbau9l8Mvr7xFyU1CAe4/04AGTMIdjBDpu4h/jlaz2rjpPU/vCVqZmgO
	 wE4fa1t1lvieGNGejYQyharFehEwvEQiP9X/DAW1MvnJgdK2Fos8EV3WJ42MTj0GFGg8J
	 6BPiDiKpm7pBA2EC1gv/P8XL3nfpjzv5diKMRjQ8CJ0umjT9gwbRwNq04T45Sv2mdTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794443460;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=asiV0Nb3CKTVvWzzJZdh56T+JeGFdtUuK3jyjs0qlE8=;
	b=lck6Iza9iTravRROnDw1DbgRnF9nQzCLxsIWlJHAHnJ9jpyL8Y4b8UHAznjO+J8i/eIm
	 yBzCkcDMyL4QNeJR/PiOhV16WFO2Vdo1J5k0Qrb6rYw5D8Bx+yABsNAWRXSNJJ0Nx9KtG
	 z9RKZ1QyTdyxRHLyVle8lrDcg3L2+TA4FGCxK0/oIDG0VzIEvN9LrwXSn4Z0fC1/dnBMQ
	 2oDMhvJe8ouHY0QY4B4EusCbHdfij+JLiTtYMr7bTeVeweRLjQQ1snhC4V2GKry5u1a6+
	 VRqDA3z6Dg0DwI9X3v8DCd9uNziX2O0wlAUXtflKI1sQcZfCm2EZC2MyrePsw9p2Cow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WiPrtlZG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1898F606A32E
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 00:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WiPrtlZG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C991F00A06;
	Thu, 12 Nov 2026 00:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794443459;
	bh=asiV0Nb3CKTVvWzzJZdh56T+JeGFdtUuK3jyjs0qlE8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WiPrtlZG4gBvoSd5XkcG/mzp3Sxv4fEn93NrGP5xeHFwPZpMQVmKxin+kTbRgT2OD
	 5l/Q65shZpnwhRwYNJE5Crg0abRT4bgpN6oYouLMcYPWyGkI/ssSk09O+H+ZYTYF8u
	 f39i0ADc2L3LKjMYilnOmB02bLJtXur2bygciWTZOkGrhGFbtFDYsbuHjPzJMIZwF2
	 8cAorMIjuXZHdzYd3vY+vUiRumA8LBKKtV+F8sKdekSCFo3Z2cDHeNhKqxGmey1GPX
	 UjsOmzHfZfeIgjwvg28nyH2tEUUY+DRMXjhjhZyCkRcBgMdKHtfjDQZQDmnPI1HyFc
	 gkXt/0NKMPWEQ==
Message-ID: <sashiko-outbox-209926@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v5 2/8] psp: don't encapsulate ipv6 packets with
 extension headers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111001831.3710881-3-toddfreed@meta.com>
References: <20261111001831.3710881-1-toddfreed@meta.com>
 <20261111001831.3710881-3-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:30:59 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> psp_dev_encapsulate() inserts the udp+psp headers at the transport
> header, rewrites the protocol of the fixed ip header to udp, and writes
> tcp as the psp next header. so tcp must directly follow the fixed
> header.
>=20
> if the packet is an ipv6 packet with extension headers, udp+psp is
> placed after them, but the next header indicating the l4 protocol is on
> the last extension header in the chain, not in the fixed header.
> therefore this produces a malformed packet.
>=20
> in addition to being malformed, with mlx5 this kind of packet goes out
> unencrypted. since the tx association encodes intent to send encrypted
> packets, drop such packets instead.
>=20
> a psp tcp socket emits such packets if certain socket options are set on
> it (e.g. IPV6_DSTOPTS). refusing the combination of such socket options
> with psp association would be helpful but is not implemented here. since
> extension headers can also come from a route the datapath check is
> needed anyway.
>=20
> the check also covers ipv4: the l4 protocol must be tcp, and the
> transport header must follow the ip header and its options. packets of
> a psp tcp socket always pass it.
>=20
> Fixes: fc724515741a ("psp: provide encapsulation helper for drivers")
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111001831.3710=
881-1-toddfreed@meta.com?part=3D2

