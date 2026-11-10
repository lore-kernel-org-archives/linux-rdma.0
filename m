Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794316265;
	b=an44n4iheh/W1xeBHFLxIgfGOfnuarbNlWGDfrRLGaC3eOurAZIXjAzkf1Yxeiw3gQ/R
	 InHd0C0ebxZJNx0NE+p2O/jhvBY1hz3WvblYDQPr5rNtpc/mCGjSECvCMlfW2lnpf2Qj7
	 3468eKv7Aka47DPvo/leoOOI6ttkGYk4BSXUYBnngYv7tZmmAcn21Egkccw0y55zgDRSW
	 UBaRiMuK4MTqpG0D/Cm06Oy51LqAtXhgjy11THRnJiYIr9qnqNVmehq36KLIDYjHCNi1p
	 BYpQPd34bsXmA98PwPfLytwTdBCjcs7jAPfQwSAz0holrGRxSC1H5vq6rSoJ5sxW5NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794316265;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=YqhHrbvxknMNvTFhD6gQDJ6KM+r9Hkl/Zrq8MpHjLuA=;
	b=2XEZAMk0C69pkyH3eCl+hL2RDPk6Ad37uudUzrwqY/Axn3u+fQ4NSii6AsyXLEjH8Zlt
	 YBKzLTqpoXLYcszzG9Sfi481sPm7rW7pAsgMvnvuqiPG+rdemhgPtp2twbE0/r1sSWAiy
	 HyLUCwC/ZUbuEana7C4ZXZ4nqtcPxv58ORwWQVZpCnGnz6rItUJ/qFi3MA7ymhltnvtfA
	 Of9sv4gjqqT+pZClMBt8quAtt/hYHhU/LAEpupBGoUhLsXHl/QyQXVIv/Aic74XeU2hlS
	 +uAcLFw4v7MxdqGcUAVf+JHj6VimcaC2nmrdaCRk4KBGEsKA2qdgMBLnQ+QzwESf01w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="kh/2Pgpo";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C91606A32E
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 13:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kh/2Pgpo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B30A1F008BF;
	Tue, 10 Nov 2026 13:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794316264;
	bh=YqhHrbvxknMNvTFhD6gQDJ6KM+r9Hkl/Zrq8MpHjLuA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kh/2PgpoTVssk3mtBlshcm7CzBBGuqVGjTJLf2HxOa7MplNw4dTF29raOmnB7o6BS
	 9hyFkWZ2+TQUkyb6TUAXBoDDgUnWooXfxqRdkQqmv4IpSG2KlLzPCcLUDg1/A+IFv3
	 u60odDHJie6Fb/EA7k9ZomjjzMfmrYa7Zpkz8Qv//pAX4IK+UW9iCIEdEy152fzAZ2
	 Jl+vTeWzq2xhDCiUK5785yEvQvvorsvoWBEvexQqUuDVu1Pf+KfQJspfoTkWGax993
	 nMcxubVGes3+FfQ103CUzftk+wuDyKq6KA6IDK3+YSINsmPFBq8U/7+rYW3DlbKYIc
	 ZflPfC+z6Wo0Q==
Message-ID: <sashiko-outbox-207097@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 08/10] net/mlx5e: TC, offload RX queue mapping
 in NIC flows
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109131039.959438-9-acassen@corp.free.fr>
References: <20261109131039.959438-1-acassen@corp.free.fr>
 <20261109131039.959438-9-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 13:11:04 +0000
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
> come last and cannot follow goto or mirred. A goto would also unbalance
> the reference count of its chain table.
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109131039.9594=
38-1-acassen@corp.free.fr?part=3D8

