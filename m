Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55923DAAD9;
	Fri, 14 Aug 2026 20:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786738002; cv=none; b=uWmpAa4QvdsAV/qTNAt6TXhtAr15BzyU3o3SEnCg66YPK/CCaLnondb+5jBLdBPK/0hS69WefH6ui3O2Xei0xhOqZcjAf+zQKNXSL48KNrQnMrMl01qg6LUL2awBB/I5G+/jtXwuOg4DN1z8nKfguIzUa4Axgk8rXgf4pkiedoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786738002; c=relaxed/simple;
	bh=QrMfZq87/zy6os+T8ilBckhR9kFFNoW2BE+ctPB8fvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KsIm0KP0DXN5rsKeDAe+/gbBd9wm3AD0vzuoGuARE+30t0Zj3P5a9bd/XsUjYgE1Fc4GpS4vt2NZXwilXdAzBw+VmANYpND4L+z0Eltj3p27Ibgso/Z+QcwypOPJ8CWGFQviANI073V7RRlgNnRaBbO9afwKhWXg47pGZM9Ri00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=afZtTwPu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="afZtTwPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA6F1F000E9;
	Fri, 14 Aug 2026 20:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786738000;
	bh=fSc/pLmpYJqWpXRb2uAnf22OBcer6U7q8y7k9XgXKv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=afZtTwPuIXNtjncCIMWodYQ0n653Vd51kIVE/SoP7cGGl/ePwX+airH3J3dxJVYyU
	 fA/OKR0fV9sNsFuyGjqhhVvQSchEAJzcrybBP+3uhLUJ19sWwf2l7qc+yCoVzIQxQQ
	 /N13wzxNRspNLfMKwYbO7oDAj2Il7CsPp632775AlOxlGySCj4LmYsDMIaZaLQQrVJ
	 933aUlU3pFB3OwBfl8U3YALDzJEgudN2wEnyZ646J+TBSPmIsjJ8fvD1fg7O4QGtBu
	 79nVYClaI8DXOg/P0aDuoswCMNvXyNx21qoRbv6Tlta4YPzbDbfjngSMBjOdPMArMa
	 rnXUmCxGHlVGQ==
From: Jakub Kicinski <kuba@kernel.org>
To: tariqt@nvidia.com
Cc: Jakub Kicinski <kuba@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	agoldberger@nvidia.com,
	ast@kernel.org,
	borisp@nvidia.com,
	bpf@vger.kernel.org,
	cjubran@nvidia.com,
	cratiu@nvidia.com,
	daniel@iogearbox.net,
	dtatulea@nvidia.com,
	gal@nvidia.com,
	Jacob.e.keller@intel.com,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	kees@kernel.org,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	lirongqing@baidu.com,
	mbloch@nvidia.com,
	moshe@nvidia.com,
	richardcochran@gmail.com,
	saeedm@nvidia.com,
	shshitrit@nvidia.com,
	horms@kernel.org,
	sdf@fomichev.me
Subject: Re: [PATCH net-next V2] net/mlx5: Use dma_wmb() for completion queue doorbell updates
Date: Fri, 14 Aug 2026 13:06:38 -0700
Message-ID: <20260814200638.3215194-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811064750.3218024-1-tariqt@nvidia.com>
References: <20260811064750.3218024-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
net/mlx5: Use dma_wmb() for completion queue doorbell updates

This converts the barrier that follows mlx5_cqwq_update_db_record() from
wmb() to dma_wmb() in six CQ polling paths, on the grounds that only DMA
coherent memory is involved.  It also converts the barrier in
mlx5_wc_post_nop() in wc.c.

V1: https://patchwork.kernel.org/project/netdevbpf/patch/20260402055206.2311-1-lirongqing@baidu.com/

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> index fb7110b1b6834..442a8d7d6a58f 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> @@ -2501,7 +2501,7 @@ int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget)
>  	mlx5_cqwq_update_db_record(cqwq);
>  
>  	/* ensure cq space is freed before enabling more cqes */
> -	wmb();
> +	dma_wmb();
>  
>  	return work_done;
>  }

[ ... hunks for en/ptp.c, en/xdp.c, en_tx.c, fpga/conn.c and lib/aso.c
snipped, they follow the same shape as the en_rx.c hunk above ... ]

[Severity: Low]
This isn't a bug, but the same "ensure cq space is freed before enabling
more cqes" pattern in mlx5_wc_poll_cq(), in wc.c, is left as wmb():

drivers/net/ethernet/mellanox/mlx5/core/wc.c:mlx5_wc_poll_cq() {
	...
	mlx5_cqwq_update_db_record(&cq->wq);

	/* ensure cq space is freed before enabling more cqes */
	wmb();

	sq->cc++;
	...
}

Was leaving that one out intentional?  After this patch the same commented
rule has two different implementations inside the one file the patch
modifies.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wc.c b/drivers/net/ethernet/mellanox/mlx5/core/wc.c
> index 7d3d4d739e2cd..1afbdd19f8de2 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/wc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/wc.c
> @@ -314,7 +314,7 @@ static void mlx5_wc_post_nop(struct mlx5_wc_sq *sq, unsigned int *offset,
>  	/* ensure doorbell record is visible to device before ringing the
>  	 * doorbell
>  	 */
> -	wmb();
> +	dma_wmb();
>  
>  	mlx5_iowrite64_copy(sq, mmio_wqe, sizeof(mmio_wqe), *offset);

[Severity: High]
Is this site really covered by the commit message rationale?  The commit
message says:

  "Since only DMA coherent memory accesses are involved (no MMIO accesses
  follow), can safely use dma_wmb() instead of wmb()."

In mlx5_wc_post_nop() an MMIO access does follow immediately.  The barrier
separates the host-memory stores (the NOP WQE and the send doorbell record)
from the BlueFlame store:

	sq->pc++;
	sq->wq.db[MLX5_SND_DBR] = cpu_to_be32(sq->pc);

	/* ensure doorbell record is visible to device before ringing the
	 * doorbell
	 */
	dma_wmb();

	mlx5_iowrite64_copy(sq, mmio_wqe, sizeof(mmio_wqe), *offset);

mlx5_iowrite64_copy() writes into sq->bfreg.map, which is a
write-combining __iomem mapping.  mlx5_core_test_wc() asks for it with
map_wc = true:

	err = mlx5_alloc_bfreg(mdev, &sq->bfreg, true, false);

Does dma_wmb() order the write-back doorbell-record store against that
write-combining MMIO store?  On x86-64, __dma_wmb() is a plain barrier()
while __wmb() is sfence, so this hunk appears to drop the fence that
ordered the two.

Neither branch of mlx5_iowrite64_copy() looks like it restores the
ordering, since both use raw stores: the arm64 path issues a bare NEON
"st1" from inline asm and the fallback uses __iowrite64_copy().

The rest of the driver keeps the two steps distinct, dma_wmb() for
WQE -> doorbell record and wmb() for doorbell record -> MMIO, for example
mlx5e_notify_hw() in en/txrx.h:

	/* ensure wqe is visible to device before updating doorbell record */
	dma_wmb();

	*wq->db = cpu_to_be32(pc);

	/* ensure doorbell record is visible to device before ringing the
	 * doorbell
	 */
	wmb();

	mlx5_write64((__be32 *)ctrl, uar_map);

and mlx5_cq_arm() in include/linux/mlx5/cq.h states the same rule:

	/* Make sure that the doorbell record in host memory is
	 * written before ringing the doorbell via PCI MMIO.
	 */
	wmb();

Can the device then read a stale sq->wq.db[MLX5_SND_DBR] or a stale WQE
after the BlueFlame doorbell arrives?  mlx5_wc_poll_cq() derives
mdev->wc_state from cqe->wqe_counter, so a misordered post would either
time out or mis-classify write-combining support for that device.

Also, the retained comment still says "ensure doorbell record is visible to
device before ringing the doorbell" while the barrier no longer covers the
MMIO side.  Should this hunk be dropped from the patch so wc.c keeps wmb()
here?
-- 
pw-bot: cr
