Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793005714;
	b=YNKEQSK782b6oibBYQu9nTscfBP8dBPVpzfF+OKT4h64rWvev9qAf1f5bTFfEmtBNc/+
	 BR6/62lTuzIFGfQCCgdCX5rW9Vb8S0LgNvtiGQS6U26c8agKJ/CqQM/wduA9nqdjLfySY
	 yXcznzgbrGT1NExdgLcMUgUDtKv4L9yDfq0JAWTDhSCJAsJChucOQfALbcynTuLYhLEY8
	 RbGSkd55Al6u30T4RKOarQdqXKi6jtrnhxR4iPvJVFbmyiIDY3hJPAAHkc5z9S7vxoiUW
	 XcjHztUuFfIlew/9OpPLEm9tkaIfNunAptnsE7cuPItlDdbwBoDnqkLi5jWarVd+msA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793005714;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jhgnhcMYcECkCXfu1dyMLozduElXn4cAX2GJDba9iG0=;
	b=KathZikYXtdvDlV8E84I8GPhgOtQAy4+RK8rLyHagGXiw+qjRnHgje915IRxhdXeqKnm
	 EuAQoUAWmyTKiPOtcHQ5g9ZhQk4j/4EvFMBzaFz5j10p2azXvtY+WH6dtKWYwKfitS+q7
	 4yCBBqNo/DIM+dWjFDa50jnkJi2/ptDeilh4n5AS3AQYZrJ6wygccgUqrLE8vuKaVLlcv
	 PpaZcxVrwMThbFYk/hCuTp92aFO4mcq7WSYDIhbxN1fHp0EAAlRUDFTpbwmHPSVwquJLL
	 j74woxhgm/ssTsP8WAPFs4X84MXPRqpQZbavNn4Ty+kUtq/nVYOs5fL3LJWyNDeP2NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jSKpT34u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB3C606A320
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 09:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jSKpT34u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F2B1F01825;
	Mon, 26 Oct 2026 09:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793005713;
	bh=jhgnhcMYcECkCXfu1dyMLozduElXn4cAX2GJDba9iG0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jSKpT34uyvxLtJxVdMODNEG/UH1hKH++PuW9zVz1b6nk2ee2oXMex0f3gIQ7K7dqa
	 s5cTEJP9m+ciorbG7KRFpwybjzSYvjlJJJqw8ThW7nP4UigRELKXitI1msG3d7CqC3
	 wNv8/r/+WskU0nIEMVFAe9ukjhQqyhdOZJtZJRM3pkCkJF6mLOtTP6hmzKd/Gf1nU2
	 tiauH58C2L5ocyFWOxXI0oJ2On5wXfuKgOL9fiUEzchbhkVm4LkrS099+VVKlkIvNr
	 vvTb8/vT5BCqH9YCvIuxP15gM/D42kkoYztLixfum+DiOOSUdy4xDIOp2dWBX1wcLZ
	 hXOPQiKUdcK/w==
Message-ID: <sashiko-outbox-184736@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 RESEND 2/2] RDMA/srp: do not DMA-sync a receive IU
 past its mapped length
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261026055430.406487-3-yhlee@isslab.korea.ac.kr>
References: <20261026055430.406487-1-yhlee@isslab.korea.ac.kr>
 <20261026055430.406487-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 09:08:33 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> srp_recv_done() syncs the receive IU with ch->max_ti_iu_len, but the IU
> was mapped with iu->size.  Those are the same value only until the first
> reconnect.  srp_cm_rep_handler() takes ch->max_ti_iu_len from every
> SRP_LOGIN_RSP while it allocates the receive ring only when there is none,
> and srp_rport_reconnect() keeps the ring across a reconnect, so a target
> that reports a larger max_ti_iu_len the second time around makes both
> ib_dma_sync_single_for_cpu() and ib_dma_sync_single_for_device() run past
> the end of the mapping, which breaks the DMA API rules.
>=20
> The HCA itself cannot overrun the buffer, because srp_post_recv() posts
> iu->size, so sync the length that was actually mapped.
>=20
> Suggested-by: Bart Van Assche <bvanassche@acm.org>
> Fixes: aef9ec39c47f ("IB: Add SCSI RDMA Protocol (SRP) initiator")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026055430.4064=
87-1-yhlee@isslab.korea.ac.kr?part=3D2

