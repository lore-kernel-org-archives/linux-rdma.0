Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793168236;
	b=Fd6L/GjWbBI2w0uPBIwSg1le+UDUyL/iZYpV3tLQg9rhTS4LomAA7r9lhwSNkTiisIZ9
	 9t49AE+qkm/M3dsaNYmSGnMYjLsq2OzQi/O0glqT4wMr4CJBd+IfFnpJV+NJLWbro1wCR
	 c38pEt41BPiavOy+oDw1O3AkAf54gv7SzBERwghToEtd12L64f7gJD2FdomnajjSH4fak
	 JEQZis3+arh8Yr3q6wktPB1+k8KA4i+f9NRqSnP6QmuWLK2op6srJFiCR/wFXig3FIC7E
	 AI7lOCXRz8GSHSjiIsVQ9Lmir4fNd9grQ7xMSl38lLFQ2WgiGyt7E33cHMvFckvk1yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793168236;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0SvobhI+e9GbvRyh0c879VdQNNeRb6Hi0gfSQIqqntM=;
	b=nzCeylO/DwzdWYuZrAW000qU/Az40HQYZmJq9ta681FPa5xDSwN9HsPuXPZyD0bgPmg+
	 uDaBGcBz1pgAdh6GghD2GAKT0LyBz6mE9rzVEcRM+Uw0xPdZxDFwfwmNyFmPBIajTyD7s
	 5u0HBffO7+SpJ59dXR4jkxtLQk1QZOm9N+5wC5iD9UtS8wxmwRD0Dw86eWJPGoEyfAcUr
	 0h4uTuZ3Fg79cgWrvNesQngpT74+JKvJrepNvc7WnbVXQn3mR8zElPMJ4JH9QTLkc1/MA
	 xzqRKLv8BVKFvQCwm9Nw1gJw5WdKkJYr9MWl/zfOgm5cD2qKJECD5g+eJAm9Dqx60sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dmmzJY8X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B9E606A31D
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 06:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dmmzJY8X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814FA1F01825;
	Wed, 28 Oct 2026 06:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793168235;
	bh=0SvobhI+e9GbvRyh0c879VdQNNeRb6Hi0gfSQIqqntM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dmmzJY8XjVKvatKy7/hj8IJqkVeWXSO2sdc6wRbR9THsqp+Bey3hAjZWLo0v11Kgt
	 0y8OhEjSU4/W2j6HokVQceZEZIK+6puFefZSHfkmjlGDKyVyckMyliLPGqC0UJDJj6
	 NDhLl4M/0Xdohi4YJWIlVEQCyLuzj58diPqLTUDlXD1kwu/yhPPyuSrbnEYiaxnOE9
	 PhQaMk6/5cyW7HicDXqUeqFMXwI0Xk4bj7S+cL/YSkJalJLa/Ak0HiVTGSaKqtiBhB
	 6UbnCyDZD46TrbgIuRGB3ujfYQFdDBkCKv4lBhCgjZtGqXqHEn+RcT5g4WWc7blXIK
	 syms9FiurEEww==
Message-ID: <sashiko-outbox-187551@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc 4/7] RDMA/bnxt_re: Drop RCFW completions for
 cookies with no outstanding command
Reply-To: sashiko-reviews@lists.linux.dev
To: "Selvin Xavier" <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261028113404.33289-5-selvin.xavier@broadcom.com>
References: <20261028113404.33289-1-selvin.xavier@broadcom.com>
 <20261028113404.33289-5-selvin.xavier@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 06:17:15 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
>=20
> A duplicate CREQ completion for an idle cookie slot is processed as a
> command response. It can decrement timeout_send a second time and, for
> CREATE_AH, send a spurious DESTROY_AH. Log and drop such completions.
>=20
> Fixes: 691eb7c6110f ("RDMA/bnxt_re: handle command completions after driv=
er detect a timedout")
> Signed-off-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
> Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028113404.3328=
9-1-selvin.xavier@broadcom.com?part=3D4

