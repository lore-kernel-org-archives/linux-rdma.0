Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795613350;
	b=uQad/LvjV6Q4e46tjSULk7vu5qdMtQnXFLX7yDKyskAZtbjl71VOEt2fASbI5HYorrpw
	 Z0vIkuddwtJoY7KrxV4blFzAL6T7BzKBG2H8Hf0ezGd4TW/xL/983t+pcrcY6Wzzmc2HV
	 SOIRapAd6QKfhbjC72f7+w7j/FTvtPpcf6lKdH1FbJOHSwKZAYah10IS9pGsPfWszC6o4
	 jm0ZA3ZdBi3qRZT8ZFYRQAXz4OsqhBTN8GRPM7xjmxyYfTyD5Uhuw67hi0VqA/nzpyFb8
	 qapftwf8riFtWfzuIPXgfOahbWqGq1e3mE50n0B2qSzg9Iy5YzRoFz62RweEoqzowfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795613350;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wD15vx2TZrfNZLxZbQi6vAMv4VDm1Vm8mJRiAFPoM1M=;
	b=1bC+6/hPLNc8ipcG143xdYBJ7IYAPdcqQMB+/34uz74xYHurT9E88YZ3cc9xbEJ3AGMl
	 LgHNF6rpnT2CtIY7ZPDeG9fpDrQ5E20h0ZcBFbSpYX1KAhjGqpjjnj1q3hRdqBXsh+LMT
	 yW9IXY+1rWDV6h3nRQtjgVoXRMWpU57qjASjuWAF0JxA6k9l54roeO5YANdeLx2sR9Bhw
	 1tCzH5UJjz2PSTPR7CAFEkjFPvWkgqjaTWU/OndBI0t1FY2rezj/K/+9iqgmd/H+u5zZL
	 jvqcFwDR+0L45H/5CA5Dumynpc/tWgnR9M1FYZM/K3FztTH8SwYdEsV4xZtBM3UKnBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YXU3GWo9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDE1606A31E
	for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 13:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YXU3GWo9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842AD1F000CA;
	Wed, 25 Nov 2026 13:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795613349;
	bh=wD15vx2TZrfNZLxZbQi6vAMv4VDm1Vm8mJRiAFPoM1M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YXU3GWo9pbpTSrBrL4C2v1+hRPhHaNaTd2/Sb6XrwsUySS8pL8jdDZgr1f0ciF5Uw
	 NIE0atnKPZerV7iAiriw0Siz3Taq+6IKrPXiQjysCokL5CBUkuls+Ysw3hF9XmqXr/
	 atekUVed6juZh4Z3BiD1gSaOwBzT7P+MAWl3uHby5jnM/Q8tHIe9fcGvv7+Rp3EPfC
	 Zp1Nnu+lyRcG5rVoCN0jSTxyMQxWwC58PHdr5p3VaHdYpq2Z4htkEBogl45kpG1w95
	 q2BP+QEdQxn9SaL94nyUWiXG5mjDf8/8WVBh8p9TFev84UVEwduUBNtXLfQVb6hrJT
	 DRNNNNnXfnsOQ==
Message-ID: <sashiko-outbox-233491@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-rc] RDMA/rxe: Zero the AtomicETH compare field in
 fetch-and-add requests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Stellman" <astellman@stellman-greene.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261125132605.44412-1-astellman@stellman-greene.com>
References: <20261125132605.44412-1-astellman@stellman-greene.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 13:29:09 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> init_req_packet() fills the AtomicETH compare field for compare-and-swap
> requests but leaves it unwritten for fetch-and-add requests. The field is
> eight bytes in the transmitted packet.
>=20
> With init_on_alloc=3D0, all 200 fetch-and-add requests captured between
> two rxe devices had nonzero bytes in that field, including printable
> text. After this change, all 200 had zero there. Compare-and-swap
> requests sent their compare value before and after the change.
>=20
> Set the unused compare field to zero when constructing fetch-and-add
> requests.
>=20
> The issue was found by Claude Opus 5.5 while checking rxe for other
> unzeroed memory, as Zhu Yanjun asked in his review of the rxe_mmap_info
> patch. The fix and this changelog were drafted with OpenAI GPT-6
> (Codex) and reviewed by me.
>=20
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125132605.4441=
2-1-astellman@stellman-greene.com?part=3D1
