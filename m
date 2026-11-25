Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795606482;
	b=MAfh16jrnjERgdoAGBHkv37XREYXhOj1txoGxv/lwsokLN6N3gRN1HjafjqoG7IREUuX
	 gp5rBaeJ66iBqlJTSxWALx5fMpq2MyVocPWFyJ7yui3H8RFQjjPDvtZkAV8D1ZtJwOXwY
	 RskB5NhGIGufyRlvBvvqN1cqXwOWFadfMaSzYcZL6FFPPoKLbcI5L3Cl8xj0hRfy0v43P
	 NRFTgoQCCTziyrTWge/28PIT2lVj3TuO9pGBn82G7f4h6SIVli4pRrHGQR4xgoQHS/GUl
	 3I7WyB7CPV72Kdv8z3Wp0+H/sMP69++90krAHnSrdBVGAbIypNHDkT6UIExV2nAyVMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795606482;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=ktSTLHvEve1gXNwYhZ1BGhptqOK9oIl7eS1z9LVmb/Q=;
	b=hEc14H6ICGF2nyIlYG84MWHgiXCYNC9L9h1ZoFthi0JvxEQh2l153FjzMZUS32SqpXY5
	 L5B8wDkVWUhcK4UsKMkNzZvvY7T2Tx4zF+b166LytXbYlavIiljPx2mx5xrysTCcadcrD
	 9l9LZnCe0rI6oRRC/D9YSqwVN0KRfpofEVL6vgmiUVRuBHCl9/BrTJ2B0OVs3WaFpIe0J
	 1wN2sYbku4LFYjFB99rny3DgPJdoAhPXKhIKPvXfgutWXcFoPHSBbtuandyoWR6+cEeKF
	 /LgbeqsyL6dnB+PHsAiFCC5JGgWOcIVsl2n1sF6QuGdOqEApyEUCh6c0Ql9+VP4SQWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LOnC4tKp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7471B606A333;
	Wed, 25 Nov 2026 11:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LOnC4tKp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539BC1F00ACF;
	Wed, 25 Nov 2026 11:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795606481;
	bh=ktSTLHvEve1gXNwYhZ1BGhptqOK9oIl7eS1z9LVmb/Q=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=LOnC4tKphZUpm967mA800iScTWOxIJOUMUKTcwkVY3gruai2PLl+HtUZufRb+qJN6
	 Pv0CTIqBUDam2ySrJ8eKsLj7UeS4EiBBuXkeOrbqMp6KjBfs9kswtssrmSnv/0aNr8
	 VIQXhSIwRYoRtZVDRKfiVOGq9ESS9kyZ5+oz+IklVK7KAU1R+Ol9yALwBMJ/ZT/Jdt
	 KSftMO8qSXaJIJW5qSrtNNEGT9OGxiL/6vBoH4YFWeTzEsAhUMtgLbVJjP12QhmWD8
	 MSGfvP4WIXQqow7OZrhZJtX4TxsIoELNTaJGUFHCh+yu57TAcoXZ8rEJumH4P/7yIk
	 0c7qQ9OtdSjeg==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Andrey Misiurov <amisiurov@cloudlinux.com>
Cc: linux-rdma@vger.kernel.org, Quanye Yang <quanyeyang@proton.me>, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20261120174405.2761262-1-amisiurov@cloudlinux.com>
References: <20261120174405.2761262-1-amisiurov@cloudlinux.com>
Subject: Re: [PATCH v2] RDMA/ucma: reject a second join of the same
 multicast address
Message-Id: <179560647902.1205594.17228631928366782502.b4-ty@kernel.org>
Date: Wed, 25 Nov 2026 06:34:39 -0500
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


On Fri, 20 Nov 2026 18:44:05 +0100, Andrey Misiurov wrote:
> ucma_process_join() permits multiple joins of the same address on one
> cm_id. Each join has its own ucma_multicast, but rdma_leave_multicast()
> searches by address and removes the first match. A leave can therefore
> destroy another join's cma_multicast and free the requested ucma_multicast
> while its cma_multicast still refers to it. A later event then accesses
> freed memory.
> 
> [...]

Applied, thanks!

[1/1] RDMA/ucma: reject a second join of the same multicast address
      https://git.kernel.org/rdma/rdma/c/0888ed60df42e5

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

