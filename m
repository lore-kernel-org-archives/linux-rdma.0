Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795003037;
	b=pg/xDqSDlMXmTdAAuep0o3h9nhLGA+nogCEzAdQEuuLNVwlwAnOeHb9+uGP8LnbaF3He
	 b4kzHZdciiTr0q4cGVqJqMR+VglmmtI8r3LCiVPCK3zTeCAY5M5bNkYTKs8/a0Yo+TClm
	 KcZeN6jBLYgAFwMEoSfOG7esIn5Wk7M9Qdg5mqiC71Ffyb6GBHxJFaeF8sHrRQq/3ejw8
	 aGySmxzX9v9ErXS2Mck0JGm8J0WpP2ZHWwqsT3DE1KuYw2LPL+Tu5zBmFoXS88t91W89P
	 psSF+l61Tv3sjJuzp7buuEu59JZ7aeQnEA04krXUyuZ+uoDHiFxt1Kk8OD7o3d4VnGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795003037;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ZDntiBPdbVozbmSy5gqwRh/2LvLM40ExKHAUGpqVQ3I=;
	b=4MiPtv1kKbxYieNN30xCf+fWjdJGQhoJZHcMsyHkudQL9s7YPc/hy6YV2cobo0EQ+j82
	 oUP5rVnCtt8JrKKzoB3edcpzvwRA4QdB7whOK9pBNS2UVDddt2VEhyAsur+RMp4btXz5/
	 mBky77pnG4ESH/s64+VtTnP16zQc6WvZNIrovfU3F+mZ9LCgn4f5ovH0uTJwZfE0hkg6+
	 bG6/Ngo4G1uDV37aLwoDNy2xO+4/gtEd55eavt2ovb3fUtAZwZ2Sm1x9Mnj75XQ08NQlI
	 49pi+sKkN63sdUanMuv72yi6JWIv7HeAKGskrmpulvW1iir5uzWEYAc8RU5wiomyfWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M+z3JzAU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C96606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 11:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M+z3JzAU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9A21F000C4;
	Wed, 18 Nov 2026 11:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795003037;
	bh=ZDntiBPdbVozbmSy5gqwRh/2LvLM40ExKHAUGpqVQ3I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M+z3JzAUETIp6lEnB7gaV9Wc3ZIQq9npH5NcbZFn9OWFjdtOpKStF777crQHdtzMx
	 lmuDCNcaQKE3udymRQv7BJ/BdjfBqvZIVfn0wLb2QEoVnR2A4CRjm06e0al2EhYw7r
	 +T+R/WwgN4mf2CQss6E30qYKDDf/rKcio4ASVlAH2AwYPXc6H5C3EVbwAR5PU/eDJv
	 OI7lq5X63Nuc+zWOkp7xvzGkqOAiawHjp58u6LZejSUV/QNodtl+O58wEp4Yx0xlNX
	 dIhOQPKBMLvewDjv0gXwiqsp1XGPexvjjRwa/KEd4YSzYfJDso2iBAm/t/D/7BvfsJ
	 1bcz2JEiJDQ8g==
Message-ID: <sashiko-outbox-220866@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC 4/4] nvme-rdma: support dma-buf backed requests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anuj Gupta" <anuj20.g@samsung.com>
Cc: linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261118103327.1788667-5-anuj20.g@samsung.com>
References: <20261118103327.1788667-1-anuj20.g@samsung.com>
 <CGME20261118103457epcas5p17770752b910960b84cc259d007120965@epcas5p1.samsung.com>
 <20261118103327.1788667-5-anuj20.g@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 11:57:15 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] nvme-rdma: use-after-free on ctrl->device in
  nvme_rdma_remove_one()
- [Medium] nvme-rdma: nvme_rdma_remove_one() fails to wait for
  nvme_delete_ctrl_sync()
--

commit 7ad9fcf127f13cdfc7ce401ed605b13cf6ca3225
Author: Nitesh Shetty <nj.shetty@samsung.com>

nvme-rdma: support dma-buf backed requests

This commit implements ->init_dma_buf_io_ctx for nvme-rdma so that memory
exported through dma-buf can be registered with io_uring and used for I/O
to an nvme-rdma namespace.

> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> index 32189fdfc0f51..e7c26bd4f77d0 100644
> --- a/drivers/nvme/host/rdma.c
> +++ b/drivers/nvme/host/rdma.c

[ ... ]

> @@ -2413,7 +2573,7 @@ static void nvme_rdma_remove_one(struct ib_device *=
ib_device, void *client_data)
>  {
>  	struct nvme_rdma_ctrl *ctrl;
>  	struct nvme_rdma_device *ndev;
> -	bool found =3D false;
> +	bool found =3D false, need_flush;
> =20
>  	mutex_lock(&device_list_mutex);
>  	list_for_each_entry(ndev, &device_list, entry) {
> @@ -2423,20 +2583,24 @@ static void nvme_rdma_remove_one(struct ib_device=
 *ib_device, void *client_data)
>  		}
>  	}
>  	mutex_unlock(&device_list_mutex);
> +	need_flush =3D found;
> =20
> -	if (!found)
> -		return;
> -
> -	/* Delete all controllers using this device */
> +	/*
> +	 * Delete controllers using this device, and controllers that
> +	 * reconnected elsewhere but still have dma-bufs attached to it.
> +	 */
>  	mutex_lock(&nvme_rdma_ctrl_mutex);
>  	list_for_each_entry(ctrl, &nvme_rdma_ctrl_list, list) {
> -		if (ctrl->device->dev !=3D ib_device)
> +		if (!(found && ctrl->device->dev =3D=3D ib_device) &&
> +		    !nvme_dmabufs_use_owner(&ctrl->dmabufs, ib_device))

[Severity: High]
Can dereferencing ctrl->device->dev here cause a use-after-free on
ctrl->device?

ctrl->device is assigned from ctrl->queues[0].device without its own
nvme_rdma_device reference, so when nvme_rdma_destroy_admin_queue() frees
ctrl->queues[0], nvme_rdma_dev_put() can free ctrl->device while leaving
ctrl->device non-NULL.  With this patch, __nvme_init_dma_buf_io_ctx_locked()
takes an nvme_get_ctrl() reference that is only dropped in
nvme_dma_buf_io_release(), keeping deleted controllers on
nvme_rdma_ctrl_list after their admin queue and ctrl->device have been
freed (and reconnecting controllers on nvme_rdma_ctrl_list also have no
admin queue).

When found is true for ib_device, this loop visits every controller on
nvme_rdma_ctrl_list and reads ctrl->device->dev without holding
ctrl->dmabufs.lock or checking !ctrl->dmabufs.dead.  Even for a controller
using ib_device, its admin queue can be torn down after device_list_mutex
is dropped:

CPU0                                  CPU1
nvme_rdma_remove_one(ib_device)
  mutex_lock(&device_list_mutex)
  found =3D true
  mutex_unlock(&device_list_mutex)
                                      nvme_rdma_error_recovery_work()
                                        nvme_rdma_destroy_admin_queue()
                                          nvme_rdma_free_queue(&queues[0])
                                            nvme_rdma_dev_put(device)
                                              kfree(device)
  mutex_lock(&nvme_rdma_ctrl_mutex)
  ctrl->device->dev =3D=3D ib_device  <-- use-after-free

Checking ctrl->device->dev under ctrl->dmabufs.lock only when
!ctrl->dmabufs.dead would ensure the admin queue and ctrl->device are still
live.

>  			continue;
>  		nvme_delete_ctrl(&ctrl->ctrl);
> +		need_flush =3D true;
>  	}
>  	mutex_unlock(&nvme_rdma_ctrl_mutex);
> =20
> -	flush_workqueue(nvme_delete_wq);
> +	if (need_flush)
> +		flush_workqueue(nvme_delete_wq);
>  }

[Severity: Medium]
Can nvme_rdma_remove_one() return before nvme_remove_dmabufs() detaches
contexts from ib_device when racing with nvme_delete_ctrl_sync()?

CPU0                                  CPU1
nvme_sysfs_delete()
  nvme_delete_ctrl_sync()
    nvme_change_ctrl_state(...,
      NVME_CTRL_DELETING)
    nvme_do_delete_ctrl()
                                      nvme_rdma_remove_one(ib_device)
                                        nvme_dmabufs_use_owner(...) =3D=3D =
true
                                        nvme_delete_ctrl(&ctrl->ctrl)
                                          /* returns -EBUSY, already DELETI=
NG */
                                        flush_workqueue(nvme_delete_wq)
                                        /* returns to ib_unregister_device(=
) */
      nvme_rdma_delete_ctrl()
        nvme_remove_dmabufs()  <-- detaches after remove_one() returned

Because nvme_delete_ctrl_sync() runs nvme_do_delete_ctrl() directly in task
context rather than on nvme_delete_wq, nvme_delete_ctrl() fails to queue
delete_work and flush_workqueue(nvme_delete_wq) does not wait for the
in-progress deletion to finish detaching the dma-bufs from ib_device.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118103327.1788=
667-1-anuj20.g@samsung.com?part=3D4
