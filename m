Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794767281;
	b=4tTUzbU25rcgO5jA4VprlCOcD/FWaT8H0vTNyNdoisN1AeZywBCQWbpCcsZwcfS3Azg8
	 AB/gAHZGzyKySCSGkev2dDX04YOmEgMFveoyjji/YdFRz1iI496o2/RJ7QtO1F0V5Tfp9
	 4AC0b7yEOIJ8qB2jUlGyP4w9gjMGNHXdJ2xsCF4q39SArCI3ml3yJqsOpikQaEn3ecd9w
	 EZqpURYILDfu/fFOdVfAoakuKvgnC591rBszLQGYpHj7MVgKtHutLwne39DShU8Iur0hY
	 5eoWtnyNBYOfE28+6h6yUH2ErGMvz8R9QSH3h8pK6TQ+wYnZLLYKEQJcGbv/wrnkh/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794767281;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=X8C3ik5YqnoOC+Rr/OycYD4ixkVNff9wdCpJqvmBguE=;
	b=hzfHCwA+NrAqRxLL3P/TG8vu5f2jGbwJrl2g/dPVKFpkA+Ysa2PrutE1E7yv7Y3T/Fla
	 g6EoewPjlvfpsS9VB9ivzTEHXp3ASbCkvq4xzyZNKKRQFZ/99ciE2V70pY2I2u3+AxwZ0
	 7//EUkQO8uMQevWO1uT6sNU9PZ5sJ1T8VuYM/9bEnqRLKRaHebIbCfWhlGPFevsA0gSFs
	 DlJETPpzAhwSHpyh3NXlnyOUDZU4cg3Hlp8ovR+hhuPw1pyoOUyI5Q+22nueV9AaWqBAZ
	 BYAYzqR6TYsQkjAcPCai0lCUTcANFUADRut25Ah151zgd8EHLM8VBYeYYeY5YG6bnug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AcaMIpJt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BCE606A31E
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 18:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AcaMIpJt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56F41F000C4;
	Sun, 15 Nov 2026 18:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794767280;
	bh=X8C3ik5YqnoOC+Rr/OycYD4ixkVNff9wdCpJqvmBguE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AcaMIpJtGZVLwPDa0JYetzDhkkOEFADWFIa2XzCdjxFUwE/bSsnUyF4CL4m6RdMZw
	 dxKC3M5T3A6Z2xcQwPkKlIL9zKz3HS4WvIsEcmpVdM+H+7ZC3QMo/FHGzGx64tiKc4
	 iwrgQDF+wiUlB8Qe8wj7ubX9Ft9AnXqIIez86bZnC0axpLMM0aDfZxXDG6UfKiYVC+
	 EYq5dBuZ2lwnOHdHSZqUAKvCxSjHKmX6PlxWhqzzEmQgOhN6XMLcCnyk1yByPPu2li
	 /pu4eJgWQd4mcg+HitOa8dFyflF9j2JXqhXRwbZDC54uHq18SosKFIN3bF80sBrqZs
	 O9mfepB5nlZiQ==
Message-ID: <sashiko-outbox-215717@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2 1/2] net: keep the TCP fixed-ID flags on the
 header they describe
Reply-To: sashiko-reviews@lists.linux.dev
To: "Julius Bairaktaris" <julius@bairaktaris.de>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <f7d096c63c6a0b7a23a4dcea9a3de0915a48ac56.1794139176.git.julius@bairaktaris.de>
References: <cover.1794139176.git.julius@bairaktaris.de>
 <f7d096c63c6a0b7a23a4dcea9a3de0915a48ac56.1794139176.git.julius@bairaktaris.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 18:28:00 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Commit 3271f19bf7b9 ("net: gso: restore ids of outer ip headers
> correctly") made SKB_GSO_TCP_FIXEDID describe the outermost IPv4 header
> and added SKB_GSO_TCP_FIXEDID_INNER for the inner header of an
> encapsulated packet. Every path that adds or removes a header then has to
> move the flags, and none does. A TCP stream that GRO merged with fixed
> IDs and that is forwarded into an IPIP tunnel, or into an ESP tunnel mode
> SA with crypto offload, is segmented with one outer ID for all segments
> and with incrementing inner IDs. Decapsulation leaves the state of the
> removed outer header on the new outer one, and the inner header of a GRE
> or UDP tunnel, which segmentation reads at encap_level 0, gets the state
> of the outer header.
>=20
> Let SKB_GSO_TCP_FIXEDID describe the innermost IPv4 header again, as it
> did before that commit, and replace SKB_GSO_TCP_FIXEDID_INNER with
> SKB_GSO_TCP_FIXEDID_OUTER for the outer header of an encapsulated
> packet. A new outer header then has no flag and gets incrementing IDs,
> so encapsulation needs no change, and decapsulation clears the outer
> flag in iptunnel_pull_offloads() and bpf_skb_net_shrink(). Convert mlx5
> and sfc, the two drivers that use the inner flag.
>=20
> Fixes: 3271f19bf7b9 ("net: gso: restore ids of outer ip headers correctly=
")
> Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1794139176.gi=
t.julius@bairaktaris.de?part=3D1

