Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795611620;
	b=yXJEdLvEfGR5F6oliU7lKnQ69m2LC1H5djrVOxeVx19PB6CxCAvo9OhN5IM8BnDIYAyS
	 qPhyqlPxKHaVTOW+4auWEoMs2cj7udTPm0sLa0g7knmdYqkp4sYAboDYnK3OSWGJ8O9/H
	 e8NRD9OVo06gMajJYr6fPS743wu2JZYOlfI15wd0bE/oVwvpeaawNRFTi1OzuPfXOA3if
	 fpLzDwilcrlEK44vyMSsWcdAl3NM9k7+6Sgmco/apLPUqv0b3s4zq1oDKzz8dGtNcfucP
	 gS/yQLefuHYeAiDiIligTc/Snaqr7ClFQWA8XcY2+oxBBf7bXZ5QLfq39JSRlD9f5RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795611620;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=SLxQ6+cw6WV7E3RP8ecIogz6iQ4Ut6nDCdlniho3wxc=;
	b=PRnUFQjGpBPyR+UyWNoE0fDodhwbXWr8zu9Szd8CV9+DrrqtvPfGG+Xlid/i1av04wxS
	 Mk15cjBSonzi0RK9BfbthS/o+cXYPlvTjgKEc/G+BieMRgGXfs0kM4BhmldLBSMNHHRPs
	 WjZRthak74aMbu+kKSbrXNbH7WNSAwX7ZXvETn2kxjhbcf1HH8ythKPbLjuKH6YD50qQ6
	 EtxUINEsgnTVoeTk7fkZ5FeEAB82tU3iFaixcm/E7aQ9ReqphsxvQWcOtk5gr9M5nJUHb
	 et4vTIX8IAOS8NZP03CLedKqBks8s6ozben4zvGzDaoaYfF33Tao+d5MFENEFAgx+WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XyQsk54v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B29C60A2620
	for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 13:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XyQsk54v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B916A1F0093E;
	Wed, 25 Nov 2026 13:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795611619;
	bh=SLxQ6+cw6WV7E3RP8ecIogz6iQ4Ut6nDCdlniho3wxc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XyQsk54v3dTeSAg7sg9eZu88kDGjkHy8uWk00VQGuSB5mjvmW2Efu2M19yD9eq2f9
	 deZoxBwNkOFQLWltIz2o2kB3TiCUjJA2XH3qdPcr1z9WM5bWTl+xqSeINFPgr+c8XQ
	 MV0XPQfh4wrZOG0H+DGHNiaMLO7Ho2P76HH0b1L74htW3E3vGwjML0cDL2sNVicj4I
	 BFOcqQLrD5bDSsf3nBZC7hmc+cG48PSXUhX42uOU4fC/S5dBlZ2aUYlgMkXfFvRk4M
	 9WEHmPW8ygmzbZMCbpN/CzO8Ur6PmJ0+FYDrgUf7336Z4M/PIvKbBDFbxS38MljDp9
	 1LZG8gRRhJyIA==
Message-ID: <sashiko-outbox-233426@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 00/15] xsk: Receive in the device's buffer
 layout
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261124112707.118678-1-bjorn@kernel.org>
References: <20261124112707.118678-1-bjorn@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 13:00:19 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Sashiko has finished reviewing this 15-patch series:

- Patches 2-4, 9-11, and 15: no issues found.
- Patch 1 ("xdp: Let memory providers offer XDP a view of their..."): 1
  related pre-existing bug noted
- Patch 5 ("xdp: Run programs on buffers that must not hold kern..."): 1
  potential issue (1 High)
- Patch 6 ("xsk: Lend UMEM chunks to the page pools of a queue"): 3
  potential issues (2 High, 1 Medium) and 2 related pre-existing bugs
- Patch 7 ("xsk: Deliver to the socket in the device's buffer la..."): 5
  potential issues (2 High, 3 Medium)
- Patch 8 ("xsk: Receive in the device's buffer layout"): 1 potential
  issue (1 Medium) and 1 related pre-existing bug
- Patch 12 ("eth: mlx5e: Receive into XDP-only memory providers"): 2
  potential issues (2 High) and 1 related pre-existing bug
- Patch 13 ("eth: bnxt: Receive into XDP-only memory providers"): 1
  potential issue (1 Medium)
- Patch 14 ("selftests: net: xsk: Test the device's RX buffer layout"):
  5 potential issues (4 Medium, 1 Low)

Detailed reviews have been sent as separate replies to patches 1, 5-8,
and 12-14.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124112707.1186=
78-1-bjorn@kernel.org
