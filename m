Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336069;
	b=1v+8OlhlZCMVf0dsoWG7VAASEm6kCy3tWonSNhMMIXVyICA+amGprvWAnUGMbzdBgD5L
	 1uWtfec2DwrRIdM7/Rw/rtNWMVhNhoo8yK3DbyGylxKTZQoj3kEBNZP45L5JBcidJx4am
	 BZLbq5QalpEQYmSNEvuA+NXTBh5FcaCgROrrAnHjN+VoY/MKlx03MvLRUDHhTCU1MOkHC
	 a9sUJ/M+VQ+W56NB9FI5sOLIVS2UklnpOuZdxRzmCG598b0Nn1pmUPNpRgPcRGr+0NpJS
	 XmeknlbHak3pE5lu1N5EaQxwzhcpFgqs83EowHP0sk1m+2Bhr2SMRfEYpxabFaEuS/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336069;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Fr/E7UWmgxntNGBGBstR4q3l6eRE3rIlZXF7chvm+sM=;
	b=FCFQiuCMwJOCcI6L1fj6Hd7MtM3GTI9aZjW+0wrKhxl8+TdGURE5B4U3yKbKeaJNrBUS
	 DAmJuccRke/pSTQdPkNRBHiMh2bYRI7In15HbdDPx1olQfl1qYqgGG3CgruaENZychngF
	 Oicw/TCnFGPZeWgBNrjxqlia1guLLHVZB1vH1keSJxYgzBBr8qiuzAw/LQIBUQXOgZGi2
	 f84UXtK1WeUv620R2UHFmuUSnf+wUnonB0QSWXGR8l/1awvVh3n2CjrtIk+HaGk06qJ5u
	 jBv9nWOrHMgVfIRlFNS7kNIyGWR67UAC+nfpW7mD4mO9Av3Ckt7ICcX72092GQCnjRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lqbT8fDZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61C0606A324;
	Fri, 30 Oct 2026 04:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lqbT8fDZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573301F000C1;
	Fri, 30 Oct 2026 04:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336068;
	bh=Fr/E7UWmgxntNGBGBstR4q3l6eRE3rIlZXF7chvm+sM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lqbT8fDZHJBRWlty5KkBSlbR1JVZNi3f7nK+jLmTt+dn3+qYc0UoyRnMiCmwmwVBE
	 MErdGQWnNKjF9zaaRpRKp6uqKs8We7NuStK7qaeg9HBMiOSd2H15D1QWio0d8RJpED
	 Tm/3DtlAYuLcncXRF77FEZCMpFRRTjbAK2nEDQIqXPe9zy0tMAeaXmpaC/WOWZJyEj
	 Im0GhnSeD/vZTTgPn/3zufE8M8uSP+BQ1XfBhFijrYNDMzh/kj3HbFhiks2LwNjp2E
	 tsU/VzekpNsuxYQEsV93/XkhC2KD8iMFJyIs4l5hrs9SSzs6ZaTX4o4/xK8FYxApQX
	 WNYEiKYgiQ1ww==
Message-ID: <sashiko-outbox-190467@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 01/13 RFC net-next] net: ipv4: introduce CONFIG_IPV4 to
 decouple the IPv4 stack
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fernando Fernandez Mancera" <fmancera@suse.de>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260712013941.4570-2-fmancera@suse.de>
References: <20260712013941.4570-1-fmancera@suse.de>
 <20260712013941.4570-2-fmancera@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:54:27 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Historically, the IPv4 protocol has been linked to the core INET
> subsystem. Because shared infrastructure like the TCP/UDP engine,
> routing or INET hashtables live inside net/ipv4/, it has been impossible
> to compile a kernel with only IPv6 support.
>=20
> This patch introduces the CONFIG_IPV4 Kconfig symbol, which is set to
> 'def_bool y' for now. This does not allow to completely disable the
> IPv4 stack yet but it lays the necessary build-system work for that
> goal.
>=20
> In addition, multiple subsystems Kconfig symbols across networking
> features like tunnels, drivers and filesystems have been adjusted to
> depend on IPv4. Keep on mind that follow-up work is required to convert
> the Kconfig symbol to bool and remove the dependency on IPv4 where it
> makes sense.
>=20
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260712013941.4570=
-1-fmancera@suse.de?part=3D1

