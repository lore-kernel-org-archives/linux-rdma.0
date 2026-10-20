Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792484197;
	b=oi822CA7GmWOk/eqyN2/LkBfG63nS9P/vOTNrzhEcpY7u5HpjYVeagFKlB3Ehb6qoxj5
	 C67MkxSE5WXgDe4w5AX3K1Idf/RBQkhPUgUd5AuUI0ni8/Sb4Lx386k87E9VD2nrApDIx
	 EBf7f6TNNizVHTeuRwtEWNcYnrWGO9b+CrZ16Jlcy4kZI/+ZXiQGt+hcoXj9/3m9ax2sB
	 N2acJVE65GzbFvFluq6WnUaSLbmyeSs2f5OIQNEUO5iib+vED040RtL0yKiIGc0R7DXEH
	 U81U+mGczWK3K8biLE2UE3xbkqBB8qVJ1vxPZnc18pbeFhxeuZgyLJbuqTqs6Wwt9IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792484197;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=0GWhIFwLin+5SQmXUO6prYShTkbZNusCKZwKoD53rr0=;
	b=izZLVoszoa2cO5wXhE0OEiSYoUMIIIVSfCx5X/tFrKPVTSSmSCUzkyFkejj+sEB+6Fjc
	 dKcfq4QYhbnYbuEzADrTHLlfLhEdrpZksMl/JBqFrFnO41HpzKSVxA7J2M+PhLXFPMajl
	 5ZbTiAhp+p1svZjR9vyNAbTEoLHtW+7SPioBua2SwWB/gURpWQ086kXoXD1T8gm80e2u9
	 aeNRuD3z9p+2MOcsAal+pvHt5nIefsTM+Yb9Xj9Z7NYVfFf9l3Tur+feTs0JMbgrAwPzZ
	 ovA2OgTjOHLu26uKecIkMoITdwDkq7YceUprD4oTEmYmcJEreZahTCqCs5Hvr2Te5mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nS+jomKn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA24D606A319;
	Tue, 20 Oct 2026 08:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nS+jomKn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D531F000C4;
	Tue, 20 Oct 2026 08:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792484196;
	bh=0GWhIFwLin+5SQmXUO6prYShTkbZNusCKZwKoD53rr0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=nS+jomKn4k9oSLGa5mNanpT25nr3vfIztdOixD9JHoxgNq5AcOUcYyaSLkF0aVsjQ
	 hDGDq9UfGa6kcsb1eXbDHQU6nvqS1F/SC/xIeUFA7v0SxzUJoGT8KpyB25BlFTwxVG
	 FEbS4o721l5sRtTLqlP0WwS8W8siUVWSLB3T+kPuQ8fKLZvvE5Gu1RAiw9yYjzEBhC
	 a+l+CkP08Ykoa6DnPX32+nhAS9ahoZAwlz1knAABrX0mUJDPF7wnB37mkzGBT42395
	 90O/QTMMRhd6V+17LpjMUXvQIHg5nxDJoWBr+52B999KMpNflRJPioeYrKDFQIRwJ9
	 7DGrv4CMzX+3g==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Serhat Kumral <serhatkumral1@gmail.com>
Cc: Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, 
 Yishai Hadas <yishaih@nvidia.com>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261018144907.20123-1-serhatkumral1@gmail.com>
References: <20261018144907.20123-1-serhatkumral1@gmail.com>
Subject: Re: [PATCH] RDMA/mlx5: Validate priority in STEERING_ANCHOR_CREATE
 handler
Message-Id: <179248419348.624760.8984863742736735727.b4-ty@kernel.org>
Date: Tue, 20 Oct 2026 04:16:33 -0400
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sun, 18 Oct 2026 17:49:07 +0300, Serhat Kumral wrote:
> In MLX5_IB_METHOD_STEERING_ANCHOR_CREATE, the user-supplied u16 priority
> is passed directly to _get_flow_table() without an upper bound check.
> This can lead to out-of-bounds array accesses on dev->flow_db priority
> tables.
> 
> Check that priority does not exceed MLX5_IB_FLOW_LAST_PRIO before calling
> _get_flow_table(), matching the existing validation in raw_fs_rule_add()
> and mlx5_ib_create_flow().
> 
> [...]

Applied, thanks!

[1/1] RDMA/mlx5: Validate priority in STEERING_ANCHOR_CREATE handler
      https://git.kernel.org/rdma/rdma/c/bb75e5580b15cd

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

