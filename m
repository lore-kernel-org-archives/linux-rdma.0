Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873433A4F30
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 08:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788943838; cv=none; b=mRr7o0z/bXYkzBd5Cxm20OSoKzIYyxZcvFWQXg9h/nxZpEFusZZEg2CWKLsKF/DRNZUHdoGkWVF7afHll4LHXy1bisUqcxz939eJyGIJdgWxiEbVVj9J+av8cmO3qPwBI5jdAZhbr2W72lmkW7qcjOJwZwcGWik0qJu37RMPWxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788943838; c=relaxed/simple;
	bh=a4ihGqfVmjjUyds7mJY1inYLiQTp9Gy4V55Cqmj7rNA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fUh8xAnqeCATlEx+Mj4W68IeX9cOVL2ZKrjAj05wfjTCB0qsWRIzeKg+QfsYFsmgm0E0+0iNfCJ5a1H/kfcAZDYDx8VEsvavxGNGTHy0f11W3YRAZUmqTp8i6yDU3r4JlyaVNCzoDPFCUnM4d003L3wf2/i2sGfQdAubyAHuZlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TStcTgEy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TStcTgEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0F11F00A3A;
	Wed,  9 Sep 2026 08:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788943837;
	bh=r+nFa7sw2qlUWtvXOd+lKvnQxPpSUYRQcs+3oCnW7dw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TStcTgEyhg9S2IKGyPL6wsUZuQEOYhmTS4YFlT9nDl8qAt4GgAZG45FGgXsO3uvXp
	 2fWLbOP8PTC1kuxggdN6NCMvXC2nfSnGJlcZNMsWdIXfnMmnKF8dSWrpB6dObDkLTj
	 8/XOnPCw49zwIC0SNQYZueKEz/kC++ph9wb5kEgDa3Qw/uldHY11WiXW7Wwjdwweea
	 je5TP9foyphXkYxbt5n0pGMBrDdkRcS2ThOqGMQ+nXPQ6b73o/fTguZJ5pwTM9VzNO
	 XcxRVyTL/bNficJGcYgutvLnwZRNhT87KecvHhYeh0b2phVpekoQgE2dNiapY8Sblh
	 VNVGzn7/reqqg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc v2 5/8] RDMA/bnxt_re: Fix rdev lifetime races in
  suspend/resume/shutdown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Selvin Xavier" <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260909135244.122747-5-selvin.xavier@broadcom.com>
References: <20260909135244.122747-1-selvin.xavier@broadcom.com>
 <20260909135244.122747-5-selvin.xavier@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 08:50:36 +0000
Message-Id: <20260909085037.0B0F11F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The patch misses applying the Use-After-Free fix to `bnxt_re_remov=
e()`, leaving the exact same race window open during device unbind or modul=
e unload.
- [High] Use-After-Free during `bnxt_re_dev_init()` failure path due to int=
ernal resource teardown while `en_info->rdev` is still valid.
- [High] Insufficient synchronization between `bnxt_re_update_en_info_rdev(=
)` (`rtnl_lock`) and lockless RCU readers like `bnxt_re_async_notifier()`, =
leading to Use-After-Free.
--

commit 1f3564eb53548d58fabdef6b5b5a607d2ac66cdf
Author: Selvin Xavier <selvin.xavier@broadcom.com>
Subject: RDMA/bnxt_re: Fix rdev lifetime races in suspend/resume/shutdown

This commit attempts to fix use-after-free windows in the suspend, resume,
and shutdown paths by ensuring the rdev pointer is cleared before device
resources are freed.

> diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw=
/bnxt_re/main.c
> index ce72db1b4bc34..142bf9a8ca4a4 100644
> --- a/drivers/infiniband/hw/bnxt_re/main.c
> +++ b/drivers/infiniband/hw/bnxt_re/main.c
> @@ -2427,11 +2427,14 @@ static int bnxt_re_add_device(struct auxiliary_de=
vice *adev, u8 op_type)
>  	bnxt_re_update_en_info_rdev(rdev, en_info, adev);
> =20
>  	rc =3D bnxt_re_dev_init(rdev, op_type);
> -	if (rc)
> +	if (rc) {
> +		bnxt_re_update_en_info_rdev(NULL, en_info, adev);
>  		goto re_dev_dealloc;
> +	}

[Severity: High]
This is a pre-existing issue, but does this approach fully prevent the race
during a device initialization failure?

If bnxt_re_dev_init() fails internally after registering the netdev, it
jumps to its internal fail label and calls bnxt_re_dev_uninit(). At this
stage, en_info->rdev is still valid.

If an async ULP callback triggers during this teardown, could it access
partially destroyed resources before bnxt_re_dev_init() returns and the
pointer is finally cleared here?

[ ... ]

> @@ -2533,8 +2539,9 @@ static int bnxt_re_suspend(struct auxiliary_device =
*adev, pm_message_t state)
> =20
>  	ibdev_info(&rdev->ibdev, "%s: L2 driver notified to stop en_state 0x%lx=
",
>  		   __func__, en_dev->en_state);
> -	bnxt_re_remove_device(rdev, BNXT_RE_PRE_RECOVERY_REMOVE, adev);
> +
> +	bnxt_re_update_en_info_rdev(NULL, en_info, adev);
> +	bnxt_re_remove_device(rdev, BNXT_RE_PRE_RECOVERY_REMOVE, adev);
>  	mutex_unlock(&bnxt_re_mutex);

[Severity: High]
This is a pre-existing issue, but is there sufficient synchronization betwe=
en
the pointer clearing and lockless RCU readers?

While bnxt_re_update_en_info_rdev() uses rtnl_lock() to clear the pointer,
readers like bnxt_re_async_notifier() read it under rcu_read_lock().

Because bnxt_re_remove_device() subsequently destroys the workqueue via
bnxt_re_uninit_dcb_wq() without waiting for synchronize_rcu(), could an
active concurrent RCU reader proceed to call queue_work() on the destroyed
workqueue?


Looking at the rest of the file, it appears a similar pattern exists in
bnxt_re_remove() which is not covered by this patch:

drivers/infiniband/hw/bnxt_re/main.c:bnxt_re_remove() {
        ...
        rdev =3D en_info->rdev;

        if (rdev)
                bnxt_re_remove_device(rdev, BNXT_RE_COMPLETE_REMOVE, adev);
        ...
}

[Severity: High]
This is a pre-existing issue, but since the patch fixes the use-after-free
window during suspend, resume, and shutdown, does bnxt_re_remove() need the
same fix?

When the auxiliary device is removed, bnxt_re_remove() calls
bnxt_re_remove_device() to destroy resources without first clearing
en_info->rdev. Could an asynchronous L2 ULP callback fire concurrently and
access the freed memory?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909135244.1227=
47-1-selvin.xavier@broadcom.com?part=3D5
