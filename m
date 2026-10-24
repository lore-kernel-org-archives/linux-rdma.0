Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792827811;
	b=qF/+LZhUisBxT0ZaJFdSmcmID4Fm0OVv3d8PrnAo3hXxiIpNliQvnZpC/jUd2jP83APU
	 U6tzxugdlQIwf9k9bI7U99uQUx0I1FQo5rd+RSq2nGiA+lgqESaxR1EMLx9G91boqm65u
	 YBMuxb96BqWbQCYNDXG6gd599NX2iO+pCpyH15jZxA8i84gNsgZyPfKYxg3B+zoXP5uai
	 i9q524Fagrlfo1ApCHvVMWQ0ZWInHhvX/bKi4/fuHmwJTaHlZirYur15GEzv6wWgZi4cE
	 9iQltX1R0xWdHTJhWqFdcRlrDa2UCBu86gmkIZISTTBHIRKkUm1hdZufOPoCWzRw5wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792827811;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=++mDTC0dHMM1YS0CpPmt7lOqdqDemqq0Vgg9htFyIqY=;
	b=SEIMYlSgKAlLob3K5bh7vDnSz115z+cNIRVCfdQB3U2C0OUcT0pm6UtdUdB97+B+pmuu
	 XnWzrDdX9n+wddfOee6oHymIGhm5jVhtxz9hn4upx7z++5644gcFTaWqxtFBqykMBfONX
	 rUvKGP6jsKkdtGjLydQ3twRhLDf/3cAaHWlF7Qg8uDY3R7dYAWkwqfXtoATip3l4DU1Vo
	 VPEZDUPBS3CG1rD97GGgyzJDKBwbHRFT/VdI4s3oYMEF/1ET7hSpnvtJAQYfnMHRO6WZM
	 OEHKQJawp7SihZI4CU9YosGET7Y7PJOm51n+8x1gwYrpumstxLOcrB2uGvuNv6WImpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WuDDNxOv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E69A606A31A
	for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 07:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WuDDNxOv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C151F01825;
	Sat, 24 Oct 2026 07:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792827810;
	bh=++mDTC0dHMM1YS0CpPmt7lOqdqDemqq0Vgg9htFyIqY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WuDDNxOv15Lr7qLUoPYUAp7Gg0sE8GVSgI2VGipDsCOdFD6IXhQRnE9DJ/vMUlunb
	 IbOCQyG4nXLiFFMQtHQIDX3nwLoMMExsIghJoX9QmTIQsQzDhwf6x+bg6banC3xTdC
	 PiGxb8nTqgSUQdGrNpZ3OlmOs64qbTnLpw/G5PEMgS9n68Q1d6F8q7SSrpJQMXVSyS
	 xjZjf8jOAHko/O+/mMFSRpHPxd2pTwGo/6h6J2kBow0ICW7WneiCn9g4jNdFosVIQ/
	 s4zj5nBPL5THnNoJ1aiVYgbXwUZGKrVl2OCJv5XG5SVIXRCyo2esp/KvhYZXO4o1MA
	 FnjuCmEUbruRg==
Message-ID: <sashiko-outbox-183590@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6/7] RDMA/zrdma: Implement context, PD, and mmap
 operations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yanze Zhang" <zhang.yanze@zte.com.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261024071539.2182864-7-zhang.yanze@zte.com.cn>
References: <20261024071539.2182864-1-zhang.yanze@zte.com.cn>
 <20261024071539.2182864-7-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 07:43:29 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] RDMA/zrdma: resource leak on probe failure due to late ib_set_devi=
ce_ops()
- [Medium] RDMA/zrdma: truncated SRQ doorbell mmap range in zxdh_alloc_ucon=
text()
--

commit 42854f9bc8b33facfd22e1942728befbae8346de
Author: Yanze Zhang <zhang.yanze@zte.com.cn>

RDMA/zrdma: Implement context, PD, and mmap operations

This commit implements protection domain allocation and deallocation, user
context management, and doorbell memory mapping for the zrdma driver. It al=
so
adds device teardown and initialization logic for RDMA device registration.

> diff --git a/drivers/infiniband/hw/zrdma/zrdma_verbs.c b/drivers/infiniba=
nd/hw/zrdma/zrdma_verbs.c
> index 6db536c94e01a..54b016ea8f5de 100644
> --- a/drivers/infiniband/hw/zrdma/zrdma_verbs.c
> +++ b/drivers/infiniband/hw/zrdma/zrdma_verbs.c
> @@ -7,24 +7,370 @@
>  #include "zrdma_main.h"
>  #include "zrdma_verbs.h"
>  #include "zrdma_ctrl.h"
> +#include <rdma/ib_mad.h>
> +#include <rdma/ib_cache.h>
> +#include <rdma/ib_user_verbs.h>
> +#include <linux/etherdevice.h>
> =20
> -static const struct ib_device_ops zxdh_dev_ops =3D {
> -	.owner =3D THIS_MODULE,
> -	.driver_id =3D RDMA_DRIVER_ZRDMA,
> -	.uverbs_abi_ver =3D ZXDH_ABI_VER,
> -};

[ ... ]

> +static void zxdh_ib_dealloc_device(struct ib_device *ibdev)
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
> +		/* rf =3D=3D NULL =3D> zxdh_probe early failure path; ah_list_lock
> +		 * not initialised, must not be destroyed.
> +		 */
> +		mutex_destroy(&zdev->ah_list_lock);
> +	}
> +	kfree(zdev->hdl);
> +	zdev->hdl =3D NULL;
> +}

[ ... ]

> +static int zxdh_alloc_ucontext(struct ib_ucontext *uctx, struct ib_udata=
 *udata)
> +{
> +	struct zxdh_ucontext *ucontext =3D to_ucontext(uctx);
> +	struct zxdh_alloc_ucontext_resp uresp =3D {};
> +	struct ib_device *ibdev =3D uctx->device;
> +	struct zxdh_device *zdev =3D to_zdev(ibdev);
> +	struct zxdh_alloc_ucontext_req req =3D {};

[ ... ]

> +	uresp.srq_db_bar_off =3D SRQ_DB_OFFSET;

[ ... ]

> +	if (ucontext->abi_ver =3D=3D ZXDH_CONTEXT_VER_V1 ||
> +	    ucontext->abi_ver =3D=3D ZXDH_CONTEXT_VER_V2) {
> +		ucontext->srq_db_mmap_entry =3D
> +			zxdh_mp_mmap_entry_insert(ucontext, SRQ_DB_BAR_OFF,
> +						  PAGE_SIZE,
> +						  ZXDH_MMAP_IO_NC_BY_SIZE,
> +						  &uresp.srq_db_mmap_key);
> +	} else {
> +		ucontext->srq_db_mmap_entry =3D
> +			zxdh_mp_mmap_entry_insert(ucontext, SRQ_DB_BAR_OFF,
> +						  SRQ_DB_MMAP_SIZE,
> +						  ZXDH_MMAP_IO_NC_BY_SIZE,
> +						  &uresp.srq_db_mmap_key);
> +	}
> +	if (!ucontext->srq_db_mmap_entry) {
> +		rdma_user_mmap_entry_remove(ucontext->sq_db_mmap_entry);
> +		rdma_user_mmap_entry_remove(ucontext->cq_db_mmap_entry);
> +		pr_err("zrdma: srq_db_mmap_entry is NULL!\n");
> +		return -ENOMEM;
> +	}
> +
> +	uresp.srq_db_mmap_size =3D SRQ_DB_MMAP_SIZE;

[ ... ]

> +static int zxdh_mmap(struct ib_ucontext *context, struct vm_area_struct =
*vma)
> +{
> +	struct rdma_user_mmap_entry *rdma_entry;
> +	struct zxdh_user_mmap_entry *entry;
> +	struct zxdh_ucontext *ucontext;
> +	u64 pfn;
> +	int ret;
> +
> +	ucontext =3D to_ucontext(context);
> +
> +	rdma_entry =3D rdma_user_mmap_entry_get(&ucontext->ibucontext, vma);
> +	if (!rdma_entry) {
> +		pr_err("zrdma: pgoff[0x%lx] does not have valid entry\n",
> +		       vma->vm_pgoff);
> +		return -EINVAL;
> +	}
> +
> +	entry =3D to_zxdh_mmap_entry(rdma_entry);
> +
> +	pfn =3D (entry->bar_offset +
> +	       pci_resource_start(ucontext->zdev->rf->pcidev, 0)) >>
> +	      PAGE_SHIFT;
> +
> +	switch (entry->mmap_flag) {
> +	case ZXDH_MMAP_IO_NC:
> +		ret =3D rdma_user_mmap_io(context, vma, pfn, PAGE_SIZE,
> +					pgprot_noncached(vma->vm_page_prot),
> +					rdma_entry);
> +		break;
> +	case ZXDH_MMAP_IO_NC_BY_SIZE:
> +		ret =3D rdma_user_mmap_io(context, vma, pfn,
> +					vma->vm_end - vma->vm_start,
> +					pgprot_noncached(vma->vm_page_prot),
> +					rdma_entry);
> +		break;

[Severity: Medium]
In drivers/infiniband/hw/zrdma/zrdma_verbs.h, SRQ_DB_BAR_OFF is defined as
0x62000 and SRQ_DB_MMAP_SIZE is 0x10000:

#define ZXDH_PAGE_OFFSET_NUM (PAGE_SIZE - 1)
...
#define SRQ_DB_MMAP_SIZE 0x10000
#define SRQ_DB_BAR_OFF 0x62000

On kernels with 16KB or 64KB pages, SRQ_DB_BAR_OFF has an intra-page offset=
 of
0x2000. When zxdh_alloc_ucontext() registers ucontext->srq_db_mmap_entry wi=
th
length SRQ_DB_MMAP_SIZE (0x10000) for ZXDH_CONTEXT_VER_V3, and zxdh_mmap()
computes:

	pfn =3D (entry->bar_offset +
	       pci_resource_start(ucontext->zdev->rf->pcidev, 0)) >>
	      PAGE_SHIFT;

pfn is rounded down to BAR0 offset 0x60000. Mapping 0x10000 bytes from that
pfn only covers BAR0 [0x60000, 0x70000). When userspace adds srq_db_bar_off
(0x2000) to the mapped base address, won't the upper 0x2000 bytes of the SRQ
doorbell region at [0x70000, 0x72000) remain unmapped?

Also, when ucontext->abi_ver is ZXDH_CONTEXT_VER_V1 or ZXDH_CONTEXT_VER_V2,
zxdh_alloc_ucontext() inserts ucontext->srq_db_mmap_entry with length
PAGE_SIZE, but still sets uresp.srq_db_mmap_size =3D SRQ_DB_MMAP_SIZE. Shou=
ld
uresp.srq_db_mmap_size match the registered entry size for V1 and V2 so
rdma_user_mmap_entry_get() does not reject a mapping of uresp.srq_db_mmap_s=
ize
bytes?

[ ... ]

>  static int zxdh_init_rdma_device(struct zxdh_device *zdev)
>  {
> +	struct pci_dev *pcidev =3D zdev->rf->pcidev;
> +
> +	if (zdev->roce_mode)
> +		zxdh_init_roce_device(zdev);
> +	else
> +		return -EPFNOSUPPORT;
> +
>  	zdev->ibdev.phys_port_cnt =3D 1;
>  	zdev->ibdev.num_comp_vectors =3D zdev->rf->ceqs_count;
> -	zdev->ibdev.dev.parent =3D &zdev->rf->pcidev->dev;
> -
> -	ib_set_device_ops(&zdev->ibdev, &zxdh_dev_ops);
> +	zdev->ibdev.dev.parent =3D &pcidev->dev;
> =20
>  	return 0;
>  }
> =20
> +static const struct ib_device_ops zxdh_dev_ops =3D {
> +	.owner =3D THIS_MODULE,
> +	.driver_id =3D RDMA_DRIVER_ZRDMA,
> +	.uverbs_abi_ver =3D ZXDH_ABI_VER,
> +	.alloc_pd =3D zxdh_alloc_pd,
> +	.alloc_ucontext =3D zxdh_alloc_ucontext,
> +	.dealloc_driver =3D zxdh_ib_dealloc_device,
> +	.dealloc_pd =3D zxdh_dealloc_pd,
> +	.dealloc_ucontext =3D zxdh_dealloc_ucontext,
> +	.mmap =3D zxdh_mmap,
> +	.mmap_free =3D zxdh_mmap_free,
> +
> +	INIT_RDMA_OBJ_SIZE(ib_pd, zxdh_pd, ibpd),
> +	INIT_RDMA_OBJ_SIZE(ib_ucontext, zxdh_ucontext, ibucontext),
> +};
> +
>  int zxdh_ib_register_device(struct zxdh_device *zdev)
>  {
>  	int ret;
> @@ -33,6 +379,8 @@ int zxdh_ib_register_device(struct zxdh_device *zdev)
>  	if (ret)
>  		return ret;
> =20
> +	ib_set_device_ops(&zdev->ibdev, &zxdh_dev_ops);

[Severity: High]
Does calling ib_set_device_ops() here in zxdh_ib_register_device() leak
zdev->rf, zdev->hdl, zdev->rf->qp_cnt_8k_idxs, and zdev->rf->mem_rsrc if an
earlier failure occurs during zxdh_probe()?

In drivers/infiniband/hw/zrdma/zrdma_main.c, zxdh_probe() relies on
ib_dealloc_device(&zdev->ibdev) to invoke zxdh_ib_dealloc_device() on its
error paths:

	hdl =3D kzalloc_obj(*hdl);
	if (!hdl) {
		ib_dealloc_device(&zdev->ibdev);
		return -ENOMEM;
	}
...
	rf =3D zdev->rf;
	err =3D zxdh_ctrl_init_hw(rf);
	if (err)
		goto err_ctrl_init;

	err =3D zxdh_ib_register_device(zdev);
	if (err)
		goto err_ib_reg;
...
err_ib_reg:
err_ctrl_init:
	ib_dealloc_device(&zdev->ibdev);

If kzalloc_obj(*hdl), zxdh_ctrl_init_hw(), or zxdh_init_rdma_device() fails
(or even in follow-up commit 5562e1f8054b where ib_set_device_ops() is at t=
he
end of zxdh_init_rdma_device()), zdev->ibdev.ops.dealloc_driver is still NU=
LL
when ib_dealloc_device() runs, so zxdh_ib_dealloc_device() is never called.

Should ib_set_device_ops() be called right after ib_alloc_device() so that
zxdh_ib_dealloc_device() is always invoked on probe failure?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261024071539.2182=
864-1-zhang.yanze@zte.com.cn?part=3D6
