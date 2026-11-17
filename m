Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794905891;
	b=XnIgZIsy4WQKQIwaTltEUbeC4aOGa1wE5enbGnlsHG/wdficH04Dc6kI7oS0aU/RYDUr
	 O8c2JNfaZjEte6elP2dnbArqVn4iycVEji/cHdP7FhzovsRRN1LjipFmIxVm3JrBmV+Sz
	 xJ/ZoDlIc+hjf2CMjNEzR+3z8aErYbZnP5u3mQVC08O0Zej2wc1Z6c2+8mGXQ+hLflw4N
	 S2MgAVJ8S9KPP2ngWjXjAfDhVbIfAgPmw4pzBXDCdQQ5hLzPMPqkbt8Ab5BreEfTQfvwN
	 MMJGlFVKa+iBa6sPn76RvUDTkH/dcfNXX2UKPiw8qQBeTUJcQoATN4EsFHPuCqstJrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794905891;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=JnK19KwJXtth06xOSL0mInriHs2mwi7vMlcsLYWlviY=;
	b=IkKTXWLSFnpcdphLsC1VvrTSBIvU5CRrB3/i3YMexsQnchdA+Kp/9eGpQKVkSXnA2YrG
	 qQgwwaDdiBa5GxMTDoC3GuS+xAttAlhamRGwNilmyZMRvIC4LWCznjAgGIMEMuWZgxByJ
	 MrzbuFAIyLlo+Y8u/RO6p/t7OeCQhhydebSGZ8b0XfBohRUGOQ7xz4tj6BHEBjxfHEjAz
	 zcNvYWR41caAHWPithJWsMELJLavgEmwVfydCbVg+DvOGDjvuccfi+Q/Sux0imbuaW7xg
	 GCDaSorj6d8CAo/WROPs9WuXJOCeOy40pKJtFPZT2g2TCy6QX/SyhjUEaZN0f3caQAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iaS8VA+V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA66606A883
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 08:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iaS8VA+V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105671F000C6;
	Tue, 17 Nov 2026 08:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794905891;
	bh=JnK19KwJXtth06xOSL0mInriHs2mwi7vMlcsLYWlviY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iaS8VA+VACECnDNB7d7qgmQXAG/WyD/kgAhX7vierI5GWZf8tv2y9+RAXqU8/XZ+7
	 o/fl24bVFEtdjwoCsB2kmlZfc4rGYtqS6VjPUa4mx8lUUIZLJ7CUGZNVgFM4H4ATrU
	 YPYa6VyflO6kOlob2gPdcqrToghZYjGCLsQVDoJj0PdiCj73t7Vlnjrh6M2mzRfQQV
	 ZOkjHR8JnB00UM5NLxqoBs9Fwhq5R2jCEMTqzwvLmmbPiYr6nYlT1dYfkQiyTKX+/Z
	 RQP3hFX7zpw6KhyYNa0MOJbs0DyeZ68YVVXpPDgte0NDAj3CQjkXp0aGn570jmvbIt
	 /dOfIddZo7RFg==
Message-ID: <sashiko-outbox-218443@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1] net/mlx5e: TX, Do not open a multi-packet
 WQE for a single packet
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xuanqiang Luo" <xuanqiang.luo@linux.dev>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117085036.3138779-1-xuanqiang.luo@linux.dev>
References: <20261117085036.3138779-1-xuanqiang.luo@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 08:58:10 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
>=20
> A multi-packet WQE (MPWQE, added by commit 5af75c747e2a ("net/mlx5e:
> Enhanced TX MPWQE for SKBs")) lets several packets share one WQE, so the
> control and Ethernet segments are fetched by the device once per batch
> instead of once per packet. This saves PCIe bandwidth and CPU cycles, but
> only if the WQE carries more than one packet.
>=20
> With skb_tx_mpwqe enabled, which is the default, mlx5e_xmit() sends every
> skb accepted by mlx5e_tx_skb_supports_mpwqe() through an MPWQE session.
> A session stays open between two calls only while the stack sets
> xmit_more. A packet without xmit_more closes the session and rings the
> doorbell. Hence a packet that comes without xmit_more while no session is
> open opens a session just for itself and closes it right away. Such a WQE
> takes one WQEBB, as a regular WQE does for the same packet, and the
> [ ... ]
> than a single packet MPWQE does (mlx5e_sq_calc_wqe_attr(),
> mlx5e_accel_tx_finish()); the packet rate above shows that it is more
> than compensated.
>=20
> Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117085036.3138=
779-1-xuanqiang.luo@linux.dev?part=3D1

