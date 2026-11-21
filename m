Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795232927;
	b=NOe6srliqpKWS/FxBogADt+/2UpVbBwgZkwLAf4nxEHTAEL8vIGzxolcgxD3B91YQXGZ
	 1wf+HE0Z2+zPOo2fvXNqEPzN1y+r+ZItihlOpRrnS6cGP9Z+eOCF85+2dEuuRflNs5+Qf
	 pmgTg3kL/X/M/YZSchFlspqQpCb8XJ9GkI/UGv+KSO93ZrulOvwC+3K3+feeTjnpEIQKd
	 9Z82vzgL3sL+73beeHeygTAENSOriuRd4Ryffo0EFWv6Sg4ny6ngY3E89p2rKjd30YTSw
	 uRHDYmAodWZGU/0TxFxhYer770Yzsp+BjyVAxk3S+MNlajfkMyrSYad4InHzbdraX4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795232927;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Ep6rJ30FnzbXtPf04LnPdd/K4OzVo4HGBvseiYs67Z0=;
	b=Vd8pUOvNlXqZtzzgMGuZqhwsA5nw3sX3i7YZ3+5GHUwKfydC8Jx0Iz+i6thkYnv8iDkZ
	 s549ch/MjHXeUkxGTUR5etC2cere04S/URfjIC/pLMfkfzusqtJ5SOar1ZKxgpp7WWbRF
	 YNx/E9HsN2Yrv7PM7hWwNPj9Rsq0FiGnGkHEgGUnH7VTv6Pdjm0zIeUYfIPE0LeUMn5M1
	 I+CkPW5Gy8jojwHwF+t5wfcO6ieuBPTUgepq/xla/gpGMYZOfg9rb62Ewp/iKGFNBHaTa
	 nkvVqGQYNrNC18uHiD+Y2QnadY59JEuA6cSlqur7XHbqGuij2qKDf7k/pOJw7Q5Ps0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yzfq40tB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C07606A691
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 03:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yzfq40tB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0EA1F000C0;
	Sat, 21 Nov 2026 03:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795232927;
	bh=Ep6rJ30FnzbXtPf04LnPdd/K4OzVo4HGBvseiYs67Z0=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Yzfq40tBN7og/bLF+0Y5L/aQuKddnpcrwW8qDwMExI0brKhy2ulVy5N84jJ1c9/jz
	 oTfcbYl4azIflIRuQae46+Yr4e2prDzsiIp8HhjIMMEaKwvgfBddJrK54AbPp/bOBO
	 p5IjHOx7lXR2f6zUJwBV1rol7zLy9a5YFuprqHZo9yL5+syuiq37ygCgDzKEFyB83A
	 s6celgNv8U0cnw86V1XHek3heYeanxsUuIvdZlddPHuz8pxDx+xAjgcDhMmqY3fL/R
	 778tiShLjAvxq/iQO53v5A7Js0owpRIOPVnDqOBRM0SXtcQtuCAm/JStHuKB0fLAwG
	 2PNEekZkPQMjA==
Message-ID: <sashiko-outbox-226603@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/rxe: Mask the SQ producer index read from user
 space
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shuai Liu" <847807867@qq.com>, linux-rdma@vger.kernel.org
In-Reply-To: <tencent_03B85262EE136CEE83D2012CA5F2704D2008@qq.com>
References: <tencent_5B9FB1BCC8EF36C5E2128B7D4D54B867480A@qq.com>
 <tencent_03B85262EE136CEE83D2012CA5F2704D2008@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 03:48:46 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The send queue producer index of a user space QP is stored in the
> queue buffer which is shared with and written by user space. The
> requester reads it without any validation in req_retry() and
> __req_next_wqe() and compares it against its own local index which
> is always masked.
>=20
> The requester stops processing WQEs when its local WQE index equals
> the producer index. If user space writes an out of range producer
> index into the queue buffer, that comparison can never become true.
> Once the QP is put into the error state, rxe_requester() then keeps
> flushing WQEs forever: the flush path advances the WQE index with the
> masked queue_next_index() but the producer index stays out of range,
> and each pass calls rxe_qp_error() which reschedules the send task,
> so the loop never converges. The send task holds a reference to the
> QP for as long as this lasts, so ib_destroy_qp() waits for the QP
> [ ... ]
>=20
> Reported-by: syzbot+fef38133c495aeb48297@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dfef38133c495aeb48297
> Fixes: ae6e843fe08d ("RDMA/rxe: Add memory barriers to kernel queues")
> Signed-off-by: Shuai Liu <847807867@qq.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_03B85262EE1=
36CEE83D2012CA5F2704D2008@qq.com?part=3D1
