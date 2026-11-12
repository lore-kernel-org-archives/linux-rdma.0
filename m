Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445019;
	b=Y+AV37xLmKZELlFKoRf6WJCsc8rN7ntC8NDKZsLRd0SOX6qhnw06YdwYTGlsPejFt1li
	 Ff22oEjftGfi3Wm/mIx22opIFgnZgRkl+yY7VVyZz9QFhnLKmjfcFH+p4EvOwpzkb82yH
	 xvmZt7YselqOqOE+G6z4PxvCLsapkFbbOc17ZzVMRLHdIoQ6q49x2mP5zPkm8i9kDQ4Bz
	 dJ5Opy69qWDhi8X4EETqqW4BP+Nj2hA+Vw5H71lQ1+d4CTgswxzWOcgQWgomzO1c9w0Tx
	 0cPJd4Ai/YQtp8MyREyUQeWLslG9M4yjarVvoD+lXYDQZW+1MBbslUZ8bfKWjT1uH8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445019;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hZvnNhEEFd1Isz68nkVq7ahTTD58b/ST9v2AbjbRrHI=;
	b=qP5yuEhr10mjtcXo8q8KtrcNBygbeP4FZStn3wbTtoYxEIovIxfhbP6A81cYu4GorjTM
	 33++AC4HEb6pRcFFrAyPHO4kSZn4WX4cpiePSA8EKbVX7AWXeKZD3xJnzsYIZkvYpAUTG
	 e69KrSkDIWm/KaB9NEAY/4OrVK6oo4E1+5M1qqg3VqhtDA2Y54ckJsw9X6gB2upnk4NLN
	 mcrPGObzrhOc9RT5YB48jKWTcYWvQAEMt4lZmm58/T+MpckoFVYCI8kf1kDEufMvNQNYU
	 DtrLpJHdL6FUMHjmyqpVrZAzV4lAkak6BHchjGT6C39EetAKrH1Y8W7TAIlyuvt2BjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UVbKlAVP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81454606A324
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 00:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UVbKlAVP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F611F00A05;
	Thu, 12 Nov 2026 00:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445019;
	bh=hZvnNhEEFd1Isz68nkVq7ahTTD58b/ST9v2AbjbRrHI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UVbKlAVPu4Q/7Fp9F7iPCuGYMT/KwWPujGuAIrhWC5NleMryr1SUBmNQFQkVNMnQS
	 i9s1DSeZwFMB8QJAZlxfxeNNGWpEd7MF2lm6chD+7FcgzoKKrAjpxRFkp9yvH20TrX
	 KJNp8eQIbdcfy6wuNL6sHarLQeU2j+V3Z00nIqPnxodW49I2vfpkE5tGhBtS3QVdfO
	 fuEqAopnMgSzKA8KbfuJga68stLdqrXPSb/Qzehd6BMlz4TQBtyXmGrstkQGIgvCRr
	 XZYl2qm36AQ0uNc59Sz2syeEe7f5Y7ChP5zsPXcFYXCggWJQnIMshJE28pqYymPB1q
	 PpiR4rRA/2KLg==
Message-ID: <sashiko-outbox-210004@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 01/15] psp: get netns from net_device
 instead of sock
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111005533.6436-2-toddfreed@meta.com>
References: <20261111005533.6436-1-toddfreed@meta.com>
 <20261111005533.6436-2-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:56:58 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> every psp skb is related to a socket today, but that will no longer
> be true once a psp association can be attached to the skb by other
> means, such as tc flower rules added later in the series.
>=20
> get the netns from the transmitting device instead.
>=20
> for the outer source port range, psp_write_headers() now explicitly uses
> sock_net(sk) in the socket case specifically, to maintain the existing
> behavior.
>=20
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111005533.6436=
-1-toddfreed@meta.com?part=3D1

