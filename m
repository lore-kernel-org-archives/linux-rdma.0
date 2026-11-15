Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794751910;
	b=qxzFHByR/0BUq/AJkabTXDcmkynOlZNblyaS2/nIPotHHtndRheZ29P5u4glElXl9tRX
	 0px3IsO7s81tVI9MVgaK0P3vF/SLggPwKHwCxF/V1i9KhBc9J/dNoLLSpouyrTdETJ4JR
	 ah5Q0Wi3xnfjpG2tHh26F4x0EarHeF3W99xe5BBT/bO8zEwq8J/vFlMCxTE0mfgsUJQvT
	 pGLJTtRW1EM20OWUxtVfIzz0o+58nx99jlhBGt85Q3nSz2MPe46NRSINn7JqodVX7+RyX
	 CFE8AmZ4UlS/RVqqJmH2bb8ip5+GMxAF8pexaWWxqGH8/3QeyBBJoUswKHOSERosZVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794751910;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=U7MX+kDR6pYMu3DhkO8X+PWV1Rqk1KS0v8+bh7F7baA=;
	b=J253WRXRml+xCbA+rk30r6fKEMWG4eHuNQezpCcj00F80TBq86tNPNtKN3WfDC+ymXE/
	 TsHGJKVMccWNsJXs7IeoWZg2nVT4up9FMyXBK0d+XFs+BE4AcoMzctGQjvr2PDt/RucD7
	 vcfbHhLsRGM/pWtsAHqZznLCBznAzpzmsamcQ+GbJ3iQk72olMz743rYbpukdTfqr5pG4
	 Vf9XQbOHCgbFAx+tOCf/JHmaJiO0AgGRtEtTtpAQZ0J28PS0tFVSNRXmQrALImV1FHY9x
	 UIBWhqXHSRWyFlq2SzZ3USv8An7rQ0alFlx7RYJdar8Wjk9fa2/jDfwG07Gj9x3M3+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h62m3uRZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02646606A327;
	Sun, 15 Nov 2026 14:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h62m3uRZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6B81F000C4;
	Sun, 15 Nov 2026 14:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794751909;
	bh=U7MX+kDR6pYMu3DhkO8X+PWV1Rqk1KS0v8+bh7F7baA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=h62m3uRZ1aP0h63BTfodrlOmYEeppLvUnG3pNkDgelLYS48GA5fo98Aq10khRQXJS
	 3IGsr6gWoia6NwBzpfLwKIOb3nXe9sRvReN8lv3OeVklR3RA9hSZKNWwvuNZ4ROUvP
	 2ndJXv3sV4qbMWbK7bs9pFX4Hm9e9rE3rZD1Y5VXMFsXnBsvdWZVt5DjWMjJFLAQTx
	 cAZQeCT8HrUhVv2CnbHYZqfgWio2mnPvkO+/Fs07f3GrletxAzswR2y/3Ou5u9fgGx
	 A9x13q0esYrDPsJ+57YIZGWEo/U03HP5HpHs9RL/znFp+ZblWXIdXWSawF1vWv01sV
	 i9ffui+mzTUlQ==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, 
 Yishai Hadas <yishaih@mellanox.com>, Edward Srouji <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Sashiko <sashiko-bot@kernel.org>, Uri Dar <udar@nvidia.com>, 
 stable@vger.kernel.org, Michael Gur <michaelgur@nvidia.com>
In-Reply-To: <20261111-devx-umem-mailbox-overflow-v2-0-1e7ca8237b58@nvidia.com>
References: <20261111-devx-umem-mailbox-overflow-v2-0-1e7ca8237b58@nvidia.com>
Subject: Re: [PATCH rdma-next v2 0/3] RDMA: Fix DEVX UMEM mailbox size
 overflow
Message-Id: <179475190675.1328244.9297005857885925212.b4-ty@kernel.org>
Date: Sun, 15 Nov 2026 09:11:46 -0500
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


On Wed, 11 Nov 2026 15:57:01 +0200, Edward Srouji wrote:
> Registering a DEVX UMEM builds a CREATE_UMEM mailbox whose size grows
> with the number of MTTs, i.e. with the user-supplied length and
> pgsz_bitmap. The size is stored in a u32, so a UMEM of about 2TB with
> 4KB pages wraps it, the mailbox is under-allocated and
> mlx5_ib_populate_pas() writes past its end.
> 
> Patch 1 fixes a pre-existing issue in the same path, reported by Sashiko
> on v1: devx_umem_find_best_pgsize() can return a page size that is not
> in the user's pgsz_bitmap.
> 
> [...]

Applied, thanks!

[1/3] RDMA/mlx5: Respect pgsz_bitmap when reducing the DEVX UMEM page size
      https://git.kernel.org/rdma/rdma/c/80bac9f85a8c58
[2/3] RDMA/mlx5: Fix DEVX UMEM mailbox size truncation
      https://git.kernel.org/rdma/rdma/c/bbd8ba74c5a37e
[3/3] RDMA/core: Don't warn on oversized bundle allocations
      https://git.kernel.org/rdma/rdma/c/204a89c69f3bd4

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

