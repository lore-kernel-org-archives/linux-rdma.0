Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795174817;
	b=Opyf9rFEy90IpjXPGAPql3uXbMbF8M6w20fyPwRvgsguvye6j1jXTNhNk1hUzK3S5/yn
	 MxJWq95jM5zVZhDQMGqesqspL+eAsZ3Jj2oeXVK1gkn3gva8rrgbRfz7tMfeBPocAkPUf
	 f7e6phceT3OpH6s+djkQM7M7XPMfZZRVezRawvYQy9SyODeCPcCE8CPJ86nGSAVoPaAVv
	 W7bKTvpLdQDeaUSk+IQyDhTZI7Isi/Ak/kndOdmAyVXcS6gxjgSerA6jdazeFpzg7daHt
	 qh7fks9vu3rBKtK7JGeU/U+8ILWTYO2dRKMGqIjcTt7RJwSW5uXPwJpLWx1Z2p+C9vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795174817;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=IkWSLbYJugGulc+KudOMsDuchELnRDk1cfAXWq+TqCc=;
	b=P411h2jFWoTLi1ky1pgJH6V2j8usVU+cLbhzNQWNty61LzoZqHB7CoVas8S/GUuI5tOE
	 4saRJ8B9zBPYCzjvB8xhCzI2Xlbe+qEytts0PkTs3aJePohUzJEzYf/Z6mpcJzIR3Agba
	 xme8UDGvJVek1Wi/8mFbF2jkU+fJMC1Ul1z5RycFbwuv9p98OUJgKIp0cC4Q4oQOj2n/B
	 Rq451i4C9Xn2D0EtZg/0vTKrn0D8uw/zoeBFhFostPhGMyhY8klCSkNr15PyW9jn9+myd
	 VNfYjJjm/y9lbe5ZYsZZbWTCAw48qY3gz1SdSp/cAVYGfteDTv6+Jx/wekQeiokbWmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bVCzEXS4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BC560A2607;
	Fri, 20 Nov 2026 11:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bVCzEXS4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05001F00A3C;
	Fri, 20 Nov 2026 11:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795174817;
	bh=IkWSLbYJugGulc+KudOMsDuchELnRDk1cfAXWq+TqCc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bVCzEXS4AQMAxwx+mpGPS4CHFyHZcaR7hsF9joOii3iSuRcf/wqxL9s3jnlSym6gf
	 cMKljGPbsQeQnAfqAkkB1Q5c/WwDhgszRTs7TiGyQQq0+16oQzm5JerGzgZBA9oB/q
	 YVTnwAMbxNCdqspd1HsSsMwd/IMxGfJo7AURLxNhEOkj7wWCX9YaX6wpbbv/BNGFQt
	 tef0EYpxNxyNi0YTa6kwz3gYJG7WNd6eCf3m1v0fzZ9M1vOhaqltnrLXCAIlGSbO/9
	 1M6ItmzUUI1PVIxWHca+5RUUVqQ1w/JtJCYSP2Iji4MaJi63QeY2zhX9eI1yasja1/
	 sHhCKcGoEULHQ==
Message-ID: <sashiko-outbox-225085@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next] net/smc: validate smc_diag_req length before
 reading diag_ext
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mahanta Jambigi" <mjambigi@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261120113708.3950966-1-mjambigi@linux.ibm.com>
References: <20261120113708.3950966-1-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 11:40:16 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> __sock_diag_cmd() only validates nlmsg_len against sizeof(struct
> sock_diag_req) (2 bytes). smc_diag_handler_dump() schedules a dump
> without a further check, so the dump path reads diag_ext at offset 3 of
> struct smc_diag_req from uninitialised skb tailroom. Add the missing
> nlmsg_len guard, matching every other sock_diag handler.
>=20
> Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets")
> Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120113708.3950=
966-1-mjambigi@linux.ibm.com?part=3D1

