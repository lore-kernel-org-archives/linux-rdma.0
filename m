Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795395598;
	b=4Kphq0kiJBVVfOdd3ktRmGzaMB4aKQTkDx0kJVVs/QFVkbUQX8T5LMu8qwzLxdG6cxLH
	 Tk+kB8SuKkdWMnCs3D+jykW8+HIAQnVPwNIz/QTkneHUGvIl6+XyRQyBhbyQao7wMyvHY
	 1/SWNmYdRBTCAa7MB02Ri/0AiSO6oiYyUqP7ahjXeNuwHhp9fLPWp8VZY5wAFkiehCUjM
	 EZtuizw4O2hH5vp+9UhE+6j/czwz+01c87mrrQmdC38J9jC9IJCBofuQK0YgzZBgKKOtl
	 szq8xn+TkI0pT3gTrArfgRvroZCzXbXGuAd2LvnVIF9xTOT1R1LRmejmE99Y+hrE/UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795395598;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=qTxce4dhFrzTlXqQZV4d0/BQMYVrWdfgLn8c+4Vl3nU=;
	b=WkOIoDynRo7vluTjiIHS+0jIwvYeBlfAcpLQ1sXefumB1UO+K4tAqNXrKyFL6gAVk+2u
	 U0i/mEMlGsdPf8KoaPJ/ta9qwHWqdVvDEfbJpzMXQobCa3AL9ccnckOjwPBlGbvwWJ6OS
	 PPdLDPrJVTLuAHzEw0KT2Evl66fQnk8EutdV1R4+NaUvvg4+9DjpxAVcNLEENtCz0hLPx
	 dF33c62//M4TuB/kf0KKqTvLXVfSFrSIZR9b1aOoB0PgvEWB8jZvRwRva2skVK/ArCMWE
	 T4d03QMDKbo8DFAOSmIDQrVIZdrDDcAa3+30uPbCGzQN42nD8NXffDufhPqVt4C7OaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KmTnxCTq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADB0606A681;
	Mon, 23 Nov 2026 00:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KmTnxCTq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248E21F000D3;
	Mon, 23 Nov 2026 00:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795395598;
	bh=qTxce4dhFrzTlXqQZV4d0/BQMYVrWdfgLn8c+4Vl3nU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=KmTnxCTqxKsJd88PcN9Awqo3gQBgjz/elGW6aR7vMeLFZiEh8c/b3Y+VzhLZfPxTQ
	 PzmVLUgfRmYW/oy68Zi+pIDjMdtMoJ8r4U88lMLf1uQdT4CJ6uT3s7psK2S80fwZ6u
	 ZODpWk/h2+Scdh3BH42pO5PE9Sp1NCgmeTmATGReJxRoIowI/ZKsby2pqsRnpbHubb
	 d0Aftyau5E0b+uGow5M0wRAtG9R2SsjYEzOFqGDQHbIXLLprJ+atbFXWGxB87ZPMV/
	 0yf7rJueSkJhhXb++obdqXRb6IcU7+ZL7bif1LRsainm/kI7Iq51HWKeLRjeVWldfs
	 Ogx8tDttaVmRA==
Subject:
 Re: [PATCH net-next v3 3/3] ionic: add devlink param for command timeout
From: netdev-bot+sashiko@kernel.org
To: nikhil.rao@amd.com
Cc: brett.creeley@amd.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 abhijit.gangurde@amd.com, allen.hubbe@amd.com, jgg@ziepe.ca, leon@kernel.org,
 jiri@resnulli.us, horms@kernel.org, corbet@lwn.net, skhan@linuxfoundation.org,
 rdunlap@infradead.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-doc@vger.kernel.org, eric.joyner@amd.com,
 ArunKumar.Prakash@amd.com
Date: Mon, 23 Nov 2026 00:59:56 +0000
Message-ID: <179539559673.3135.12079878343644861835@kernel.org>
In-Reply-To: <20261119-b4-ionic-cmd-timeout-v3-3-2cdb8fca15fd@amd.com>
References: <20261119-b4-ionic-cmd-timeout-v3-3-2cdb8fca15fd@amd.com>
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] If the firmware advertises IONIC_DEV_CAP_CMD_TIMEOUT but the
  IONIC_DEV_ATTR_CMD_TIMEOUT GETATTR fails, ionic_update_cmd_timeout()…
- [Medium] ionic_dl_cmd_timeout_set()
  (drivers/net/ethernet/pensando/ionic/ionic_devlink.c) checks…
- [Low] ionic_set_cmd_timeout()
  (drivers/net/ethernet/pensando/ionic/ionic_dev.c) sends the SETATTR…

--

ionic: add devlink param for command timeout

This adds a permanent devlink parameter, cmd_timeout (u8, seconds), to
ionic. It is stored in device NVM through a new device attribute and is
only offered when the firmware advertises IONIC_DEV_CAP_CMD_TIMEOUT. A
non-zero value replaces the device command and admin queue timeouts and
the heartbeat interval at the next probe or reset.

> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
> index f14fff4a74278..8e8f7d8d174e1 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c

[ ... ]

> @@ -689,6 +690,62 @@ void ionic_dev_cmd_reset(struct ionic_dev *idev)
>  	ionic_dev_cmd_go(idev, &cmd);
>  }
>  
> +void ionic_update_cmd_timeout(struct ionic *ionic)
> +{
> +	union ionic_dev_cmd_comp comp = {};
> +	union ionic_dev_cmd cmd = {
> +		.getattr.opcode = IONIC_CMD_GETATTR,
> +		.getattr.attr = IONIC_DEV_ATTR_CMD_TIMEOUT,
> +	};
> +	u8 timeout = IONIC_CMD_TIMEOUT_DEF;
> +	int err;
> +
> +	mutex_lock(&ionic->dev_cmd_lock);
> +	if (!ionic_cmd_timeout_supported(ionic)) {
> +		WRITE_ONCE(ionic->cmd_timeout, timeout);
> +		WRITE_ONCE(ionic->cmd_timeout_param, -EOPNOTSUPP);
> +		goto out;
> +	}
> +
> +	ionic_dev_cmd_go(&ionic->idev, &cmd);
> +	err = ionic_dev_cmd_wait_nomsg(ionic, ionic->cmd_timeout);
> +	if (err) {
> +		dev_warn(ionic->dev, "Cannot get cmd_timeout: %d, keeping %u\n",
> +			 err, ionic->cmd_timeout);
> +		goto out;
> +	}

[Severity: Medium]
What happens to cmd_timeout_param if the firmware advertises
IONIC_DEV_CAP_CMD_TIMEOUT but this GETATTR fails? It could fail with
-ETIMEDOUT after the 5 second default wait, with -ENXIO when the firmware
is down, or with a firmware error status.

At probe time, ionic_probe() has just done this:

	ionic->cmd_timeout_param = -EOPNOTSUPP;

The goto out leaves that value in place. Both devlink callbacks then treat
the negative value as "unsupported":

ionic_dl_cmd_timeout_get()
	val = READ_ONCE(ionic->cmd_timeout_param);
	if (val < 0)
		return val;

ionic_dl_cmd_timeout_validate()
	cur = READ_ONCE(ionic->cmd_timeout_param);
	if (cur < 0)
		return cur;

As a result, a devlink param dump silently skips the parameter, a single
get reports "not supported", and validate rejects every set before
ionic_dl_cmd_timeout_set() is reached.

Doesn't that leave the user unable to see or raise cmd_timeout until the
next FW-up or PCI reset? That would happen on exactly the slow-firmware
device this parameter is meant for. The -EOPNOTSUPP also hides the fact
that the query itself failed.

On the fw_up path, after an earlier query succeeded, the same failure
leaves a stale positive value instead. What the user sees then depends on
what happened before.

> +
> +	ionic_dev_cmd_comp(&ionic->idev, &comp);
> +	if (comp.getattr.cmd_timeout >= IONIC_CMD_TIMEOUT_DEF)
> +		timeout = comp.getattr.cmd_timeout;
> +	else if (comp.getattr.cmd_timeout)
> +		dev_warn(ionic->dev, "Ignoring out of range cmd_timeout %u\n",
> +			 comp.getattr.cmd_timeout);
> +	WRITE_ONCE(ionic->cmd_timeout, timeout);
> +	WRITE_ONCE(ionic->cmd_timeout_param, comp.getattr.cmd_timeout);
> +out:
> +	mutex_unlock(&ionic->dev_cmd_lock);
> +}
> +
> +int ionic_set_cmd_timeout(struct ionic *ionic, u8 timeout)
> +{
> +	union ionic_dev_cmd cmd = {
> +		.setattr.opcode = IONIC_CMD_SETATTR,
> +		.setattr.attr = IONIC_DEV_ATTR_CMD_TIMEOUT,
> +		.setattr.cmd_timeout = timeout,
> +	};
> +	int err;
> +
> +	mutex_lock(&ionic->dev_cmd_lock);
> +	ionic_dev_cmd_go(&ionic->idev, &cmd);
> +	err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
> +	if (!err)
> +		WRITE_ONCE(ionic->cmd_timeout_param, timeout);

[Severity: Low]
This SETATTR writes the new value to NVM, but it only waits for the
current ionic->cmd_timeout, which is 5 seconds by default. The commit
message itself says the firmware can be alive but slower than that.

On timeout, __ionic_dev_cmd_wait() clears the command registers and
returns:

	if (!done && !time_before(jiffies, max_wait)) {
		ionic_dev_cmd_clean(ionic);
		...
		return -ETIMEDOUT;
	}

cmd_timeout_param is only updated on success, and nothing reads the
attribute back afterwards.

If the slow firmware still commits the NVM write, would
ionic_dl_cmd_timeout_get() keep reporting the old cached value while the
device holds the new one? The new value would then take effect without
notice at the next probe or reset, when ionic_update_cmd_timeout() reads
it again.

> +	mutex_unlock(&ionic->dev_cmd_lock);
> +
> +	return err;
> +}

[ ... ]

> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> index 4ec66a6be0738..87bf23c3404ff 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c

[ ... ]

> +static int ionic_dl_cmd_timeout_set(struct devlink *dl, u32 id,
> +				    struct devlink_param_gset_ctx *ctx,
> +				    struct netlink_ext_ack *extack)
> +{
> +	struct ionic *ionic = devlink_priv(dl);
> +
> +	if (test_bit(IONIC_LIF_F_FW_RESET, ionic->lif->state))
> +		return -EBUSY;
> +
> +	return ionic_set_cmd_timeout(ionic, ctx->val.vu8);
> +}

[Severity: Medium]
Is this test_bit() enough to keep ionic_set_cmd_timeout() from running
during a PCI reset?

The check takes no lock. ionic_set_cmd_timeout() then holds only
dev_cmd_lock while it uses the dev_cmd registers for up to cmd_timeout
seconds. The FLR/AER path takes neither dev_cmd_lock nor the devlink
instance lock:

ionic_reset_prepare()
	set_bit(IONIC_LIF_F_FW_RESET, lif->state);
	...
	ionic_dev_teardown(ionic);
	ionic_clear_pci(ionic);

ionic_clear_pci()
	ionic->idev.dev_info_regs = NULL;
	ionic->idev.dev_cmd_regs = NULL;
	...
	ionic_unmap_bars(ionic);
	pci_release_regions(ionic->pdev);

So a set that passes the test_bit() can still be polling when the BARs
are unmapped.

The NULL checks in ionic_dev_cmd_go(), ionic_dev_cmd_done() and
__ionic_is_fw_running() are unlocked check-then-use. The EAGAIN retry
branch in __ionic_dev_cmd_wait() has no NULL check at all:

	iowrite32(0, &idev->dev_cmd_regs->done);
	msleep(1000);
	iowrite32(1, &idev->dev_cmd_regs->doorbell);

Could a reset during that msleep() cause a NULL+offset MMIO write, or an
access to unmapped I/O memory?

The missing serialisation between reset teardown and dev_cmd users
predates this patch. The same test_bit(IONIC_LIF_F_FW_RESET) guard is also
used in ionic_set_link_ksettings() and ionic_set_pauseparam(). This patch
adds a new userspace entry point into that race.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261119-b4-ionic-cmd-timeout-v3-0-2cdb8fca15fd%40amd.com
