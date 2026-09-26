Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F34A3A382B
	for <linux-rdma@vger.kernel.org>; Sat, 26 Sep 2026 08:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790411344; cv=none; b=YGwiQTZOYATZ1UEMmGlGeDt2xPK9oEjTBopV4w54SyS5k+Cl0Vr2x2W9Ts/hrNbIyWyRyR40CUAa0iTAQYi9cGBgewYFu+Bcg0oFLXJCVcqBQA9HZNnmubJbg7cM2dwGbHKqyx4mfVDkHgLcd/0jHqMyez3I1sG3I3uu6JQ8Pko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790411344; c=relaxed/simple;
	bh=XE6FCMchpKaOvLAHCulCOM9YLtWNGmXcLAxqyI+R23Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uzhPuBS2tDnKZMSwuMbrU9jjxSuMygg1lFFlb+qoxox+g/jmTz9FgX6OtGK06oyakqmHY2wenXz9efkJPZF57RLuLCBvbdmFQ02fPllN0SVGgY5zEKrH3fr5j5eyoEy32IZEBG9yaSJtKRK4Dmae4hq30u+UC7xXlci31sKhfPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PByVzYwL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PByVzYwL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4776C1F00898;
	Sat, 26 Sep 2026 08:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790411342;
	bh=juIanV9M0ChquCSPAJ4zRObeNjausj7LhG9z9R1d7lk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PByVzYwLs44fUlIC+sULE/EFKssf1MMv5GctyNXrz+VXEvZ6qqcjqzbg7I5lm0rC7
	 Z9IZ1szvNwo5a+Ti1JZ4e27hC6kr3oKsaXfg/Qjf5wgqAuOljebxlZtaVDT2WvC8vh
	 LIhPgqi1naR0xtnNzkSzgxoTdLvHGCcwb4dJ5JlhkHdTEddsucGZeOBK71Gx2j5hdq
	 tpjNUOkIVNwSnLFWf/lseFW04Zx3eTMcUVfz8MjvpHCN6lvv+Mku1v4Wfs1PIkNRks
	 hunNzkBAhFORJM2yuyufA/BLY5Wh7oi/NIt/iOvAkHndD6fyxcNJCvHc6SZdrqyblH
	 DuQ0Si1pCDt4g==
From: sashiko-bot@kernel.org
Subject: Re: [for-next v3 4/5] RDMA/ionic: add Shared receive queue (SRQ)
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260925082802.2675902-5-abhijit.gangurde@amd.com>
References: <20260925082802.2675902-1-abhijit.gangurde@amd.com>
 <20260925082802.2675902-5-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 26 Sep 2026 08:29:01 +0000
Message-Id: <20260926082902.4776C1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] RDMA/ionic: race condition in ionic_modify_srq allows cached lim=
it to diverge from HW limit
--

commit 697ed1cd8f63e63fe464892e9bc1d1c9a1b2de14
Author: Amit Kumar <a.k@amd.com>

RDMA/ionic: add Shared receive queue (SRQ) support

This commit adds Shared receive queue (SRQ) support for the ionic RDMA
driver. It implements the device-supported verb APIs for shared receive
queues, which are currently only supported for userspace.

> diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/in=
finiband/hw/ionic/ionic_controlpath.c
> index 3739c1855a4ba..fd15d9549ac04 100644
> --- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
> +++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c

[ ... ]

> +int ionic_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
> +		     enum ib_srq_attr_mask attr_mask, struct ib_udata *udata)
> +{
> +	struct ionic_ibdev *dev =3D to_ionic_ibdev(ibsrq->device);
> +	struct ionic_srq *srq =3D to_ionic_srq(ibsrq);
> +	int rc;
> +
> +	if (attr_mask & IB_SRQ_MAX_WR)
> +		return -EINVAL;
> +
> +	if (attr_mask & IB_SRQ_LIMIT) {
> +		if (attr->srq_limit >=3D IONIC_MAX_SRQ_LIMIT)
> +			return -EINVAL;
> +
> +		rc =3D ionic_modify_srq_cmd(dev, srq->rq.qid, attr->srq_limit);
> +		if (rc)
> +			return rc;
> +
> +		srq->srq_limit =3D attr->srq_limit;

[Severity: Medium]
Does this code allow the cached SRQ limit to diverge from the hardware
limit due to a race condition?

In drivers/infiniband/hw/ionic/ionic_controlpath.c, ionic_modify_srq() is
called to update the SRQ limit. The IB core allows concurrent readers via
uobj_get_obj_read(), meaning multiple userspace threads can invoke this
function on the same SRQ object simultaneously.

Because there is no driver-level locking around the hardware command and
the subsequent state update, these operations can interleave. This can resu=
lt
in the hardware being programmed with one limit while the driver caches a
different limit, causing ibv_query_srq() to return incorrect state to the
user application.

Could a lock be used to protect the SRQ limit modification sequence?

> +	}
> +
> +	return 0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260925082802.2675=
902-1-abhijit.gangurde@amd.com?part=3D4
