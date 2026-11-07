Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794083094;
	b=CgviVED4g+GislqXn1ccFxSLoVOu6SxEvxxoxj2ou0T2lU0v9pjfRTjNaSm+i9ToRzbJ
	 7gscZv8bnFRuhNg29hXaKe74cQrLCx1WHHwz4RxEya+o0Kw5QsXs5zLiA9qd9Ywy5xZD+
	 TbhN3fGo59GIyHrNJFSbSMG3kV1pZ1T2SbJt9Q5npo87UptZjMX+jdyMALt+tKhrlEGfj
	 pKxingkHX9VEzOmRb7r/djMV2HecynouKah/zoIfX5grM8fqW5ib+lwgusIiDVWvwglKk
	 34sXYFefPVxELEwXEAsrakL2DakQgpvDtGcelP5prJKguHY7yGMHWpODAhJDe96gPJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794083094;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=lgs3KVNbf0o7fwvX/gx91q/+sHVfD9TIfwHmI1J95iU=;
	b=4rZLVx/HWnPIEiZoxZdYfX3Z9nRbBzx7araN7wjeBFMsLrKt3jvtlmzpw01TNWnD+sEA
	 aCchQpSDFNb8ffaH5ZzhouzqbZZWbzDLKLgdXa7YdxnqkjLVngHruZvFRnjNfKGlnXqYj
	 tk0J6r2eGK89AyK8o9hjJd7hnIg9Dwfz5YjyZu1wYSqC1D6ypGJbGGbLB7vwdtyq8McVL
	 L+UXv7IHc/Vyys09w2xkno/jIWVf64B2b74+oqQWIPY7YdwUbJjWJ07KVRcTSkeIRIby7
	 qNWOfczqCRB4P51k8MTcyXA2+OPHlSYZKntonzw9iJM88y7kmQlbZKI+6MV7h7Lg3Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VLXrcmPV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFC8606D81C;
	Sat,  7 Nov 2026 20:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VLXrcmPV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD321F008A6;
	Sat,  7 Nov 2026 20:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794083094;
	bh=lgs3KVNbf0o7fwvX/gx91q/+sHVfD9TIfwHmI1J95iU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=VLXrcmPVo5jyXjyMBpsd8n3ZM/C/P2xlVHUD56k6qDWp3bHbWlgqKnXyUZLRSgN18
	 TeHXFgbTVPVKJpvQzgTLgVLln5ZsDkvga/Kv9rUMaVU4HIQMgh4coQOEfUTDpo9NiW
	 Fy6Z+fvsHFXFzFyWj9V6CpoRVIqJ+ZQm0TGZlyZXh13nQXdRUqwV8nKrPpmQeG3rT2
	 L8Pms2YL63b8Aj+AF92W0J2rk1J9qJzzp/vVdCSr2Cjat7gkpUAsnmmmRq5sXXNBSp
	 67xNzwW5Qtz8DL2svOgYvxBfLYghmXpM7Kc1RZaoXPxqX46yq0Gl1DUoTrGQYKGhYr
	 gnjBY3HdP9lJQ==
Subject: Re: [PATCH rdma-next 11/23] RDMA/mlx5: Add shadow FIFO infrastructure
 for UMR completions
From: netdev-bot+sashiko@kernel.org
To: yishaih@nvidia.com
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
 davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
 moshe@nvidia.com, maorg@nvidia.com
Date: Sat, 07 Nov 2026 20:24:52 +0000
Message-ID: <179408309294.994134.208597027649974206@kernel.org>
In-Reply-To: <20261103163949.1554-12-yishaih@nvidia.com>
References: <20261103163949.1554-12-yishaih@nvidia.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit message's design premise is wrong.

--

RDMA/mlx5: Add shadow FIFO infrastructure for UMR completions

This commit adds a shadow FIFO of posted UMR contexts in adversarial
mode. A later patch can then check each UMR CQE against the oldest
pending request instead of trusting the CQE wqe_counter. Each context
also records the SQ producer counter it was posted at.

> The UMR QP is RC and signals every WR, so its completions arrive in
> posting order.

[Severity: Low]
Is this description accurate? The UMR QP does not look like an RC QP.

mlx5r_umr_resource_init() in drivers/infiniband/hw/mlx5/umr.c creates it
as a REG_UMR QP:

drivers/infiniband/hw/mlx5/umr.c:mlx5r_umr_resource_init() {
    ...
	init_attr.qp_type = MLX5_IB_QPT_REG_UMR;
    ...
}

to_mlx5_st() in drivers/infiniband/hw/mlx5/qp.c maps that type to its
own service type, not MLX5_QP_ST_RC:

	case MLX5_IB_QPT_REG_UMR:	return MLX5_QP_ST_REG_UMR;

mlx5r_umr_qp_rst2rts() also moves the QP to RTS without a remote QPN or
a path, which an RC connection would need.

The shadow FIFO design depends on in-order completion. The consumer added
later in the series, mlx5_ib_poll_one_umr(), treats any CQE whose
wqe_counter differs from the FIFO head as forged.

The in-order conclusion is probably still correct, since mlx5 send queues
complete in order and the generic poll path already relies on that when
it sets wq->tail = wq->wqe_head[idx] + 1. Only the stated reason seems
wrong.

Could the message say that the UMR SQ (a REG_UMR service type QP)
completes in posting order, instead of calling the QP RC?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103163949.1554-1-yishaih%40nvidia.com
