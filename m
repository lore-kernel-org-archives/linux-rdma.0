Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1AB4963A6
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 09:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788945025; cv=none; b=O7mFWZCYMGAC3lUikirwgGGYZQf2cC4UQYtOkSO/K2f+XTmcB/2TAE9CM8vNa0aoM6jCSnEue+21qMmC1Wr+5t/l4XfDWhmrfQdCwKVgmh4veYGpOm2VqadaNQQ+YL/yFoKffcENg65ShgOpkdEjadSaWurD9fDpDkhhWp1UsSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788945025; c=relaxed/simple;
	bh=NpIIANkkVb83RimGNOL8ctbcwdC3xZE7FvlAPbyiyfA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=r88Te+pY7Tz1E0Xd3/Jl6EROkdNmbTs9hT+txRTflHSrq2hYUltLueZIpZRwt+y9LC4BKsQWC7MDe2BGiDVqHPig/PCb8C4bIXmLDgQ/wtmP6Ws2gwwRjGQUdILQrQAMTCtTNERP9HNl+XoEAux9Z7IC/dkLTJ8P3IFqFpciRFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WtYcwCJR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WtYcwCJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B995A1F00A3F;
	Wed,  9 Sep 2026 09:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788945023;
	bh=PzPMOhJVi7h3yk1U/h6KzOoPHQsGmQHlBwm+F36UBhA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WtYcwCJRhIyHlFlil2oWMz1MKMuHCkMGxjcXOsd3lXGsS5EGjtLvdUSgMHIws2JjC
	 AEFEJz2XATrw3z0d3257fcZcvDl0ilJF2B6660YQYyBXDcjiCMvMN7yse5wvOcWSk8
	 GhCEQ1lrei5ZC+hyhflkvLg+KJxe34/str7cdonrLnUZwhFcQjXeE8h+UM31N7bu/x
	 8qKXaOh6zjfj0lEw+Zzd+CzNdxE11fhnp9Xv1XQoVEZR3GA04F+iIyO/wEImUYTPr5
	 gBSo+VBLYeP1SLWWQWwXCLP2X9ZanVAV5KLQIBLK2dtc789MnbbQKZqo124F78iBaM
	 +iGT+VIWIKkrQ==
From: sashiko-bot@kernel.org
Subject: Re: [for-next v1 5/5] RDMA/ionic: implement SRQ event handling
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260908090802.152142-6-abhijit.gangurde@amd.com>
References: <20260908090802.152142-1-abhijit.gangurde@amd.com>
 <20260908090802.152142-6-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 09:10:23 +0000
Message-Id: <20260909091023.B995A1F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Software SRQ tracking state is irreversibly destroyed before verif=
ying that the fallible hardware SRQ destroy command succeeds, leading to re=
fcount underflow and deadlock on retry.

Pre-existing issues:
- [High] Incorrect flag passed to xa_init_flags() causes a sleep-in-atomic =
bug when inserting items into the XArray.
--

commit 6b80795e1502f8e968be68240853d9d74c4b43a3
Author: Amit Kumar <a.k@amd.com>

RDMA/ionic: implement SRQ event handling support
   =20
This commit introduces SRQ event types and associated events for the ionic
driver. It updates the event processing loop to report these events through
the SRQ event handler.

> diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/in=
finiband/hw/ionic/ionic_controlpath.c
> index 6979e0c5a25c2..de1b8aa1815cc 100644
> --- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
> +++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
[ ... ]
> @@ -3056,6 +3056,13 @@ int ionic_create_srq(struct ib_srq *ibsrq, struct =
ib_srq_init_attr *attr,
>  			goto err_resp;
>  	}
> =20
> +	kref_init(&srq->kref);
> +	init_completion(&srq->rel_comp);
> +
> +	rc =3D xa_insert_irq(&dev->srq_tbl, srq->rq.qid, srq, GFP_KERNEL);

[Severity: High]
This is a pre-existing issue, but won't this xa_insert_irq() call trigger a
sleep-in-atomic bug if the XArray needs to allocate memory?

The xa_insert_irq() function disables interrupts. If a node allocation is
required, xas_nomem() is called which attempts to drop the lock and
re-enable interrupts. However, because dev->srq_tbl is initialized using
GFP_ATOMIC instead of XA_FLAGS_LOCK_IRQ, xas_unlock_type() drops the lock
using spin_unlock() instead of spin_unlock_irq(). This leaves hardware
interrupts disabled while potentially sleeping for a GFP_KERNEL allocation.

> +	if (rc)
> +		goto err_resp;
> +
>  	ionic_pgtbl_unbuf(dev, &buf);
>  	attr->attr.max_wr =3D srq->rq.q.mask;
> =20
[ ... ]
> @@ -3080,6 +3087,11 @@ int ionic_destroy_srq(struct ib_srq *ibsrq, struct=
 ib_udata *udata)
>  	struct ionic_srq *srq =3D to_ionic_srq(ibsrq);
>  	int rc;
> =20
> +	xa_erase_irq(&dev->srq_tbl, srq->rq.qid);
> +
> +	kref_put(&srq->kref, ionic_srq_complete);
> +	wait_for_completion(&srq->rel_comp);
> +

[Severity: High]
Is it safe to irreversibly destroy the software SRQ tracking state before
verifying that the hardware command succeeds?

In ionic_destroy_srq(), the driver erases the SRQ from its tracking table,
drops the kref, and consumes the completion before issuing the hardware
destroy command via ionic_destroy_srq_cmd().

If the hardware command fails (for example, due to a firmware timeout), it
returns an error back to the RDMA core, which leaves the SRQ object intact.
If a user subsequently retries destroying this SRQ, the driver will execute
kref_put() on an already-zero refcount, and call wait_for_completion() on
a completion that has already been consumed and will never be signaled agai=
n.
Will this lead to a refcount underflow and a permanent hang?

>  	rc =3D ionic_destroy_srq_cmd(dev, srq->rq.qid);
>  	if (rc)
>  		return rc;
> diff --git a/drivers/infiniband/hw/ionic/ionic_ibdev.c b/drivers/infiniba=
nd/hw/ionic/ionic_ibdev.c
> index 3187f6297946f..b0206d34b6dcf 100644
> --- a/drivers/infiniband/hw/ionic/ionic_ibdev.c
> +++ b/drivers/infiniband/hw/ionic/ionic_ibdev.c
[ ... ]
> @@ -336,6 +338,7 @@ static struct ionic_ibdev *ionic_create_ibdev(struct =
ionic_aux_dev *ionic_adev)
> =20
>  	xa_init_flags(&dev->qp_tbl, GFP_ATOMIC);
>  	xa_init_flags(&dev->cq_tbl, GFP_ATOMIC);
> +	xa_init_flags(&dev->srq_tbl, GFP_ATOMIC);

[Severity: High]
This is a pre-existing issue, but does GFP_ATOMIC result in the correct
XArray lock type? xa_init_flags() expects XArray flags (like
XA_FLAGS_LOCK_IRQ), not gfp_t memory allocation flags.

When GFP_ATOMIC (which doesn't set the XA_FLAGS_LOCK_IRQ bit) is passed,
the XArray lock type defaults to XA_LOCK_NORMAL. If an IRQ-safe operation
like xa_insert_irq() later requires a memory allocation, xas_nomem() will
drop the lock using spin_unlock() rather than spin_unlock_irq(). This
leaves hardware interrupts disabled while xas_nomem() potentially sleeps for
a GFP_KERNEL allocation, resulting in a sleep-in-atomic bug.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090802.1521=
42-1-abhijit.gangurde@amd.com?part=3D5
