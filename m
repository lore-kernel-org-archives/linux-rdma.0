Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794325532;
	b=5beXgqoswThpauSRQszXageVkNN/8s5iyqM/Dmr2hCeVOguHPp8gAzqr5aVWsHAv2kZn
	 1ybc4hTYjcHCIbIBeqUK3nd49EphnSi2lbdJRdd/XJB6P4HN/Y3kXtDWngeB1zMscy7Zc
	 xVsTkZWuTRXi6pPSVHx4DbSWlqeXw9FATPRU6ocW8ZW46DJyqfFEPE0NjyETdTo1IgoUA
	 gbInVNFW7qLqSiXAilq7J4gjwQ7xnOUEjIiN8Lzx9Nj3FXphbgDvxnrFPU8Q2E6nmjR7F
	 lAMvsxYXr82gXJSPMyk22yl/QxZ+MR/XPBJakFCGcdxsenSyCg8bgnj1KnCFlqEFSnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794325532;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Zi6WCbs8dDpk4wSHpXkNFzq/USs9PEONAl6YpI0LRU4=;
	b=O/cTU/DZtJxZXlrq35cGkjcWQVFGulaOf2LZFcFzJSeUFejV0eimaX5dg8sTfgG9wLl5
	 GYhAv/DWxtCqaGoC4rHp43yPNtOXCNa0+3DWm3hF72C++wrU7RIVX/FnWGSRmfYZrX3gX
	 6bw0kL6p0XXe1fPtl6kjZf7GxZ7dtbZKKXMUKchP5zw+pVjpzWYy9UsIfSBZ9UruzMwPk
	 KYSnSEFTyxdJ+xYlXmAtnX1aRSPsJrqqWNO+pIC6R39cf34cTqxpgj0kFUg99nreUCKDS
	 o1VnH8jfIwOvJQMt+lnNtBfNH95UMIigXzSklon3IpWI1IfHecPgmwIetZ7Y65H74CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M3CAhHm4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74920606C439;
	Tue, 10 Nov 2026 15:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M3CAhHm4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C151F008A2;
	Tue, 10 Nov 2026 15:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794325532;
	bh=Zi6WCbs8dDpk4wSHpXkNFzq/USs9PEONAl6YpI0LRU4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M3CAhHm4gmQjLcexSklE32zlBB4jzpGrdmQoJSKZYceyMftotpgsUahbge8JJDX8O
	 T1rAJwXTHr9DV49crZhzAinGx2J0nAb5oZ8HGVnNr/i1rcNIu0yDSv5i91WgRSzDY9
	 rwuneZeDcc2K6lzDsHhEnOFWrlvQn6vjWKoRXhjGI/HUomEWce0x1XQr5Vknx5FO7K
	 LNzbp0jX3iU+UB3y/IgQsOkNUPatA08AByYZ8adXc3KRHRVslUb6ohRFfRMUs7+deb
	 2ZYeiqRCHo6G3Aj7gUb3gvzddYtY5qBJKsciGi0tLzMdT7ilvzd4/MAbkqmp5nA4RN
	 JilEaQi+7x4mA==
Message-ID: <sashiko-outbox-207290@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v10 4/4] net: mana: add dynamic HWC queue depth
 with reinit path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <aa4e08e8bc9a7139778b11875e41921d2d813712.1794208055.git.weh@linux.microsoft.com>
References: <cover.1794208055.git.weh@linux.microsoft.com>
 <aa4e08e8bc9a7139778b11875e41921d2d813712.1794208055.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 15:45:31 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] net: mana: duplicate mana_hwc_teardown_queues() on HWC
  rebuild failure
--

commit 63009cdb17b7f248623a5c752d26416fb4226096
Author: Long Li <longli@microsoft.com>

net: mana: add dynamic HWC queue depth with reinit path

This commit adds dynamic HWC queue depth negotiation by rebuilding the
bootstrap hardware channel when the PF reports a supported queue depth
between 2 and 128, with fallback to fresh bootstrap queues if the rebuild
fails.

Link: https://lore.kernel.org/r/20260908035201.402424-5-longli@microsoft.com
Link: https://lore.kernel.org/r/179196575846.434549.7933818740976196422@ker=
nel.org

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/n=
et/ethernet/microsoft/mana/hw_channel.c
> index 8bc00001d20e5..867f8dd3ea547 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c

[ ... ]

> @@ -1088,16 +1176,11 @@ static void mana_hwc_fence_channel(struct gdma_co=
ntext *gc,
>  		mana_hwc_unpublish_cq(gc, hwc->cq->gdma_cq);
>  }
> =20
> -static bool mana_hwc_release_channel(struct hw_channel_context *hwc)
> +static int mana_hwc_teardown_queues(struct hw_channel_context *hwc)
>  {
>  	struct gdma_context *gc =3D hwc->gdma_dev->gdma_context;
>  	int err;
> =20
> -	mana_hwc_stop_channel(hwc);
> -
> -	/* An unacknowledged destroy leaves the PF's mappings live.  Fence
> -	 * software dispatch, but retain every PF-visible allocation.
> -	 */
>  	err =3D mana_smc_teardown_hwc(&gc->shm_channel, false,
>  				    &hwc->setup_active);
>  	if (err) {
> @@ -1105,28 +1188,26 @@ static bool mana_hwc_release_channel(struct hw_ch=
annel_context *hwc)
>  			"HWC teardown failed: %d, retaining PF-visible resources\n",
>  			err);
>  		mana_hwc_fence_channel(gc, hwc);
> -		mana_hwc_retain_channel(hwc);
> -		return false;
> +		return err;
>  	}
> =20
> -	mana_hwc_clear_cq_table(gc);
> -
> -	/* Fence the EQ before releasing the remaining HWC state. */
> -	if (hwc->cq)
> -		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
> -
> -	if (hwc->txq)
> -		mana_hwc_destroy_wq(hwc, hwc->txq);
> +	mana_hwc_destroy_queues(hwc);
> =20
> -	if (hwc->rxq)
> -		mana_hwc_destroy_wq(hwc, hwc->rxq);
> +	return 0;
> +}
> =20
> -	kfree(hwc->caller_ctx);
> -	hwc->caller_ctx =3D NULL;
> +static bool mana_hwc_release_channel(struct hw_channel_context *hwc)
> +{
> +	struct gdma_context *gc =3D hwc->gdma_dev->gdma_context;
> +	int err;
> =20
> -	mana_gd_free_res_map(&hwc->inflight_msg_res);
> +	mana_hwc_stop_channel(hwc);
> =20
> -	hwc->num_inflight_msg =3D 0;
> +	err =3D mana_hwc_teardown_queues(hwc);
> +	if (err) {
> +		mana_hwc_retain_channel(hwc);
> +		return false;
> +	}

[ ... ]

> +static int mana_hwc_rebuild_channel(struct hw_channel_context *hwc,
> +				    u16 q_depth,
> +				    struct mana_hwc_init_report *report)
> +{
> +	u32 timeout_ms =3D mana_hwc_timeout_read(hwc);
> +	int cleanup_err;
> +	int err;
> +
> +	err =3D mana_hwc_teardown_queues(hwc);
> +	if (err)
> +		return err;
> +
> +	err =3D mana_hwc_build_channel(hwc, q_depth, report);
> +	if (!err)
> +		err =3D mana_hwc_validate_report(hwc, report, q_depth,
> +					       true, true);
> +	if (!err)
> +		err =3D mana_hwc_finish_channel(hwc, report);
> +	if (!err)
> +		return 0;
> +
> +	dev_warn(hwc->dev,
> +		 "HWC depth %u rebuild failed, restoring bootstrap: %d\n",
> +		 q_depth, err);
> +
> +	cleanup_err =3D mana_hwc_teardown_queues(hwc);
> +	if (cleanup_err)
> +		return cleanup_err;

[ ... ]

> @@ -1234,7 +1452,7 @@ int mana_hwc_create_channel(struct gdma_context *gc)
>  	gd->pdid =3D INVALID_PDID;
>  	gd->doorbell =3D INVALID_DOORBELL;
> =20
> -	err =3D mana_hwc_create_bootstrap_channel(hwc);
> +	err =3D mana_hwc_prepare_channel(hwc);
>  	if (err) {
>  		mana_hwc_release_channel(hwc);
>  		return err;

[Severity: Medium]
Does mana_hwc_release_channel() issue a duplicate mana_hwc_teardown_queues()
when mana_hwc_rebuild_channel() fails inside mana_hwc_teardown_queues()?

mana_smc_teardown_hwc_locked() only clears hwc->setup_active when the SMC
teardown transaction succeeds.  If mana_hwc_teardown_queues() fails in
mana_hwc_rebuild_channel(), it fences the channel and returns the error with
hwc->setup_active still true, and the error path in mana_hwc_create_channel=
()
then calls mana_hwc_release_channel() -> mana_hwc_teardown_queues() a second
time on the same channel.  On an unresponsive shared-memory channel this
stalls for a second 20-40s poll timeout; if the PF completes the first
SMC_MSG_TYPE_DESTROY_HWC right after the first read times out and rejects t=
he
second destroy with a status error, mana_hwc_release_channel() retains the
already-destroyed channel.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1794208055.gi=
t.weh@linux.microsoft.com?part=3D4
