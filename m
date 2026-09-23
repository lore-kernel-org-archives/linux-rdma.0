Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D6D3F410D
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 09:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790157565; cv=none; b=lB9lfaRYLk73Hpx8CVZEM4CKZDwiC8mPtmeBaa7qN/NuiU7TpqyHGpuaHRH1arbFBSBb7cFIjOqQiVcdp0X8G5/qMwJsKHMAddr5Gj+NnyEete4huwOQb+OQWwApWznkfI2bP4bgg8WqUs93cfzj3Ln1dBZDrCYMhVbvQbo17Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790157565; c=relaxed/simple;
	bh=N8ZiBD+OQ1Kz9de3m8Js8FVgtXQjPBcEkgoUNdFx/rU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eDlAtica0TWDKoAeAKM2wgstDp77rij6Tqmuew0KJxI4WSIibYPFQCQYnn5tGS3sZwAWUqAPrgc90dimVuaFPdiQecZmVH+AUaWgPuRKwx1ZRPcjhEolzDlqCFYsDD3Z22hSzmP2oYJ9LrgDH0A3YBVyGQTQn3Rcd6fhqak6hmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JO3QSHi4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JO3QSHi4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF5E1F000FF;
	Wed, 23 Sep 2026 09:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790157563;
	bh=QWVojqYi0begReD+8pgZup85hKQiop/IGJ66CYFOCuA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JO3QSHi4j3e9lVrumL3yr60LSEZ4DREexy/jglwUefqIh8H7KkuspXoLprEoDash1
	 qJukFH/LYhwJ0P2er0PYYkGWkc2oaprBmcZclZy45NGbNEWkywH+qkQeBpLmH+s46c
	 K7b3NAARP8saN9Tdq/NaycUPmA3zP/BuYB7EMDYMWSqBIOQjh6No3vVXg5OukprHh/
	 qxzIOxnTXTBrJOVHYDpXh4a0tSKf3XBLdT5mxxqk9Ir4kyVCHrAxt1tZCdNqQRT7rj
	 54cfdPj4c+6adUgxeyjS/CrOHWTs0ZlKP5LGpiaH9mZd5JOIHaBrp6ER+wCCs5BIPi
	 bfmafhk5i+epQ==
From: sashiko-bot@kernel.org
Subject: Re: [for-next v2 2/5] RDMA/ionic: support firmware-assigned CQ IDs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922095724.3683011-3-abhijit.gangurde@amd.com>
References: <20260922095724.3683011-1-abhijit.gangurde@amd.com>
 <20260922095724.3683011-3-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 09:59:23 +0000
Message-Id: <20260923095923.6EF5E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] RDMA/ionic: raw loop index passed as udma_mask bitmask in CQ creat=
ion
--

commit fe0e581cbc460bad22a8b89a0b2fc1b93d3ab485
Author: Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: RDMA/ionic: support firmware-assigned CQ IDs

When the LIF advertises qid allocation for CQ, this commit updates the driv=
er
to let the firmware return the completion queue ID instead of allocating it
in the driver bitmap. The CQ creation and destruction are split into distin=
ct
phases to safely handle concurrent allocations.

> diff --git a/drivers/infiniband/hw/ionic/ionic_admin.c b/drivers/infiniba=
nd/hw/ionic/ionic_admin.c
> index 37e24450d1298..bd31594b36908 100644
> --- a/drivers/infiniband/hw/ionic/ionic_admin.c
> +++ b/drivers/infiniband/hw/ionic/ionic_admin.c
> @@ -533,12 +576,16 @@ static struct ionic_vcq *ionic_create_rdma_admincq(=
struct ionic_ibdev *dev,
>  	cq =3D &vcq->cq[0];
> =20
>  	rc =3D ionic_create_cq_common(vcq, &buf, &attr, NULL, NULL,
> -				    NULL, NULL, 0);
> +				    NULL, 0);
>  	if (rc)
>  		goto err_init;
> =20
> -	rc =3D ionic_rdma_queue_devcmd(dev, &cq->q, cq->cqid, cq->eqid,
> -				     IONIC_CMD_RDMA_CREATE_CQ);
> +	rc =3D ionic_rdma_cq_devcmd(vcq, &cq->q, &cq->cqid, cq->eqid,
> +				  IONIC_CMD_RDMA_CREATE_CQ, 0);

[Severity: High]
Does ionic_create_rdma_admincq() pass an empty bitmask to the firmware here=
?=20
The udma_mask argument is 0, which evaluates to a bitmask with no bits set.=
=20

Earlier in this function, vcq->udma_mask is initialized to 1. If the firmwa=
re=20
expects a valid UDMA mask, this might fail or allocate unexpectedly.

[ ... ]

> diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/in=
finiband/hw/ionic/ionic_controlpath.c
> index 37f71fb43811e..7a840ece8259d 100644
> --- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
> +++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
> @@ -1222,8 +1230,11 @@ int ionic_dealloc_mw(struct ib_mw *ibmw)
>  static int ionic_create_cq_cmd(struct ionic_ibdev *dev,
>  			       struct ionic_ctx *ctx,
>  			       struct ionic_cq *cq,
> -			       struct ionic_tbl_buf *buf)
> +			       struct ionic_tbl_buf *buf,
> +			       int udma_mask,
> +			       int *out_udma_idx)
>  {

[ ... ]

> @@ -1243,13 +1254,57 @@ static int ionic_create_cq_cmd(struct ionic_ibdev=
 *dev,
> +	wr.wqe.cmd.create_cq.udma_mask =3D udma_mask;

[ ... ]

> @@ -1308,16 +1363,21 @@ int ionic_create_cq(struct ib_cq *ibcq, const str=
uct ib_cq_init_attr *attr,
> =20
>  		rc =3D ionic_create_cq_common(vcq, &buf, attr, ctx, udata,
>  					    &req.cq[udma_idx],
> -					    &resp.cqid[udma_idx],
>  					    udma_idx);
>  		if (rc)
>  			goto err_init;
> =20
> -		rc =3D ionic_create_cq_cmd(dev, ctx, &vcq->cq[udma_idx], &buf);
> +		rc =3D ionic_create_cq_cmd(dev, ctx, &vcq->cq[udma_idx], &buf,
> +					 udma_idx, NULL);

[Severity: High]
Should ionic_create_cq() be passing BIT(udma_idx) or vcq->udma_mask instead
of the raw loop index here?

By passing udma_idx directly as the udma_mask parameter to=20
ionic_create_cq_cmd(), if udma_idx is 0, a mask of 0 is passed. If udma_idx=
=20
is 1, a mask of 1 (which equals BIT(0)) is passed, which could cause the=20
firmware to allocate the CQ on UDMA 0 instead of the intended UDMA 1.=20

This could break DMA and completion tracking if the software CQ context is=
=20
mapped to the wrong hardware UDMA engine.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922095724.3683=
011-1-abhijit.gangurde@amd.com?part=3D2
