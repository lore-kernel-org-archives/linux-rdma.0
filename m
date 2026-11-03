Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793705246;
	b=WQ+sKV1vkcwm8oFhYYVBTd98dGHtyA6Xjnh0Q01/6VV18GgxnZ2AMK7Kxcn670dNecPX
	 YbX1j+Z2z5IzmJa3gO1jB3oSFh1P5mqgOa9zs17jvm5vs+CV8B6nEKKbbLqnp8jjUAM/U
	 vOrjGiKliM5I/oELrutKHKD5UikUBAE/3HEARJMVYFrTJ2nvrzNdPqb/jeESC7DLmEAtP
	 FTSCc5nHAw4Y8xdlxwoOj+thTSIh9Ijn8gjJJN5uBhKpL2EPLvYIR32+ecOPKnxSu7HOo
	 izEmlkuBD+5nOgX33saaGQsgBHJkcJR+6RlssJvLuvlRwYUkYLbpSHAph90TZWTeuIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793705246;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=uzlPkJHN2h5ImtBjw5YG52d5Y6ERDDUOdNu5u3tyvp8=;
	b=IsJLcu6ohD5v7fUGqGV9v8Nh8/rZM6FJxCYHI4AEoJgcpCMG9N6IxJaeTAR1LMoP4kYO
	 qsWIW5l6GqNZsdsGj2G/TgtrmKTA0NeoisFRy8wpQLMvrH6s6JdUz+8cl7PwVxeMv46eY
	 W10JMnFw/ktgW4MqGfw/Dgx6whUEDf8xL9UGa5Rz3nKiZa2lXfZs88fZunn4Vl9xkdn0b
	 MwWU1ehoZ+mwqpub/w1Aa7IswnE68Ds9MqdW3UBuy/CBtYvgny1KPSjo+Ky37TcOAQJNn
	 zrNv1/hJvdl055pT4EEqejeVy3yuT0eo3r1PYAAqGmyc8dm7WCiW8ylDcZ2bPMAbE1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="kBELp3/F";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6FF606C577
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 11:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kBELp3/F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD9A1F0093A;
	Tue,  3 Nov 2026 11:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793705245;
	bh=uzlPkJHN2h5ImtBjw5YG52d5Y6ERDDUOdNu5u3tyvp8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kBELp3/Fn7D/qNRomFGRndCaQseCBruo+g8SUUTUSCkODymNJmTdw+Z2gEU8SGyhY
	 Epe0mWZSJRNItaJsZtj1iy5jrXXtY2OwjcB8vhFbT1xb2qmde/8f3XAacohZlQcEcY
	 5yaQaQriZdkaure/g2jK8GohfktjZ6oMcG3EaHffZKFbz1RCrcnxVjDQWfu9/XoQ/2
	 LN/KOe6QNvqzY8SGM4ySVXPtdb/M74y20J/r3RQ/MGha/W1auYidBULfQBr9XqAByJ
	 slojlgEsDt/CRZZRcaKRi3CAS30NMDe8lIbUaioWF2kiuSfBLkfdffa20NN4qIiD8H
	 1PnsquEKSLVCQ==
Message-ID: <sashiko-outbox-195149@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v8 3/9] net/mana: Extend GDMA encoding for new
 RDMA WQEs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103111729.729886-4-kotaranov@linux.microsoft.com>
References: <20261103111729.729886-1-kotaranov@linux.microsoft.com>
 <20261103111729.729886-4-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 11:27:25 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Extend mana_gd_post_work_request() to support extra-large OOB data and
> fixed-size WQEs. These formats are supported only for power-of-two WQE
> sizes.
>=20
> For fixed-size WQEs, use num_pad_sge to specify the padding size. Encode
> the WQE header fields required by RC QPs based on the WR flags.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103111729.7298=
86-1-kotaranov@linux.microsoft.com?part=3D3

