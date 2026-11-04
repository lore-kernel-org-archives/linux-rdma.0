Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793785387;
	b=mfqPdZJUm1wq1MOlluKey0V/a9s3KS9HZdZXAzW+FXcnUZkwHpu/TEe3FVNlt8wUzzlh
	 S5CDUkHarfHNsQhH4CJ2F/GMnWDF7o70xifUuJzJPDYF36U9qsIuvCI95s6aDWzXMkd2a
	 TBd/U789Sz55HvimYh4bGZpTett2pdTIhZYuI3i7DLA+bg16MZIDv0KkaFuH+OWt6Mlsj
	 CH6eQ8RaXEkandW6z4IBSsQRiltlQKbh/yz2Pz7VM+0i0ODpwoA4nOdDwrrvMpx+relGE
	 tEpzE/6gUQo5Cigo4PyeHpAJqP815DYChOqjK06ZgjyHPLDKAvv4m1heMrywt+HjoGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793785387;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=zYZlBkaaxtSkEivPZbZ/sb3nWpvaNpMXctacs+R9lLE=;
	b=1j4DhZzISf0uLtUAY5oS4pLBVQquAPLgfz0/aSoiB2Fw/7LpbATp+tXVdVY+w1xf8cSd
	 RKmOYz70N/BF3fR1ji8l8vRFt6cul/SJvzKI9Xa0dtKTQ8LvbXD13J+fShokNgmG0DZYk
	 0PFNiEmJNgl3ClD3pHu4qGL9k8Ywg7LOQ23acqQ1As/O73qNcD4LAxQqrdu7LYOjxMIOU
	 9y85iG1Dnwuep4bAPmanvM/OZVPVjsBb7vniU0MoQlRFqhhHgqIOMLJGp1S6aan65m1cF
	 Go7IVqIqKpOfAMuNe22cMn3HUUt71yEM1fr8pKYp7mlmbxnDybNybN6GCzOwR/uzqhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QF2OhwBQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF331606D80A;
	Wed,  4 Nov 2026 09:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QF2OhwBQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BCA1F00A02;
	Wed,  4 Nov 2026 09:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793785386;
	bh=zYZlBkaaxtSkEivPZbZ/sb3nWpvaNpMXctacs+R9lLE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=QF2OhwBQKKdH0laIjTXSsEdPo06vT6q/bTzDkHEHZqljwlWNGQbo9dxSmzUL7AbtM
	 +d5FBxcXv7VyzkOL6mrPx9zL2rTXgtx56jDTXNKPuCR7L0HYhODfOp/viuWmsdboWu
	 /fpGZJ1SDlndDmslj5KnPuRe3fsHkeBjJmfCmSUa1VOPRyIr5QT5CAcNsDaRqzdZA3
	 f7OTJJg1vztQyiqWegYRTjwIamyWQj3uqMuSqGRSSuOoTD43jz2xvc+ITSLxnN53Mk
	 K2MIuve25HiZ13OKcYHzL2aNjG4l4UrLpNH9VkABXERUOJ3CEQ3hkCeAMk5bNwaXH/
	 fYhr//6qeAyhA==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, 
 Tatyana Nikolova <tatyana.e.nikolova@intel.com>, David Hu <dhu@x6u.co>
Cc: Jacob Moroni <jmoroni@google.com>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, David Hu <xuehaohu@google.com>, 
 sashiko-bot <sashiko-bot@kernel.org>
In-Reply-To: <20261030173254.2000665-1-dhu@x6u.co>
References: <20261030173254.2000665-1-dhu@x6u.co>
Subject: Re: [PATCH rdma-next] RDMA/irdma: Free cq with a safer cq num
 reference
Message-Id: <179378538353.1751229.10381671766751561860.b4-ty@kernel.org>
Date: Wed, 04 Nov 2026 04:43:03 -0500
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


On Fri, 30 Oct 2026 17:32:54 +0000, David Hu wrote:
> Within a iwcq, `cq_num` is allocated first, and only
> copied to an inner uk structure, `cq_uk.cq_id` at a
> later stage. Freeing cq by `cq_uk.cq_id` before the
> later stage leads to a cq id leak.
> 
> Free `iwcq->cq_num` instead, which is allocated
> right after initial rsrc allocation.
> 
> [...]

Applied, thanks!

[1/1] RDMA/irdma: Free cq with a safer cq num reference
      https://git.kernel.org/rdma/rdma/c/e50525a486300e

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

