Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795596998;
	b=yXkyiJzkK1THkPscHcEVLFF+KUaTfGqCuqu49G9KGcknL1mZWdN4+CBK0ZKyhHlaJ2Oa
	 MSTz4aSWqolkF1DgXYCwD3jP+/SGqIxBVYyYPE4pYopTtHgj4rUIHduWsxGhsElPiBBbd
	 UvMImpoNzQdrk95y3kfyjrnoQnGmJ+gAyiAuCnhLQ3Qso+XHjGffUwiE1pOhUwd3B8aOr
	 0QgsMffFBKuld2GCZq2bCadctkY0x41iSNsGmVy/J/pleO+elIK73GCA4VprXG1gsHb5F
	 x7DN0zbDth1owWNK2XQREHju6K5gkpHxwwDHVzP4c+HwnMn+GIdKrwCKs7MoYzri2Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795596998;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/wSbAcHfcSrmF+UfLLdq5SpQ/D29Y5TUJTg1ch9RQUc=;
	b=ZvW563oR6A6hq4WEPbXxtngaTnS+EH3XjIF625JUdfdXhLSmZKTF4JYKZDDI6wyv7tMU
	 AZTKzpq+eBzMYrbYYcaBwz9MKlH6JXnnMPNK+FzTP41elmJODGNS5SPStstb2ylsoTus0
	 BWbqGmdN0bHWvhAN5HR52Wyr4Fdac4s5KqhIJSF7ZUkggDd7kgnslvpBek3iXn5Pg/pFg
	 z0udXSJw3u2RRIop4iccB84Tnzr95JYQms7W5tgRg1MKl5bqBJ5bxXBdQJILDkjEuLlw0
	 lTshH28ceR0s4bt5U7Dwkw0zuaXVmEZNKnSZwdKryaWiDmwC908zjBbuOLTlsitUv8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OV+gy4AF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA493606A321
	for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 08:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OV+gy4AF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D5B1F000D1;
	Wed, 25 Nov 2026 08:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795596998;
	bh=/wSbAcHfcSrmF+UfLLdq5SpQ/D29Y5TUJTg1ch9RQUc=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=OV+gy4AFmf7K+w4I9PfZ8BAEdMLl5EYQL2uO2d0txoP3wEFPUZU2AKyU4mGyVuDj9
	 fecx7BXuFU1J7l8r7Sk7Aj/ThFX/J/EQptXpB/yfE6bT+Q463ZPHjFZKiOtv45pmDs
	 MGjcbk9e4QR9DoQ+gRxrgJIvJiccuOB3BrfQTAyU67DlnWmUO/CJKxeevneyfXIQ/b
	 HM53nCfm5Kusb8cb24l7r3Qy/Dx0qgUQptYIy8tnHoyiP7WoO8oputESJYCP1s8mXC
	 FT4tJ+WTXMSQGckt4urL7smLw1beh6kONeCVphn1zZFnTE7Ku8fWSAj0cfrFffZg8c
	 22BvqXj6aTCBQ==
Message-ID: <sashiko-outbox-232958@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next] RDMA/mlx5: Read the CQ consumer index under
 cq->lock when arming
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mahanta Jambigi" <mjambigi@linux.ibm.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261125084054.1349677-1-mjambigi@linux.ibm.com>
References: <20261125084054.1349677-1-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 08:56:37 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] RDMA/mlx5: race on arm_db and doorbell in mlx5_ib_arm_cq()
  outside cq->lock
- [Low] RDMA/mlx5: inaccurate Fixes trailer in mlx5_ib_arm_cq() commit
  message
--

commit d56119318ab1d6b70585159d086babf002396fda
Author: Mahanta Jambigi <mjambigi@linux.ibm.com>

> RDMA/mlx5: Read the CQ consumer index under cq->lock when arming
>
> mlx5_ib_arm_cq() reads cq->mcq.cons_index after dropping cq->lock, while
> the poll path advances the index under that lock. A ULP that arms the CQ
> from process context while the completion tasklet polls races on the
> index, as SMC-R does from smc_wr_tx_send():
>
>     BUG: KCSAN: data-race in mlx5_ib_arm_cq [mlx5_ib] / mlx5_poll_one
>     [mlx5_ib]
>
> Read the index under cq->lock, which every writer of it already holds,
> so the doorbell is programmed with a consistent value. A stale index can
> only cause a spurious completion event, never a lost one.
>
> Fixes: ce0f75093282 ("net/mlx5_core: Modify arm CQ in preparation for upc=
oming Ethernet driver")
> Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>

[Severity: Low]
Is ce0f75093282 ("net/mlx5_core: Modify arm CQ in preparation for upcoming
Ethernet driver") the right commit for the Fixes: tag?  That commit only
moved the unlocked read of cons_index from inside mlx5_cq_arm() to its call=
er
at a time when mlx5_ib_arm_cq() did not take cq->lock at all.  The unlocked
read against mlx5_poll_one() dates back to e126ba97dba9 ("mlx5: Add driver
for Mellanox Connect-IB adapters"), and cq->lock in mlx5_ib_arm_cq() was
introduced by 25361e02c448 ("IB/mlx5: Generate completions in software").

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
Can dropping cq->lock before mlx5_cq_arm() still let a delayed caller
overwrite *cq->mcq.arm_db and MLX5_CQ_DOORBELL out of order?

In SMC-R, smc_wr_tx_send() arms roce_cq_send from process context while
smc_wr_tx_tasklet_fn() polls and re-arms the same CQ from softirq context:

CPU0 (smc_wr_tx_send)             CPU1 (smc_wr_tx_tasklet_fn)
mlx5_ib_arm_cq()
  spin_lock_irqsave(&cq->lock)
  cons_index =3D cq->mcq.cons_index (N)
  spin_unlock_irqrestore(&cq->lock)
  mlx5_cq_arm(..., N)
    sn =3D cq->arm_sn & 3
                                  <hardirq>
                                    mlx5_eq_comp_int()
                                      cq->arm_sn++
                                  mlx5_ib_poll_cq()
                                    cons_index =3D N + k
                                  mlx5_ib_arm_cq()
                                    mlx5_cq_arm(..., N + k)
                                      *cq->arm_db =3D (sn + 1) | (N + k)
                                      mlx5_write64(..., (sn + 1) | (N + k))
    *cq->arm_db =3D sn | N  <-- overwrites with stale sn and index
    mlx5_write64(..., sn | N)

Even without an intervening EQE, CPU0 rewinds *cq->mcq.arm_db and the MMIO
doorbell from N + k back to N; if a completion EQE also incremented
cq->arm_sn before CPU1 re-armed, CPU0 overwrites *cq->mcq.arm_db in host DMA
memory with the already-fired sn, which can lose the completion event if the
HCA reads the doorbell record.  Concurrent mlx5_ib_arm_cq() callers also
still have a data race on *cq->mcq.arm_db and unserialized 32-bit doorbell
writes in mlx5_write64() on 32-bit architectures.

Calling mlx5_cq_arm() before spin_unlock_irqrestore(&cq->lock, irq_flags)
would serialize the cons_index snapshot, the *cq->mcq.arm_db update, and the
MMIO doorbell write.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125084054.1349=
677-1-mjambigi@linux.ibm.com?part=3D1
