Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795013479;
	b=oz9/HyU5S1XtKXm0+bnIf4p4NSL8YmVcg+xmTzmsgopXbL3k6y5MVhEACtzHRRf902Py
	 OVlXv0OXcnQrQ/WoFaxR3xj7b86Nry+FG2D5Pzf5OxRcYOce4ATJLgU1xKfVfO3Hk6EZv
	 5MioRA0R7KTYAlbAtXARdaPnQxO695cBciuPq6uJ7WJPnE1ot7RDk/vOJypxvT+jku10n
	 0goTucx4QCjhUVfVM9jGElx/Uux2A+RBj8VxHHAwu20+nxQ/pcfd2T/IL1i/Gywi84VHX
	 8zjxgLQalVSk3gtLiCrMUljdOp3dp3bIWyPcuXziyoFP3DnDgMk+dsK6lXkbzCSVaGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795013479;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xlqJWmQf06Pze2sCLBzNPROGFagRnFT6YIDz3+tInNE=;
	b=e5s7C3ssbV0p7pNMOebo/4/ShjBb9pZfJNHZ72h1RYEsKXRJWWT3zj/wvQjy9io5bkx+
	 8GnsJMSnGiqg/AftFsU36uovSxhVeDWPwLCmFffSVmZ+69ua7JVsL2CktrPCP1isWRsaJ
	 2lze2VSn6m9r/cEBOTf7fadN+Io1GkW/i59wb/Mm1FKRtPdt0IS0ZfD/r5bMoSlRA0w/u
	 Fja/LqgtzuilczyCaFOwp/6S78M1VG4yLckZPO/4Jx0c00egePHO32RBqrIpa+oquFM86
	 FqHQlgjWEZmWVRqTpejfsfI4qGQ+XxsWsj6cI5dw3z9vz/pT8aKHx6ppFlYV/8jdv5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eHcfk8Pe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF563606A337
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 14:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eHcfk8Pe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04051F000C8;
	Wed, 18 Nov 2026 14:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795013478;
	bh=xlqJWmQf06Pze2sCLBzNPROGFagRnFT6YIDz3+tInNE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eHcfk8Pe3i6eIQN/P22ZU/WsJaN1nZPp4utVUnfnYIbAMVmcVixEwN2SgnwIiDMCa
	 TlaFCHLSCbHkzlAfIDtiTBshGt+LPeT2dtg4ysg3ZDyOkQxK4lgqRZb5zHcCStfi2O
	 mOVPP+fcfbfjreIA9Dlsqqt5wMpSWm513SfCBKKXqvJ5qjLUhq/7r76NMdJ5bet+xI
	 pUaZjpvMFwYYqMfneZMoiuYLoqNzyCl9/JHqn2Ut+KR+utQuT0p6asxvQPcEZwYAnD
	 wlsvmUjICtWoXQ/dHVZ7X5nw7hLvQblFIOyPXxDpNAoY2RuWMXdblOfyGnQZRlDsNF
	 MMljW/lyryUBQ==
Message-ID: <sashiko-outbox-221259@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5e: SHAMPO: Do not merge packets with
 different kTLS RX state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261118144042.1916204-1-tariqt@nvidia.com>
References: <20261118144042.1916204-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 14:51:18 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> HW-GRO (SHAMPO) sessions are not terminated by HW when the kTLS RX
> offload indication in the CQE changes. The driver applies the offload
> metadata of the first packet in the session only, so ciphertext and
> plaintext can end up in the same skb under a single skb->decrypted
> indication, and resync requests carried by non-first packets are lost.
>=20
> Do not merge a CQE whose decryption state differs from skb->decrypted,
> which the first packet of the session sets. Never merge a CQE that
> carries a resync request or a TLS error, so that each of them starts a
> session and is handled.
>=20
> The failure was reproduced on ConnectX-7 with HW GRO and kTLS RX offload
> on and 0.3% loss added by netem on the sender's egress: TlsDecryptError
> increased and the receiving sockets failed with EBADMSG. With this
> patch, TlsDecryptError stays 0.
>=20
> Fixes: 92552d3abd32 ("net/mlx5e: HW_GRO cqe handler implementation")
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118144042.1916=
204-1-tariqt@nvidia.com?part=3D1

