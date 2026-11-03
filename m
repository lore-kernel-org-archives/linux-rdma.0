Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711893;
	b=2J30KJzk6a66eERuHPgId5y9fU+mw12HEo0RQF+lajtfWP6e4J8alzlNLdDPmNXSKxUF
	 7XaOakxlCCjnQBHVpsikDAuu7QBPEN7gzFD4Jbb+yeFsvkoB9s6eG+3o4P+t4zjtTflB7
	 ItbCd2mVBXy6wJ34crAh4FhFNSS9loFmWg5MeTrhl7l7bZtQgPWdqAJFDAiz5rGK7M5qs
	 mpudjeL2Vg7FxHKM8qtQxcMboIrabBFZkaHleKsVZ3TO5Lksgw0bnzHsn/lFNGWfK6JqD
	 qQcTYHvBVLrvfKOLZd1SFgva83PSZcmfXSAMKSpWAOiNhYLfdzauaBZ6AHf6QPuazHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711893;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=ushLv3HkkPJVTvOvdvA5+y8nCKa81DfFRU2rVsOBlOQ=;
	b=mRhJGbbe3C5D/jxRa2gepht3u42Pn8XKklXbmmjUf4herID5/TkF/eQhPyXDVnnanVRO
	 kyr8Zn0b/ZF6P7HMYAhyzL2rot778w8v1BfgzT6jKuSZ6YUVT1j7mRdZLjqoWQolDp4lZ
	 KonpLuq4eloHr3j8ndfgff+UYvPKVC357Qsr71QH5twD3F813WReUTGHsD1K0+K4YPVTD
	 umWN1E5HdO26KjVSIOBCKaf3pZZ2HWVs5t/8w2LiqJ1mtCRsyIrnG7ZFFapyjEWAqkJQy
	 Z5qX4iYEDi6Rn2ynhYoaCwKYDk256PtCYpto/EeapxyCHqUbalnU1gyy7lesLl0hb6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LZWm3bAc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5A16082BC1
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 13:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LZWm3bAc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D491F00919;
	Tue,  3 Nov 2026 13:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793711892;
	bh=ushLv3HkkPJVTvOvdvA5+y8nCKa81DfFRU2rVsOBlOQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=LZWm3bAc49U3w97Sdfm2PohuThupHNbwbGYH/8Qr3P3jq9OZFsNxcTgb0rW+Tlwfc
	 VDCNVw1om6QKmo+Lzay/iW8NjBun9cemH/aJeJN8y0s/S4kUKdBfauT0rh9j+0jevr
	 4R14rF6bJccHyjOcAi8QqQ/p9fxLlh2SzcgLOO3MU1F7apUqHA1bcNE8FNSrP37Hcr
	 25fYfR3vCKjWD9LNMWnTBgY0+zGCRo8SJ7OiYOlVkEQd90XJ+dlSPu4b3yQzKEjUFu
	 f7IUj4ieOR57vp0OWIBEGbpv16CO+vpdNZ1tdNQDBNPBKJL9ioIKXHH/oMvxjDlzan
	 OklncOqm+eg0w==
From: Leon Romanovsky <leon@kernel.org>
To: yishaih@nvidia.com, jgg@ziepe.ca, Jacob Moroni <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261029132740.1169950-1-jmoroni@google.com>
References: <20261029132740.1169950-1-jmoroni@google.com>
Subject: Re: [PATCH rdma-next 1/3] RDMA/mlx4: Fix stale umem and MTT state
 after rereg_mr failures
Message-Id: <179371188983.1725532.283949415885384209.b4-ty@kernel.org>
Date: Tue, 03 Nov 2026 08:18:09 -0500
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


On Thu, 29 Oct 2026 13:27:40 +0000, Jacob Moroni wrote:
> During rereg_mr, the umem is released in various failure cases
> but mmr->umem was left pointing to a freed umem, so it could end
> up getting double-freed when the MR is finally deregistered, or
> cause a UAF in ib_umem_check_rereg() if another rereg_mr attempt
> is made.
> 
> Fix this by setting mmr->umem to NULL after ib_umem_release().
> 
> [...]

Applied, thanks!

[1/3] RDMA/mlx4: Fix stale umem and MTT state after rereg_mr failures
      https://git.kernel.org/rdma/rdma/c/a7ff66ebcb81ab

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

