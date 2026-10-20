Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792503395;
	b=UeNAG2r7lWKCqcZOdL2a6pp5ZkSue6rsrJsz6NlG9PQ/p+iuoeECX4QnH6GLApVq4ngk
	 DHwt0gniLlH6Iam4rJNXV/koy58nqr1UD3sPZRVtnt2iV4Q9dvVUgE9p5H0pvZBnJAjKR
	 WCXgEPkrCaGdY6GX/S/0yDpjFnbwxTaTI4zdcbtD444L2i2mxxH+COQG87tgQnvs8oNqq
	 v6uDj1MfavCpMdGVSDcG4dgUcvhDndISlClt/D6nV0QVPpSX6Hy1hY/ahAKW42JBoXsG1
	 xTI8+8x5JpLWnko28h6vyrOAHg/J0Q2RGAcudy0ViTkv4elO7OfeHfqmru9IWLmFjkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792503395;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=bEnpdbQXnYxpntT+HnfCAXyMaxxkM+oCkmppLMyj3f8=;
	b=mDbip2Zr34aZz4tQxr/xQpCukNBynIftJoHl1xr2iZ0+9xvMCIj+PgOM0ueXD9/i4kYu
	 A6/ITVzdFPfXnN3U3av/siSP3nNOACexvd0q0QCoBdjL0iEU4aHSiA2q3YytmWH6WqYfQ
	 crrDE1Q7DfGjCoJlfMdPfQSyHTn7XuEcH7yfO2JwTtnp3CFBiOSXP3uRfSUJOdk7lxS65
	 ZEeI7Sno32H4ePKuZUDnxi3VG7Y6keMMvjMyY22627jE4x1Wl0mMesJuDBOv/JBJD8U6t
	 85lfCEU0L+LgiMgX0LvpGTxgPghu6VJQPCtqE3VFzhQ5FBtEplgRpvx5y0Z4QM2dzDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=boZvfr2y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFD060A4AC3;
	Tue, 20 Oct 2026 13:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=boZvfr2y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C42A1F000CF;
	Tue, 20 Oct 2026 13:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792503394;
	bh=bEnpdbQXnYxpntT+HnfCAXyMaxxkM+oCkmppLMyj3f8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=boZvfr2yO+wT2J+j5A02snFsCJ7oNNMBoEEreJqQqVnDzm0oA9LRcISThCXYhslql
	 oz2cjxJDmKugtwIkercwHQQaxSWVtTV19MN/AT+mz3dSMSt6bPEhaugaJEzJKyzHGc
	 33LDeiXpvL12eHVrjawfgQPTDUulfx72IXWvrVHlaFKY4j22l4bc7/Yh9y3bZGcC68
	 Hgw9D3OH9XrEZU7ERs3KgZc+uu5ZIM4L+GhKsLIUf40s4ijnCLpMnvNTLUIEyXEFSS
	 6u+Vqll9Skof16M07RX1iEQdirLazR1eZyKa8QEiQoOpMMD4bP0BwF9cEHeCSz0Oxn
	 Eg5NNrUGavA7Q==
Subject:
 Re: [PATCH net-next v8 3/4] net: mana: support concurrent HWC requests
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
Date: Tue, 20 Oct 2026 13:36:32 +0000
Message-ID: <179250339266.3135.15035365058593192217@kernel.org>
In-Reply-To: =?utf-8?q?=3C983b5719644379806ac278b45cfb7cb70d2935f6=2E1791998?=
 =?utf-8?q?462=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
References: =?utf-8?q?=3C983b5719644379806ac278b45cfb7cb70d2935f6=2E17919984?=
 =?utf-8?q?62=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 1 (1) · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The patch replaces the unbounded down(&hwc->sema) with
  down_timeout(..., hwc_timeout).
- [Medium] mana_hwc_get_msg_index() replaces the unbounded down() with
  down_timeout().

Pre-existing issues:
- [Medium] This problem wasn't introduced by this patch, but
  mana_hwc_rx_event_handler() returns without reposting the RX WQE when…

--

net: mana: support concurrent HWC requests

This patch gives each HWC message slot separate sender and response
references, serializes SQ posting, and replaces the unbounded admission
down() with down_timeout(), which returns -EBUSY or -ETIMEDOUT. It also
publishes the channel under a new hwc_lock, drains active senders on
teardown, and moves hwc_timeout updates to atomic helpers.

Link: https://lore.kernel.org/r/20260908035201.402424-4-longli@microsoft.com
Link: https://lore.kernel.org/r/20260914175044.2a26bb46@kernel.org
Link: https://lore.kernel.org/r/179196575640.434549.9102950927041409151@kernel.org

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 03a3a0e9d3f84..9ea67c076ebda 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> @@ -6,34 +6,105 @@
>  #include <net/mana/hw_channel.h>
>  #include <linux/vmalloc.h>
>  
> -static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
> +u32 mana_hwc_timeout_read(const struct hw_channel_context *hwc)

[ ... ]

> +static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, void *resp,
> +				  u32 resp_len,
> +				  struct hwc_caller_ctx **caller_ctx)
>  {
>  	struct gdma_resource *r = &hwc->inflight_msg_res;
>  	struct hwc_caller_ctx *ctx;
>  	unsigned long flags;
> +	u32 wait_ms;
>  	u32 index;
> +	int err;
>  
> -	down(&hwc->sema);
> +	wait_ms = mana_hwc_timeout_read(hwc);
> +	if (down_timeout(&hwc->sema, msecs_to_jiffies(wait_ms))) {

[Severity: High]
Before this patch, admission could only block here. Every command that
reached mana_hwc_send_request() was eventually posted. With
down_timeout(), a channel that is healthy but busy can now return -EBUSY
without ever sending the command.

At HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH of 1, every sender shares one
permit in FIFO order. That includes RDMA verbs that users can reach
through mana_ib. The wait is hwc_timeout, which stays at 1 ms for good
after any mana_hwc_timeout_reduce().

Several teardown callers do not handle a command that was never sent.
mana_gd_destroy_eq() ignores the result:

	if (queue->eq.disable_needed)
		mana_gd_disable_queue(queue);

mana_gd_create_hw_eq() has already set dma_region_handle to
GDMA_INVALID_DMA_REGION, so the later mana_gd_destroy_dma_region() call
in mana_gd_destroy_queue() cannot replace the missed disable.
mana_gd_destroy_queue() then calls mana_gd_free_memory() without
condition. mana_destroy_wq_obj() returns void, so its callers free the
WQ/CQ memory either way.

If GDMA_DISABLE_QUEUE, GDMA_DESTROY_DMA_REGION or MANA_DESTROY_WQ_OBJ is
rejected at admission like this, can the device, which is still healthy,
keep writing EQEs/CQEs into pages the kernel has already freed and
reused?

> +		spin_lock_irqsave(&r->lock, flags);
> +		if (!hwc->channel_up)
> +			err = -ENODEV;
> +		else if (atomic_read(&hwc->abandoned_msgs))
> +			err = -ETIMEDOUT;
> +		else
> +			err = -EBUSY;

[Severity: Medium]
Can this choose -EBUSY when the channel is hung? Only the permit holder
raises abandoned_msgs, in mana_hwc_wait_for_response(), and only after
its own completion wait has expired:

mana_hwc_wait_for_response() {
    ...
	if (err == -EINPROGRESS) {
		ctx->error = -ETIMEDOUT;
		ctx->responded = true;
		atomic_inc(&hwc->abandoned_msgs);
    ...
}

The bootstrap depth gives one permit. Suppose a waiter enters
down_timeout() after holder A takes the permit but before A enters
wait_for_completion_timeout(), or both timers expire in the same jiffy.
The waiter then reads abandoned_msgs == 0 and returns -EBUSY, even
though the device is not responding.

There is a second case after mana_serv_reset() calls
mana_gd_cancel_hwc_timeout(). A request posted before the cancel still
holds the permit with its old wait. The suspend-path commands would then
fail at once in down_timeout(0) with -EBUSY. Before, they blocked in
down() and failed quietly with -ETIMEDOUT.

The existing consumers check for -ETIMEDOUT.

mana_need_log() only suppresses -ETIMEDOUT on a published hwc whose
timeout is 0. Two new errors slip past it:

  - the -EBUSY returned here
  - the -ENODEV that mana_hwc_stop_channel() sets after
    mana_hwc_unpublish_channel() has cleared gc->hwc.driver_data

Both would now print dev_err() messages on reset and teardown paths,
for example from mana_gd_deregister_device().

mana_gd_probe() schedules recovery only for -ETIMEDOUT or -EPROTO, and
mana_serv_reset() rescans after a failed resume only for those two
codes:

	if (err == -ETIMEDOUT || err == -EPROTO) {

If a probe or resume gets -EBUSY from a hung HWC, will it fail with no
recovery scheduled?

> +		spin_unlock_irqrestore(&r->lock, flags);
> +
> +		return err;
> +	}

[ ... ]

> @@ -90,40 +183,53 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
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

[Severity: Medium]
This is a pre-existing issue and was not introduced by this patch. This
rejection path reposts rx_req, but the range check before it in
mana_hwc_rx_event_handler() does not:

mana_hwc_rx_event_handler() {
    ...
	msg_id = READ_ONCE(resp->response.hwc_msg_id);
	if (msg_id >= hwc->num_inflight_msg) {
		dev_err(hwc->dev, "HWC RX: wrong msg_id=%u\n", msg_id);
		return;
	}
    ...
}

Does each response with an out-of-range hwc_msg_id lose one RQ buffer
for good? At depth 1, a single such response from the device or a
hostile CVM host would leave the RQ empty. Every later response could
then not be delivered until a reset.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1791998462.git.weh%40linux.microsoft.com
