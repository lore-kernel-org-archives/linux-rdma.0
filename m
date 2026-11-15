Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794747133;
	b=bgLgu8EOdVRQK+Ve3s27SQfdv7kOtiIOa/g382ZC94h3iP2IKrNdAt5tAKHX3ACwsZz/
	 JxckA/Z0V8ZTcqW25h2WwgtkDv9837z/ZYe8H+VsOXLnYvFvyFA/5/FZ9KHI1qu7i2DeA
	 f/E2XzEy/mCot2KFpMVSR2+Mjwnkfwk9DcV5TudepBwqe3kUX8PnIk5U/T6SaGTymJvsk
	 jS4y9BXLbcQ/2RRTPqFrZ0DBQEtXq52ylsq/s0WZ5f7j1A8iXtVRMVVZS244yyfw4hRu8
	 FS3ZZGib5QmuzentqVALdFVlTsmVLn0su5qPtSO+Opk/xlpTgXUhmmtesmz7IrrVHDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794747133;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=KParxGsc7XRf1tM5678gFtw4cILsa1rzhE0kGfy39CY=;
	b=VGG3rxc3ZhDaKanPHTKF4IZQdtXmSqTShZj/Uu3/H1IhVSIk9UJbKB7qPTHyTmRlVLko
	 QGsBKQaHUbn/xo/+/UZtcGMYG3NCzLGJFabpzez0Jxl8PKn0jk8f2G1JqfcgYm9lgDcyh
	 iyThAdVhDngAEtp0+kjHosq9oO+gGtIrqnU7ss+MSPOHw6H4UiTbwgHJsxCRoo+K28OTd
	 +1FkpW8Ew1GKTgaRG36l86d3p8dHoWw10ox8AvtOhGh0s/QYucMvXMuH3x8EDQXBCJtCR
	 6iUz4umoE5EoLQPiekJGIi9t7ZqfIdsW41e57qacAHPNGqguE4T2ekbdZfmRfvrw26w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S+kj1pyJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE90606A31A;
	Sun, 15 Nov 2026 12:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S+kj1pyJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508DD1F000C4;
	Sun, 15 Nov 2026 12:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794747132;
	bh=KParxGsc7XRf1tM5678gFtw4cILsa1rzhE0kGfy39CY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=S+kj1pyJzfBBW6hbKdfqruu/v61PhCNuJ+vgYrJkiWd7msnFgARmlXfbIVQ0OxYcG
	 +KVTNTNUvkj+KitytSnTu3DP8dv68hRbh4hT6hUbrh+xABUIHUdgSMh5df7CyYMnM+
	 pzO+xAXJzmSJ8aAl1n1mY3rZEP7L1xndbFwcrQa4DqjCm2i1EFRFcJcOLvpFenlLdh
	 W3vS5s3+1lDR+ZA+Fb8qvy5atIUobJ2qycf+SHqlGlkbQ7Tn10tpFeo7hbEiQNIXG/
	 r9+mB8JfAMbLtRKGgUUVSGuSx2hzC+f2N16Dr4ImjyaPqbXwHnwqhe3fLUPONBWob3
	 J82sSPAWavx7w==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, 
 Junyoung Jang <graypanda.inzag@gmail.com>
Cc: Jeffin Philip <jeffinphilip14@gmail.com>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261109200330.2361828-1-graypanda.inzag@gmail.com>
References: <20261109200330.2361828-1-graypanda.inzag@gmail.com>
Subject: Re: [PATCH] RDMA/iwpm: fix memory leak in iwpm_add_remote_info()
Message-Id: <179474713016.1305087.6552754506457256588.b4-ty@kernel.org>
Date: Sun, 15 Nov 2026 07:52:10 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 10 Nov 2026 05:03:28 +0900, Junyoung Jang wrote:
> NETLINK_RDMA accepts requests addressed to kernel port ID 0 from a local
> unprivileged socket. The IWCM RDMA_NL_IWPM_REMOTE_INFO callback has no
> RDMA_NL_ADMIN_PERM flag, and RDMA netlink routes this IWCM opcode to its
> dump callback even without NLM_F_DUMP.
> 
> iwpm_remote_info_cb() parses the six required attributes and only checks
> that the local and mapped-local sockaddr_storage families match and that
> the remote and mapped-remote families match. Four family-255 addresses
> pass those checks. The callback allocates an iwpm_remote_info object
> with GFP_ATOMIC and passes it to iwpm_add_remote_info(). There,
> get_reminfo_hash_bucket() accepts only AF_INET and AF_INET6, so the
> family-255 lookup returns NULL. The object is neither linked into
> iwpm_reminfo_bucket nor freed, and the callback returns -EINVAL after
> this allocation side effect.
> 
> [...]

Applied, thanks!

[1/1] RDMA/iwpm: fix memory leak in iwpm_add_remote_info()
      https://git.kernel.org/rdma/rdma/c/4b14bd5d913b16

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

