Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794827504;
	b=iWvkfnq8HlmYuXrfltuspiaVouJrpdVntCk+07E5fF4jDsYMn+mQL38cLUYu4QqGaZoW
	 MPv8Cpg9LOY4VSQAyXq8B6JTn4g5JeuibhLWSpVP75OJjz0dXdRx/7JmW5VDWlHgd2dU8
	 EcHiK9cwMZj2YLJJZSzANGf33K36FzzX35+1xQ6REvVeXk2icwrulH76erR4GiIAPJJpS
	 O/+o1FDVg1DreF2WCxE3mqL5XTC9mmvl86/ZfFxKb5n8giZVihRwd8JGfDyLyB5WIu+2q
	 ha5JdPjFdvTULJcbMz9btnlFBe1uKSClAg8+kyFKPwgBSFjqIuY7AFtpPoWX8X9lUJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794827504;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=2tLTj+r6wC0R6/1wbZaMQxXGmT3+7HPCMpRKANnpgZo=;
	b=b9LzOHFHiLppZE5gbqVOiAp2jrzo20hhk4i0xt4eM3mFKQXSTvQ7AbJzERsG3erPD1Xc
	 KQPEEmhOzAlZtajN2frWoKuYhqNUFwQEGGAXEvJDahOvTYpObsSl3zh2C8PSjGnabU8Ti
	 TSFoYtjjMDFjqqubRKz+mZpz//+eclFSvIVsa9Xk131dnqm4ZfVtgTw8T7BN/RTD7GBnx
	 fceddJj+alHyAyiCKXwtAeygpEPJEaQ7DoaC2rPX7jucvWuw05Rb7LsSY9wYV/NAqf0C/
	 8drJ8TRCT51u6yuBbAArnqgxIKee0q6xAGVt1SD8C12PKegO/YqIInMmHoiVrnA0ORA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=chG06J7y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96CA606B181
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 11:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=chG06J7y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C8A1F000C4;
	Mon, 16 Nov 2026 11:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827504;
	bh=2tLTj+r6wC0R6/1wbZaMQxXGmT3+7HPCMpRKANnpgZo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=chG06J7y3VeyZzu1ATJE36Kd1e1QDDA5o4Au/tGGUmAO7UY+u725yn/hYhicxT/2e
	 hnBMSTDQ0O97SM/XLSrR43b/5pFKlTtnv2n6JWkuixWLUaU9TfoVqyQgXZlrsK3Zgo
	 NQAgSQf3KalJn0fyWoD/8Z1mEVa1JQVGOjiSwSbBeobv2v6heUt9S7KTW9RQZSntX2
	 cm7FdJ2kjcNE32rDwKOYL1q5NVSNSOwr4JVomS1n4UaVweRT0UNVyn9uX+Q7wnyJob
	 QKKj4vxX1JrPxTHVQu8XSRdFUAznQYMAYXL0oJZr+M0LmFLCHFpVHGxQL+/tbTaXHD
	 kOIKvNPSmCMrQ==
From: Leon Romanovsky <leon@kernel.org>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, 
 Jacob Moroni <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261106221201.2266301-1-jmoroni@google.com>
References: <20261106221201.2266301-1-jmoroni@google.com>
Subject: Re: [PATCH rdma-next 0/4] RDMA/irdma: Fix SRQ completion handling
Message-Id: <179482750126.1347292.4390960033258834142.b4-ty@kernel.org>
Date: Mon, 16 Nov 2026 06:11:41 -0500
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


On Fri, 06 Nov 2026 22:11:56 +0000, Jacob Moroni wrote:
> SRQ support was introduced along with GEN3 HW support, but the kernel
> implementation contained several bugs which rendered it unusable for
> kernel consumers.
> 
> - The QP handle was being loaded from the incorrect offset, which
>   would cause a crash/hang upon receiving the first receive completion
>   for an SRQ-associated QP.
> - Similar to above, the CQ scrubbing logic was scrubbing the wrong
>   CQE offset, which would leave stale CQEs in the CQ for a QP that
>   has been destroyed.
> - When SRQ CQEs were scrubbed, the SRQ slots weren't being released.
> - A NULL dereference could occur during CQ poll if scrubbed CQEs
>   happen to be in the ring at the time of polling, due to the NULL
>   check being located after the pointer was dereferenced.
> 
> [...]

Applied, thanks!

[1/4] RDMA/irdma: Fix QP handle assignment for SRQ completions
      https://git.kernel.org/rdma/rdma/c/9a03e15b77fc74
[2/4] RDMA/irdma: Check QP handle before decoding CQE errors
      https://git.kernel.org/rdma/rdma/c/3f816d67f9bdff
[3/4] RDMA/irdma: Fix CQ scrub for SRQ associated QPs
      https://git.kernel.org/rdma/rdma/c/890a47493ed2c6
[4/4] RDMA/irdma: Release SRQ slots during CQ scrub
      https://git.kernel.org/rdma/rdma/c/d1de1f3056c7fd

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

