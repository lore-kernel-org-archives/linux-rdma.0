Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795791488;
	b=xorszvkcRwWNqNUZZc+IuyL7lfp45+bgr4JacLJXMUvO+Ru6UK8Bo4iGYw2zG+5YYRSc
	 rX2Du47JXmS1Zbc0hm4fSJ6zB6EFnJUhxLgCiklpSghCjVAIyvI6oFfeiwSs4fksH4KWU
	 nIo89J0wY8m5DxZruWnWAwgsymcOcXDUrI699M9XN8yy7WBn2L3nYV9x7LMiQ242KflY5
	 wzuGz+1K9gGAhNu9DRb4Ap6NWvswuQo5Maubw4/IN4gSCzUU3xUKzkMO6mDJIKZiABKjd
	 38x2aNkRvt5D0HfdUs5bf3YcAm2DEIUOoZiiNZ2/d+AQTPIKy18Qvn8j8hJg0OzjbGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795791488;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=j15pXdO/JjzmV3BpN3y/MTQoqrZTXE6at95EOPeixj0=;
	b=YTa7pOqoRgICOZevesFiQDbK/jAXNK1CJBEDYaFtAEeDslnx6PAoG77XiWc4JdVzRJrR
	 5H01E+8Cn2nEZ5RwTKz2X1HcVSHefv+M7SEzCvRsqZOpBTE24TYoFEwWwHkikkXJyvtZY
	 JesazPjVOaODFMtcobSUaq+mrTIgHXlt6rTGq+MkCw6CI4icQ7fAaBb4NOT7qLA9B1YKI
	 Y+WbH+kWf52mNaJS3pSD5WQ6XzegjNPIsZgBw1aB4dM7UZaEKuBWJNKxqKeBTdRmmQ4mP
	 eEwGO7yfHsV7ulLcYyG0vbdE48uJF1ing58FOORJmJ4Gms9+X2tR0o5nT6+JE44bzwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XVyI2UBm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25DC606A31C
	for <linux-rdma@vger.kernel.org>; Fri, 27 Nov 2026 14:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XVyI2UBm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CC41F0089B;
	Fri, 27 Nov 2026 14:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795791487;
	bh=j15pXdO/JjzmV3BpN3y/MTQoqrZTXE6at95EOPeixj0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XVyI2UBmVuOD40BPg59jqbVhOREKbiVxFUl3w62CQYJ5ob2YKZXpEWGyjW045yn5z
	 TuqHMITWuxbAx9Hi5WpN0evZaGxyAj8cVbp71WtNGvRVeO69kBbg2yQBDIE7npNtXw
	 5qy6VrzhoEgHBEwo9CbKmOEZlStn4W00ddzjj5ljM7wR4wOuKChJ/Rfn1cP0bbQgtj
	 xWhxvRFUr2yiqWDxDRc1gMxDW2zGoNs3VVrflmz5Nsc60K1viAMJypW171GOzq5Upo
	 On8crqm3WRuIhcvMEwOB3qYlzEUIHJosSklzv+o99SxQeXWj+qS3fwnkU69Pg3u6w5
	 QcaV4eXyze9sQ==
Message-ID: <sashiko-outbox-237636@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 03/11] net/xsc: add the command queue
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261126145718.70868-4-tianx@yunsilicon.com>
References: <20261126145711.70868-1-tianx@yunsilicon.com>
 <20261126145718.70868-4-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 14:58:06 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [High] net/xsc: race on cmd->ent_arr in xsc_cmd_invoke() and
  xsc_cmd_comp_handler()
- [Medium] net/xsc: broken CQE owner-bit readiness check in
  xsc_cmd_cq_polling()
- [Medium] net/xsc: continuous idle MMIO polling in xsc_cmd_cq_polling()
- [Medium] net/xsc: clear cmdq error status before retrying in
  xsc_cmd_err_handler()
--

commit 69606c4897d6d499bb3174901050bfe9f0c8a30d
Author: Xin Tian <tianx@yunsilicon.com>

net/xsc: add the command queue

This commit adds the mailbox-based firmware command interface for the
Yunsilicon XSC PCI driver, including command execution, completion
polling, error handling, and command queue version verification.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/cmd.c b/drivers/net/=
ethernet/yunsilicon/xsc/pci/cmd.c
> new file mode 100644
> index 0000000000000..45dcdb2b47eb0
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/cmd.c

[ ... ]

> +static int xsc_cmd_invoke(struct xsc_core_device *xdev, struct xsc_cmd_m=
sg *in,
> +			  struct xsc_cmd_msg *out, u8 *status)
> +{
> +	struct xsc_cmd *cmd =3D xdev->cmd;
> +	struct xsc_cmd_layout *lay;
> +	struct xsc_cmd_work_ent *ent;
> +	unsigned long timeout;
> +	unsigned long flags;
> +	int err;
> +
> +	ent =3D kzalloc_obj(*ent, GFP_KERNEL);
> +	if (!ent)
> +		return -ENOMEM;
> +
> +	ent->in =3D in;
> +	ent->out =3D out;
> +	init_completion(&ent->done);
> +	down(&cmd->sem);
> +	ent->idx =3D xsc_alloc_ent(cmd);
> +	if (ent->idx < 0) {
> +		pci_err(xdev->pdev, "failed to allocate command entry\n");
> +		up(&cmd->sem);
> +		kfree(ent);
> +		return -ENOMEM;
> +	}
> +	ent->token =3D ent->idx + 1;
> +	cmd->ent_arr[ent->idx] =3D ent;
> +
> +	spin_lock_irqsave(&cmd->doorbell_lock, flags);
> +	lay =3D xsc_get_inst(cmd, cmd->cmd_pid);
> +	memset(lay, 0, sizeof(*lay));
> +	memcpy(lay->in, in->first, sizeof(lay->in));
> +	if (in->next)
> +		lay->in_ptr =3D cpu_to_be64(in->next->dma);
> +	lay->inlen =3D cpu_to_be32(in->len);
> +	if (out->next)
> +		lay->out_ptr =3D cpu_to_be64(out->next->dma);
> +	lay->outlen =3D cpu_to_be32(out->len);
> +	lay->type_owner =3D FIELD_PREP(XSC_CMD_TYPE_MASK, XSC_PCI_CMD_XPORT);
> +	lay->token =3D ent->token;
> +	lay->idx =3D ent->idx;
> +	lay->sig =3D 0xff;
> +
> +	/* ring doorbell after the descriptor is valid */
> +	wmb();
> +
> +	cmd->cmd_pid =3D (cmd->cmd_pid + 1) % (1 << cmd->log_sz);
> +	xsc_update_cmdq_req_pid(xdev, cmd->cmd_pid);
> +	spin_unlock_irqrestore(&cmd->doorbell_lock, flags);
> +
> +	timeout =3D msecs_to_jiffies(XSC_CMD_TIMEOUT_MSEC);
> +	if (!wait_for_completion_timeout(&ent->done, timeout)) {
> +		cmd->cmd_status =3D XSC_CMD_STATUS_TIMEDOUT;
> +		pci_err(xdev->pdev, "wait for opcode 0x%x response timeout\n",
> +			xsc_msg_to_opcode(in));
> +		/* the entry stays registered for the completion handler */
> +		return -ETIMEDOUT;
> +	}
> +
> +	err =3D ent->ret;
> +	*status =3D ent->status;
> +
> +	spin_lock_irqsave(&cmd->alloc_lock, flags);
> +	if (cmd->ent_arr[ent->idx] =3D=3D ent)
> +		cmd->ent_arr[ent->idx] =3D NULL;
> +	spin_unlock_irqrestore(&cmd->alloc_lock, flags);
> +	kfree(ent);
> +
> +	return err;
> +}
> +
> +static void xsc_cmd_comp_handler(struct xsc_core_device *xdev, u8 idx,
> +				 struct xsc_rsp_layout *rsp)
> +{
> +	struct xsc_cmd *cmd =3D xdev->cmd;
> +	struct xsc_cmd_work_ent *ent;
> +
> +	if (idx >=3D cmd->max_reg_cmds || (cmd->cmd_entry_mask & BIT(idx))) {
> +		pci_err(xdev->pdev, "idx[%d] exceeds max cmds or has no request\n",
> +			idx);
> +		return;
> +	}
> +	ent =3D cmd->ent_arr[idx];
> +
> +	memcpy(ent->out->first, rsp->out, sizeof(rsp->out));
> +	ent->ret =3D 0;
> +	ent->status =3D ((struct xsc_outbox_hdr *)ent->out->first)->status;
> +	cmd->retry_cnt =3D 0;
> +
> +	xsc_free_ent(cmd, ent->idx);
> +	complete(&ent->done);
> +	up(&cmd->sem);
> +}

[Severity: High]
Can concurrent callers of xsc_cmd_invoke() race with xsc_cmd_comp_handler()
on cmd->ent_arr[idx]?

xsc_cmd_comp_handler() releases idx back to cmd->cmd_entry_mask via
xsc_free_ent() before cmd->ent_arr[idx] is cleared, and xsc_cmd_invoke()
assigns cmd->ent_arr[ent->idx] =3D ent without holding cmd->alloc_lock:

CPU0 (cq_task)             CPU1 (cmd 1)               CPU2 (cmd 2)
xsc_cmd_comp_handler()
  xsc_free_ent(cmd, idx)
  complete(&ent1->done)
                                                      xsc_cmd_invoke()
                                                        xsc_alloc_ent() -> =
idx
                           spin_lock(&alloc_lock)
                           if (ent_arr[idx] =3D=3D ent1)
                             ent_arr[idx] =3D NULL
                           spin_unlock(&alloc_lock)
                           kfree(ent1)
                                                        /* before ent_arr[i=
dx]
                                                         * is written, or if
                                                         * CPU1 overwrote e=
nt2
                                                         * with NULL: */
xsc_cmd_comp_handler()
  ent =3D cmd->ent_arr[idx]
  memcpy(ent->out->first, ...)  <-- NULL pointer dereference or use-after-f=
ree

Also, if a timed-out command completes late, xsc_cmd_comp_handler() frees
its slot in cmd->cmd_entry_mask without freeing ent, ent->in, or ent->out.
Any concurrent command that already passed the cmd_status check in
_xsc_cmd_exec() can then reuse idx and overwrite cmd->ent_arr[idx], leaking
the timed-out entry and its DMA pool buffers.

[ ... ]

> +static void xsc_cmd_err_handler(struct xsc_core_device *xdev, u32 raw)
> +{
> +	struct xsc_cmd *cmd =3D xdev->cmd;
> +	unsigned long flags;
> +	int err =3D 0;
> +	int retry =3D 0;
> +	u32 stat =3D raw;

[ ... ]

> +	if (retry) {
> +		if (cmd->retry_cnt >=3D XSC_CMD_MAX_RETRY_CNT) {
> +			pci_warn(xdev->pdev, "error handler retried %d times, stop retrying\n=
",
> +				 cmd->retry_cnt);
> +		} else {
> +			spin_lock_irqsave(&cmd->doorbell_lock, flags);
> +			xsc_update_cmdq_req_pid(xdev, cmd->cmd_pid);
> +			cmd->retry_cnt++;
> +			spin_unlock_irqrestore(&cmd->doorbell_lock, flags);
> +		}
> +	}
> +
> +	if (err)
> +		xsc_clear_cmdq_err_status(xdev, raw);
> +}

[Severity: Medium]
Should xsc_cmd_err_handler() clear the error status register via
xsc_clear_cmdq_err_status() before ringing the retry doorbell with
xsc_update_cmdq_req_pid()?

Ringing the request doorbell before the write-1-to-clear on the error
status register means the hardware either sees the retry doorbell while
the error bit is still latched, or a fast error on the retried request has
its newly latched error bit immediately cleared by
xsc_clear_cmdq_err_status(xdev, raw), causing the command to time out.

> +static int xsc_cmd_cq_polling(void *data)
> +{
> +	struct xsc_core_device *xdev =3D data;
> +	struct xsc_cmd *cmd =3D xdev->cmd;
> +	struct xsc_rsp_layout *rsp;
> +	u32 err_status;
> +	u32 cq_pid;
> +
> +	while (!kthread_should_stop()) {
> +		if (need_resched())
> +			schedule();
> +
> +		err_status =3D xsc_read_cmdq_err_status(xdev);
> +		if (err_status)
> +			xsc_cmd_err_handler(xdev, err_status);
> +
> +		cq_pid =3D xsc_get_cmdq_rsp_pid(xdev) & XSC_CMDQ_INDEX_MASK;
> +		if (cmd->cq_cid =3D=3D cq_pid) {
> +			usleep_range(1000, 2000);
> +			continue;
> +		}

[Severity: Medium]
Does xsc_cmd_cq_polling() need to wake up every 1-2 ms and perform two
PCIe MMIO reads when no commands are in flight?

Even with event-driven interrupts deferred, this kthread runs
continuously for the lifetime of every probed PCI function, preventing
deep CPU idle states and adding a 1-2 ms polling delay to command
completions.  Parking the thread on a waitqueue when no commands are
outstanding and waking it from xsc_cmd_invoke() would avoid idle MMIO
polling and poll immediately when a command is submitted.

> +
> +		rsp =3D xsc_get_cq_inst(cmd, cmd->cq_cid);
> +		if (!cmd->ownerbit_learned) {
> +			cmd->ownerbit_learned =3D 1;
> +			cmd->owner_bit =3D xsc_rsp_owner_bit(rsp);
> +		}
> +		if (cmd->owner_bit !=3D xsc_rsp_owner_bit(rsp)) {
> +			dev_err_ratelimited(&xdev->pdev->dev,
> +					    "rsp doorbell advanced but buffer not ready %u %u\n",
> +					    cmd->cq_cid, cq_pid);
> +			msleep(20);
> +			continue;
> +		}

[Severity: Medium]
Does learning cmd->owner_bit from rsp right before comparing it against
xsc_rsp_owner_bit(rsp) defeat the buffer readiness check?

On the first response (!cmd->ownerbit_learned), cmd->owner_bit is set to
xsc_rsp_owner_bit(rsp) immediately before testing
cmd->owner_bit !=3D xsc_rsp_owner_bit(rsp), so the check cannot fail.  If
the MMIO response PID advances before the CQE DMA write lands in
cmd->cq_buf (which xsc_cmd_init() zeroes with memset()), the polling
thread learns cmd->owner_bit =3D 0 from the unwritten slot, consumes an
all-zero CQE for index 0, and latches an inverted owner_bit if the
hardware phase bit was 1.  Likewise, whenever the expected owner_bit is 0,
zero-initialized slots already match cmd->owner_bit before DMA completes.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126145711.7086=
8-1-tianx@yunsilicon.com?part=3D3
