Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793874392;
	b=oGqcALGaWxYqeMd0MZOLCBlKaHhVzJJ3g84S9duBCIpv8lCkczKPjRraxhNTLiRkbXRm
	 pykUrkfWReliGs8vVn+ixtcjS7+rexdTVSS2PNnzJq2RX/UHNVmnOcUIcD+rt6DgL1ajf
	 I6PUn/4V/hrLTIhmIYKQiq+uVjGorVtiBZWPWv6yxAqjkzUkTOo9Lt/nxaXN6OvRN2kJM
	 nhaRFwX7HIbrYxzUG/M44Qya7fvJxTirEgAYAaO35rRVIIYPkYBh0Jkt+Vw7fu/CsOtdU
	 f0NHaYwM6XocsnhusrxaTUkNkGb3qAMsFHQmhQlEKl/7FrUtszhVHd6o2zQId+riRpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793874392;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=k8aHG4Weyisntz2fRN9nAZqCO1AF7fsoIKr3+GICHk0=;
	b=J7kTLTkSMuZnXehS01sUzGUfLKsQhd0yVQVsI0JVnp/Rx1kjd0JYufCyxtv2MifdTHj+
	 Fv5wazv5if9bpqY5ibluf+OXl7UC3AZFmuPkRuDEJjYNOc9XNIeKmglhI9Rb7KRy/VxAL
	 dF9kX9hVgt+SeVWI1VoT6ekVZNbNpnkvd4IyFFUUk/sanL6bWzGi6/y0eWkopGA3YDFlH
	 7UfSfbZkVRnxNioh1f3lqmxfS9XVrPzzxMQAbjN8pSWBDJqY8Nr4h+jXQdri03hJJloNC
	 sE4zSrEnSkePApY7eQr96oEggYjpR59bfxnhOGB1NpzxNQ/EgRFNVUdE0owmxqbXhEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EWWlO2T3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205DF606A31B;
	Thu,  5 Nov 2026 10:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EWWlO2T3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE281F000C1;
	Thu,  5 Nov 2026 10:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793874392;
	bh=k8aHG4Weyisntz2fRN9nAZqCO1AF7fsoIKr3+GICHk0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EWWlO2T3QDuaGsJcaAOJceljBiZEv+tZgVpeGWrINdh4Mh3U0bq14phxMYi0NYwGm
	 v6JNDip2v+3Xor08QUR/PV07OR5iBeNP1w1CJhDbi79VX+fTCuxXN57A7qZUgsnGQC
	 UGvKosDo/mJ5c5Vkpbv3nYb6fzpFCns5r9RUCTSuafRRYCaYM+qBur/Q9yD3FPTWWi
	 1tvpvvqkLD4mKCaXjqTSRnZC6LsgAml/pKKIwsU0KZotaHnr9eIkM94ovQEVzBKhOY
	 D04e00wiP3fshAvJl228dDhXga6JoC87kTk1FxQgvHBRGbVfOivIM3Shw1dNa5h9h4
	 eyukbpQcvGKwg==
Message-ID: <sashiko-outbox-198852@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 01/19] PCI/P2PDMA: Honor device-specific ACS
 redirection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-fix-p2p-acs-v4-0-v13-1-3dd065907c3b@nvidia.com>
References: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>
 <20261105-fix-p2p-acs-v4-0-v13-1-3dd065907c3b@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 10:26:31 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> Some ports, such as Zhaoxin Switch Downstream Ports, redirect peer-to-peer
> traffic without an ACS capability, as their device-specific ACS quirks
> report. P2PDMA reads only ACS Control, so below such a port it hands out
> bus addresses for traffic that goes to the host bridge.
>=20
> Take Request and Completion Redirect from a bridge's quirk too. Ignore
> endpoint quirks, which only describe traffic between an endpoint's own
> functions. Skip bridges on a root bus: they never sit between two peers,
> and the AMD southbridge quirk may sleep there during DMA mapping.
>=20
> pci=3Ddisable_acs_redir=3D cannot override a quirk, so name such ports
> separately.
>=20
> Fixes: 52916982af48 ("PCI/P2PDMA: Support peer-to-peer memory")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-fix-p2p-ac=
s-v4-0-v13-0-3dd065907c3b@nvidia.com?part=3D1

