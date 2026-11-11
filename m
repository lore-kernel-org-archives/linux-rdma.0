Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404818;
	b=XSTUkNG9xFZf2HAG2/7LBqMdI41A6X/8vmLjxwSNfZMgSQBFUi5dhg5S4qHbV9wwiW45
	 cFXgH3qCpipbmSajJY9QOm3+4JZ47CQ0b4XANuWxTRA2WnamLdgKAjOGcyusQ7aWW9p8P
	 2bih//XE9nTg7N08F8TORl3DrsJz3aOljqfu2eYusR+zsFo7jBY1tsZnn8mdtW0hs9xkY
	 /TdKZXRA+QFcA2ZUiTAdGb0Qzkwo+Xi1EU+5+GTcmA1yQYCgw8TPoc0HHHaSJp3QJX73c
	 IgIjCCruJwoiGuFxJK0nx4TkXOL0l3bXSKg6ljEWPSZOLi2PLzqwyoyU6oCchFViA/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404818;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=TQuzVm87ZYxfHwkcMQvHzLi3YhYJyRYqwTR5xMdCxds=;
	b=VA5BDgHOCiONz/Nf8FDM89eVcHNjA1Vkcw4o1Teoi3QjQ3c/1+9MSQ4WXVA0H8iBk84l
	 sEKHnJmvlXiSTQsmXu8nObzqkvJZdaMFOjtXBfI3Jwibo9yrehED4XNFRJHWkC0nG/55Y
	 1WwDyb3Aulw0GvWkvo24sq+o9LHRue09wUWDjLErpNUXeyeXFuSMyd8335P1e5KX2y3Ay
	 qEZi6TPhKgY6bKcseupRXAOezeGsJbLIf/X1LrfcM6e7G0fXMkqawmi1W9N9gjkbmwvJb
	 Oyq+zQ729cnTB3aRdUQ84Rxt//pRsnpuAX1X9jwbRr6MvyLMGFA3+tps/+xjPwElfxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WfMhxVVC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F849606A88E
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WfMhxVVC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB261F00A06;
	Wed, 11 Nov 2026 13:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794404818;
	bh=TQuzVm87ZYxfHwkcMQvHzLi3YhYJyRYqwTR5xMdCxds=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WfMhxVVC1HzRX2SAA7vLd5vmQAiKxuecXl1j+Ar7y2gdif1Uns3LlIEzjB0flAfAA
	 HDiKXbL+7bd0U7UAVG2mEizP1pMfnPR7Z+oLb7Q6zPzsjOO2qhTFVA4mfkthRERuBM
	 PLqt8haj7ci8k2FgPmIEexT+eyBZG6UInoirPqHsPRfFTEW0wXziUf97BgSR5gOvlp
	 For91TVvHvC9/bkVKIeaVcpwNFDiD0bhdwwFWAbmNcI5JorntgEThsIPEInCz6NJzd
	 JG7LcJaDtXdo7bPNT4aZDYfLL6vDCxPPPPktw7SbAVzuX+5Zur8RgL0a/v0DUdnPdo
	 hZ93WjssiJFDg==
Message-ID: <sashiko-outbox-209107@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 22/24] RDMA/mlx5: Clamp log_max_* shifts in
 query_device and ucontext paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110134320.34408-23-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-23-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:46:58 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The device, port and ucontext attributes and the SRQ size limit are
> computed as 1 << cap from log_max_* FW capabilities. An untrusted NIC
> can report 31 or more, which makes the shift undefined. The same
> applies to 1ull << log_pg_sz with a value of 64 or more, and to the
> max_tso computed as 1 << max_lso_cap, which can be 31.
>=20
> Use MLX5_CAP_GEN_LOGSZ_U32() and MLX5_CAP_GEN_LOGSZ_U64() for these
> values, and BIT() for max_tso. As the limits can now reach 2^31,
> compute max_qp_wr in 64 bits and saturate the max_res_rd_atom and
> max_total_mcast_qp_attach products at U32_MAX. Cap max_cqe at 2^30 - 1,
> the largest CQ size the create path accepts.
>=20
> The SRQ size limit then lets the rounded up SRQ size overflow the int
> srq->msrq.max, and the SRQ buffer size exceed the int passed to
> create_srq_user() and create_srq_kernel(). Reject both above INT_MAX,
> computing the buffer size with check_mul_overflow().
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110134320.3440=
8-1-yishaih@nvidia.com?part=3D22

