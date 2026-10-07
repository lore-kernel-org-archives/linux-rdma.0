Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFB7184540;
	Wed,  7 Oct 2026 04:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791346068; cv=none; b=fpohlL2m4JYhrPQhq9CQF+6dhakkKYgVUHImvXPKre4pbiNg9ZuY7JpT1rVLipopZBcFeadekSNqEYz0vPDroqRM64WjPmB1m54Bj4ammINnItxCQV9XPED2PLA1+CFP5HzfYZWtKA55shO9/Q1DzROjn1A0B7/mtxXREFKRpbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791346068; c=relaxed/simple;
	bh=Az47Tcz8A7CK+UvGsJtxSuxn0K1P1yNAWmP5SHOut/k=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=VkW0VmKAPt6SKHZZE/9PwwPu9719KSDC8PlS0bsiyT7KtUImUqRs/AEiExE5dxuFrM3tfNyElSwCWBnLJcC3QLaAfMi3alRgrvpDXEQdD084Xw9TDPZfVX0C3lIejC8WVdpUHEAyDRTt8faDWlTWSgLF4pmcD+C/CEQ62zLbGDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i3jA/YN/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i3jA/YN/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A141F1F0089B;
	Wed,  7 Oct 2026 04:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791346067;
	bh=3YBETmkndpLPDYtdhcyRzFAN2o33DcilpM8etLw0yVI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i3jA/YN/NSDCa6E9g1JQSptM3X0tULtHWmWb+MJFijg1ETjQj5M8zrrATBUKEvNCD
	 KiMEA2Aru20kBEsup4PxOtVLQEeqVnWDCW0w3lOJygvQLs2+le/gyVox8dOYKHDmpZ
	 bbN1nE1WMz1Z/6IMBLiCIvyn6pTvXvYumi5uWMe3qYgaN2tSJEkhRttPMfC6gZFTGb
	 FD/o2Yp9ingQ6SiqjuxHyFilfaS4Dy9aWkQLLAYbqHWRldeY1DCczqDiBsZmdHGMy4
	 nKIjrzfnuoLEvvQeCwL5iCCyPtaYx80wXvw6R0MTEt8jaUY2+1EOC6mow7l1BiDzew
	 g8Qy7FnvhONHw==
Message-ID: <sashiko-outbox-162620@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] net/smc: hold a reference on net_device returned by
 pnet_find_base_ndev()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Atharva Vartak" <atharva.a.vartak@gmail.com>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20261007040009.137568-1-atharva.a.vartak@gmail.com>
References: <20261007040009.137568-1-atharva.a.vartak@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 04:07:46 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> pnet_find_base_ndev() resolves the base net_device for stacked devices
> under RTNL, then drops the lock and returns the raw pointer without
> taking a reference.  All three callers dereference the pointer after
> RTNL has been released, creating a use-after-free window if the device
> is concurrently unregistered.
>=20
> Take a reference with netdev_hold() before dropping RTNL and add the
> matching netdev_put() in every return path of the three callers:
>=20
>   - smc_pnet_add_eth()
>   - smc_pnet_find_roce_by_pnetid()
>   - smc_pnet_find_ism_by_pnetid()
>=20
> Fixes: 0afff91c6f5e ("net/smc: add pnetid support")
> Fixes: 1619f770589a ("net/smc: add pnetid support for SMC-D and ISM")
> Cc: "D. Wythe" <alibuda@linux.alibaba.com>
> Cc: Dust Li <dust.li@linux.alibaba.com>
> Cc: Sidraya Jayagond <sidraya@linux.ibm.com>
> Cc: Mahanta Jambigi <mjambigi@linux.ibm.com>
> Cc: Tony Lu <tonylu@linux.alibaba.com>
> Cc: Wen Gu <guwen@linux.alibaba.com>
> Cc: Willy Tarreau <w@1wt.eu>
> Cc: linux-rdma@vger.kernel.org
> Cc: linux-s390@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Atharva Vartak <atharva.a.vartak@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007040009.1375=
68-1-atharva.a.vartak@gmail.com?part=3D1

