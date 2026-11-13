Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794603448;
	b=uNbuvntyjiOIJ837D7Cyd5DxG1JTT/OqHwq1myNhnrumGxJcKRaBP3j5FKHzHHGCpDod
	 nGqGrpzMzpb83fkijLqS1UpY2+FGhNfE3Gh+ibW05iFy6GLP7cwTOHiaEWZZMOztbkdN5
	 sAY2NxrB6lV0BYiqRMM/mYh6SOvxsDJLPXBxKOaidvAe7rtqBY8RNW+MUTjLsjhZ7GFML
	 57khuBrFt0K4QJG270/+59nnGMiJO29l53iqDcEhhtWOVRig0t40Oe4srKWxKoz4MSDnr
	 ayJhPAjHH+Fw/6w6ZIYmvFBARzCJEPvRuySltna5nARcJLQGpvNrN8wzLYkLfXz7/ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794603448;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=h7PzvbycXAhbhd5sRIl6HzCdZRUSGlT0BLVmbb3nQfI=;
	b=4FNCAPmUGL2kBWYklMPTSArlUza5e9VaiGQZCZN64jKdGKSoQHlHMzugytHE6QWm+zBD
	 /s6CDoSTG9UZE6yNQ42prTtEzEwtyw4J2Z3KYmuNxmuDGo1ur5bwerT6VRYOqjNGhmqJL
	 bbK1kqMtctM2VMCWrcKk8msf33UtpDNFQCmrKeESvZoiDF9nMp6ld+CWKv+nv92yaT5Wb
	 DRVFk8ccShSwV/w0pvM4wTQNBlejtnSI4arPCGKXWhK9J9nEhqmtiKx5DdxooySDfzimV
	 OJHkOACE1dsHu/EP0x5omAhPRq7U2IVcVpL+w7pTLvM96Soyx8jtFo4fYog8PeypFgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JWnzzsCI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E66606A337
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 20:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JWnzzsCI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2CB1F000C8;
	Fri, 13 Nov 2026 20:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794603448;
	bh=h7PzvbycXAhbhd5sRIl6HzCdZRUSGlT0BLVmbb3nQfI=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=JWnzzsCITtmBrfg6L/SdhupanBgNTiMvoKbdqbgFgHMAMybQwkqdHsu80PHj2rMn+
	 uU3v+NI8NTAV/+5LlgML1sBlv1EeK/d2U3mBP6ZE+gOUrpiC4zED2e+cGM7JqWFB9J
	 ia+0F6qPLMzDgRJOhCtZGUICw4quCj4cwlG6P5mDsJx6tmPw/NIrgDIA335Revl9+6
	 iREtMzlCTLlhyQwrbqs4AUOBnt6GqzZpjJrvtbO75En6HVlFMXhOeLw8HiPPB+ZWri
	 L3KjlIHMK5y3LIoq1+OPO2nj0NM7PeV3+rM/UsMs8u+uENkHE9yxzmw0Y3QT4bzt6L
	 YhPNP8Byiq/mQ==
Message-ID: <sashiko-outbox-213686@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net: mana: Set 1 usec / 1 comp as default and
 minimum interrupt moderation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Haiyang Zhang" <haiyangz@linux.microsoft.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261113204427.1922848-1-haiyangz@linux.microsoft.com>
References: <20261113204427.1922848-1-haiyangz@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 20:57:27 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Haiyang Zhang <haiyangz@microsoft.com>
>=20
> The existing code sets interrupt moderation defaults to 0 usec and 0
> completions, which may cause CQ starvation of our NIC HW, and TX time
> out error like:
> mana 7870:00:00.0 ens1: NETDEV WATCHDOG: CPU: 14: transmit queue 4 timed =
out 63434 ms
>=20
> To fix, change the default and minimal rx/tx usecs and frames to 1.
> When the HW supports interrupt moderation, reject ethtool rx/tx usecs
> and frames below 1.
> Also clamp the values written by mana_gd_ring_dim() to [1, max], so
> no caller, including the DIM work, programs a zero value.
> On the HW without interrupt moderation support, do not request CQ
> moderation, the usecs and frames stay at 0, and cannot be modified by
> ethtool.
> The PF capability is queried again when the device resumes from a
> reset or suspend, so re-initialize these settings before re-attaching
> the vPorts.
>=20
> Advertise this change to the PF with the new driver capability flag
> GDMA_DRV_CAP_FLAG_1_SET_MIN_INTR_MOD_VALUE.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 433f482add31 ("net: mana: Add Interrupt Moderation support")
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113204427.1922=
848-1-haiyangz@linux.microsoft.com?part=3D1

