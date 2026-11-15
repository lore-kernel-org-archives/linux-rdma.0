Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794749563;
	b=GW66Ey9ZQQH3XoxziPr2aIwpNYmi4PUjQqY4m7Vuy5yASJo4N1c/gjhvrpUbEG89IXkX
	 RE886HUJaa0Jts8+9Xcizd2qBuMsvsUmqNYEzCRUXh+SCIGNJWIHP/7IgbwO7yk7QkcG6
	 qxsogfvfM8wd3mSztdeRKVVvpkMXJD0xtxj8nI0y9kAs2tvnmJQXUFI7jlLV2zVEXe5ob
	 LvYbWANDs9WnFI0mp/LTgOgKVkSaUEZfWFIp7J4xhqbyM2Lwzi8ZnIf0YslUDRG/ReEGA
	 oIMbOUa9xy/lpcuXnuZP/QpX15g5Hs0tWurSoXw+rBtKQjfpvkrccP5pzDVjE6ZqP+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794749563;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=tvoqpx8A0aIUjbW7MjuoIHovY+4ciTgdmTztZFjOrzo=;
	b=FaLlu5V/ZeApeIYdazbReiCL3oFvn3v40iUFQOERj4lcFwNaB9o4KroF3aUjEmmaLXHe
	 qumTZCHTw2pifuvOmRbD8xCzKWXsu4iGlxEoOW5pMgaFUG+OkHsIcqjOiDouiWP1NnBb9
	 GKzY/bN3+oinCdjIa/KMXr5KcY+4F4lqfRvhWWlr/RNbMUNkr+1o7ga2kvlz8HUHAIAva
	 Gr4W8sLGnoBBnNDnwsOas3+XpXdJOL7CyaoEZEFQNHbaCROVkRqyMNqSDcNqiLbgLOXUD
	 Mhc6y7C5x5DzYp6xWBWfqJMt6jbbRHnRHtv39Wil1lwebO2btySboqimNgq8WpGMi1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C2GFzjjS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D76606A31F
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 13:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C2GFzjjS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C14A11F000C5;
	Sun, 15 Nov 2026 13:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794749563;
	bh=tvoqpx8A0aIUjbW7MjuoIHovY+4ciTgdmTztZFjOrzo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=C2GFzjjSoEcz7vUBVuV/bYc9VDnVqGMq2ODyPBx/l+AHAs3+7hBI83Z60q6KMircB
	 8yyJK+A1Hdje6FIKI4EsScPI4DV9lO/FU4C3T5xBb7RWD9rTLzriaotX258P2mmsXC
	 A/7fkhex+ot1Rx81jTCbKbHlA5YXcw0QiEaBrQkz3LZK/m1gvzP2ZeCwfeDP0jyEnM
	 kJj19B6c9I/fiQzVdCxCv8W08A84vHaBY2vwkVwytpv3nt7am48V77OHHCiCsjxc+N
	 WbwRUEa8PFCSQbxrKNCO29urPP2/DM2YJ6mRDtQrxwSh8YFA3R5Snhxw1AY0HdCBqz
	 1kGA2aCiykAfg==
Message-ID: <sashiko-outbox-215529@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 net-next 1/5] net/rds/sysctl.c: move sysctl-only code
 under CONFIG_SYSCTL
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oleg Nesterov" <oleg@redhat.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <avmyt194jNI6Le17@redhat.com>
References: <avmyt194jNI6Le17@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 13:32:42 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Collect all code used only when CONFIG_SYSCTL=3Dy into a single block and
> wrap it in #ifdef CONFIG_SYSCTL. rds_sysctl_init() no longer needs the
> IS_ENABLED() check.
>=20
> Add the corresponding init/exit stubs for the CONFIG_SYSCTL=3Dn case.
>=20
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/avmymGvelu00X5EH@re=
dhat.com?part=3D1

