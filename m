Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792604846;
	b=TMRgKSQq96q4+Tza1lRv2vXJfDd1M9Q6n4ovhefcHB/E7iUMs92L9T9fr98cLXbHKIC3
	 Tc/F/eHFUlMOBeVvC28HmC6esoTz5uBd9zI7Mds1pSKnk4+JVvpAmRaGYX116US0QepAQ
	 LTBTIJbH8CTQuLy/S9MGn1UsQqJRq5mQfCK/IAz3jCQCG2/ri6+jqbdYT+M3qkX+gvWmN
	 iVQnXSZw/wseMqEk4SYgkWON9n6kkr3luNV1cLPWhKqx3xKmm7ZO9R8UR+b9luII1FK0W
	 lKoZvMYzfLXX0xNGXVqiCD0rrkeO+s3q7eiX8xuASAMv/hXFPEf0vs8gmA0jMGcaiOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792604846;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=tgpEDFefa4L+JiauSXAxe5PDuRfddg5fICbSIt3jPAM=;
	b=YO/5fi/cqOMDxmq19iqULt8U6y7iSyR0o0OjXT+w2fXQCFXDgnPm3gu3C1r56PM8zgHi
	 J31NP99Dw1Fu6cFZHkTeNR75SuCyxXZx7/nc3r0AWzjQFwSvs/GCeEjOFcnNAH7a+z+bm
	 Hqw8PvP9OUDHKoTIo3LDIDU5CshHA/HRf09kDS6A4yaYchIKL/Fu+KsKcqwB88MyaTX32
	 Hek3cyHM11r2MG4bMMFz4Z0VqEGFPr304ZKvCkt8H4v4uL9WhUfI71Rx4FzcB+wxOVPDo
	 l1W+Pvp1CJ3vTWue971dr1p8VVQ7Dh+BWdSAFAtbELGPBmJyV9IHo6gLpBJO8eUBLdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eaCvm3SL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDFA606A319
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 17:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eaCvm3SL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA5C1F000C1;
	Wed, 21 Oct 2026 17:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792604845;
	bh=tgpEDFefa4L+JiauSXAxe5PDuRfddg5fICbSIt3jPAM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eaCvm3SL7oldSmfk9dfkYwOZd9YdT559XkwqnHzR36Lltic6WDP5jiNI7qcK3Ka2j
	 PwgHPcUzGeHo9maxfTv1mTyu4FlD87nJh0aOvtv/yBojgl5Lj8dAzalWQxcth1w4XN
	 3/c61ZI2F1UTiZTKUMkqk/eYldA3TLvZsoKFFF23rHQM35XLq5kq0sYkR3d+TGrPHp
	 SH/KyHeqzeBD4wvySU64lg6zRGkQ3VjlRqvRX0aFhZyHAFJvu4fSWyZrkpNACHnY/f
	 jBR1G2u+SfSGhkzA6JvAoVJ/wnWKggka+dX0Vbl1bjuhkDhn4EAqmomJOD+FguOWvq
	 eG+S+ZxXD5HoA==
Message-ID: <sashiko-outbox-180530@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5e: Fix stalled channels with threaded NAPI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261021-b4-mlx5e-threaded-napi-stall-v1-1-d719c17b3ec4@toxicpanda.com>
References: <20261021-b4-mlx5e-threaded-napi-stall-v1-1-d719c17b3ec4@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 17:47:24 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> With threaded NAPI an mlx5e channel can stop receiving when a burst of
> traffic ends. It stays dead for minutes on an idle machine, while the
> connections hashed to it time out.
>=20
> When mlx5e_napi_poll() has more to do, it checks that it runs on a CPU of
> its interrupt's affinity mask. If it does not, it takes the affinity to
> have been changed: it completes the NAPI after at most budget - 1 packets
> and arms the CQs, so that the next interrupt moves the poll to the new CP=
U.
>=20
> A NAPI thread runs wherever the scheduler puts it, so with threaded NAPI a
> busy queue takes this path at nearly every poll. That costs an interrupt
> for every 64 packets. Worse, it counts on an interrupt for the CQEs that
> are still in the CQ when it is armed, and none comes: the next event is
> raised by the next new completion. While packets keep arriving this goes
> unnoticed. When a flood stops, what is in the CQ stays there, and is work=
ed
> [ ... ]
> interrupts taken during the flood halve.
>=20
> Fixes: 29863d41bb6e ("net: implement threaded-able napi poll loop support=
")
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021-b4-mlx5e-t=
hreaded-napi-stall-v1-1-d719c17b3ec4@toxicpanda.com?part=3D1

