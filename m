Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D250F395243
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 18:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791398608; cv=none; b=U2nej4ULPv24KituvfXMY3MO5l+i4de2pBOecDQmDQorLc7AuNVhmE4p03CG9ET1pQwx3gG4J4Oq+xFQczBRQ6y9fmiMtA4INyTQtoQbub9fugWN+ji8LOirGo1nRb1mTdfrFqUpQ1sGXppnc69P67ZUh8tZssHrqhaQACjxivY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791398608; c=relaxed/simple;
	bh=1jhlYYGwJk6fPcYIdztCMNWFb0XAhOEKOQHtJ5AEIew=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=SP7qfsv9u5nARwWVXzy074JMw7+HMr5nkT4C9yyyGhcFacKKjh6oL1pv13ak+IVRCcQQAckui5uvnlUcRJb/SfZWXMIGw3wvgtJxtw4nArD5ujH3j+EEJHfLfA2wjRMCvhSlkIYV3ib8xoAXY1tIjpGher1l6dMECTMjKucblSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bbp7u4mP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bbp7u4mP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4362F1F000FF;
	Wed,  7 Oct 2026 18:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791398606;
	bh=1jhlYYGwJk6fPcYIdztCMNWFb0XAhOEKOQHtJ5AEIew=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Bbp7u4mPy3gBpBoCf0jGymqI0QglhL66+do5yvY3BlerpARTmqq0IRiOg5MmWsyMj
	 /xy9849YAEgenhuseugB+x62F0v1TXGe05QtQ4q5pDnku2Pq/4WT0QelbFRNVsM4xu
	 ZMoOyvpz0K9ZxXxigw+q9M0ufOUZ0fh72MydcJt2cdUxe1Zt/ipQpnokh4G/dmeBL+
	 dekqonAsv96FHEIqYaT/nk3c8Z9qEPP7NcXI4GYceQQLxPXzB478uhd58LrsQmMyTF
	 IR+nnA2dX6TwXEuftZZVjC3brQOOUdKreCwy7DBohEOsZ6LQ8ju6s9GuUddI9DwrcP
	 iS6HETn4FpZBg==
Message-ID: <sashiko-outbox-163295@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 1/3] net: selftests: use skb_share_check() in
 the loopback receive hook
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nicolai Buchwitz" <nb@tipi-net.de>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261007-nb-net-selftest-shared-net-v1-1-458369bfa1ba@tipi-net.de>
References: <20261007-nb-net-selftest-shared-net-v1-0-458369bfa1ba@tipi-net.de>
 <20261007-nb-net-selftest-shared-net-v1-1-458369bfa1ba@tipi-net.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 18:43:25 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The loopback hook gets a shared skb when another ETH_P_IP handler is
> bound to the device. skb_unshare() does not unshare it, so
> skb_linearize() on a non-linear frame hits BUG_ON(skb_shared()).
>=20
> Use skb_share_check() instead.
>=20
> Fixes: 3e1e58d64c3d ("net: add generic selftest support")
> Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007-nb-net-sel=
ftest-shared-net-v1-0-458369bfa1ba@tipi-net.de?part=3D1

