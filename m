Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794716089;
	b=eWND9DkrJFNV2TJKPYsCieQG7VoOEkhSh4OOi/XbAYzZqBmeyVGr2q6AuhQe3wlcUESl
	 Aytnfb2ZXmcN9DRuoHBpjOECTzYzSiz4qe+AsFULvcrncQN8u076xAtbdR/tKY/IDJNeK
	 VTxLGI1+ENlsXcYuNtCZY5ZJt4qktFMoEyUbSfe6U0Lp6o/eoDMc+zWuSevsSNniNsK1L
	 lN/m8IdEjnEuroQrnlWP4uD+pM4cgufiZ6zTrSIOa4tB58pTFRm7Ud6D5GvBJbhSIr34t
	 CpGv1VInTrt61IjvH3l1xhQI/lMEdT15Bxz0WTC1AuSjLBeYHCc8ZJzuWP8btXYN34g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794716089;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=p8q00MKTCFgTLaXN/n8cs8MmF4HYg498OeF4dxyCuU4=;
	b=jKuRxOK9FpZ/QCvZ0J6iOAqP0vBWakKdaef7CAvzaWyVla4RHGMJiZYg0xQEZf+FThis
	 3gqtyBWaodUdfW3NX5A3+nmImI7l9AjfwlfnJItKPuEj2IKgG0S0IWO8rYLHHCPByai36
	 cxipo4QJvH4rDQAEP6RV1+4l6S+xasT8iMqNNrbMuJq/eeUGsLEFJzOK+Mjdlq2uxfBnF
	 AmYsUQ9ssbWYXwQNLlulszciyIslw9JvVGD4a47fzoTSmRgOBU1JCeKToCWdN/qe3IO/U
	 AK4/9r05pPFufCIUKiOHvlc3GRSRBFZMu2KVrUXLpiFSApG4TBd+HSKI1V/spixrLWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RxYy0R3x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C21606A329;
	Sun, 15 Nov 2026 04:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RxYy0R3x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53AC11F000C4;
	Sun, 15 Nov 2026 04:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794716088;
	bh=p8q00MKTCFgTLaXN/n8cs8MmF4HYg498OeF4dxyCuU4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RxYy0R3xF1/ggapxbJr3/OKj86Ei4hlUV3Z3w/Gc96MaHHPanUWOEp22lGffHvB6H
	 SAt9VK6dkP0p2QT9s2SQJEmHVQet8ZTXAf51aFnJQzQPEmOHlKAAgnL9SCnS89o7uv
	 I4j8IV/8ixKrQeeCNpIE3wj+/WkxHpIVRCG+aMwDU9I55YJddmXSBXioSY5vqMZ8S3
	 iTT9oxrGC88CqPb5sF+um25XYkDbPUWlynaS01HcoY/zJi5Z5aipDGZla/3Wu0YxVD
	 g2F1s0YNL1tPC56Url8uV/xoRQpAyDgANNyf7Zq+xACR8CxrjcH7Le4Se//HrgKIHQ
	 N0VVcvg09tTGg==
Message-ID: <sashiko-outbox-215217@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 1/4] net/smc: take the socket spinlock across the
 failover cursor switch
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261113-b4-disp-1a9ab9b0-v1-1-4a7c8d85d849@proton.me>
References: <20261113-b4-disp-1a9ab9b0-v1-0-4a7c8d85d849@proton.me>
 <20261113-b4-disp-1a9ab9b0-v1-1-4a7c8d85d849@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 04:14:47 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Bryam Vargas <hexlabsecurity@proton.me>
>=20
> smc_switch_cursor() rewrites the send cursors, sndbuf_space and
> peer_rmbe_space under send_lock only. smc_cdc_tx_handler() updates
> tx_curs_fin, local_tx_ctrl_fin and sndbuf_space, and
> smc_cdc_msg_recv_action() updates the peer's consumer cursor and
> peer_rmbe_space, under bh_lock_sock(). A CDC completion handled during a
> link switch can credit its bytes twice and leave tx_curs_fin ahead of
> tx_curs_sent, or leave tx_curs_sent and the producer cursor out of step,
> so the resend writes at the wrong RMB offset. A CDC received at the same
> time can be counted twice in peer_rmbe_space.
>=20
> Take bh_lock_sock() around the link change and the cursor switch, in
> the order the receive path already uses (the socket spinlock, then
> send_lock).
>=20
> Fixes: c6f02ebeea3a ("net/smc: switch connections to alternate link")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261029-b4-d=
isp-33001ace-v8-0-f9bb96e17827%40proton.me?part=3D4
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-b4-disp-1a=
9ab9b0-v1-0-4a7c8d85d849@proton.me?part=3D1

