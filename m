Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794443462;
	b=ynfDl4JIhUZ6clhpjHMdAwWYUjHnQ+YHUSymDGcJUw4vCUKwUuMrrlw6KOiwPTNVJ7m5
	 JiAv32mpCNQcvKcm2ygcNy+rf0tsFpSYuwPHYFKnApspZMUk4RN5M8WlOZSiaAEicSBQs
	 TDz0mXKxwA4OteStX+yHqFSuCsK/KUdwk9j49/qOfWAyarEpeSG20uvLTRAjnxHbImIls
	 jEgej711foSXNxQBZ4N6PFGKJmHfAxuJDQRp8F5lsInpnH2I3B3T9R31uf3URtct9Nr7+
	 NEZxjHq42SAdxr+sc6cQLPrTDXpSFjS10tmgHlyUP6a4Ya3XyZPWOxu1Nv++KbvdVSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794443462;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=u8jwyDC+jB0U9FbKhYxFvALBr1W5230/BU0V1E7QmBA=;
	b=wrpGpT2/cok98OG8wxdUBswwY23cuIS63PFDK5mhbDbb51+rj7AsRa2q6y3AF2pHdjr4
	 LMNRKXWicyMlb+NF70uANnGDEbXkpIqp1raYxpSyLJmTOdepxTvPCazeoqMdBcodIfI5g
	 dZ7QuSb7Aq4ZB5xnI1sA3HZSB8HDLH68IAa9EngZ1skw+38auvVQLH1auv17MHFBINBxu
	 HhLMt80tRyxHY5+zRwzAJgOfZwt/GZ3grDEDeKa7KYIGWF7Q/5yX+JxqcvTsXC00b/tjH
	 DctpCQqOeU70L/uSo1l6ktNinNfGJr70jtqlk9rP5a0BREjBtB29LO8cFK1UYIjwP3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Se7DVndj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A060606A33A
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 00:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Se7DVndj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590321F00A05;
	Thu, 12 Nov 2026 00:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794443462;
	bh=u8jwyDC+jB0U9FbKhYxFvALBr1W5230/BU0V1E7QmBA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Se7DVndjYrXyGuEh4nG9Izb+Tp/Z9WYZCVeZ0/ULZMIfQGjY65owV7+hT2UgbMLc7
	 N/oFizw+772KBIe+6s4uJvp7oiQIDnYTgbhnnuAxHbmQcC1zthGg8Jx1LpinMy9PDR
	 7MTgGPN2YYNDZhqMWrYAuQBdA5YyB9dmdZWB4KWcg6xfcFUfP9Q2PAm8LfYZEoWGUv
	 U2H3Lv6siwdceqea9YTI0EYk0tvaInyIAkQZA4jZzq/1k7TzGTj/BY20s9IIyWT7mz
	 HZ5LhK0ih/yrxJ3uycifltgJ33MUM4Z7z7qspocAsWb+/SvyxGbCOwtq1z24J98Nh5
	 ft+k0Pn95Z1WQ==
Message-ID: <sashiko-outbox-209930@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v5 6/8] selftests: drv-net: psp: test ipv6 tcp
 socket with extension headers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111001831.3710881-7-toddfreed@meta.com>
References: <20261111001831.3710881-1-toddfreed@meta.com>
 <20261111001831.3710881-7-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:31:01 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> send on a psp tcp socket in three phases, checking the device's
> tx-packets and what the peer received after each:
>=20
>  1/ no socket options. the data is sent, counted, and received.
>=20
>  2/ an extension header set on the socket. the packets are dropped,
>     tx-packets is unchanged, and nothing reaches the peer. the data
>     stays queued.
>=20
>  3/ option removed. the queued data, then new data, is sent, counted,
>     and received.
>=20
> the test has a variant for each extension header a socket can set: a
> destination options header (IPV6_DSTOPTS) and a hop-by-hop options
> header (IPV6_HOPOPTS), each holding one padn option, and a segment
> [ ... ]
>   tcpdump -i <dev> -nn -A 'ip6 and src host <sender> and not tcp'
>=20
> shows them as udp, with the test's payload readable.
>=20
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111001831.3710=
881-1-toddfreed@meta.com?part=3D6

