Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795684609;
	b=2SOcGrLzsH5yM8Iv9kaUfWItpGxWpKp17yJP//w+yrcLvUvz4q6tVYuzog4HUtpSrzRk
	 PNdIPDgenYvkrX3w9j5xkkKZ5qSohYDIfdUQQot5y/1+i/w7PEUpBfxbg1v3NBt4gvDQp
	 MMA2GJM24p9nGbGKdHGmfL+aLr08OEcCQHWzwmIfIHlDZvJGCF0Mx7QLPLd+KHShb6EfY
	 KrweCtOhLJyTDDDyC4EwSyyQ6o2ZoFSsWgW20DafVOFbLFI8+w8rVK+pmLTjrB7exT3C5
	 AjE7UkcfvIEsRJrZug3EtV5PGeCIEICIamdoBuxLuG9wp5A+2TF7YtA7OrcDnpFbxIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795684609;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=hb7rFjI8cEAPUcCjDKUxjTA78DcUBkPvCo2vrjiUA1A=;
	b=ltYe7/z6zMTgQGFtVsCIqzjIhLDf6NPHnjQcXtJPnLWMdeBejniPH+SNyljGpFNQMGTe
	 LS+vEuWLynC79gtQOsQwaBDCmL9XpKhVdu7r9k0H7NyXq5MDQ/c6vsj+OOZgrJx0fyX0e
	 b82rkJQMt4nxUTgZqrbDi148nEItCKHu4sVNFE2mI8uQ7pf7z1+S5dKHaODFfNFTIoCQ/
	 VbbeVnRvTao62h1fx6LU3frv/ngr/3YB/KdG+ng3A3ROydw7yaliiS+5Z8LTVZZW4+Uj+
	 t478rs85riP+x+QTW+D9rNbBWg0x25Swm3V1Sv2lCEG7UPY4mr8fvAItXcJFnqKU6Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UucVRK3w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD05606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 09:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UucVRK3w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6577F1F000C4;
	Thu, 26 Nov 2026 09:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795684609;
	bh=hb7rFjI8cEAPUcCjDKUxjTA78DcUBkPvCo2vrjiUA1A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=UucVRK3wgMTAQBidduYS2ugiCKfOKigZUoKlVSLzS2RrQnI6UfzorNTryy+W0ZoYR
	 tvlLHAONcNi8V72Zv9Gq0fVAm0b381iE4x0paJUbFWrVFCrZ//eSa0DXINYI+tyxfj
	 F+ang677p5+KtoOIPUNuU5xVQDQrUu6HiO479ojbwWXsno7CzWFTyRCAc9A21xmqmb
	 T9kpSnV97+oz3BzgP7pUZHHwLYjO0FVXBZNSvnPCPCPw8UmDaUvm9Abg0oifEVSru4
	 raVDyyeiwuUqzEbrbZnZVBRgc7DS82/xj573RMmowK+kgUT4XozRpHjBBlkJltQuke
	 AjXhnUjGzsKRQ==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, Wanhui Fu <fuwh1120@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261123062641.1964605-1-fuwh1120@163.com>
References: <20261123062641.1964605-1-fuwh1120@163.com>
Subject: Re: [PATCH] RDMA/mlx5: Remove redundant kernel CQ resize code
Message-Id: <179568460613.1252598.15739902565049084241.b4-ty@kernel.org>
Date: Thu, 26 Nov 2026 04:16:46 -0500
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
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 23 Nov 2026 14:26:41 +0800, Wanhui Fu wrote:
> Commit ce68351be075 ("RDMA: Clarify that CQ resize is a user‑space
> verb") made resize operation only used for user-space. Thus some
> data structure is redundant and some code is dead code.
> 
> Remove redundant code to simplify the resize function.
> 
> 
> [...]

Applied, thanks!

[1/1] RDMA/mlx5: Remove redundant kernel CQ resize code
      https://git.kernel.org/rdma/rdma/c/1f7aa7b3e3fec0

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

