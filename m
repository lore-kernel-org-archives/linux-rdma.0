Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795766999;
	b=LYBgmQlW+NJfdo3+OhygfbJuAY4QiPsJiniunDOh1lDSlYGVAA8rAvpF1DU8rrxGzti/
	 XdvJFCuVIJHHn5qAP7ipq9QH3hoih5Om2fJ55J0f1tL3i9H46KcKyICsBpj7j7+toqzQ3
	 JbSWwt4hiKYjTKcIfEOyywQORG+U+O/daHp3OjpxVL75+TvOk2q31JshXy2uzyT4x12BI
	 1g1sYEUX+SFmMWKJVZVsqetS1MgPRdKpxf4UU68RNufSKUCT02NqjZGQhptJFWqdJhkZZ
	 eM1/fQIn1esT8ADsJnCICoyRq2p4GgUXn56OUDIy0tUYk/SnIZTyVvyXq1/V94fnWTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795766999;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=PtMd5bHyxAX75xvcow0ZIWCdrcbjcSRrlqxxdQU8jqA=;
	b=EiTanZ3GBqaMfkX9Dg8xTklU3c+uMAqslDIAS7Ayr34vJJMmKZRttFGR0hEP4FWv1w55
	 k9eiaiZOzGBERhlXCZy4+M740ru/NElE5oCMLeAX9yPJi7ge0MA4nQeY0r4SGRX2gaYmt
	 rgyHq4HdwTh8qGwXaobAf7MZCoTCD5c+c6PtOUnp5G4xyMV7K5neaSNv1WAEIENf5Xcmc
	 aE7zBr6cMx1q5BkwgcepMnu1IriftCkjH1tf/Rwnl8ffGZQw+Q3pZUx5ZbphPY06JN4YP
	 z1ko+CGp1kqQuUT1c17s1Scf2Fr86PkaTCv7s5u6PfD0DrsSr+vblM/CFi4QT67Ez4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="OFCs/jpL";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792D7606A31C
	for <linux-rdma@vger.kernel.org>; Fri, 27 Nov 2026 08:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OFCs/jpL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D199A1F000C1;
	Fri, 27 Nov 2026 08:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795766998;
	bh=PtMd5bHyxAX75xvcow0ZIWCdrcbjcSRrlqxxdQU8jqA=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=OFCs/jpL5dueKRhmcq1G581yUENO5/d8vKMpQeJN2IURSB/TtVnkx8PblkkgrLTls
	 5HEzSRevJ87NSpg6gt8EL1wHP1PAc7k8g7I12w9yaJe92WisK8HNLBjcIyq+Fx8x5N
	 2FZTX0ACq21AMrk1nHsgo+giELocd5hyWiQI9xS1UCYTGP6H+aiM4XXcMh5D8ecmMK
	 g2v+JliGQvr1WaMrrljIdweAnzffwRUxnucSH2a5beEFUmDZxgMaUMIq6xOynuVGgg
	 d29Oz/4FneVi/wp2M8/agAPZdQykxfYHX2OXNgP3iERKSYaSHd3oDHsduZA8EZIME4
	 RQwcSi7FM04sQ==
Message-ID: <sashiko-outbox-236868@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3] RDMA/mlx5: Read the CQ consumer index
 under cq->lock when arming
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mahanta Jambigi" <mjambigi@linux.ibm.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261127075323.4099367-1-mjambigi@linux.ibm.com>
References: <20261127075323.4099367-1-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 08:09:58 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] RDMA/mlx5: stale cons_index and arm_db race in
  mlx5_ib_arm_cq()
--

commit cd4a8e789a4da161bb086eeea0e1e95d45a10710
Author: Mahanta Jambigi <mjambigi@linux.ibm.com>

RDMA/mlx5: Read the CQ consumer index under cq->lock when arming

This commit snapshots cq->mcq.cons_index under cq->lock in
mlx5_ib_arm_cq() before unlocking and calling mlx5_cq_arm().

> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5=
/cq.c
> index 2581a7693585b..65badcb90d34a 100644
> --- a/drivers/infiniband/hw/mlx5/cq.c
> +++ b/drivers/infiniband/hw/mlx5/cq.c
> @@ -651,6 +651,7 @@ int mlx5_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_not=
ify_flags flags)
>  	struct mlx5_ib_cq *cq =3D to_mcq(ibcq);
>  	void __iomem *uar_page =3D mdev->priv.bfreg.up->map;
>  	unsigned long irq_flags;
> +	u32 cons_index;
>  	int ret =3D 0;
> =20
>  	spin_lock_irqsave(&cq->lock, irq_flags);
> @@ -659,12 +660,16 @@ int mlx5_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_n=
otify_flags flags)
> =20
>  	if ((flags & IB_CQ_REPORT_MISSED_EVENTS) && !list_empty(&cq->wc_list))
>  		ret =3D 1;
> +	/* The poll path advances cons_index under cq->lock; take the
> +	 * snapshot here so the doorbell sees a consistent index.
> +	 */
> +	cons_index =3D cq->mcq.cons_index;
>  	spin_unlock_irqrestore(&cq->lock, irq_flags);
> =20
>  	mlx5_cq_arm(&cq->mcq,
>  		    (flags & IB_CQ_SOLICITED_MASK) =3D=3D IB_CQ_SOLICITED ?
>  		    MLX5_CQ_DB_REQ_NOT_SOL : MLX5_CQ_DB_REQ_NOT,
> -		    uar_page, to_mcq(ibcq)->mcq.cons_index);
> +		    uar_page, cons_index);
> =20
>  	return ret;
>  }

[Severity: Medium]
Can snapshotting cons_index before spin_unlock_irqrestore() cause
mlx5_cq_arm() to overwrite *cq->mcq.arm_db and MLX5_CQ_DOORBELL with a
stale index?

Reading cons_index under cq->lock and dropping the lock before calling
mlx5_cq_arm() does not serialize the doorbell update against concurrent
polls and re-arms, and introduces a local-CPU race across interrupt
re-enablement when called from process context with softirqs enabled
(such as smc_wr_reg_send()):

mlx5_ib_arm_cq()
  spin_lock_irqsave(&cq->lock, irq_flags)
  cons_index =3D cq->mcq.cons_index          /* N */
  spin_unlock_irqrestore(&cq->lock, irq_flags)
    <hardirq>
      mlx5_eq_comp_int()
        ++cq->arm_sn
    <softirq>
      smc_wr_tx_tasklet_fn()
        ib_poll_cq()                       /* cons_index -> N + k */
        ib_req_notify_cq()
          mlx5_cq_arm(..., N + k)
  mlx5_cq_arm(..., N)                      <-- rewinds arm_db to N

Before this change, cons_index was read after spin_unlock_irqrestore()
returned and observed N + k on the local CPU.  Across CPUs, if the first
caller also reads cq->mcq.arm_sn in mlx5_cq_arm() before
mlx5_eq_comp_int() increments it and the tasklet re-arms the CQ at
(sn + 1, N + k), the delayed caller overwrites *cq->mcq.arm_db in DMA
memory with the already-fired sequence number sn and stale index N,
which can cause spurious interrupts or a lost completion notification
during doorbell recovery.

Calling mlx5_cq_arm() while holding cq->lock before
spin_unlock_irqrestore() would keep cons_index, *cq->mcq.arm_db, and the
doorbell write serialized with the poll path.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127075323.4099=
367-1-mjambigi@linux.ibm.com?part=3D1
