Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794443462;
	b=5E8dBsNCeG8W/s2tE2HlY3GWjSpDFhzYVt5TC70Olw4BGTZBzzDubwf+vAXOq3l+Yv0d
	 MyWaHlXgYB/M79jH03tQ/6Rz8aVCJcCpemy9gAdqOFPX4n5EMOWE7IM9RVp+Sx5PPI9Fg
	 8SkK+aXPe7Pz4bd6+EAfCHINPHuKwGhJiTsrAPa09y/W+M1dOHJ1CoRG6w6GGQ6S+WNR6
	 sYyf1jv9URTKH2N86QjXYzLhjDLUlWDItp6G25PT2u8FpiAf9smjDI0MPU6VjuRqegci2
	 HkI0KBy19gRaBt2vk6SJI6N2D+kDO5sVob5fphoMZLThVkqK3NgeOLRZVb70hEgQ9yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794443462;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=VgaN0BiPhQ621Odqczovv/aDnJY8HDiU5hduftq69L8=;
	b=M5c9OhoA1In5UhCc4kp5ecgWXIjpvXeMgc8E5OWZCJLdsDgrrmeY6vxlo1s0scmtsuwa
	 TGimsi34PmqXYdXKcI/iPq1VIKT04pBjk3ULxyDD59agGWCxy2cE0Dml6Jzw1dyeEhC6o
	 R9EozEQoNp0+B+8n1shZ+fMzUc/IvTxJ3PD3UewQamGyjpYeAtW4ni0OJQ5BZpKh//kbS
	 Pt3f3JyHLketEoDmkCCZB+AEWvVuUlM/VipdleiqHz3QLsvCrBblwe118qlgfJzK6y2mH
	 9/k0nJoUF5qfNuldo57WISZtqY31rPlW+7xSk7hQS/TEpTP2FhBx4RteI+L1S1MLCvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JGHc26Z5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BC9606A321
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 00:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JGHc26Z5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00BD1F00A06;
	Thu, 12 Nov 2026 00:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794443461;
	bh=VgaN0BiPhQ621Odqczovv/aDnJY8HDiU5hduftq69L8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JGHc26Z5gEvcV/BVODFx8WZJy7/oLBPr2wOso3eZmKRVezhWKHD9isNvg7Zoy/6eS
	 PQgRtuPsskc6cmgCG1kV8Wic305JZxnbr2/YLvD1JPnSos4smT+rBrNeH9v/gRfRrc
	 ks9uFgKKYz3p003z0dR0vUrudNkoqxkcpM7dRh6VooBoQwKXxubHH3dvkygezsAhDZ
	 FnB7Yt/RO/76P8wlzh5Y4VZN0Oo3RA1Gbd/y29aj7c6h7GsJDoIp+rSpsxT6fIx6By
	 3l+nNjSXfC3jq0xBXvhW2fmuRLFzPPXrdvUk3yRvWyGuowPuEXJCvJv55KQ7s061kz
	 DkOK7wTYo4ICg==
Message-ID: <sashiko-outbox-209929@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v5 5/8] ipv6: icmpv6: don't quote decrypted payload
 in icmpv6 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111001831.3710881-6-toddfreed@meta.com>
References: <20261111001831.3710881-1-toddfreed@meta.com>
 <20261111001831.3710881-6-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:31:01 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> an icmpv6 error quotes as much of the invoking packet as fits in the
> minimum ipv6 mtu. if the device had decrypted the packet (as indicated
> by skb->decrypted) then the icmpv6 error is sending part of it back out
> onto the network in cleartext.
>=20
> as in the previous patch for icmp: ktls rx device offload and psp can't
> be told apart reliably, and psp also encrypts the l4 header, so don't
> send an error about a received decrypted skb at all. linux receivers
> would drop an error whose quote stops before the l4 header anyway
> (icmpv6_notify()).
>=20
> on tx, skb->decrypted is also set. an error about a locally originated
> skb (skb_iif is 0) is sent in full as before, if its route goes to a
> local address (RTF_LOCAL), like RTCF_LOCAL in the previous patch.
>=20
> an error about a received decrypted skb is dropped before the rate
> limit, so that it doesn't use up the peer's and the global icmpv6
> credit.
>=20
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/2026102323464=
0.1459291-1-toddfreed%40meta.com
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Suggested-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>
> Fixes: 784abe24c903 ("net: Add decrypted field to skb")
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111001831.3710=
881-1-toddfreed@meta.com?part=3D5

