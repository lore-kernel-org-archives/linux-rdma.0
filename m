Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B932FC00D;
	Sun,  6 Sep 2026 07:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788680395; cv=none; b=I4zkN+G/hmmMobYJcr/AUR3RtGkJPj+gszCuDO5iheuChgIda7OOGFT/Tv2dsIYNQD4epig8ER3BfCuawMuZcp6DUYS9uZrTrFgI+YKK5f0RaN5+mmpDQ6/sVsUIMmSwV1Y5sr8S6ZBurCbSqTXawctOKhDjd+enAeUsYZd6rgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788680395; c=relaxed/simple;
	bh=a3Y7EjoE876wryR/ZaCLl4mwJUI+ZlvWkecNSMgFX8I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=f9otDP1uWaZgGl3FGRpoBRUof+jz/IdobuR+Mg+6ZVJHy8n7BEyMz+lKyHCVbezpuNT4UwWsn0B6r6Vh/6csq27C2ocriHJc8elSD1zVVouPf9kNDfOGmhu0SN3wgPtK+pAKDWYSR9cCHHoia2x9BJvGILaeHnbrRsZvVbnAVmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mHgtZr8I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mHgtZr8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F31E1F00A3A;
	Sun,  6 Sep 2026 07:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788680383;
	bh=a1JpmLBRc537fzy1AHiK3MBgXUbNIPuVdUdaIlKpK/U=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=mHgtZr8I5iP2UxrtpegQW/0HSWKnQPYTkQGzDqmfE0V+84E6luJesC3QAmXNCE7dC
	 MXZszrFH9Vir9HydtyVaskwXNcsEFkPk+onZ6ug12rhid32xGj6Mrk3UybE4Ptt4HL
	 TEHtgSP1AZF2Qsi/EiiBRceeUItQgsc9FizmFSbeXFRA3UoGzU7KpSn4IRxDmtW/9X
	 IBlkxttW3BrAEq9e9DhuaxdzjS9lratRFj38SoSlTw8WIcPJWuWU8fVaE5ADnHy+uU
	 y2m5FWeFKfR/ZTW5jN8FEb2S7JunzksKpfgPVSYcYQXruXX1gqoq8UMgaZFwX5fl7s
	 MVGHHo03sC4QA==
From: Leon Romanovsky <leon@kernel.org>
To: kotaranov@microsoft.com, snsanghvi@microsoft.com, longli@microsoft.com, 
 jgg@ziepe.ca, Snehal Sanghvi <snsanghvi@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260902153813.3385076-1-snsanghvi@linux.microsoft.com>
References: <20260902153813.3385076-1-snsanghvi@linux.microsoft.com>
Subject: Re: [PATCH rdma-next] RDMA/mana_ib: advertise pow2 RC SQ support
 to user space
Message-Id: <178868038119.3926550.17226102132911020646.b4-ty@kernel.org>
Date: Sun, 06 Sep 2026 03:39:41 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 02 Sep 2026 08:38:13 -0700, Snehal Sanghvi wrote:
> The send queue of an RC QP normally needs an extra rollback area in
> shared memory. With fixed-size WQEs the rollback can be derived from the
> WQE size alone, so an adapter supporting it can accept a plain
> power-of-two send queue and the rollback area becomes unnecessary.
> 
> Report the adapter capability to user space with a new comp_mask bit in
> the alloc ucontext response, so that user space can request a
> power-of-two RC send queue when the adapter supports it.
> 
> [...]

Applied, thanks!

[1/1] RDMA/mana_ib: advertise pow2 RC SQ support to user space
      https://git.kernel.org/rdma/rdma/c/89b48ad5671fa0

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

