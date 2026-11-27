Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795795073;
	b=PeI5VSoFZaU8fUpCJFCVE7HqkUbQ59Hr346Xhx9aBjOxvXMAL9ZJV4KK1a3x6w216KAp
	 TnK7iUDomFFb2RSiHSX6zoIHnMbYMZzZZ8cDYS3fGpct7pRXIiM/YxAS5aj7ttKwzSuLx
	 p/mqcKgCh3zcOVdw7RSMYZ6Pp1R5wqjP7oJ1xQk27pUoQRS7J0k4Ur5JoAtfDWx7CccrM
	 fIvqVWDpVzrcLPuMouWzvF2j4V0B+KsLgwvPnORendvLBAwFc+qkzAfE4EJIcmi9YfHzG
	 wOQrToY+01jMz4TXnwTfLz0i9B8NE538nbMzRBq1AlV1Xa93tdShtXapvRZT58VQ1QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795795073;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=x6kIKvotnGfyF+LHAJIdpxCafMgTkU1XXwAbkkw4uXo=;
	b=v6Ge6PT//yGlTYxdEkWXDRA9mLIZ+jIfX/XO6OoBBtR1cvrthqno1czeY7ngQoAN+nR4
	 Sol6EJ1bMAQUpF2Wrtj5G7oXDHE6VpVBo1jrdFI+knxDV5bO5GnJKw5BiBNG1rNpo7azL
	 Q/QoV+r4C7L0+4pLmSZjPW5BeYrJXlkXBw3V/4aKHYNguGOxVsmRgZ73aPFphu9a8szFY
	 mHEFj1bET9MKs8/1ZejN1EdRflp2JKRTYrQQen7+/3AgD5PlgVF7p0QXNpWWL6MtOrwBU
	 8MxiHhIFOEANzqCs2km70y80B3QaO4gGZ4zdOCzrYwogalGta2ubKgvwPeGg+ICDdRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iJhd2J6Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857CC606A32D;
	Fri, 27 Nov 2026 15:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iJhd2J6Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6222E1F000C1;
	Fri, 27 Nov 2026 15:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795795073;
	bh=x6kIKvotnGfyF+LHAJIdpxCafMgTkU1XXwAbkkw4uXo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=iJhd2J6ZwGR4TusVgBY5fehf8HVUG98CxVUveO5nCAeCWbBql+Q3YoFrfFKuOhZ2s
	 e5HRS1Ru2opXqPgVy/E+2dfyi8RWFJWdj6JJfzLUvkKMYs35RdoPbipf3E70+p6gQc
	 g0+Y9n5VoKpSIEtwTew+SVIzMTDQ5AAGYLWgYwKoI/HgbX+67NVkzPJ2yEYpkA6wvD
	 kAQnidXH3TJT382YdA5Rk5xuHX5V95kGDymJaX3Y9gKzlUGc1q9u8zueQm/hJnT9xi
	 FVUO/O5jWoiOInZWwTXBQav9FnqWAW0Tdn3BtvXmdbqpW+dBPhQggrIPGxMwaY8mHh
	 jSyMjNKlgeJ7Q==
Subject: Re: [PATCH v2 03/11] net/xsc: add the command queue
From: netdev-bot+sashiko@kernel.org
To: tianx@yunsilicon.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, jgg@ziepe.ca, leon@kernel.org,
 huangjunxian6@hisilicon.com, weihg@yunsilicon.com,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, kerneljasonxing@gmail.com
Date: Fri, 27 Nov 2026 15:57:51 +0000
Message-ID: <179579507193.3135.14971802624950078162@kernel.org>
In-Reply-To: <20261126145718.70868-4-tianx@yunsilicon.com>
References: <20261126145718.70868-4-tianx@yunsilicon.com>
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

Thank you for your contribution! Sashiko AI review found 8 potential
issue(s) to consider.

Critical: 0 · High: 2 · Medium: 5 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] Race on cmd->ent_arr[idx] can leave a live command with a NULL
  slot, and the polling kthread then dereferences NULL.
- [High] xsc_cmd_cleanup() frees the request ring (cmd_buf), the response
  ring (cq_buf), the dma_pool and the mailboxes of timed-out commands…
- [Medium] One command timeout permanently disables the command
  interface.
- [Medium] A timed-out command's xsc_cmd_work_ent and its inb/outb
  mailboxes can leak permanently.
- [Medium] xsc_cmd_comp_handler() matches a response to a waiter using
  only the device-supplied rsp->idx.
- [Medium] The ring is sized so that a full ring cannot be told apart
  from an empty one.
- [Medium] xsc_cmd_cq_polling() learns the expected owner/phase bit from
  the slot it is about to validate (cmd.c:450-452: `if…
- [Low] The command-queue poller is one kthread per device, and it polls
  even when no command is outstanding.

--

net/xsc: add the command queue

This commit adds the mailbox-based firmware command interface for the xsc
driver. A single polling kthread collects responses, command status is
mapped to errno values, and the cmdq version is checked at probe time.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/cmd.c b/drivers/net/ethernet/yunsilicon/xsc/pci/cmd.c
> new file mode 100644
> index 0000000000000..45dcdb2b47eb0
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/cmd.c
> @@ -0,0 +1,708 @@

[ ... ]

> +static int xsc_cmd_invoke(struct xsc_core_device *xdev, struct xsc_cmd_msg *in,
> +			  struct xsc_cmd_msg *out, u8 *status)
> +{

[ ... ]

> +	ent->token = ent->idx + 1;
> +	cmd->ent_arr[ent->idx] = ent;
> +

[ ... ]

> +	timeout = msecs_to_jiffies(XSC_CMD_TIMEOUT_MSEC);
> +	if (!wait_for_completion_timeout(&ent->done, timeout)) {
> +		cmd->cmd_status = XSC_CMD_STATUS_TIMEDOUT;
> +		pci_err(xdev->pdev, "wait for opcode 0x%x response timeout\n",
> +			xsc_msg_to_opcode(in));
> +		/* the entry stays registered for the completion handler */
> +		return -ETIMEDOUT;
> +	}
> +
> +	err = ent->ret;
> +	*status = ent->status;
> +
> +	spin_lock_irqsave(&cmd->alloc_lock, flags);
> +	if (cmd->ent_arr[ent->idx] == ent)
> +		cmd->ent_arr[ent->idx] = NULL;
> +	spin_unlock_irqrestore(&cmd->alloc_lock, flags);
> +	kfree(ent);

[Severity: High]
Can a live command end up with a NULL slot here?

xsc_cmd_comp_handler() releases the slot bit with xsc_free_ent() before it
calls complete(). So xsc_alloc_ent() can give the same idx to another caller
while this waiter still has its pointer in ent_arr[]. find_first_bit()
always picks the lowest free bit, so reusing the same idx is the normal
case.

The new owner publishes its entry with the plain
cmd->ent_arr[ent->idx] = ent store above, outside alloc_lock. That makes
this compare-and-clear atomic only against other locked accessors:

T1 (old waiter, idx 0)            T2 (new owner of idx 0)
spin_lock(alloc_lock)
ent_arr[0] == ent1 -> true
                                  cmd->ent_arr[0] = ent2;
ent_arr[0] = NULL
spin_unlock(alloc_lock)

When T2's response arrives, xsc_cmd_comp_handler() sees bit 0 allocated
and does this with ent == NULL:

	ent = cmd->ent_arr[idx];
	memcpy(ent->out->first, rsp->out, sizeof(rsp->out));

Wouldn't that oops the polling kthread? Every later command would then
time out.

If T2 times out instead, xsc_cmd_cleanup() can no longer reach its entry
and mailboxes.

The window is narrow. On PREEMPT_RT it is wider, because spinlock_t holders
can be preempted. In this patch only the serial probe-time version check
runs. However, the semaphore and bitmap allow 32 concurrent commands, and
later patches in the series add concurrent xsc_cmd_exec() callers.

> +
> +	return err;
> +}
> +
> +static void xsc_cmd_comp_handler(struct xsc_core_device *xdev, u8 idx,
> +				 struct xsc_rsp_layout *rsp)
> +{
> +	struct xsc_cmd *cmd = xdev->cmd;
> +	struct xsc_cmd_work_ent *ent;
> +
> +	if (idx >= cmd->max_reg_cmds || (cmd->cmd_entry_mask & BIT(idx))) {
> +		pci_err(xdev->pdev, "idx[%d] exceeds max cmds or has no request\n",
> +			idx);
> +		return;
> +	}
> +	ent = cmd->ent_arr[idx];
> +
> +	memcpy(ent->out->first, rsp->out, sizeof(rsp->out));

[Severity: Medium]
Can a stale response be given to the wrong command here?

The only matching is on the device-supplied rsp->idx, plus a lockless read
of cmd_entry_mask. ent_arr[idx] is not checked for NULL.

rsp->token is never compared with ent->token, even though xsc_cmd_invoke()
writes the token into the request:

	lay->token = ent->token;

The token is idx + 1, so even if it were checked it could not tell two uses
of the same slot apart.

A late response can come from a command that timed out in this instance,
or from a request the firmware still holds from a previous driver instance.
Either one would complete whichever command now owns that idx.
xsc_cmd_handle_rsp_before_reload() only skips responses that were already
posted at load time. Allocation starts at bit 0, so the version check is the
likely victim.

There is also a duplicate-response case. Suppose the response arrives after
the idx has been re-allocated, but while ent_arr[idx] still points at the
previous entry that its waiter is freeing. Could the memcpy() into
ent->out->first and complete(&ent->done) then write into freed memory?

> +	ent->ret = 0;
> +	ent->status = ((struct xsc_outbox_hdr *)ent->out->first)->status;
> +	cmd->retry_cnt = 0;
> +
> +	xsc_free_ent(cmd, ent->idx);
> +	complete(&ent->done);
> +	up(&cmd->sem);
> +}

[Severity: Medium]
Does this leak the timed-out command's xsc_cmd_work_ent and its inb/outb
mailboxes?

After a timeout, entA stays in cmd->ent_arr[X] and owns both mailboxes
("the command owns both mailboxes now" in _xsc_cmd_exec()). When the late
response arrives, this path frees bit X and returns a semaphore permit. It
does not clear ent_arr[X] or free entA.

The timeout check at the top of _xsc_cmd_exec() is a plain lockless read. A
caller that already passed it can still get idx X from xsc_alloc_ent(), for
example one sleeping in xsc_alloc_msg() or blocked in down().
xsc_cmd_invoke() then overwrites the slot unconditionally:

	cmd->ent_arr[ent->idx] = ent;

That command NULLs the slot when it finishes. From then on, entA, its two
xsc_cmd_msg chains and their dma_pool blocks are unreachable.
xsc_cmd_cleanup() cannot free them, and dma_pool_destroy() would report a
busy pool.

[ ... ]

> +static int xsc_cmd_cq_polling(void *data)
> +{

[ ... ]

> +		cq_pid = xsc_get_cmdq_rsp_pid(xdev) & XSC_CMDQ_INDEX_MASK;
> +		if (cmd->cq_cid == cq_pid) {
> +			usleep_range(1000, 2000);
> +			continue;
> +		}

[Severity: Low]
This isn't a bug, but this loop keeps polling when no command is
outstanding. Each idle iteration does two non-posted MMIO reads (the error
status and RSP_PID), then usleep_range(1000, 2000).

That is roughly 500-1000 wakeups and 1000-2000 PCIe reads per second for
each bound device, for as long as it stays bound. In this patch, commands
are only issued at probe.

The commit message mentions "a single polling thread" but not this idle
cost. Could the thread poll only while commands are outstanding, or back
off when idle?

> +
> +		rsp = xsc_get_cq_inst(cmd, cmd->cq_cid);
> +		if (!cmd->ownerbit_learned) {
> +			cmd->ownerbit_learned = 1;
> +			cmd->owner_bit = xsc_rsp_owner_bit(rsp);
> +		}
> +		if (cmd->owner_bit != xsc_rsp_owner_bit(rsp)) {

[Severity: Medium]
The expected owner bit is learned from the same slot being validated, so the
readiness check always passes for the first response. Is that safe?

The "rsp doorbell advanced but buffer not ready" branch suggests RSP_PID can
become visible before the slot contents. Suppose that happens on the first
response after init:

- The zeroed cq_buf slot is consumed with rsp->idx == 0 and status 0.
- The version check completes with a zeroed payload (cmdq_ver == 0), so
  probe fails.
- owner_bit is learned as 0.

The queue is never reset, so the hardware phase carries over from earlier
driver instances. If that phase is 1, every later slot fails the owner
check. The poller then loops on msleep(20) forever and every command times
out.

[ ... ]

> +static int _xsc_cmd_exec(struct xsc_core_device *xdev,
> +			 void *in, unsigned int in_size,
> +			 void *out, unsigned int out_size)
> +{

[ ... ]

> +	if (cmd->cmd_status == XSC_CMD_STATUS_TIMEDOUT)
> +		return -ETIMEDOUT;

[Severity: Medium]
Is it intended that one timeout disables the command interface for good?

xsc_cmd_invoke() sets cmd->cmd_status = XSC_CMD_STATUS_TIMEDOUT on timeout.
Nothing outside xsc_cmd_init() ever sets it back to XSC_CMD_STATUS_NORMAL.
That holds even when the late response arrives and xsc_cmd_comp_handler()
frees the slot and calls up(&cmd->sem).

After one firmware stall longer than XSC_CMD_TIMEOUT_MSEC, every later
xsc_cmd_exec() returns -ETIMEDOUT until the device is unbound and rebound.
Later in the series this covers CQ/QP/EQ create and destroy, MTU, port admin
status, vport state and event query.

The commit message only says "Event-driven mode is deferred". It does not
mention that timeouts are terminal.

[ ... ]

> +int xsc_cmd_init(struct xsc_core_device *xdev)
> +{

[ ... ]

> +	cmd->log_sz = XSC_CMDQ_Q_DEPTH_LOG;
> +	cmd->log_stride = XSC_CMDQ_ELEMENT_SIZE_LOG;
> +	cmd->max_reg_cmds = 1 << cmd->log_sz;
> +	bitmap_fill(&cmd->cmd_entry_mask, cmd->max_reg_cmds);
> +
> +	spin_lock_init(&cmd->alloc_lock);
> +	spin_lock_init(&cmd->doorbell_lock);
> +	sema_init(&cmd->sem, cmd->max_reg_cmds);

[Severity: Medium]
With this sizing, can a full response ring be told apart from an empty one?

max_reg_cmds and the semaphore both allow 32 outstanding commands. The
request and response rings have exactly 32 slots, and indices are compared
modulo 32 (XSC_CMDQ_INDEX_MASK). A permit is only returned after the poller
consumes the response.

xsc_cmd_cq_polling() treats cq_cid == cq_pid as empty:

	if (cmd->cq_cid == cq_pid) {
		usleep_range(1000, 2000);
		continue;
	}

Suppose the device posts 32 responses while the poller is in
usleep_range(). The masked RSP_PID wraps back to cq_cid, so all 32 responses
are skipped. Every waiter then times out, the XSC_CMD_STATUS_TIMEDOUT latch
disables the interface, and the owner phase no longer matches the hardware.

The request side has the same issue. xsc_cmd_invoke() never compares cmd_pid
with the hardware consumer index, so a 32nd unconsumed request also makes
REQ_PID equal to the consumer index.

The code does not show whether the hardware posts into all 32 slots. Would
limiting outstanding commands to (1 << log_sz) - 1 avoid this?

[ ... ]

> +void xsc_cmd_cleanup(struct xsc_core_device *xdev)
> +{

[ ... ]

> +	/* a timed-out command stays registered for a response that may never
> +	 * come; with the polling thread stopped nothing can touch it anymore
> +	 */
> +	for (i = 0; i < cmd->max_reg_cmds; i++) {
> +		if (!cmd->ent_arr[i])
> +			continue;
> +		xsc_free_msg(xdev, cmd->ent_arr[i]->in);
> +		xsc_free_msg(xdev, cmd->ent_arr[i]->out);
> +		kfree(cmd->ent_arr[i]);
> +		cmd->ent_arr[i] = NULL;
> +	}
> +
> +	dma_free_coherent(&xdev->pdev->dev, PAGE_SIZE, cmd->cq_buf, cmd->cq_dma);
> +	dma_free_coherent(&xdev->pdev->dev, PAGE_SIZE, cmd->cmd_buf, cmd->dma);
> +	dma_pool_destroy(cmd->pool);

[Severity: High]
Can the device still DMA into these buffers after they are freed?

With the polling thread stopped, the host will not touch a timed-out entry.
The device, though, still holds the ring and mailbox addresses. Nothing here
does any of the following:

- reset the queue
- clear the CMDQM_HOST_REQ/RSP_BUF_BASE registers
- drain outstanding commands

Bus mastering is also still enabled, because xsc_pci_fini() only clears it
afterwards:

	xsc_cmd_cleanup(xdev);
	pci_iounmap(pdev, xdev->bar);
	pci_clear_master(pdev);

The xsc_pci_init() unwind uses the same order. The probe path reaches this
directly when xsc_cmd_version_check() times out and jumps to
err_cmd_cleanup.

On rebind, pci_set_master() runs before xsc_cmd_init() reprograms the base
addresses. xsc_cmd_handle_rsp_before_reload() also writes RSP_CID before
that. A response the firmware still holds could then be written into the
previous instance's freed, and possibly reused, pages.

The kthread_create() failure path in xsc_cmd_init() has the same problem,
because the rings were already programmed into the device:

err_free_cq:
	dma_free_coherent(&xdev->pdev->dev, PAGE_SIZE, cmd->cq_buf, cmd->cq_dma);

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261126145711.70868-1-tianx%40yunsilicon.com
