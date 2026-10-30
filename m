Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793334372;
	b=ZARtpmHKcV6hsuewcdRYmmEM6SxVZYMWos+jT3WZlR9slY4irC03lePJdIk2UnYd6OMK
	 ytDKqG7zjSLhNNc0WocGn4FEmd2544Dye/2ZbxL08Jp8HmjVl7mzs2JdKLgPEN+vS20Zm
	 42S6lOZuF7yR41b+AIdmkcUULqj0KcBhKxI8reJKc/G3HEBjSpKjznPSYnFK8ZlYD16Bu
	 d8tNRCYScHpY+gk7UvVVaJpFCPsg2RpQiF01asUxWDvG8mHsAAQ0GtH/Nce6fkNq+lgxA
	 Vnl5BT5Knc1QV0/q+lNUfNzNeAaaO8XhdSMLzAz4fCC9XqljiQHhUZlIIWqgUUba+zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793334372;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8/rXq5DOo4F5pmYrmzsHI5w9UUWTePWvORsI7Xyqpwc=;
	b=swrE+n8UYm+TIY4Nu3VxAQLRupddgk80ZUWYvGbNE3TN14QFzuwsZ0+ATWAPJUOYP2we
	 7KcGdVbSI2V2iGuijblXc17bNOM7Wum9LRtKfAMpirwJ7ixSKXW2+CUTLQaDMM4MrMGSr
	 xbMZ0vbPMUt1PsZqfoiC6Qq6lCmRI46hnM+Qit8vZfbTZQNoQ+E39855tvqCa5+lueVMk
	 ZwEzHlnHLl3jIWa13RLVRaR05XS2f9hVvHmoxT5V3tjTup3m/+AbF1zLxRpVXnPTUR/EE
	 J3DDQdYkuvK8986x3junDLNDm+DsCN8QG3GcRc2qVFG6hvbS38IrorzlM0p1smXwb9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E0n7OO0C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F1E606A31F
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E0n7OO0C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28721F000C1;
	Fri, 30 Oct 2026 04:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793334372;
	bh=8/rXq5DOo4F5pmYrmzsHI5w9UUWTePWvORsI7Xyqpwc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=E0n7OO0CEncC5JiMKsLyFT1XQiSATA1zwtaA++xS5tizXIK5zL5Qlftdx1hYLb66A
	 yfg76CfmRFrGQ9V6O43dehKdMIwLysKiIBpC+i7iXPVtuI5BJScjCU55SbAsl3pKPW
	 KOY1f1I65N+1ox4fZIGIzUKNkh4IWRdUtEPZ17V/NIh4Wr/FLJ4L/ncJpp3NH9wYRj
	 OAuMtbYs5AkNvcz4G1l3RX36QR3TXVikjWuwyIWQUvpC+A6LMq2YMxTaLAbsRyZUyj
	 DG3tEtH61Rfw03r9H7opqb3ez1pqErAb8hQnbg8O7BkPWeVWBw7T58bSF/CesHJqwZ
	 rWEO9gp7IklLA==
Message-ID: <sashiko-outbox-190295@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] net/rds: Do not unpin a page after a failed atomic pin
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kyle Zeng" <kylebot@openai.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261030042110.73571-1-kylebot@openai.com>
References: <20261030042110.73571-1-kylebot@openai.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:26:11 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> rds_cmsg_atomic() assumes that a non-NULL output from rds_pin_pages()
> represents a pin that it owns. However, pin_user_pages_fast() can roll
> back a fast-GUP pin after racing fork() and then fail in the slow path,
> for example after a concurrent mprotect(PROT_NONE). The output slot can
> still contain the already-unpinned page.
>=20
> The common error path calls unpin_user_page() on that stale pointer.
> This can consume another subsystem's pin and allow the page to be
> freed while it is still in use.
>=20
> Clear page when rds_pin_pages() does not return one. The error path
> continues to release the page on errors after a successful pin, and
> successful requests retain their existing ownership and behavior. All
> four RDS atomic ancillary operations share this path.
>=20
> Signed-off-by: Kyle Zeng <kylebot@openai.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030042110.7357=
1-1-kylebot@openai.com?part=3D1

