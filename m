Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792682157;
	b=JB/lt097UtjWbXq+ijN9kC5m3a/jykZitNeIjwev3x0aYkuQoGxVC3puOKmnke1UbenJ
	 B5zpUjHfvMnEbkKiW1OMrdY5qiXVexW64SsctX/cpdMOAjyeS6/l8+g/eQvyxKgfxwdiV
	 75qSGpiCTIEIa/rJy02gu+GprcRaSY7slk8pVp4SAGdYjeSFSP/u9iNXpEvil4mu2Od7A
	 GPvYvq08cUmOmAC+1JJceQkOYAkAHdf4Lj4/mnCiXA3hdibLyPA5k6t6MljVupT3u9Kuu
	 MhF5xgThgKhP2xpEWrBuRzD/Iv+A+rxNhyo+3myBzs5oeUA8H+HTLCvZ+C//O+iEECA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792682157;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=f3L9dMb2v2QyNELC1ri7+Yj2mEr8lm4JSmLE4gS0cN4=;
	b=Jn3LCKZSnH2lS43kzbXhHSTetuhbeVv+ceAmWR79dYlh8fPmaEAWcFdg+A7XpCfCzTSr
	 TCf5/kmN+HiNbub8Qme/BGznnvqnPjQH5lfZynxDGN5RIjD1nGi3n6xRjA+yR1ftmeV/A
	 RVs54viEa9TR+JL5O1ffsvH99zqg718j4a/jv5KETCxkw9cL6/J3kjivJT8ik3Y9uPQhX
	 TJ5x/QgGWr7dapStYSb9rLdNwac7lQUF2+i2eln7w+gi4IrV7RYzWY3GU8zY8G0blFu8O
	 pysQ7bY8KFc9nhOv3Q0o5MftvCEV23O6XyhW7JADjYGDL0bjTeQNCnmF6DPDEoN0vLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N0asKZ5H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB80F606ACEC
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 15:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N0asKZ5H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936CE1F01828;
	Thu, 22 Oct 2026 15:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792682156;
	bh=f3L9dMb2v2QyNELC1ri7+Yj2mEr8lm4JSmLE4gS0cN4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N0asKZ5HvWsfq2Q+qmuZz5Bw2zlIIZ+GvWE1vgUwI+9YDW6CWywixkv5kdBgMGoNw
	 9O0vou7G7fSAyDL2gkHmwlelHdy58D7lzMJ7r2ovOLxCzL0ZkLDF1OZQ/VB+LDkFeF
	 TF64zDtCK/AY+C06Ju2drxGh3t6lTLOBE22g2Ph2J1GZFifOV8T4BuHQpk5XukVwSf
	 caH5x+dOSFrjBgd/fHMcNO21C8ZDXPefMKj5NgbGvhGN3b2PbZumt7egct4qUKM7Xx
	 bk0LcJIrhTOB26SHBjR8issGLSe+UrCYUrqEeF5OFJ1fs/2PNK+oHE54jgKYuqguCS
	 qFVOompF4Zi0g==
Message-ID: <sashiko-outbox-181682@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v9 3/4] net: mana: support concurrent HWC
 requests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <fc5fddcaec1b88c4f366f446a336fdf738c0031e.1792679388.git.weh@linux.microsoft.com>
References: <cover.1792679388.git.weh@linux.microsoft.com>
 <fc5fddcaec1b88c4f366f446a336fdf738c0031e.1792679388.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 15:15:56 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Long Li <longli@microsoft.com>
>=20
> Give HWC message slots separate sender and response ownership. Initialize
> each slot under the inflight resource and per-slot locks, publish its
> bitmap bit last, and release the slot only after both references are
> released. The per-slot lock also excludes an older duplicate callback from
> resetting or consuming the next caller's state.
>=20
> Serialize SQ posting so concurrent senders cannot corrupt the producer
> state. A posted request which times out keeps its response reference and
> slot until its late response arrives or teardown cancels it. The bootstrap
> channel remains depth one here; the next patch selects and allocates
> larger queues.
>=20
> Wait for a free slot while the channel is healthy instead of imposing a
> [ ... ]
> Link: https://lore.kernel.org/r/20260914175044.2a26bb46@kernel.org
> Link: https://lore.kernel.org/r/179196575640.434549.9102950927041409151@k=
ernel.org
> Link: https://lore.kernel.org/r/179250339266.3135.15035365058593192217@ke=
rnel.org
> Signed-off-by: Long Li <longli@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792679388.gi=
t.weh@linux.microsoft.com?part=3D3

