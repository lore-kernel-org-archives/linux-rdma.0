Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9CD37F8D6
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 14:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791469495; cv=none; b=N2pDdCzX1e/FUjbsVCH/R7T05a0YPqvqcfUdZRpzHfvQXNyhhB0Dvra8eUJPGu/oXwNPYwDF7XxLpsx95Mg/oGkXI5eusj9tC+NR4WSdc4LrnBNjz6Y5aliqjV2tQJaQ4MVLNsAY+IVInC9cd4QgFEazX1kMvUIeWYGdy/0qtpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791469495; c=relaxed/simple;
	bh=ZIVXXNZbBPBGAbm90h18oS+KoIRy4IXGWjOp2DQaua4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=hRk0n4kaAx8r/+bNSEEuSF30ewWU5IQzr36t14VAxkBumE4Z4VdXsmGFxwZlv/MFXo/yMNWA6c+G59mBmRi+fbl9nYWPaK0xIGk7+Ints+BQvc8U3y19DzAajuu6w2c7tgzYmGkSayW1u1QaBvCHmylui+bVHwOJ32kAfJV9ubU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jOZqqyGS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jOZqqyGS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 513061F000FF;
	Thu,  8 Oct 2026 14:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791469494;
	bh=K9uJyXAH1+pOalbwuUzRleiCRkyGBq/ORV/lfMFD6JI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jOZqqyGS/Gp2yVCiollufMH/devBwnk/Vk56+Cod3z7OJu351veaEkiafXEr9F5WD
	 5L8dAeaAWGNMiScfSl3wCB9RFiIjaR+TMtgWUzb3pjmAjzliB6hiq93JEGCuGFllZd
	 Te9YOuk0c+wy1U0T1TV5PPD2E81JYwLFWa3TiDi2FGrfCRExRNL6Yg/tLdwYGWjHkv
	 ZTm7jF7+UL0HB0ei/T5h6mDcLmLuPTJXE9MjLyi8JEtnC0VHxBQMxBj2DU2JVO5/oZ
	 tFaPzrC4W2CehuYNDjzV0zjaFi7OV7+uIzeiECk4NIWRh9Am5Ysdu9EiWweBZ9SDYS
	 8bLs2EhP1bGiw==
Message-ID: <sashiko-outbox-164281@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma] RDMA/mlx5: Cancel software CQ notifications before
 teardown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Prathamesh Deshpande" <prathameshdeshpande7@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008141209.6923-1-prathameshdeshpande7@gmail.com>
References: <20261008141209.6923-1-prathameshdeshpande7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 14:24:54 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] rdma/mlx5: missing wc_list drain in mlx5_ib_pre_destroy_cq() cau=
ses leak
--

commit bb2bb35d84abe8b8d9f71ac658dfcd1b34acddcb
Author: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>

RDMA/mlx5: Cancel software CQ notifications before teardown

This commit cancels notify_work in the pre-destroy callback to prevent queu=
ed
or running work from accessing a freed CQ or restarting polling after the CQ
is drained. User CQs are skipped because they do not initialize this work
item.

> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5=
/cq.c
> index 072b77a2c8a6c..7495e20c3dec9 100644
> --- a/drivers/infiniband/hw/mlx5/cq.c
> +++ b/drivers/infiniband/hw/mlx5/cq.c
> @@ -1117,6 +1117,9 @@ int mlx5_ib_pre_destroy_cq(struct ib_cq *cq)
>  	struct mlx5_ib_dev *dev =3D to_mdev(cq->device);
>  	struct mlx5_ib_cq *mcq =3D to_mcq(cq);
> =20
> +	if (!cq->uobject)
> +		cancel_work_sync(&mcq->notify_work);
> +

[Severity: Medium]
Does this code cause a memory leak regression by leaving dynamically alloca=
ted
elements in mcq->wc_list undrained?

When mlx5_ib_generate_wc() generates software completions, it dynamically
allocates memory for them and queues them to the wc_list:

mlx5_ib_generate_wc() {
	...
	soft_wc =3D kmalloc_obj(*soft_wc, GFP_ATOMIC);
	...
	list_add_tail(&soft_wc->list, &cq->wc_list);
	...
}

If the CQ is destroyed before these completions are polled,
mlx5_ib_pre_destroy_cq() correctly stops the workqueue to prevent
use-after-free, but it fails to drain mcq->wc_list.

Since the work queue is no longer running to consume these elements, they
will be leaked when the CQ is freed.

>  	return mlx5_core_destroy_cq(dev->mdev, &mcq->mcq);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008141209.6923=
-1-prathameshdeshpande7@gmail.com?part=3D1
