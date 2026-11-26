Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795684118;
	b=XZame5bck5obWfAu3v4ZgfuO/+Ox/e49XrV3tbw3Pez738/gk7P/niCRsN7fe5PrGKSl
	 nGncMmm3ZVmLJG4Ls26pOzpeaxfFDva6JITbewC8Efbd97hH429cNO+ik74ION396gGGO
	 4mh+Q4b/sGwIQ+lkyAHgM4Bf/LuiptyRm8+c9F51PwXkPqwnD+00x3fdWP4Go3i3Q9Fhc
	 5yMhEBWQkgxGhi4pbuT5DgD2kQ2gF4pFZH6Ex0m6NPW1p9+blYIONr9knl+6eddoy2a5K
	 UD9tRR0oSkIuLq0KwvJFYEgYECCx+7g4U6sv1oTX036x0KYOd5/u+FyC22m5cWJiskg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795684118;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=OPCZzsvkKM0UvMPTYkHWRWm5EPIddGnBdOT567+t5s4=;
	b=W5opLoPB31N0so70NS74YN6IJEEPSMavRspQPEF53sVmSI/sadMwpAjtqRyCQFyDz9Rp
	 Cdl2a9+eD3gpy2A9Ie9X5G7r//BUxEcBLr5atAseQXf4lJGiJ+l41RuJM8eGZGlmjmtjq
	 1DCIV1cbuT0qMMBXV5J0QpNcaoABmW8J0r9fs0e4621w6WqjQu0rTqad0HZZtO9bgXI9D
	 NBbDRLMSOV8qo5uvI3kdroSQ0w3SFTzYPESactPCy3kPFm3300B1kVq1DIlQ6fBVMHFbW
	 w39Uvb1IlvMmL1cKEOb1cRGdb6J3+dhceTJWCp2r3UWSIKTZx4D6nsHRn4HdRZ8K4hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LnBZTHOi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84FE606A31C;
	Thu, 26 Nov 2026 09:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LnBZTHOi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3581F000C4;
	Thu, 26 Nov 2026 09:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795684118;
	bh=OPCZzsvkKM0UvMPTYkHWRWm5EPIddGnBdOT567+t5s4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LnBZTHOiEpBSCPeTzkazm6sl7iHPYRBROHlaKQDYZ8gwjZ84bnHPtDtctwgDmUwpS
	 FP482wP+8eO+f7IWDzo+fyE7a7OmiCsqeHDaGRmyO80dpMrn5V78JR2rcRsyMJPMLa
	 Zo6FqSSYRf2Losmd0eq1RDxUEWFP3SIk/Xu67lIUJMxoPIwo3l8/NZbWUBxGUtw4Sb
	 Vc0vd5B+Fl2qURhdfQuA5ZgdLUELvyPkkVxBsUmCQtQMpFP9UhDw/1fzQwz9ss/o60
	 su8gM1TmC+/RZlHU+2gkCn3AR24a9bjcDoeiR6ZcrTS7umH5Zc5BboDGpIdqeLyJ3N
	 T48Oo0VEkUExQ==
Date: Thu, 26 Nov 2026 11:08:33 +0200
From: Leon Romanovsky <leon@kernel.org>
To: shyckless@gmail.com
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/mthca: Free the AV table index if kmalloc fails in
 create_ah
Message-ID: <20261126090833.GE774860@unreal>
References: <20261123-mthca-v1-1-506d3c3a7d4e@gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261123-mthca-v1-1-506d3c3a7d4e@gmail.com>

On Mon, Nov 23, 2026 at 12:43:23AM +0000, Suyuan Wang via B4 Relay wrote:
> From: Suyuan Wang <stevewong@hust.edu.cn>
> 
> When an address handle can be stored in HCA memory, mthca_create_ah()
> first takes an index from the AV table and then allocates a temporary
> AV buffer:
> 
> 	index = mthca_alloc(&dev->av_table.alloc);
> 	...
> 	av = kmalloc_obj(*av, GFP_ATOMIC);
> 	if (!av)
> 		goto on_hca_fail;
> 
> If the allocation fails, the code falls back to the PCI pool and
> ah->type stays MTHCA_AH_PCI_POOL. mthca_destroy_ah() then frees the
> pool entry but never the AV table index, so the index is lost for
> good. The allocation is GFP_ATOMIC, so it can fail under memory
> pressure, and repeated failures can exhaust the free on-HCA AV indices
> until no new on-HCA address handle can be created.
> 
> Return the index to the allocator before falling back.
> 
> Found with a static analysis tool and checked by hand.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Co-developed-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
> Signed-off-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
> Signed-off-by: Suyuan Wang <stevewong@hust.edu.cn>
> ---
> Compile tested on x86_64 (W=1). I don't have the hardware.

This code is old and unmaintained, so let's drop this patch. We can
revisit it if someone with the hardware steps forward to test it.

Thanks

> ---
>  drivers/infiniband/hw/mthca/mthca_av.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
