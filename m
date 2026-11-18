Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022032;
	b=IzYaxZOre6iVU9zJYov0ltp9dFrfhkM+CZ53bnUpPvnabh0qplXsa/9kMUon6w67ZMaY
	 sGBUyud5qEFds3dQbzkDb/WkINdn0TKy/tGAHrgW27iazWUMEz9g6aLhPXzEWyo4RV8/G
	 cn7KjXsSJCQfTYKGMu+HH8Pn34RxHtTZV3K3i/fBBP9zxeCL27SiQ5K2T5igHiXRJoTTv
	 NYc0uk8DdmIfADE/vk6t3zwAwPcH0fMP/F05xBPZAJebQEzzrvD4l7sN/dWkazhgacYzE
	 bXgjHxxqySUKY6xJ5GyaY3Jp0FuIUZeYm/pbU/+hdZCrElR5Zkq9G/uzmSe5Lwq+xNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022032;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=LcVU98PipCTReQ9k2cl39M2aKcPu9KqveMAzmNqSEhQ=;
	b=W52DkcNtUuePaXz3aFCJ59kzJiK/ZJBqGU3uMAUPNhtEeYYmyPkdaftDAUdwxnaDqIES
	 /uKOwirp0i+n7/6GtKN6sdQakyapUaki4TWkIvjWOUfBh87N3BESMKkijXuc59d44jhSt
	 02qlJ1eiFb6B/Dj1JdInTaOmDd9aUwwL85pG+2kS94Mh9Hm9UhVXcWK9m5009mkvMPnHX
	 L9cCAATQMeYDBsX3g4pE3thdDoVg0hUJGJzD26FApV3tteXi1ztqgaTfdWaJ6ZROEzE20
	 vLXy6ghjS8ARfpEn/4kmCVWgmlm0r8AxpWp80Rdt9IZuQHKHfZhq8vUJLFxT3a6Nyfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dmhGaQmz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC4260A2613
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 17:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dmhGaQmz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7AA1F000C7;
	Wed, 18 Nov 2026 17:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795022032;
	bh=LcVU98PipCTReQ9k2cl39M2aKcPu9KqveMAzmNqSEhQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dmhGaQmzGyocU+AvUG8Pr6Ktt0McwUVeRD7Ky7nqZXawT/fHU6FTXROox2XbFygBu
	 GPKHitLGPzrxXBpDLkC8MkVea41bVW9oGZxI0oSll5hs8WT+ce93kPejR4yIeWsoYi
	 UcTH0EAczdGY5tBDqbrwepJjgD5VjHnTQtS7QNgrtwNiCbV8YeTiiI5SCgukbdITjv
	 0uX2s3A9dyTauw/eSYFknfFRatas8qMk3lYJTZoJIcu73cpUvj8kWa6TnDcMhLZYHF
	 wMJydRjT3fKZpIBIMvdTuZE/qRShXivhQGGyTRTjE8DFlZlxk5EynSUqP5kyJVc3Fs
	 XzTZIfNe9DCgg==
Message-ID: <sashiko-outbox-221619@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V2 rdma-next 18/21] RDMA/mlx5: Clamp log_max_cq_sz shift
 in CQ size checks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117170914.27410-19-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-19-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 17:13:52 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The CQ create and resize paths check the requested size against
> 1 << log_max_cq_sz. The cap is 8 bits wide, so an untrusted NIC can
> report 31 or more, which makes the shift undefined. A large limit also
> lets the rounded up CQ size exceed INT_MAX, and it is then truncated
> when passed on as an int.
>=20
> Such a size also overflows the CQ buffer size, entries * cqe_size,
> which create_cq_user() and alloc_cq_frag_buf() compute as an int. A
> user CQ buffer smaller than the CQ the NIC is given then passes the
> umem size check, and a kernel CQ gets a zero-sized buffer that
> init_cq_frag_buf() writes to.
>=20
> Take the limit from MLX5_CAP_GEN_LOGSZ_U64(), round up in 64 bits, and
> reject sizes above INT_MAX. Compute the buffer size with
> check_mul_overflow(), as resize_user() already does.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117170914.2741=
0-1-yishaih@nvidia.com?part=3D18

