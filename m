Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336036;
	b=vOB8IaRvVrYhMs7HcixQYHQrkLB/l+kzs7RsUsGJkSAZ7sZBUig4KMMYXxWNldgvT3qp
	 +s8K5TLAvdDd0EpiQ9SW30fXhy5orEaHhtV333NC2MX1dxbn8+uPuXTJ03YopC6LikDDV
	 l/LgJz3fe14O8dkJslM/e5wmw5kFN09L7j4FGfGAERMx8WhZ1KQtoU4N8av3Y8LiAg15e
	 Ml1ACSXkFI54mPS8MFbGWyqjcX4GYQJFx69ps4b7q0ycbzJ9wq6FdfHtVTyEkgJE2PM7h
	 Rp5RtoNQmq2J1ITdMh/TAXq9YvwoPCofELf0tlyo+ZRhRbvDMaHDbafU/Pc4N1kd4tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336036;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=uXaYhg7n0DU5KMcbLH+cFn+AJqbTCEQyZ6F4B+pyQog=;
	b=hTCmtjfja/BPfjHDlvgJe8bN4pHVwDxpJMOTLDjUFIq1oVkCHkpCh49jAhGcqWvd7Are
	 /X84DNaDArsfsHXihQd3mTlMGYuOL7NbaBdkgBS2MNeOkkTu8L/DZGLpOyqmEXeVwOkvs
	 pWb84wnZtmIlzNuwqTAGZr4jbCLwxdr4RLUd7AnkOGPWlo6Wo68M5ragpOHCrMaXYpEK4
	 bSCmkR1fq+alOuVEdoSfAB1PCmRbku+FzXr/Txx12/6pXO8wA3BZMxLnv5O12Zr5Of7Dc
	 QSqF4Dxkvdr0kTL2xXIb2FCnET8TW8FWS2p3Orsn9kFf1zzw1CjLYST6uCnHf0VR2bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Uq4BVWzV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57444606A320
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Uq4BVWzV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15FF21F00A21;
	Fri, 30 Oct 2026 04:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336036;
	bh=uXaYhg7n0DU5KMcbLH+cFn+AJqbTCEQyZ6F4B+pyQog=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Uq4BVWzVAXCBjUfqo8shT5dc9fLUJ3c3wZPRLs1GE53ZIWtGwf0/n7qfZCRqt7/jo
	 7ZeR17Rf+605LaSIb9JkO4rd8HMukHObPVCd903RPXTKzvU4q//tLm1VLiBY1L7TXU
	 eavF97ceZN7BxNseb6hZ3Wm1HmZlrxumpqHL253ovRMpy9NEuWP+3SmBBywT8SlTwJ
	 WFgqIOwTKuZ2l6vf00+ghIHnSikydE5ShirBQ1aCYxD1RgWISpQTuwTlc6SZ4ZryN+
	 o6Y2W3/kGwZHEwDteCn/YDazHRbAEIa5q27ycrJiUhFnl0LeVyTRHKWmReDsAFNziN
	 MSfCkusbVKNjg==
Message-ID: <sashiko-outbox-190383@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 2/8] net: netkit: declare NETMEM_TX_NO_DMA
 mode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bobby Eshleman" <bobbyeshleman@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260507-tcp-dm-netkit-v3-2-52821445867c@meta.com>
References: <20260507-tcp-dm-netkit-v3-2-52821445867c@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:53:55 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Bobby Eshleman <bobbyeshleman@meta.com>
>=20
> Some virtual devices like netkit (or ifb) never DMA and never touch frag
> contents, they just forward the skb to another device. They are unable
> to forward unreadable skbs, however, because they fail to pass TX
> validation checks on dev->netmem_tx. The existing two-state
> NETMEM_TX_NONE / NETMEM_TX_DMA doesn't give the TX validator enough
> information to differentiate devices that will attempt DMA on the
> unreadable skb from those that will simply route it untouched.
>=20
> Add a third mode to the enum so drivers can indicate 1) if they have
> netmem TX support, and 2) if they do, whether they are DMA-capable:
>=20
> NETMEM_TX_NO_DMA - pass-through, device never DMAs
>=20
> Widen dev->netmem_tx from a 1-bit field to 2 bits to fit the new value,
> and declare netkit as NETMEM_TX_NO_DMA. Devmem TX support over these
> devices comes in a follow-up patch.
>=20
> Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260507-tcp-dm-net=
kit-v3-0-52821445867c@meta.com?part=3D2

