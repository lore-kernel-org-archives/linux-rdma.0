Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C8B3911DC
	for <linux-rdma@vger.kernel.org>; Thu,  1 Oct 2026 04:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790830487; cv=none; b=Fl5nX/3GDt5pTpy7GeqO/1x4oauxXKxft31FQ9Dmn1/SzOqAOb9Um7+H7BZHXz6LErfAdrX0VH1zu8R1hO/oCdrYN/49SB/ZuSXDIdhebEy3kSNHm+V5coOAcgYrB3rD5kj6ys4W+F4yH1jyuL4e6xRBOu+IfDsCQD9COW/H3GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790830487; c=relaxed/simple;
	bh=t4xjZh3t+JUEVgjlb6x8Ig9HV3C58PgizlRZhmH1yxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ea0eU2H+ma/r9AFKMIucpNmhmySAoaJL944SRFu+MyEjI4YF0A7AqTDg4sDRawQKwGEyB2CFu8a9mAGPpbbFiubJedy8sV9SyepvYiLAm78lzvt2DOxh+1oDQswLSJzU6kPPnNdayEVgkQ7v4EONeFvR57ygqJ9+268PCBstAKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M43JU0o8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M43JU0o8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E267C1F000FF;
	Thu,  1 Oct 2026 04:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790830485;
	bh=/Po0TQFseE4bPUUFXEdEtVd3qkaszorwsMfoKiebgUw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M43JU0o8uRXW/YU8g4e4Tq8AOtmL80HH4QyI6DxCONz0gTFDdZzT2bOvUBKPdU0AT
	 LyHWUZijJKi/iY+wolXiROHDaYo51R9tf6gtxD9h+N5bznk0ibEmUDwF1rbo2UCz/j
	 gDCFQ8oTyf2fmcWCMS0IhhYA/XPgQaKFoWwRH5RI=
Date: Wed, 30 Sep 2026 17:34:55 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: AYS <ays511.kr@gmail.com>
Cc: zyjzyj2000@gmail.com, linux-rdma@vger.kernel.org, security@kernel.org
Subject: Re: [PATCH] RDMA/rxe: validate cur_sge on the receive path before
 indexing dma->sge[]
Message-ID: <2026093031-deferral-excitable-9009@gregkh>
References: <CAPAqSgbjxGEJ5PketUCyUNu8Zcs5yrbSjSD7NVgPpJ3GGQWRsA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPAqSgbjxGEJ5PketUCyUNu8Zcs5yrbSjSD7NVgPpJ3GGQWRsA@mail.gmail.com>

On Thu, Oct 01, 2026 at 12:15:52AM +0900, AYS wrote:
> A user QP's receive queue is an mmap'd ring: the user provider writes the
> WQEs and post_recv does not touch them, so every field of struct
> rxe_recv_wqe is attacker controlled. When the responder takes a WQE it
> validates only dma.num_sge (rxe_get_recv_wqe()/get_srq_wqe()); dma.cur_sge,
> dma.sge_offset and dma.resid are copied into qp->resp.srq_wqe unchecked.
> 
> copy_data() then uses cur_sge as an index immediately --
> struct rxe_sge *sge = &dma->sge[dma->cur_sge];
> -- and dereferences it (sge->length) before the in-loop
> "dma->cur_sge >= dma->num_sge" test, which only runs after the first sge++.
> cur_sge is a u32, so this reads far out of bounds of the RXE_MAX_SGE-entry
> dma->sge[] embedded in the kmalloc-2k struct rxe_qp: an information leak (the
> out-of-bounds sge->length is recoverable through the work-completion status)
> and a DoS. The send queue already got this check in commit 126c757e4cd4; the
> receive path did not.
> 
> Reject an out-of-range cur_sge in copy_data() before the first sge
> dereference. This also covers the send retry path and is harmless to the
> kernel ULP path, which always sets cur_sge = 0.
> 
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>

Does not match the "From:" line :(

No cc: stable?

No Assisted-by: line?

thanks,

greg k-h
