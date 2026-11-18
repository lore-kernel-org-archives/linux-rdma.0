Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022030;
	b=Rkirvoe84AZhsc4bK1QW3uRLPZZfr4dhVGWAXfks1obYD2B+xFFJdDgYHuXqWDFw/5wH
	 dqBd4PN9P0DctU5rO27LpRntNvxmSA6pXe4S6JhkESMUdctjfzFqRBqxxqIY1V9ae68xz
	 K4NSjVRcQK08UK/ukAeFoIDNsXGqZcoms1G+OudeJHQd3FWN90fIQju157jK2ei753pzL
	 r8rckl5cKInH5cuokemHsjmOVJPlbL8l7AqH+bB1+SQjv0uxUVni2rxMlVhg/QZnD9Za3
	 al13zcFJ3vXGSBDeXel4DGLQgu+7aQkpSpg7vVKzFOg/KCHID6hDa1dfdTcXrOuuQIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022030;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=XRLw+jAk34Ve0WYJqHCoHBIGswbL2dgKV7fZxizZBLA=;
	b=FqtePeB9c8xR44ek7ZE9uZD7TtN6qvWVlQO7yUpiglL10QYGNtrdS5VWpPtcsmR/qu+e
	 YUqfvynPM8fQCeLy/jAfQAT4KjtpJTvd5NTCW0fC8iM6LT52/a0fYXUwzstp5T/fOLH5y
	 V21ZsOCalJKosVDsIrVOBLNuZurDttYL5tVrwF5iAO/MGlqRP3TmXOJPpIipIcZrjRC1p
	 kPudW8HuD35Rl2/5mkjpOZnqQfgpvsLqUkg9ftee43TqKJMVilsOCRv9Rk8xQPZqrHZTN
	 QVse4UsvYi655bIHFailrjLDQBnBu4fW7rMdhXslqsk+gvnHfVnWFEfCNIuYjFlj/Fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WGtcRu7T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E4460A2600
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 17:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WGtcRu7T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9399C1F000C4;
	Wed, 18 Nov 2026 17:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795022030;
	bh=XRLw+jAk34Ve0WYJqHCoHBIGswbL2dgKV7fZxizZBLA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WGtcRu7TgcUlZcwEfrIgiN4UdSvfyOwbNBO4hY/ZdM/0iBasnEOfbVUcGazq2Xs1j
	 it1GCdIS3E46siqRWP6o5uSEHniIsAJKqpUXimFp94a4IU4SrOyBYUW1DEGOc51Z/9
	 VS7dG0mv3I+1nIEx10UmIEEYNHZ4+el7xczMeIIdHKZ0aSZfS2QkY/PNKtQ0dJJouC
	 CWfmYNGXdT5OB3qKzOuNfu8+nuN4YFWoY4HiTCKiIdB57Kk+hXMcNjuWlqQn6Fu7lT
	 RdIsM4Iig9yQntwiccU4oGafWEbCDKEry13OjFLrIU4FRKLRoAYryCkEpxyUGMCSFc
	 3/KUjP5ZV4sxQ==
Message-ID: <sashiko-outbox-221616@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V2 rdma-next 15/21] RDMA/mlx5: Ignore completion events
 for a kernel CQ that is not ready
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117170914.27410-16-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-16-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 17:13:50 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> A kernel CQ can be reached from the completion interrupt before it is
> set up: __ib_alloc_cq() sets its poll context and handler only after
> ops.create_cq(), and devr->c0 has no handler, as it is never armed.
>=20
> A trusted NIC raises no event for a CQ that is not armed, but a hostile
> NIC in adversarial mode can. For devr->c0 that ends in a NULL call. For
> a CQ from __ib_alloc_cq(), on a weakly ordered CPU, the interrupt can
> see the handler but not the poll context, and crash in irq_poll.
>=20
> In adversarial mode, give kernel CQs their own event callback, which
> ignores events until the first arm, the point where the core has
> finished setting up the CQ. mlx5_ib_arm_cq() marks the CQ ready with a
> release before the doorbell, and the callback checks it with an
> acquire.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117170914.2741=
0-1-yishaih@nvidia.com?part=3D15

