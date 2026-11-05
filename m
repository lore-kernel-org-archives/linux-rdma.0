Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894973;
	b=MBi4/oWBrtux7qtXLpj82tSUEO8o1UWgNKtp5Ngi30Q6VLPdy0A2h8c6U5jCfUuioBMp
	 /lvLVhByCCLgJcHUvkDJ8GCpCkb0Mcizra90278pgMVzMQHM4F5VuYnTPeov5DhV60Qyx
	 K3lot8GL3uKfpt/wuFE4ZD8qNJGgauDgZdxFH5hiWizZq5BEG7B23p8qiipsHoj6/U4Tc
	 JOrV3Wkalp4u0bBvhmn7H9TKYh7eZFTxxU7nB04tdM74we1DiYQ4bFiJHXDy+NjoFk+DI
	 sxrOd3QV39x/b/MKSj91bo3hbvDiYchF1U3lzp35FYeF2xI7TfaMgA1mewuKcus43ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894973;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Zg0rwNXZ9yvHWFqFwZyXjHNmEmfkVvFk8FcpQdnKUdE=;
	b=wvUjRn28EEybq86yAsEgHwH7SArGgIxWIoZSC9PexFw29YH8zScDs/VEvuB0EbxnoUy/
	 bg2/7g+13vL3NQLn0u0SXrnT7xTpQQg5kjabFsCIF+qUeIFiw8dXA3kD6RfFXCM6WxgQu
	 eq2Rr9ITp659sQwh+F0Rqipm3GgWFiAzYGIXPkdwUibOQgFdm48jOzBcVxfebcbu6A2fr
	 eGJntUJqCSgAhHXRXYoZ6ax50Dv38Cq8YFBMDHWl3Nx4vDwz6Tu8QGCzdX+D3SW+WmKmx
	 NxEj3hr8ODPKMjda3Z7aRHkxJ2HmT/un5FwwN5NXWOfU0bMLJvirMgL3QFYlVpCVEkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fCCpE9Pq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA88606BE84
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 16:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fCCpE9Pq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1141F000C1;
	Thu,  5 Nov 2026 16:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894973;
	bh=Zg0rwNXZ9yvHWFqFwZyXjHNmEmfkVvFk8FcpQdnKUdE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fCCpE9PqjU0AYAvIW5l9XpqGG57l20MeIf/Q2pzS+67H7B03kN8EP1YxXfoS5uJZD
	 /5DeTPmrLDg8Py8Ipt2VYRNts+/bK5EYUKmYnP6yMtIheWLDUE6CPzmdumfC8STsBu
	 HNQBiWKSfr4JosrLx6ZPMZdAoQlpZZs0sy8C63x9SSsYO0NBJ5ZqsjqOPFTihN7RJ4
	 MAZn0U4N5tjvt9NsPpmf9dTXUExWb9vk7ovBlgjWy5CAYD5xrhINxvs11TvBkX/42c
	 mrRnjBf1FregN+I/dJAbyFxlHL8aks6vQYCpgBhCuytmKowjrxn+d1smRHMP1CHbIg
	 PERRxj1fQs/DQ==
Message-ID: <sashiko-outbox-199427@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 05/15] net/xsc: add event queues, interrupts and the
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104155701.37053-6-tianx@yunsilicon.com>
References: <20261104155650.37053-1-tianx@yunsilicon.com>
 <20261104155701.37053-6-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 16:09:32 +0000
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
- [High] net/xsc: deadlock in xsc_cmd_use_polling() if xsc_cmd_enable_msix(=
) times out
- [Low] net/xsc: missing select AUXILIARY_BUS in Kconfig for xsc_adev_add()
--

commit bbb498d789473438951b00cc57ce44b8544a92ad
Author: Xin Tian <tianx@yunsilicon.com>

net/xsc: add event queues, interrupts and the

This commit adds event queue support, MSI-X interrupt allocation and event
dispatch, DMA buffer allocation helpers, and auxiliary bus device registrat=
ion
for the ethernet and RDMA function drivers.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/adev.c b/drivers/net=
/ethernet/yunsilicon/xsc/pci/adev.c
> new file mode 100644
> index 0000000000000..c8e8f1a9ff5e3
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/adev.c
> @@ -0,0 +1,142 @@
[ ... ]
> +int xsc_adev_add(struct xsc_core_device *xdev, int idx)
> +{
[ ... ]
> +	ret =3D auxiliary_device_init(adev);
> +	if (ret) {
> +		kfree(xsc_adev);
> +		return ret;
> +	}
> +
> +	ret =3D auxiliary_device_add(adev);

[Severity: Low]
In drivers/net/ethernet/yunsilicon/xsc/pci/Makefile, adev.o is unconditiona=
lly
linked into xsc_pci.o when CONFIG_YUNSILICON_XSC_PCI is enabled, and
xsc_adev_add() calls auxiliary_device_init() and auxiliary_device_add().

In drivers/net/ethernet/yunsilicon/xsc/pci/Kconfig, YUNSILICON_XSC_PCI only
specifies:

config YUNSILICON_XSC_PCI
	tristate "Yunsilicon XSC PCI driver"
	depends on PCI

Since AUXILIARY_BUS is a hidden symbol without fallback stubs when disabled,
will building with CONFIG_YUNSILICON_XSC_PCI enabled and CONFIG_AUXILIARY_B=
US
unselected fail at link time with undefined references to
auxiliary_device_init() and __auxiliary_device_add()? Should
YUNSILICON_XSC_PCI select AUXILIARY_BUS in Kconfig?

[ ... ]
> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/pci_irq.c b/drivers/=
net/ethernet/yunsilicon/xsc/pci/pci_irq.c
> new file mode 100644
> index 0000000000000..d83f13f38e9b8
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/pci_irq.c
> @@ -0,0 +1,494 @@
[ ... ]
> +int xsc_irq_eq_create(struct xsc_core_device *xdev)
> +{
[ ... ]
> +	xsc_cmd_use_events(xdev);
> +	err =3D xsc_cmd_enable_msix(xdev);
> +	if (err) {
> +		pci_err(xdev->pdev, "xsc_cmd_enable_msix failed %d.\n", err);
> +		xsc_cmd_use_polling(xdev);
> +		goto err_clear_hints;
> +	}

[Severity: High]
Can this sequence deadlock in xsc_cmd_use_polling() if xsc_cmd_enable_msix()
times out?

In xsc_irq_eq_create(), xsc_cmd_use_events() stops the command CQ polling
kthread (cmd->cq_task) and switches cmd->mode to XSC_CMD_MODE_EVENTS before
xsc_cmd_enable_msix() issues XSC_CMD_OP_ENABLE_MSIX to the firmware.

When xsc_cmd_enable_msix() calls xsc_cmd_exec() -> _xsc_cmd_exec() ->
xsc_cmd_invoke(), cmd_work_handler() acquires one permit of cmd->sem via
down(&cmd->sem). Because polling is already stopped and MSI-X is not yet
enabled in firmware (or if MSI-X delivery fails), no completion interrupt m=
ay
arrive on cmd->irqn. When xsc_wait_func() times out, xsc_cmd_invoke() leaves
the cmd->sem permit held for the completion handler:

drivers/net/ethernet/yunsilicon/xsc/pci/cmdq.c:xsc_cmd_invoke() {
	...
	err =3D xsc_wait_func(xdev, ent);
	if (err =3D=3D -ETIMEDOUT)
		/* leave the entry for the completion handler; the driver
		 * is marked timed out and rejects all further commands
		 */
		return err;
	...
}

The error path in xsc_irq_eq_create() then calls xsc_cmd_use_polling(), whi=
ch
disables cmd->irqn and waits to acquire all cmd->max_reg_cmds permits of
cmd->sem before recreating cmd->cq_task:

drivers/net/ethernet/yunsilicon/xsc/pci/cmdq.c:xsc_cmd_use_polling() {
	...
	flush_workqueue(cmd->wq);

	disable_irq(cmd->irqn);

	for (i =3D 0; i < cmd->max_reg_cmds; i++)
		down(&cmd->sem);
	...
}

With one permit still held by the timed-out command and both the IRQ disabl=
ed
and the polling kthread stopped, wouldn't down(&cmd->sem) block forever? Sh=
ould
xsc_cmd_enable_msix() be called while the command interface is still in
polling mode before switching to events with xsc_cmd_use_events()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104155650.3705=
3-1-tianx@yunsilicon.com?part=3D5
