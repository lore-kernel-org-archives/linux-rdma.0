Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795719247;
	b=q28rH++CR+s0eAYxRyHG42JRm9s849c/XPLpQPw3qTH3wIWEkw4WyCeZ5QMm1e8xF8IL
	 VHXX6jvEHO7q3ge0U+lfCt8MWfuueDSwtdhKc2KYZGdT8edCpy6GTZGtOsIK1hF9LxiwA
	 cKapydk4pwNlPloRiUqFXi0zw4XIdko1NnhsHcKJbv3nC8Xxgc1MiGaSQ0WAqbVdbO+yf
	 JRHjhfLuDl9Q0KN7yNzTsWFV9z6sckseIVoidtfEGFI63bOH2ZGjr1SPCRg2rbO1Pw1Ox
	 LiinCUlUgIsn0ndWJ0My5iOUmYzFMkWM9+sLRNSi5Pi9fWlU/w2Uteg7ghkHoNwIzOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795719247;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=MePySBjN2qwi9A7byjwBZBLqFBC4PwYorwzDzkzCes4=;
	b=YUoUWjCXk3eg7NF5BFdrWLY5rRWx3k9Tgy9jUnlGmWEkCgksTF4iVT/7uPz7M68+/9vJ
	 /uvs2kR7Q1fgp+/oDUnljJjN5WtsWUej2kntf4ZrlBIuxWLs52Jm3p28556amnVyXxZhN
	 oFrslEu1t1qGFYpysHru4zlIrVIgHDbORJolJj1usvZFXc9z6iHTGB59fBNHQ5hZDgi00
	 iJUShXHwDwf7szn+bsIPxr9CM4JZtbbsosvCu9TCtRYC5J5kTwV8a2mbJMeTLMm7WJOWd
	 GUl6nCcKYzeXRZseweyIqj0WB3jlOmpoMO/JSw1SYMCcBe3psewt8APF8h8DUvITV+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AjvcPv0i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F58606A31C;
	Thu, 26 Nov 2026 18:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AjvcPv0i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33381F000E1;
	Thu, 26 Nov 2026 18:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795719246;
	bh=MePySBjN2qwi9A7byjwBZBLqFBC4PwYorwzDzkzCes4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=AjvcPv0iWwoAQXPMbEcIiQcEmWc0/pgk4WDrqSpD5UIc52uSj+RGXKzusq3Gy5eiA
	 D/AyL7mY+GRThr4LNzjJoJZ9I/B4maviZfB3yK7QUOu0bnmANKVRPPUMpN03gA7trv
	 1m8c1Ij7IE/iHwQZPFYBQzZezn1L5VTW744JjJNu96tsOop+WqdtHDskG1yTOB2OwA
	 9i0LagicCkUQvfJGCikIxUW5wGcnIHaBnVePWGG/0fbOCC5DJQUXtrLC+IThxokWSs
	 4giaqMWteto1MJKDN7eIsGGGy0XxkxUJqd3MEKaDWw/6x1uHkESMLEwBWyTJIZtAey
	 vbWcqyTl6W9OQ==
From: Leon Romanovsky <leon@kernel.org>
To: Zhu Yanjun <zyjzyj2000@gmail.com>, 
 Andrew Stellman <astellman@stellman-greene.com>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261125132605.44412-1-astellman@stellman-greene.com>
References: <20261125132605.44412-1-astellman@stellman-greene.com>
Subject: Re: [PATCH rdma-rc] RDMA/rxe: Zero the AtomicETH compare field in
 fetch-and-add requests
Message-Id: <179571924332.1294028.17142388357226815925.b4-ty@kernel.org>
Date: Thu, 26 Nov 2026 13:54:03 -0500
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


On Wed, 25 Nov 2026 08:26:05 -0500, Andrew Stellman wrote:
> init_req_packet() fills the AtomicETH compare field for compare-and-swap
> requests but leaves it unwritten for fetch-and-add requests. The field is
> eight bytes in the transmitted packet.
> 
> With init_on_alloc=0, all 200 fetch-and-add requests captured between
> two rxe devices had nonzero bytes in that field, including printable
> text. After this change, all 200 had zero there. Compare-and-swap
> requests sent their compare value before and after the change.
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: Zero the AtomicETH compare field in fetch-and-add requests
      https://git.kernel.org/rdma/rdma/c/d24184a64765d7

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

