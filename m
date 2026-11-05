Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894973;
	b=eLw2st4pGXNB6bB9pk1x7gxWQpd0t90PO3tSP1XYNnrP/zqRqgcyXsimiwvzzaFzBvfT
	 3GuCPUFvU7SBEYLk7gALDDEdXA39Ecm1YZY81CyucCsBegJomL3QaYhiXncA7dVti+pvr
	 T/bcKr97H1R3ZGEvdVSQQaEvEOAej0ZcCFKt8AKQznQDOlSO50viQa4WAypGKV1tcUI8v
	 jZK84918vIe9Fd86OC6gVJQKGCeZ69mFRuAbEE9gunPiyUa+D+tMw9F+BVVLFscGIQiC1
	 mja5IwspP2VZ4l+GmcwYzTNERRychi2B6KRVdl6UKmvXWy0N7ar4T/cgD58cJxjkZmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894973;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jsS3DdgLpqFKU47AeHChygy/v3Dxd4XR4fjVs23jGFY=;
	b=4/zCZcLDTWDzufOMwh0QJNArnwDXz8M1p4R3veQ9rmnw6F2ekJnj0672+McryUvWTRi/
	 mBOv9y1Ha0gwxGZf7FvE2FfrfcZNj5paVd6ci0jGb88CMzI4JrfL9rcgMQ3OJbdkd3Iwl
	 jMnC0Bve+d7VfIRnb8/m20x2DH4caqewPdgXDH8+UU77JqJM8HJXsR8m9+WDNWkNY6p4i
	 FfxKtjKKEXj+xYypjGY48Aw9DS5e8a7B+xw8D5d2zG/kj7ccJC0IQ8Xf9UdP1bpljVBdo
	 pvtPCxVQcPJPneUkFFMoo4oVWRuTiHzh5zftIJEhHAPCgsvFyIyqKo6srMbTVFSxK9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Ukm/t8HZ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA67606BE83
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 16:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ukm/t8HZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8691F00A02;
	Thu,  5 Nov 2026 16:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894972;
	bh=jsS3DdgLpqFKU47AeHChygy/v3Dxd4XR4fjVs23jGFY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ukm/t8HZutBRsEfFhCRclU7jNR3QPhE53aGvjHVaJG5hsK7PDVQSEc9D8lK6hP0A2
	 QHDfZt9cM4csjzrDovnvuQxQ/XjNlq4A2aYKmhBqzUKEThh+akzAjNboH0loStH9Yv
	 HQA6Emq3gDtlYlk8xn6NHf5H9wenZlyib1tfv64PkuMZiT8Uap46pVqPJnBN72SLym
	 SefNdu707tGLgfTK8gfCSdeOQvRk2BvRVYgmSKX+eeA5qpClv2fBDtYmetyMXM9oll
	 MU9C79nMmdhnJskwVxa6W/L2TMAgL59zdIBi96ShrrKtPcvxKpPhqWuPhZqC6cjGlp
	 tZdEeX8ocoa4Q==
Message-ID: <sashiko-outbox-199426@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 04/15] net/xsc: add the command queue
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104155658.37053-5-tianx@yunsilicon.com>
References: <20261104155650.37053-1-tianx@yunsilicon.com>
 <20261104155658.37053-5-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 16:09:32 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:
- [High] net/xsc: leaked command resources and wq hang on timeout in _xsc_c=
md_exec()
- [High] net/xsc: IRQ deadlock and unchecked kthread_create() in xsc_cmd_us=
e_polling()
- [High] net/xsc: infinite loop and premature up() in xsc_cmd_use_events()
- [Medium] net/xsc: wrong 16-byte inline threshold in xsc_alloc_msg() corru=
pts commands
- [Medium] net/xsc: broken CQ owner-bit learning in xsc_cmd_cq_polling()
- [Medium] net/xsc: unsynchronized shared board_info access in xsc_hw_setup=
()
- [Medium] net/xsc: unguarded V2 capability fields and 32-bit shifts in xsc=
_cmd_query_hca_cap()
--

commit bb1aecb9bb4cc115b4d4581a9902a3b7bb2ae064
Author: Xin Tian <tianx@yunsilicon.com>

net/xsc: add the command queue

This commit adds the firmware command queue implementation, mailbox memory
management, and initial hardware capability and board configuration queries
for the Yunsilicon XSC PCI driver.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/cmdq.c b/drivers/net=
/ethernet/yunsilicon/xsc/pci/cmdq.c
> new file mode 100644
> index 0000000000000..c001b312224d6
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/cmdq.c
> @@ -0,0 +1,1244 @@

[ ... ]

> +enum {
> +	NUM_LONG_LISTS	  =3D 2,
> +	NUM_MED_LISTS	  =3D 64,
> +	LONG_LIST_SIZE	  =3D (2ULL * 1024 * 1024 * 1024 / PAGE_SIZE) * 8 + 16 +
> +				XSC_CMD_DATA_BLOCK_SIZE,
> +	MED_LIST_SIZE	  =3D 16 + XSC_CMD_DATA_BLOCK_SIZE,
> +};

[ ... ]

> +static int xsc_cmd_invoke(struct xsc_core_device *xdev, struct xsc_cmd_m=
sg *in,
> +			  struct xsc_rsp_msg *out, u8 *status)
> +{
> +	struct xsc_cmd *cmd =3D &xdev->cmd;
> +	struct xsc_cmd_work_ent *ent;
> +	int err =3D 0;
> +
> +	ent =3D xsc_alloc_cmd(cmd, in, out);
> +	if (IS_ERR(ent))
> +		return PTR_ERR(ent);
> +
> +	init_completion(&ent->done);
> +	INIT_WORK(&ent->work, cmd_work_handler);
> +	if (!queue_work(cmd->wq, &ent->work)) {
> +		pci_err(xdev->pdev, "failed to queue work\n");
> +		err =3D -ENOMEM;
> +		goto err_free;
> +	}
> +
> +	err =3D xsc_wait_func(xdev, ent);
> +	if (err =3D=3D -ETIMEDOUT)
> +		/* leave the entry for the completion handler; the driver
> +		 * is marked timed out and rejects all further commands
> +		 */
> +		return err;

[ ... ]

> +void xsc_cmd_use_events(struct xsc_core_device *xdev)
> +{
> +	struct xsc_cmd *cmd =3D &xdev->cmd;
> +	int i;
> +
> +	/* flush first: cmd_work_handler() takes a semaphore permit, so
> +	 * flushing after all permits are held would deadlock against a
> +	 * just-queued work item
> +	 */
> +	flush_workqueue(cmd->wq);
> +
> +	/* keep the cmdq interrupt out while the polling kthread is still
> +	 * draining the queue
> +	 */
> +	disable_irq(cmd->irqn);
> +
> +	for (i =3D 0; i < cmd->max_reg_cmds; i++)
> +		down(&cmd->sem);
> +
> +	cmd->mode =3D XSC_CMD_MODE_EVENTS;
> +
> +	while (cmd->cmd_pid !=3D cmd->cq_cid)
> +		msleep(20);
> +	kthread_stop(cmd->cq_task);
> +	cmd->cq_task =3D NULL;
> +
> +	for (i =3D 0; i < cmd->max_reg_cmds; i++)
> +		up(&cmd->sem);
> +
> +	enable_irq(cmd->irqn);
> +}

[Severity: High]
Can the while (cmd->cmd_pid !=3D cmd->cq_cid) loop in xsc_cmd_use_events()
spin forever if the request producer index and response consumer index start
at different offsets?

In xsc_cmd_init(), cmd->cmd_pid and cmd->cq_cid are initialized from separa=
te
hardware registers:

    cmd->cmd_pid =3D xsc_get_cmdq_req_pid(xdev) & XSC_CMDQ_INDEX_MASK;
    cmd->cq_cid =3D xsc_get_cmdq_rsp_cid(xdev) & XSC_CMDQ_INDEX_MASK;

If the hardware request and response indices do not have the exact same
modulo-32 value after a kexec, FLR, or prior command error, cmd->cmd_pid and
cmd->cq_cid maintain a constant non-zero offset even when all commands have
completed, so cmd->cmd_pid !=3D cmd->cq_cid will never become false.

In addition, in xsc_cmd_cq_polling() and xsc_cmd_resp_handler(),
xsc_cmd_comp_handler() calls up(&cmd->sem) before the caller advances
cmd->cq_cid, updates hardware via xsc_update_cmdq_rsp_cid(), and flips
cmd->owner_bit. Doesn't that allow xsc_cmd_use_events() or
xsc_cmd_use_polling() to acquire the final semaphore permit before the
completion handler finishes updating the CQ consumer state?

> +static int xsc_cmd_cq_polling(void *data);
> +void xsc_cmd_use_polling(struct xsc_core_device *xdev)
> +{
> +	struct xsc_cmd *cmd =3D &xdev->cmd;
> +	int i;
> +
> +	flush_workqueue(cmd->wq);
> +
> +	disable_irq(cmd->irqn);
> +
> +	for (i =3D 0; i < cmd->max_reg_cmds; i++)
> +		down(&cmd->sem);
> +
> +	cmd->mode =3D XSC_CMD_MODE_POLLING;
> +	cmd->cq_task =3D kthread_create(xsc_cmd_cq_polling,
> +				      (void *)xdev,
> +				      "xsc_cmd_cq_polling");
> +	if (!IS_ERR(cmd->cq_task))
> +		wake_up_process(cmd->cq_task);
> +
> +	for (i =3D 0; i < cmd->max_reg_cmds; i++)
> +		up(&cmd->sem);
> +
> +	enable_irq(cmd->irqn);
> +}

[Severity: High]
Won't xsc_cmd_use_polling() deadlock on cmd->sem if a command is still in
flight when disable_irq(cmd->irqn) is called?

In XSC_CMD_MODE_EVENTS, cmd->cq_task is NULL and completions are driven by
the interrupt handler on cmd->irqn calling xsc_cmd_resp_handler() ->
xsc_cmd_comp_handler() -> up(&cmd->sem). Because cmd_work_handler() returns
as soon as it rings the doorbell while the in-flight command continues
holding its permit on cmd->sem, calling disable_irq(cmd->irqn) before
acquiring all cmd->max_reg_cmds permits masks the completion interrupt while
no polling thread is running, so up(&cmd->sem) cannot be called.

Also, why does xsc_cmd_use_polling() call enable_irq(cmd->irqn) at the end
after starting cmd->cq_task? With the interrupt enabled in polling mode,
xsc_cmd_resp_handler() and xsc_cmd_cq_polling() can race on cmd->cq_cid and
cmd->owner_bit.

Finally, if kthread_create() fails in xsc_cmd_use_polling(), cmd->cq_task
stores an ERR_PTR while cmd->mode is set to XSC_CMD_MODE_POLLING, and
xsc_cmd_use_events() later calls kthread_stop(cmd->cq_task) without checking
IS_ERR_OR_NULL(cmd->cq_task).

[ ... ]

> +static struct xsc_cmd_msg *xsc_alloc_msg(struct xsc_core_device *xdev,
> +					 unsigned int in_size)
> +{
> +	struct xsc_cmd_msg *msg =3D ERR_PTR(-ENOMEM);
> +	struct xsc_cmd *cmd =3D &xdev->cmd;
> +	struct cache_ent *ent =3D NULL;
> +
> +	if (in_size > MED_LIST_SIZE && in_size <=3D LONG_LIST_SIZE)
> +		ent =3D &cmd->cache.large;
> +	else if (in_size > 16 && in_size <=3D MED_LIST_SIZE)
> +		ent =3D &cmd->cache.med;
> +
> +	if (ent) {
> +		spin_lock(&ent->lock);
> +		if (!list_empty(&ent->head)) {
> +			msg =3D list_entry(ent->head.next, typeof(*msg), list);
> +			/* For cached lists, we must explicitly state what is
> +			 * the real size
> +			 */
> +			msg->len =3D in_size;
> +			list_del(&msg->list);
> +		}
> +		spin_unlock(&ent->lock);
> +	}
> +
> +	if (IS_ERR(msg))
> +		msg =3D xsc_alloc_cmd_msg(xdev, GFP_KERNEL, in_size);
> +
> +	return msg;
> +}

[Severity: Medium]
Should the inline threshold in xsc_alloc_msg(), MED_LIST_SIZE, and
LONG_LIST_SIZE be sizeof(msg->first.data) (32 bytes) instead of 16?

In struct xsc_cmd_first, data is 32 bytes (__be32 data[8]), and both
xsc_alloc_cmd_msg() and xsc_copy_to_cmd_msg() copy up to
sizeof(to->first.data) (32 bytes) inline before using overflow mailboxes in
to->next.

Because xsc_alloc_msg() checks in_size > 16, a command with 16 < in_size <=
=3D 32
(such as XSC_CMD_OP_ENABLE_NIC_HCA or XSC_CMD_OP_MODIFY_RAW_QP) is served f=
rom
cmd->cache.med, which has a pre-allocated overflow mailbox in msg->next.
xsc_copy_to_cmd_msg() consumes all in_size bytes into to->first.data (leavi=
ng
the remaining 32 - in_size inline bytes with stale cached data) and never
initializes to->next->buf, yet cmd_work_handler() still copies all 32 bytes
of ent->in->first.data into lay->in and sets lay->in_ptr to ent->in->next->=
dma.

[ ... ]

> +static int _xsc_cmd_exec(struct xsc_core_device *xdev,
> +			 void *in, unsigned int in_size,
> +			 void *out, unsigned int out_size)
> +{
> +	struct xsc_cmd *cmd =3D &xdev->cmd;
> +	struct xsc_rsp_msg *outb;
> +	struct xsc_cmd_msg *inb;
> +	u8 status =3D 0;
> +	int err;
> +
> +	if (cmd->cmd_status =3D=3D XSC_CMD_STATUS_TIMEDOUT)
> +		return -ETIMEDOUT;
> +
> +	inb =3D xsc_alloc_msg(xdev, in_size);
> +	if (IS_ERR(inb)) {
> +		err =3D PTR_ERR(inb);
> +		return err;
> +	}
> +
> +	err =3D xsc_copy_to_cmd_msg(inb, in, in_size);
> +	if (err) {
> +		pci_err(xdev->pdev, "copy to cmd_msg err %d\n", err);
> +		goto err_free_msg;
> +	}
> +
> +	outb =3D xsc_alloc_rsp_msg(xdev, GFP_KERNEL, out_size);
> +	if (IS_ERR(outb)) {
> +		err =3D PTR_ERR(outb);
> +		goto err_free_msg;
> +	}
> +
> +	err =3D xsc_cmd_invoke(xdev, inb, outb, &status);
> +	if (err =3D=3D -ETIMEDOUT)
> +		/* the entry stays registered for the completion handler
> +		 * and keeps its mailboxes
> +		 */
> +		return err;

[ ... ]

> +static void xsc_cmd_comp_handler(struct xsc_core_device *xdev, u8 idx,
> +				 struct xsc_rsp_layout *rsp)
> +{

[ ... ]

> +	xsc_free_ent(cmd, ent->idx);
> +	complete(&ent->done);
> +	up(&cmd->sem);
> +}
> +
> +static int xsc_cmd_cq_polling(void *data)
> +{
> +	struct xsc_core_device *xdev =3D data;
> +	struct xsc_cmd *cmd =3D &xdev->cmd;
> +	struct xsc_rsp_layout *rsp;
> +	u32 cq_pid;
> +
> +	while (!kthread_should_stop()) {
> +		if (need_resched())
> +			schedule();
> +		cq_pid =3D xsc_get_cmdq_rsp_pid(xdev);
> +		if (cmd->cq_cid =3D=3D cq_pid) {
> +			usleep_range(1000, 2000);
> +			continue;
> +		}
> +
> +		rsp =3D xsc_get_cq_inst(cmd, cmd->cq_cid);
> +		if (!cmd->ownerbit_learned) {
> +			cmd->ownerbit_learned =3D 1;
> +			cmd->owner_bit =3D xsc_rsp_owner_bit(rsp);
> +		}
> +		if (cmd->owner_bit !=3D xsc_rsp_owner_bit(rsp)) {
> +			dev_err_ratelimited(&xdev->pdev->dev,
> +				"hw update cq doorbell but buf not ready %u %u\n",
> +				cmd->cq_cid, cq_pid);
> +			msleep(20);
> +			continue;
> +		}

[Severity: Medium]
Does learning cmd->owner_bit from xsc_rsp_owner_bit(rsp) right before
checking cmd->owner_bit !=3D xsc_rsp_owner_bit(rsp) bypass the readiness ch=
eck
on the first response in xsc_cmd_cq_polling() and xsc_cmd_resp_handler()?

In xsc_cmd_init(), cmd->cq_buf is zeroed with memset(cmd->cq_buf, 0,
PAGE_SIZE) and cmd->ownerbit_learned is set to 0. When the first completion
is polled, if the MMIO read of rsp_pid sees the updated producer index befo=
re
the device DMA write of the response descriptor reaches cmd->cq_buf,
xsc_rsp_owner_bit(rsp) reads 0 from the zeroed buffer, sets cmd->owner_bit =
=3D 0,
and immediately passes the cmd->owner_bit !=3D xsc_rsp_owner_bit(rsp) check=
 with
an all-zero descriptor while latching the wrong owner-bit polarity for subs=
equent
slots.

[ ... ]

> +void xsc_cmd_cleanup(struct xsc_core_device *xdev)
> +{
> +	struct xsc_cmd *cmd =3D &xdev->cmd;
> +
> +	destroy_workqueue(cmd->wq);
> +	if (!IS_ERR_OR_NULL(cmd->cq_task))
> +		kthread_stop(cmd->cq_task);
> +	xsc_destroy_msg_cache(xdev);
> +	dma_free_coherent(&xdev->pdev->dev, PAGE_SIZE, cmd->cq_buf,
> +			  cmd->cq_dma);
> +	dma_free_coherent(&xdev->pdev->dev, PAGE_SIZE, cmd->cmd_buf,
> +			  cmd->dma);
> +	dma_pool_destroy(cmd->pool);
> +}

[Severity: High]
When a command times out in xsc_cmd_invoke() and _xsc_cmd_exec(), where are
ent, inb, and outb freed?

On -ETIMEDOUT, xsc_cmd_invoke() leaves ent allocated and _xsc_cmd_exec()
returns early without freeing outb or returning/freeing inb. However, neith=
er
xsc_cmd_comp_handler() (if a late completion arrives) nor xsc_cmd_cleanup()
(during error unwind in xsc_hw_setup() or device teardown) ever frees ent,
inb, or outb. Because inb (when detached from cmd->cache or allocated on
demand) and outb (when out_size > sizeof(outb->first.data), such as in
xsc_cmd_query_hca_cap()) hold blocks allocated from cmd->pool,
dma_pool_destroy(cmd->pool) in xsc_cmd_cleanup() will fail to destroy the
pool due to still-allocated DMA blocks and leak coherent DMA memory.

Furthermore, if cmd->max_reg_cmds commands time out while another work item
is queued on cmd->wq, cmd_work_handler() for that queued item will block
indefinitely in down(&cmd->sem), causing destroy_workqueue(cmd->wq) in
xsc_cmd_cleanup() to hang.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/hw.c b/drivers/net/e=
thernet/yunsilicon/xsc/pci/hw.c
> new file mode 100644
> index 0000000000000..0358a40cca9b8
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/hw.c
> @@ -0,0 +1,316 @@

[ ... ]

> +int xsc_cmd_query_hca_cap(struct xsc_core_device *xdev,
> +			  struct xsc_caps *caps)
> +{

[ ... ]

> +	caps->max_qp_mcg =3D be16_to_cpu(out->hca_cap.max_qp_mcg);
> +	caps->max_ra_res_qp =3D 1 << (out->hca_cap.log_max_ra_res_qp & 0x3f);
> +	caps->max_ra_req_qp =3D 1 << (out->hca_cap.log_max_ra_req_qp & 0x3f);
> +	caps->max_srq_wqes =3D 1 << out->hca_cap.log_max_srq_sz;

[ ... ]

> +	caps->max_qp =3D be32_to_cpu(out->hca_cap.max_qp);
> +	caps->max_cq =3D be32_to_cpu(out->hca_cap.max_cq);
> +	caps->max_pd =3D be32_to_cpu(out->hca_cap.max_pd);
> +
> +	if (be16_to_cpu(out->hdr.ver) >=3D XSC_CMD_QUERY_HCA_CAP_V2)
> +		caps->max_mtt =3D be32_to_cpu(out->hca_cap.max_mtt);
> +	else
> +		caps->max_mtt =3D 1 << (out->hca_cap.log_max_mtt & 0x3f);

[Severity: Medium]
In struct xsc_hca_cap, max_qp, max_cq, and max_pd are defined alongside
max_mtt in the V2 section of the mailbox. When be16_to_cpu(out->hdr.ver) is
earlier than XSC_CMD_QUERY_HCA_CAP_V2, won't reading out->hca_cap.max_qp,
out->hca_cap.max_cq, and out->hca_cap.max_pd unconditionally leave
caps->max_qp, caps->max_cq, and caps->max_pd as 0 instead of falling back to
1U << caps->log_max_qp, 1U << caps->log_max_cq, and 1U << caps->log_max_pd?

Also, in expressions like 1 << (out->hca_cap.log_max_mtt & 0x3f),
1 << (out->hca_cap.log_max_ra_res_qp & 0x3f), and
1 << out->hca_cap.log_max_srq_sz, can shifting the signed 32-bit integer
literal 1 by a 6-bit or 8-bit field overflow a 32-bit signed int?

[ ... ]

> +static int xsc_cmd_query_guid(struct xsc_core_device *xdev)
> +{
> +	struct xsc_cmd_query_guid_mbox_out out;
> +	struct xsc_cmd_query_guid_mbox_in in =3D {};
> +	int err;
> +
> +	in.hdr.opcode =3D cpu_to_be16(XSC_CMD_OP_QUERY_GUID);
> +	err =3D xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
> +	if (err)
> +		return err;
> +
> +	xdev->board_info->guid =3D out.guid;
> +	xdev->board_info->guid_valid =3D 1;
> +	return 0;
> +}
> +
> +int xsc_query_guid(struct xsc_core_device *xdev)
> +{
> +	if (xdev->board_info->guid_valid)
> +		return 0;
> +
> +	return xsc_cmd_query_guid(xdev);
> +}
> +
> +static int xsc_cmd_activate_hw_config(struct xsc_core_device *xdev)
> +{
> +	struct xsc_cmd_activate_hw_config_mbox_out out;
> +	struct xsc_cmd_activate_hw_config_mbox_in in =3D {};
> +	int err =3D 0;
> +
> +	in.hdr.opcode =3D cpu_to_be16(XSC_CMD_OP_ACTIVATE_HW_CONFIG);
> +	err =3D xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
> +	if (err)
> +		return err;
> +
> +	xdev->board_info->hw_config_activated =3D 1;
> +	return 0;
> +}
> +
> +int xsc_activate_hw_config(struct xsc_core_device *xdev)
> +{
> +	if (xdev->board_info->hw_config_activated)
> +		return 0;
> +
> +	return xsc_cmd_activate_hw_config(xdev);
> +}

[Severity: Medium]
Since xdev->board_info is shared across all PCI functions of the same board,
can concurrent probes of multiple functions on the same card race in
xsc_query_guid(), xsc_activate_hw_config(), and xsc_hw_setup()?

In xsc_cmd_query_hca_cap(), board_info_lock protects the lookup and
allocation of xdev->board_info, but xsc_query_guid() and
xsc_activate_hw_config() check and update guid_valid, guid, and
hw_config_activated (and xsc_hw_setup() updates xdev->board_info->msg_opcod=
e)
without holding board_info_lock or using memory barriers. Two PCI functions
probing in parallel can both see guid_valid =3D=3D 0 or hw_config_activated=
 =3D=3D 0
and issue duplicate XSC_CMD_OP_QUERY_GUID and XSC_CMD_OP_ACTIVATE_HW_CONFIG
commands or observe guid_valid =3D=3D 1 before the store to guid is visible.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104155650.3705=
3-1-tianx@yunsilicon.com?part=3D4
