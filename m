Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792569239;
	b=UruytLLskzNBM346mMuuyL3/HdBDuZmSomlkmc18vwF1Llzm/zutWtKvgmv/n6hxIZgK
	 atOnWJxpQG8K+sQfo/K4p5fqJo3tbcswMfxkh2dxT4d+wgalW+IZsqI4GTtdtJduz/uwX
	 HAY2bos5G1oSiYFyPXvdG3b5Kt8bqSykSgeu58QsSsj3V4Ph0mtBN0ZGSP+gw4tK2UHr1
	 CcjIG5QDTOKe5HvuVY7mAPiHQk09u5VhpqWjLbrx8cpSBZMPdhGpk47NMcXTBcFvNBkMd
	 45VLsAOqWTCw0dkTBYKXjOfMjdtCJaVWPEJgGzRGXdDX7oJ0YZx6Oca/xhdB1BASl1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792569239;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	b=mAJavTvE/zVdaAH4O3JJKVKCoOpomz2QYKI8ORazYv3l8bz6u/iBqmTnZE5i4IvzYrV6
	 XtDLog8G/e9mJ0WNIrltndPhQPid1maJGoLXDpvveGl15jJGZ1eB9P3EcpaGVHxEeqv5t
	 VJHcK3cupO9RMfS9Hq4O+zkaMhjjcwxfj2Jx1Mj9i5grtfCQJMDHucwSK8Ug+TameIwtw
	 FcoNlhGGhf2RsM+It1/BTVCVTUXlssslBgihbmVk/Pe6vi7Oh5ViVOmCwKKE5S5IxVf8k
	 bgqTd3bFteoG9/2/Unb5IDFtQrwMH4nMvrLqjRiNP/i1vtZJkHX1A04eS88Ue1oH7UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oGcqdc+r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F109C606A319;
	Wed, 21 Oct 2026 07:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oGcqdc+r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1B61F000C9;
	Wed, 21 Oct 2026 07:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792569238;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oGcqdc+r/lbAvimEPgmLHYcBozq1kF4RzvnB/6T5NZkr7zbetu8VpVJ7dNr9NAMio
	 EQbOoM55camCNlZFgeEg9lvKVClnVlvZwaZacgwve7PtnnD8pWA3BcXP/mXxJtypeL
	 y5Xatyay1IFRQUDjE8k+qdnHpOdiLqXcZe3tvXRDAXdCtngnP8OBs3+vciNswT4NE+
	 83XrGhb/5KRbnoJbJNoeIuuwjps1cz3/ETx9bkvl3BpYxdENOxAtxs8Cgdiqq7IciO
	 vwviyWulXzQbQzRXvn0vYx29eDZ5s241W9vMx8u25TkJ/Ll19rsahuaOyb7+5SEPLR
	 doqw+otHB2kOw==
From: netdev-bot+sinfo@kernel.org
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Alexandre Cassen <acassen@corp.free.fr>,
 Alex Vesker <valex@nvidia.com>, Erez Shitrit <erezsh@nvidia.com>,
 Gal Pressman <gal@nvidia.com>, Itamar Gozlan <igozlan@nvidia.com>,
 Kees Cook <kees@kernel.org>, Kees Cook <kees+treewide@kernel.org>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Moshe Shemesh <moshe@nvidia.com>,
 Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
 Saeed Mahameed <saeedm@nvidia.com>, William Theesfeld <william@theesfeld.net>,
 Yevgeny Kliteynik <kliteyn@nvidia.com>
Subject: 
 Re: [PATCH net 0/3] net/mlx5: Fix HWS and DR steering memory safety bugs
Date: Wed, 21 Oct 2026 07:53:56 +0000
Message-ID: <179256923674.3290.14436892609029206565@kernel.org>
In-Reply-To: <20261021074949.3471704-1-tariqt@nvidia.com>
References: <20261021074949.3471704-1-tariqt@nvidia.com>
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
