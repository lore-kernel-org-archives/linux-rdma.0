Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793389552;
	b=GranLquAoxVuluDMsY9gTQbnfDo0tiuQcVvBxbKLvclRr0/+o0hE6pVanxrjrdlQwz44
	 uvAboPwscJ+WUnXjxWUXaOCOTa3BYZM620l62ueelN9xl+MGvYh1XzzRq99BQi0JUab/G
	 Bc4/1j9ZAOe13oEd4D3Ef11eyrD8QuubBjw+fDneBgG4JZ2mLCiyO1dwAZtuxKtFXIaGV
	 dSyjZJMt/EdDr7aJFGAwi76AkiuOijJksH5IhEraUTc5KeOCyhrIr5+9vgm240svouBVr
	 bSvwPMzxOnCjMh61BoUzd3vMfg+ULFE53KRaJgCZXSvnv7fT/GLsCAnPzi8JlEMmN4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793389552;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7ei42KuVHWl8ysQ4IHCJtfc5J4KRI9MNtYPuX9gqCRU=;
	b=1tOwgWqIn2C0wDsKpQo1M40QnuIV/jdUTgR3VPMAbadPyxOLjSEr5Q6t7MyrQKY+NtVl
	 eQ2nYP6cjN2t/WO+bKPqcmV6qvvsU0lyBeMW73l1pHmCrWNVrqi0mk/4zfCYiLW6plEmm
	 zsKq+6tNdnVQKuIjytJYvYEdyKiSKeQvJ+ejh6vE4NNd5inAeMvK5GvPPYAdnbBcW2qal
	 oK+Ak+ulrdfpuNzFfucymcOlPkKqoPP1xNL7b6SV6welGD9OfkLeKbKr2GrreHP75MP/u
	 NSOPxbyKY2PuhTOvTd6BKCUYhjm+Ip89HcuHAxO7KDVdydK/sirol5D+B7nLbWeTdjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j3ib3T+A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60AC606A31A
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 19:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j3ib3T+A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED3E1F000C1;
	Fri, 30 Oct 2026 19:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793389551;
	bh=7ei42KuVHWl8ysQ4IHCJtfc5J4KRI9MNtYPuX9gqCRU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j3ib3T+ARqXBtTRmYh/SL2yDTHIj3KmqHYagw9a7I0WCLr2stDW85MdW54Ihs28js
	 QhJHp3y65n65gUfmtOsVRxwi8J5f7kBQDS30H6tPw+HPxndmGPbpDseETFzyUQKn7G
	 LyUE16zXTa5PjmxL+AS43MO9iKSoVsLuPxTKarepGng2YkMY7TnLB38uF5DNhBqDBO
	 bQlWVJxA/ibVfG2e7pBqy1HzeC90rvrLClvy2ZM/UhZpJe4V1oz4Xr7yr33f9daE+E
	 vM3PPjchMBR1t9mIJJsaRGEYcyJMceWYNbSUn1p3X+i4JDKHi+byseq6jpP0gBa418
	 zJ1jPD2TJltmA==
Message-ID: <sashiko-outbox-191453@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 1/2] RDMA/rxe: copy send WQE to kernel buffer before
 processing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tristan Madani" <tristmd@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261030193235.3470653-2-tristan@talencesecurity.com>
References: <20261030193235.3470653-1-tristan@talencesecurity.com>
 <20261030193235.3470653-2-tristan@talencesecurity.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 19:45:50 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The rxe send queue is mapped into userspace via mmap. The requester
> processes Work Queue Entries (WQEs) directly from this shared buffer
> without first copying them to kernel memory. Userspace can modify WQE
> fields (num_sge, sge_offset, SGE entries) between kernel reads,
> leading to inconsistent state in copy_data().
>=20
> This is the send-path counterpart to the receive-path fixes:
>   - commit 22b8fbded65b8 ("RDMA/rxe: Fix TOCTOU heap overflow in
>     get_srq_wqe")
>   - commit d6ab440240a04 ("RDMA/rxe: Copy WQE to local buffer in
>     non-SRQ receive path")
>=20
> Fix by copying the send WQE to a kernel-private buffer in req_next_wqe()
> before processing. The copy uses the full queue element data size
> (max of max_sge SGEs and max_inline bytes) so that both SGE entries
> [ ... ]
> reset, or when the QP enters error state for flush.
>=20
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tristan Madani <tristan@talencesecurity.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030193235.3470=
653-1-tristan@talencesecurity.com?part=3D1

