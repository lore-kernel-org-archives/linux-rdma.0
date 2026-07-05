Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1783A3815DD;
	Sun,  5 Jul 2026 14:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783260060; cv=none; b=fi3NWdqopEabJ7PoNSyR6IES8QcsiOO0pH/rv4gQy+U9bKNZXv8He/+lRDebNus2rbiWsq7WD8e10L3Rl3yR9oU5tafDiezG9BSKo/fC3dn1P2JdS5VpsF08vmjEAqDXLoLS9B9wgivuky5ovMMZBgJHWeS/95OubZ8IcJE9CF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783260060; c=relaxed/simple;
	bh=f8D3+xN9REuYOdEaTiuV1Y497YUkxMYf+sFbBacpUdU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=YbM/sQzN2m0Jj3UzsXLFvGzhdjPBdlVUbVtSXVEguDlqHAw7W0U1CV1a6mnB7uSPlnerOi1qOm/XtknRZOHsV4G7K9lOJ2XjrssyKXqxCQDUsqwoiRo1TTKWQliZ468ekZqd7G/YnzfsYI8WjW5ctanCMzYuuBublJud5XMGV44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e4sB04bL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e4sB04bL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507F11F00A3F;
	Sun,  5 Jul 2026 14:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783260058;
	bh=I9V4OGY0llBBClorw61zvtdebs7AbefmNKvCwmr+1iI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=e4sB04bLF6nufZ0C7PoK8JX0NKpjIlDkdUeWkKEQSZr1el5s24Y4CO7qMPxn9+cZb
	 2SvqHj2ooR7RIhU8fdiuFUZ3hu8unv6MW46DYxvSi2OM3dWXyyiTQQX0dwc9qfUcYc
	 F21YLYm6Ho8+hbX8jO6t+7nhbzaTr81dc9qqmdhcPpuOv2lW2JH69mk5qDGCQ+Howi
	 EpW8KbXWd0PikV2AL4gx1MjjtCa1aOb+Zw4wsPZDtu3xhcWsBxPJ3QJqcPH8879Dw/
	 Fy1uiTAtNTBrHN22x15eRntutMg/LLjdZK6YCUtHonXcbKSqnbUcJskk6zYEAkXeeO
	 w3SeSx4Mwhr2A==
From: Leon Romanovsky <leon@kernel.org>
To: Krzysztof Czurylo <krzysztof.czurylo@intel.com>, 
 Tatyana Nikolova <tatyana.e.nikolova@intel.com>, 
 Aleksandrova Alyona <aga@itb.spb.ru>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, 
 Mustafa Ismail <mustafa.ismail@intel.com>, 
 Shiraz Saleem <shiraz.saleem@intel.com>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
In-Reply-To: <20260624144846.61242-1-aga@itb.spb.ru>
References: <20260624144846.61242-1-aga@itb.spb.ru>
Subject: Re: [PATCH] RDMA/irdma: Prevent overflows in memory contiguity
 checks
Message-Id: <178324946774.906796.6761274205609866502.b4-ty@kernel.org>
Date: Sun, 05 Jul 2026 07:04:27 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 24 Jun 2026 17:48:46 +0300, Aleksandrova Alyona wrote:
> irdma_check_mem_contiguous() and irdma_check_mr_contiguous() verify that
> PBL entries describe physically contiguous memory ranges.
> 
> Both functions calculate byte offsets using 32-bit operands. For example,
> with 4 KiB pages, pg_size * pg_idx overflows 32-bit arithmetic when
> pg_idx reaches 1048576. In the level-2 check, PBLE_PER_PAGE is 512, so
> i * pg_size * PBLE_PER_PAGE overflows when i reaches 2048.
> 
> [...]

Applied, thanks!

[1/1] RDMA/irdma: Prevent overflows in memory contiguity checks
      https://git.kernel.org/rdma/rdma/c/3cda0dfe8c651d

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

