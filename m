Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795750007;
	b=YX24QfVO+wectWBnowJmuItdKodoeRLGEsxv3+DVr7cxegaWlJbOayKGqemljFoDQSQR
	 1yWcqhxSAYatcHkfwDNLEo5GHO7/cRlFcIfdjEoqQqk2ON3qGxxX1kFE8wjMbz8jKxANb
	 DiUC1PWBpuIVu+96icmIs7fGzvVPdim7PpNijFP6PUQ7H+SeLd2EuVlCQIYMTmBzmhySj
	 eu6TM6oK055zxYzlPTXwxNyScKymCHMH/lUAChdI/27ZmdpTxODvsMggTLc4gZ1GKyzS/
	 MdpsuXVfhNjJt2sslUqn7lyyodhhcy+3SKPhHOuQAi4Y9F1HMgOzTeYAA/cbU+nOcJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795750007;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=AidAI+a7QOu/h5AJZg3F8Qjo+SbCrYRGo5IJPB2FHWQ=;
	b=tz4BZWnDFzKdteEZRhPoETZFCK1MljidpFd/HJL3eKoqFpNcKQDA2s0Pwu6JOawQNdfA
	 LlWRwZb3ndtoUpvmpUT8HyyNTd7vmRrX54fbf3DflzVEXoxcdvUK5pejioaGqs1oMVdVj
	 mSeRn2SNYMsfzMFO2IoY+klkeYmxoI6hVLtldES9/7Ome0W5Q95lPx3I36JwJHRGsUdKL
	 WR+OpnPJvNA1ZUWHPgoaLiWcQtcaxTZzuAtJduAiF58hsP92Jacn+4OUsQrAZOOuiPvEY
	 Mu67PN/1v8Y2CwXB3qHJji13i7FPX3w0tI1Cas6XWMcr21sAxXzg0sCrR6ZGzY/WnZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C67iLB0j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D78606A31C
	for <linux-rdma@vger.kernel.org>; Fri, 27 Nov 2026 03:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C67iLB0j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1A31F00897;
	Fri, 27 Nov 2026 03:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795750006;
	bh=AidAI+a7QOu/h5AJZg3F8Qjo+SbCrYRGo5IJPB2FHWQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=C67iLB0j7T2PgxFuxRwIZtnQNgCV8aoV80ay3K4i24O7x9+A/4TNlYVRe8aesSfjk
	 J9auX2E+pqPwixaiD8wvoDTeCbetPdHtNZPUC2esRBjvk7n4O1arzQozeE7v0xlAIh
	 9w8YPZ1yNnGUGiPBJNLEnJ9fzCvPvyOWZT2TFzkFX4Bpkm+2WzmrOFpnpHCHVqAmrV
	 hbmps7w5tvDjOZxCfkbKw/H9UsC9zXw5A9pQEKGAH3hh08NJk9bPoTzEiM1Biy6A1e
	 hhLFSOd0nzlOn9ueLFHiCSux5PTQOf4+BpVCtPadu+xN0jcj2QKpUnHALl2eHs5QuO
	 HpOHWi2o99uGw==
Message-ID: <sashiko-outbox-236528@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] RDMA/mlx5: Preserve DEVX objects after failed output
 copy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jaeyeong Lee" <lee@jaeyeong.cc>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <179574905000.68536.2524255610860968331@jaeyeong.cc>
References: <20261111105346.3220427-1-lee@jaeyeong.cc>
 <20261115135123.GD42525@unreal> <20261122103715.51731-1-lee@jaeyeong.cc>
 <179574905000.68536.2524255610860968331@jaeyeong.cc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 03:26:45 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> A DEVX create command can succeed before indirect mkey registration or
> copying the command output to userspace fails. The current unwind path
> destroys the hardware object directly, ignores a destroy failure, and
> frees struct devx_obj.
>=20
> If the object cannot be destroyed, it remains live while its software
> wrapper is gone. A later event or cleanup can then access the freed
> wrapper.
>=20
> Mark the uobject as containing a valid hardware object once all state
> required by devx_obj_cleanup() is initialized. Return later errors
> directly so the uverbs abort path runs devx_obj_cleanup(). If destruction
> fails, rdma_alloc_abort_uobject() commits the uobject and keeps it alive
> for another cleanup attempt at file close.
>=20
> This also routes indirect mkey registration failures through the same
> cleanup path and removes the duplicate manual unwind.
>=20
> Fixes: 7efce3691d33 ("IB/mlx5: Add obj create and destroy functionality")
> Cc: stable@vger.kernel.org
> Signed-off-by: Finder16 <nakamurajames123@gmail.com>
> Signed-off-by: Jaeyeong Lee <lee@jaeyeong.cc>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/179574905000.68536.=
2524255610860968331@jaeyeong.cc?part=3D1
