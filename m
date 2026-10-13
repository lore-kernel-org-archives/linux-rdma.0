Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D5C47140D
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 03:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791860705; cv=none; b=r+M/t6AOR413ToN8MocG7846SqcCkwWrDgncURrAyScjmBQyMjlLxgmMj1nzdORaxPvLi0ygfsdf6OrawsuusDlqM2aX9FkNSlJFT9WupVz3KlcnR6Nrm8Rao+CjUXqNoUvL72i0BqZAnXmLsZNIPlMugFb7t33qpfk7UxH4jlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791860705; c=relaxed/simple;
	bh=0e1BE1LEZvGVlAslzVazM48fNVy4l9r27iG4/HavC1w=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=oCkFT3M99wClWete2DfiXaQZ9zu47r5UP0NM8VOBE27obpAherGiZ3W9iICpWEeD65KydI+6gpRLKt8gMwwmIrLROgKn9nDrO9/5uj8NeyLeoQ9I8pr5sF0WDcVzLpznhT93iuSLwc6f+2UYo5X+lEaOojk+Z5pa5JSZcSq004E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fh/oIvLJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fh/oIvLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344191F000FF;
	Tue, 13 Oct 2026 03:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791860703;
	bh=0e1BE1LEZvGVlAslzVazM48fNVy4l9r27iG4/HavC1w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fh/oIvLJIMGqCS4jxdFM+Re/Rt0/uR8OK6FfNeKGP1rveXCTxBaRhcQUDzduxmvXu
	 pPY+sRrlG6M72enKZLwhSkmPFuVMVBUpSCEsrvmqvdN56sT7myf+bpoXLLpWKDf5Oe
	 XYnu5B1gUKT/dBinLEQSEENys4ceizhpcZxjMc6pafsBIARYqlHnQROS8B5gy6B4+O
	 ZjRv5tF57b+UvfCsW4uduNgV0QUgCsPriqIdP0791KasaP3pzWg3Fkn/s/SoOov4Zm
	 4D5GmFno74Ag+oOrHW+YuJ5/k4krQBr4LvJAd9ZalPoqiJUbQJK8ZA2QndfXSP6zw8
	 wrbQI0xsn4YtA==
Message-ID: <sashiko-outbox-168889@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v4] RDS/IB: validate receive fragment completions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shubham Antil" <shubham@octane.security>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261013025729.40815-1-shubham@octane.security>
References: <20261013025729.40815-1-shubham@octane.security>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 03:05:02 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rds_ib_process_recv() accounts every receive fragment as contributing
> min(i_recv_data_rem, RDS_FRAG_SIZE) bytes, regardless of the completion
> length. When a completion is shorter than the header-declared amount,
> receive accounting can advance beyond the payload supplied by the
> completion.
>=20
> Only an IB_WC_RECV completion has the buffer layout expected by this
> receive path. Other successful completion opcodes must not be interpreted
> as ordinary receive completions.
>=20
> Reject successful completions with any other opcode before processing
> their length. For ordinary receive completions, require enough payload
> to cover the amount accounted to the fragment before linking its page
> into the incoming message.
>=20
> [ ... ]
> Link: https://lore.kernel.org/netdev/8a6ee1d5336ae65b8ffdc8c40a1135657207=
e204.camel@kernel.org/
> Fixes: 1e23b3ee0e94 ("RDS/IB: Receive datagrams via IB")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM (OpenAI Codex, gpt-5.6-sol)
> Signed-off-by: Shubham Antil <shubham@octane.security>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013025729.4081=
5-1-shubham@octane.security?part=3D1

