Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794746528;
	b=bBy6chNA0xg9kl3ISMl1P/33xAOC80DIVysabHuDiEG7MsYi7gCPoDBifugo7Fx23m84
	 PWg+JtJpJjNCQ9XMNJGCszYgffReqybeCgl7/AdmGbUR3oH4RzUs5HiGyWj20/16DgvuG
	 UBteC6tRag/kaqdCal4s/VmuRL1g8RqJIgj/4TxrG6xZXcksOwf/AnScvqkGgxe5oxNyM
	 eFWdOZU+7sXhPmaln9KUWwSkRvnVIlmKEeGgLjC30PoBznvC6cVsVyGmOVBl+PnMc0xzR
	 g6zmDnxLz5Nln+JlOyfbkMrICt+JvJ8AbeOmXfaQGbm+CoVi6lntvWuEO9xbz4luCMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794746528;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=KfwOhbMRwZYcD/b3lsAKsMTdrdUiFKnowzL9PLDU2gA=;
	b=eWTEgTnS4cJe/zGHrIvYk3hQavrhFCyL2jpb3gpxpRKVKxIFfcoQfCvvpbBLiepdLzZs
	 SSS7nt8589GMjrDiJ6+0ianvJewV+Ut9AZGizxkAQRIjGgcpcsRYQSMrL+BTb9di1pMoA
	 641rtbVu8It8+5NxJOmR/agVjULC3XjWTjIBmz7E6ZnsMo2CErJ26eK5NPZ4uKfuREf3v
	 M+nmxHA2UnGreexwJO0wY9dS7FzBUqdx9naOOsq92tDWBkp0u1FN0HVxN6asSkgkI+Q2o
	 dAzSk2dZ1BdCeUR2iLb4csxw0qTnUcxFrCnSEdCZIluSRX2JV7og3uq7FlqyFN9YaGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Oo5c/auL";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6326606A31D
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 12:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Oo5c/auL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45491F000C4;
	Sun, 15 Nov 2026 12:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794746528;
	bh=KfwOhbMRwZYcD/b3lsAKsMTdrdUiFKnowzL9PLDU2gA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Oo5c/auLrhvTTGDaUPipd5Bv7KbqVKB/fUcTPcH/jGOLkj+lRJHjJuvRm6mFW8mPL
	 aP8+Z0R19/dp0DOCghDKCo/jLog+1lYctJZ3dGBmuU8kSbM0efLPPlZQPwFOEI6Fxx
	 +l5x2yiNFGEKZ5EQE6mLGtMssF7bE3YKrRmHczKAaRzhfNdTRphavzowghpEZ5ja7N
	 9Ux6sPWpuQBg6r54SnbCoCF6ttCqcXAn/Jn+j0kcHYVErbOZ7K1mYwy1ELF4xWysNh
	 hEHQSBhmX0TMOiSiIoLcJ/rtnmJiYMJDjA+1OX0QwqbRUGtyCuOlgDigAaRF1lStNA
	 Aa0rGnjaNVNCQ==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, linux-rdma@vger.kernel.org, 
 Michael Gur <michaelgur@nvidia.com>
Cc: Edward Srouji <edwards@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20261102223325.2115128-1-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
Subject: Re: [PATCH rdma-next v2 00/15] RDMA: Support HW requiring relaxed
 ordering and add Unordered access flag
Message-Id: <179474652540.1251023.6081466559373397899.b4-ty@kernel.org>
Date: Sun, 15 Nov 2026 07:42:05 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 03 Nov 2026 00:32:53 +0200, Michael Gur wrote:
> This series prepares the mlx5 stack for hardware that restricts strong-
> ordered memory accesses, i.e. HW whose fabric doesn't guarantee memory
> operation ordering. The HW may choose to reject creation of an mkey that
> doesn't request relaxed ordering, so every mkey the driver creates -
> internal and user-facing - has to be handled accordingly.
> 
> The previously added 'ConnectX-10 NVLink-C2C' PCI device is such a device,
> as will be any future PCIe Gen7 UIO devices.
> 
> [...]

Applied, thanks!

[01/15] RDMA/mlx5: Allow optional access flags in DM registration
        https://git.kernel.org/rdma/rdma/c/254ddd3eee1089
[02/15] RDMA/mlx5: Allow optional access flags in DEVX UMEM registration
        https://git.kernel.org/rdma/rdma/c/7f69ff741d5045
[03/15] RDMA/core: Allow optional access flags in dmabuf reg ioctl
        https://git.kernel.org/rdma/rdma/c/756809c5538b16
[04/15] RDMA/core: Allow optional access flags in reg mr ioctl
        https://git.kernel.org/rdma/rdma/c/59f62a8d8d32f7
[05/15] mlx5: Rename IFC bits of relaxed ordering fields
        https://git.kernel.org/rdma/rdma/c/82bf8589c13bca
[06/15] net/mlx5: Add IFC bits for new ordering caps
        https://git.kernel.org/rdma/rdma/c/c512ebca3d30fc
[07/15] mlx5: Consolidate mkey ordering setting into a single core helper
        https://git.kernel.org/rdma/rdma/c/876e3ff1f0212c
[08/15] net/mlx5: Enable relaxed ordering on resource dump mkey
        https://git.kernel.org/rdma/rdma/c/6238ad7df1404d
[09/15] net/mlx5: Enable relaxed ordering on FW tracer mkey
        https://git.kernel.org/rdma/rdma/c/58f869ca743065
[10/15] vfio/mlx5: Enable relaxed ordering on the live migration data mkey
        https://git.kernel.org/rdma/rdma/c/b66642ff406eb5
[11/15] RDMA/mlx5: Enable relaxed ordering on ODP null mkey
        https://git.kernel.org/rdma/rdma/c/c3d03c36dbc38e
[12/15] RDMA/mlx5: Converge UMR access-flag cap checks
        https://git.kernel.org/rdma/rdma/c/f170699b8a279a
[13/15] RDMA/uverbs: Add new Unordered MR access flag
        https://git.kernel.org/rdma/rdma/c/59e0ab9ac05401
[14/15] RDMA/mlx5: Support new Unordered access flag
        https://git.kernel.org/rdma/rdma/c/e41579a849937c
[15/15] RDMA/mlx5: Enforce relaxed ordering when HW requires it
        https://git.kernel.org/rdma/rdma/c/ed876261d0cdcd

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

