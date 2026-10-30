Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793386588;
	b=5sUR0RdWn9bFujEJZzfaMeYQFpFJKX0Ac1o3Jcq0qKHsPGj5boPVrPs+Q+oqPX0oDnop
	 2EHN1YCcPVMe4KYNkpH8MPxA3mfRqQQ/7sP9A54wf7PV4oF4htxfyOgvsfIv2b0ws3Xt8
	 fkfXi4QYg6Qnt8U9vIOU++urIrlzGQdb28dygUyU9b8dA4zz5YG39VHVDGbjH1mJ5L8Vk
	 wpe5A+yKcMlqZLyKThcIX2CMqgQclDYOnqrZv91fPGJj8v6RqxS9vZQX/gZ5wEkbnC0Xw
	 A/jUs79GAnNmuwa5BIDcrL371ROMgC+TDUQokxy3vp1eaoEEAxP01D3xGm/AxLjaxPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793386588;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=k8Pa9NLdnXH1CyE/sN603/wei2PwiO8Rp6erhHESQF4=;
	b=C7jpe0gvpia/bqz+JS7pLNRlNDbnTqsMgkqjcJ1KmVYJkM2jt8kq1/UGJloXUdrVWtS8
	 jxwcGC4Nn2xfkx3EP/aCdGnt4EhwMwv2V2463RaipULbgb2LBN9rmUfotbSjIlrsqKs3x
	 O4EGlAL/QfvAFLngr7aXH76IWSO0S75YEERynI2q0TVhoUAYDvb7mPFyrMTwGEmV98uKi
	 FB6VPYlbkfZNCh2GfLQq1eFD0Itu80i61mKIImXse9t8oZnQsve0JWuzyipyUZabeG51a
	 VqBXyhbxqeLm7IHeODoR5OXB9bRlEBwfPmfqAJw+pA7jM+WgR/i3AwCUKht42Vp3Jnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eZwT1a1N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EAA606A31A
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 18:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eZwT1a1N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FCF1F000C1;
	Fri, 30 Oct 2026 18:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793386587;
	bh=k8Pa9NLdnXH1CyE/sN603/wei2PwiO8Rp6erhHESQF4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eZwT1a1NxCT0CBkvDFp9a7v1dG4F01L+l7PZ9TAOWuVt3aTkoMHPjwBbb+whgMoP1
	 U/33hjd2t9x/Asi2fmQEApPEyuRAY0ii/asKK4mIp3V4H5AWrdVQbvsD2uc148ORVA
	 57lg3OwN5asT8k3s1voKjeVVq5g5vGlKWqomOIvoRyaGQq+vL87DTRz/4gAY4Y+7Jo
	 YtUiRmpmC//aDrjev66WO5PSxoUWSYkY8UGPC2zOPQt7ghr9m6aEg+dt1248rEc5A6
	 n+ZMlUOQRMxnMaASqFFWSI5Ara3l48yRFFZJiDzihlXNMNMbzHVDnZjqQggjosaPD1
	 LL2KtnI/ZW27A==
Message-ID: <sashiko-outbox-191426@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 2/2] RDMA/rxe: copy send WQE to kernel buffer in
 completer path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tristan Madani" <tristmd@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261030183409.195671-3-tristan@talencesecurity.com>
References: <20261030183409.195671-1-tristan@talencesecurity.com>
 <20261030183409.195671-3-tristan@talencesecurity.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 18:56:26 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] RDMA/rxe: comp_wqe_valid cleared in rxe_requester() before struct d=
efinition
--

commit fe57a6fbeb3985861e302c45b7aad80d47e4ce81
Author: Tristan Madani <tristmd@gmail.com>

RDMA/rxe: copy send WQE to kernel buffer in completer path

This commit copies the send WQE from the userspace-mapped shared queue into=
 a
completer-private buffer in get_wqe() to prevent TOCTOU races, validates the
opcode and SGE bounds, and writes back DMA progress and completion status to
shared memory.

[ ... ]

> diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/s=
w/rxe/rxe_verbs.h
> index 0fc6c69f4f840..ddc195c283326 100644
> --- a/drivers/infiniband/sw/rxe/rxe_verbs.h
> +++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
> @@ -130,6 +130,12 @@ struct rxe_comp_info {
>  	int			started_retry;
>  	u32			retry_cnt;
>  	u32			rnr_retry;
> +	struct rxe_send_wqe	*shared_wqe;
> +	bool			comp_wqe_valid;
> +	struct {
> +		struct rxe_send_wqe	wqe;
> +		struct ib_sge		sge[RXE_MAX_SGE];
> +	} comp_wqe;
>  };

[Severity: Low]
Does the previous patch in the series ("RDMA/rxe: copy send WQE to kernel
buffer before processing") fail to build on its own because it references
qp->comp.comp_wqe_valid before comp_wqe_valid is added to struct rxe_comp_i=
nfo
here?

In that first patch, rxe_requester() in drivers/infiniband/sw/rxe/rxe_req.c
adds:

	if (unlikely(qp->req.need_retry && !qp->req.wait_for_rnr_timer)) {
		req_retry(qp);
		qp->req.need_retry =3D 0;
		qp->req.send_wqe_valid =3D false;
		qp->comp.comp_wqe_valid =3D false;
	}

Should the qp->comp.comp_wqe_valid =3D false assignment in rxe_requester() =
be
moved into this commit so that each patch in the series compiles cleanly
during a git bisect?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030183409.1956=
71-1-tristan@talencesecurity.com?part=3D2
