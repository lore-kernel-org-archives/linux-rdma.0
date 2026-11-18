Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039291;
	b=cAbIU7kMoG1sqfHoI0sqayQEEV6o8NzJWocWqg8CkiOminlZGGrJFWVtPhdQb+qYi4ew
	 bqRzPpEN4KMcBTMRMdQjQrYMGltUhD1Brc1NoSrH8/lFfe9PtRq/QYkJmb3s0tZ0h0wvY
	 5On54Z3IEJZFi2ysRnd8i792GP5GyoQv84fr4Y+Z7vcnxvXhdTGUgUxnJECby+DpRiDZz
	 6kQ0E8VCxmICGwwbd3jcF7CK6KN9o5HmqY4Dl+NGYWQf5ynzf0Ii8baaS5tuswa1npYmV
	 /PFvbQsE2UVak3u009ltKWQRl8itT7kwnhj+fjQ5Fpaq8fZuuCz85Kew49Zx6WdCSdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039291;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=RSkoZ7fWh6qd2FOn/wdjdkoClef4q2B/0lY3RvT4LfY=;
	b=Fay/d1ibj3ZUV85iwMd9RCgV3MlnyFp/Pab5F/sLY51fcYs93LjFSGnKpJP4L9G08fX0
	 lt2bPJKbhuDiR9tB7rs2lWYm4sOGNaTeyBHhwjQ6TOsarXDP1EaNwONf7DnqHjviaklr1
	 ZHku91u8wXCh+fLNFQm6DEF2Y40OAdxERqv+XOmbks9Aim43SkHkvAzvI2EShK6QiDask
	 Y/1IewqvNsU3ourVnKGHU4RPIjdaJiCfdUIZ1LBCG683uEXItsdYpAkw9i2/uB9zjt/+P
	 +LmBdLwu300tEDIzkAnttQYFqPsLl6llrZNcN/D85CYOKW24JK41Qy6c1w65i1zGY8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mvNfkzkZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48535606A331
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 22:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mvNfkzkZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2901F000C4;
	Wed, 18 Nov 2026 22:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795039291;
	bh=RSkoZ7fWh6qd2FOn/wdjdkoClef4q2B/0lY3RvT4LfY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mvNfkzkZjYTCsFKwEf7VpzBQYgKP7ZFikLX5bYD5/M+XSvWZdnEJSadXHHPg+NGx/
	 9QMIB+csN2l2EwjaGas6lzJfaHiFOezNgSJy/MxEe/FcTcXTlSF+8rQzvl+GRACUiB
	 jD5yqdWXu/nF3A5KCe8z+MIeXWmvB5yqAPZ+v29YQXD7uA4MbRzvNJR2dDmywF/cF8
	 DHW938WZ6P9yu83E8AgMPBTNUriQODNTFukaS0vWG+q698TJSXvkftt7sWqWLrejsc
	 drnFc2Xi+y+oIgVZcn2Z6zAe7y7mnSY/1bkA+KiIt2BHXIQLFybSspOtMkNIk2VvEJ
	 BfouZs4YFfuBw==
Message-ID: <sashiko-outbox-222066@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-rc] RDMA/ionic: Wait the device command timeout for
 admin queue commands
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nikhil P. Rao" <nikhil.rao@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261118-b4-ionic-rdma-admin-timeout-v1-1-39536999a3e4@amd.com>
References: <20261118-b4-ionic-rdma-admin-timeout-v1-1-39536999a3e4@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 22:01:30 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Commit ec8ee714736e ("ionic: stretch heartbeat detection") notes that
> firmware can take more than 2 seconds to service a device or admin
> queue request, and is only expected to complete it within the ionic
> command timeout of 5 seconds. The RDMA admin queue watchdog gives up
> after 2 seconds, and a timeout resets the RDMA LIF, after which every
> verb fails with -ENODEV. Wait 5 seconds, as ionic does for its own
> admin queue.
>=20
> Fixes: f3bdbd42702c ("RDMA/ionic: Create device queues to support admin o=
perations")
> Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118-b4-ionic-r=
dma-admin-timeout-v1-1-39536999a3e4@amd.com?part=3D1

