Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793744915;
	b=sFMPjvhXr7PjzLmZXlaSbYebDv8OHkexac+W1OdIOgUR3j1z05W45mL0zQ4rfoS8zfyg
	 c9a1szlu2433Go/2SM3s/G7ioSTXpCCGB5XD3+kzi1eEkAs4iTIle7aZ7Jjh2f3d3oHjC
	 f7TTpr8iqPhGj40J8X+RcF99LTXdoiM9SkcapL3YBFCizs19ITvdVfn/GcR5g1wYkQMhE
	 cX0F5Fr9+SaShpxmR2A4Fv9Rz390u1UJq/aRENzy6kuab+t4cm/UYVasoLzsEppRbK19O
	 RI+MJ/qrolqy8pty5TWzGaaHOTSlYU3oMklFtiphuZV6tc3p+01aqHb1IJZbAX8uI5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793744915;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=vUhksVllBi0V8Uh+q+pwWDlLitay8yRSWPY52Ne28sw=;
	b=UyYNJcLVPg4LfXFmGCiT23KfrgI6UsILambT28w8PdEbo33EthjvblgRCkPS6Jx/LfH5
	 g8nU7CPI+H6LLs1Sbc0JP5+EWeDKLUJEcV8yXouWu4JJb3gb+EA5A5JIhY7gJiZ5GxARM
	 CpGVa6I9SdTRJnPIXxJy3K4zXNmiZ6lriauTK2DSSL0Ntm0Dxyw5NosAQUwvwbkQW1vqV
	 hEw/mm5tFft9Tn5Q524B55O0Xq92LIBXkw9mUthNoCyaYVH1Tw+6ENEQPoG6NP3xsEM4Q
	 z21KvkGg9SHQYqV8kYnhb20JbazsRytOqKdl793EtBbgjfiKnmDbhC/MAZkadeB6gdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gATZtpYP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C30606A32C
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 22:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gATZtpYP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9731F000C1;
	Tue,  3 Nov 2026 22:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793744914;
	bh=vUhksVllBi0V8Uh+q+pwWDlLitay8yRSWPY52Ne28sw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gATZtpYP92M7oTJ1bIPFzWrd5VbcDotz0bYSMMp/GIbT7wLMa5LVcGnQs4R7Tc8qP
	 CgLNqnOOsdVs/LvooUifAyAWRr0yeowMaD/f4zzHana1UyWU543tyKA/8l7i6Opa4h
	 mbfHMo9Pe3jyiYfw0dLsYYGsUE19wu4nrEYi/KlE4z36agZ184TtlcfFFzePEuf+GF
	 7dOoXOHia/N5BwBzvGWMT4PCcerc+tW9mFUBVTlDygXVAfIG5uFhu0jf5DPtxOQqdU
	 oLuPkKwDzwH3rX7E3bGEawSQyGrp3bGQ3l/z5WAsHsBojtAi1Xo0aYThtBRA03rHzY
	 VM+/2L2cI+qWw==
Message-ID: <sashiko-outbox-196113@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 3/3] ionic: add devlink param for command
 timeout
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nikhil P. Rao" <nikhil.rao@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261102-b4-ionic-cmd-timeout-v1-3-2f75c2d0a0c7@amd.com>
References: <20261102-b4-ionic-cmd-timeout-v1-0-2f75c2d0a0c7@amd.com>
 <20261102-b4-ionic-cmd-timeout-v1-3-2f75c2d0a0c7@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 22:28:34 +0000
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
- [Medium] ionic: hardware getattr issued during reset in ionic_dl_cmd_time=
out_get()
- [Medium] ionic: last_hb_time not back-dated on reset in ionic_lif_handle_=
fw_up()
--

commit 0a0b7719e75bbcb6ea7fc807a50ee80589eafae1
Author: Arun Kumar Prakash <ArunKumar.Prakash@amd.com>

ionic: add devlink param for command timeout

This commit adds a permanent cmd_timeout devlink parameter stored in device
NVM to configure device command, admin queue, and firmware heartbeat check
timeouts on supported firmware.

> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/driver=
s/net/ethernet/pensando/ionic/ionic_devlink.c
> index 4ec66a6be0738..d775fa5bb43d7 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> @@ -51,6 +51,55 @@ static int ionic_dl_info_get(struct devlink *dl, struc=
t devlink_info_req *req,
>  	return err;
>  }
> =20
> +enum ionic_devlink_param_id {
> +	IONIC_DEVLINK_PARAM_ID_BASE =3D DEVLINK_PARAM_GENERIC_ID_MAX,
> +	IONIC_DEVLINK_PARAM_ID_CMD_TIMEOUT,
> +};
> +
> +static int ionic_dl_cmd_timeout_get(struct devlink *dl, u32 id,
> +				    struct devlink_param_gset_ctx *ctx,
> +				    struct netlink_ext_ack *extack)
> +{
> +	struct ionic *ionic =3D devlink_priv(dl);
> +
> +	return ionic_dev_getattr_cmd_timeout(ionic, &ctx->val.vu8);
> +}
> +
> +static int ionic_dl_cmd_timeout_set(struct devlink *dl, u32 id,
> +				    struct devlink_param_gset_ctx *ctx,
> +				    struct netlink_ext_ack *extack)
> +{
> +	struct ionic *ionic =3D devlink_priv(dl);
> +
> +	if (test_bit(IONIC_LIF_F_FW_RESET, ionic->lif->state))
> +		return -EBUSY;
> +
> +	return ionic_dev_setattr_cmd_timeout(ionic, ctx->val.vu8);
> +}

[Severity: Medium]
Unlike ionic_dl_cmd_timeout_set(), ionic_dl_cmd_timeout_get() does not check
IONIC_LIF_F_FW_RESET (or IONIC_LIF_F_FW_STOPPING) before calling
ionic_dev_getattr_cmd_timeout().

During firmware down or PCI reset preparation in ionic_lif_handle_fw_down()
and ionic_reset_prepare() (including when ionic_pci_error_detected() is
called with pci_channel_io_frozen), IONIC_LIF_F_FW_RESET is set and then
ionic_devlink_params_unregister() is called while the devlink instance is
still registered:

ionic_lif_handle_fw_down() / ionic_reset_prepare()
  ionic_devlink_params_unregister()
    devl_params_unregister()
      devlink_param_unregister()
        devlink_param_notify(..., DEVLINK_CMD_PARAM_DEL)
          devlink_nl_param_fill()
            ionic_dl_cmd_timeout_get()
              ionic_dev_getattr_cmd_timeout()

Similarly, ionic_devlink_unregister() calls devlink_unregister() before
ionic_devlink_params_unregister(), which also invokes devlink_nl_param_fill=
()
via devlink_params_notify_unregister().

If a userspace netlink listener is monitoring devlink events, or if a user
queries devlink parameters during the window before the parameter is
unregistered, won't ionic_dl_cmd_timeout_get() issue a synchronous MMIO
IONIC_CMD_GETATTR command while the firmware is down, the device is in
reset, or the PCI channel is frozen, potentially stalling reset recovery for
up to cmd_timeout (255) seconds under devl_lock and dev_cmd_lock?

[ ... ]

> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/ne=
t/ethernet/pensando/ionic/ionic_lif.c
> index b0868ab139dd5..a89f9c72eb39d 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c

[ ... ]

> @@ -3495,6 +3497,7 @@ static void ionic_lif_handle_fw_up(struct ionic_lif=
 *lif)
>  	err =3D ionic_identify(ionic);
>  	if (err)
>  		goto err_out;
> +	ionic_update_cmd_timeout(ionic);
>  	err =3D ionic_port_identify(ionic);
>  	if (err)
>  		goto err_out;

[Severity: Medium]
The commit message notes that idev->last_hb_time is back-dated by the
largest possible interval so that a larger cmd_timeout value does not delay
the first heartbeat sample after probe or reset.

However, ionic_watchdog_init() is only called from ionic_dev_setup() during
initial probe and PCI function reset, and is not called when recovering from
a firmware reset in ionic_lif_handle_fw_up().

When firmware comes back up in ionic_lif_handle_fw_up() and
ionic_update_cmd_timeout() applies a large timeout, idev->last_hb_time still
holds the timestamp from before the firmware reset. In
ionic_heartbeat_check():

	last_check_time =3D idev->last_hb_time;
	if (time_before(check_time,
			last_check_time +
			READ_ONCE(ionic->cmd_timeout) * 2 * HZ))
		return 0;

Could this cause ionic_heartbeat_check() to skip sampling fw_heartbeat for
up to 2 * cmd_timeout (510 seconds) after a firmware reset unless
idev->last_hb_time is also back-dated in ionic_lif_handle_fw_up()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-b4-ionic-c=
md-timeout-v1-0-2f75c2d0a0c7@amd.com?part=3D3
