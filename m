Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794552402;
	b=l2KVgjDo7+/4rCalKaesDrwgHOIB8YWSXPJ2+BlfqLUDNJ/mycRdaI68CZQnPkeyRWzJ
	 bTZe+1lim7tYIHb+aisfJRK53nvknL81OKJjgo9giY7RPxBamXVxKVaV+ZJ4LTxo0W5+9
	 fYey/3RQB4rIxOfhbfw354Eb53GIbkh1BOJCo3dHVz9NujPXFoGN/VzzTK39N+p563ZdI
	 YtnZuRnWRsiP0MWRhRHY9NnunvGkT5Vb8pVgG7sQaH1VLHmAqGbxV4lE1HNwjzlji3zKg
	 3llykfW/t+wUJoGBuT/X4PbnNdQFh+uXHSd8TLtFsvmiVEPr7UC91VMWCoU3RqJOOMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794552402;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=+W4MtmrIqWp+kYZjfKbvtwBvtxVj9xj86hKfD148kIc=;
	b=C+5zWaYXz71NpnE338Ue6Qk0bq/TkZs2bz3yYDFdN9f14/6GHboap3TXKMsPncgkE+K0
	 svAVOBHVn8CkWaoFQHijNhf5BQ1hrfLGb3TmG71EXDUoikw4zB8vaR+05G3Yje7km/bjA
	 DNfOgqjPK9QsQv3541rHSYfQQS4Ag6wQGMADl/5vwIWEBlygGQLAJFD4SwowsB88n/CVh
	 JgcnfX3zyTF8yVqjDYy7ctWJr7xBNfAiWV4txnKyVWQ+NQvJzYfsJ5UdP6uHD2TRfN37s
	 ZtqAt0YzAdqEdyCqm1m144Ykp3IcuJOfMeJwpEbpj1M7uQ/5WRhbsrynG55g//pIvbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PLZ0TglA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5E9606A896;
	Fri, 13 Nov 2026 06:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PLZ0TglA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12D51F000C8;
	Fri, 13 Nov 2026 06:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794552402;
	bh=+W4MtmrIqWp+kYZjfKbvtwBvtxVj9xj86hKfD148kIc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=PLZ0TglAR5MbJwLgt3abZ/SZP2Yo71jSMtcn1mzgmBb8QBji8Gqyt1H5LrRy+QQ3W
	 3hZtmhFfSshijgETgFmSUAieK/Y+z1Y5TU3YhbS3mlyVlsfQfWgh5UG8TZ1Py3YukA
	 /K1bvtR9FFzi3aYrsoezV1A82xGWuvH/6UcNrIr0XbhWVrImwMAC2A42mGiZkiCA7P
	 GR0T5wdfzNL67QRAWcdztClUBLtfAqDyLjl9IcTH44jiRNyaSSx66TMIwMbYRThr1s
	 I5NV0hZ4REbx5yYAjEILlQPyQH4yYtm1FyyX26yr9evFuppMv6XeZPhvWMpeBrJbPF
	 InaswWSYWbe4Q==
Subject:
 Re: [PATCH net-next v10 3/4] net: mana: support concurrent HWC requests
From: netdev-bot+sashiko@kernel.org
To: weh@linux.microsoft.com
Cc: longli@kernel.org, kotaranov@microsoft.com, kuba@kernel.org,
 davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 andrew+netdev@lunn.ch, jgg@ziepe.ca, leon@kernel.org, haiyangz@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, shradhagupta@linux.microsoft.com,
 horms@kernel.org, ernis@linux.microsoft.com, stephen@networkplumber.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 gargaditya@linux.microsoft.com, kees+treewide@kernel.org, kees@kernel.org,
 mawasthi@linux.microsoft.com, weh@microsoft.com, edumazet@kernel.org
Date: Fri, 13 Nov 2026 06:46:40 +0000
Message-ID: <179455240021.2199510.18244084352437360589@kernel.org>
In-Reply-To: <2ae0e8b22569dc23178d0ea42178808ad92cb6db.1794208055.git.weh@linux.microsoft.com>
References: <2ae0e8b22569dc23178d0ea42178808ad92cb6db.1794208055.git.weh@linux.microsoft.com>
X-sashiko-severity: High
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

Thank you for your contribution! Sashiko AI review found 5 potential
issue(s) to consider.

Critical: 0 · High: 1 (1) · Medium: 1 · Low: 3

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] After one HWC command times out, later commands are rejected
  without being posted, so teardown commands never reach the device.
- [Medium] mana_hwc_try_get_msg_index() turns a full bitmap into
  -ETIMEDOUT whenever atomic_read(&hwc->abandoned_msgs) is non-zero,…
- [Low] The patch fixes a real bug without naming it: a late HWC response
  could be delivered to the wrong command.
- [Low] mana_need_log() now suppresses logging for -ETIMEDOUT/-ENODEV
  whenever gc->hwc.driver_data is NULL.
- [Low] gc->hwc_drain_waitq belongs to gdma_context (it sits next to
  gc->hwc_lock, which the patch correctly initializes in…

Pre-existing issues:
- [High] Some code reads gc->hwc.driver_data with no hwc_lock and no
  active_senders reference, then dereferences it:…

--

net: mana: support concurrent HWC requests

This patch gives each HWC message slot separate sender and response
references. It serializes SQ posting and replaces the semaphore with a
wait queue for admission. It also adds a publish/unpublish and
sender-drain protocol around gc->hwc.driver_data for runtime teardown.

Link: https://lore.kernel.org/r/20260908035201.402424-4-longli@microsoft.com
Link: https://lore.kernel.org/r/20260914175044.2a26bb46@kernel.org
Link: https://lore.kernel.org/r/179196575640.434549.9102950927041409151@kernel.org
Link: https://lore.kernel.org/r/179250339266.3135.15035365058593192217@kernel.org

> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index 8df130386da34..bb4a963c2cf5d 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> @@ -142,22 +142,26 @@ int mana_gd_init_registers(struct gdma_context *gc)
>  		return mana_gd_init_vf_regs(gc);
>  }
>  
> -/* Suppress logging when we set timeout to zero */
> +/* Cancellation and unpublication make teardown request failures expected. */
>  bool mana_need_log(struct gdma_context *gc, int err)
>  {
>  	struct hw_channel_context *hwc;
> +	bool need_log = true;
> +	unsigned long flags;
>  
> -	if (err != -ETIMEDOUT)
> +	if (err != -ETIMEDOUT && err != -ENODEV)
>  		return true;
>  
>  	if (!gc)
>  		return true;
>  
> +	spin_lock_irqsave(&gc->hwc_lock, flags);
>  	hwc = gc->hwc.driver_data;
> -	if (hwc && hwc->hwc_timeout == 0)
> -		return false;
> +	if (!hwc || !mana_hwc_timeout_read(hwc))
> +		need_log = false;
> +	spin_unlock_irqrestore(&gc->hwc_lock, flags);

[Severity: Low]

Will this also hide live-channel failures during setup?

mana_hwc_test_channel() sets channel_up = true and calls
mana_gd_test_hwc_eq() before mana_hwc_publish_channel(). So
gc->hwc.driver_data is still NULL when mana_gd_test_eq_request() checks
the error:

mana_hwc_create_channel()
  mana_hwc_create_bootstrap_channel()
    mana_hwc_test_channel()
      mana_gd_test_hwc_eq()
        mana_gd_test_eq_request()
          mana_need_log(gc, err)   /* driver_data == NULL -> false */

If the bootstrap EQ test fails with -ETIMEDOUT or -ENODEV, the
"test_eq failed: %d" message is now dropped. The commit message says the
patch will "keep logging live-channel failures", which doesn't match.

Before this patch, driver_data was set at the start of
mana_hwc_create_channel() and the timeout was nonzero, so this was logged.

>  
> -	return true;
> +	return need_log;
>  }

[ ... ]

> @@ -1482,9 +1542,12 @@ int mana_gd_verify_vf_version(struct gdma_context *gc)
>  	struct gdma_verify_ver_resp resp = {};
>  	struct gdma_verify_ver_req req = {};
>  	struct hw_channel_context *hwc;
> +	u32 timeout_ms;
>  	int err;
>  
> +	/* The setup caller must exclude concurrent HWC teardown. */
>  	hwc = gc->hwc.driver_data;
> +

[Severity: High]

This is a pre-existing issue, but the new comment claims an exclusion
that nothing seems to enforce. Is anything keeping hwc alive between
this read and the later mana_hwc_timeout_read() and
mana_hwc_timeout_update() calls?

GC_PROBE_SUCCEEDED is not cleared on suspend. If a
GDMA_EQE_HWC_RESET_REQUEST arrives during PM resume,
mana_gd_process_eqe() schedules the service work, which runs without
device_lock:

mana_serv_func()
  mana_serv_reset()
    mana_gd_suspend()
      mana_gd_cleanup()
        mana_hwc_destroy_channel()
          kfree(hwc)

Meanwhile the resume thread may be in
mana_gd_resume()->mana_gd_setup()->mana_gd_verify_vf_version(), still
holding the raw pointer. The new active_senders drain only covers
callers inside mana_gd_send_request().

mana_gd_create_dma_region() (with the similar "The caller must keep the
HWC alive" comment) and mana_ib_gd_create_dma_region() in
drivers/infiniband/hw/mana/main.c have the same problem: both
dereference hwc->max_req_msg_size without hwc_lock.

Teardown now clears driver_data at the very start. Could these readers
also see NULL mid-teardown and dereference it?

>  	mana_gd_init_req_hdr(&req.hdr, GDMA_VERIFY_VF_DRIVER_VERSION,
>  			     sizeof(req), sizeof(resp));

[ ... ]

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 6f0ccdeffc4f9..8bc00001d20e5 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> @@ -6,48 +6,140 @@

[ ... ]

> +static int mana_hwc_try_get_msg_index(struct hw_channel_context *hwc,
> +				      void *resp, u32 resp_len,
> +				      struct hwc_caller_ctx **caller_ctx)
>  {
>  	struct gdma_resource *r = &hwc->inflight_msg_res;
>  	struct hwc_caller_ctx *ctx;
>  	unsigned long flags;
>  	u32 index;
> -
> -	down(&hwc->sema);
> +	int err;
>  
>  	spin_lock_irqsave(&r->lock, flags);
> +	if (!hwc->channel_up) {
> +		spin_unlock_irqrestore(&r->lock, flags);
> +		return -ENODEV;
> +	}
>  
> -	index = find_first_zero_bit(hwc->inflight_msg_res.map,
> -				    hwc->inflight_msg_res.size);
> +	index = find_first_zero_bit(r->map, r->size);
> +	if (index >= r->size) {
> +		err = -EBUSY;
> +		if (!mana_hwc_timeout_read(hwc) ||
> +		    atomic_read(&hwc->abandoned_msgs))
> +			err = -ETIMEDOUT;
> +		spin_unlock_irqrestore(&r->lock, flags);
> +		return err;
> +	}

[Severity: High]

Can this reject teardown commands without ever posting them to the
device?

After a command times out, mana_hwc_wait_for_response() keeps the
response reference. The bitmap bit then stays set until a late response
arrives or mana_hwc_stop_channel() runs:

	if (err == -EINPROGRESS) {
		ctx->error = -ETIMEDOUT;
		ctx->responded = true;
		atomic_inc(&hwc->abandoned_msgs);
		abandoned = true;
	}

On the depth-one bootstrap channel, every later caller finds
index >= r->size with abandoned_msgs != 0. It returns -ETIMEDOUT here,
before anything is written to the SQ or the doorbell is rung.

The same happens when hwc_timeout is 0 after mana_serv_reset() calls
mana_gd_cancel_hwc_timeout(). In the mana_gd_suspend() that follows,
only the first command is posted.

Before this patch, the slot was released on timeout, so the next command
was still posted with a 1 ms wait.

The destructive callers free the memory whatever the error.
mana_destroy_wq_obj() returns void, and mana_destroy_rxq() continues to
page_pool_destroy() and mana_gd_destroy_queue(). mana_gd_destroy_queue()
then calls mana_gd_free_memory() whatever mana_gd_destroy_dma_region()
returns.

If the device is slow but still alive, could it keep WQ objects and DMA
regions that point at pages already returned to the allocator?
mana_hwc_timeout_reduce() drops the timeout to 1 ms after the first
abandonment. Against a device slower than that, roughly every other
later command could be dropped this way.

The commit message says:

    A congestion-only -EBUSY can make destructive callers skip a
    teardown command and still free its DMA memory.

Doesn't returning -ETIMEDOUT at admission have the same effect on those
callers?

This also seems to remain at the end of the series. "net: mana: add
dynamic HWC queue depth with reinit path" keeps the depth-one channel
when the PF reports depth 1, a depth above 128, or non-default maxima.

[ ... ]

> +static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, void *resp,
> +				  u32 resp_len,
> +				  struct hwc_caller_ctx **caller_ctx)
> +{
> +	int err;
> +
> +	/* Healthy contention must not skip a destructive control request. */
> +	wait_event(hwc->admission_waitq,
> +		   (err = mana_hwc_try_get_msg_index(hwc, resp, resp_len,
> +						    caller_ctx)) != -EBUSY);
> +	return err;
> +}

[Severity: Medium]

Only -EBUSY keeps a caller waiting here. mana_hwc_try_get_msg_index()
turns a full bitmap into -ETIMEDOUT whenever abandoned_msgs is non-zero,
however many of the occupied slots are actually abandoned.

Take a queue of depth N >= 2 with one abandoned slot and N-1 normal
in-flight commands. The next caller would fail at once, with nothing
posted. Waiting would be bounded: each of the other slots is released or
abandoned within its timeout, and abandonment calls wake_up_all() on
admission_waitq.

Would a check such as abandoned_msgs >= r->size match the commit
message's "without mistaking healthy contention for a failed command"?

At depth one the two checks are equivalent. However, "net: mana: add
dynamic HWC queue depth with reinit path" rebuilds the channel with
depths 2..128 and leaves this logic unchanged.

[ ... ]

> @@ -90,40 +182,53 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
>  				 struct hwc_work_request *rx_req, u16 msg_id)
>  {
>  	const struct gdma_resp_hdr *resp_msg = rx_req->buf_va;
> +	struct gdma_resource *r = &hwc->inflight_msg_res;
>  	struct hwc_caller_ctx *ctx;
> +	bool release;
>  	int err;
>  
> -	if (!test_bit(msg_id, hwc->inflight_msg_res.map)) {
> +	spin_lock(&r->lock);
> +	if (!test_bit(msg_id, r->map)) {
> +		spin_unlock(&r->lock);
>  		dev_err(hwc->dev, "hwc_rx: invalid msg_id = %u\n", msg_id);
>  		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
>  		return;
>  	}
>  
>  	ctx = hwc->caller_ctx + msg_id;
> -
>  	spin_lock(&ctx->lock);
> -	if (!ctx->output_buf) {
> +	spin_unlock(&r->lock);
> +
> +	/* Consume the response-side reference exactly once. This releases a
> +	 * quarantined slot after its late response arrives.
> +	 */
> +	release = mana_hwc_clear_resp_pending(hwc, ctx);
> +
> +	if (ctx->responded) {

[Severity: Low]

This isn't a bug, but the quarantine here also fixes a real misdelivery.

Before the series, a timed-out slot was released immediately, and at
depth one the next request reused msg_id 0. A late response for the old
command then passed test_bit() and was copied into the next caller's
output_buf.

The previous patch in the series says late-response correlation is
handled here. This commit message describes the quarantine but does not
name the misdelivery, and there is no Fixes: tag.

Could a Fixes: tag be added, for stable backports?

[ ... ]

> @@ -1020,11 +1175,146 @@ void mana_hwc_free_retained_channel(struct gdma_context *gc)

[ ... ]

> +	gd->gdma_context = gc;
> +	hwc->gdma_dev = gd;
> +	hwc->dev = gc->dev;
> +	WRITE_ONCE(hwc->hwc_timeout, HW_CHANNEL_WAIT_RESOURCE_TIMEOUT_MS);
> +	init_waitqueue_head(&hwc->admission_waitq);
> +	init_waitqueue_head(&gc->hwc_drain_waitq);

[Severity: Low]

Should gc->hwc_drain_waitq be initialized once in mana_gd_probe() and
mana_cdx_gd_probe(), next to spin_lock_init(&gc->hwc_lock)? It belongs to
gdma_context, but here it is re-initialized on every channel creation,
including each mana_gd_resume()->mana_gd_setup().

mana_hwc_stop_channel() sleeps on this queue after driver_data has been
cleared. A concurrent creator, for example the service reset work racing
PM suspend/resume, would see driver_data == NULL. It would then call
init_waitqueue_head() on a queue that still has a waiter.

Could that orphan the waiter in mana_hwc_stop_channel() and lose its
wakeup?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1794208055.git.weh%40linux.microsoft.com
