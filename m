Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF34E33ADAE;
	Thu, 16 Jul 2026 05:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784181154; cv=none; b=Yn0OGPH/CSdfnyo7GNrfkwbQYsSfdTnnqbGIZFmG29J3dvJBqsQ6CCfRSHFggeDnuvG+FgDc4xolRAuSL+RC+eIDaYmVtAK1K/jGn+ggeJ+5HrQw1FfUHcsQyzi4H+LsafwmYB3v/J01/k/MxG1tcHgo1mVRFZ/c/kaqCONbapg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784181154; c=relaxed/simple;
	bh=bfWKNY1or9yAZ6lmSZT8NKBAFugv86ibAQbjP4xxvDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ETJsFoHw3dii8ec8khJpdS8c64TERMJ6CfjknRcxp486Ub+Cngsn25SW8ZKhPv0VHqRVYUthD1zLXqlAmmryUJK2HS050UrsTDQb2est7fsDDHLk03CRCsEiEGMh+LqOES6zPCKtOiHM4KXnn4To9HDBxDRAv/yI+PBrYZqhJWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=neiI1odB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="neiI1odB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0761F000E9;
	Thu, 16 Jul 2026 05:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784181153;
	bh=42o9zunWd/xaaXYt7DSJsLMeoyIGtPnWg/CcrsX96vM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=neiI1odB+yJBcwZY/ToCJ2aNApAIcNtTPpkTc5OH3JZsGVh3GT9dV+GL4wo60aYwQ
	 SDBgMB/up/GNDn2LvftZu+DJyrbBGKJoZrycesqyYPqEmNHk3QyCxG4oypKOGBN+ZE
	 dwqDgzcNY5wMZ+4Ug8y2zTyTwH8wFDltCNS/RekuTBZwAV9RICIMEBBT6atPMF2dG8
	 CWA4DxJPG3sDR02GqokmZSMPheqvDvcP14GBCA6AAT/Gmm8x392pgvwVuBgdVwDIqi
	 gN7JgGJ+54U870s5pw+Ingwpw+2Wzp3hRxn7irMRHPkUoc18MCVLE317H1Mj4II8NW
	 iGYTslRBeQnxg==
Date: Thu, 16 Jul 2026 08:52:28 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Potnuri Bharat Teja <bharat@chelsio.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
	Nelson Escobar <neescoba@cisco.com>,
	Satish Kharat <satishkh@cisco.com>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH rdma-next 0/4] RDMA: use kmalloc() for remaining scratch
 buffers
Message-ID: <alhxnOTeJHNmgkrk@kernel.org>
References: <20260715-get_pages-to-kmalloc-v1-0-b0b7fce288be@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715-get_pages-to-kmalloc-v1-0-b0b7fce288be@nvidia.com>

On Wed, Jul 15, 2026 at 02:03:08PM +0300, Leon Romanovsky wrote:
> The series [PATCH v2 0/5] RDMA, IB: replace __get_free_pages() with
> kmalloc() [1] replaced direct page allocator use in RDMA buffers that
> have no page-specific requirements. Continue that cleanup for the remaining
> scratch buffers in cxgb4, mlx4, usnic and mlx5.
> 
> Use kmalloc() or kzalloc() to retain the existing physically contiguous
> storage and alignment while avoiding casts and allowing kfree() to derive
> the allocation size. The mlx5 patch converts every allocation tier in the
> shared UMR buffer allocator so its cleanup path does not mix allocator
> families.
> 
> Allocations in qedr, cxgb4 and bnxt_re that back userspace mappings are
> intentionally unchanged. Those buffers are passed to vm_insert_page() or
> io_remap_pfn_range() and must remain individual page allocations rather
> than slab pages.
> 
> [1] https://lore.kernel.org/all/20260713-b4-rdma-v2-0-65d2a1a5180c@kernel.org/
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks, Leon!

-- 
Sincerely yours,
Mike.
