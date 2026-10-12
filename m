Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5B93164D8;
	Mon, 12 Oct 2026 06:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791786823; cv=none; b=YS1zI6OvjMrEtMge5ESyBwYXvvAjIhH8ugXztx8z/46IhmzclaDC8bLzWqMq4o3HZk6hw4EYachcEVuNLs4SVNZ8XxWYPrE2AslmLLdo3BOWGQti+Tpj96ZCT6izN9gtzaMj+XdAm+gCKJAQLV2BQhGNZCWeLuqVQ3RrFHlE2AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791786823; c=relaxed/simple;
	bh=3D4xF39AFDs8uTInc1bj+woOrOcBTjDl1DC/X52bylo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=usC5kvQy0YfHuNYCiGW2D52dbcIB8pQX2DzBtCoNZ6tqE8i+mS+e7E4+TLnn/y6ldsvxm2XWpQ/v7To/m8hFLD4Iyx5mjlzSCEWIJnwvHFJCeWAFxgdvrC5GNTlLdZfMVe0e8gv0ydS9Kph5kY2xd1CEnhxPmVUu6sWudxMl60w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ceMtcjgE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ceMtcjgE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65671F0089B;
	Mon, 12 Oct 2026 06:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791786822;
	bh=T2OeqgQ5o9uT/B7vBiaJV+HJMkcE2OLv6vufUzf7Vws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ceMtcjgEleJ/sJLvTFsZDWAXo++hahBVqOMJcrFi18pUeth1DWG7MlTSt3x0qC0Me
	 lV7wKuAEpHr44biD8vek1EQqx/sZQNnQmaFxAFsvQD+fq2n6DY73hA9aSRn3ZXpEtd
	 t1gatC1r6sHoyfgmiQt0sxnHEpBuXxMZIQxnwcpN44K7i1RHUExDVfbR8l7VIPwGdY
	 xXzvn9fVlAjeNb2FqWcuG1++Gv5lZujJJc/uaooF/oNzjmY7PBYjyUfErBCeBbwb1Y
	 Jn6Co5cKTUmnL5YesyUbE9gs87hvGA609XDbfOctlwWybMy3GZhjLI7FbLtsnwso2U
	 mKt8+8jswPTSA==
Date: Mon, 12 Oct 2026 09:33:37 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-rdma@vger.kernel.org,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/irdma: always route IB_WR_REG_MR through the
 allocated PBL
Message-ID: <20261012063337.GF27033@unreal>
References: <20261007095312.1523211-1-metze@samba.org>
 <acccb494-988e-4b87-b40c-42421d2e31e5@samba.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <acccb494-988e-4b87-b40c-42421d2e31e5@samba.org>

On Wed, Oct 07, 2026 at 12:26:25PM +0200, Stefan Metzmacher wrote:
> Am 07.10.26 um 11:53 schrieb Stefan Metzmacher:
> > irdma_alloc_mr() always allocates a PBL via irdma_get_pble(), but
> > irdma_post_send()'s IB_WR_REG_MR handling only pointed the FAST_REGISTER
> > WQE at that PBL (chunk_size != 0, first_pm_pbl_index) when
> > iwmr->npages exceeded IRDMA_MIN_PAGES_PER_FMR (1) - leaving chunk_size
> > at 0 for a single-page (npages == 1) registration, telling hardware to
> > use direct/PBL-less addressing for a registration that was never
> > allocated that way.
> > 
> > This reproduces as data corruption / an IOMMU IO_PAGE_FAULT when a
> > peer later performs an RDMA WRITE/READ against such a single-page
> > FRWR-registered MR, even though ib_map_mr_sg() itself reports success.
> > 100% reproducible on iWARP, intermittent on RoCEv2, with fs/smb/smbdirect's
> > own single-page memory registrations on an Intel E810-CQDA2 (irdma).
> > 
> > Intel's current out-of-tree irdma driver (2.6.96) never gates this on
> > npages - it always sets chunk_size/first_pm_pbl_index based on the
> > actual PBL level (PBLE_LEVEL_1 vs PBLE_LEVEL_2), matching what
> > irdma_alloc_mr() actually allocated. Mirror that here instead of the
> > npages-based heuristic.
> > 
> > Also drop the reg_addr_pa assignment. irdma_sc_mr_fast_register()
> > packs reg_addr_pa into the FAST_REGISTER WQE's PBLADDR field, which
> > hardware only consults when chunk_size == 0 (direct/PBL-less
> > addressing); with chunk_size now always nonzero for this opcode, that
> > field is never read for IB_WR_REG_MR and the assignment is dead code -
> > Intel's driver never sets it for this path either (only the separate,
> > non-FRWR irdma_sc_mr_reg_non_shared() path actually branches on
> > chunk_size between reg_addr_pa and first_pm_pbl_index). Removing it is
> > not required for correctness: *palloc->level1.addr is always a
> > page-aligned address (low 12 bits zero), so it could never have
> > collided with the first_pm_pbl_index bits sharing those same bit
> > positions in the WQE word even if some path still read it.
> > 
> > This leaves one deliberate difference from irdma-2.6.96: that driver also
> > ties local_fence to the WR's IB_SEND_FENCE flag
> > (stag_info.local_fence = ib_wr->send_flags & IB_SEND_FENCE) rather than
> > hardcoding it true for IB_WR_REG_MR. That is a separate, non-corruption
> > behavioural change, so local_fence is left at true here.
> 
> I realized to late this was changed just recently in:
> 
> commit 3fb905f07ea45b31c8f67ba6e4668de46f527e65
> Author:     Jacob Moroni <jmoroni@google.com>
> AuthorDate: Tue Sep 1 16:00:14 2026 +0000
> Commit:     Leon Romanovsky <leon@kernel.org>
> CommitDate: Wed Sep 2 12:27:03 2026 -0400
> 
>     RDMA/irdma: Enforce local fence for IB_WR_REG_MR
> 
> I also noticed that these two from linux-rdma/for-next
> are in conflict:
> 
> 4a93466061d38f159b857aad63a9cc3cd3affadb RDMA/irdma: Remove unused post_sq arguments
> c470050f2a7a7748ce35367e828885a8e658d712 RDMA/irdma: Preserve fast-registration IOVA on 32-bit
> 
> What's best way forward here, is this something that
> would go via linux-rdma/for-rc or via linux-rdma/for-next?
> 
> as we're at rc6 already waiting ~3 weeks before it hits upstream
> is fine, I have it in my local test kernels anyway...
> 
> Should I resubmit a v2 with the commit message clarified
> regarding "RDMA/irdma: Enforce local fence for IB_WR_REG_MR"
> and should I base this on top of linux-rdma/for-rc or linux-rdma/for-next?

After -rc4, almost everything goes into the -next branch. The only patches
we still take into -rc are those that fix UAPI breakage, regressions
(introduced in the current cycle, at least), kernel panics in non-debug
builds, builds breakage, and other small issues that make you say, “Oh dear...” :).

Thanks

> 
> Thanks!
> metze
> 
