Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3A92F83B5
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 06:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789455397; cv=none; b=MoOgWTurwRC+8GKaypt92dLaiiF56Cfhnxac6o0hX590ZGzQ0cwGJDh8yn7CTv/aiidhL2PFnKBy9E823UjXTjB66Omn71Yj6YAHIN+4hLaUqbZR/1FlZRWwwPM90JiVY1OW5/5luZYXiSWbeAAE33D42TRCTCDP5C9aD0dRg/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789455397; c=relaxed/simple;
	bh=1b6fsjaQfKpAIKAXJHnjkYfuY2TaolveGAWQs2+0I/4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AXPO9yTgld7DNA8RX/tigREfF3hY0HgPa25C2lW/g1cLBQ0eYiVk0ASTC+NCQLaMLcWrU+9i0/69O3hVQEOLpfF4mSqBTQpGm5NyHd3h/rn41qdiLPIH6UhfJn7PerhoYt5GIyKkN2nSaxC9RYhDv6Lz5oHJZd25r/tvUqj/b8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bm5z7uU8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bm5z7uU8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D4B1F000FF;
	Tue, 15 Sep 2026 06:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789455395;
	bh=Q50hdTsGtgj4za0nuiRqUGNKCVc4zBDnK2n+VR7tWvc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Bm5z7uU8oh8pbseIqNKRpTfbsO7ZMW0pVIJMlTP8PCPD5D+o4nwbtHdIqsC/vANld
	 qUvCYNZuOcflLCPU3jdrge34IOwFLPBGKNV2oJa6N8RCLbznhOULaE44YFaxXvCXnb
	 EsQnChKvap01xWydj7jh+dPo25ZsMysFj2M5LzNmlXe37Ew12vjjd6foUJ2T9gXsE/
	 6op+BVmbQpARwAlOPRyRzSxdHSVtEYSwVphN5BvV24joOwIoeJEhljD+S0a6dryOx+
	 kKI/d5ikAZHdU7+oA4nyhTXFZiRaUglMPFr1qyW0BdshTmFn13KHIn8mc7Ku35yJoH
	 auXKg2jTeWuMw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/rxe: Fix out-of-range unsigned-to-signed
 conversion for RDMA message in 2GiB size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Honggang LI" <honggangli@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915064532.194540-1-honggangli@163.com>
References: <20260915064532.194540-1-honggangli@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 06:56:34 +0000
Message-Id: <20260915065635.73D4B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> When RDMA READ request for 2GiB in single WR, res->read.resid is u32
> 0x80000000, which is INT_MIN (-2147483648).
>=20
>     payload =3D min_t(int, res->read.resid, mtu);
>=20
> The `min_t` function will return -2147483648 for payload. The wrong
> size is propagated through call chain, `read_reply` -> `prepare_ack_packe=
t`
> -> `rxe_init_packet` -> `alloc_skb` . `alloc_skb` failed because of
> invalid size. The passive side failed to emit response packet for RDMA
> READ request.
>=20
> After fixed it, the active side of RDMA READ failed with error code
> "IB_WC_LOC_PROT_ERR". When RDMA_READ_RESPONSE_FIRST packet recived by
> the active side, `do_read` call `copy_data`. dma->resid is u32 0x80000000.
>=20
>    int resid	=3D dma->resid;
>=20
> This conversion set resid to -2147483648. `copy_data` abort as length
> greater than resid. Change resid to int64_t fixes this issue.
>=20
> RDMA SEND and WRITE 2GiB message works too, after fixed these two bugs.
>=20
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Honggang LI <honggangli@163.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915064532.1945=
40-1-honggangli@163.com?part=3D1

