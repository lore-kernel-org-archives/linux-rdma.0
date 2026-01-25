Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF951F131A;
	Sun, 25 Jan 2026 13:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769348504; cv=none; b=iDVT7Z0vq92/8476j/dPKm7FstGzbFUlYqXGaZDqKU8T7weub8kA/5GxvantANYc7vFfm6bOGib0RzcLC3ST8zE6rfzpSBjBFw/9ASYUZFtkkBeG1WAI+gsJ4a55XEcGXDD9XFyOTCjGRmnVZPYzXbW+IljCJkSR9mzgyp8hqsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769348504; c=relaxed/simple;
	bh=HYMhyMR6LH50Dbm3wRC/SwJSWFerK9gyfCzFrkFyWmE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=VUYGtdoc6fGSNZs7+YV6sYXv70gExBw01aGexWedM6a+AUIFTyegitWA41TZVl0dPVnI1ztoW/qAyPMAUcHZTRsfWklNLeKMon0jcsBmunHTIBidzkouYG0Kwv6fssToRspEz5b/CQ9fzeA2+ChEkxeSRwbpeiOUpcF7G5AqyzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rprCrEd+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rprCrEd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA52C4CEF1;
	Sun, 25 Jan 2026 13:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769348504;
	bh=HYMhyMR6LH50Dbm3wRC/SwJSWFerK9gyfCzFrkFyWmE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=rprCrEd+1YBZkvE97/R7Z91+2k8ojFUywg2KkfKhDPvelDUwpkI0PaqxMbb+NsQSD
	 cYq3jgW5mRZXcc9YoQHQQgGeeZqRQYJ6wJH4H0KKm1WuHSL7MiC1x2WJbC3WMpBRuq
	 fEv04MxVLwK/O+H6snfIoUoOb/H90fZWKuMtP9M4rmT4DOwZSuUz63fCe4EQTJlYAh
	 5I8kPSI1ECeWMZ32gtvxTQOR1JB6/iCxsGAiDKRpdIdIis8l2R9+nVMunQ+8M+ydwP
	 nVCUGjs/cDB8A6pJ3WSkJM7hT47q2yFF8i4S4EAM5Ri5aSDNBPE9KNcCCvmTF2fphF
	 WHLuv+12567qA==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Li Zhijian <lizhijian@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, zyjzyj2000@gmail.com, jgg@ziepe.ca, 
 Yi Zhang <yi.zhang@redhat.com>
In-Reply-To: <20260116032753.2574363-1-lizhijian@fujitsu.com>
References: <20260116032753.2574363-1-lizhijian@fujitsu.com>
Subject: Re: [PATCH RFC v2] RDMA/rxe: Fix iova-to-va conversion for MR page
 sizes != PAGE_SIZE
Message-Id: <176934850129.885318.1848511655256311844.b4-ty@kernel.org>
Date: Sun, 25 Jan 2026 08:41:41 -0500
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-47773


On Fri, 16 Jan 2026 11:27:53 +0800, Li Zhijian wrote:
> The current implementation incorrectly handles memory regions (MRs) with
> page sizes different from the system PAGE_SIZE. The core issue is that
> rxe_set_page() is called with mr->page_size step increments, but the
> page_list stores individual struct page pointers, each representing
> PAGE_SIZE of memory.
> 
> ib_sg_to_page() has ensured that when i>=1 either
> a) SG[i-1].dma_end and SG[i].dma_addr are contiguous
> or
> b) SG[i-1].dma_end and SG[i].dma_addr are mr->page_size aligned.
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: Fix iova-to-va conversion for MR page sizes != PAGE_SIZE
      https://git.kernel.org/rdma/rdma/c/12985e5915a0b8

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

