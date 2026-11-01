Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793542768;
	b=P9J70cVfKwNufYz83/G6lDEb06Tjb7lPU8uSJTq2j205ZXSDYvkBCwPPM0y1qLTI/C6y
	 wryIVsqlQgLnq84pFlQZ64i3c/4vx1ljhHjbiERMpWRzlmfyZHdGyQv2PBLxJem33ASG8
	 V1uJN7qJbuERkSDDoD6l2P0kyRJ92xGv3apcxvVLKlG0Q3ZJFNWATqjjEzBHbuh87ijKs
	 yS6GchCoyDcflD3cah9h8ztyrzNboO9Te6kJR2k+JxYpx6sVT9vwkOxnW1unJ1XykfbVR
	 PPY4F3XC2xnUt6FUztrXMl1oUWcTObAbz6sFQSr8eB11VV9oqRqTGAm/YBa765X3jjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793542768;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=h2brRHdNf4QXLS+bB/HLyFHdblED0eoX2qXJ3udfy4A=;
	b=DyP78E2rWDQxRsFJ2tQwIHbpTaZVJ20dqX2Mk8rAn8WO9Cwez0EPSday3pCzYBaKQHv1
	 060lrHtOmTQ7vwbxpR8Tn8uheE0c8pLvlgvhrzKOmRRVxZX06vp2KYP0Pow/fWSLtyuqx
	 TUGrSnJhr9593es7ZAdVHhzg87sXMjPxMQeJVkDT+MKFDz5onCn8k5TB9boUy58zVilDs
	 ToLk8NbeMLXuzvQG/LRSVoBbM1z3l3XlGptLIV5e9FjaSQRFFbHt8PE1vR19cBNU322+k
	 JPFXsr0mxZjercu4C9bOzjdNjlU2He0E3WNFDzkVbRxZ7fBTh36GkbdonGu6/BBxPBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BJ1ju6dW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0E1606A324
	for <linux-rdma@vger.kernel.org>; Sun,  1 Nov 2026 14:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BJ1ju6dW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010AA1F000C1;
	Sun,  1 Nov 2026 14:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793542768;
	bh=h2brRHdNf4QXLS+bB/HLyFHdblED0eoX2qXJ3udfy4A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BJ1ju6dWLVTe6LfTJSOs9rgHN/8DugMIaT06fst/yTvu9tWRVZVYebxVZTbmrGj1g
	 ATcwTYJphJmaxBpEiHqGo5d8zNQKg119pd45zV+WiIL+0WKrSMW8cw2JtAarkeVSWn
	 geXgtW8xzAXJA20cahWqZ7cr5R3ZBk5G63pipKXYpi+4UlTLRwTHN8cb0CmtCNIKoU
	 /BzZMrLPlJ+RTdnBMzJP/Y6Lk6SgmoVgmN30lzRl/5QVJC8UvEPLNRkkU18JKs6dV3
	 FGwj7uUKSL2lhNXZgxYLjmGYI6KB40U3v87chhUk3Yr8QzJiS7fUDt/99ilt/HgBTs
	 FeZVM1nEAfZ4w==
Message-ID: <sashiko-outbox-192442@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] RDMA/nldev: Reply to RDMA_NLDEV_CMD_STAT_DEL with
 its own command
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nikolaos Gkarlis" <nickgarlis@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261101141521.2426198-3-nickgarlis@gmail.com>
References: <20261101141521.2426198-1-nickgarlis@gmail.com>
 <20261101141521.2426198-3-nickgarlis@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 01 Nov 2026 14:19:27 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> nldev_stat_del_doit() replies with RDMA_NLDEV_CMD_STAT_SET. Use
> RDMA_NLDEV_CMD_STAT_DEL.
>=20
> Fixes: b389327df905 ("RDMA/nldev: Allow counter manual mode configration =
through RDMA netlink")
> Assisted-by: LLM
> Signed-off-by: Nikolaos Gkarlis <nickgarlis@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261101141521.2426=
198-1-nickgarlis@gmail.com?part=3D2

