Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794616387;
	b=KQtk75k7aE2IULGvDCTyM8+vJnNd8iDL0cy59OytgL36T649UTj6m/P1TvS1crZ7U3dA
	 hYYeJCVilI5GjRLIUPbUV2tQdULR2mAsXpkWlOrbD2YAI3AkfrwvVwq1+q5XRGoNitORB
	 NEBvOGEYspKnGboBaFUq/NxswHagYxgf5JtjNl8KSJQ5sLlt4xd55FiOvQJlFqXJDfw2B
	 gk8IKhGUrG8tTOXyKOxS7NTwIUOcuiaNCFvyAyp89bfqGLfmILdFvdihSicxVbHG3Q6JJ
	 nk6H4wC00it5pImQuuafThuo/+n5+YIhIUUMMPrY9f/yTXT+3HlRLuUGaOrXJv8MUyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794616387;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=p6B+WjUHd/OHnu0HCSYULJp+3X+udH5TqY/HcB2JYIM=;
	b=jsMdd4K/E/lIo0J0tm4UjGQiLEwuxoBCzIQq9r0DLW8OO/uQ2HD3gUtJQMlDIUGc9z2g
	 8ecHyVzn547vPutjYTk52YBmm5DVO1HVgdLsIaA9gfiAbnFtkkbx8qbYSmzO1ZCTiIsM/
	 gRWFuz63lvCxMLvviWZFowJAdLADQQYAkoBqBcDEjQ21LhfwVk5aLRD+7XVRRynNlhR1E
	 ZVANRou4dR9TGc1SqW4P+72MaS7zhCk5mzAH68etKT+lCTZW5mgvC0PqFx9KbgjOwfkVs
	 ONiEcDimrtBh7cP2UN31Cotlu5gXvI9eDoWvXJczS2UPWIgmmUetGySsSOJu9NEW5pQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d7dexMJl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C1C606A332;
	Sat, 14 Nov 2026 00:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d7dexMJl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281A01F000C4;
	Sat, 14 Nov 2026 00:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794616386;
	bh=p6B+WjUHd/OHnu0HCSYULJp+3X+udH5TqY/HcB2JYIM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d7dexMJlUqMz4oEI1OKVUkolQ5NZo6GmBilpe0MSKbGX5+8X5WF0wvnjTllUpLO3G
	 g63F4u58s/+L7IvRCwRtHJGXFs5K8zeNIzKWpL0353BdNAGwA2CjWTRrlUdFqcVXfO
	 N4hLhB1nkKoatc12A6MopeU5FxUtb/1Jl9cooo8GizQBCNucQwnZyTi/KYMWJlYye+
	 vRCP9lectoWp9w3ibskHq8R6/W4OXcIKwVb12F0cV1a+T60bWdzyAwUe4xLljXmWo2
	 Ca3ZIH5vSvZ3QirefVEvwMzphvvHm/x4dZOVP1U6jEa8fnfBxfDUEwLFrL+0oOjPPm
	 9K6T3ohwMtBJA==
Message-ID: <sashiko-outbox-213927@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v6 1/3] net/smc: order the CDC receive path against
 RMB publication
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261112-b4-disp-1c8d3a53-v6-1-36a38ae35021@proton.me>
References: <20261112-b4-disp-1c8d3a53-v6-0-36a38ae35021@proton.me>
 <20261112-b4-disp-1c8d3a53-v6-1-36a38ae35021@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 00:33:05 +0000
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
> smc_conn_create() adds an SMC-R connection to the token tree before
> smc_buf_create() sets conn->rmb_desc. Tokens come from one global
> counter, so a peer in the link group can predict the next one. A CDC
> with that token, arriving in the window, makes
> smc_cdc_msg_recv_action() dereference a NULL rmb_desc in softirq.
>=20
> Set rmb_desc with a release store after the receive fields that go
> with it, and drop a CDC in smc_cdc_rx_handler() while rmb_desc is
> unset. A conforming peer learns the token only from the CLC accept or
> confirm, sent after smc_buf_create(), so nothing it sends is dropped.
> The SMC-D receive tasklet needs no check: smc_ism_set_conn() publishes
> the connection under smcd->lock, which smcd_handle_irq() also takes.
>=20
> Fixes: 69cb7dc0218b ("net/smc: add common buffer size in send and receive=
 buffer descriptors")
> Closes: https://sashiko.dev/#/patchset/20261008-b4-disp-f7cd3d96-v6-0-fba=
616c0920c@proton.me?part=3D1
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112-b4-disp-1c=
8d3a53-v6-0-36a38ae35021@proton.me?part=3D1

