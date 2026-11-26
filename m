Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795676982;
	b=YuxoU9PXz0mY//2Wgr0e6Il8q5zo2TzndRygzxQan/HtVRfo5d8vNUwjxsq9s6XsuOfj
	 KrW2sFC7jPv/mTwaZPiAKimCwrjXo43yJQ+73fLJb1f+Jz4HR/J5Cy1z2TYHR8ZRSsefF
	 s3eHS+gIbJr1+NZc+CZjQImIbt+8xj5R1jVSTwm2ENa3RYyvkPxSLge3RCmTtZsZL2MdT
	 E7zqvtQL5DhSardyJwjJE0RxvMiRrWjqIwcmPVSG5NwRGBS0uQmZtBRWZEHlsP5n6bXAJ
	 9EmsU9YAC/PkId1aZeA0sc6qYJmAOaw85RSI98Oj5kWtEK4+jTuKeCaxg+DLmzCpiPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795676982;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=tmsb983Vm/xB8l/jha3v4rfEnILc6zmm3+pOHWxRW0E=;
	b=2aJVAe+rhTwFTCGh1HyXDPpGdsDmeDSKNJ+MK1o5wrNH/4/SVA219SiovTXk83PLUf5F
	 9VnzQxUnkFiLDR2ia/H5CYPw2eGd4ReRylxNjkpS66V+9ESG05S1sgSOgE5K4FiE/er7V
	 qXtrVxxp45XZVz6U66NCMOA+lEaif2NlnffUcHo34Xucadwhykmv31ixGeQqV8HIUfKKr
	 Ny9GHILzrMQG8yyv2q4mxbNKKbYeeGAqRxgNNRdStGeknmKqr1oOG4Ieok+HexGwxA7oT
	 v/ft4YZGIQYxBF51vkm8ieU3CWg/3+hjCukM+TtMdzz0bVzBbHHUxEN5Le4IZVGi1iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cnFaeD4e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9840C606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 07:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cnFaeD4e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DF01F000C0;
	Thu, 26 Nov 2026 07:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795676981;
	bh=tmsb983Vm/xB8l/jha3v4rfEnILc6zmm3+pOHWxRW0E=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=cnFaeD4etO1YCrvkULPvtZdKjBoXrWvuJbp7OEyyZNQXppmExJD4F5dDrpVa0+tbS
	 cTy6RDaNaYDP2hBRRkbM/U6FTP88XouMKKDhhbq9Hq7lfXhjPGTc8B+4q450eeAvhn
	 l5MFfh0vJOFUifDYi1MIrvPx5+eGug9YRfbxN8LhTeYyRFR421dWIWeJnQMJ+w4337
	 JeMFxuk78yLgqATi5mt1F8qmEAf6OQfPLgkzOSxJP7JZer+RpoOPy0nINQ955JsC79
	 nDequXP7MMuQVdO8gz5wI411QxE2m/RyIFbVi5ZvN/RxNxv65WT+PE5FFY6oEezqWY
	 46CozzP5TyyKA==
Message-ID: <sashiko-outbox-234933@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2] RDMA/mlx5: Read the CQ consumer index
 under cq->lock when arming
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mahanta Jambigi" <mjambigi@linux.ibm.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261126065219.1367677-1-mjambigi@linux.ibm.com>
References: <20261126065219.1367677-1-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 07:09:41 +0000
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

commit 8599d5eedfaa0e58f45970b9ef54ea48dbceee76
Author: Mahanta Jambigi <mjambigi@linux.ibm.com>

RDMA/mlx5: Read the CQ consumer index under cq->lock when arming

This commit snapshots cq->mcq.cons_index under cq->lock in
mlx5_ib_arm_cq() before passing it to mlx5_cq_arm().

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
Can releasing cq->lock before calling mlx5_cq_arm() overwrite *cq->mcq.arm_=
db
and MLX5_CQ_DOORBELL with a stale cons_index and arm_sn?

Because cq->mcq.cons_index is an aligned u32, reading it under cq->lock and
dropping the lock before mlx5_cq_arm() does not serialize the doorbell upda=
te
against concurrent polling and re-arming. Moving the read before
spin_unlock_irqrestore() also opens a window on the local CPU when a
completion interrupt arrives while IRQs are disabled under cq->lock:

smc_wr_tx_send()
  mlx5_ib_arm_cq()
    spin_lock_irqsave(&cq->lock, irq_flags)
    cons_index =3D cq->mcq.cons_index;  /* N */
    spin_unlock_irqrestore(&cq->lock, irq_flags)
    <hardirq>
      mlx5_eq_comp_int()
        ++cq->arm_sn;
    <softirq>
      smc_wr_tx_tasklet_fn()
        mlx5_ib_poll_cq()             /* advances cons_index to N + k */
        mlx5_ib_arm_cq()
          mlx5_cq_arm(..., N + k)     /* writes arm_db with N + k */
    mlx5_cq_arm(..., N)               <-- rewinds arm_db and doorbell to N

If the outer caller is delayed between reading cq->arm_sn in mlx5_cq_arm()
and writing *cq->arm_db while an EQE increments cq->arm_sn and the tasklet
polls and re-arms the CQ, the delayed write also overwrites *cq->arm_db with
an already-fired sequence number, which can lose a completion notification
during doorbell recovery.

Should mlx5_cq_arm() be called before spin_unlock_irqrestore(&cq->lock,
irq_flags) so that reading cons_index, updating *cq->mcq.arm_db, and ringing
MLX5_CQ_DOORBELL are serialized by cq->lock?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126065219.1367=
677-1-mjambigi@linux.ibm.com?part=3D1
