Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794312902;
	b=pKBnypnQrEV3oJmKqxw4qtF4HPFrQNajK3u75dBmFu47MMW9N+BZFrGx3oX3eNrJBo7m
	 9/EpRgz3KNMZOZs2cgiRHe/VmKCi4BUTa0Vuezyq2/eaex4eZ19TO6YMjS7PIzCN4LfgO
	 PWjXMTIZeqzzsLedFBDy8YFhzwub6ZiqL8th6D1d6FdmK3ZmccgT+WTOcrrwmZ8puzRdu
	 ZBxCI0dXTragiyJDo4SHdr52uD1q72lsdAaIHnFntPhE+LdlTHhCBGRGspVqa1OSe4XwU
	 4QoIm8mpF4+5Qh2St/bXmLK5NRwlAa4TrcNyvONUXmlOzu/Yd+ufh97FrgxtdlR9vCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794312902;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=K+AtYtLXT5CtwyWdEY39KFim4auSE6S4YP6dmETiu/I=;
	b=qemMKlNn7eZqPznHBrkQMGR4UNn4t3uuStzVlmsKPCLuM2RH7LmyKzURqbXIZN+qKleB
	 QcwjCpBEphUs/g3funpFnn0BnWO2YOtq60q8AMNfs6tvRHo3L7hJ96/eUTFaC7I2yNIMb
	 DYIXirZUZFCwOE2BrV3EUXy/5DV0YpxoWIlrvgwFFFqZB1x8phJe6gcDN7wMLS5hTPt3m
	 m537/rnYJUSpnGvLwnpZ4fDvvML0cuWJyYOL14Q8Wlvqf9y8TkhTPwyG0+ZVWBCk6C5od
	 PIHrnqrxo87c/aeJkSMAn1+Sh3HJ99+lB/HgvMVD1S+e0drX78tWRkQSmzMghQLCgVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W2SdmF+p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C6D606A32A;
	Tue, 10 Nov 2026 12:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W2SdmF+p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74D11F008A1;
	Tue, 10 Nov 2026 12:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794312901;
	bh=K+AtYtLXT5CtwyWdEY39KFim4auSE6S4YP6dmETiu/I=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=W2SdmF+p/0CvcB+OrayA3456jeYWT2XsLbJxpjym3PqfxOwi09beeCAJ8pjeNCq1k
	 D2s5SPYWSdCJj7WbTBDXJvbVfhVRm1BVp3j+FRw++LLm+ds0q0YBNJkYPWQLEMrXt3
	 YIo3ZSyFcMQnCneeWnJ3HxxNaHnYW6oUsXdYAVcJ9CZyhyJ4685r9spAX1V8ItBBl1
	 DAS0cagK9ZvpQ8SXv8lK/O88fzGwa/fmOJyug7IEAZS/AMXQAfruvN2YoiCkpfH/Cc
	 4211b3J21NY/7OhNlDkYYyNmFI9kyMpfzU0DE/MWsXQA/djwgRU5WDdUXVmDJab0MX
	 Pxm/N+Nq2zKVw==
Subject:
 Re: [PATCH net-next v2 3/3] ionic: add devlink param for command timeout
From: netdev-bot+sashiko@kernel.org
To: nikhil.rao@amd.com
Cc: brett.creeley@amd.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 abhijit.gangurde@amd.com, allen.hubbe@amd.com, jgg@ziepe.ca, leon@kernel.org,
 jiri@resnulli.us, horms@kernel.org, corbet@lwn.net, skhan@linuxfoundation.org,
 rdunlap@infradead.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-doc@vger.kernel.org, eric.joyner@amd.com,
 ArunKumar.Prakash@amd.com
Date: Tue, 10 Nov 2026 12:14:59 +0000
Message-ID: <179431289941.994134.11663452629837334156@kernel.org>
In-Reply-To: <20261105-b4-ionic-cmd-timeout-v2-3-35a9a2aa48b1@amd.com>
References: <20261105-b4-ionic-cmd-timeout-v2-3-35a9a2aa48b1@amd.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] ionic_dl_cmd_timeout_get() always sends a live
  IONIC_CMD_GETATTR(IONIC_DEV_ATTR_CMD_TIMEOUT) dev command and never…
- [Medium] Any local user can now make the driver send firmware mailbox
  commands.
- [Low] The cmd_timeout devlink parameter is not registered for the whole
  life of the devlink instance, and neither the commit message nor…
- [Low] The patch adds a new lock dependency: the FW-down deferred worker
  (ionic_lif_handle_fw_down) and the PCI reset_prepare/AER…

--

ionic: add devlink param for command timeout

This patch adds a permanent devlink parameter, cmd_timeout. It is stored
in device NVM on firmware that advertises IONIC_DEV_CAP_CMD_TIMEOUT, and a
non-zero value replaces the device command and admin queue timeouts on the
next probe or reset. The parameter is unregistered on FW-down and PCI reset,
and registered again when the LIF restarts.

> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> index 4ec66a6be0738..c9a07a86aa383 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> @@ -51,6 +51,56 @@ static int ionic_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
>  	return err;
>  }
>  
> +enum ionic_devlink_param_id {
> +	IONIC_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
> +	IONIC_DEVLINK_PARAM_ID_CMD_TIMEOUT,
> +};
> +
> +static int ionic_dl_cmd_timeout_get(struct devlink *dl, u32 id,
> +				    struct devlink_param_gset_ctx *ctx,
> +				    struct netlink_ext_ack *extack)
> +{
> +	struct ionic *ionic = devlink_priv(dl);
> +
> +	/* devlink fills PARAM_DEL with this on PCI reset; no FW_RESET check */
> +	return ionic_dev_getattr_cmd_timeout(ionic, &ctx->val.vu8);

[Severity: Medium]
Is the comment above accurate for every caller that reaches this getter
through PARAM_DEL?

When a devlink monitor is listening, the unregister path calls this getter
to fill the notification:

ionic_lif_handle_fw_down()
  ionic_devlink_params_unregister()
    devl_params_unregister()
      devlink_param_unregister()
        devlink_param_notify(DEVLINK_CMD_PARAM_DEL)
          devlink_nl_param_fill()
            devlink_param_get()
              ionic_dl_cmd_timeout_get()
                ionic_dev_getattr_cmd_timeout()

On the watchdog path, ionic_lif_handle_fw_down() only runs after fw_status
has lost IONIC_FW_STS_F_RUNNING. ionic_reset_prepare() is also reached from
ionic_pci_error_detected() for io_frozen, where MMIO reads return 0xff. In
both cases the firmware cannot answer the GETATTR.

__ionic_dev_cmd_wait() then prints the warning and returns -ENXIO. do_msg
does not gate this warning, so the _nomsg variant still prints it:

	if (!done && !fw_up) {
		ionic_dev_cmd_clean(ionic);
		dev_warn(ionic->dev, "DEVCMD %s (%d) interrupted - FW is down\n",
			 ionic_opcode_to_str(opcode), opcode);
		return -ENXIO;
	}

devlink_param_notify() drops the message on that error:

	err = devlink_nl_param_fill(msg, devlink, port_index, param_item, cmd,
				    0, 0, 0, NULL);
	if (err) {
		nlmsg_free(msg);
		return;
	}

So no PARAM_DEL is sent, but ionic_restart_lif() sends PARAM_NEW again on
FW-up. Monitors would see two PARAM_NEW events with no PARAM_DEL between
them, and a spurious warning is logged on every FW-down.

There is also the case where FW-down starts while fw_status still reads
running (a generation change, or IONIC_EVENT_RESET) and the restarted
firmware does not complete the command. Could the getter then block the
deferred FW-down work for up to ionic->cmd_timeout? This patch raises that
limit to as much as 255 seconds.

[Severity: Medium]
Can an unprivileged user use this getter to tie up the device command
mailbox?

In net/devlink/netlink_gen.c, DEVLINK_CMD_PARAM_GET (both the do and the
dump op) has no GENL_ADMIN_PERM; only PARAM_SET does. So every
"devlink dev param show" from any local user ends up in
ionic_dev_getattr_cmd_timeout(), which holds dev_cmd_lock while it waits:

	mutex_lock(&ionic->dev_cmd_lock);
	ionic_dev_cmd_getattr(&ionic->idev, IONIC_DEV_ATTR_CMD_TIMEOUT);

	err = ionic_dev_cmd_wait_nomsg(ionic, ionic->cmd_timeout);

The wait can last up to ionic->cmd_timeout (now up to 255 seconds), with
msleep(1000) retries on IONIC_RC_EAGAIN. Before this patch, ionic
registered no devlink params, and ionic_dl_info_get() only uses cached
data. Devlink gave unprivileged users no path to the dev_cmd mailbox.

With slow firmware, which is the case this patch targets, a loop of gets
could delay identify, port init/reset, VF ops, flash and setattr. All of
these need dev_cmd_lock. It could also delay FW-down recovery, which now
needs devl_lock.

Between the firmware stopping and the watchdog unregistering the param,
each get also prints a dev_warn from __ionic_dev_cmd_wait() that is not
rate-limited ("interrupted - FW is down" or "timeout after N secs").

ionic_update_cmd_timeout() already reads the value at probe and reset.
Could the getter return a cached copy of the stored value, updated on set,
instead of querying the firmware on every call?

[ ... ]

> @@ -74,6 +124,43 @@ void ionic_devlink_free(struct ionic *ionic)
>  	devlink_free(dl);
>  }
>  

[ ... ]

> +void ionic_devlink_params_unregister(struct ionic *ionic)
> +{
> +	struct devlink *dl = priv_to_devlink(ionic);
> +
> +	devl_lock(dl);
> +	if (ionic->dl_params_registered) {
> +		devl_params_unregister(dl, ionic_dl_params,
> +				       ARRAY_SIZE(ionic_dl_params));
> +		ionic->dl_params_registered = false;
> +	}
> +	devl_unlock(dl);
> +}

[Severity: Low]
This adds devl_lock to two paths that did not take it before:

- the FW-down deferred worker in ionic_lif_handle_fw_down();
- ionic_reset_prepare(), which runs under device_lock for FLR and AER.

Is it intended that FW and PCI recovery now wait behind any devlink
operation that holds devl_lock?

For example, devlink flash_update holds devl_lock for all of
ionic_firmware_update(). ionic_fw_status_long_wait() retries on -EAGAIN and
-ETIMEDOUT for up to IONIC_FW_INSTALL_TIMEOUT (25 minutes), and each dev
command inside it can take up to cmd_timeout:

	do {
		mutex_lock(&ionic->dev_cmd_lock);
		ionic_dev_cmd_go(&ionic->idev, &cmd);
		err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
		mutex_unlock(&ionic->dev_cmd_lock);

		msleep(20);
	} while (time_before(jiffies, end_time) && (err == -EAGAIN || err == -ETIMEDOUT));

A param get or set also holds devl_lock while its dev command waits.

While devl_lock is held here, the PARAM_DEL fill also calls
ionic_dl_cmd_timeout_get(). That puts a firmware round trip under
dev_cmd_lock in the middle of teardown.

In ionic_lif_handle_fw_down(), the worker blocks after
netif_device_detach() but before the queues are stopped and before
ionic_reset(). Every other item on lif->deferred (LINK_STATUS, RX_MODE, the
later fw_up) queues behind it.

There does not appear to be an AB-BA deadlock, since no devl_lock holder
waits on deferred.work or device_lock. Recovery can still take longer,
though.

[ ... ]

> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> index b0868ab139dd5..a89f9c72eb39d 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> @@ -3398,6 +3398,7 @@ static void ionic_lif_handle_fw_down(struct ionic_lif *lif)
>  	netif_device_detach(lif->netdev);
>  
>  	ionic_auxbus_unregister(ionic->lif);
> +	ionic_devlink_params_unregister(ionic);
>  	mutex_lock(&lif->queue_lock);
>  	if (test_bit(IONIC_LIF_F_UP, lif->state)) {
>  		dev_info(ionic->dev, "Surprise FW stop, stopping queues\n");
> @@ -3460,6 +3461,7 @@ int ionic_restart_lif(struct ionic_lif *lif)
>  	netif_device_attach(lif->netdev);
>  	ionic_queue_doorbell_check(ionic, IONIC_NAPI_DEADLINE);
>  
> +	ionic_devlink_params_register(ionic);
>  	ionic_auxbus_register(ionic->lif);
>  
>  	return 0;

[Severity: Low]
Two paths unregister the cmd_timeout parameter:

- ionic_lif_handle_fw_down();
- ionic_reset_prepare(), reached on FLR and on AER io_frozen through
  ionic_pci_error_detected().

It is registered again only here, at the success tail of
ionic_restart_lif().

During each FW-down/FW-up or PCI reset cycle, "devlink dev param show" and
"devlink dev param set" for cmd_timeout fail because the parameter is not
found. Monitors also see PARAM_DEL and PARAM_NEW events.

If recovery fails, the parameter stays missing until the next successful
recovery or a driver reload. Recovery can fail on these paths:

- the err_out path of ionic_lif_handle_fw_up(), when ionic_identify(),
  ionic_port_identify(), ionic_port_init() or ionic_restart_lif() fails;
- ionic_reset_done(), when ionic_setup_one() or ionic_restart_lif() fails.

The new documentation only says:

  The value is stored in device NVM and takes effect on the next driver
  probe or device reset. Only available when the device firmware supports
  it.

The design may be reasonable, since the capability can change after a
firmware update. Should the commit message and ionic.rst say that the
parameter is absent while a reset is in progress, and stays absent if
recovery fails?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261105-b4-ionic-cmd-timeout-v2-0-35a9a2aa48b1%40amd.com
