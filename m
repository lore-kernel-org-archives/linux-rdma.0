Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794083090;
	b=sjAiIHj0huegilVTHLmTm4Yvz857GwOL2h0yqdl7CfMeY7kg/E2zTKm7DwRlUj7GexkM
	 zdLH96SQTFX3YDGodpUj3xk6F7l2oD94lfBJyjNWUjIYxnbwEaMf2vqHX8eaaV9oVuF1V
	 wKHiUNyRVwxvFsT6hc3lhMfH1V+DUFUlqS8V7cpCAKs5ntYzEsog4koC6g+f/+mgeq7Z8
	 nFI4m/Yi8eMqKoQynG+aWOSHP9dEcMlHfIMIhunNT+ZKIm8iF+bBt837Z8AqVroSNDLs3
	 bGtMBV6yRFfcqsXYaWE4pqhGh1vz8zd7fcBa+8yzkda3qWxZNakPq9OU8Zcuv0ZcA8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794083090;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=pu1pe8eDqY/kb7H7Vv4RY02+044IW1jA59qA22PzvKc=;
	b=NPCLSfDu+NSzW+VBiAxI6jEPX5X9Mr6nxxIhuAsEvsDj4AKHHe3Nm/+CSvVoriCNnQ0y
	 kGOiS0aSNnKeCo3llC1kLjn6XBgwmXJYVHfW62gSBb+9A7CNwohozWehqQkgsgDFNSjG7
	 ZZ8ufwI1FHy9Cc2SB1+sxpBXVd/mZ7MLnWcgCO8IPDLOPbM5cjSTDX5mftN4T+QHgzAyM
	 GXKl+cJfNhh2JIrwbb3UNUmlAMbqn5fpqeMG3gDOFuBw3xRBRykx46jf6G4qZedP2rsU4
	 QhK/hkBkimm2/My4oELnREeUbIi8kWV9PXsdehBJLZQlZeeM+Fu8F0ghgmFdUE5th/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VhjjRP9d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60EBB606A32D;
	Sat,  7 Nov 2026 20:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VhjjRP9d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380ED1F008A2;
	Sat,  7 Nov 2026 20:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794083090;
	bh=pu1pe8eDqY/kb7H7Vv4RY02+044IW1jA59qA22PzvKc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=VhjjRP9dGGaEv7BFSz7CCOWiHyrewdkdgJ7gVkdyEu6o0q3M4p418xJ6QHnh7wEWC
	 osVPntetU/XFdGL6FuIlN0zPvHRgBWlcdQn7jPjQDiupCemKRF51EB631cPiTX8IR+
	 iNPMeARl2bzFieS8wD0hfB/3c+VzJLYKfzYtRaXAz0ts07iKoVBXuFvCOd9d9WQLaS
	 7CoD9cUA+K7ZG/A+V84DcuKLzE/l47noY1MtmG9G4SjkUzIiAr/1v82UfdX9Hy4HjM
	 BOcCDnSiuAnUvzFrlvEv3CReW/GmRmcIfnmNV2Ydm9Yr1M2GSGzq6FBgT2rQi2VdjV
	 73gwQXQNFRmoA==
Subject: Re: [PATCH rdma-next 07/23] RDMA/mlx5: Derive
 mlx5_ib_adversarial_mode global from mlx5_core adversarial API
From: netdev-bot+sashiko@kernel.org
To: yishaih@nvidia.com
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
 davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
 moshe@nvidia.com, maorg@nvidia.com
Date: Sat, 07 Nov 2026 20:24:48 +0000
Message-ID: <179408308880.994134.16800694809832426795@kernel.org>
In-Reply-To: <20261103163949.1554-8-yishaih@nvidia.com>
References: <20261103163949.1554-8-yishaih@nvidia.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit message does not describe the code correctly.

--

RDMA/mlx5: Derive mlx5_ib_adversarial_mode global from mlx5_core adversarial API

This commit adds a global bool mlx5_ib_adversarial_mode to the mlx5_ib
driver. mlx5_ib_init() sets it from mlx5_is_adversarial(). The flag is
declared extern in mlx5_ib.h so that other files in the driver can read it.

> Use the mlx5_core mlx5_is_adversarial() exported API to set a
> module-level static bool mlx5_ib_adversarial_mode at init time,
> instead of a per-device bit field. This avoids propagating the flag
> through every mlx5_ib_dev pointer and makes the module-wide policy
> clear at the call sites.

[Severity: Low]
Is "static" the right word here? The patch adds a non-static global in
drivers/infiniband/hw/mlx5/main.c:

    bool mlx5_ib_adversarial_mode;

and makes it visible to the rest of the driver in
drivers/infiniband/hw/mlx5/mlx5_ib.h:

    extern bool mlx5_ib_adversarial_mode;

Later in the series the variable stays non-static, and umr.c and cq.c
read it. That is why it can't be static.

The text "instead of a per-device bit field" also seems to point at
something that isn't in the tree. No adversarial field exists under
drivers/infiniband/ before this patch, and the patch only adds lines. Is
this a leftover from an earlier, unmerged version of the series?

Could the message instead say that the patch adds a driver-wide global,
shared through mlx5_ib.h, that caches mlx5_is_adversarial() in
mlx5_ib_init()?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103163949.1554-1-yishaih%40nvidia.com
