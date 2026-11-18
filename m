Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794994196;
	b=AxlSJcLM0l4FP2hB9yDcH9jswhHj2RGvJskENWoZh3DKgJT13Qw/xIFTiDvOSPDU5veb
	 5UW7VZna4dFMTY60T4dQWSkgSQNTq6iMDAHNPMlYFa2FzvcqGilJ89mABI9dlSEhK6zgd
	 XTVswqynLh5wAy2egAqXBlim8SyvXeeAyt9YQFx3i2UnCL4xel8+5kGS5t4bnR+yhHL8G
	 rJgAEGPaWG6VAk6VIRBwkEEuQ7kAFp/fwDxLtOK5QqlJIiWksaOkP1FXJtWAIbgfMwSTi
	 tyVFocwRL7Wmxp4AD0hHNOd6Fh6pBYbGoqFQaMxSSgbg2d1VaK171CYnEhrnkAf554g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794994196;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ufax5qmt5PWLprPpO/7I8+XNZK0jxg5qQlaf3w1JPxY=;
	b=lrEV+BMUUSASrdnJtexgF0s6DNxt3mB6rGB7ydb0fJOf2za0XAl04PiY+zR/5ueCN1Wx
	 iaqzaxH1dYlMTPpnEMEZMTbBwGULOQbLZtFydgv86FcDAzVETaCNIQssgCkQWt1OIIBjC
	 TNppnRTQsQ+XTDUfiLfePgJeZiQkQ2PIAaU2PZIs2TihxxCTUHXOMi0CJ2UgRmfk2r9O/
	 5/5a4kznoWVxyjwbSWK6v0TLu/5K2SMvNASFaH/kp9sk4Nz+S6WYKVJ/mq8nly8NBotlp
	 nA9wJhIAxUjgzbEHQ731C8t963Z3gUSsNJSz/rWwrZtYpDyiQnN+AmW62Hnyta6auJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nn1ewvyY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FDD606A32F
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 09:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nn1ewvyY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3171F000C4;
	Wed, 18 Nov 2026 09:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794994196;
	bh=ufax5qmt5PWLprPpO/7I8+XNZK0jxg5qQlaf3w1JPxY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nn1ewvyYbJFyfekM96Mi9vk480OKF2rpgENOTe244ZDXwDpCr1M0sOU+OEotRZ2lF
	 g3gZUeqnyCaiKxapoKqKL0tFNCQ974K0pQ2uND0YkepCC6SwRXhrEWSNU3REqeDKO4
	 aBo7mSr/HGwpz8Apw7XPGKZZgJrtvLZ+Y1txRiNnkvpS5fyfDueutH5a+WWQ6hPlmT
	 aGG2KaDxGqvwKkhc8ixzT4VIcjPxOjO9BR3LajIwCvovT1mJHfNyNeDsx8LhUSQP4r
	 osgt57+dyQOFNocZnQxSzg2UF0kKaSkWLdtQ5M+g9WmpIy36m2V5Q8z3KjF8fWHg4C
	 GY/y7ori4mbqA==
Message-ID: <sashiko-outbox-220571@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 10/10] docs: networking: describe tunnel key
 partitioning in TC queue filtering
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117092915.255194-11-acassen@corp.free.fr>
References: <20261117092915.255194-1-acassen@corp.free.fr>
 <20261117092915.255194-11-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 09:29:55 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Tunnel key partitioning steers blocks of tunnel flows to RX queues with a
> mask on enc_key_id. Document this use and what enc_key_id means on a
> physical port of mlx5. Also document what happens to such a filter when
> its queue goes away.
>=20
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117092915.2551=
94-1-acassen@corp.free.fr?part=3D10

