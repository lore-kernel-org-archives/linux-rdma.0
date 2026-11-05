Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793873778;
	b=rw94yqRl4Dd/AiWW0GwxhoC+rD6XW+QyMrX7JGxXGhBMYy/2w3n6Y0h6vsbfIeMSg9SB
	 yrfZzeETcC4vm2enzhqgTMd20rhmrOraDY4wUF0LWPoZ5BlmuQconx3fgxrqaGsAMCDSh
	 Rv8h1ZVtF1RMqtFyUyw6cpHsDJ+M6iHox8AZ6q86UgYaDR9iuUNCwozbaePAQ24UZdqFJ
	 XAf5K7PDYkf4rv5NSxFd9UHuB/zZz+NIRZbl/phlhjefACjbQIv+ebeqrFKwbyW5KnBeW
	 jDtr2gu3NE9Q4jsSSCsLUZG03Vknn7jSIwg/VR+1E+d0icGwGoPTCJQBi0SnhT7dJlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873778;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7GzPWmPtq5M/rCUmAqve1/2UiwqoOHY8SaMKbuH+IoE=;
	b=bbi2o9oskkd1bJoyyoMtLrjKj4T4W2tVwZexxppBAk+hxMcvYbHhbJvOBAF7m5dUHb/k
	 9xRRdO545t18cQ7hpfh6v9D3mXiYyFaQeQx2RjCqSFAOmyCC31VAmihgGDAiDPzTKLt0+
	 m+iAIGhkPk2Tiu6WxW5eSVWo2MOvCZJ9OByq3fAXlTaiFV2xSBSGUIpIp5g3sg2eKLdvF
	 0LkmyB/0gsXwLVfnkUyvwZUApKpjMAh6ZKeZDHcp/35HALoheNAPZR1Y1RsCapcenFS3p
	 LggyX8YAw1761HQO+UNGvqqznFSLzEY+SdjUbsu9xY32JV0Z2MD9i25hriGnALMRH3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LbRvn0QG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB905606A326;
	Thu,  5 Nov 2026 10:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LbRvn0QG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 695071F000C1;
	Thu,  5 Nov 2026 10:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873777;
	bh=7GzPWmPtq5M/rCUmAqve1/2UiwqoOHY8SaMKbuH+IoE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LbRvn0QGrNmWUn5kj3s/2ZrvtiAt6Ge/vo6ERS0E2tik2jc6El8sSVvf9Qaq2pIPN
	 hqAPfls/cQ2N/YgsOMJ8hdXEZGmo5CX8nOK0X8UApwVHjWWeXlreg9c4H64KbQNE0B
	 634nAQtBpUyQ6mAlZr/1uk5F35M0mwlHnJVvWIevQu7doAGuDm+HpPgUHtV8wMwr2X
	 pMiqy7VPUgASH3ulls3X3HR/x4QdDm1H7f664FClj3HlF2YAGkaXQgxpsKKZ5kRhLd
	 iu3qbCJh43pUQJyxKVMDIgI4F5xdKo1urfPBxQkEWaBe0SAwDIUMl3T9Suk10H6fN6
	 1c5xaxQZkxS/A==
Message-ID: <sashiko-outbox-198831@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 16/19] PCI/P2PDMA: Document TLP-class routing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-fix-p2p-acs-v4-0-v13-16-3dd065907c3b@nvidia.com>
References: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>
 <20261105-fix-p2p-acs-v4-0-v13-16-3dd065907c3b@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 10:16:16 +0000
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
> The P2PDMA documentation leaves Relaxed Ordering and ATS-translated
> Requests undefined, although routing now depends on their attributes.
>=20
> Describe the three TLP-sensitive ACS controls and the outcomes for each
> class. Clarify that Direct Translated P2P and Relaxed Ordering cannot
> create an internal route between sibling functions when hardware lacks th=
at
> route.
>=20
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-fix-p2p-ac=
s-v4-0-v13-0-3dd065907c3b@nvidia.com?part=3D16

