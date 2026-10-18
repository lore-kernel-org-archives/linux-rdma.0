Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4133F12EB;
	Sun, 18 Oct 2026 19:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792352494; cv=none; b=ZNbOmwALjMNwOuuNNTmIyIU7yEjIQuA9K5zPTDzqVSpsjexX1OAwOy3/mLoES3q1O2BMTiLHv18XI37l+YVZO7/Hiuo/TkIGr9qNXe7fhcS4ZgjQHZw5Zku2hmPdDOP3+ltuaTc4vTcT1JpPAoCgjXEv5V42Bqg83omFdqfDiG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792352494; c=relaxed/simple;
	bh=QOS9qehBLDG0nNsemc7O/SDV/AphexsQO3Xo7I6UicM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Sx1HyzyR6AzMryY2uB53jFwq1Gj4C8zDsTBmzWyn+q/Ld9CvwJB5douaQzRsUHMTnbHJjFo4NlbsAMg/WZVyf3TZqLQX1gLdrXVQkSjaiRWPQHqh4h3oQtbEYFY6FcNHnNyIhF2hrbC/U/2gbUGk9emoMaqjqltf3bq6uA0YrOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QuXb1XGO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QuXb1XGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706DC1F000C4;
	Sun, 18 Oct 2026 19:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792352493;
	bh=CDvBfxAFQEqTyH9qMRpRLe7CJ9PkduG+Ui+RwfZJI+M=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=QuXb1XGOgJMTKhpNUGye08eF5lX3lhif9R1hm0QyJeF9JKuRe5lOcth7TnO2NxqFo
	 +dHn9Nzx82qiyaeZ1d1cpkiIFoHvO29G6Q/J3NGEc2J6Huk/oYf5eLgYKlfyHRATye
	 BxCFDvyIszPmMLNj0wnX7X17MNH65v1LaXR6GLGoxjItPECEcqa/WKBR1O7/AQW3LQ
	 Bgf1+Xoj4/zwphYvKwjiwpJXS0ZF+qaYDn9SSEofbEXh++QF2aAsk6dhp06Ue9IbGO
	 uSdC+U5xjoIJZzc+5NwoABlS9LdnwCJDtHWb1rsgm5spk4q5xsQEuNf5PIgSlw8uMp
	 n4xAgtLf088aw==
Subject: Re: [PATCH v1] net/mlx5: Use generic power management
From: netdev-bot+sashiko@kernel.org
To: vaibhavgupta40@gmail.com
Cc: helgaas@kernel.org, bhelgaas@google.com, bjorn@helgaas.com,
 saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 18 Oct 2026 19:41:31 +0000
Message-ID: <179235249198.3135.3606400485703838782@kernel.org>
In-Reply-To: <20261017194104.2684-1-vaibhavgupta40@gmail.com>
References: <20261017194104.2684-1-vaibhavgupta40@gmail.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] After this patch, the PCI core puts the mlx5 function into
  D3hot/D3cold in pci_pm_suspend_noirq() once mlx5_suspend() returns.

--

net/mlx5: Use generic power management

This patch moves mlx5_core from the legacy pci_driver suspend and resume
hooks to dev_pm_ops. It converts mlx5_suspend() and mlx5_resume() to take
a struct device and registers them with DEFINE_SIMPLE_DEV_PM_OPS() and
pm_sleep_ptr().

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> index 5f28d906c35b6..d8dba3328bb6a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c

[ ... ]

> @@ -2281,8 +2285,7 @@ static struct pci_driver mlx5_core_driver = {
>  	.id_table       = mlx5_core_pci_table,
>  	.probe          = probe_one,
>  	.remove         = remove_one,
> -	.suspend        = mlx5_suspend,
> -	.resume         = mlx5_resume,
> +	.driver.pm      = pm_sleep_ptr(&mlx5_pm_ops),

[Severity: Medium]
With dev_pm_ops in use, the PCI core now calls pci_prepare_to_sleep() from
pci_pm_suspend_noirq() after mlx5_suspend() returns. That puts the function
into D3hot or D3cold. The legacy path did not do this.

Can the PTP overflow worker still touch the device after that point? The
suspend path is:

mlx5_suspend()->mlx5_unload_one(dev, true)->mlx5_unload()->mlx5_clock_unload()

mlx5_clock_unload() unregisters the PPS notifier and cancels out_work:

	mlx5_eq_notifier_unregister(mdev, &mdev->clock_state->pps_nb);
	cancel_work_sync(&mdev->clock_state->out_work);

It does not stop the PTP aux worker. That worker is started in
mlx5_init_clock_dev():

	if (clock->ptp)
		ptp_schedule_worker(clock->ptp, 0);

It only stops when ptp_clock_unregister() runs from
mlx5_destroy_clock_dev() on the cleanup_once path, and suspend never takes
that path. The worker runs on a kthread worker from kthread_run_worker(),
which is not freezable.

mlx5_timestamp_overflow() re-arms itself every overflow_period. Its only
guard is:

	if (mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
		goto out;

mlx5_unload_one_devl_locked() leaves dev->state at MLX5_DEVICE_STATE_UP, so
the worker goes on to timecounter_read()->read_internal_timer()->
mlx5_read_time(), which reads BAR0:

	timer_h = ioread32be(real_time ? &dev->iseg->real_time_h :
			     &dev->iseg->internal_timer_h);

In s2idle, timekeeping comes back when s2idle_loop exits. A delayed work
that expired during sleep then fires right away. That can happen before
dpm_resume_noirq() returns mlx5 to D0. It can also happen in the window
between mlx5's suspend_noirq and sleep entry.

Would those reads then reach a function in D3hot, complete as Unsupported
Request and return all-ones? They may also log AER errors.

If so, timecounter_read() would take the all-ones value (masked by
cc->mask) as a real counter value. It would move tc->nsec and cycle_last
forward, and mlx5_update_clock_info_page() would publish the bad values to
the clock_info page that RDMA userspace maps.

Nothing on the resume path (mlx5_load()->mlx5_clock_load()) appears to
re-initialize the timecounter.

Should the overflow worker be stopped in the unload path when suspending
(for example with ptp_cancel_worker_sync()) and rescheduled on load?

>  	.shutdown	= shutdown,
>  	.err_handler	= &mlx5_err_handler,
>  	.sriov_configure   = mlx5_core_sriov_configure,

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261017194104.2684-1-vaibhavgupta40%40gmail.com
