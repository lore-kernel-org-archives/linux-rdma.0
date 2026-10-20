Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792479568;
	b=S73tP2iACTxcw9/R+37MTVlNUhF0pgeCk5+jfRUG+3ii38WAq+uERhbnBeRsV6gJdK2w
	 kV3SG4ECY+Wj8Ygj2Wqioef3rJ9ZVUBMNN3/ZzOvTVmw96fbuBg4MKcYSNBqwBioLOln+
	 5Npw3/fw8wDxWsSgJ+24ysc8zjIRJpFf/57zFIx0xnrVPiFYDaF5N0l3qRnljzqJAyVai
	 ISY+7hRHmcC9L6LyoPkn/gGSmfE9vK6mxb3CfN9DHVXEiNQ/w9lC2RLFxaBfD66AHwxp7
	 xY3KnEiemRtBDbnDuaHvGCVsBuQDih/mAo10DNH94lIiZt0hjpil21G0SNLQkSdPijg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792479568;
	h=Received:Message-ID:From:Subject:Reply-To:To:Cc:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:Date;
	bh=GNgGNwvFAqB+5GglajRuYHSbxfe20Slti+2cXbK7VOw=;
	b=zmaFlFpiM7spRkL7vxEyTZG31zPJIy/dkwKP88Sh3PxiNNpuzy3R/URUYdgaOsgVfr6l
	 82fpSAtk1ZFjB1hqHGEAuyVmIqT2gMFfpe+Fjw8jZHacaKIsVtdHWfaRMOEUB+hih0V20
	 Kx/oQBVEXk66CkGaabbcXNSfpqyUNT1TwVMM3Ih80O8cGBM+j1TvyVYMkwIVflObP2D74
	 fD1GeuBbBtGE2l0DaRlnBRYNnhB9mWIJTKdS4IS8m/P0+v4m32QSdBRKPDu9yvx1gNJMd
	 Gn8FQR6+trqes/WY8q9MDppDRZToxZoJ4QjtMumw4h2zVHyt7HRGN1cQV4PfcQlHlEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4A4606A319;
	Tue, 20 Oct 2026 06:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820151F01810;
	Tue, 20 Oct 2026 06:59:27 +0000 (UTC)
Message-ID: <sashiko-outbox-178445@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH iwl-net 2/3] ice: do not block on the aux device lock in
 ethtool set_channels
Reply-To: sashiko-reviews@lists.linux.dev
To: "Petr Oros" <poros@redhat.com>
Cc: linux-rdma@vger.kernel.org, intel-wired-lan@lists.osuosl.org, linux-rt-devel@lists.linux.dev, linux-kernel@vger.kernel.org
In-Reply-To: <20261019065301.3983537-3-poros@redhat.com>
References: <20261019065301.3983537-1-poros@redhat.com>
 <20261019065301.3983537-3-poros@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 06:59:13 +0000
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
- [High] ice: TOCTOU NULL dereference on cdev_info->adev in ice_set_channel=
s()
--

commit 41ef61e89b925d28893681cf06722f3b9581b193
Author: Petr Oros <poros@redhat.com>

ice: do not block on the aux device lock in ethtool set_channels

This commit replaces device_lock() with device_trylock() in
ice_set_channels() to avoid a lock inversion between the RTNL lock and the
auxiliary device lock during RDMA auxiliary device probe, returning -EBUSY
when the lock is contended.

> diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/e=
thernet/intel/ice/ice_ethtool.c
> index aa87d4f6324e8..976402b6836de 100644
> --- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
> +++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> @@ -3947,7 +3947,11 @@ static int ice_set_channels(struct net_device *dev=
, struct ethtool_channels *ch)
> =20
>  	if (pf->cdev_info && pf->cdev_info->adev) {
>  		mutex_lock(&pf->adev_mutex);
> -		device_lock(&pf->cdev_info->adev->dev);
> +		if (!device_trylock(&pf->cdev_info->adev->dev)) {
> +			mutex_unlock(&pf->adev_mutex);
> +			netdev_dbg(dev, "RDMA auxiliary device is busy, try again\n");
> +			return -EBUSY;
> +		}
>  		locked =3D true;
>  		if (pf->cdev_info->adev->dev.driver) {
>  			netdev_err(dev, "Cannot change channels when RDMA is active\n");

[Severity: High]
This problem wasn't introduced by this patch, but can pf->cdev_info->adev
become NULL between the unlocked check in ice_set_channels() and the
device_trylock(&pf->cdev_info->adev->dev) call?

Paths that do not hold rtnl_lock, such as ice_service_task() handling
ICE_FLAG_UNPLUG_AUX_DEV, ice_prepare_for_reset(), or
ice_devlink_enable_roce_set() and ice_devlink_enable_iw_set(), can run
concurrently and call ice_unplug_aux_dev():

drivers/net/ethernet/intel/ice/ice_idc.c:ice_unplug_aux_dev() {
	...
	mutex_lock(&pf->adev_mutex);
	adev =3D pf->cdev_info->adev;
	pf->cdev_info->adev =3D NULL;
	mutex_unlock(&pf->adev_mutex);

	auxiliary_device_delete(adev);
	auxiliary_device_uninit(adev);
}

If ice_unplug_aux_dev() clears pf->cdev_info->adev after ice_set_channels()
checks it but before ice_set_channels() acquires pf->adev_mutex,
device_trylock(&pf->cdev_info->adev->dev) will dereference a NULL pointer
(and conversely, if ice_plug_aux_dev() assigns cdev->adev concurrently, the
RDMA active check could be skipped).

In contrast, ice_send_event_to_aux() checks cdev->adev after acquiring
pf->adev_mutex:

drivers/net/ethernet/intel/ice/ice_idc.c:ice_send_event_to_aux() {
	...
	mutex_lock(&pf->adev_mutex);
	if (!cdev->adev)
		goto finish;

	if (!device_trylock(&cdev->adev->dev)) {
	...
}

Should ice_set_channels() likewise acquire pf->adev_mutex before testing
pf->cdev_info->adev?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019065301.3983=
537-1-poros@redhat.com?part=3D2
