Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794473737;
	b=oXjqzF3iFiCGEoHgi6ttCPDUQiXHepGtezNK4wUPso8xo24dTx3npyqYCUCNEgITfKh6
	 BapZVD8TK5SOJt45wG7RrPz10WtDNME06jzb4cqap1+O5rXOZGrHEhSOc4ZMD86q9lgwU
	 N8eE/CSCGrOjEuH///LaWPXTbR65Y3SDv4va6nkccCdGu2h1xbs+J4ZfKKIircB4rly2l
	 rBn8b4DFcug1y030ut9kJi8Jajdbcx3/97pxuyy7pQ7ANSJ6uBcAGRAKLywLiY2O7YHWU
	 UUnlzWs/4/N/Wy7JLflJs1yAc8iucdOMcGMTShghAWY9sEDvZ7f3AGwwenA3lQpibTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794473737;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5u87AWGScTGEk0s6yXSh7Xnj4g/Nmct+BufbrMoWGUU=;
	b=VM/dcOGqr5OORxuvAiO3F52TGetFqUNYOe4QN7tYITrijOU4S5XqjdvA7VydqCU8q3Du
	 YO2FvUz2ootzPVq/kgoXSJFE4rsBilUbyMMlY0mUhEMHz6sj/hosWrm/8/9gTTiAvniUv
	 E5gnA8xJ4BkIDujtXUi5AVhSmdfRG7Vww2pFTKi5PvmeNChEySBkW2YhzCE889w2cZySq
	 AAIGeD6jFx13+W9j1bpdWM80ZcjRV2bYzJbCYgsroHhHMtB/PYOEUGKLn2x2ZebdQbuy0
	 6ysHHDCErSI0Jbv3BqWWn+dbfjnrnrg3UDceOu2qbP4LbNgPH1mlqjL5L2CM3ylTcUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="EemdknG/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAF960A2621
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 08:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EemdknG/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349BB1F00A06;
	Thu, 12 Nov 2026 08:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794473737;
	bh=5u87AWGScTGEk0s6yXSh7Xnj4g/Nmct+BufbrMoWGUU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EemdknG/8Ju/pS/eUHO9oMcbfpQotjinIgTGNcjYmdNldhRL2XVYFwyTJNwCo39Tc
	 TJlqBe4vbKJmRAk9S1QxYXm05KlrCwmG2zUfhad60RolTtIj3YbGrxzV2Z7vHLCcsR
	 ZGMRGQSZQuQjObNnX7SBGHOaripB2e0385zTBRkRCC3yASn9CByVOrPRJ9Q/4+qqjj
	 71wCwl3HoroOMtZak3xX0P3gs/+k1obvt27O9xphZKtlEEG6Aat7I5xbOYi1rTQUzO
	 HArcI1DU7iFTHtyiY5kSizJanHD2sO9dNY65/4IbPZjG7mVDe1ZEtKy7pGMhIqDGZQ
	 PYayGNLKYsgyg==
Message-ID: <sashiko-outbox-210799@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v11 5/9] RDMA/mana_ib: Post receive WRs on
 kernel RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261112084716.1483342-6-kotaranov@linux.microsoft.com>
References: <20261112084716.1483342-1-kotaranov@linux.microsoft.com>
 <20261112084716.1483342-6-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 08:55:36 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Implement receive request posting for RC QPs. When posting a batch of
> WRs, ring the doorbell periodically to prevent the u8 counter from
> overflowing.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112084716.1483=
342-1-kotaranov@linux.microsoft.com?part=3D5

