Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793487826;
	b=eDl3Rixs3rBIsrWBV0o0XPEgqvqL0jdNm/3lE9QotXomtj2hx6x8LiCThGHSRzEk54EC
	 Al4oWxKcSW1W2eOul/5SkFx/yQGdD4Lu/o3IVZCXg44ZsJTFtt6z3Nz2lfXY3Pq7ZRybP
	 XEpLEjLw+5sLczcSR2oDkrF3U3p1h26f9jBqoZmGkdT6NcG9BCX/iE7a4mVRAtdhRh5sd
	 Nqec9+3c4aS7JJhnFjY5RUtKR2kcRyqQhrNBpC1LxJGXhS8Vq12R2Qt9BHc7m1WCNMSz1
	 zLCGa/ROKJhT15A0Qt3DhgiCBmaWO/CfEg33D5YSmUv/xcY4iW5AxKucq6MKEgB7L1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793487826;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	b=FP6teHbx5P37S+tqVi3aeMTFQ1/+8IiXestD5tH9uBsKq8H7Y38WsFRCvUkubvJLuGfM
	 K9Iiwx3LXhnhlSdCMsAaGrDjgvWtCvbXt3OUkFT3hVPFD6OfeaBuQpy4+UzbhNgDuw0Jn
	 hNTsLmxfhviY2DPo6oUpdANiPHIwj8aM38NQv/uXb2+IKg6tGh1kfu9kfwTv14hOLiI5v
	 OeX90QhU+dVwsqWAovcOLGVibNePNGI39YXuEDAJtMIylfzC7KI7Jpi7KDf0Vk+V2kjR6
	 WaMHAx3opQdEVBPDNzK2h551/T5oqNPCjh4fj1SDaqFjvWli6LYwnlLfDl0vykkAovQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PkWUYQan;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECA3606A31A;
	Sat, 31 Oct 2026 23:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PkWUYQan
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386211F000C1;
	Sat, 31 Oct 2026 23:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793487826;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PkWUYQanEi8N9CjbIyygd9rk0FHvO8KP8QQ79kuPGnCQD8fgzX3da0jrtE2Sn3daa
	 9YRCqKWYRupGcYeoEA8RjJIaHn6o33y5ZGz9y4ydgYhqbjuGQj2TRMpE606rN2soJg
	 B61VUugSf4b5/UHEzRDaMnxlA3GzYuKf19qO3GwKno+sciDEDGjb+UKse/aGs+QdZj
	 /7c8Akqyhxh0ioTKDpJJgoDFuRzrlO9zKORJPFWcdo9jLjJpF7FQ+6Gf8AskOqin4A
	 IVHYSHN78MYTpFn5v/2ubOKX4qBJxxPG12Ts0BNK1soXfXFFbpwFHC6VWBkWxExgUB
	 HZouFu0yhkR4Q==
From: netdev-bot+sinfo@kernel.org
To: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, dtatulea@nvidia.com,
 Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
 Erez Shitrit <erezsh@mellanox.com>, Alex Vesker <valex@mellanox.com>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net/mlx5e: IPOIB, Fix QPN lookup race
Date: Sat, 31 Oct 2026 23:03:44 +0000
Message-ID: <179348782476.3286.8725253095821375751@kernel.org>
In-Reply-To: <20261031225749.14214-1-prathameshdeshpande7@gmail.com>
References: <20261031225749.14214-1-prathameshdeshpande7@gmail.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by code inspection). If it was triggered please include
   the symptoms, like the stack trace or error messages.

 - What hardware the change was tested on. For driver fixes please
   mention the device (and if relevant firmware version) used for
   testing, or say that the change was not tested on real hardware.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
