Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795233064;
	b=xh1uSzTv9Ddtfk/2BbZQdfmqB8p9CFV13je58TZgQ5pF+jLvKcBs36Uuk0VsaG8tqD6g
	 JpHprDWWqhJre8zBB/I3vnAPwfFRN6w81XrsKn2O569QULRpt7biifoKVsVNpx5cV32R7
	 G7WMbGp/O54JdYy/1C/h3ITJVkGNBkl9iPTnrSMF0TeqFwujprPDC2/iW8h//nQCvjLYK
	 5BP1W5Utdq5aeKnpHJgb+2nI8cNekmQh635JNh7i2sTa1IEA9Si0yRu6l+jT+vB68u5SD
	 Im8fQ+rP4TzqW3ZiJTjY9i++W1puVGFum2IRZybavWlOM/2evcotqS1nHLFt8Y7UFsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795233064;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7q4PMD3e/PGADQpQDkXhEVxlUnE3pnrDNkLoGjIh4PE=;
	b=ckVaTuM8gDAGzAa0xwBN+cym7S4SIk8DGKnMX0WNsscMab0Ym5ub+0EfJmUosWNiR0+V
	 Y0T2BNYt7c49oVJGfv6h3H/ZoD9nF3VIHbxStWtyZiy+aDyHiM+422gnysRfx2Cufkq80
	 HxUer5BYJFsUoTVHEvjaB1pU9QPqBwgcVjXnz70ysiTlNdOqfEiqA5xaNcKnlt+v3RtHv
	 uNew37Lh/g26DJnqnMNNbARyXS+7Ugd5Rf1liSZcTIYSOPgbZvElIjJmLWxhg4JAYCoRf
	 PQ1oHQ8MSR6796SLOCpFsHLHeGq7Bt9q8zElQJEdgykr8xxsn4rAeMqh3qTA698Zr9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OM2SdcJg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CCC606A69A
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 03:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OM2SdcJg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DCB1F000CF;
	Sat, 21 Nov 2026 03:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795233063;
	bh=7q4PMD3e/PGADQpQDkXhEVxlUnE3pnrDNkLoGjIh4PE=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=OM2SdcJgx4SfmSA8wwfXRyDGf0TFXia7f+QC9TdJ7e2/3VbzmDcLsFw+cvfBefDvm
	 YnMlwfUByPkineOF2pas9LeMm7x6FOJbtJCz5HQObQMlLKnyLWFW+/TkKzLlhjghov
	 HKd04Zciz4oKmFSVkixMq3c0Av/S0yrRV8ofWGr1zPLs7xBIwM07yI/z2yoUGxlROV
	 3Z5wfTw3Tr8XUooUGYVA3fYagmbSty5wf68q92FWQ9rCho8RWBRCcjv9J8TCWgLgIl
	 9+/ZVpwty4BcAOYLmvVXsa0gMni/7ugMGQojViNTvQ2N6L7Gi3U9Cd+ulUYueoKk7Z
	 41Uu++Nhsx+0A==
Message-ID: <sashiko-outbox-226605@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2] RDMA/rxe: Mask the SQ producer index read
 from user space
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shuai Liu" <847807867@qq.com>, linux-rdma@vger.kernel.org
In-Reply-To: <tencent_BEE58D9BBE7109C47C2796DDF5A4B958F609@qq.com>
References: <tencent_5B9FB1BCC8EF36C5E2128B7D4D54B867480A@qq.com>
 <tencent_BEE58D9BBE7109C47C2796DDF5A4B958F609@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 03:51:02 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The send queue producer index of a user space QP is stored in the
> queue buffer which is shared with and written by user space. The
> requester reads it without any validation in req_retry() and
> __req_next_wqe() and compares it against its own local index which
> is always masked.
>=20
> The requester stops processing WQEs when its local WQE index equals
> the producer index. If user space writes an out of range producer
> index into the queue buffer, that comparison can never become true.
> Once the QP is put into the error state, rxe_requester() then keeps
> flushing WQEs forever: the flush path advances the WQE index with the
> masked queue_next_index() but the producer index stays out of range,
> and each pass calls rxe_qp_error() which reschedules the send task,
> so the loop never converges. The send task holds a reference to the
> QP for as long as this lasts, so ib_destroy_qp() waits for the QP
> [ ... ]
>=20
> Reported-by: syzbot+fef38133c495aeb48297@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dfef38133c495aeb48297
> Fixes: ae6e843fe08d ("RDMA/rxe: Add memory barriers to kernel queues")
> Signed-off-by: Shuai Liu <847807867@qq.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_BEE58D9BBE7=
109C47C2796DDF5A4B958F609@qq.com?part=3D1
