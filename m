Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793068667;
	b=MfsIZ631A2nYi/4XNMV1ao+qqIvqrzV4UNVWb9TgALCJvZxOtIcoF8q4DwnPYgVxsY8F
	 5VjYNjYNYhDgufrHdOJmVP1eStIIo46/bDEg/z/7SYwD6DtVInE6x9ttn0LpF+OanIg2y
	 2SzULKaS1xQoSYX98qajC6smK0ZtNsFjwcHUOT0BNxZH9Rx87BJ1QyAUSr3g/anRHumko
	 30nGLIpmBZI52uCbKf3c89fgqpKoKvlEKHtQN6WpZtUHiQmW+mZ+cmp8bmIrRtpwjdu2e
	 qIpnXOBc22U95+vBQnFIE+/H2sQTfOw1qMYGx4+cY4jPkOu4pg0bOmykCBArr22emSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793068667;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+uAm1UoH8DMVxlFNhW9jHqNt4WYK9nH9gegzJjfjEaI=;
	b=IHDPpiy9tGnczGJ+aS6Eui1O16pLEF1yUCodP5s9nqVDlc7lO1XhDIDenAigfhsaBo1e
	 kmvHEosTZ6JM6MiPNdhMMitFqYiNtqnSuJHse+vFgfB+aWFaa8l4rdrOTuXvFw0/UfREj
	 +qiDAOXlZs2SAMQDoGeogGGPndhHLH0H8wo2eklSxRgxrhvku1sdwQlXXLuJah/I/aQ95
	 riOM4ZvL1ZOWQ0ZaMHIjv4p77L6cLnIupI95w0kNXwEakzxvtsjh+pydGe/TomXfvBTxG
	 VsEleo5AJyZAwy4F1K+a2L1e0aB4bvT0w6zQTqLgUr/lxrwCws/8w1z4Ez6na8V0uhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gNzpVyWp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A82606A31A
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 02:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gNzpVyWp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3451F01825;
	Tue, 27 Oct 2026 02:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793068667;
	bh=+uAm1UoH8DMVxlFNhW9jHqNt4WYK9nH9gegzJjfjEaI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gNzpVyWpb/gGn45Tr/wRUSP4+wvCC5D4pTZGiZ3lwErRFwzx4cXvYDesXETP5HYuN
	 zk1SiPaWKFOD3xzojfZTDm2nnk7+E00zb+CDWFsr5ClJ5s7Y6uZZKcR2BLfdQsz5Sl
	 27UepWjtkrBA+ozbtRcJeFmjzxtSGsli4NNBbTEgvah0mDlaI2rB6H7qi6plou78+j
	 NSKA7yx30L1BHqbhime6L0z8TMGYl9rv8/yGLW2MUkmSjJT1AY32fa4FYohWBNLGDD
	 ufumAVZ744rA1aSIIpcfB1zksGd0JQs4UY5Jg5e87nwkIs0yVWHi/AfKGfCLpGGaU9
	 GBlExwCLLUVfA==
Message-ID: <sashiko-outbox-186026@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma v7 5/7] RDMA/zrdma: Add device probe and remove
 logic
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yanze Zhang" <zhang.yanze@zte.com.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261027021119.2325798-6-zhang.yanze@zte.com.cn>
References: <20261027021119.2325798-1-zhang.yanze@zte.com.cn>
 <20261027021119.2325798-6-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 02:37:46 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] RDMA/zrdma: uninitialized ceqs_count and hw.device in zxdh_probe()
- [High] RDMA/zrdma: un-cleared pointer in zxdh_initialize_hw_rsrc() causes=
 double free
- [Low] RDMA/zrdma: unpopulated zxdh_rdma_list and unused zxdh_handlers list
--

commit 63daa22995c515a9faef7a5a084166c75b7006ce
Author: Yanze Zhang <zhang.yanze@zte.com.cn>

RDMA/zrdma: Add device probe and remove logic

This commit implements the auxiliary bus probe and remove functions for the
zrdma driver, including device initialization, hardware resource setup,
handler list management, and IB device registration and deallocation.

> diff --git a/drivers/infiniband/hw/zrdma/zrdma_main.c b/drivers/infiniban=
d/hw/zrdma/zrdma_main.c
> index af1d37be63362..14c36531cc453 100644
> --- a/drivers/infiniband/hw/zrdma/zrdma_main.c
> +++ b/drivers/infiniband/hw/zrdma/zrdma_main.c

[ ... ]

> +LIST_HEAD(zxdh_handlers);
> +DEFINE_SPINLOCK(zxdh_handler_lock);
> =20
> -MODULE_DEVICE_TABLE(auxiliary, zxdh_auxiliary_id_table);
> +static struct mutex rdma_name_lock;
> +static struct list_head zxdh_rdma_list;
> +
> +static void zxdh_add_handler(struct zxdh_handler *hdl)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&zxdh_handler_lock, flags);
> +	list_add(&hdl->list, &zxdh_handlers);
> +	spin_unlock_irqrestore(&zxdh_handler_lock, flags);
> +}
> +
> +void zxdh_del_handler(struct zxdh_handler *hdl)
> +{
> +	unsigned long flags;
> +
> +	if (!hdl)
> +		return;
> +
> +	spin_lock_irqsave(&zxdh_handler_lock, flags);
> +	list_del(&hdl->list);
> +	spin_unlock_irqrestore(&zxdh_handler_lock, flags);
> +}
> +
> +int zxdh_get_del_rdma_name(const char *sbdf, char *name, size_t name_len)
> +{
> +	struct zxdh_rdma_node *pos, *tmp;
> +	size_t len, sbdf_len;
> +
> +	if (!sbdf || !name || !name_len)
> +		return -EINVAL;
> +
> +	if (name_len > IB_DEVICE_NAME_MAX) {
> +		pr_err("zrdma: name buffer too large\n");
> +		return -EINVAL;
> +	}
> +
> +	sbdf_len =3D strlen(sbdf);
> +
> +	mutex_lock(&rdma_name_lock);
> +	list_for_each_entry_safe(pos, tmp, &zxdh_rdma_list, list) {
> +		len =3D strlen(pos->sbdf);
> +		if (sbdf_len =3D=3D len &&
> +		    strncasecmp(sbdf, pos->sbdf, len) =3D=3D 0) {
> +			snprintf(name, name_len, "%s", pos->name);
> +			list_del(&pos->list);
> +			kfree(pos);
> +			mutex_unlock(&rdma_name_lock);
> +			return 0;
> +		}
> +	}
> +	mutex_unlock(&rdma_name_lock);
> +	return -ENOENT;
> +}

[Severity: Low]
Are zxdh_rdma_list and zxdh_handlers used anywhere in the driver?

zxdh_rdma_list is static to zrdma_main.c and initialized in
zrdma_module_init(), but nothing in the driver or patch series ever inserts
a struct zxdh_rdma_node into it. As a result, zxdh_get_del_rdma_name() can
only return -EINVAL or -ENOENT, and the list traversal here and in
zrdma_module_exit() cannot match any entry.

In addition, zxdh_get_del_rdma_name() rejects caller buffers when
name_len > IB_DEVICE_NAME_MAX, and zrdma_module_init() initializes
rdma_name_lock dynamically without calling mutex_destroy(&rdma_name_lock) if
auxiliary_driver_register() fails.

Similarly, zxdh_probe() allocates struct zxdh_handler and adds it to
zxdh_handlers via zxdh_add_handler(), and zxdh_remove() removes and frees
it, but nothing in the series ever reads or iterates zxdh_handlers.

Could these unused lists and helpers be dropped until they have users?

[ ... ]

> +static void zxdh_fill_device_info(struct zxdh_device *zdev,
> +				  struct zxdh_rdma_core_dev *zdev_info)
> +{
> +	struct zxdh_pci_f *rf =3D zdev->rf;
> +
> +	rf->ftype =3D ZXDH_FUNC_TYPE(zdev_info->vport_id);
> +	rf->pf_id =3D ZXDH_PF_ID(zdev_info->vport_id);
> +	rf->sc_dev.ep_id =3D ZXDH_EP_ID(zdev_info->vport_id);
> +	rf->ep_id =3D rf->sc_dev.ep_id;
> +	rf->sc_dev.driver_load =3D true;
> +
> +	rf->zdev_info =3D zdev_info;
> +	rf->pcidev =3D zdev_info->pdev;
> +
> +	rf->msix_count =3D zdev_info->msix_count;
> +	rf->msix_entries =3D zdev_info->msix_entries;
> +	if (rf->msix_count)
> +		rf->sc_dev.max_ceqs =3D (rf->msix_count - 1);
> +	else
> +		rf->sc_dev.max_ceqs =3D 0;

[ ... ]

> +static int zxdh_probe(struct auxiliary_device *aux_dev,
> +		      const struct auxiliary_device_id *id)
> +{

[ ... ]

> +	rf =3D zdev->rf;
> +	err =3D zxdh_ctrl_init_hw(rf);
> +	if (err)
> +		goto err_dealloc;
> +
> +	err =3D zxdh_ib_register_device(zdev);
> +	if (err)
> +		goto err_dealloc;

[Severity: High]
Where is zdev->rf->ceqs_count initialized before zxdh_ib_register_device() =
is
called?

In zxdh_probe(), zdev->rf is allocated with kzalloc_obj(*zdev->rf), and
zxdh_fill_device_info() sets rf->msix_count and rf->sc_dev.max_ceqs, but
neither zxdh_fill_device_info() nor zxdh_ctrl_init_hw() sets rf->ceqs_count.

When zxdh_probe() calls zxdh_ib_register_device(zdev),
zxdh_init_rdma_device() sets:

drivers/infiniband/hw/zrdma/zrdma_verbs.c:zxdh_init_rdma_device() {
	zdev->ibdev.phys_port_cnt =3D 1;
	zdev->ibdev.num_comp_vectors =3D zdev->rf->ceqs_count;
	zdev->ibdev.dev.parent =3D &zdev->rf->pcidev->dev;

	return 0;
}

With zdev->rf->ceqs_count left at 0 (even at the end of the patch series),
ibdev.num_comp_vectors is registered as 0, which causes uverbs CQ creation =
to
reject all completion vectors with -EINVAL and causes ib_cq_pool_get() to
divide by zero (% dev->num_comp_vectors).

Additionally, at this point in the series (prior to commit "RDMA/zrdma:
Implement device and port query operations"), zdev->rf->hw.device is still
NULL and mandatory ib_device_ops callbacks (get_port_immutable and
query_device) are not yet installed when zxdh_ib_register_device() passes
zdev->rf->hw.device to ib_register_device().

> diff --git a/drivers/infiniband/hw/zrdma/zrdma_verbs.c b/drivers/infiniba=
nd/hw/zrdma/zrdma_verbs.c
> index 90ff9a8264918..d47dfafa717ad 100644
> --- a/drivers/infiniband/hw/zrdma/zrdma_verbs.c
> +++ b/drivers/infiniband/hw/zrdma/zrdma_verbs.c
> @@ -12,8 +12,37 @@ const struct ib_device_ops zxdh_dev_ops =3D {
>  	.owner =3D THIS_MODULE,
>  	.driver_id =3D RDMA_DRIVER_ZRDMA,
>  	.uverbs_abi_ver =3D ZXDH_ABI_VER,
> +	.dealloc_driver =3D zxdh_ib_dealloc_device,
>  };
> =20
> +/* Release everything the probe path may have allocated. The hook is
> + * called from ib_dealloc_device(), so it must tolerate a partially
> + * initialised device.
> + */
> +void zxdh_ib_dealloc_device(struct ib_device *ibdev)
> +{
> +	struct zxdh_device *zdev =3D to_zdev(ibdev);
> +
> +	if (!zdev)
> +		return;
> +
> +	if (zdev->rf) {
> +		kvfree(zdev->rf->qp_cnt_8k_idxs);
> +		kvfree(zdev->rf->mem_rsrc);
> +		kfree(zdev->rf);
> +		zdev->rf =3D NULL;
> +	}

[Severity: High]
Can this double-free zdev->rf->qp_cnt_8k_idxs if zxdh_ctrl_init_hw() fails?

In zxdh_probe()->zxdh_ctrl_init_hw()->zxdh_initialize_hw_rsrc(), if the
first vzalloc() succeeds for rf->qp_cnt_8k_idxs and the second vzalloc()
fails for rf->mem_rsrc, zxdh_initialize_hw_rsrc() frees rf->qp_cnt_8k_idxs
without clearing the pointer:

drivers/infiniband/hw/zrdma/zrdma_hw.c:zxdh_initialize_hw_rsrc() {
	...
	rf->qp_cnt_8k_idxs =3D vzalloc(rf->max_8k_idx * sizeof(u32));
	if (!rf->qp_cnt_8k_idxs) {
		ret =3D -ENOMEM;
		goto mem_8k_qp_cnt_vmalloc_fail;
	}

	rsrc_size =3D zxdh_calc_mem_rsrc_size(rf);
	rf->mem_rsrc =3D vzalloc(rsrc_size);
	if (!rf->mem_rsrc) {
		ret =3D -ENOMEM;
		goto mem_rsrc_vmalloc_fail;
	}
	...
mem_rsrc_vmalloc_fail:
	vfree(rf->qp_cnt_8k_idxs);
mem_8k_qp_cnt_vmalloc_fail:
	return ret;
}

zxdh_probe() then jumps to err_dealloc and calls ib_dealloc_device(), which
invokes zxdh_ib_dealloc_device() and calls kvfree(zdev->rf->qp_cnt_8k_idxs)=
 a
second time on the dangling pointer.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027021119.2325=
798-1-zhang.yanze@zte.com.cn?part=3D5
