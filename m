Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205BB46F4B3
	for <linux-rdma@vger.kernel.org>; Fri,  2 Oct 2026 09:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790932387; cv=none; b=r4nFcJVkKPXFMuET6KQwifuWcMfjjTTYwVy423WY9zyC846+ccXRqn1hHkoU+mE57WqnYDURlc14CtiMWiR9v68eANyoaOIhPrKKBkZRylQS+E5EJUu0W+htAf3agaVkP+rbQvsHiQ8AMCVitqdhSxDUGWqjQuiP+VFy2EC4lPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790932387; c=relaxed/simple;
	bh=PaJdbVgSf51u6lda/5e3sl4N+Xu/aHiyZ+8NHkEsEaE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=n9ZukTCpN7vrO3fR1w420eNA3IcdrGIzVKq9ioNuOS9X2ym0WYhePlpSThGaCN7LcGwt4yGG89zSNszlmaHP1MOZciW2N6EVUKp1JT2U2lPBcMqmDO7uJzJNgQsSHV/OTKuqsXIu729DP46wuKtIkJCDKEh5cIwqGI+ytJTqpUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XAgNGlZ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XAgNGlZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E511F00893;
	Fri,  2 Oct 2026 09:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790932386;
	bh=RQt37KptM4/slipHfuwzSFl3+KfuKj9UYU6UDfFq0c8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XAgNGlZ1UAxEMT7N9acbGT/O2gHblX+K5BbtD8pwr0/EJVGRmZCBzO/29KvlmWD6r
	 lKOw0RBrAw3O6OE3GMN5pHXUYQ6WrYO9+VUbi9aamG2hGlL+Jfgl82lzR2aOky68zI
	 /sEnoFTo9SLHAMdh0BBJS+pqFNb+47PLZqQ8fmSQFkK1xP5c+auDKVsmJQ2yaM6Z9A
	 olLcE2YnE0x2rBzaUzE0LaNBH9b3pyPfbFOvvamKzHu04RncZLq6q20rV1zWvMSLcE
	 i0mdXV2dpdAWHmBt/2U/f1T5ZRmnsq9HIubIrASU0LhJgzthA+g6hE4xPAD6p0HjJJ
	 7/ga+nRnn3vVA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 09/10] RDMA/mana_ib: Handle error CQEs for RC
 QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261001182015.1757203-10-kotaranov@linux.microsoft.com>
References: <20261001182015.1757203-1-kotaranov@linux.microsoft.com>
 <20261001182015.1757203-10-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 02 Oct 2026 09:13:05 +0000
Message-Id: <20261002091305.D3E511F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] rdma/mana_ib: module unload race due to missing workqueue teardown
--

commit a138de6b28986049d5aed34daaeffc27d848b82d
Author: Konstantin Taranov <kotaranov@microsoft.com>

RDMA/mana_ib: Handle error CQEs for RC QPs

Decode hardware error CQEs and process them on the corresponding work
queue. Complete the failing shadow entry with the vendor status from
the CQE.

Defer transitioning RC QPs to the ERR state so that the other work
queues can be flushed.

> diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana=
/qp.c
> index b3891956f0666..0f60909cbe848 100644
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c

[ ... ]

> @@ -1136,6 +1139,20 @@ int mana_ib_modify_qp(struct ib_qp *ibqp, struct i=
b_qp_attr *attr,
>  	return ret;
>  }
> =20
> +static void mana_ib_qp_error_work(struct work_struct *work)
> +{
> +	struct mana_ib_qp *qp =3D container_of(work, struct mana_ib_qp, error_w=
ork);
> +	struct ib_qp_attr attr =3D { .qp_state =3D IB_QPS_ERR };
> +	int ret;
> +
> +	ret =3D mana_ib_modify_qp(&qp->ibqp, &attr, IB_QP_STATE, NULL);
> +	if (ret)
> +		ibdev_err(qp->ibqp.device, "Failed to move QP %u to ERR: %d\n",
> +			  qp->ibqp.qp_num, ret);
> +
> +	mana_put_qp_ref(qp);
> +}

[Severity: High]
Does this create a race condition with module unload?

If the QP destruction path waits on wait_for_completion(&qp->free) and
proceeds immediately after mana_put_qp_ref() drops the refcount, the
teardown can complete and the module can be unloaded before the worker
thread finishes returning.

If the worker thread is preempted right after signaling the completion in
mana_put_qp_ref(), it could later resume execution and attempt to return
into potentially unmapped module memory, causing a kernel panic.

Should the teardown path explicitly flush or cancel the queued work instead
of relying solely on refcounting for synchronization?

> +
>  static int mana_ib_destroy_qp_rss(struct mana_ib_qp *qp,
>  				  struct ib_rwq_ind_table *ind_tbl,
>  				  struct ib_udata *udata)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001182015.1757=
203-1-kotaranov@linux.microsoft.com?part=3D9
