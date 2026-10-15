Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2723051AFF8;
	Thu, 15 Oct 2026 13:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792072792; cv=none; b=WkZtrYfJEBpZoYHXOxfZkDeQvttBRwDEKUavsKuH9IHAqUxe4Lo34VvTnqeg/1zTyFyCZWTdiktKy/YanNfftkj6wstkPD7QIzkzL+gq9LIuQ6FgKQV2AatjTxQnienBsjadMTy29TvNIhUCYzn1QJtFbUuUUtGhudK408SxCiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792072792; c=relaxed/simple;
	bh=jdDHdSENu/Hy4dJDvkb9s42EjaZj3dNTCeCsYNpTMZQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dSVeX85My7RB0jFVzZRiHob6fzt9vA3obq2dnkv67eshCbd3dMG5J8SIIHHIF8XrKkjFo9QKspS8L1A0f7KQ0RVyGXUQyl0ebrSgqfAg/R2sWxsGsQkwUYGvoSaDqC3/mvuHrgTxookTJpQ7tf3pbDWVH+9bYkWEXF4H7BQt3cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e+MkGLcg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e+MkGLcg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA1E1F000C4;
	Thu, 15 Oct 2026 13:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792072790;
	bh=qaEDfFBlYsj4hfyfp6LfJ3GfDsJGR9TlCPIVJPfUPxM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=e+MkGLcg22ThuEvjMS7ijNcqqgZdOpNOK0y8A13KoE8QlfyufGQC/t5APGcRuRU0q
	 SQipUGJ62MjvlaGSo/JpleAikXV/HlnITGBOYJgVNFnU3u4L5niXImnZp3miha90l+
	 0qCPF7Mai6PZPdC1gCVn5eWfFOp+YAUNXGaU3gx4JB3ncKngUkoGKrxqLqyuOabPL2
	 yI0dCkpMp8f0Jq4+em4PCXwhnyD/6i8w5cGLRziyvro3UPmHtob1fLaPPTK+GDF/9d
	 ka9pFGNWis+Lc6TO0EQYcApNJgBKj95BQdrZGdZtzk2nPpensb0FMtvRmbQhlLTERo
	 n/5ljWRz3ystQ==
From: Leon Romanovsky <leon@kernel.org>
To: Zhu Yanjun <yanjun.zhu@linux.dev>, Youngsung Ahn <ays511.kr@gmail.com>
Cc: linux-rdma@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20261001152433.3259573-1-ays511.kr@gmail.com>
References: <20261001152433.3259573-1-ays511.kr@gmail.com>
Subject: Re: [PATCH v2] RDMA/rxe: validate inline sge_offset in
 finish_packet() before indexing inline_data[]
Message-Id: <179207278807.164616.12185141669213002162.b4-ty@kernel.org>
Date: Thu, 15 Oct 2026 09:59:48 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 02 Oct 2026 00:24:33 +0900, Youngsung Ahn wrote:
> For a user QP, rxe_post_send() takes the qp->is_user branch and
> never runs init_send_wqe(), so
> dma.length/resid/num_sge/cur_sge/sge_offset all come straight from
> the mmap'd SQ ring. In the inline send path finish_packet() uses
> sge_offset directly as an index:
> 
> 	u8 *tmp = &wqe->dma.inline_data[wqe->dma.sge_offset];
> 	memcpy(payload_addr(pkt), tmp, payload);
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: validate inline sge_offset in finish_packet() before indexing inline_data[]
      https://git.kernel.org/rdma/rdma/c/47a9c0338f2e0d

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

