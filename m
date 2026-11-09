Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794204045;
	b=gA1UilRSpCft48FQI9O6snDUjmaqSRKpCDs3bORBW3PltYHo3iuIjC8N5/mp+0qDGzxc
	 JHHyZCPZYu/ddmEiEd4SF2ZdhLjh69CZiYdIOquzwNt6pWLLUuukTEmR64bRHM48WII7Q
	 iOSfLfmUgP2KEw65nR/WFMBlhLaxskVCDBr4EiT8o2X5sc/F4NM7NxnxE7b1mZ840Ub92
	 HtJEp19kBX9UTon4FAmYXo/5cNmLgHuZrMKVSYCB3+sUy/le7byceU1GDEL5Fg0pguz1b
	 IpZKKIpkVh0/YOGIkrg40giUI0MIH/xflbKrspQDV8EC/qIfgNcfBoBN2PImqbgiAPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794204045;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=orEWQzXaVWIa0pyNRGKYbqcGD7cBsq5tkQ9DvTSKQ90=;
	b=QqvvusTrN/qdE0FGyDJ8i0w11u5dQit5HQ6iedNPeCjedLSB/iYoPYfX9y6cn529Rb+1
	 0zxygXwst+2HFaGvgO5Ufuze3yX/c9VOdKFwzp5jD7g0GXQ6oheZDyxxVC/ZWPSInIxh8
	 jdZ21mrL3HY12vJE/akidfxe8mRUQUTLxFNGWtkUB0Sc5kL1GOHPMIpzYmbdTUcw15KVA
	 sC2bMDxztXb7YurJWz7tnS7Fj1bJjibiSSvL/CPz7JXC7SO9HlwtgHCKugtp20/9YeqJJ
	 e7nKk2E8unRnAPQPEG8LKBa0dFXjqwSf9lTvKANYAdfKUsH2SgDc6/yaEW+aHEcT9pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BCxQ6y7e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2FF606A322;
	Mon,  9 Nov 2026 06:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BCxQ6y7e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118971F0089F;
	Mon,  9 Nov 2026 06:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794204044;
	bh=orEWQzXaVWIa0pyNRGKYbqcGD7cBsq5tkQ9DvTSKQ90=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BCxQ6y7ePLtm0A/O6ZPve1Tnigdekgaa2Ikk4WLMjlgUvUg8NfOGgDXDfiyLHBoQJ
	 Xf560D7Dl40NWBJ7zvvCfvR/8WaSawen5ymIS6WVf1INM6ZbBRhLacxffo8KaFzwUO
	 MyuVZGsipT1OjGoq76z/NlTZuyU81m/jG+9cbSjN2FuBIs8l3FGJiHlsFyqNAW1Wky
	 PQ9tpsGV421cLmR+klMGRfTE/lfr/jQrV0fEl8vNdEbRvDs52OEJwF99kcZpX2dLED
	 McXijQ1UDdorMVk//f5sbLOSDF/QdOq9F2LWAMwtubdww4nWNyWadZT3/iGpF67rM7
	 KpoqSf9NWYh8g==
Message-ID: <sashiko-outbox-204474@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 5/5] net: remove skb_mark_for_recycle()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>
Cc: virtualization@lists.linux.dev, linux-rdma@vger.kernel.org, "Michael S.
 Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>
In-Reply-To: <20261108060016.2131509-6-almasrymina@google.com>
References: <20261108060016.2131509-1-almasrymina@google.com>
 <20261108060016.2131509-6-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 06:00:43 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Now that page_pool reference counting is dispatched directly from each
> netmem's type and skb->pp_recycle has been removed, skb_mark_for_recycle()
> is a no-op stub with no remaining purpose. Remove its definition, all
> in-tree callers, and its reference in
> Documentation/networking/page_pool.rst.
>=20
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108060016.2131=
509-1-almasrymina@google.com?part=3D5

