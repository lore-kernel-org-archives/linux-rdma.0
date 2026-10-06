Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE5A3AB28F
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 08:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791275533; cv=none; b=HKKM7MzCarfMA+JMLwRlrl4lvl8oRJD9Jn+wVGhzS5nPgeKtVFzRd5buPB1Q3S+WRozGSe1MQRQ4KjLS1zAJYaYT/Hn58xDfByxOPGzay3IqsDRcPWhI4e5QMwon3baMaoJCRXFq+LCz2M+86yAy7KWi0iQJ0vMTdxgm9TU/Bx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791275533; c=relaxed/simple;
	bh=JTFtNw6OUGU6U7kSmlww9ya/U8rk8rgWBG7YCvPXOH4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=a99S8Q4YKtJjaeGm30JIRvVYsfl5QBWFduKhSzE1jWLj+mC0M11Aii28Bi+ucG/wDi33Tz6IYWFh48O04VIO1JqUMJuyMBBckGbf/9e25sC3wJDrbeYXah47VtPAayYQJxFi1wxJzEoAsCPbYv59f00UvNf9TK8rkaRfLJJpdbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mI8vTrd1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mI8vTrd1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5F61F000FF;
	Tue,  6 Oct 2026 08:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791275532;
	bh=rgfmHvz0mlBvx8n+gIz407Jn/qteoOi710lEsJfe2pw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mI8vTrd1UTygPrWL/NmMZFLZyAbTnLRG6d2ORQY7kyg1WP4kHaP8WKj3wV++SWy52
	 0A5kMo4js5gXmSvGe1ix4R8kIMmxtfOwu5UGHRt9N8BMLBgiGn3E7grUJxoT96QEav
	 bLjbRIisg0ppte9KPxuWpk/MYQwTBWg5mH2jo5FEynZfP9W/W9F6bp9Nry6e/1S/vh
	 fReajksLdZDmm/d2m6ea+zCk4AyK80HOEEdz476mqFaGATIRUaXHvTmaNWQbcjQjpr
	 CnxIuZeFZJiOZIbhQr2QSr736gKDAUmnwVWxQ/HKZS3/XS0VynqDYqRnXJrl0e0NRS
	 ldJD9hhkzoWKg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5.15] RDMA/hns: Fix WQ_MEM_RECLAIM warning
Reply-To: sashiko-reviews@lists.linux.dev
To: "Roman Demidov" <roman.demidov.nn@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261006081857.125617-1-roman.demidov.nn@gmail.com>
References: <20261006081857.125617-1-roman.demidov.nn@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 08:32:11 +0000
Message-Id: <20261006083211.DC5F61F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] RDMA/hns: WQ_MEM_RECLAIM violation causing deadlock risk
--

commit d3658f8cd2795fb06b4ce731d99702798127a921
Author: Chengchang Tang <tangchengchang@huawei.com>

RDMA/hns: Fix WQ_MEM_RECLAIM warning
   =20
This commit adds the WQ_MEM_RECLAIM flag to irq_workq to resolve a flush
dependency warning during xprt_rdma_connect_worker execution. It notes that
since QP destruction frees memory, this workqueue should have WQ_MEM_RECLAI=
M.

Link: https://patch.msgid.link/20260104064057.1582216-2-huangjunxian6@hisil=
icon.com

> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infinib=
and/hw/hns/hns_roce_hw_v2.c
> index d5f3faa1627a4..f0a33562f8657 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> @@ -6119,7 +6119,8 @@ static int hns_roce_v2_init_eq_table(struct hns_roc=
e_dev *hr_dev)
>  		}
>  	}
> =20
> -	hr_dev->irq_workq =3D alloc_ordered_workqueue("hns_roce_irq_workq", 0);
> +	hr_dev->irq_workq =3D alloc_ordered_workqueue("hns_roce_irq_workq",
> +						    WQ_MEM_RECLAIM);

[Severity: High]
Does adding WQ_MEM_RECLAIM here introduce a deadlock risk under memory
pressure?

The WQ_MEM_RECLAIM flag requires that works on this queue must not block on
memory allocations. However, flush_work_handle() runs on this queue and mak=
es
synchronous calls that trigger hardware QP modifications:

drivers/infiniband/hw/hns/hns_roce_qp.c:flush_work_handle() {
    ...
		ret =3D hns_roce_modify_qp(&hr_qp->ibqp, &attr, attr_mask, NULL);
    ...
}

These modifications eventually lead to allocations with GFP_KERNEL:

drivers/infiniband/hw/hns/hns_roce_cmd.c:hns_roce_alloc_cmd_mailbox() {
    ...
	mailbox =3D kmalloc(sizeof(*mailbox), GFP_KERNEL);
	if (!mailbox)
		return ERR_PTR(-ENOMEM);

	mailbox->buf =3D
		dma_pool_alloc(hr_dev->cmd.pool, GFP_KERNEL, &mailbox->dma);
    ...
}

When the system is under heavy memory pressure, the workqueue rescuer thread
activates to guarantee forward progress. The rescuer thread will block in
these GFP_KERNEL allocations waiting for memory reclaim, while memory recla=
im
might be waiting for this workqueue to process items (as seen in the rpcrdma
trace in the commit message).

Will this unresolvable circular dependency cause a hard deadlock?

>  	if (!hr_dev->irq_workq) {
>  		dev_err(dev, "failed to create irq workqueue.\n");
>  		ret =3D -ENOMEM;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006081857.1256=
17-1-roman.demidov.nn@gmail.com?part=3D1
