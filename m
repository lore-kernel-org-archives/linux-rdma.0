Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794443461;
	b=1GbZFtIbYrqx8S+ZcLbTivi0mMIK1bFhXKEUFU1Bw7uDV9e8t80INh8D8diBrgDQMIW3
	 BRX7N5cTWy+t3SN0OdE9eC2xRADmvKbDxIsjOZTS+JSrjjkU/bfkhx+SUBRLLHCyENwCR
	 wU9e6EWwvlrOFNBu/RH1pPaxS3D16GnUiFQBu0x/xTeZWSS9B/VD3PERrlJRE+jfJ70YY
	 b2KLrl/qsb4Sc/pNrUEP5YU28NdXb5IhQofjg5q4ogDovdca38XDZPzfeVgcuFJOVlJzI
	 5kUnLr8xzv3JbPd016GbdDl/QrDszQfcuelYI9O8GnMdcJZurhH0MtQKn4+dMR6JI6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794443461;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=H4LF/BpXzfSx2N/kI1qd2VYtPnxOYbRK5IVhyIsR6Zs=;
	b=B5VW0NqOnX031bMFb2ZjiCfn15IR59HBfvB5dj91iwjUhrkKPR99baaKfL4hZxin0+xk
	 qZlExfUE6NY2vII2g+Yu/83JXFRYAhuX5wuQ/VKKRksZ6pO7N5rTPY6TrkHx2b4VimFMk
	 LCCTKq3wYwsyR2y15GqHEIo9YHIELzRDDVq/fPjPVn2WYqM45xuL3bmbMqYOoFQaLrp4Q
	 T43FrgL31yMvoKllcQJxqvj4O2e3RIu0Xa3tQrnjiWBu4EoYDWi31d13Ar+jIdQg43zwb
	 VHfkC9mmnHu3siIvWBT34/6R2wDQHaofjpu5X28KxMEo3TgsUJiM7WVYTJHO8N+uspw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F8PGe6Cv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5327F606A32D
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 00:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F8PGe6Cv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10DFC1F00A06;
	Thu, 12 Nov 2026 00:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794443461;
	bh=H4LF/BpXzfSx2N/kI1qd2VYtPnxOYbRK5IVhyIsR6Zs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F8PGe6Cv5feaQz77roKucnrS8jhgjPhCkSwyGhsoJtSSfFrEt3LgjA86a17Iulr+v
	 5j3QqXeI6pG4F++KJ4toAClVnasVnqc/s9Q0Aqpaoi6gbFIBnWIeFqNdkxjyDHdPmv
	 I/PvNyPEB8JfLh92BEE8aMuudBSCG3SPAkGlzXx9mCpMiDrxbImPLh3pzq/3gljZ5L
	 JPUFnyyrelON4m6hHY+EB5KX3V9iKkD9DIzWNcAUXFMZFQd167xxkGr9ia2XPc/FVw
	 0sk1zi9fap8UbD1lZQjaBL01KI4b92uRuQ6SXTAw+E00ZnjvdeNuSNRmHy429XFiSE
	 d5pgu8vvkQ7yQ==
Message-ID: <sashiko-outbox-209928@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v5 4/8] ipv4: icmp: don't quote decrypted payload in
 icmp errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111001831.3710881-5-toddfreed@meta.com>
References: <20261111001831.3710881-1-toddfreed@meta.com>
 <20261111001831.3710881-5-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:31:00 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> an icmp error quotes as much of the invoking packet as fits in 576
> bytes. if the device had decrypted the packet (as indicated by
> skb->decrypted) then the icmp error is sending part of it back out onto
> the network in cleartext.
>=20
> the two offloads encrypt different parts of the packet:
>=20
> - ktls encrypts the tcp payload. the tcp header is in the clear on the
>   wire, so a quote of the ip header and the tcp header, without the
>   payload, would be fine.
>=20
> - psp encryption also covers the tcp header. the quote could include
>   just the ip header, but then that's not really useful. linux receivers
>   want to look at the l4 layer on the quoted packet to look up the
>   related flow, so such a truncated icmp error packet is just dropped
> [ ... ]
> Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/2026102323464=
0.1459291-1-toddfreed%40meta.com
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Suggested-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>
> Fixes: 784abe24c903 ("net: Add decrypted field to skb")
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111001831.3710=
881-1-toddfreed@meta.com?part=3D4

