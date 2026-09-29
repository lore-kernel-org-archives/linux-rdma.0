Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E94C5505F0;
	Tue, 29 Sep 2026 18:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790706729; cv=none; b=OASkylYbpasqbJHaijhCJSbAuyL4wvB1MOwVYCVcrRUE0NVR6EuXIoNQpPFSbl4UKGdHgA45HEjAvjyDtavVxjq7SWKV9o1NvAwItFSCQBqWzU4pKey9KF/XQGbGirKN5klRn6NJU3OIGlpWTM2RxWYopwJ0ZmVPfgsySNuf9qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790706729; c=relaxed/simple;
	bh=KuSL+6yE31wVrGnn9WUJMFiojwk6BfayXAMRC0rOujs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=VcTSqOUc4RNTmxdEz3DtNnMECm/Int4ak3i5x6UgCojQJVVoOKzESKoaAQbxWHNhhMW+mIKenZigTBmhph99+t1XXY/8C17VTinzNPVr8EBnhQRlnrSDWvumZ/3CF1XJ8MHD30YwzwzDjd/d/VLYIOegmlmgvMVbg4CPTAUIpdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jYTtpN6G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jYTtpN6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149521F000FF;
	Tue, 29 Sep 2026 18:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790706727;
	bh=fAD6b9RtU8hBm4TqIrFG/AIDHb7hjw8jXLJPjfv30Ug=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=jYTtpN6Gxfup5qv1LmjaUvkD4HhmekGzdQUxLMiGKzHVd/DWOskl3a0iLMwMnc8MP
	 U+9iTnpEW5kXVcNgZ9HGb0lJkicAfiYuVvIPRIqIO2S2a1J9MliMffROuytPweqIX5
	 Susxy3qexonnZKqJ2AM7D+8PisvcJUGQniNpD1izmlJ3ALn5vRxSs7zDnxTEm9moOA
	 UkzXjCLDs7Qe5aagMKHM573m9Jknh9EvgW9FWPPNlyZseBA/WmAFgzLoP5wGO9nUib
	 2m8qVwYzplbSLJWi15Rx0PxmXjRCvqlUqV8obDAL6qKVB9kt/BDLq/YHZdxtOls8RJ
	 rOYp36oivRpcA==
From: Leon Romanovsky <leon@kernel.org>
To: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Bob Pearson <rpearsonhpe@gmail.com>, Daisuke Matsuda <dskmtsd@gmail.com>, 
 Norbert Szetei <norbert@doyensec.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Zhu Yanjun <yanjun.zhu@linux.dev>, stable@vger.kernel.org
In-Reply-To: <20260923-rxe-advise-mr-v3-v3-0-95e1a4077e4d@doyensec.com>
References: <20260923-rxe-advise-mr-v3-v3-0-95e1a4077e4d@doyensec.com>
Subject: Re: [PATCH v3 0/2] RDMA/rxe: fix ADVISE_MR prefetch on non-ODP MRs
Message-Id: <179070672490.3973661.17606940533193497773.b4-ty@kernel.org>
Date: Tue, 29 Sep 2026 14:32:04 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 23 Sep 2026 16:40:48 +0200, Norbert Szetei wrote:
> ADVISE_MR prefetch on a plain MR runs to_ib_umem_odp() on a struct
> ib_umem, giving a KASAN slab-out-of-bounds read in
> ib_umem_odp_map_dma_and_lock() (splat in patch 2).
> 
> v1 checked is_odp_mr() after lookup_mr(). Leon asked for lookup_mr() to
> do the check itself, off mr->access. That only holds once mr->access
> cannot disagree with the umem, so patch 1 stops the two paths that
> assign mr->access after registration from touching IB_ACCESS_ON_DEMAND,
> and patch 2 passes the flag to lookup_mr() in both prefetch arms.
> 
> [...]

Applied, thanks!

[1/2] RDMA/rxe: Reject IB_ACCESS_ON_DEMAND changes after MR creation
      https://git.kernel.org/rdma/rdma/c/2dac7006b9fb46
[2/2] RDMA/rxe: Reject prefetch of a non-ODP MR
      https://git.kernel.org/rdma/rdma/c/66f18a749a3eee

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

