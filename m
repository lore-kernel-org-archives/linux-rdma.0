Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984D0318146
	for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 03:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789963049; cv=none; b=r2fSl4xMSaOczHidd5+Zks7JIs8hbGSOUQFlZ5eK1PGYYzIJiWytwIqQ7yNgLGxTN9l22wUJwEN/B8FFWAu/hNGtJ+kuWKSYsQcVLpKz8INKR0xeJmNy2uBr8iMB3nBVk6VDG1YMg5Lx8Pc5j0/pFd3KGMdcgCmkshwOf92MKgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789963049; c=relaxed/simple;
	bh=hy/HlfeVx9ZhQJxyyzzG8Ml9yUBBvC3YkEfYwumceH8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pC0j8ogbPQtcxIJOYrZcHjsy10LEQoUvLzGc55Gf5pSuCgOjAZwBXmkcrH79yH/tjI/WH6+dw7sckuiMzAGaHfZQ4l5i7oRrHmQXjL0ONX1kcExAEKy3LL5+3lqXBgnciEpXH01g7Y7PuEs0KJ1lhwHFEFnj0KokhtCXkGyhv48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VmH0fvB0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VmH0fvB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111E81F000FF;
	Mon, 21 Sep 2026 03:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789963048;
	bh=5wVr+/glWvlAYLkxIyokQ0xpF8FKRjZD2Hvwy21+ASs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VmH0fvB0OMxDX+CUAhQfc5pqOb16tp5KpkKmg0P5IVt0lJUjYtRDnRL+RxKBU9as/
	 +GWqYqexj0BqY+bcEAWkPfJvfQSjBrLUTgSg/NPicdcpRE5RosRY3E1XKBZARmqNHW
	 BpOwMSJ3ARG144oscmgdOAyJJKjEMdf2QH7V5Y8wscCcnEx5Nsvq3KDcqzNNguwV78
	 am0ghnvL7OzZUrP9vJTXeYDV5SgDALYDlGc8DZ1Nj1HWHr3nQLbYEtq6J5zHzO6GDT
	 kRqo4Gf3BBGtjfILVovBUdvrklA07HGmajN3Tn2+toTye1sStu/I833DUcUoj3M6Jr
	 xM1h60zEp23TQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/iser: Unmap Data-Out header DMA on send failure
Reply-To: sashiko-reviews@lists.linux.dev
To: lirongqing <lirongqing@baidu.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260921033949.1803-1-lirongqing@baidu.com>
References: <20260921033949.1803-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 21 Sep 2026 03:57:27 +0000
Message-Id: <20260921035728.111E81F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] iser: NULL pointer dereference in iser_send_data_out error path
--

commit 3d250519caf840438453e72597d8f3c0e0bcd912
Author: Li RongQing <lirongqing@baidu.com>

RDMA/iser: Unmap Data-Out header DMA on send failure

This commit fixes a DMA mapping leak in iser_send_data_out() by unmapping
the header DMA in the error path if the transmit descriptor was mapped.

> diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infin=
iband/ulp/iser/iser_initiator.c
> index 12a2d12fef070..1cdc8f389919f 100644
> --- a/drivers/infiniband/ulp/iser/iser_initiator.c
> +++ b/drivers/infiniband/ulp/iser/iser_initiator.c
> @@ -464,6 +464,10 @@ int iser_send_data_out(struct iscsi_conn *conn, stru=
ct iscsi_task *task,
>  		return 0;
> =20
>  send_data_out_error:
> +	if (tx_desc->mapped)
> +		ib_dma_unmap_single(iser_conn->ib_conn.device->ib_device,

[Severity: High]
Can this result in a NULL pointer dereference if a DEVICE_REMOVAL CM event
occurs concurrently?

If a target sends a malformed R2T that fails the bounds check, execution ju=
mps
to send_data_out_error. If a DEVICE_REMOVAL event occurs simultaneously,
the CM thread handles the removal asynchronously and sets
iser_conn->ib_conn.device =3D NULL.

Since iser_send_data_out() does not hold state_mutex or otherwise
synchronize with DEVICE_REMOVAL, iser_conn->ib_conn.device can be evaluated
as NULL here.=20

The commit message mentions mirroring iscsi_iser_cleanup_task(), which uses=
 a
safety check for this exact race. Does this new error path need a similar
check before dereferencing the device?

> +				    tx_desc->dma_addr, ISER_HEADERS_LEN,
> +				    DMA_TO_DEVICE);
>  	kmem_cache_free(ig.desc_cache, tx_desc);
>  	iser_err("conn %p failed err %d\n", conn, err);
>  	return err;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260921033949.1803=
-1-lirongqing@baidu.com?part=3D1
