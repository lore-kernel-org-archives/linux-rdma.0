Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C283C3BE0
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 08:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791275869; cv=none; b=DJDvdkF7HhbUsvNX9hQ47GqJ48P/211HDYGlyR54j8ZMe+u6g6AaJ72Kl+7Ele/DbL68V+NB29YPVoA5j5/EYQMRJBUnpGDAknyyeOElDdSIIXLoCygcT0QR0+zR37vpXIdUG6S/fk7yXrmKxNhld4B2gZVwQtI/xvs7UfLgM5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791275869; c=relaxed/simple;
	bh=2/gVrq79UhU6DUgWr9ds6egwFde/dBNJJKCp9MhKE3g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cJ+COAtC6xMo707FuItwM5ySntPzxQWEmdSYTpGg9cgFMDF4yaxlCnjrau6hMpf4qa/7J4hvbzLnVf72hpgL979HWMNB2SqHRRncs94TDBASXGiqagURgZ446BpuX9+PKDdm4QaEWZtdLRih8UAqekBLdpxoDWRY1GzQBFko3Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iu2obLUc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iu2obLUc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310031F000FF;
	Tue,  6 Oct 2026 08:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791275868;
	bh=vf3jxzSsvgecucnv3lYUsSRpnRM7gTf6S/2ERjBhUdA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Iu2obLUc1NJulSFf0+R6ZYJdED77+8+vfDe4vvqq2TxtsUlQcGaXVjHSplImRXr3T
	 FKXyk91RxMKLjAQt9rQVyc+qAI6uF0fVm5TpdkH22OAlLbPnJZNFFcTowGV831p5+6
	 jST5ExtXrxFXMDtS1io6Yq04WGeXJKdRKu3PQ+ZU9M2CcVwIDsX8/tH0l+du2DAel/
	 I/wTTI8RexxWCvJNtQRjhbBuoeqoHO63Ri0VGxRyoq8LDuLhTV8Gn7+HAmBrPWXtDL
	 4bIzdbRjuYhszlX8YCk07iMC2bHRqT+JLs9m8dPN8XrN0bRD+OH3PrwAdvFNDyC7Oj
	 qxVtIxWKSjHRQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5.10] RDMA/hns: Fix WQ_MEM_RECLAIM warning
Reply-To: sashiko-reviews@lists.linux.dev
To: "Roman Demidov" <roman.demidov.nn@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261006081840.125567-1-roman.demidov.nn@gmail.com>
References: <20261006081840.125567-1-roman.demidov.nn@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 08:37:47 +0000
Message-Id: <20261006083748.310031F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] workqueue: WQ_MEM_RECLAIM rescuer deadlock via GFP_KERNEL
--

commit 324f8a5f04c3f5e308cb6f7d1d9cb0367924235e
Author: Chengchang Tang <tangchengchang@huawei.com>

RDMA/hns: Fix WQ_MEM_RECLAIM warning

This commit adds the WQ_MEM_RECLAIM flag to the hns_roce_irq_workq
workqueue to resolve a check_flush_dependency warning triggered during
QP destruction.

Link: https://patch.msgid.link/20260104064057.1582216-2-huangjunxian6@hisil=
icon.com

> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infinib=
and/hw/hns/hns_roce_hw_v2.c
> index 0468028ffe390..3e49baf2abf61 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> @@ -6082,7 +6082,8 @@ static int hns_roce_v2_init_eq_table(struct hns_roc=
e_dev *hr_dev)
>  		goto err_request_irq_fail;
>  	}
> =20
> -	hr_dev->irq_workq =3D alloc_ordered_workqueue("hns_roce_irq_workq", 0);
> +	hr_dev->irq_workq =3D alloc_ordered_workqueue("hns_roce_irq_workq",
> +						    WQ_MEM_RECLAIM);

[Severity: High]
Adding WQ_MEM_RECLAIM to a workqueue creates a rescuer thread that
executes during memory pressure to guarantee forward progress. Can this
introduce a deadlock if the work items perform GFP_KERNEL allocations?

Looking at the work executed by this queue, flush_work_handle() calls
hns_roce_modify_qp(), which eventually calls hns_roce_alloc_cmd_mailbox().

In hns_roce_alloc_cmd_mailbox(), memory is allocated using GFP_KERNEL:

drivers/infiniband/hw/hns/hns_roce_cmd.c:hns_roce_alloc_cmd_mailbox() {
        ...
        mailbox =3D kmalloc(sizeof(*mailbox), GFP_KERNEL);
        if (!mailbox)
                return ERR_PTR(-ENOMEM);

        mailbox->buf =3D dma_pool_alloc(hr_dev->cmd.pool, GFP_KERNEL,
                                      &mailbox->dma);
        ...
}

Since the rescuer thread is supposed to relieve memory pressure, blocking
on GFP_KERNEL allocations defeats its purpose and could permanently block
the rescuer. Does this patch trade a flush dependency warning for a
potential deadlock?

>  	if (!hr_dev->irq_workq) {
>  		dev_err(dev, "Create irq workqueue failed!\n");
>  		ret =3D -ENOMEM;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006081840.1255=
67-1-roman.demidov.nn@gmail.com?part=3D1
