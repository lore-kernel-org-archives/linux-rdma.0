Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826885;
	b=NsrdNVsm7axEqGawk11frE+gqYpCu5uEiQrKP2hYrfqNNFZ/rKQfgNdy27js69mITZJc
	 Z11pOe4zDHsY4YMPkOxNTpb0nj87ehKoJqwt1tV6pNrGe3VNhxyTLJuzdF5n+a5x/P5qp
	 2kuuNutjfmHvL9Es+eTrIqE+OQg5SgviPPRDKDFbqxXWe9mcY+9gpQrRe5bPnhF5u4GVk
	 NnZmrnVAuhyRJeXG2gPqtBLu4l9VjI6wYhXlFvjJ0+fNwg9zM/M9SDHKUsRE9b311tiYb
	 8HqK2ZAbIA8aVo/cIxMRF+5cPjqRbkSrXKYDmqQ7ZS88NXBI3EP1cunfNGsIsEA0eog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826885;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=nQ8e6ehzvYJlZhRSDOk8gRwlYPYabildh3BMTFmhRG4=;
	b=fQmbh54AYDc0YT7DP41uxbJ1VJDJ4mXCtO8oh9Kkm0LnZFigNDJlqkeZVQOUXKQfdg3Y
	 ckDu1sgJI7P2QzOJmHRwmR6S7RIe8NGzcdT4041yQdA447a8+IsYZwOMVLZ368j1t8YR5
	 yiqayeFpoYXNTt+LjWsKNnLSVRV0dpcMgj2OF3QSO70Iyezjnmoo8n5vbOY3u40fF6H45
	 DjpV27bgvef/Fm10NCQ0hqCtXhEf/i42q240w6Utv3eyDB0eKr1hKhWynXEVufhqDLGOc
	 lgB2DL1R9fwjF5dDkwlWpb/bE39j6T2OgqSuZC9Fo88W3AKNgBRRaPv8Vl4C4vRhXXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R4o7NBT2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C58607267A;
	Wed,  4 Nov 2026 21:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R4o7NBT2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E281A1F00A15;
	Wed,  4 Nov 2026 21:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793826885;
	bh=nQ8e6ehzvYJlZhRSDOk8gRwlYPYabildh3BMTFmhRG4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R4o7NBT28cTNCMG7W/LeFyFbE4spwq9E6Co6SUukRiMQm447plAI9hZ38wbQctWcf
	 PsCJb/JcwuBVxBGix1pOiZu/H3M3Dthup+rd7lkHTE2TLJe0DabrbYKT5Ra9HEadIW
	 kczNOJf+Mu3/htgOJ6Txwwrf9Z4vPD/kd3neR4R07Lgg8CmK/UEUO6y0n4RXPgp3jP
	 DdemafHtXqWphQsgfJkprfM3qMoXZAANGcb22e9ReLWQS9iwF+RXC+2urxPka+W6+W
	 Z0U6LLC403i5LHscns7PEDmLYoXrAHsKnXeY6fnH9ygF7JUY0WbFWcHrhcwI7kyus3
	 9eybjAKuFdkXQ==
Message-ID: <sashiko-outbox-198070@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 1/5] net: skbuff: skip managed zerocopy
 frags in skb_frag_ref()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>, virtualization@lists.linux.dev, linux-rdma@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>
In-Reply-To: <20261103211424.127627-2-almasrymina@google.com>
References: <20261103211424.127627-1-almasrymina@google.com>
 <20261103211424.127627-2-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 21:14:44 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> skb_frag_unref() and skb_release_data() skip releasing references on
> managed zerocopy fragments (SKBFL_MANAGED_FRAG_REFS), whereas
> skb_frag_ref() acquires a reference unconditionally. If skb_frag_ref()
> is called on a managed zerocopy SKB, the acquired reference is never
> released by skb_frag_unref() or skb_release_data().
>=20
> Skip acquiring a reference in skb_frag_ref() when skb_zcopy_managed(skb)
> is true so skb_frag_ref() matches skb_frag_unref() and
> skb_release_data(), and disable share_ok in iptfs_output_queued() when
> skb_zcopy_managed(skb) is true so iptfs_consume_frags() does not append
> unreferenced fragments into a managed zerocopy outer SKB.
>=20
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103211424.1276=
27-1-almasrymina@google.com?part=3D1

