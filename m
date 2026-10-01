Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC62C35C1AD;
	Thu,  1 Oct 2026 16:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790871317; cv=none; b=EEHo9CujRr1cpL9reAOV1e758xL6nYOFVUAUr3cDB7z+zoYRCYT44O2qfND92uhNMCdayvDlcf/AfJkOSsPd1VzuNZRLQVan6z+F8cooCTbX1hu4P+yEH5+Je+hBtELdRMvZwEsSUI27uquUeSksRUTuEytReSp96aDJhHdFcVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790871317; c=relaxed/simple;
	bh=mTnhXn/BG+VL+9sMkljTJfM+MgvHXH6AeJmDJhv7ts8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=actKl6clvZALkTZjpEawP4oXxHNPX7OQLzikfMLW18G+7LVXuDKFGaPQVlexTBK/IxnGMDGK55nXo34kwr0bSOj46gB5br8Jn9T1cPu9+qM9yBRmhvZo5xu/AY5x/xp6e9yEFmSF/MW3sMcK2IfD/YZuM6Y826PWK7H0JRK+s2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XsqJnQA9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XsqJnQA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E291F00898;
	Thu,  1 Oct 2026 16:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790871315;
	bh=AFLe9cnLKy6oIE5TKzBWYXSGHV80Tx8GhwXTjJOF9Dg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XsqJnQA9PKgwcUsA5v0YJ2WFc9cMGh6ES2svWrOraEJ6TYdkDK/P7mQiXCYHtBAQ2
	 5W7j+Bnf6M4K5uOOq4FFy7Om4wKvWwnlTfn+k1NE02wZCBVc3xO78Kp+7z9EyLXWgh
	 2NatxHtyjIeo5xFQkAYLViTUHWUjAkgpfSD7ylbL3Y1SFUzf92OWwoB85288CxbVpF
	 W496lBBm0nmkwPXrlmjPoC0OszPkGUqeVt9MBXdNaGOjHgPQtkL5aa/e+Es+6wZwJ6
	 EVuOQalaTx4OMVcwn65PomWnY637+6d/FojVM32/sPxHAbP9Xi3Z9kfmEx2b6JMqXJ
	 OD3v0SMpDbRTg==
Date: Thu, 1 Oct 2026 19:15:11 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Youngsung Ahn <ays511.kr@gmail.com>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>, linux-rdma@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] RDMA/rxe: validate inline sge_offset in
 finish_packet() before indexing inline_data[]
Message-ID: <20261001161511.GS3401365@unreal>
References: <20260930182216.2510953-1-ays511.kr@gmail.com>
 <20261001152433.3259573-1-ays511.kr@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001152433.3259573-1-ays511.kr@gmail.com>

On Fri, Oct 02, 2026 at 12:24:33AM +0900, Youngsung Ahn wrote:
> For a user QP, rxe_post_send() takes the qp->is_user branch and
> never runs init_send_wqe(), so
> dma.length/resid/num_sge/cur_sge/sge_offset all come straight from
> the mmap'd SQ ring. In the inline send path finish_packet() uses
> sge_offset directly as an index:
> 
> 	u8 *tmp = &wqe->dma.inline_data[wqe->dma.sge_offset];
> 	memcpy(payload_addr(pkt), tmp, payload);
> 
> inline_data is a flex array whose capacity is qp->sq.max_inline, but
> sge_offset is a u32 from user space, so the source pointer is
> displaced arbitrarily past the WQE and the memcpy reads out of
> bounds.
> commit 126c757e4cd4 ("RDMA/rxe: Validate num_sge/cur_sge before indexing wqe->dma.sge[]")
> added num_sge/cur_sge checks on the send path but not sge_offset, the
> third attacker-controlled index in the same struct.
> 
> Read sge_offset once with READ_ONCE() and bound it (and the payload
> that follows it) by qp->sq.max_inline before indexing, so the value
> that is validated is the value that is used.
> 
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
> Assisted-by: LLM
> ---
> Notes (not part of the commit):
> Reproduced on 7.3-rc4 as uid 1000: "BUG: unable to handle page fault ...
> memcpy+0xc/0x30" from rxe_requester, 4/4. Present unchanged in mainline
> 551c722f4080 (2026-09-29) and rdma for-next. Compile-tested (KASAN+RDMA_RXE),
> not runtime-tested. Found through manual review; per security-bugs.rst this is
> public and a reproducer can be shared on request.
> 
> v2: the WQE lives in the mmap'd ring, so read dma.sge_offset once with
> READ_ONCE() into a local and validate/index that local, closing the TOCTOU
> noted in automated review (v1 re-read the field after the bounds check).
> Dropped security@kernel.org Cc.
> 
>  drivers/infiniband/sw/rxe/rxe_req.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)

Please do not send patches as replies to previous versions. Send them as
standalone messages.

Thanks
