Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792836141;
	b=QcRXS2MNaNuEibCXUKHOZrkliP/CG76jxI2BUuLdMyStaFWdFyPYVbN0zJziJmgwwFXP
	 lJQD+Q1aS/4R34CLwufy5RIbC8MtaxyDwAOsxzHlvHrH4/o98L+g14+vDoywZ+hdtCiFR
	 wsqqwkMDSykUiZxRHOzUFya5A4TpG55r/MkyJWlP+SYVl/QpOXOfXvPliNIRE6HId+Hp7
	 4GtNF+cnW4CJaRGCswtVxZpnFGYPW2yLBENoMO85LAbLAskgbSr1LtqQ16b8ovhyik7QI
	 8MhuFGVcq6wEYwdMsAqw4CLWeGASXFMaAh8ONShjVtUGrQeOgfO649+qH29ce3R84qQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792836141;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Gk/pMN+9J+FCPEhk/e4g5ksRun4XfCd/zMQt/uGbni8=;
	b=VHbgl90Q3c1AijzN/eRplgzpEq+1aF6C5yfMFmaoCdeb6mLE/N7fR8P64+dsSWN8oU0H
	 1wyXtPeKyqUQBVNrkiPKNoWLXINgv7DGNaJ1MsfGNBPw226cfYCR7kT5/q0LyCTwX2GvW
	 tQ+BB37mNVS7KKITO5PiW5igvv7mUjnI6lmNLav0VBIeNtt38TJZZhVExuuB/BHyNWzUn
	 OItG/bmjR+ske0wXNRg+UQWoGXQDhdNM6JWxZm4lCuk6FLPuH0VGOAJjr3ZfUhdyBlw6g
	 7g7cUfZTxc61ISceO4a2vo+d7WOPm43rs32IVjTJ4H0sIh1rW7M9P4Ft2sYpxTwkS7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cUEOk1df;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EF9606A31B
	for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 10:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cUEOk1df
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB921F01825;
	Sat, 24 Oct 2026 10:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792836140;
	bh=Gk/pMN+9J+FCPEhk/e4g5ksRun4XfCd/zMQt/uGbni8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cUEOk1dfJulus6lcsU87jHXuv8bGLTetbzwDPXjc+b5y3CH6eVL5ZkJDeSReaWJIt
	 oFlSPMvYR8jEXcdnZPXhumPc+8Yr4WszEgB7eXcBkXbJFksaNijVpSVDWdeC3xVg4d
	 Dz6PCaFQJgPQpy0VFwtUkLtfQ94zPZLgXmgR7abd5ADEK12fOvP1oMyLbI0/7t+NGr
	 h7+p1brxzjc36/ck1I/Dr0aEsuLDEPSpYoRgZhYNQhaXugc+MoQXKRnomXxyqweTjw
	 Ok/0TkFhX94kpRyWNYHWtZGUzM6OQSXV/Al8+Kc3sJ9jKs9xOTh6zsDhF8F4u/Bol5
	 JsIdbL94s2w0Q==
Message-ID: <sashiko-outbox-183639@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] net/rds: hold IB device reference through deferred
 cleanup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eduard Zateev" <hackerowskiy@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261023100206.126692-1-hackerowskiy@gmail.com>
References: <20261023100206.126692-1-hackerowskiy@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 10:02:20 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] net/rds: holding ib_device ref until rds_ib_dev_free() hangs unreg=
ister
--

commit 3160014216e205f18977de718fd96d4297fa02da
Author: Eduard Zateev <hackerowskiy@gmail.com>

net/rds: hold IB device reference through deferred cleanup

This commit holds a registration reference on struct ib_device via
ib_device_try_get() in rds_ib_add_one() and releases it via
ib_device_put() in rds_ib_dev_free() so the underlying IB device is not
freed before deferred cleanup runs on rds_wq.

> diff --git a/net/rds/ib.c b/net/rds/ib.c
> index 4ea9838d090c3..ca6be8b2c3227 100644
> --- a/net/rds/ib.c
> +++ b/net/rds/ib.c
> @@ -115,6 +115,7 @@ static void rds_ib_dev_free(struct work_struct *work)
> =20
>  	kfree(rds_ibdev->vector_load);
> =20
> +	ib_device_put(rds_ibdev->dev);
>  	kfree(rds_ibdev);
>  }
> =20
> @@ -142,6 +143,12 @@ static int rds_ib_add_one(struct ib_device *device)
>  				 ibdev_to_node(device));
>  	if (!rds_ibdev)
>  		return -ENOMEM;
> +	/* Keep the device registered until the deferred cleanup completes. */
> +	if (!ib_device_try_get(device)) {
> +		kfree(rds_ibdev);
> +		return -ENODEV;
> +	}
> +	rds_ibdev->dev =3D device;

[Severity: High]
Can holding this device reference until rds_ib_dev_free() cause
disable_device() to hang indefinitely during IB device unregistration?

During __ib_unregister_device() -> disable_device() in
drivers/infiniband/core/device.c, the core invokes
remove_client_context() -> rds_ib_remove_one() and then blocks waiting
for device->refcount to reach zero:

drivers/infiniband/core/device.c:disable_device() {
	...
	/* Pairs with refcount_set in enable_device */
	ib_device_put(device);
	wait_for_completion(&device->unreg_completion);
	...
}

With this change, the reference taken in rds_ib_add_one() is only
dropped in rds_ib_dev_free(), which is queued by rds_ib_dev_put() when
rds_ibdev->refcount drops to zero. However, there appear to be two paths
where rds_ibdev->refcount is not released during rds_ib_remove_one():

First, in net/rds/ib_rdma.c, rds_ib_get_mr() calls rds_ib_get_device(),
which increments rds_ibdev->refcount. When creating an ODP MR,
rds_ib_get_mr() returns without setting ibmr->device =3D rds_ibdev or
calling rds_ib_dev_put(rds_ibdev):

net/rds/ib_rdma.c:rds_ib_get_mr() {
	...
	rds_ibdev =3D rds_ib_get_device(rs->rs_bound_addr.s6_addr32[3]);
	if (!rds_ibdev) {
		ret =3D -ENODEV;
		goto out;
	}

	if (need_odp =3D=3D ODP_ZEROBASED || need_odp =3D=3D ODP_VIRTUAL) {
		...
		ib_advise_mr(rds_ibdev->pd,
			     IB_UVERBS_ADVISE_MR_ADVICE_PREFETCH_WRITE,
			     IB_UVERBS_ADVISE_MR_FLAG_FLUSH, &sge, 1);
		return ibmr;
	}
	...
}

When the ODP MR is later freed, rds_ib_free_mr() queues
rds_ib_odp_mr_worker() and returns early without calling
rds_ib_dev_put():

net/rds/ib_rdma.c:rds_ib_free_mr() {
	...
	if (ibmr->odp) {
		INIT_DELAYED_WORK(&ibmr->work, rds_ib_odp_mr_worker);
		queue_delayed_work(rds_ib_mr_wq, &ibmr->work, 0);
		return;
	}
	...
}

Because every ODP MR leaks a reference on rds_ibdev->refcount, will
rds_ib_dev_free() ever run if an ODP MR was allocated on the device?

Second, for non-ODP FRMRs mapped via RDS_CMSG_RDMA_MAP (without
RDS_RDMA_USE_ONCE), each MR stored in an open socket's rs->rs_rdma_keys
rbtree holds a reference on rds_ibdev->refcount until rds_ib_free_mr()
is called, and keeps ic->i_fastreg_inuse_count > 0. Because
rds_ib_remove_one() does not revoke socket MRs and removes rds_ibdev
from rds_ib_devices before cp->cp_down_w runs
rds_ib_conn_path_shutdown() -> rds_ib_flush_mrs() on rds_wq,
rds_ib_conn_path_shutdown() stalls waiting for
i_fastreg_inuse_count =3D=3D 0 while rds_ibdev->refcount remains elevated.

Would flushing or waiting on rds_wq in rds_ib_remove_one() after
rds_ib_dev_put(rds_ibdev) (and fixing the rds_ibdev reference handling)
avoid holding an ib_device registration reference across
rds_ib_remove_one()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023100206.1266=
92-1-hackerowskiy@gmail.com?part=3D1
