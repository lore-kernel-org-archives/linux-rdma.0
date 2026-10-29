Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793261726;
	b=OGXGAmyR2905iN2sPTj6Wt1n6o9qkROB1ViGvdUm4r8Z+ELMg+bkTOu5qPTMYfWuC/qd
	 JcXQMOd+efmI8n1F0kXq1FQ1sqjzu6nYKBK/dFBm8JE1iCxNy99MZ+O/9czA7zAcbtiCk
	 MswwLvtyXCo0G9fXz/FhVwcjj2/++fRCyRrHK1GN8Pk/bbXNZX5wNMuaXk3i7IadKk4wN
	 +pqzaZf5WibcWdSvpbsey2AFME9RCwB34lMA3VE35iZnTQNdLeJmgNACVhdbFIP3SalpN
	 LRJ1S8K+7O2kj0iCC/QIbVO91rHM+US2ZktNzgLDJivlqYfRlrh8Vw3vhkE+hgnAYBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793261726;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8BBGghYy6NAXTQfifWhOv0WkmL0KTVbh/mY8XZqJTrQ=;
	b=5jPZMVt6BmF6K62EcYhptn7VxVls1IIqB/rrVD8NFmf+9p3img35zSpooTGIGwUP6P3c
	 cKPfTOR9lFkJJf68kQ2PMTgKEPwEq5YFqC06S76M3Piw/g1ao4IrsJ/iuIsJ5HnTJArbY
	 Ky4dd2lA3MJBnTYz5kAEDCxO3n/KEBv7r7CGkOy2FREdG4tsC/GnqY/PjNfZIj2SUc/Q7
	 MLRhG+NvKUHVXWMrWLk5R8sDe+DU3sPlT/ozFOo1g8QiNHJj34q7jFUXS+Dd9DTxIp6YH
	 TZ4qGwbt+eZUGgRDOxEhLYf0TYbyPqoBvV+1y1oUKj2SmCCKLrR2SL6l96tho9Td5Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iSJhO1yN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD16606A31D;
	Thu, 29 Oct 2026 08:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iSJhO1yN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6005E1F01829;
	Thu, 29 Oct 2026 08:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793261725;
	bh=8BBGghYy6NAXTQfifWhOv0WkmL0KTVbh/mY8XZqJTrQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iSJhO1yNIr8H2VZE1w7boDRsTuUEIXdmG/mLOBATtwR+Kuuo8Zs7RLNgIODKVRYIf
	 zV01Hr9B3BDpsaD0couDeuXSLtS2GJIL4QjAuAI9djGJ1M+EvoXXBh8BL9zdVBtaA8
	 Jz0zHVJchc7MK2lC2+jvP5t5mX/CQvSlbJcUQ8zcRgLPsLaicdxI4fzQSx54vJxtAV
	 i3rNeopyg7aPL/HOsz3A5luHDS8AP2UMYyCNgVZfssx+mzH96U0wyPUx5CclUxaHIu
	 wSdru7R9bsCd+MUYd2zigQ+gKDiKd9BqAt6DGI5yJotfVQ9CvZC+PXdQA016v1cn9A
	 W2bttu+bMCn1w==
Message-ID: <sashiko-outbox-188952@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2] net/smc: don't spin in smc_rx_recvmsg() while a
 pipe holds spliced data
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261029-b4-disp-da7f8e6a-v2-1-9052904adf72@proton.me>
References: <20261029-b4-disp-da7f8e6a-v2-1-9052904adf72@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 08:15:24 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Bryam Vargas <hexlabsecurity@proton.me>
>=20
> While bytes spliced off the RMB are still in a pipe, recvmsg() waits
> for the pipe to release them before it copies the data behind them.
> The path to that wait skips the timeout and signal checks, and
> smc_rx_wait() returns at once on RCV_SHUTDOWN. With a signal pending,
> after SHUT_RD, or once the peer closes or shuts down writing,
> recvmsg() spins on a CPU until the pipe is drained, and SIGKILL cannot
> stop it. MSG_DONTWAIT and an expired SO_RCVTIMEO wait there too
> instead of returning -EAGAIN.
>=20
> Check the timeout and signals before that wait, and end it when the
> pipe releases the data or the connection is killed, not on RCV_SHUTDOWN.
> A zero-length read returns 0 without waiting for the pipe; a
> non-blocking one returns -EAGAIN while poll() still reports the socket
> readable (splice() can still take those bytes). The wait sets
> SOCKWQ_ASYNC_WAITDATA like smc_rx_wait(), so a byte arriving behind
> the pipe raises no SIGIO on a reader already asleep for it, and a full
> barrier orders its wait queue entry before its read of splice_pending,
> so no wake is lost.
>=20
> Fixes: 9014db202cb7 ("smc: add support for splice()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-b4-disp-da=
7f8e6a-v2-1-9052904adf72@proton.me?part=3D1

