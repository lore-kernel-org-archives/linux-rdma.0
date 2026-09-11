Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D90B3A9D80
	for <linux-rdma@vger.kernel.org>; Fri, 11 Sep 2026 06:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789107723; cv=none; b=XoEN5UWIXSIoPtH7I3Ca9BoBSLCBPCKsHdr1e0wa1Cx3sd+dHLUu7Euz8uxm1DrTwNokBDCc2XdGv6tKqt+0Hu29u3C6kas2ae3NPleZsv4gVh8hedYXqEgX5pAuTGrCkgI/rK/tPkf+XyJIUud1V8Hi4UbmYGKhvjAKzAIRJ4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789107723; c=relaxed/simple;
	bh=egKY/Qmgxo13K4GBt64gvpa+PzKZB0zq1yNuqExdcU0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=q5U/2isBg8IONECqAdoh2XrVVzhD/Qjb2LMvTDqO4T2H1IwTgNb6/fN8qd2Pa/LKqJ24ZLRQdJqTZ1ymDmH2y2Pjr2bjEFQ/U3KVBX6Txf3KOkoDvshWq91LJZEJ/+G7L1jA/VHOREL0g0L2O/8zqdk0m2L5TGi23ii06ky6dis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JuFNiUoD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JuFNiUoD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28391F000FF;
	Fri, 11 Sep 2026 06:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789107721;
	bh=ek0EQZKHgWOqwrZT14hGKybqGyNjEJPQxYu9tC0qYtA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JuFNiUoDlFVh76COmFmED6g47rYi70jHfkwSi13xqcKdSh2UdC6trcpjatHWf+tuo
	 LmseTG6aFWjk3/Uq4doKYie0zjjnawTyqZc8at8t0AOpkS1MNCkuLakIMQ6x177JlU
	 If+8WnBi/5omMX2wldHgbcYGTtX2n7sckFddKAE4HgWr3nphe27okHXT5BuOIPPuVQ
	 qbVM+uy6YSyubDiIj+QI+wXPKan1OWf/PrvaADrpHw1KtAhVUQPHY864rg4Sa+dZQd
	 MQ6a3OUau9IiNoSjX9qVI4DjWqZCfG11RKGym2V1aUiH/jCSn6tuS+rgdgxs+PBx1F
	 p0HiWkaM7zITQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC] RDMA/irdma: check vport device allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Slavin Liu" <bolin.liu@seu.edu.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260911060909.94219-1-bolin.liu@seu.edu.cn>
References: <20260911060909.94219-1-bolin.liu@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 06:22:01 +0000
Message-Id: <20260911062201.B28391F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Double-free and Use-After-Free in the probe error paths when irdma=
_ib_register_device() fails, due to redundant irdma_rt_deinit_hw() and irdm=
a_ctrl_deinit_hw() calls.
--

commit 0981212030a2affcec23860d2a7ba06344c067f0
Author: Slavin Liu <bolin.liu@seu.edu.cn>

RDMA/irdma: check vport device allocation

This commit adds a missing NULL pointer check after allocating iwdev in
ig3rdma_vport_probe(). It returns -ENOMEM to prevent initializing the
structure if the allocation fails.

> diff --git a/drivers/infiniband/hw/irdma/main.c b/drivers/infiniband/hw/i=
rdma/main.c
> index 95957d52883dd..106915b51e7cb 100644
> --- a/drivers/infiniband/hw/irdma/main.c
> +++ b/drivers/infiniband/hw/irdma/main.c
> @@ -80,6 +80,8 @@ static int ig3rdma_vport_probe(struct auxiliary_device =
*aux_dev,
>  		return -ENOMEM;
>  	}
>  	iwdev =3D ib_alloc_device(irdma_device, ibdev);
> +	if (!iwdev)
> +		return -ENOMEM;
>  	/* Fill iwdev info */
>  	iwdev->is_vport =3D true;
>  	iwdev->rf =3D rf;

[Severity: High]
This is a pre-existing issue, but does the error handling later in
ig3rdma_vport_probe() trigger a double-free if irdma_ib_register_device()
fails?

If irdma_ib_register_device() fails after setting the .dealloc_driver
callback, the error unrolling logic manually tears down resources and then
calls ib_dealloc_device():

drivers/infiniband/hw/irdma/main.c:ig3rdma_vport_probe() {
    ...
err_ibreg:
	irdma_rt_deinit_hw(iwdev);
err_rt_init:
	ib_dealloc_device(&iwdev->ibdev);

	return err;
}

Because ib_dealloc_device() automatically invokes the registered
.dealloc_driver callback, it calls irdma_ib_dealloc_device() which
redundantly repeats the teardown:

drivers/infiniband/hw/irdma/verbs.c:irdma_ib_dealloc_device() {
	struct irdma_device *iwdev =3D to_iwdev(ibdev);

	irdma_rt_deinit_hw(iwdev);
    ...
}

Would calling irdma_rt_deinit_hw() a second time cause a double kfree() on
iwdev->vsi.pestat and a double destroy_workqueue() on iwdev->cleanup_wq?

drivers/infiniband/hw/irdma/hw.c:irdma_rt_deinit_hw() {
    ...
	if (iwdev->vsi.pestat) {
		irdma_vsi_stats_free(&iwdev->vsi);
		kfree(iwdev->vsi.pestat);
	}
	if (iwdev->cleanup_wq)
		destroy_workqueue(iwdev->cleanup_wq);
    ...
}

Additionally, does this same pattern cause a use-after-free in non-vport
drivers?

drivers/infiniband/hw/irdma/i40iw_if.c:i40iw_open() {
    ...
err_ctrl_init:
	kfree(iwdev->rf);
	ib_dealloc_device(&iwdev->ibdev);
    ...
}

Since the unexpected dealloc_driver callback dereferences iwdev->rf,
wouldn't this guarantee a use-after-free on iwdev->rf?

drivers/infiniband/hw/irdma/verbs.c:irdma_ib_dealloc_device() {
    ...
	if (!iwdev->is_vport) {
		irdma_ctrl_deinit_hw(iwdev->rf);
    ...
}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911060909.9421=
9-1-bolin.liu@seu.edu.cn?part=3D1
