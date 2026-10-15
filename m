Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C2A46C4C5
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 13:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792072789; cv=none; b=TUZSamqPsQmmifUyPewRBPH6pY003PndFOWvSEiq6GxRXS+ttcSLdgNo9eneWC4QWkDKqmvD4o/1mHLRJDj+LaxRyppIakrXyBDDgmBG0IphgUHCxjgQyy5A3DCdxjTuF83SPgMMVCtl2U0/O6m35Mhqw9pfcOmo1ta5/H5sGDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792072789; c=relaxed/simple;
	bh=lGf+uMgJjuPwIS1HbVTf1L9Gut0NR3PrvsPHc84Efmw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=GR8Mok207w3cUvLeAyP/F9VjHboliG+txmmVrzPEzJXi/hb/7SBo0t7+JKkvD2Lp69ir2uMODKVvHIolxUG5+1rUrt0kp3DPU6fr4r7uJ/LK5od5iubTYM7oy+6A/Tp2Zb79DLuXA+5Cfx37qmGAd5P28EHViCqoBZ8dCII+C/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F/yfKbQD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F/yfKbQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160A61F000C4;
	Thu, 15 Oct 2026 13:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792072787;
	bh=t6JKmWGyzA82Cz1sAXX7jS5pHDA7iZf0K4XAmFE4+S4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=F/yfKbQDJPoht8tTKjtflz5jyaS4uJOLrY39n6AXRLPx9RP4iMSD63ZitmbwojNHN
	 icLkNjVwQJLbgElqmFwd/TaOsVsbxFyFqr7olynZj1ZQ6hVFJoizQEPP1Of8dQqBIA
	 QITfOM7nTUfrvnU8ucr6yLSIVK+kwxL15gWwDLUnYOs7H5dnFEMjk2yFqTL3Khdgzu
	 A2dopJTjK7tzWu5Mj0PGxie7NbYn9pzbOzRRwfh57LNkHpks1nJDCMFgECKsDssKrt
	 tGm0z2WRfJjSQzzBlCNy2Nhi3HzQzJbCU0fuisoglpghnAr6kIpkjmiPOe4fEqOysq
	 vATN0kHh10C4w==
From: Leon Romanovsky <leon@kernel.org>
To: Zhu Yanjun <yanjun.zhu@linux.dev>, Youngsung Ahn <ays511.kr@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261004153246.2951263-1-ays511.kr@gmail.com>
References: <20261004153246.2951263-1-ays511.kr@gmail.com>
Subject: Re: [PATCH v3] RDMA/rxe: bound the ODP page index against the umem
 in rxe_check_pagefault()
Message-Id: <179207278488.164616.11769142771490685098.b4-ty@kernel.org>
Date: Thu, 15 Oct 2026 09:59:44 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 05 Oct 2026 00:32:46 +0900, Youngsung Ahn wrote:
> An ODP MR has a page array, map.pfn_list[]. Its size is computed from
> the umem start address. But rxe_check_pagefault() builds the index into
> that array from an iova that is relative to the same start, while the
> access itself was range-checked against the MR's iova (ibmr.iova).
> 
> Those two bases do not have to match. reg_mr only requires that start
> and hca_va have the same page offset, so a user can register an MR with
> hca_va = start + N*PAGE. The difference then becomes an index skew of
> (hca_va - start) >> PAGE_SHIFT. Nothing compares the result with the
> size of pfn_list[], so the read goes past the end of the array.
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: bound the ODP page index against the umem in rxe_check_pagefault()
      https://git.kernel.org/rdma/rdma/c/7797bbb0e86f00

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

