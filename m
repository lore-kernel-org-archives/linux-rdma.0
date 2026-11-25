Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795582681;
	b=O9dK9hI4OgIRsFk+CnLMDyme3dGCONjR40tD7ZJEdP99iBNmqXPmxFFUSZZ5IKZY1dfc
	 m2ZfTl0SfpJG/7un/49wM/xuSZhQlz8BZ1fpcS1X4j7at6tyJbCTmXPUyz+OC6M2fASBl
	 oFbSrSadqhWG0jKKqJkslVXTn+6/PZrbsmKP6Av51fPOZ5qEa1271qvVPJMtbOPi/VjC2
	 MvxrBZ/uOyM/+jKCNZ0KpftsSfE15UEDVO0m5O49QGmYwDTSTVE/y2S40D77GfxSNoLSu
	 utpYYhWf9Y+ey6AQhoRoltbUcaOpX4omWUqi0yltVPHp4X2xo8MI6QRF2LpHcquVv5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795582681;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Yf6kIbFF2cs2VKmiW7uMv0sVztDeBkfj8IeEZl7uPYA=;
	b=Sb8M3/1c6xTPf8aXwi5M79w2ei3jnVBXt5Vvq+KYu1avO0crK3zhFdX+en5ejGWbMmzR
	 o/bfWnXCjj5cAIU3pGCPg0vydo4cgTbSOwnpmTEYIyjp5UFKU8UPLgCyRwjV8MXt5J3uV
	 tiJGDOD/jKS2CctaaxCQ0H9v4+WhvvQp58anH8JxqjMSLtt3G+jnyOiJ58u6TsaM54Bwl
	 LX9jI1qqDeGplDTtHwMNm6ZuMepIRgpiAC/OJpzfeXZPitBfmzXvJfqca/tbrzQacqOMO
	 TxxbdBNpt2AdJEFaDBOYPUR3uDakGuDi/j/+aUfgMSnIFjni96gNbMYO2UmoyuEPh/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WRT6rrjN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C44606A31E;
	Wed, 25 Nov 2026 04:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WRT6rrjN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776E31F000C4;
	Wed, 25 Nov 2026 04:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795582680;
	bh=Yf6kIbFF2cs2VKmiW7uMv0sVztDeBkfj8IeEZl7uPYA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WRT6rrjNcJOSCgm18h/xPnTG1OGsXdJxmkbFRQMJx55KE1N0489XAi2fOJoAW7Hg/
	 6E+6tIGnbigLEWnUmnmyF3cwRomzCtGvDMtLirHPJ1VOO2nzyCPGUvJ8wInKfbbgJ9
	 rsIw3+kubHy/z9TyzZqwG8bACeAW11d1tIuO/3hK9eG0agbsVE6w3at/WoHuMaPnG1
	 ZJIyphLs5gclY20Vyi/fg90G3AN/SBbF88yCRQC2+8FG+gYUqAmoV1qslgW5qDkw9V
	 UsHtO3ix9Xnh0fc1XXMyg6lvAnAymXVs3PidgHomrizjuBQkCJAY7FOuyGwRmHUQZh
	 lMqDDyGH2tRBQ==
Message-ID: <sashiko-outbox-232599@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH bpf-next v2] bpf: Reject sleepable struct_ops programs
 without check_member
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sechang Lim" <rhkrqnwk98@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261125045105.2326120-1-rhkrqnwk98@gmail.com>
References: <20261125045105.2326120-1-rhkrqnwk98@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 04:58:00 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Any struct_ops program can be loaded as sleepable, and it is up to each
> struct_ops to reject that in check_member. tcp_congestion_ops, Qdisc_ops
> and smc_hs_ctrl have no check_member, although the kernel calls most of
> their members in softirq, under a spinlock or under rcu_read_lock(). A
> sleepable program attached there is entered through
> __bpf_prog_enter_sleepable(), and lockdep reports "BUG: Invalid wait
> context".
>=20
> Reject sleepable programs in the verifier when the struct_ops has no
> check_member, and drop the check in bpf_tcp_ops that is now the
> default. Qdisc_ops init and destroy run under rtnl and can sleep, so
> give bpf qdisc a check_member that still allows sleepable programs
> there.
>=20
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Sechang Lim <rhkrqnwk98@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125045105.2326=
120-1-rhkrqnwk98@gmail.com?part=3D1
