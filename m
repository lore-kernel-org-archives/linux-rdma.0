Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10143537E0;
	Wed,  9 Sep 2026 03:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788925973; cv=none; b=BgvL6VPkE7tJoV1lz/d4ojRsnaA2GMFKMoyMAAzddywMJWHt5yug3HVp4b8DI8iRCXJYl/JO9JznvLzxCK56+grIGyDX3YDxOKyK/DPC+flY7LR8qs5OLz1WIOKHJSCCsVt+ufm+qTXrPEV4o4fCeNg7wqiCJLR/d66/NKPIsrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788925973; c=relaxed/simple;
	bh=hwZXMomvGkefIy/Uhf10MHTtdjzJ+aCAwXWzQChB2UU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=r9wYtGaKab9x4pKGPOXJdxtXIpyOd7hLnVAuoZpR9ChfwsoSggpNgdN6lXdZliYrHR2Dv0cr52EoyeyXtUyxn+XkcTMUU91D1wG9GCC5Ekj7bOMdG/TaQE58rrBFtqPwCPjq47phm+dFHTNDuBmJDw43UqPMlmsvL60XoNkRfCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S7G2dFFq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S7G2dFFq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7813F1F00A3E;
	Wed,  9 Sep 2026 03:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788925969;
	bh=Lo3sMkk2nYzejnWlVKfrMVg9XGwzx8tA6N2JXX+jx88=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S7G2dFFqnwdaUatUmWFU+Tj2eeeBrlnRUSTsjHu9hZpJwAmVDsmEa/5gsznD7zfXw
	 EBW/HTd82/bKErd1kelrRo8nLwQf9FfjP28IoE4LRNZMrgtiv9z81VGvRVZR/8Cg17
	 OOUDD65z2WODLs95wtEIrCw2Dl06W0s3ewZ1HhLH3BZR482wdwA9b/pBLmh7QUXYVp
	 MYvk9sPd6B7sDMM5KG5wBfIAH3PeHf8NQkAChbARE5txODOZ1wytqYbnn0reAGhVw1
	 KJiOTn6uOyFs0oOXleEDgBFgMkS1aGVjRhEYvVdCG8skyXId8kf68i9YpEOn70eJXm
	 0hJHIBqku7LDg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 4/4] net: mana: add dynamic HWC queue depth
 with reinit path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20260908035201.402424-5-longli@microsoft.com>
References: <20260908035201.402424-1-longli@microsoft.com>
 <20260908035201.402424-5-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 03:52:49 +0000
Message-Id: <20260909035249.7813F1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [Critical] Capping the hardware-reported HWC queue depth without negotiat=
ing it with the host causes a fatal ring buffer size mismatch, leading to o=
ut-of-bounds memory accesses.

Pre-existing issues:
- [High] CQ queue memory is freed without waiting for an RCU grace period, =
risking use-after-free in the IRQ handler.
- [High] Use-After-Free during channel teardown due to incorrect queue dest=
ruction order.
--

commit e9ca1d1d51e325f4557f02fd7fcfac8f36e41ace
Author: Long Li <longli@microsoft.com>

    net: mana: add dynamic HWC queue depth with reinit path
   =20
    Rebuild depth-one HWC queues at the advertised maximum, capped at 128.
    Preserve the 24-bit depth in u32, bound allocations and round message
    buffers to a power of two. Advertise support in the driver-version requ=
est.

> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/ne=
t/ethernet/microsoft/mana/gdma_main.c
> index eb88bae2b14d8..78424e1d884f1 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> @@ -1260,15 +1260,17 @@ static void mana_gd_create_cq(const struct gdma_q=
ueue_spec *spec,
>  static void mana_gd_destroy_cq(struct gdma_context *gc,
>  			       struct gdma_queue *queue)
>  {
> +	struct gdma_queue **cq_table =3D READ_ONCE(gc->cq_table);
>  	u32 id =3D queue->id;
> =20
> -	if (id >=3D gc->max_num_cqs)
> +	/* HWC re-establishment can fail before allocating the CQ table. */
> +	if (!cq_table || id >=3D gc->max_num_cqs)
>  		return;
> =20
> -	if (!gc->cq_table[id])
> +	if (!cq_table[id])
>  		return;
> =20
> -	gc->cq_table[id] =3D NULL;
> +	cq_table[id] =3D NULL;

[Severity: High]
This isn't a bug introduced by this patch, but can this lead to a
use-after-free in the EQ interrupt handler?

The CQ memory is freed by the caller (mana_gd_destroy_queue()) immediately
after mana_gd_destroy_cq() unpublishes it from the table, without waiting f=
or
an RCU grace period.

Concurrently, the EQ interrupt processor (mana_gd_process_eqe()) runs under
rcu_read_lock(), reads the CQ pointer from the table, and dereferences it. =
If
the CQ is freed during this window, the interrupt handler will access freed
memory. Should this wait for an RCU grace period before freeing the queue?

>  }
> =20
>  int mana_gd_create_hwc_queue(struct gdma_dev *gd,
> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/n=
et/ethernet/microsoft/mana/hw_channel.c
> index a4f7346d285f7..750ee8f729994 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
[ ... ]
> @@ -846,13 +878,44 @@ static int mana_hwc_init_queues(struct hw_channel_c=
ontext *hwc, u16 q_depth,
>  	return err;
>  }
> =20
> +/* Bring-up only: requires no senders or concurrent lifecycle operations.
> + * This helper does not unpublish the HWC or drain senders.
> + */
> +static void mana_hwc_destroy_queues(struct hw_channel_context *hwc)
> +{
> +	struct gdma_context *gc =3D hwc->gdma_dev->gdma_context;
> +
> +	/* The CQ helper deregisters the HWC EQ before returning. */
> +	if (hwc->cq) {
> +		mana_hwc_destroy_cq(gc, hwc->cq);

[Severity: High]
This is a pre-existing issue, but does this queue destruction order cause a
use-after-free during teardown?

mana_hwc_destroy_cq() frees the CQ object before it destroys the EQ. The EQ
remains active and can still receive events from the hardware. If a teardown
fails or times out (which is actively exercised by the new reinit_fallback
logic) and an initialization event arrives after the CQ is freed but before
the EQ is disabled, the EQ interrupt handler will dereference the freed CQ
when processing HWC_INIT_DATA_CQID.

> +		hwc->cq =3D NULL;
> +	}
[ ... ]
> @@ -896,8 +959,132 @@ int mana_hwc_create_channel(struct gdma_context *gc)
>  		goto out;
>  	}
> =20
> +	if (q_depth_max > HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH) {
> +		/* Bound DMA allocations before using the 24-bit depth. */
> +		if (q_depth_max > HW_CHANNEL_MAX_QUEUE_DEPTH)
> +			q_depth_max =3D HW_CHANNEL_MAX_QUEUE_DEPTH;

[Severity: Critical]
Does capping the hardware-reported HWC queue depth without negotiating it
with the host cause a ring buffer size mismatch?

The driver limits the queue depth to HW_CHANNEL_MAX_QUEUE_DEPTH (128) and
allocates DMA rings based on this limit. However, the mana_smc_setup_hwc()
protocol lacks a queue size field, meaning this restriction isn't
communicated to the host hardware.

If the hardware advertises a larger depth (e.g., 256), will it write up to
256 entries into the rings and exceed the 128 allocated entries, leading to
an out-of-bounds memory write?

> +
> +		/* Keep bootstrap message sizes for mandatory commands.
> +		 * Incompatible reports skip rebuilding, not channel creation.
> +		 */
> +		if (max_req_msg_size !=3D HW_CHANNEL_MAX_REQUEST_SIZE ||
[ ... ]
> +		err =3D mana_hwc_establish_channel(gc, &q_depth_max,
> +						 &max_req_msg_size,
> +						 &max_resp_msg_size);
> +		if (!err &&
> +		    (q_depth_max < hwc->num_inflight_msg ||

[Severity: Critical]
Does this validation check incorrectly allow the out-of-bounds access?

By verifying q_depth_max < hwc->num_inflight_msg, it permits the hardware
depth (q_depth_max) to be larger than the driver's allocated depth
(hwc->num_inflight_msg). Should this reject the configuration if the hardwa=
re
depth exceeds the allocated depth?

> +		     max_req_msg_size !=3D HW_CHANNEL_MAX_REQUEST_SIZE ||
> +		     max_resp_msg_size !=3D HW_CHANNEL_MAX_RESPONSE_SIZE)) {
> +			/* The rebuilt channel must support the allocated depth
> +			 * and message sizes.
> +			 */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908035201.4024=
24-1-longli@microsoft.com?part=3D4
