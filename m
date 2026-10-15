Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1A852BE5A;
	Thu, 15 Oct 2026 13:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792072795; cv=none; b=HRN+Tgqscgh3/rd6+nuGt1YpJ7wJYfDFPKyV2Nsdi+6omFEWf+MWFTLKx8hHCfy7vXuCbWSaiCf8sX0jgnxrRWTiY+2mVMBlcy3qXFLzF3kfGo0/rkYlnsYcOwurSHhfKXQj/lQXZy1ZDkfSQ+8+aeeCTTB8DZq7Bo2idskQjCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792072795; c=relaxed/simple;
	bh=dVYOwq3QGrBs0Nyv0lXg4YJqiWbVmSkCwqil/73BUC0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=qoE4FMgZNoqreIY4ALSQ1YaRLsvmb/hmvNQvl/wVKP1dMND+ICOMxrJ4Q5pxF84F9dnv3vZC57jMCdC+rzZuKnv33DynQAgzIQXX8ZNNjqC1EZXpzB9d6dwoWKnT2RJ22X0Fi8wJkZ5MsMbzq0v8Cda+NF+91dWIkP4aRQnDXEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ihQM7D5a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ihQM7D5a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714051F000C4;
	Thu, 15 Oct 2026 13:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792072794;
	bh=y+701hbwidrzFqkOcTrJTdHTP9zsp1GVMZZnrz9NDf8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ihQM7D5axpQRjU6r9d8ARgN2mFyhsnsPEwd3RErlCgsVsVvmmzwMIVMT3hiZdIfzD
	 04SUa4arz8fsD6D7UCbYVDjHqmxu5PdF0Y34543G0SMVDRSx8v8kuIWU1iW29VEado
	 Vu/qcO4IyHcQFB4pssZuFPta3Rtz/EIuKfpvNn9oEObSN9oNYxvUT9d9j6UGv77j7s
	 xWqVf0iAZ26xpF+1+LlZbF3YXS0k0MLEQA+T2FswqdtH5SSvrOrGYUxcZaPyjkzkA2
	 8J/R0JZBxBa8jjB8dMCcH9ifLbqYKYsVYm5Z7lv/WinyehKDbJgKytYmvApVqJXFo7
	 J2hJ1N5c+rctw==
From: Leon Romanovsky <leon@kernel.org>
To: zyjzyj2000@gmail.com, jgg@ziepe.ca, Honggang LI <honggangli@163.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261002142250.657151-1-honggangli@163.com>
References: <20261002142250.657151-1-honggangli@163.com>
Subject: Re: [PATCH v3] RDMA/rxe: Fix out-of-range unsigned-to-signed
 conversion for RDMA message in 2GiB size
Message-Id: <179207279123.164616.11787793015499597467.b4-ty@kernel.org>
Date: Thu, 15 Oct 2026 09:59:51 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 02 Oct 2026 22:22:50 +0800, Honggang LI wrote:
> When RDMA READ request for 2GiB in single WR, res->read.resid is u32
> 0x80000000, which is INT_MIN (-2147483648).
> 
>     payload = min_t(int, res->read.resid, mtu);
> 
> The `min_t` function will return -2147483648 for payload. The wrong
> size is propagated through call chain, `read_reply` -> `prepare_ack_packet`
> -> `rxe_init_packet` -> `alloc_skb` . `alloc_skb` failed because of
> invalid size. The passive side failed to emit response packet for RDMA
> READ request.
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: Fix out-of-range unsigned-to-signed conversion for RDMA message in 2GiB size
      https://git.kernel.org/rdma/rdma/c/56a27df6cedd4f

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

