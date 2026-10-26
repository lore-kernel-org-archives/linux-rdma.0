Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793001396;
	b=u6Bj6961hz0WZrGndPk+lLWprCO+1rTCSNtTz4pLsNlgzKA7UsRTxePdKwt29sec5Wkx
	 4ke7FowXblsJed0FCFOGqLY7MzQWeSnsYVLpPFBSM/ddMLEnVImk+YNNXcenIa88geMPJ
	 s0eakKVk7ZKgpesPz176SLKBjCc95ZIfHeBtqzkzLC4wXDMrYktcl8DJHrclCdQau3tIy
	 SWpgSwTA305FS/XSjYIzJdPxTbXxXARKcJJTWQIWJ9jOsT2YYc3/Z6Fx2gi8zfzzgE1YC
	 vJzlVKiMb8cCK/BEmwPLdRHlkLANDmM3b4t70j7oIY0Brw6HQrWrShMm7ZH0BM7n0eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793001396;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=PLLNAbC16tf/SLz/VX6ZhbHix+lJmPrbLiK0sto1u0k=;
	b=J0j2xXUKwSxH+SpjaDEaj/twiXNXc4T7mybS16rEwvzySJJdJovcKz5WNtckycHmB77/
	 721mxdg6srMIYEJgi71ASABCKDGLJUiGcApZpycCum7+GV8n05fREc0CAEYdEyliVYRxz
	 Ai0zv22o9bXp2ycIcqRhXZ5TqF27chQsrTUQkAYbqD8FUHRs8WrgXvv3ZoBFF+ct8aosv
	 dxFnLw5qOARZ5ZBS7u7+lfMX/KwqiU6it+eb5XTnH30sdbvNhSydJTNHIl8n8clHRqL4o
	 ysC1Gj4C7dCPQmLtQEootrYobc9+Bg/XSr9pNDdHClSV+AcjSRaW3mm6cAVCSyvC37g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CtpywzzI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741A8606A31B
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 07:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CtpywzzI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5C21F01825;
	Mon, 26 Oct 2026 07:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793001396;
	bh=PLLNAbC16tf/SLz/VX6ZhbHix+lJmPrbLiK0sto1u0k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CtpywzzIPNYVwDu8PKnrCp3ovNqCpIom0N0pt8llwEr6X+qPy2zI3QWR5Yhfil7/7
	 qEApxf20xRVoDnUqg69/BIPn2f5f3xD2yTV3GeCSsbIYwJRDVAoE+VmNDEy+UH4jMd
	 0ujmp/ttEao4dYGN0cxHI3zI9l2/FyBQ2lnJixVCLcsaI5g4VUmtrRu2Xp1VEB/CWr
	 oxI6yPjZ+1uNbiZi+QOJHF3WCsZED5TGgMdFHDcazZjKfruItQeBahhxxJpVlzIace
	 e61GzRpp8bTXOozCNrlQ+hayv60cgFTWe1UuZ10kyj+CMJh5jCvIehigIh/7BHRrLC
	 A4ZtFHkspuA+g==
Message-ID: <sashiko-outbox-184667@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 07/26] dma-buf: Add dma_buf_mapping_map() returning a
 type-tagged mapping
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, dri-devel@lists.freedesktop.org
Cc: intel-xe@lists.freedesktop.org, linux-rdma@vger.kernel.org, media-ci@linuxtv.org
In-Reply-To: <20261026053623.202642-8-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-8-apopple@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 07:56:35 +0000
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
- [Medium] dma-buf: do not clear prior attach->selected on error in dma_buf=
_mapping_map()
--

commit 03dc2c734a4965633dec9f21493634bacf3d9de7
Author: Alistair Popple <apopple@nvidia.com>

dma-buf: Add dma_buf_mapping_map() returning a type-tagged mapping

This commit introduces dma_buf_mapping_map() and dma_buf_mapping_unmap() so
importers supporting multiple mapping types can let the exporter select the
mapping type at map time and receive a type-tagged struct dma_buf_mapping. =
It
also wires up the SGT mapping type to these new operations via struct
dma_buf_sgt_mapping and dma_buf_sgt_mapping_table().

> diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-=
mapping.c
> index dbcd83b6dcff7..7a5a379a372e7 100644
> --- a/drivers/dma-buf/dma-buf-mapping.c
> +++ b/drivers/dma-buf/dma-buf-mapping.c
> @@ -366,6 +366,79 @@ int dma_buf_mapping_select(struct dma_buf_attachment=
 *attach)
>  	return 0;
>  }
> =20
> +/**
> + * dma_buf_mapping_map - Map an attachment with whichever type the expor=
ter
> + *                       selects
> + * @attach: the attachment
> + * @dir: DMA direction
> + *
> + * For importers that listed more than one mapping type. The exporter pi=
cks the
> + * type from the possible matches and the result's &dma_buf_mapping.type=
 records
> + * which was used. Must be called with the dma_resv lock held, and the l=
ock must
> + * be held until the result has been acted on. Importers that listed a s=
ingle
> + * type keep using that type's map function.
> + *
> + * Returns: a &struct dma_buf_mapping to pass to dma_buf_mapping_unmap()=
, or
> + * an ERR_PTR.
> + */
> +struct dma_buf_mapping *dma_buf_mapping_map(struct dma_buf_attachment *a=
ttach,
> +					    enum dma_data_direction dir)
> +{
> +	struct dma_buf_mapping *mapping;
> +	int ret;
> +
> +	might_sleep();
> +
> +	if (WARN_ON(!attach || !attach->dmabuf))
> +		return ERR_PTR(-EINVAL);
> +
> +	dma_resv_assert_held(attach->dmabuf->resv);
> +
> +	ret =3D dma_buf_mapping_select(attach);
> +	if (ret)
> +		return ERR_PTR(ret);
> +
> +	if (!attach->map_type.type->map) {
> +		ret =3D -EOPNOTSUPP;
> +		goto err_release;
> +	}
> +
> +	mapping =3D attach->map_type.type->map(attach, dir);
> +	if (IS_ERR(mapping)) {
> +		ret =3D PTR_ERR(mapping);
> +		goto err_release;
> +	}
> +
> +	return mapping;
> +
> +err_release:
> +	/* Nothing was established, so the choice may be made afresh */
> +	attach->selected =3D false;
> +	return ERR_PTR(ret);
> +}

[Severity: Medium]
Can jumping to err_release in dma_buf_mapping_map() corrupt an already
established selection state on attach?

If attach->selected is already true when dma_buf_mapping_map() is entered
(for instance, after dma_buf_pin(), after a prior map/unmap cycle without an
intervening dma_buf_invalidate_mappings(), or while another mapping on the
same attachment is still active), dma_buf_mapping_select() returns 0 without
making a new choice:

drivers/dma-buf/dma-buf-mapping.c:dma_buf_mapping_select() {
	if (attach->selected)
		return 0;
	...
	attach->map_type =3D *match;
	attach->selected =3D true;
	return 0;
}

If the subsequent map operation fails (such as kzalloc_obj() returning NULL
in dma_buf_sgt_type_map(), or sgt_exp_ops->map_dma_buf() failing in
__dma_buf_sgt_map_attachment()), err_release unconditionally sets
attach->selected =3D false.

A later call to dma_buf_mapping_select() can then invoke
dmabuf->ops->select_mapping(attach) again and overwrite attach->map_type
while the buffer is still pinned or has an active mapping. If an earlier SGT
mapping is still active and attach->map_type is changed to a non-SGT type,
unmapping that earlier mapping via:

dma_buf_mapping_unmap()
  -> dma_buf_sgt_type_unmap()
    -> dma_buf_unmap_attachment()

will find dma_buf_get_sgt_ops(attach) =3D=3D NULL, trigger WARN_ON(!sgt_exp=
_ops),
and return early without unmapping or freeing mapping->sgt.

Additionally, when attach->selected was false on entry and
dma_buf_mapping_select() picked a match other than attach->matches[0],
clearing attach->selected on error leaves attach->map_type overwritten rath=
er
than restored to attach->matches[0].

Should dma_buf_mapping_map() remember whether attach->selected was already
true before calling dma_buf_mapping_select(), and only reset attach->select=
ed
(and restore attach->map_type) if this call actually performed the selectio=
n?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026053623.2026=
42-1-apopple@nvidia.com?part=3D7
