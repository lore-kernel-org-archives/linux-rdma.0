Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793601052;
	b=Hpx1Pq3fTgNwP50ypTROCFVkE1oQ2Hsg3ILMrXa4a4p+pw133bittK0li4Fh4B+Yb4uv
	 URKdOEtdHLfBncOBsUPLELlVE3MDXdruabShb6yBnjREHbFKxnCrD4oPHCmyPDce5lxDJ
	 d2vpOPE4BlxjJsRcmNCVlCo/Rtzhg9lEe6NU3WNn6OD30BtCBNF7J8rO44pSb0zJ45loO
	 5GcjgySXZKEGY1O03kdiDdaaClGGcmw31y3NCfBnhWk99mKSdiXVUVfpdTSADNU7ZCZwZ
	 6H2o1OX4xkkoEXefN64vKMQ9j77Epox2GnDmQPEkmVltB/l4m0oW65b+JwP7TkjxEmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793601052;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=GYLQILhj4V1m1rsHDTzWLrB5wgKoOz0NtbLit/5P8r8=;
	b=SqwrRbqO7jBg4sMUIlPaiqATIH4qSth5QEvbotLKDCzNP92Ms3f3WMTkwUt284tQP9NN
	 GlPicsxvkkZ1E56XtBQDfv1MfCnZoAajwnl8b/pb945Q1Se9WmWPbg9nMNqiMdHBXJ1c2
	 ut89mjHhVSCO6s/VT/AQ9tEsUp1D5BSBB5SMrQJ0mYyEw+zvugeJVrkJJKncV83UHGCs6
	 Oo+gwLLFOx0xaAVvBcEGdPy2UGBSY+TgeeI3WeHOGRiBpoZCftHMDMYHEQgMaZ+leuUqT
	 djY/94E886RQICXjzHKuhcoypSF2rYjHiHTJRUlKws/wxrpI5M6obrVS0gyHlcShzsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RpHQbGSI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC52606A324
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 06:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RpHQbGSI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DBC1F000C1;
	Mon,  2 Nov 2026 06:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793601051;
	bh=GYLQILhj4V1m1rsHDTzWLrB5wgKoOz0NtbLit/5P8r8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RpHQbGSIDHLUFtVlMDuJW0FE5f7Wh1kz7Y2K0YlmUEA5TwTMwch/0jPuVxyXE45O0
	 DAN4F1z6behQww3MjTNuRAHrpzpmfjrM18D3PLcVLuMCZctvM7cXdBCXT3oJQ9PWGV
	 5Y2VIs62f2Q+1vuunnjHhg8mzj2+aY0fivJ8VZx1DYdWqyiuXAMFNeRd+rjqfXMf3S
	 ojfUnmVUHGPc/Uw4Si74jtnfsec6P4QrAMmR6hpk95UNv+38AvJwcs2HW8hvoInkXq
	 RyB1nJhVzBXORYQYKyKIANfKtC6yeot4yxRcpwA0aE2GbNHBN6aCYCKB/smBfed1RD
	 rPy6U1T92ckXg==
Message-ID: <sashiko-outbox-192957@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] RDMA/srp: do not DMA-sync a receive IU past its
 mapped length
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261102061938.617371-3-yhlee@isslab.korea.ac.kr>
References: <20261102061938.617371-1-yhlee@isslab.korea.ac.kr>
 <20261102061938.617371-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 06:30:51 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102061938.6173=
71-1-yhlee@isslab.korea.ac.kr?part=3D2

