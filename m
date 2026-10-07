Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2524D5997
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 18:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791398609; cv=none; b=Uvf3TzoDYddd3tFggjhs4Xlgf2Hs9+UnvXuMDlNbL4hKgc2YHR4OM3W3DkATZYuxqD8PJkBQx5Non2YaKZVJiBY6zeGoVo20oEtkghT5mb/8Ci42eOg7nnzhvt7T2y0OsQd89guHjsWCQ2stFQNPeHxVS1wN1eCmi2yJSDDUfBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791398609; c=relaxed/simple;
	bh=lXxuOooDiNF15ltVC5y2TXkZhFtDRAaI4lWCI1mrCW4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=eawwI+rjOddyAPqla8cnRc6bNooSK5x1QDANEf6jN8Ay5NyQz31yOu4jvH3tvw4drm0pCteHZz0knHKEoY80+7WbbsLRCQPGkPFUq2tijqZmMMLgKRpb4jbqdMaKJCDNBW2OjldqmWdaEcWQIyVTmbayJIQ8pYxZ0MohCdUZRMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZBzW018d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZBzW018d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DE01F00898;
	Wed,  7 Oct 2026 18:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791398607;
	bh=lXxuOooDiNF15ltVC5y2TXkZhFtDRAaI4lWCI1mrCW4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZBzW018dVEh0JUbhicYG6lpG1ksB5Si2dprBHO1yKlDWkmWvpzf5wTLZtKmz8gG/D
	 PJm9Tm5GYZvoKmxCV1Gyul5R3dKMYSUzSJsVRSUENGuq5CHCnTmHE5gnfTCpRW2s3w
	 HFkHOL5kb1WHDt9ifM9ckAACL+j+5xI1S1upHaFyvR2LiwT7VUJKLtoZ2zWko3v1U1
	 IDNSO1C4YU7xLNyMSuBdnswRVmzS40QTpzXsygKre5vcm53jVO+G6wMkF3FOGc2xY9
	 dpfM31zrcBnVZxjYBjtYjhJs12eS8TNyAS5/ZsxfD30Bb3Oicr72PImRWS4wZEuvr9
	 S4+q10FFnPsjg==
Message-ID: <sashiko-outbox-163297@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 3/3] net/mlx5e: use skb_share_check() in the
 loopback selftest hook
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nicolai Buchwitz" <nb@tipi-net.de>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261007-nb-net-selftest-shared-net-v1-3-458369bfa1ba@tipi-net.de>
References: <20261007-nb-net-selftest-shared-net-v1-0-458369bfa1ba@tipi-net.de>
 <20261007-nb-net-selftest-shared-net-v1-3-458369bfa1ba@tipi-net.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 18:43:27 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The loopback hook gets a shared skb when another ETH_P_IP handler is
> bound to the device. skb_linearize() on a non-linear frame then hits
> BUG_ON(skb_shared()).
>=20
> Call skb_share_check() before linearizing the skb.
>=20
> Fixes: 95b9606b15bb ("net/mlx5: Extend Ethtool loopback selftest to suppo=
rt non-linear SKB")
> Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007-nb-net-sel=
ftest-shared-net-v1-0-458369bfa1ba@tipi-net.de?part=3D3

