Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2168348662E
	for <linux-rdma@vger.kernel.org>; Mon, 14 Sep 2026 13:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789390955; cv=none; b=eng5Hgi7YO68k2XnpL032wfl2yNioszimF+LGcGa0Dc1kQRigu2tFwHZe2dGfWfeF/q7mh5fFnL+uLXoZ+IrIUProqUvRiuvm+sBQgCg0XVksWtsM8bZoBtWaTW5QWUdcKBtqQkKZ3OMbKkUIo6lCTbcfX6j/B5WCMwdMnxbBdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789390955; c=relaxed/simple;
	bh=ebHUIXW2Tcsfu/jf6MEzgDh4cud0ZsOwt8BQb7Na1tw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ctEifuszabqj0ZSCfgG1OZpJ7+uc+8nMYSS6U8SkIA4DnRlTsIQ/Ae7Dk2NZpYXtcHxK+to0fbs8r//ZZz9q0YDtC6ZDeR+/hYyI7Cx2slnP8oR2hiO0zggZvvx/Ea/lehBEnnMiU0WlTqF7X9xjULIhE32AysghyyA3IsKLVPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b6mt0Qn7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b6mt0Qn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DD41F000FF;
	Mon, 14 Sep 2026 13:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789390954;
	bh=8JS/xGfdrWjyzZhXnxPiFI0Od2fpGEvnMW+n2p3Ps6s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b6mt0Qn72rWaOWh1DY0jr3ceTPbq8KsqNVjabar5GnsPzq1JJ3WtleLspZ6tE5a01
	 wTqT9HuA4m/0bDP/4S596S8q14vYWbLiPNdPi3uo3+ZFy/1qDtbaLyraxI9L8Jqweb
	 7SJ7vz6M49oVNNffHEyvF/L5thXmEui8dpftPCLIQZN/V//d4DB4MDfEgdZz3vWRCY
	 Drlji8Ix0d3261m5yrv2fZwlRMsouIJNz2pjCLR8h/VrS54gnmT76pBbIzFwgAmERw
	 TC27cq6phoCHREYvdEs78bejanpMU0W8DQtGpBqzUCfwG03yVwsSOBjoob+BdGodNI
	 oPagHq/TuOZOw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/irdma: avoid use-after-free in icrdma_remove
Reply-To: sashiko-reviews@lists.linux.dev
To: "Guangshuo Li" <lgs201920130244@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260914122840.1709743-1-lgs201920130244@gmail.com>
References: <20260914122840.1709743-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 13:02:33 +0000
Message-Id: <20260914130233.D0DD41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Double deinitialization and use-after-free bugs in probe error pat=
hs when device registration fails.
--

commit 0724e8fb174ff83ee96cc996862eceaebf99da69
Author: Guangshuo Li <lgs201920130244@gmail.com>

RDMA/irdma: avoid use-after-free in icrdma_remove

icrdma_remove() accesses iwdev after calling irdma_ib_unregister_device(),
which could lead to a use-after-free. This patch fixes the issue by
saving the iwdev->rf pointer before unregistering the device and using it
for the remaining cleanup.

> diff --git a/drivers/infiniband/hw/irdma/icrdma_if.c b/drivers/infiniband=
/hw/irdma/icrdma_if.c
> index 4b451d8482a48..f405ef761f843 100644
> --- a/drivers/infiniband/hw/irdma/icrdma_if.c
> +++ b/drivers/infiniband/hw/irdma/icrdma_if.c
> @@ -318,14 +318,15 @@ static void icrdma_remove(struct auxiliary_device *=
aux_dev)
>  		container_of(aux_dev, struct iidc_rdma_core_auxiliary_dev, adev);
>  	struct iidc_rdma_core_dev_info *cdev_info =3D idc_adev->cdev_info;
>  	struct irdma_device *iwdev =3D auxiliary_get_drvdata(aux_dev);
> -	u8 rdma_ver =3D iwdev->rf->rdma_ver;
> +	struct irdma_pci_f *rf =3D iwdev->rf;
> +	u8 rdma_ver =3D rf->rdma_ver;
> =20
>  	ice_rdma_update_vsi_filter(cdev_info, iwdev->vsi_num, false);
>  	irdma_ib_unregister_device(iwdev);
> -	icrdma_deinit_interrupts(iwdev->rf, cdev_info);
> -	mutex_destroy(&iwdev->rf->ah_tbl_lock);
> +	icrdma_deinit_interrupts(rf, cdev_info);
> +	mutex_destroy(&rf->ah_tbl_lock);
> =20
> -	kfree(iwdev->rf);
> +	kfree(rf);

[Severity: High]
This isn't a bug introduced by this patch, but I noticed a similar issue
in the device probe functions in this driver.

If irdma_ib_register_device() fails, the error paths perform manual
cleanup and then call ib_dealloc_device().

For example, in icrdma_probe():

err_init_interrupts:
	mutex_destroy(&rf->ah_tbl_lock);
	kfree(rf);
	ib_dealloc_device(&iwdev->ibdev);

Since irdma_ib_register_device() sets .dealloc_driver =3D
irdma_ib_dealloc_device before attempting registration, does calling
ib_dealloc_device() here invoke irdma_ib_dealloc_device() using the
freed rf pointer, leading to a use-after-free and double-free?

Does this same pattern cause a similar use-after-free in i40iw_open()
(in drivers/infiniband/hw/irdma/i40iw_if.c) and a redundant call to
irdma_rt_deinit_hw() in ig3rdma_vport_probe() (in
drivers/infiniband/hw/irdma/main.c) resulting in a double-free of
iwdev->vsi.pestat and double-destroy of iwdev->cleanup_wq?

> =20
>  	pr_debug("INIT: Gen[%d] func[%d] device remove success\n",
>  		 rdma_ver, PCI_FUNC(cdev_info->pdev->devfn));

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914122840.1709=
743-1-lgs201920130244@gmail.com?part=3D1
