Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A14C37FF67
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 21:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320677; cv=none; b=Q8heiLpKv7+FEdl9uud0mUd5Vw5cAfo/TuNs05Mj7wEXj7UDfLHtXRcjGWd3uyt0Fblqzo7POAaHLI1ts1mq5de35yAWmlGN9idfle/vD6S8Xq0DAqllnxSUQlWcG0LQbAuxy7mHhoT81F6wK463TKKr6JalGsKxqpTbMzT1mfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320677; c=relaxed/simple;
	bh=pYfixMb1dJVkz8OmMD7SA7DE+RXY6wDEBsCSW1FT/F8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Wsg+pMmWklL834e0SVMh1JtYTGQC4itHjvrrLnEopqZIDrqEH3vjLuzgQ1MR77IRCN/MyDg0QkBntRWrfVFCoCQI9zaAhDJaLKAS8pTnpfDjlswh8tD+Z+LBREwyi7tY4xmE+qBVHhhYwRzeLkVZXKfkRXaYx1s0CtdtnSRMZHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a4/stgtG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a4/stgtG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330DB1F0089B;
	Tue,  6 Oct 2026 21:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791320676;
	bh=pYfixMb1dJVkz8OmMD7SA7DE+RXY6wDEBsCSW1FT/F8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a4/stgtGbgvBr1Wv1c92Rm7AYS+uBV4Vzx4YO+sh+q+xSwMQYKH0g4uY6PrVenuZg
	 svV6Mxb1pqcE1sXPU8beBkeHp8YGGpS5ZvmkhN5HP2UT38JoGTxQVniq7i50CfV/Ql
	 iT8Uzi/1tfGC3H6UA7CSu6FSb5J6qAxEllAx141cYGxDJlABRC88BsnygROE+vfjQ/
	 ZM1vEwdhj8dlfpPTk60DjJzpS5hjX6uvb25lQJ2gNtSOurpwWF8eW5iiuONLyOX/Kt
	 Ta9NisN86G1ar63iMYtnWmcpLFV19Qlvk0reoCziqD2ykKK6ND9wKcr2VapR3lOb3Y
	 oeMEVmIvdc4sA==
Message-ID: <sashiko-outbox-162446@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] RDS/IB: validate receive completion payload length
Reply-To: sashiko-reviews@lists.linux.dev
To: sungbyeongchan <tjdqudcks0424@naver.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261006205204.1322102-1-tjdqudcks0424@naver.com>
References: <20261006205204.1322102-1-tjdqudcks0424@naver.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 21:04:35 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> An RDS/RDMA peer can declare a fragment length larger than the payload
> reported by the receive completion. The receive path attaches the recycled
> receive fragment without validating those lengths, allowing recvmsg() to
> return stale bytes beyond the actual payload.
>=20
> Validate data_len against the expected current-fragment length before
> transferring fragment ownership. Disconnect and reconnect on mismatch.
>=20
> The issue reproduced in two clean QEMU boots. A peer declared 4096 bytes
> while posting only 16 bytes, and a receiver under a different UID obtained
> 4080-byte tails from prior messages in all 256 attempts in each boot. With
> this change, the malformed message was not delivered, reconnection
> succeeded, and a subsequent normal 4096-byte message was delivered intact.
>=20
> Fixes: 1e23b3ee0e94 ("RDS/IB: Receive datagrams via IB")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: sungbyeongchan <tjdqudcks0424@naver.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006205204.1322=
102-1-tjdqudcks0424@naver.com?part=3D1

