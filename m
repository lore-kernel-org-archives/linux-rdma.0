Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017689;
	b=JbMtZKF1PomvhlM2z5x9I3Qpydv3qp6vFNNrM1eeO4svbRlfAkoRmt+8A9IOUE+9szDm
	 dK/VJIUjTQNuziyFD5mRzSmPF/9PNYnheKOACqE3WDAV4fRn0PtnBxBFWLiHUsgFmt206
	 jbvs2TRvwdBSWWuJDFZh+3/5Ux4Mc7ZkvPHKrXMNZ8YZebZcJpylfJHIHen/ENk6eGnUr
	 Q81t3QAXkqmVgRadz6+Ifop33F75uAxqWnKd1J/PDE4LBFqGWZ1e5LjQfTivgnVs1bllR
	 VCIdVd0ELK4/vblnNSjJDGf12F0RiXz9F7t4vWwRst5YHGVcZHHjxZtb11CGP0Es+dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017689;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Wwx/oG7I4TlM9QjGqsSHZIP16p2xBizaNmFcnQA2TNo=;
	b=vC+u1jcBxOyHJKqwik17othzRUrLhUXq1RlbOTBEUP4F/IiN5H/S+nUvB2OtI3jLZyw3
	 xHR/Gptd6PRQ3U3stuyTZXWK5ISS3udDS3/LtDU6fatSwzMu1VfgBvXtZ6r6r3J7DXA6v
	 fa+IyzKCoNhiac/vhQEAZ5eQI93jlNvIaLJxymYlkIzPKoMg5iBCCCeD1MxuKYgWenSHf
	 odI8m6UxkIcqA7OXZCfE/yPez0wkrMwzqggeIPX8uVK2j34td/V+qG62ljchY8knQ0NTQ
	 VPdomIu32RGm4RwmY3ut30nGouYoxtkYQ1LWreNudJZpqm0OmCnuMuLM52N82U/1jZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lfCaYZ5Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83255606A32F;
	Wed, 18 Nov 2026 16:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lfCaYZ5Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09B61F000C5;
	Wed, 18 Nov 2026 16:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795017689;
	bh=Wwx/oG7I4TlM9QjGqsSHZIP16p2xBizaNmFcnQA2TNo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lfCaYZ5Z2nH2IIy8WkeAljH2Q0F2lX32LLbZJlZ1VBiwGG/HtFH/J+EgQ+qL9VHLe
	 SNZuBdZRSfg4fVD8DIgaFPZzz+reWUW4uxITBFMelpmMm7Hh55+3sH/NK4jRfv/hK5
	 hsIFoeSOsTZ7NK/3Gft91jhaGa67qbR+68JZnNbSEAQ5gxT91KexObopyiqt/0VqOw
	 NjkOh2k62Cpw26YHgy64I4+JcYLHe0TpsELz4xzzv3vmughSqrWTTwJ0dl3P8bJD+q
	 fB/CYWn9V8bgLenZz6+OjxjC7oCkgRGy5dgwuB9KTzQY1Bwro/nrp4OHUwhrtvXDZD
	 NsTfcZiqnIBZA==
Message-ID: <sashiko-outbox-221403@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v11 4/4] net: mana: add dynamic HWC queue depth
 with reinit path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <100c6b7a71e86c8d7afd0c55f6b231f01db184d5.1794751992.git.weh@linux.microsoft.com>
References: <cover.1794751992.git.weh@linux.microsoft.com>
 <100c6b7a71e86c8d7afd0c55f6b231f01db184d5.1794751992.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 16:01:28 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] net: mana: swapped HWC request/response limits in
  mana_hwc_finish_channel()
- [Medium] net: mana: duplicate mana_hwc_teardown_queues() on HWC
  rebuild failure
--

commit 3fabf9cbfe8a174f5953b462e57e3b1f0fcf54f1
Author: Long Li <longli@microsoft.com>

net: mana: add dynamic HWC queue depth with reinit path

This commit adds support for dynamically rebuilding the MANA hardware
channel queues to the PF-reported queue depth (up to 128), validating
reported message size limits and doorbells, and falling back to bootstrap
queues if rebuilding fails.

Link: https://lore.kernel.org/r/20260908035201.402424-5-longli@microsoft.com
Link: https://lore.kernel.org/r/179196575846.434549.7933818740976196422@ker=
nel.org
Link: https://lore.kernel.org/r/179455240227.2199510.2666165032389090040@ke=
rnel.org

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/n=
et/ethernet/microsoft/mana/hw_channel.c
> index 8c2495ce5f526..cb73d0725206e 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c

[ ... ]

> @@ -1175,32 +1256,169 @@ void mana_hwc_free_retained_channel(struct gdma_=
context *gc)
>  	gc->hwc.gdma_context =3D NULL;
>  }
> =20
> -static int mana_hwc_create_bootstrap_channel(struct hw_channel_context *=
hwc)
> +static int
> +mana_hwc_validate_report(struct hw_channel_context *hwc,
> +			 const struct mana_hwc_init_report *report,
> +			 u32 expected_depth, bool check_depth,
> +			 bool require_exact_msg_sizes)
> +{
> +	if (!report->queue_depth || !report->max_req_msg_size ||
> +	    !report->max_resp_msg_size) {
> +		dev_err(hwc->dev,
> +			"HWC: invalid maxima depth=3D%u req=3D%u resp=3D%u\n",
> +			report->queue_depth, report->max_req_msg_size,
> +			report->max_resp_msg_size);
> +		return -EPROTO;
> +	}
> +
> +	if (require_exact_msg_sizes &&
> +	    (report->max_req_msg_size !=3D HW_CHANNEL_MAX_REQUEST_SIZE ||
> +	     report->max_resp_msg_size !=3D HW_CHANNEL_MAX_RESPONSE_SIZE)) {
> +		dev_err(hwc->dev,
> +			"HWC: rebuilt message maxima req=3D%u resp=3D%u, expected %u/%u\n",
> +			report->max_req_msg_size, report->max_resp_msg_size,
> +			HW_CHANNEL_MAX_REQUEST_SIZE,
> +			HW_CHANNEL_MAX_RESPONSE_SIZE);
> +		return -EPROTO;
> +	}
> +
> +	if (check_depth && report->queue_depth !=3D expected_depth) {
> +		dev_err(hwc->dev, "HWC: rebuilt depth %u, expected %u\n",
> +			report->queue_depth, expected_depth);
> +		return -EPROTO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int mana_hwc_finish_channel(struct hw_channel_context *hwc,
> +				   const struct mana_hwc_init_report *report)
> +{
> +	int err;
> +
> +	/* MAX_REQUEST sizes the RQ; MAX_RESPONSE sizes the SQ. */
> +	hwc->rx_msg_size_limit =3D report->max_req_msg_size;
> +	hwc->tx_msg_size_limit =3D report->max_resp_msg_size;

[Severity: Medium]
Are rx_msg_size_limit and tx_msg_size_limit swapped here?

On the HWC, the host sends requests over hwc->txq (GDMA_SQ) in
mana_hwc_send_request() and receives responses over hwc->rxq (GDMA_RQ) in
mana_hwc_rx_event_handler().  Because tx_msg_size_limit is populated from
report->max_resp_msg_size and rx_msg_size_limit from
report->max_req_msg_size, mana_hwc_get_max_req_size() and
mana_hwc_get_msg_index() check outgoing req_len against the PF-reported
response limit and incoming resp_len against the request limit.

When the PF reports asymmetric HWC_INIT_DATA_MAX_REQUEST and
HWC_INIT_DATA_MAX_RESPONSE values (where mana_hwc_prepare_channel() keeps
the bootstrap queues), a smaller MAX_RESPONSE will cause outgoing requests
such as mana_gd_create_dma_region() and mana_ib_gd_create_dma_region() to be
capped or rejected with -EMSGSIZE or -EINVAL against the response limit.

> +
> +	err =3D mana_hwc_test_channel(hwc);
> +	if (err)
> +		dev_err(hwc->dev, "Failed to test HWC: %d\n", err);
> +
> +	return err;
> +}

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

> @@ -1233,7 +1451,7 @@ int mana_hwc_create_channel(struct gdma_context *gc)
>  	gd->pdid =3D INVALID_PDID;
>  	gd->doorbell =3D INVALID_DOORBELL;
> =20
> -	err =3D mana_hwc_create_bootstrap_channel(hwc);
> +	err =3D mana_hwc_prepare_channel(hwc);
>  	if (err) {
>  		mana_hwc_release_channel(hwc);
>  		return err;

[Severity: Medium]
Does failing inside mana_hwc_teardown_queues() during
mana_hwc_rebuild_channel() cause mana_hwc_release_channel() to run
mana_hwc_teardown_queues() a second time on the same active channel?

When mana_smc_teardown_hwc() fails in mana_hwc_teardown_queues(),
hwc->setup_active remains true and the channel is fenced, and that error is
returned through mana_hwc_prepare_channel() to mana_hwc_create_channel().
mana_hwc_release_channel() then calls mana_hwc_teardown_queues() again while
hwc->setup_active is still true, issuing a second SMC teardown transaction
that can stall in mana_smc_poll_register() for another 20 to 40 seconds or
send a duplicate SMC_MSG_TYPE_DESTROY_HWC if the PF completed the first
teardown right after it timed out.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1794751992.gi=
t.weh@linux.microsoft.com?part=3D4
