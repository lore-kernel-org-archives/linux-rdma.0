Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2174E77FD
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 18:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791908; cv=none; b=Vir9hZUA4Aqu8DyXufQ9lIcEpL2fWgKlB9nnfMadzlYweKNjJe9SSFOK8yqT8lf9kMt1FW7vx2n0YtKGbkRrogxwVOjxpJUUXhAG3gTY8f0pB+XazP8IAvP/wCPfSzCmFlnbcCmc6OiciuaAHsL4ftY9jgH3xL/xHjs+YRzNlx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791908; c=relaxed/simple;
	bh=4vM/wJJHLPOv5VKS2ACmkCteIfFvzBD3jTiDpR/nzVk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gEdI37vQSidvF+wVL6o4VW/+bBl/SjEIJF9/S9Zg/2g2Ku/vNi+MbcKkjEU5B/xFlJbzIU3otEjKByPn38k+slvt5Ng1ZlirOJjAwZBAIkCHpEiP73D9lrKmf72n+Xy9oLVe0v89TLQnQvzpqNs/T5Y8yyEDRXgXAGTTg/QhUJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UdQ+DFsR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UdQ+DFsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF56A1F00898;
	Wed, 30 Sep 2026 18:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790791906;
	bh=5b98rL9ntIMqZdcUlqsG9k/Z6pTlYSUeSU2QVOduKXw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UdQ+DFsRjvaEcrOHldiDT0Yz8PeyA/so3jFVVBIoObQ/iHIey13oWtii3sSuRUO2v
	 hn9+glWS/LFb4zBjLK04wTE7Zgi8esCZsDcG1VZrJqLhSnPiqG4BZzvW5ZC75TGWJ5
	 dQWrEVs6+RU80ZK9+yWbz6dLnIHS4WfMkeK5Ci5OX+VzU6N7TJvHB9D9wt8XLdYenL
	 ArC0lWwS1s0k2XCPNGdI30g0ljVxPHaH9rSNxmnHesNrnFVyEYnIweOAOBKwYZJ6GG
	 KA+JrAKsgdycHUwXsrkgYFG8gu7Au+uShnHkvHCEG/76cBx2yZOO1dzO/fTrv9idGh
	 IxiEuthoNREMA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/rxe: validate cur_sge on the receive path before
 indexing dma->sge[]
Reply-To: sashiko-reviews@lists.linux.dev
To: "Youngsung Ahn" <ays511.kr@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930180119.2497360-1-ays511.kr@gmail.com>
References: <20260930180119.2497360-1-ays511.kr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 18:11:46 +0000
Message-Id: <20260930181146.AF56A1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> A user QP's receive queue is an mmap'd ring: the user provider
> writes the WQEs and post_recv does not touch them, so every field of
> struct rxe_recv_wqe is attacker controlled. When the responder takes
> a WQE it validates only dma.num_sge (rxe_get_recv_wqe() /
> get_srq_wqe()); dma.cur_sge, dma.sge_offset and dma.resid are copied
> into qp->resp.srq_wqe unchecked.
>=20
> copy_data() then uses cur_sge as an index immediately --
> 	struct rxe_sge *sge =3D &dma->sge[dma->cur_sge];
> -- and dereferences it (sge->length) before the in-loop
> "dma->cur_sge >=3D dma->num_sge" test, which only runs after the first
> sge++. cur_sge is a u32, so this reads far out of bounds of the
> RXE_MAX_SGE-entry dma->sge[] embedded in the kmalloc-2k struct
> rxe_qp: an information leak (the out-of-bounds sge->length is
> recoverable through the work-completion status) and a DoS. The send
> queue already got this check in
> commit 126c757e4cd4 ("RDMA/rxe: Validate num_sge/cur_sge before indexing =
wqe->dma.sge[]");
> the receive path did not.
>=20
> Reject an out-of-range cur_sge in copy_data() before the first sge
> dereference. This also covers the send retry path and is harmless to
> the kernel ULP path, which always sets cur_sge =3D 0.
>=20
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930180119.2497=
360-1-ays511.kr@gmail.com?part=3D1

