Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792753132;
	b=s2hY4ZzR6y+/3m5CuYwJiLUBYV1BOMnKglnOzTogaod8F5m3CQlgbleWXRS0+EYuLXVZ
	 URvBSfcp1uhm6zIZmdhSz9mwTc9ppAaYhXuBkcMxIPpfdQbK+7U+4kXWEiiBJZ7/bAXjm
	 BUd/ft6Pv+gO62wXiktf3eT1IuiWyAAphHwR1UKmojC5/hgMc3BGDiGhvaAyK4SDQMTuf
	 m3/Ul/2Q4n8BkOpvZtmtKjOBduCqCChleYzUvH5JTsPUPx3Cz9TmaF7xEKAQC1NzElAL7
	 CXtiNvUXQxY5h0Fha/pfrnMAXqCXehzAZCD61wr8GzhdkwfyZpLVI/opu5AIVC/e9UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792753132;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=lZ/4nUFep4abOULz0lcE1TEgkLFmeIk2eeOi3FRPg9g=;
	b=oSQiXCqBJH8/c0QZlZIeoU9UpduTtdCJQfGWqcFJUJXzdxRN58xQDPeQXWXkp1Pmh1dL
	 oenBEOpuZ+xiJ3lGl58Ks+pu1u62Uxvrn9ieR55poT0ZghUd4NxNDoq61HjTPnsuWFKAt
	 zJjHXxCJCBwOwQLlH/zMAuXwRx5NySwNST3HSdR9xvTnIkOwyObwYnLqs6nP1DDdaoqRt
	 eLGxKS8uxvW52y1jE76M4tQmSKU8tcoROtl3tloKyS9yjIapEXjpnf5KgkqQu8GrLHL0N
	 zYakmVFD8LBVsYt6N0qjDzEaLuTbjjrFCeh8kJ6MHwaLTI13NER69ewiaN8ZYarUSwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HBXOkpOF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D269606A31B;
	Fri, 23 Oct 2026 10:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HBXOkpOF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1711F01829;
	Fri, 23 Oct 2026 10:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792753132;
	bh=lZ/4nUFep4abOULz0lcE1TEgkLFmeIk2eeOi3FRPg9g=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=HBXOkpOFLxOtgpggSPanv4LjH3XTFSXCs8iCUq6NMXSFblbB2wzBrkmgo0fPqj1cw
	 K9HNS8ly7GWcMyjKHwg1r3zPZjcNO2hqr6w31XtK3EGDm9dR+spDF1iqG1HDxlnT3Z
	 RuZNex+gezvyf0rJluJSpPUc1Nj0nlOnf9nwwQjgR5aosCBCXa9ZLCXw+n6t0UhW+f
	 WI0IhUfPwMVKMkmABNrdl9OcEYSWbEmPKZoQt2hBzn+TENM3pW50RUUq4++B5fxegW
	 v1sL2z9MwtxI4GaKVL2QHR2wfz+CMQujPky4Ui+MpE2qWsjcd39Hcb6vpuVS6NzzEc
	 pJ+Co6AfxdCMw==
Subject:
 Re: [PATCH net] net/mlx5: Use only loaded devices for PTP clock operations
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cjubran@nvidia.com, cratiu@nvidia.com, gal@nvidia.com, kees@kernel.org,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 markb@mellanox.com, mbloch@nvidia.com, moshe@mellanox.com, phaddad@nvidia.com,
 richardcochran@gmail.com, saeedm@mellanox.com, saeedm@nvidia.com,
 shshitrit@nvidia.com, tglx@kernel.org
Date: Fri, 23 Oct 2026 10:58:50 +0000
Message-ID: <179275313029.3134.3941989506677148178@kernel.org>
In-Reply-To: <20261021105600.3481485-1-tariqt@nvidia.com>
References: <20261021105600.3481485-1-tariqt@nvidia.com>
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The commit message leaves out a large change in how the PHC
  keeps time.
- [Medium] The patch makes mlx5_ptp_getcyclesx() (and
  mlx5_ptp_gettimex(), used as the getcyclesx64 fallback when cycles are…

--

net/mlx5: Use only loaded devices for PTP clock operations

This patch serializes PTP clock hardware access with the clock mutex for
all clocks, not only shared ones. PTP callbacks now return -EAGAIN when no
loaded function backs the clock. It also ties the PTP overflow worker to
mlx5_clock_load()/mlx5_clock_unload() and uses the devcom lock to
synchronize with peer loads and unloads.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
> index 5df786133e4bc..c3e53d219496f 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c

[ ... ]

> @@ -580,14 +616,20 @@ static int mlx5_ptp_getcyclesx(struct ptp_clock_info *ptp,
>  						ptp_info);
>  	struct mlx5_core_dev *mdev;
>  	u64 cycles;
> +	int err = 0;
>  
>  	mlx5_clock_lock(clock);
> -	mdev = mlx5_clock_mdev_get(clock);
> +	mdev = mlx5_clock_active_mdev_get(clock);
> +	if (!mdev) {
> +		err = -EAGAIN;
> +		goto unlock;
> +	}

[Severity: Medium]
Can this corrupt PTP virtual clocks built on top of the mlx5 PHC?

When expose_cycles is set, mlx5_init_timer_clock() installs
mlx5_ptp_getcyclesx as getcyclesx64. Otherwise ptp_getcycles64() falls
back to gettime64, which is mlx5_ptp_gettimex(), and that also returns
-EAGAIN now.

ptp_vclock_read() in drivers/ptp/ptp_vclock.c ignores the return value:

	struct timespec64 ts = {};

	ptp->info->getcycles64(ptp->info, &ts);

	return timespec64_to_ns(&ts);

So while the function is unloaded, the cycle sample becomes 0.

mlx5_clock_unload() only cancels the physical clock's worker, through
ptp_cancel_worker_sync(clock->ptp). The vclock's own worker keeps
running. ptp_vclock_register() schedules it with
PTP_VCLOCK_REFRESH_INTERVAL (HZ * 2):

ptp_vclock_refresh()
  ptp_vclock_gettime()
    timecounter_read()
      timecounter_read_delta()
        ptp_vclock_read()    /* returns 0 */

timecounter_read_delta() then adds (0 - cycle_last) & mask to
vclock->tc.nsec and sets cycle_last to 0. Once the function is loaded
again, the next sample adds (real - 0) & mask. With the 32-bit vclock
mask, the two partial deltas can add up to the real delta plus 2^32, so
the vclock may jump forward by about 4.3 seconds.

Before this patch, mlx5_ptp_getcyclesx() always read
dev->iseg->internal_timer. The iseg stays mapped across
mlx5_unload()/mlx5_load() and is only unmapped in mlx5_pci_close(). So
these reads returned valid values during a devlink reload or recovery
window.

The missing error check in ptp_vclock_read() is an older weakness in the
ptp core. The new -EAGAIN return here is what makes it reachable.

Should ptp_vclock_read() handle the error? Or should the mlx5 getcycles
path keep returning valid cycles from the still-mapped iseg?

>  
>  	cycles = mlx5_read_time(mdev, sts, false);
>  	*ts = ns_to_timespec64(cycles);
> +unlock:
>  	mlx5_clock_unlock(clock);
> -	return 0;
> +	return err;
>  }

[ ... ]

> @@ -1554,18 +1646,32 @@ void mlx5_clock_load(struct mlx5_core_dev *mdev)

[ ... ]

> +	start = !cpriv->mdev->clock_state->loaded;
> +	mdev->clock_state->loaded = true;
> +	if (start) {
> +		struct mlx5_timer *timer = &clock->timer;
> +		u64 ns;
> +
> +		cpriv->mdev = mdev;
> +		if (mlx5_real_time_mode(mdev))
> +			ns = mlx5_read_time(mdev, NULL, true);
> +		else
> +			ns = timer->saved_phc_ns +
> +			     ktime_get_boottime_ns() - timer->saved_boot_ns;
> +
> +		mlx5_set_timecounter(mdev, ns);

[Severity: Medium]
The commit message says:

    To fix that, serialize clock hardware access with the clock mutex for
    all clocks and fail callbacks with -EAGAIN when there is no loaded
    function to service the clock. Additionally, tie the worker's lifetime
    to load/unload and use the devcom lock to synchronize with peer
    loads/unloads.

Should it also describe the change in how the PHC keeps time across
unload/load?

Before this patch, mlx5_init_timer_clock() set up the timecounter once,
and it carried over unload/load unchanged. mlx5_clock_load() only
registered the notifier and re-armed PPS.

With this patch, the first load re-bases the timecounter through
mlx5_set_timecounter()->timecounter_init(). In real-time mode the value
comes from the HW real-time register. In free-running mode it is
extrapolated from the saved_phc_ns/saved_boot_ns pair shown above.

The commit message does not mention these related changes either:

  - mlx5_update_clock_info_page() now calls mlx5_timer_snapshot() on every
    update. This stores tc.nsec and CLOCK_BOOTTIME in the new
    saved_phc_ns and saved_boot_ns fields of struct mlx5_timer.

  - mlx5_ptp_adjtime() now calls timecounter_read() before
    timecounter_adjtime(). This changes the cycle_last/nsec values
    published in the RDMA clock_info page.

  - mlx5_clock_unload() now calls timecounter_read() through
    mlx5_save_timecounter().

As a result, the PHC value and the clock_info cycle_last/nsec pair are
re-based after every devlink reload, health recovery and suspend/resume.
While no function is loaded, a free-running PHC also advances at the
CLOCK_BOOTTIME rate rather than its adjfine'd rate.

This looks necessary because the overflow worker is now cancelled while
unloaded, so the 41-bit counter could wrap without being observed.

Could the commit message describe this change in time behavior and the
reason for it? This matters more because the Fixes: tag will bring the
patch into stable.

>  		mlx5_clock_arm_pps_in_event(clock, mdev, cpriv->event_mdev);
> +	}
>  	mlx5_clock_unlock(clock);

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261021105600.3481485-1-tariqt%40nvidia.com
