Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FD741D12B
	for <linux-rdma@vger.kernel.org>; Thu,  1 Oct 2026 16:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790870862; cv=none; b=FRN2aFP5/UkHyx/9z941vMrqX5MOjNlUEuL/eFlkGLEPjLaVqQh3SVzYwLTOO1AuDWgiXe2Qw1NV7MX3Dg24+FOq6OAFkq/KppRAL70xbKU5aJ6wLQ81dhrDGwfbRKYhD7ickMg804uJjG2CTrFIcZkMEaI/NPvcFXEjC4vBmTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790870862; c=relaxed/simple;
	bh=ybGrL1htSLQrpvnglBjjWLpWw2G6pSbOTlI2FPctEhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SX0FfadMPWKK3SGbz72pEG8IJhttw1XQMme4eBBaNWKBQinYZzUMs2KQHMQCOXRhWH2+PBR89y8bYlIVRDtNdRvDDo4QFR/Qj7/ZruaiLJYrmOdH/TCcRItXjp3FOs4FsOTqHbG5D2lfEH7JHyYsBXegXRsMwIK+vlmh90eX794=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IDuxUMnh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IDuxUMnh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B641F000FF;
	Thu,  1 Oct 2026 16:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790870860;
	bh=391/IS1Ooc1yWMw5BDs4WlNbukv9Y4uj6C4uG3Nco/A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IDuxUMnhDjB7WjALSxx35zBsHSppT19BpGxE0zLOowlG55DuHlsLCjNWrByv05d/c
	 1lzk0k5Bt932RVLF5ut84S6Ld3alcM4RyEbdCvQ9ItQ3fRKo6Ho2/OH4vUzDzFMyJq
	 vTrOzlVEErTzW/XqH2zBVrWMKQ6WTLLpfA3ow3k1HHA5H32m7BYPlUm5co2JBwgfpt
	 7V6qO5sEN8/8JbfEoPcRcURvTAUAwBLiAoq0muRY+ouzqAh4eTPuwaoe4KC755Xt5W
	 V/F9uvELS01ws8t3GxlcV4veaRy4HyZQUJYQSj0yIe42gsnkOJh3ieWcLIVqvhNd7z
	 CU3fAA6+fxZ3w==
Date: Thu, 1 Oct 2026 19:07:37 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: AYS <ays511.kr@gmail.com>, zyjzyj2000@gmail.com,
	linux-rdma@vger.kernel.org, security@kernel.org
Subject: Re: [PATCH] RDMA/rxe: validate cur_sge on the receive path before
 indexing dma->sge[]
Message-ID: <20261001160737.GR3401365@unreal>
References: <CAPAqSgbjxGEJ5PketUCyUNu8Zcs5yrbSjSD7NVgPpJ3GGQWRsA@mail.gmail.com>
 <2026093031-deferral-excitable-9009@gregkh>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026093031-deferral-excitable-9009@gregkh>

On Wed, Sep 30, 2026 at 05:34:55PM +0200, Greg KH wrote:
> On Thu, Oct 01, 2026 at 12:15:52AM +0900, AYS wrote:
> > A user QP's receive queue is an mmap'd ring: the user provider writes the
> > WQEs and post_recv does not touch them, so every field of struct
> > rxe_recv_wqe is attacker controlled. When the responder takes a WQE it
> > validates only dma.num_sge (rxe_get_recv_wqe()/get_srq_wqe()); dma.cur_sge,
> > dma.sge_offset and dma.resid are copied into qp->resp.srq_wqe unchecked.
> > 
> > copy_data() then uses cur_sge as an index immediately --
> > struct rxe_sge *sge = &dma->sge[dma->cur_sge];
> > -- and dereferences it (sge->length) before the in-loop
> > "dma->cur_sge >= dma->num_sge" test, which only runs after the first sge++.
> > cur_sge is a u32, so this reads far out of bounds of the RXE_MAX_SGE-entry
> > dma->sge[] embedded in the kmalloc-2k struct rxe_qp: an information leak (the
> > out-of-bounds sge->length is recoverable through the work-completion status)
> > and a DoS. The send queue already got this check in commit 126c757e4cd4; the
> > receive path did not.
> > 
> > Reject an out-of-range cur_sge in copy_data() before the first sge
> > dereference. This also covers the send retry path and is harmless to the
> > kernel ULP path, which always sets cur_sge = 0.
> > 
> > Fixes: 8700e3e7c485 ("Soft RoCE driver")
> > Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
> 
> Does not match the "From:" line :(
> 
> No cc: stable?

No need to CC stable@ on RXE patches; I will remove it when applying them anyway.
Nothing urgent here.

Thanks

> 
> No Assisted-by: line?
> 
> thanks,
> 
> greg k-h
> 
