Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794316266;
	b=BUZdXfkmlUszCe6qzza0Cc7DKBI9KPoI0kGD7Iizb7IkPHTA7CXW5+Uc8uweOp4I93bf
	 Z7yidJHtPu6OLC5ZesohkEuEnheMJ40JxWPuUOlp195hl9qkSbXr1DU8PnNI0x2D3axJp
	 7hHNzDmSrvwIjjt6lPYss7c8kKMnycedF0CuyzbC5kQPJhvlIBsZ8RjuNowyIUlEbpkNe
	 e+SqgrkrbzB9hN3BaDjaQaMYFe0l6XUCqFcev2Ow6rCuC+/nzaHankUtshIsE/ZXRHSAl
	 /mOqXm+iXZXVF4HpcSHr+z/igoNHSuthue6QqwfdBhKbpbUFzVA1QSkFhKgqkImV5Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794316266;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=SvSFe8TSo/c/iq/Yoze/QhYyxtLvkMOz0J6i3rnFcPI=;
	b=bYx6Fcu9667pXSZzpC82QS3xz8IaAAf3RiF2vYDSz/b2/r8LjQ3FUZB6fuCti8hqoY5R
	 UqTcBf1/y17677b+NpYB3V5yEjGdKKD6egFzxccbDRJlw5eGL14UDwtnDf27eMrRdLs4o
	 fnCtXrb9GaE0tefHFAqnf2byQjKNtNJDys3/7BhzcWVKVdQH85wdl9Rlay3DKXyTfR3Nd
	 DKkR9moHGkFI0R3yEdzqYJqmE66WlZRGCrB3LRjVvUYcSHiQ4Wg/oNmHeFdcdArdkPgI8
	 NnCKutleDeRnliTt2t7FlfeDCDy8nIsaaJcjorCY4Iwn8+TG+XbA2M6mikf8IwNN/WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h3tCqDZq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B16606A7E9
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 13:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h3tCqDZq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8BE1F0089F;
	Tue, 10 Nov 2026 13:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794316265;
	bh=SvSFe8TSo/c/iq/Yoze/QhYyxtLvkMOz0J6i3rnFcPI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h3tCqDZqK9mhKm2qAoP1bCniN/7zEh6Fw4V/82amPhcLAzx9MnAdOFUTMumGCZpJO
	 Cv5JQme1ECnMgyE/9fMOsBKlgpjoRcUEBV81LvorYR+ZZeiZY/SVOhE5Jjc654OqHC
	 D280XQ3PGlfmJ7VGBbJDaQWkZx8zDexYGE3ckeqz/gGQIMOOdSQ89QHPZblzh85XZW
	 1kew275UiBYMKrLj5pkLAYvVDH/CbmztZjV52gROUzgQ1HYw9XyOPv++vpG3zDHk9c
	 puiAQSQFAGwAa+DReJxCAgW+KR6pFpHFuKFQEgoB2M5Ag/qCrk524a7UWFNNmW81lc
	 ZtL/lUpmWG67w==
Message-ID: <sashiko-outbox-207098@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 09/10] net/mlx5e: TC, match the tunnel key
 without a tunnel device
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109131039.959438-10-acassen@corp.free.fr>
References: <20261109131039.959438-1-acassen@corp.free.fr>
 <20261109131039.959438-10-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 13:11:04 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> RSS can't spread GTP-U traffic between a few endpoints. The outer headers
> barely vary and the TEID is not hashed. A masked tunnel key partitions
> this traffic into RX queues. Other tunnels spread better under RSS. The
> same match still gives a block of tenants its own queue.
>=20
> Without a tunnel device nothing decapsulates. enc_key_id reads the tunnel
> header on the wire like cxgb4 and hns3 do on a physical port. The plain
> ip_proto and dst_port keys select the match register and its capability:
>=20
>   GRE     ip_proto 0x2f   misc.gre_key     ft_field_support
>   VXLAN   dst_port 4789   misc.vxlan_vni   ft_field_support
>   GENEVE  dst_port 6081   misc.geneve_vni  flex parser and
>                                            ft_field_support
>   GTP-U   dst_port 2152   misc3.gtpu_teid  flex parser
>=20
> [ ... ]
> the uplink and VF representors in dmfs, smfs and hmfs. This includes
> redirect to a VF. GTP-U needs flex parser profile 3 and GENEVE profile 0.
> GRE and VXLAN work on both.
>=20
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109131039.9594=
38-1-acassen@corp.free.fr?part=3D9

