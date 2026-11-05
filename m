Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793874058;
	b=RkpEbtT1Cnh3LEvPG8GsDT45SiIaXGw0i49wQP3Ux9k+3szebAEC0We1RS/R2ef4kffw
	 wQoEDSKXsTtleNPzkIP/K0B6pY/Ahapn6ySdal3of2f5ASGz6KM0k+G5WokhBUyBnfURV
	 l4LuONOAo89hamG3KziGjrDwARSD2teLu6DDMLPLlJnwMC/Wl+qxPHeYadXbRXkPjXm+u
	 orGUme81nUcrAp6hTHTdVdQY3ThF3pP7om9wrqqvBCpS6X3E1ufaaoH8CZzqR+ROsvHyL
	 dVCSqS+OsgeJ/eH5z/vTaTOW3b+Cf1SKgeS43DWAln7TqcbRqlV60NMG5OOwDDHA3gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793874058;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=YkVvu6jzHleIPKd2R8xexkUCXS3crCz63cuoBe36KSk=;
	b=sRCmxJ+ITP9wqDtuO7ByWrXuQxPBHERLsdGE8otg1YdhuhEub7xktYx61ZyJQ6PoMVh3
	 CLfWnkWJmljpNRPxU1Gs+b/u3M4yI3eZTSoukBYmB77CDtyELxj9oGsOm+1ZEpjKZ8aTk
	 ttNTFmFAzH2Cpr2JPxZgzZ1QGVYQlFJyVWusooQGNF+6sNnXfYD3jrvItLuRI0VN+oyhR
	 XjWkXD8U/cljORIJ/A/6jDN3GCah12FWWx2LbwjQHtjXwmeNmhpxkN2yZKzlmvWw+bQKt
	 kD6bfIbNGcB9xTrVLoO7vvjgaqGYXxvj1fylbzQ2mlPYdTImA1+2MR6gRdXFF5fhHkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mtspw2iy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D3B606EE9B;
	Thu,  5 Nov 2026 10:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mtspw2iy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3451F00A02;
	Thu,  5 Nov 2026 10:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793874058;
	bh=YkVvu6jzHleIPKd2R8xexkUCXS3crCz63cuoBe36KSk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mtspw2iye3EyY24gCn2kFRodqlgQS3RXKqxeAqUITEfdcvrIZDFx1ZMj4VGzNlEKv
	 vjJqhB10OEmtQKF6lMl/P37BLMm4KIalGed6yBsU0uPB7gwaN4rydWprwcuutAnBvS
	 juu7aY3YYjTbHw+GygNhp0CzePbjG3S1M/8BH3XZuRX5kmpupHtbt3TC7LiSjSDIug
	 ceYD3n70kIaZspKmvxhAsbtTD3drqANSxLbPVcw6KS43khszk0JezZ2grWXZo13nLR
	 YM48LEhpZIB2jUqXwIZJuN4pZNCDanA0fjKHl1vJvBZWMiq85tQYmlH5GF87+7jZiC
	 wCxJrkT1tOr+Q==
Message-ID: <sashiko-outbox-198841@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 19/19] PCI/P2PDMA: Test the routing of clients with
 ATS enabled
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-fix-p2p-acs-v4-0-v13-19-3dd065907c3b@nvidia.com>
References: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>
 <20261105-fix-p2p-acs-v4-0-v13-19-3dd065907c3b@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 10:20:57 +0000
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
> A client that enables ATS for the whole device must never be handed a
> bus address, and Translation Blocking must reject its peer-to-peer
> traffic even when the caller asks for the default class. That has to
> hold for answers taken from the cache as well.
>=20
> Cover those on the fabricated fabric, together with a client that
> declared per-mapping ATS keeping the per-class answers and a client
> without ATS answering for the Untranslated Requests it will issue.
>=20
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-fix-p2p-ac=
s-v4-0-v13-0-3dd065907c3b@nvidia.com?part=3D19

