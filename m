Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4BB2F28EA;
	Sun,  6 Sep 2026 14:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788703347; cv=none; b=ifyY3j7PjnbuCzmKX0yQuvXdzn3l8aMa8RV+Sekgy6xQBV31Cu7SFP2oitTQZ8Lv3OYopMVEiyi9aF64fQjHWakBRONHdF6/1NzeiQLlP4X23Qr2xyKXBXmC2PUw20fW9pTca6yhuT2hjJ/TBsiuvoMzkw2Iht3IdPN6PGIZdS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788703347; c=relaxed/simple;
	bh=m4X/qxNbi5DcgokuXTbaLgnScflV54NCxGlaOr5BYog=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sDiKPAEEssM1j8fPlThrinWOGMIZVwXt0004kdxVVQKpzKhLE4Qjc2+1NIX04Pf8hDFqmLdQEV0+Ql5nUUlR2iTHbgzDM/Lrl3LQgP7VdgQmr8OpOucOjocBi0hc9Ziwipdss3udX5YrwsjxaEUSSS8C4QnActCHdlnN2FIAaUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GmtJ4cEa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GmtJ4cEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F3E1F00A3A;
	Sun,  6 Sep 2026 14:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788703346;
	bh=S8NZJkDhSbWcg/zqEMAu07Aymn+Ww7scUyc2kjcPZ8I=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=GmtJ4cEaFQky9q89CCrrW3M6THul8DmpcMe1FumeHcq4bxnu/uNJJRh1QBgQZ516s
	 sfuBlxJckHl83CEzvsX6+wa0hERbPYsJnmavRRcJUziWKEKoe9tdNiUrQMTgSRTb63
	 VTJ+fweg8X6eNxh+upzc6AwLXzEbHTIUWRF25qbcfXbhDVLsy36gfMX5x+kYfi2SxU
	 YPMJ3QIJY2+91if9+QdRpc76BK/crgiOw+ZNxeFNwNRIFH9wq0PCCA1V/4fxS1F8kg
	 irIAFVOnUv7n9hZNc+wEUCgdobRAOTgY4fAWgNJg3vik3bQDvLvnv48Uggxp4r0Uky
	 OIFNA/4bppocA==
Subject: Re: [PATCH net-next, v3] net/mlx5: Use dma_wmb() for completion queue
 doorbell updates
From: netdev-bot+sashiko@kernel.org
To: lirongqing@baidu.com
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
 hawk@kernel.org, john.fastabend@gmail.com, sdf@fomichev.me, borisp@nvidia.com,
 richardcochran@gmail.com, cratiu@nvidia.com, dtatulea@nvidia.com,
 cjubran@nvidia.com, kees@kernel.org, agoldberger@nvidia.com, horms@kernel.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Date: Sun, 06 Sep 2026 14:02:24 +0000
Message-ID: <178870334429.219967.11248144823139889707@kernel.org>
In-Reply-To: <20260902023429.1717-1-lirongqing@baidu.com>
References: <20260902023429.1717-1-lirongqing@baidu.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 1 · Low: 0

- [Medium] Commit message justification is factually wrong for at least
  one converted site, and the change's correctness silently depends on…

--

net/mlx5: Use dma_wmb() for completion queue doorbell updates

This converts the wmb() that follows mlx5_cqwq_update_db_record() into
dma_wmb() at six CQ polling sites in the mlx5 driver.  The reasoning given
is that only DMA coherent memory is written around the barrier, so the
lighter DMA barrier is sufficient.  The wmb() in wc.c is intentionally left
alone.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
> index 1f6bde5d76265..1341874ee58a3 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
> @@ -384,7 +384,7 @@ static inline void mlx5_fpga_conn_cqes(struct mlx5_fpga_conn *conn,
>  
>  	mlx5_fpga_dbg(conn->fdev, "Re-arming CQ with cc# %u\n", conn->cq.wq.cc);
>  	/* ensure cq space is freed before enabling more cqes */
> -	wmb();
> +	dma_wmb();
>  	mlx5_fpga_conn_arm_cq(conn);
>  }

[Severity: Medium]
The commit message says:

    Since only DMA coherent memory accesses are involved (no MMIO accesses
    follow), we can safely use dma_wmb() instead of wmb().

Is that accurate for mlx5_fpga_conn_cqes()?  The statement right after the
converted barrier is mlx5_fpga_conn_arm_cq(), which reaches an MMIO write:

drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c:
static void mlx5_fpga_conn_arm_cq(struct mlx5_fpga_conn *conn)
{
	mlx5_cq_arm(&conn->cq.mcq, MLX5_CQ_DB_REQ_NOT,
		    conn->fdev->conn_res.uar->map, conn->cq.wq.cc);
}

include/linux/mlx5/cq.h:mlx5_cq_arm() {
	*cq->arm_db = cpu_to_be32(sn << 28 | cmd | ci);

	/* Make sure that the doorbell record in host memory is
	 * written before ringing the doorbell via PCI MMIO.
	 */
	wmb();
	...
	mlx5_write64(doorbell, uar_page + MLX5_CQ_DOORBELL);
}

and mlx5_write64() uses __raw_writeq()/__raw_writel(), which carry no
implicit barriers.

The same holds indirectly for the other four converted sites,
mlx5e_poll_rx_cq(), mlx5e_poll_tx_cq(), mlx5e_poll_xdpsq_cq() and
mlx5e_ptp_poll_ts_cq(): the NAPI caller in en_txrx.c arms the CQ over MMIO
shortly after the poll returns:

drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h:
static inline void mlx5e_cq_arm(struct mlx5e_cq *cq)
{
	mlx5_cq_arm(&cq->mcq, MLX5_CQ_DB_REQ_NOT, cq->uar->map, cq->wq.cc);
}

dma_wmb() is strictly weaker than wmb() on some architectures (arm64
dmb(oshst) versus dsb(st)), and by itself it does not order the coherent
memory consumer-index store against a later MMIO write.  So is the change
relying on the wmb() inside mlx5_cq_arm() to provide that ordering?

If so, could the changelog state that instead, and could the code comment
be updated from "ensure cq space is freed before enabling more cqes" to
mention that the MMIO ordering comes from mlx5_cq_arm()?  Otherwise a later
change that relaxes the wmb() in mlx5_cq_arm(), or a new arm path without
one, would quietly lose the CQ consumer-index versus arm-doorbell ordering
with nothing in the history pointing at it.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260902023429.1717-1-lirongqing%40baidu.com
