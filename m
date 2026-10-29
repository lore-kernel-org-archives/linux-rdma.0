Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793299381;
	b=A/tiCMdxU1iRj4eNm4sNkrRlR4IHnFS/eJoQ3tIrjFocjH8gg8I7VxR8LAj6DwFrFQ57
	 /ywSrreJmIw8yvPHG0nH89s1iPTC6oE3PE1P5WDxZUDMZkZBrJLtMN2nKLpCTLL/Ph2Z2
	 xlD70ISQNXLn8OSz/oSUp8XEXL/4pKjcNoV1JTxB45c9RIW2Rs3GqDPbiRwFcu48zbQUS
	 Tmm9/4Knz7S7ibaMrkW5KeGQQinaI2LPGXE1DU1bZJ9eDsIDEmZCImFfoAsDqxOPmt8OW
	 nq9xuFQcpUR4/ArjRsmC+zcKDTu84UvQm6jhRYCjpDef0f3SEpFAiU5FM8DLNA7ArCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793299381;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=z7S4mQle0JtxHrxSb69d3rbfXCxRtOZ/3kA98CL/GOc=;
	b=SXnZw9t9VmH0M0FVScTAjT4wFoh6pXvN+G3lnytnc2UGEu45TJgyo9cXp2Mvp8TFpP4T
	 WxEZpVw/kyAWXlZCx60/M7Pg+rHfkeOSVz78/5MwYp8ordTcPYXsZ/gosgFuHRsQnbNGP
	 7bGoTD132lowzgNlEN02FAiQUM/pnpdEdOHrxLc3P00mi5wjzvhrn+42Y3bt9/D20tzQM
	 H+FqzFbI1qPokiE/UPfsk1aB+ewlUu5h7e42TM70ZntbBTH46UzDsrvdbElWwrk+I5NN5
	 JvBh/ytW73YM4Tw3FLyF6IZU7KVsR06ZGDv42h2S6i51li4WzxbNnbMszZwfgtCznnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VBUbYn5r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D4D606A31C;
	Thu, 29 Oct 2026 18:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VBUbYn5r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39061F01825;
	Thu, 29 Oct 2026 18:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793299381;
	bh=z7S4mQle0JtxHrxSb69d3rbfXCxRtOZ/3kA98CL/GOc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VBUbYn5rrPEIJmj2gYxLYZK2UGoAGkDFz2wpR4VebyDvev0lkrG+vDvTy0uiw1Cto
	 LYit4CXe96C9aQcqxOtiRS9S191xL8kCvXRMYBTZ7F49Xwqj9dUS25B+ZjOMUoxDSO
	 tUTSf6IMvnKjbnZRM5fM32/etzlnr9oslzYKALDgKjyHRHlCopW0IfDjFoF6hCieDP
	 H78lBqy/UR0/ZZ0dXBxx8eoVRtrFp0KHVCd9q7ST4uDjEYy7ELnY4zOS6Vx4YLTE63
	 /W6Ti820SslA63nvBRtadGlLaOpCCI+BHSwnNFhDToQik75fpZDTSEbaZvzij652fN
	 Hk6EF3SRSpoZA==
Message-ID: <sashiko-outbox-189822@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v8 1/4] net/smc: bound the wire-controlled producer
 cursor to the RMB
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261029-b4-disp-33001ace-v8-1-f9bb96e17827@proton.me>
References: <20261029-b4-disp-33001ace-v8-0-f9bb96e17827@proton.me>
 <20261029-b4-disp-33001ace-v8-1-f9bb96e17827@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 18:43:00 +0000
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
> smcr_cdc_msg_to_host() and smcd_cdc_msg_to_host() import the peer's
> producer cursor from the wire into conn->local_rx_ctrl.prod without
> bounding it to the RMB. smc_cdc_handle_urg_data_arrival() then uses its
> count as a raw index into the RMB, so a producer cursor past
> rmb_desc->len makes the receive tasklet read past the RMB, and
> recv(MSG_OOB) hands that byte to the application.
>=20
> Bound the producer cursor count to rmb_desc->len when it comes off the
> wire, for SMC-R and SMC-D. Leave the consumer cursor alone: it indexes
> the peer's RMB, which can be larger than ours, so clamping it to our
> RMB would under-credit peer_rmbe_space and could stall sending to that
> peer. Conforming peers are unaffected.
>=20
> Fixes: de8474eb9d50 ("net/smc: urgent data support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-b4-disp-33=
001ace-v8-0-f9bb96e17827@proton.me?part=3D1

