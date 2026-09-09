Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C554921A6
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 09:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788945023; cv=none; b=TiznMRUBikBMbsCT4Qomofm9oN5MnJGv9DNTh7PiWWG1cS8Z7++o+/rgU0R65jkJi+2Uc/ADU7wC8fkpW0AIU3Dm6f14toGIyQfZUSkxhzTx4H2Q/7MLARQrn/Fe/vinxVqOyNeNh2ec4BY3p9iQU+Qp5JN3zfHQekap2ufc2kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788945023; c=relaxed/simple;
	bh=XjoUT99E8/RAK1qrazR/PpR+CVpR4Vp6oF/3JBumWMs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bFFPfO1/fH2jbGzQehIiFeJtRS/G8lDSmmiOmey92J6jMf2NPGYPCOwsWtUkHX9eX91EpjRftyaC3YfZVycNhvB64L/9YyTclCfk/Ojnab5HF4ziV/TI4JyC8ruq6rEjCD3bnfElGutgbb4I9sXtWsBBlAZZlIsUhmUK6qKBVQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JlY2UHTv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JlY2UHTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7CB1F00A3E;
	Wed,  9 Sep 2026 09:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788945022;
	bh=1Uu/wTZlIbfXt8gPHDK2KTy09T3Fz4UtKoW6KCtibMw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JlY2UHTv5JBqqxtU4Z4KN/cYXeNdHGVEpulVKdoX04DlScDVG9cKrVq8hIkXgW8GA
	 N8rzScNQJWjAMjgVI1daQl3QWxlhjEffW3RT7x10yw/eyQZZp+DXMI8ky3Yn3ZQT25
	 SgJB5aMq4nQqRxuxUMTrTj6xmpAEhV0YSkg+eUZ2CtSznF1E8W4QNBnpsqL6jzwacp
	 oEX+JyoRaHb9qWy5j69Jc/gAfwlYoHd8NPW0+E9VpRoqgnPAO/shG7zmk3haIVlWLo
	 ouGsvakbdWwHlGjIYMuoqrJODXO94jwqeTa9iZS394mec78c7eYIZhvFRr2JFNQN+k
	 0RpoGwgEW5CWQ==
From: sashiko-bot@kernel.org
Subject: Re: [for-next v1 2/5] RDMA/ionic: support firmware-assigned CQ IDs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260908090802.152142-3-abhijit.gangurde@amd.com>
References: <20260908090802.152142-1-abhijit.gangurde@amd.com>
 <20260908090802.152142-3-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 09:10:21 +0000
Message-Id: <20260909091021.CD7CB1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] In `ionic_create_cq_cmd()`, the return value of `dma_mapping_e=
rror()` is directly assigned to `rc` and returned on failure. `dma_mapping_=
error()` returns a positive integer (typically 1) on failure, not a standar=
d negative error code (like `-ENOMEM`). This positive return value propagat=
es up to `ionic_create_cq()`, which returns it to the RDMA core. The RDMA c=
ore (e.g., `ib_create_cq`) translates this to an error pointer (`ERR_PTR(1)=
`). Since `IS_ERR()` only checks for negative error values (`[-MAX_ERRNO, -=
1]`), `IS_ERR(ERR_PTR(1))` evaluates to false. The caller incorrectly assum=
es the CQ creation succeeded and dereferences the invalid pointer `0x1`, ca=
using a kernel panic.
- [High] In `ionic_create_cq_cmd()`, `resp_buf` is mapped with `DMA_FROM_DE=
VICE` and the device writes the CQ ID response to it. After the device comp=
letes the command, the CPU directly reads `resp_buf->id` and `resp_buf->udm=
a_idx` BEFORE calling `dma_unmap_single()`. On architectures without hardwa=
re cache coherency (like some ARM or MIPS CPUs), the CPU may read stale zer=
oed cache lines instead of the actual data written by the device. The kerne=
l DMA API mandates that memory mapped with `DMA_FROM_DEVICE` must be unmapp=
ed or explicitly synchronized (e.g., via `dma_sync_single_for_cpu()`) befor=
e the CPU is allowed to read it.
- [High] In `ionic_destroy_cq()`, the function calls `ionic_pre_destroy_cq_=
cmd()` before issuing the hardware destroy command (`ionic_destroy_cq_cmd()=
`). `ionic_pre_destroy_cq_cmd()` removes the CQ from the tracking XArray an=
d drops its `kref` to 0, which triggers `complete(&cq->cq_rel_comp)`. If th=
e subsequent hardware command fails (e.g., due to timeout), the error handl=
ing path skips `ionic_destroy_cq_common()` (which would normally set `cq->v=
cq =3D NULL`) and returns the error to the RDMA core. The RDMA core permits=
 `ib_destroy_cq_user` to fail, leaving the CQ object alive and allowing the=
 user to retry the destruction. Upon retry, `ionic_pre_destroy_cq_cmd()` is=
 invoked again (since `cq->vcq` is not NULL), which calls `kref_put()` on a=
 refcount that is already 0. This triggers a `refcount_t` underflow warning=
 and returns false, bypassing the completion signal. The subsequent `wait_f=
or_completion(&cq->cq_rel_comp)` will sleep forever because the completion =
was consumed in the first attempt, resulting in an unkillable task deadlock.
--

commit 498fccc09f79cccc72f1e999db1c6895d77eb47e
Author: Abhijit Gangurde <abhijit.gangurde@amd.com>

RDMA/ionic: support firmware-assigned CQ IDs

When the LIF advertises qid allocation for CQ, let firmware return
the completion queue ID instead of allocating it in the driver bitmap.
The CQ create/destroy process is split into distinct phases to avoid
a race condition with the CQ XArray during concurrent creates.

> diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/in=
finiband/hw/ionic/ionic_controlpath.c
> --- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
> +++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
[ ... ]
> @@ -1243,13 +1254,55 @@ static int ionic_create_cq_cmd(struct ionic_ibdev=
 *dev,
>  			}
>  		}
>  	};
> +	dma_addr_t resp_buf_dma;
> +	int rc;
> =20
>  	if (dev->lif_cfg.admin_opcodes <=3D IONIC_V1_ADMIN_CREATE_CQ)
>  		return -EBADRQC;
> =20
> +	if (!ionic_fw_has_qid_alloc(dev, IONIC_LIF_RDMA_ALLOC_QID_CQ)) {
> +		ionic_admin_post(dev, &wr);
> +		return ionic_admin_wait(dev, &wr, 0);
> +	}
> +
> +	resp_buf =3D kzalloc_obj(*resp_buf);
> +	if (!resp_buf)
> +		return -ENOMEM;
> +
> +	resp_buf_dma =3D dma_map_single(dev->lif_cfg.hwdev, resp_buf,
> +				      sizeof(*resp_buf),
> +				      DMA_FROM_DEVICE);
> +
> +	rc =3D dma_mapping_error(dev->lif_cfg.hwdev, resp_buf_dma);
> +	if (rc)
> +		goto err_dma;

[Severity: Critical]
Does this code return a positive integer on DMA mapping failure?

dma_mapping_error() returns a positive value (like 1) on failure rather
than a standard negative error code. This positive value will propagate
up to ionic_create_cq() and back to the RDMA core.

Because IS_ERR() only checks for negative error codes, IS_ERR(ERR_PTR(1))
evaluates to false. Could this cause the caller to incorrectly assume
the CQ creation succeeded and dereference the invalid pointer 0x1,
leading to a kernel panic?

> +
> +	wr.wqe.len =3D cpu_to_le16(IONIC_ADMIN_CREATE_CQ_IN_V2_LEN);
> +	wr.wqe.cmd.create_cq.udma_mask =3D udma_mask;
> +	wr.wqe.cmd.create_cq.resp_dma_addr =3D cpu_to_le64(resp_buf_dma);
> +	wr.wqe.cmd.create_cq.resp_buf_len =3D cpu_to_le32(IONIC_ADMIN_CREATE_CQ=
_OUT_V1_LEN);
> =20
>  	ionic_admin_post(dev, &wr);
> +	rc =3D ionic_admin_wait(dev, &wr, 0);
> +	if (rc)
> +		goto err_admin;
> =20
> -	return ionic_admin_wait(dev, &wr, 0);
> +	if (be32_to_cpu(wr.cqe.status_length) < IONIC_ADMIN_CREATE_CQ_OUT_V1_LE=
N) {
> +		rc =3D -EOPNOTSUPP;
> +		goto err_admin;
> +	}
> +
> +	cq->cqid =3D le32_to_cpu(resp_buf->id);
> +	if (out_udma_idx)
> +		*out_udma_idx =3D resp_buf->udma_idx;

[Severity: High]
Are we reading the DMA buffer before unmapping it?

The CPU directly reads resp_buf->id and resp_buf->udma_idx here, but
dma_unmap_single() hasn't been called yet. On architectures without
hardware cache coherency, could the CPU read stale zeroed cache lines
instead of the actual data written by the device?

The DMA API requires memory mapped with DMA_FROM_DEVICE to be unmapped
or explicitly synchronized (e.g., via dma_sync_single_for_cpu()) before
the CPU can safely read it.

> +
> +err_admin:
> +	dma_unmap_single(dev->lif_cfg.hwdev, resp_buf_dma, sizeof(*resp_buf),
> +			 DMA_FROM_DEVICE);
> +err_dma:
> +	kfree(resp_buf);
> +
> +	return rc;
>  }
[ ... ]
> @@ -1364,6 +1424,13 @@ int ionic_destroy_cq(struct ib_cq *ibcq, struct ib=
_udata *udata)
>  		if (!(vcq->udma_mask & BIT(udma_idx)))
>  			continue;
> =20
> +		/*
> +		 * Untrack the CQ before releasing its hardware ID below, so a
> +		 * concurrent create that gets the same ID reused by firmware
> +		 * cannot have its fresh XArray entry erased by this destroy.
> +		 */
> +		ionic_pre_destroy_cq_cmd(dev, &vcq->cq[udma_idx]);
> +
>  		rc_tmp =3D ionic_destroy_cq_cmd(dev, vcq->cq[udma_idx].cqid);
>  		if (rc_tmp) {
>  			if (!rc)
>  				rc =3D rc_tmp;
> =20
>  			continue;
>  		}

[Severity: High]
If ionic_destroy_cq_cmd() fails, does this error path leave the CQ
in an unrecoverable state?

The call to ionic_pre_destroy_cq_cmd() drops the CQ's kref to 0 and
triggers complete(&cq->cq_rel_comp). If the subsequent hardware command
fails, the function returns the error to the RDMA core without clearing
the CQ object state.

The RDMA core permits destruction to be retried. If the user retries:

ionic_destroy_cq()
   ionic_pre_destroy_cq_cmd()
       kref_put(&cq->cq_kref, ionic_cq_complete);

This second attempt will hit a refcount underflow (since it is already 0),
meaning complete() is bypassed. The subsequent wait_for_completion()
would then block forever because the completion was consumed on the
first attempt.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090802.1521=
42-1-abhijit.gangurde@amd.com?part=3D2
