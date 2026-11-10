Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794279683;
	b=J6SzZPpsnvjH4/84GCecRU+2Z+taV4Un78UuCG6T/fNe/tWs+YDmqLCHJGT39posr+66
	 Js+B6qJWzHzvHtJh0KAeX5O+o37p9vGyehkCP2/kmcUtOMxZVSEsJSVGwNtRNVSEhXXkc
	 wjJzYQ6+FkPy/U2aZrGfk9XU0H/kRQa7yIFZB4AKyaaha5RdCimcWAtqbS6Lw1eJYJfef
	 PWfI3ZiMNg4E5PUtEz5Z/Hhc0EQU8rhm9mVCL8Uv0M7FKPVth8BaQn2OvfnfGzdZAMLhl
	 29lhsnrK3EDsccZvMhKht6rjXIt+6Wo6j3bJE70SgNRO275Eo3WO8sFjQadAOg4PlPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794279683;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=O/bewW18xR2NvS8nckxTcXJjBnu+lrKrh/wIuRHvOUE=;
	b=N5cmLJBeqONb7/DPbKypPLc53dLPAnUZRFwmak6w0u3VyIacgxMrfH724YKXYD8pr0RW
	 4Xrf2Vu+lPS3mzZveBsBqBWJYnZSVN5QLKN/fjXj/ssMo7XqqWpdq46J5BSEIvkdoHQwH
	 qFCZ2T6OTgS5PN8FmZGAT1fWIefcczEDSPK0+1q1Z/otSaSHaoW+JcgO92eS4umBbvPkO
	 6mGRqwd+7WGK+IVcdTooUxETUHnkXMBlVlHxCmV7TU9zEZgTWh3/kRrciT/5GKgOtCdn/
	 4EVxuMG3SYTZDG8NlNf3NrBAIRivMP5Tl94xmkySCWZBEOSPafpx2M51SHmqMyalY0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YqOAa1ab;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBA0606A31C;
	Tue, 10 Nov 2026 03:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YqOAa1ab
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FD31F0089F;
	Tue, 10 Nov 2026 03:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794279682;
	bh=O/bewW18xR2NvS8nckxTcXJjBnu+lrKrh/wIuRHvOUE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YqOAa1abLIiPUBwqcFg0z8OZtrQ+4XAyJbQfrHpyeO6ALmVEB5RMPQoNkrQgAzYMf
	 jckQqA8rmItUqFCleOPBQAy7g7LnerOoG4vvrmfmFORPtQZHEb5IQtIn9t/jJni1Z4
	 SIJmjKmgx/90put0ooKweLnyGbA33ndpv3r4Hn55RQUhONGUWNeJiDrYSZRGExe02S
	 TCBaNdcPEyAwIo8XTgDPebzVTrdmwQRpv2kM/ekRGZLp/Ji4wyDqCOKie45yQ/PyfB
	 uT51GHwvp0eTwU65LzsUzb7kFP/fhV+9yV7aLGejXrQ2AIj1tqH6q06OEY7DH+jUCB
	 dcqE7200hQTJQ==
Message-ID: <sashiko-outbox-206074@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 01/14] ipv4: annotate data-races around ip_rt_*
 sysctls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Cc: linux-security-module@vger.kernel.org, mptcp@lists.linux.dev, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261109025425.328445-2-jiayuan.chen@linux.dev>
References: <20261109025425.328445-1-jiayuan.chen@linux.dev>
 <20261109025425.328445-2-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 03:01:21 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] ipv4: double READ_ONCE() of ip_rt_min_pmtu in
  __ip_rt_update_pmtu()
--

commit d59c48746ce88d155c2f7dae0505f71dcceee996
Author: Jiayuan Chen <jiayuan.chen@linux.dev>

ipv4: annotate data-races around ip_rt_* sysctls

This commit wraps lockless reads of the ip_rt_* routing sysctls in
READ_ONCE() to avoid data races with concurrent sysctl writes.

> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index d0a5f6d77094c..83f49b2d4c36a 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c

[ ... ]

> @@ -1063,14 +1066,14 @@ static void __ip_rt_update_pmtu(struct rtable *rt=
, struct flowi4 *fl4, u32 mtu)
> =20
>  	rcu_read_lock();
>  	net =3D dst_dev_net_rcu(dst);
> -	if (mtu < net->ipv4.ip_rt_min_pmtu) {
> +	if (mtu < READ_ONCE(net->ipv4.ip_rt_min_pmtu)) {
>  		lock =3D true;
> -		mtu =3D min(old_mtu, net->ipv4.ip_rt_min_pmtu);
> +		mtu =3D min(old_mtu, READ_ONCE(net->ipv4.ip_rt_min_pmtu));
>  	}

[Severity: Low]
Should READ_ONCE(net->ipv4.ip_rt_min_pmtu) be cached in a local variable
here, as done in ip_error()?  If net.ipv4.route.min_pmtu is lowered
between the two reads, the first load can observe the old higher limit
while the second observes the new lower value, clamping and locking mtu
below the incoming packet's reported PMTU.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109025425.3284=
45-1-jiayuan.chen@linux.dev?part=3D1
