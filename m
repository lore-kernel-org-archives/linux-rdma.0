Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792600154;
	b=GvJRu/mzgFN90lWrcQeOrN5wP2c2BsD3Yta/QDGeLEeIOCUg0itqy2/NV79omyEar4Zw
	 lNKpGWQ5x71EPI83yVMDixlYLuhyJ8cfUsenw7qjXWayvoeA2nWtGHKoeRFzci8nCzPqp
	 juoYC8T/1Rc0Wpy6EO1k3uVaOe38Qc3/ahXv93IF6GiDXVtsZcLW9bZBGg//J/JiGlje8
	 mDOpDFXx9lkyTqaNjkXfDMIaM5wAfkdtepza81fIks2i/BKJ6UQnrGPhzwa5K+0TPr8r4
	 KnB28bjeRWGjXINeX7kxUFFZX6nuuUQODlljyN3cmjvU82v/7f5p8g6b4voS73r4hoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792600154;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=pOdyWnp26lTeMn7XpNShbbPVgIhhnwT+JSNvy5412a0=;
	b=uom4B+nbquVVwtfTtOGS6dyAilvyZqAUFaVm737DU/3Gu4T2GYRPE+r3BtgEs2F+MvUZ
	 ypB6MYXFJXt5NhmbG2Oo3s/qk0pk20bMq23/bqISxpSsHyseCzT0/W9unnXYW9lkm0btL
	 1WV1XwqtJd15Le0RjxYxuuDCmVwR61wrbN/QjrsrZR4dAm2JQN+SuFZ9SupgHOuPLEArR
	 HdufSAkNtm/Sq2Kj8Xn+bihw+WIvbBImv5xhH4f8vfxqopxr2GWeCjfBKIDhHrrOjOsJL
	 kILjDkdocjPlxuedX++Ua/DxeQxo9fwGfI5RVJSPwnWTYjjmDJn+WyqPDTQrt2vS4MA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DNjL11G1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED8F606A31A
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 16:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DNjL11G1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2FBB1F000C1;
	Wed, 21 Oct 2026 16:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792600154;
	bh=pOdyWnp26lTeMn7XpNShbbPVgIhhnwT+JSNvy5412a0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DNjL11G1+3RRIPNXfHbk3VXFxUT3WnlYoRJlEeRuUKy3+B+gmPve2Z6ix9foSx+9W
	 EmuDspfzxBzzulpE5E1sLz9Xzv1+eBQPJuEAFFdsG3ZmuZDpIWblfckEHlQOAb0gDN
	 40RpcuKGoPujH68md2M5Wsk2arIoIatAv07ZlGnJClCaqT/Ie2NNaBv1VeSpW2Q6cL
	 7qsmUKBigUIeFffEHTFpaOPyPy9KkwGI9jWDz4KNhrKqlSl2vC6A4KZgOnnfQ1YDaa
	 LUMWqp8HL1eQEGWaC3Wvps0U5p4j5kJhmesTceFTsjb9fP7Vgvcsw/BCSAGAGday+G
	 huE4/tYr6vbjg==
Message-ID: <sashiko-outbox-180464@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-next] RDMA/ionic: Fix GSI QP ID release
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?SMOla29uIEJ1Z2dl?= <haakon.bugge@oracle.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261021161651.4020222-1-haakon.bugge@oracle.com>
References: <20261021161651.4020222-1-haakon.bugge@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 16:29:13 +0000
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
- [High] RDMA/ionic: QPID 1 collision and wrong IDA free in ionic_destroy_q=
p()
--

commit edc58ccd1d5e8131fe43b51993df0ab60279d823
Author: H=C3=A5kon Bugge <haakon.bugge@oracle.com>

RDMA/ionic: Fix GSI QP ID release

This commit changes the error path in ionic_create_qp() and the cleanup path
in ionic_destroy_qp() to release IB_QPT_GSI directly into dev->inuse_qpid
instead of calling ionic_put_qpid() when freeing a GSI QP.

> diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/in=
finiband/hw/ionic/ionic_controlpath.c
> index 18ad967812f50..47904c5b9ce19 100644
> --- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
> +++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
> @@ -2544,7 +2544,11 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_=
qp_init_attr *attr,
>  err_ahid:
>  	kfree(qp->hdr);
>  err_ah_alloc:
> -	ionic_put_qpid(dev, qp->qpid);
> +	if (attr->qp_type =3D=3D IB_QPT_GSI)
> +		ionic_resid_put(&dev->inuse_qpid, IB_QPT_GSI);
> +	else
> +		ionic_put_qpid(dev, qp->qpid);
> +
>  	return rc;
>  }
> =20
> @@ -2858,7 +2862,10 @@ int ionic_destroy_qp(struct ib_qp *ibqp, struct ib=
_udata *udata)
>  		ionic_put_ahid(dev, qp->ahid);
>  		kfree(qp->hdr);
>  	}
> -	ionic_put_qpid(dev, qp->qpid);
> +	if (qp->qpid =3D=3D IB_QPT_GSI)
> +		ionic_resid_put(&dev->inuse_qpid, IB_QPT_GSI);
> +	else
> +		ionic_put_qpid(dev, qp->qpid);
> =20
>  	return 0;
>  }

[Severity: High]
Does releasing raw IB_QPT_GSI (bitid 1) in dev->inuse_qpid and checking
qp->qpid =3D=3D IB_QPT_GSI in ionic_destroy_qp() leave the GSI bitid unrese=
rved
and cause ordinary QPs on udma 1 to collide with QPID 1 when
dev->lif_cfg.udma_qgrp_shift =3D=3D 0?

The IDA allocator dev->inuse_qpid tracks bit indices (bitid), which
ionic_get_qpid() and ionic_put_qpid() convert to and from queue IDs (qpid)
using ionic_bitid_to_qid() and ionic_qid_to_bitid().

In the configuration from the commit message where ionic_put_qpid(dev, 1)
passes id=3D32 to ida_free() (dev->lif_cfg.udma_qgrp_shift =3D=3D 0 and
dev->half_qpid_udma_shift =3D=3D 5), ionic_qid_to_bitid(IB_QPT_GSI, 0, 5) i=
s 32,
and its inverse ionic_bitid_to_qid(32, 0, 5) is 1 (IB_QPT_GSI). Meanwhile,
bitid 1 maps to qpid 2 on udma 0.

In drivers/infiniband/hw/ionic/ionic_controlpath.c, ionic_get_gsi_qpid()
reserves raw bitid 1 instead of the bitid corresponding to IB_QPT_GSI:

	rc =3D ionic_resid_get_shared(&dev->inuse_qpid, IB_QPT_GSI, IB_QPT_GSI + 1=
);
	if (rc < 0)
		return rc;

	*qpid =3D IB_QPT_GSI;

And in ionic_get_qpid(), the reserved QPID check only skips bitids 0 and 1
when base =3D=3D 0 (udma_ix =3D=3D 0):

		size =3D dev->lif_cfg.qp_count / dev->lif_cfg.udma_count;
		base =3D size * udma_ix;
		bound =3D base + size;

		/* skip reserved SMI and GSI qpids in group zero */
		if (!base)
			base =3D 2;

		rc =3D ionic_resid_get_shared(&dev->inuse_qpid, base, bound);
		if (rc >=3D 0) {
			*qpid =3D ionic_bitid_to_qid(rc,
						   dev->lif_cfg.udma_qgrp_shift,
						   dev->half_qpid_udma_shift);

When dev->lif_cfg.udma_qgrp_shift =3D=3D 0 and an ordinary QP is allocated =
on
udma_ix =3D=3D 1 (base =3D=3D 32), bitid 32 is not reserved in dev->inuse_q=
pid, so
ionic_get_qpid() allocates bitid 32 and sets *qpid =3D 1 (IB_QPT_GSI).

If GSI QP creation failed earlier so no GSI QP exists, that ordinary QP is
created with qp->qpid =3D=3D 1 backed by bitid 32. When that ordinary QP is=
 later
destroyed, wouldn't ionic_destroy_qp() see qp->qpid =3D=3D IB_QPT_GSI and c=
all
ionic_resid_put(&dev->inuse_qpid, IB_QPT_GSI), freeing unallocated bitid 1
(triggering the ida_free() warning for id=3D1) and leaking bitid 32?

Also, if the GSI QP is active at QPID 1 when an ordinary QP on udma_ix =3D=
=3D 1
is assigned qp->qpid =3D=3D 1 in ionic_create_qp():

	entry =3D xa_store_irq(&dev->qp_tbl, qp->qpid, qp, GFP_KERNEL);
	if (entry) {
		if (!xa_is_err(entry))
			rc =3D -EINVAL;
		else
			rc =3D xa_err(entry);

		goto err_qp_cmd;
	}

can xa_store_irq() overwrite the active GSI QP in dev->qp_tbl[1] with the n=
ew
qp and jump to err_qp_cmd, destroying QPID 1 in firmware via
ionic_destroy_qp_cmd(dev, 1) and leaving a dangling pointer to the freed
ordinary qp in dev->qp_tbl[1]?

Would it make more sense for ionic_get_gsi_qpid() to reserve
ionic_qid_to_bitid(IB_QPT_GSI, dev->lif_cfg.udma_qgrp_shift,
dev->half_qpid_udma_shift) in dev->inuse_qpid (and for ionic_get_qpid() to
only skip bitid 0 on udma 0 when udma_qgrp_shift =3D=3D 0), so that
ionic_put_qpid(dev, qp->qpid) works uniformly for both GSI and ordinary QPs?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021161651.4020=
222-1-haakon.bugge@oracle.com?part=3D1
