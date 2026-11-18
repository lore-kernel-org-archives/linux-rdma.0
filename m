Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794994192;
	b=W7wZuJ6IFHhbkh0vhCCX0mT4VaxvPacJLBgKCKPzPP2BX+t3bo66rWNQ5VuU2kJfOuop
	 /jRcXgpeA6opcphjg8uzL3z6fIHv99wBaS/ktJIoTxkUnH7irQXsExNZ6heTDELA8LS/L
	 /hohQUGqKrOggOz+juMV3P2HS0+ldh54jK0MpaEYF4679f598tApWw9GcZuImscMzmtKV
	 n2NshPeqhqEbHLE4D/cqDOsgBI4W81XUsDxvHRFmSOkfPy+vEUjx5gpSad6v0R1OIZKwc
	 dlRxeDjadMV7HZGxwMlC4PLKuyXql3hUZe/c9smLrxcHYfvwgVgJAsh0/QTj8NU2abA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794994192;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3FmT4x0AGQiXOoUB+tu9FoT5HCiqQaxWcSHtrZ6+7nQ=;
	b=Uyj1bNvvuFnJVyWbA3FWB6n66Dt9ne9/HTpekyCPtVOUcky3tEar8YkmugM/q5vzfZ8d
	 B5Run2M55RMtZxj3xCI7baoWiklACnx+3ZeMm2xCPJYMPhKH9lGB5mfvzqbU4bF28UzY/
	 Eb1f3JF2PCImFr8kCJGZ6Cs+AGP2TAz3V03/vMFfwYCUj001yKFvDPmdEL+jlKTLmp1Wc
	 BZ7b31gHXLUk6lH1btoBgS2OGkLygU5AqyqiOal30tY7VRGNVa+zsMtjpnQjeN75tza76
	 opMQX2Ez8NW+bYi3LpGbhILWUq3dzH0A8MqemFAqhoN7Cbm7eQPnL/SXGU4SMWuwyXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VAMLpWCZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14125606A32A
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 09:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VAMLpWCZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75B11F000C4;
	Wed, 18 Nov 2026 09:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794994191;
	bh=3FmT4x0AGQiXOoUB+tu9FoT5HCiqQaxWcSHtrZ6+7nQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VAMLpWCZLTqAsm+pY3S2yo3OcBvfwv0Po5gzt/cQ1BVojbYM5pGumVTmCueu+4+lk
	 6L1SjQhKHJEx2LuLKk4SnHUtlPqiqJqwdG4i0PhQsbV3fZZsnGyYT162CwB4kGjvq2
	 KAF5RmM1gV3PUTVypIYvbBLnEVsAWaFyPtBGOt0+Cy/6ORUXmvSxjTSzjT6aEp+VFI
	 QVv2rO8nS6bDec/lw5lXZ1MMhVXzID/bEWXkFuNWO5XBKVnn/0htjQwLmjCLm/CUBE
	 wCN+p2HZ/eZYXiHh5kcaSEz33/qMFQpOC8a3WT/fR1QwF2hlQiiL7QezTZRS3q1k8i
	 WqKKMNj1LlQJA==
Message-ID: <sashiko-outbox-220565@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 04/10] net/mlx5e: TC, refuse a tunnel key
 wider than the VNI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117092915.255194-5-acassen@corp.free.fr>
References: <20261117092915.255194-1-acassen@corp.free.fr>
 <20261117092915.255194-5-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 09:29:51 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> VXLAN and GENEVE flows truncate the key and the mask of enc_key_id to a 24
> bit VNI. An exact key above bit 23 already selects the wrong VNI. Flower
> is about to accept partial masks. A mask that only covers bits above 23
> would then match any VNI. Refuse a key that no VNI can match. GRE keeps
> its 32 bit key.
>=20
> Found by an AI code review agent while auditing the users of enc_key_id.
> Confirmed by code inspection. The wrong match was not triggered. Tested
> on ConnectX-7 with firmware 28.48.1000 in switchdev mode on VXLAN, GENEVE
> and gretap devices.
>=20
> Fixes: bbd00f7e2349 ("net/mlx5e: Add TC tunnel release action for SRIOV o=
ffloads")
> Fixes: 9272e3df3023 ("net/mlx5e: Geneve, Add support for encap/decap flow=
s offload")
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117092915.2551=
94-1-acassen@corp.free.fr?part=3D4

