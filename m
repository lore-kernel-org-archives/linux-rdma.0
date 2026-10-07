Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC11247AF6F;
	Wed,  7 Oct 2026 10:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791368798; cv=none; b=ZMy4Wsbf8v8bhxqe9H8K0u3iun3GlPzjBOAS/n0wcdw4Ly2IPIQQcmrUfanmPAKayYL/c9Dz7eX9BhnLKTqQvEUCeNHld7f5XiUiL9HkVPvdCmf+KeEmxs3xbBW1K1LURnXxlGWH7znXBU7wz1hsUEhLAR2R8cWlXTZEkQNZKaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791368798; c=relaxed/simple;
	bh=40n6OsY1r4elr4k+ueEw9vMbqB8Q5Bs0/5Hv4rLsR+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BEehJoNBNCFnnib0oThuATXuqCHuUY2XRlUQesZdM0OxtK3jADod4SEQ+jjwgYDg7ACThC3bXOXHXwIF0/GfotmtkXGvEohAcwa8bEgZz3lrR0NzFquYAm28UyzJBvnqtB427Ng3y1FIOAfEWBA/3A3MlPf66hNpTMe9a2sxT/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Ugsa54hS; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Ugsa54hS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=w9On+VUqL6TLLSQtONNi6Y5iDS4Auy48MUQ7D5Eq3Uc=; b=Ugsa54hSp+/R4maiBQw+R5Il1a
	pKPBPTDcK/Xnx+O1ZjkXq/8CN+ApPoGmZ5vtz5tq7bgomvJcv+cI0G40ERjU0QwSH95qTqTbX6QS8
	j6+Kw61qiTDqa9QIhAIM7iSo8b0jNH/b6uRiZg6jK61WzlbXL9ObecU9J+/xOsdutZiVmS9h3nmn4
	qmlhm4A2NHL0d9Z8hWBCjCfATAe84LoEiuruM4vzOp2djFaHw/A39APLboCqP7OQdp+n104avcx96
	22g6Vm+5FlqYx7JiYRvuqGUgWQErOp9Ag7PFIvoJ3YF7OP90glICpkHyT2xSH3bcXgD1InMq5y0uZ
	cOMWkcQ3ZX5loHLqsGlPphvgjQ24UKUIqLrvHYd0oUf8OrIyhOd7So7U0oL5jhJaiZur5sK9CbOvI
	7rAyEILa51fQt+Xn5d2bEAgCnYxzFpkirWeloYwVZOV2D7bgIWC1D0+FjtN0hvyQ93FRwDaZHORCZ
	ajLpKzQn+yqj0E5XLEfEbdfl;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xEOqw-00000006AAX-0TMV;
	Wed, 07 Oct 2026 10:26:26 +0000
Message-ID: <acccb494-988e-4b87-b40c-42421d2e31e5@samba.org>
Date: Wed, 7 Oct 2026 12:26:25 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/irdma: always route IB_WR_REG_MR through the
 allocated PBL
To: linux-rdma@vger.kernel.org
Cc: Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Mustafa Ismail <mustafa.ismail@intel.com>,
 Shiraz Saleem <shiraz.saleem@intel.com>, linux-kernel@vger.kernel.org
References: <20261007095312.1523211-1-metze@samba.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20261007095312.1523211-1-metze@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 07.10.26 um 11:53 schrieb Stefan Metzmacher:
> irdma_alloc_mr() always allocates a PBL via irdma_get_pble(), but
> irdma_post_send()'s IB_WR_REG_MR handling only pointed the FAST_REGISTER
> WQE at that PBL (chunk_size != 0, first_pm_pbl_index) when
> iwmr->npages exceeded IRDMA_MIN_PAGES_PER_FMR (1) - leaving chunk_size
> at 0 for a single-page (npages == 1) registration, telling hardware to
> use direct/PBL-less addressing for a registration that was never
> allocated that way.
> 
> This reproduces as data corruption / an IOMMU IO_PAGE_FAULT when a
> peer later performs an RDMA WRITE/READ against such a single-page
> FRWR-registered MR, even though ib_map_mr_sg() itself reports success.
> 100% reproducible on iWARP, intermittent on RoCEv2, with fs/smb/smbdirect's
> own single-page memory registrations on an Intel E810-CQDA2 (irdma).
> 
> Intel's current out-of-tree irdma driver (2.6.96) never gates this on
> npages - it always sets chunk_size/first_pm_pbl_index based on the
> actual PBL level (PBLE_LEVEL_1 vs PBLE_LEVEL_2), matching what
> irdma_alloc_mr() actually allocated. Mirror that here instead of the
> npages-based heuristic.
> 
> Also drop the reg_addr_pa assignment. irdma_sc_mr_fast_register()
> packs reg_addr_pa into the FAST_REGISTER WQE's PBLADDR field, which
> hardware only consults when chunk_size == 0 (direct/PBL-less
> addressing); with chunk_size now always nonzero for this opcode, that
> field is never read for IB_WR_REG_MR and the assignment is dead code -
> Intel's driver never sets it for this path either (only the separate,
> non-FRWR irdma_sc_mr_reg_non_shared() path actually branches on
> chunk_size between reg_addr_pa and first_pm_pbl_index). Removing it is
> not required for correctness: *palloc->level1.addr is always a
> page-aligned address (low 12 bits zero), so it could never have
> collided with the first_pm_pbl_index bits sharing those same bit
> positions in the WQE word even if some path still read it.
> 
> This leaves one deliberate difference from irdma-2.6.96: that driver also
> ties local_fence to the WR's IB_SEND_FENCE flag
> (stag_info.local_fence = ib_wr->send_flags & IB_SEND_FENCE) rather than
> hardcoding it true for IB_WR_REG_MR. That is a separate, non-corruption
> behavioural change, so local_fence is left at true here.

I realized to late this was changed just recently in:

commit 3fb905f07ea45b31c8f67ba6e4668de46f527e65
Author:     Jacob Moroni <jmoroni@google.com>
AuthorDate: Tue Sep 1 16:00:14 2026 +0000
Commit:     Leon Romanovsky <leon@kernel.org>
CommitDate: Wed Sep 2 12:27:03 2026 -0400

     RDMA/irdma: Enforce local fence for IB_WR_REG_MR

I also noticed that these two from linux-rdma/for-next
are in conflict:

4a93466061d38f159b857aad63a9cc3cd3affadb RDMA/irdma: Remove unused post_sq arguments
c470050f2a7a7748ce35367e828885a8e658d712 RDMA/irdma: Preserve fast-registration IOVA on 32-bit

What's best way forward here, is this something that
would go via linux-rdma/for-rc or via linux-rdma/for-next?

as we're at rc6 already waiting ~3 weeks before it hits upstream
is fine, I have it in my local test kernels anyway...

Should I resubmit a v2 with the commit message clarified
regarding "RDMA/irdma: Enforce local fence for IB_WR_REG_MR"
and should I base this on top of linux-rdma/for-rc or linux-rdma/for-next?

Thanks!
metze

