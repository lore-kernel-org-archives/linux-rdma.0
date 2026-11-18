Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794994195;
	b=TBx5ImA4NHfxG/0p7H8WCF+8Hxixfp2dmNapI2tV0kFoKFjfa0D+bsxwDjlURxWMH0Xz
	 9ra8Ldfk/rJveKZgWL/jBDujz63fi9/Dk39HNtciMuWPJYjf3MUNA6LIUvJ1NyMNnA9tJ
	 gu0n/tfXyIQOQBDYQCxJHg5O7WEyrx2RH7k8Bh2EA1omFbDQRzGeFasLxX+toVc2UhsQB
	 rTf+wOQGrgo4NdFgvsHMSWjI59MZGyq63pyofnJaYckuTFuDKWOl25dB+FqhrIapeYbxe
	 uMkfLt4Xz3Y/7eJ/dil94kighDQjD9i752KhmcDd3+BuICD4uqP8uVAzVr2Baap3U9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794994195;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Wm5sIripQ1QExaysRadtSYnWFkIWzi829Tk85OeiE9Y=;
	b=XBmmztwmcBudTPlTBYaVqU0qv4T2uqnCM55W/Px/iXg5RNpbw0YnbqTANq8dmL0xkmyP
	 fvLcskcs1rMxxWTFEAKwtmqQSbHRs60EtDrTTQaLHU7dbtQaKfga4wOTW6zuek0750Vlk
	 9Wd1d4HhpFw8Ro/40NYPvFdv4kYHVxl8tL7gugNhO+rUYRiVEX19D9nBfQIrgAxYWalWi
	 TCkzMcZeBVthwmgkDLbL0q9EKp06VaJIFZfSor8FijV/2qJFT/oF7GIStO2XTp+CgzwbT
	 XlzbY0Hf9yVfXaYXn3obB1zdVZxsNPfMkvVVL1hx9kfj+ghlV3p+4B3yLpn8hZYCilg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DxOdP7Ky;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F9C606A320
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 09:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DxOdP7Ky
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D761F000C6;
	Wed, 18 Nov 2026 09:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794994195;
	bh=Wm5sIripQ1QExaysRadtSYnWFkIWzi829Tk85OeiE9Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DxOdP7Ky/G8+96xXXi04lWvM6RpIdMt8P2Op+Dxb760QY983Kp72c6RgNS48jOxlq
	 xG2QD77MagKfuvhotr4z8woTVuK25PsIftdNMMaMJi+Du1QOUWrWPX7BAHA6jILtKv
	 tZFofeT/sF5ZGU7N1i5/QCjWxAFmsyDGvPiL5t6KZMq6tib9s50GghTbZ39fq21Oev
	 yionPgqUYU3h4oBTiVpC1CYw+rwDMjSiGCHXXbbvZOnptrEDXz4aNm+wUW358HJhla
	 mPyW4fqPcapfKzwc6Gzjlfp5Aa4CHcoWVNTKSX/XLrRIVNJQR5SDnwYKjTQKNPG2//
	 5KiT5TD3ufJMw==
Message-ID: <sashiko-outbox-220569@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 08/10] net/mlx5e: TC, offload RX queue
 mapping in NIC flows
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117092915.255194-9-acassen@corp.free.fr>
References: <20261117092915.255194-1-acassen@corp.free.fr>
 <20261117092915.255194-9-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 09:29:54 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> skbedit queue_mapping steers a flow to one RX queue. ice, hns3 and
> octeontx2 already offload it. Add it to mlx5e NIC flows. The rule points
> to the direct TIR of the channel like ethtool steering rules.
>=20
> The direct TIR takes over the destination of the rule. The action must
> come last and cannot follow a terminating action such as ok, goto or
> mirred. A goto would also unbalance the reference count of its chain
> table.
>=20
> Reducing the channel count below the queue of a rule drops its traffic
> until the channel returns. The direct RQT of an inactive channel points to
> the drop RQ. ethtool refuses such a change for its own rules but nothing
> tracks the queues of TC rules. A channel change racing with the range
> check of a new rule has the same result. Direct TIRs exist up to the
> maximum channel count. The rule always points to a valid one.
>=20
> Tested on ConnectX-7 with firmware 28.48.1000.
>=20
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117092915.2551=
94-1-acassen@corp.free.fr?part=3D8

