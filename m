Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794279690;
	b=yg69AMGX7GKnqJgnwHoNYaStrPye53xcyqQDMAwg7/oonfdb8RCGg5kcQ8QcPkVCQ/7N
	 P4VNfKH+/eN/ohw6H2L2GQUE/itda7XaJ1Yo9KDzG2nLwOQhFz24XCfGJ5+MLQ2O2ZmdX
	 QkYxLCPBSZ7Uruv/g9fReSwtAa9EnHdTHRaL6E+KFEYqlBfo3UGc0cWsLrbS5188B18b/
	 ZpzV8kFlAQeWHTaGHAT2ruxYG03AGMqnrE0f6VTw57zj54QxxtrjdBwJMqHgNQHvCH2r4
	 7eHCGe0yO/BrYqEr9/kdfnq3W12R4CQvv87rY4w+A9eF1/zE9F45e4u9MrBVt+8B9Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794279690;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6R8w0nk6faLgFIdeh7WY1sBT+J8k4u6RkLXT6k0/YC8=;
	b=2waCKMB+yS59LoqKkEEz4C2mMGlcq4g3n/YiaxkARdRh36gYQ+FaRHksjTDyOxYFEZS+
	 280Bwqr6j4gcvRhOiVsLc7/RqoV2qk1BVstR9JfWTeZinvrCqs3xrR+gvRJ6/Tg5otvM6
	 xfCmyfdA3lbOn7BWV6Pds3TqApC6/jrxJ4h/VApFsHoLF8Vz6XckabDe5FemZYq2Q4f+R
	 IVuUm9MB7nmQSnW8xULJkZhGuUBjZT0PlsZI11TfMHcXvFSwBW+0Fotq5jCP7qQlUW0Lb
	 cWtIGpYJEHRwdjJ1daIfxpMp7upk55UQN61lLE05mPXbgZETB4+9Zjww/YFQPytu0Qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oq5HPD1y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0D760A2603;
	Tue, 10 Nov 2026 03:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oq5HPD1y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5691F0089F;
	Tue, 10 Nov 2026 03:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794279689;
	bh=6R8w0nk6faLgFIdeh7WY1sBT+J8k4u6RkLXT6k0/YC8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oq5HPD1yhjpUEV13rxXEtoLT0BwqwRMqnmWCHfUJeAojEOKvWr1a2rGwLtZvXRLis
	 ALWBNYmol9krUB2j8f5hzuUsolM3Zs356MnrfEqONqqpv5hkupw0Bkyj0yYoYiq8Or
	 IwfI7lwJZxNx6hiNJJMAOvLZx3mwEOTgkeea/Y9tgZorNn3U4scT1fUewTqeLn6lq3
	 95dgf+0vMLIO2zvKU504I9YJF1YtulRt0gBYq6odwvyXaxkh8BD+/G2PzkvyJJZiR5
	 KD/w+1jYBZCN+rDAnNOxdRz7qnl7aWKR8qiRVOM3LUPqzfrVOe0wx2uZN+Rdle26U9
	 7Pb8LITus1mHg==
Message-ID: <sashiko-outbox-206081@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 08/14] rds: annotate data-races around core rds
 sysctls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Cc: linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261109025425.328445-9-jiayuan.chen@linux.dev>
References: <20261109025425.328445-1-jiayuan.chen@linux.dev>
 <20261109025425.328445-9-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 03:01:29 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> reconnect_min_delay_ms, reconnect_max_delay_ms, max_unacked_packets,
> max_unacked_bytes and ping_enable are read without any lock while their
> sysctl handlers update them with WRITE_ONCE(). Add READ_ONCE() to the
> readers.
>=20
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109025425.3284=
45-1-jiayuan.chen@linux.dev?part=3D8

