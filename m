Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017275;
	b=1I9vDjQ1j/wq1W/9rV9FUwsO4DhJdOIZtXa7Ino+S5pJ5A3cu8zkEbYIfCTJ51CJ6vqd
	 zCkllJe69LrKng90U/ntZ6vTVGZqWMhdie981DzJiL+9m4d+LKHaWA8tsNNoPD2KaA7RS
	 bX/cHJygSUX++TgzB+1sAUBBOOMgrl1xHBbPwsd7E8o1oavQ93RCXTcjVwHn8NB5gYo7U
	 eVhD+I+5KEmcyAOeXoQUit/XsPNXUJw5snaCwguJjiuZ2cMYkzVNuuFVZ8/aV05McCvD0
	 2f9aUe+FEgfiDtZPfD5VtXwHMQ3bUO0Z02vzsh09arRYMbS2QG/HYERuOGLx85HPLKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017275;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=vaTWN8Tf9sa11IfeTspiVGmRMi7rQpL1Kw+gpZlT3Q4=;
	b=KFfA6N3GvltZL+OvqwH7cviOrQvc/ueqOH8LWIurhxvCLhHgEOpjkDvELeMx9Gz4paW6
	 DLPxdzEduHjMe6BXU45vdwNKSzgWJxavWv21/QrHaHEecrMLSDud2uw/1JtRNF5tmp8AG
	 ryxk0u5DnRhNxRhL9rGE+vQwRNYPpLnxSPtJRRzLXLpfoKn9p2+X0w4QVSYnzhJQQb7Yy
	 2nshWrLrOTRNvYOPprfmtfBwECPW2A6NkA0h82V2nIeYgLTXCsqMXl6Gt0QuMWVuXb9ME
	 tHev6N+R4mr2pHL0q+MVc+wfl+j7afxYXcyHYApXW/s5f+8iZwTMBuGqe0kjDNy/+Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lm9doVQD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9041606A325
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 15:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lm9doVQD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C521F000C5;
	Wed, 18 Nov 2026 15:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795017275;
	bh=vaTWN8Tf9sa11IfeTspiVGmRMi7rQpL1Kw+gpZlT3Q4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lm9doVQDT12aRdG0DwdCc2qCT5xTKh4DE0RV1/5jaMZ1xDjFzdKun3h/W/4c5gTUn
	 oP8EUAaRNe9SbKzm7AgWoK6rKa0IzEEisutc6VEkfEpxvXmYQArR/2lR3UVvckxW08
	 HiVhC7AI+OFoIYAODWTcuAt66Z0WTg/3JPdQBZOJF52bC49vumljbT8FNNQN3DqmVE
	 niImJrTXDQDxDWc3qIvNI1YjqN1EPV6MxBzfSlNZwUtdOe3INXvTVYI03pjcjrJuhO
	 xlAMeYo+3T9rHtfknG51GDk4XsMSczCCRcd0OjTz6tQXKPem/HeyJFK7W1G8ZhRlRw
	 YmQfMhMjkeqcg==
Message-ID: <sashiko-outbox-221386@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [for-next v1 1/2] RDMA/ionic: Accept CQ ring buffers as ioctl
 umem attributes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261118152313.113714-2-abhijit.gangurde@amd.com>
References: <20261118152313.113714-1-abhijit.gangurde@amd.com>
 <20261118152313.113714-2-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 15:54:35 +0000
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
- [High] RDMA/ionic: DMABUF CQ creation fails when req_cq->addr is 0
--

commit d9049031ddccb7cfb004f9f8562a0180d2a52483
Author: Abhijit Gangurde <abhijit.gangurde@amd.com>

RDMA/ionic: Accept CQ ring buffers as ioctl umem attributes

This commit adds optional per-UDMA UVERBS_ATTR_UMEM attributes to
UVERBS_METHOD_CQ_CREATE so userspace can pass CQ ring buffers as VA or
DMABUF descriptors.

> diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/in=
finiband/hw/ionic/ionic_controlpath.c
> index 8a0a1575a339c..11458262f280d 100644
> --- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
> +++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
[ ... ]
> @@ -110,13 +169,9 @@ int ionic_create_cq_common(struct ionic_vcq *vcq,
>  		if (rc)
>  			goto err_qdesc;
> =20
> -		cq->umem =3D ib_umem_get_cq_buf_or_va(&dev->ibdev, NULL,
> -						    req_cq->addr, req_cq->size,
> -						    IB_ACCESS_LOCAL_WRITE);
> -		if (IS_ERR(cq->umem)) {
> -			rc =3D PTR_ERR(cq->umem);
> +		rc =3D ionic_cq_get_user_umem(dev, cq, req_cq, attrs, udma_idx);
> +		if (rc)
>  			goto err_qdesc;
> -		}

[Severity: High]
Does DMABUF CQ creation fail with -EINVAL when userspace passes
req_cq->addr =3D=3D 0?

ionic_create_cq_common() calls ionic_validate_qdesc(req_cq) before
ionic_cq_get_user_umem():

drivers/infiniband/hw/ionic/ionic_controlpath.c:ionic_validate_qdesc() {
	if (!q->addr || !q->size || !q->mask ||
	    !q->depth_log2 || !q->stride_log2)
		return -EINVAL;
    ...
}

For IB_UVERBS_BUFFER_TYPE_DMABUF, the ring buffer is specified by desc.fd
and desc.addr while req_cq->addr is unused and expected to be zero (as in
the follow-up commit "RDMA/ionic: Accept QP SQ and RQ rings as ioctl umem
attributes", which validates only queue geometry for DMABUF descriptors),
so ionic_validate_qdesc() rejects the request before reaching
ionic_cq_get_user_umem().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118152313.1137=
14-1-abhijit.gangurde@amd.com?part=3D1
