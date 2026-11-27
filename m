Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795795078;
	b=Yb4YF6OzqmbmfZ4cLR5DJPi4Y4oa6CAZnhKvFHWQR80U9o7oC4mYpNQ9cNWXB+r5olaM
	 ZUWseDzoP5ShYt1cEaZh2Zxjiob72gcFceJT0qJiBjyrYUqv42T9zCbJ6lg2yiaEjp6og
	 Jnvkrgvjz4Ebp7uCmMObw+xEdsGuV/9zHX3kMTWohdxuMPz2sxnu3UcTdLGUOHi+gstmy
	 rxkrG3x8KUVNU1vXfIKRJX11DSBWs4YUgGyr87RH9xFtfoNkt2ZKVJSo8keVSkfNCLwm6
	 qHelUXM+4t+UaMbBp4u1MTg7nLQ1OcuTon18SlPRPL5dKPR425OFwQU/LL86Fh7Zh2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795795078;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=CaGjZ7Qa/8r7tjAhcAhlRFfNpWOKffHv2FSk601Qvkk=;
	b=wJqshiWhWqQeLQ68DWkTFJkCc/LDm1z4wDwQdGPqoTLe1aCBLotRb5FGv3VbqrvMbeWd
	 s+gojZxuBqi6klfq8CeyLcU1nJwYBEv7NCRCJkBr+Sj1USv1/C57kHbzg/HqXod3OkLG0
	 KfHL/zGsTtlZjnVQtQKOa5Qu50C5IeT6v5RixhqBHJZFuR3nx1OWTJhSPxLWe8DrLL6aM
	 NPMYRBvi9Fkm+KbzFhIUeTx3rzelN+7DKJwlQXhjnEXkaqsU6uqYSuj0OvdjzNVnSahE+
	 y72HaE8qHfc/u0fMDK1s8yi0qbpVZ1Ny2fBl7v5qwz29be29+fLQMTJ7QQiLrm41NYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=idUnLnxs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABAB606A326;
	Fri, 27 Nov 2026 15:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=idUnLnxs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9701F00919;
	Fri, 27 Nov 2026 15:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795795078;
	bh=CaGjZ7Qa/8r7tjAhcAhlRFfNpWOKffHv2FSk601Qvkk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=idUnLnxs2qeTthtFiA1Nox7MD/lPKxJNFca8H9gbffP0dsiBDpguhSIO0eKCNyTIO
	 IZ8/OdlT/IjoP69vdNxE+2SW2jlsn9t1pMqP/0FqAESt4tCDxeCkw6Xaks7bsuDKDo
	 VcnoBcKpjwguVfzdz8vx6PENPPmNgXY9xGnRZgkBw0Uf0ldAwAhdJLA5ngsrk2UVcz
	 JSWeORa5aycq2Lp2NVtBzJiL8dAQvS9BibQNY/4jyTY0Z8q9+vr1VfC5tfuwBkOEZ5
	 Hw7kzK9hxN1+hmcCMFFeoRQqEL76w0HqDf41Xsr+X0mJa1r9SU0mb71+2bPII+mdes
	 tB4ZvffUWIS/A==
Subject: Re: [PATCH v2 06/11] net/xsc: add CQ and QP helpers
From: netdev-bot+sashiko@kernel.org
To: tianx@yunsilicon.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, jgg@ziepe.ca, leon@kernel.org,
 huangjunxian6@hisilicon.com, weihg@yunsilicon.com,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, kerneljasonxing@gmail.com
Date: Fri, 27 Nov 2026 15:57:57 +0000
Message-ID: <179579507706.3135.12238248578368681777@kernel.org>
In-Reply-To: <20261126145727.70868-7-tianx@yunsilicon.com>
References: <20261126145727.70868-7-tianx@yunsilicon.com>
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

Thank you for your contribution! Sashiko AI review found 8 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 7

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] In xsc_core_eth_destroy_cq()
  (drivers/net/ethernet/yunsilicon/xsc/pci/cq.c), the CQ is taken out of…
- [Low] xsc_eq_int() in drivers/net/ethernet/yunsilicon/xsc/pci/eq.c
  groups XSC_EVENT_TYPE_INTERNAL_ERROR (0x08, defined in enum xsc_event…
- [Low] xsc_cq_completion() ('Completion event for bogus CQ'),
  xsc_eq_cq_event() ('Async event for bogus CQ') and xsc_qp_event()…
- [Low] The CQ/QP number widths do not agree across three places.
- [Low] The comment in xsc_core_eth_destroy_cq() (cq.c lines 106-109)
  says the completion reader 'looks the cq up under rcu_read_lock and…
- [Low] The exported helper xsc_core_eth_modify_qp_status(xdev, qpn, u16
  status) (prototype in xsc_core.h, implementation in qp.c) and its…
- [Low] Several new messages print unsigned u32 CQ/QP numbers with %d:
  cq.c xsc_core_eth_create_cq() and xsc_core_eth_destroy_cq() ('failed…
- [Low] xsc_core_eth_destroy_qp() (qp.c lines 134-159) first moves the QP
  to RST with xsc_core_eth_modify_qp_status(..., XSC_CMD_OP_2RST_QP).

--

net/xsc: add CQ and QP helpers

This patch adds CQ and QP radix tree tables to the xsc PCI core, along
with exported ethernet helpers to create, destroy and modify CQs and QPs.
It also dispatches completion, CQ error and WQ error events from
xsc_eq_int() to the registered CQ/QP callbacks.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/cq.c b/drivers/net/ethernet/yunsilicon/xsc/pci/cq.c
> new file mode 100644
> index 0000000000000..a4f9b488d659d
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/cq.c
> @@ -0,0 +1,130 @@

[ ... ]

> +static int xsc_create_cq(struct xsc_core_device *xdev, u32 *p_cqn,
> +			 struct xsc_create_cq_mbox_in *in, int insize)
> +{

[ ... ]

> +	*p_cqn = be32_to_cpu(out.cqn) & 0xffffff;
> +	return 0;
> +}

[Severity: Low]
The CQN kept here is 24 bits wide. xsc_core_eth_create_qp() keeps a
24-bit QPN the same way. Both are used as radix tree keys, but the EQE
that xsc_eq_int() uses to look them up only carries 15 bits:

eq.h:
#define XSC_EQE_QUEUE_ID_MASK	GENMASK(14, 0)

The mailbox fields that carry the same IDs (cqn_send, cqn_recv and
input_qpn in xsc_create_qp_request, qpn in xsc_modify_raw_qp_request) are
__be16, and the eth driver casts them with (u16).

If firmware ever returned an ID of 0x8000 or above, would EQE lookups for
that object miss and get reported as bogus? Could they instead alias
another registered CQ/QP and run its callback? Should the create path
reject IDs that don't fit in the EQE queue_id field?

[ ... ]

> +int xsc_core_eth_destroy_cq(struct xsc_core_device *xdev,
> +			    struct xsc_core_cq *xcq)
> +{
> +	struct xsc_cq_table *table = &xdev->cq_table;
> +	struct xsc_core_cq *tmp;
> +	int err;
> +
> +	spin_lock_irq(&table->lock);
> +	tmp = radix_tree_delete(&table->tree, xcq->cqn);
> +	spin_unlock_irq(&table->lock);

[ ... ]

> +	/* the completion reader looks the cq up under rcu_read_lock and
> +	 * takes its reference afterwards; wait for it before dropping
> +	 * the tree reference so it never touches a freed cq
> +	 */
> +	synchronize_rcu();

[Severity: Low]
This isn't a bug, but the comment doesn't match xsc_cq_completion(). That
function takes the reference inside the RCU read-side section, before
rcu_read_unlock():

	rcu_read_lock();
	cq = radix_tree_lookup(&table->tree, cqn);
	if (likely(cq))
		atomic_inc(&cq->refcount);
	rcu_read_unlock();

That placement is what lets synchronize_rcu() order against the final
atomic_dec_and_test(). If atomic_inc() were moved after rcu_read_unlock()
to match the comment, the result would be a use-after-free.

The comment also leaves out xsc_eq_cq_event(), which uses table->lock
rather than RCU. It also doesn't say that any use after the RCU section is
protected only by the refcount and the completion.

Could the comment be updated to describe this accurately?

> +
> +	err = xsc_destroy_cq(xdev, xcq->cqn);
> +	if (err)
> +		goto err_destroy_cq;
> +
> +	if (atomic_dec_and_test(&xcq->refcount))
> +		complete(&xcq->free);
> +	wait_for_completion(&xcq->free);
> +	return 0;
> +
> +err_destroy_cq:
> +	pci_err(xdev->pdev, "failed to destroy cqn=%d, err=%d\n",
> +		xcq->cqn, err);
> +	return err;

[Severity: Medium]
What happens to the CQ if xsc_destroy_cq() fails here?

By then radix_tree_delete() has already removed the CQ from cq_table. The
err_destroy_cq path only logs and returns. It never drops the tree
reference and never calls wait_for_completion(&xcq->free).

synchronize_rcu() doesn't drain handlers that already hold a reference.
xsc_cq_completion() calls cq->comp() after rcu_read_unlock():

xsc_cq_completion()
    rcu_read_lock();
    cq = radix_tree_lookup(...);
    atomic_inc(&cq->refcount);
    rcu_read_unlock();
    cq->comp(cq);
    atomic_dec_and_test(&cq->refcount) -> complete(&cq->free)

xsc_eq_cq_event() takes its reference under table->lock, with no RCU at
all. Only the refcount wait covers these handlers, and this error path
skips it.

The hardware CQ also can't be destroyed afterwards. A retry of
xsc_core_eth_destroy_cq() finds nothing in the tree and returns -ENOENT
without sending DESTROY_CQ again.

Later in the series, xsc_eth_close_cq() leaks the CQ buffer on failure,
which avoids DMA into freed pages. xsc_eth_close_channel() then does:

	xsc_eth_close_cq(c, &c->qp.rq.cq);
	memset(&c->qp.rq, 0, sizeof(struct xsc_rq));

and the same for c->qp.sq. Suppose a handler that wasn't drained loaded
cq->comp before the memset. Could xsc_eth_comp() then read a zeroed
cq->napi and call napi_schedule(NULL)?

On non-RT kernels the hardirq handler usually finishes long before a
failed firmware round trip completes. With PREEMPT_RT, though, the handler
can be preempted after rcu_read_unlock().

mlx5_core_destroy_cq() has the same delete-before-command ordering and
the same early return, so the pattern isn't unique to xsc. Should this
error path still drop the tree reference and wait on xcq->free before
returning?

> +err_delete_cq:
> +	pci_err(xdev->pdev, "cqn=%d not found in tree, err=%d\n",
> +		xcq->cqn, err);
> +	return err;
> +}

[Severity: Low]
This isn't a bug, but cqn is a u32 printed with %d. Several other new
messages do the same:

  "failed to destroy cqn=%d" in xsc_core_eth_create_cq() and
  xsc_core_eth_destroy_cq()
  "bogus CQ, cqn=%d" and "cq->event is NULL, cqn=%d" in eq.c
  "sq%d" in xsc_core_eth_destroy_qp()

Other messages in qp.c print the same kind of ID as 0x%x or %u. Could
these use one consistent unsigned format?

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/eq.c b/drivers/net/ethernet/yunsilicon/xsc/pci/eq.c
> index 875a277a83cb8..1ebc8941081a8 100644
> --- a/drivers/net/ethernet/yunsilicon/xsc/pci/eq.c
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/eq.c

[ ... ]

> @@ -52,8 +54,63 @@ static void eq_update_ci(struct xsc_eq *eq, int arm)
>  	xsc_update_eq_ci(eq->dev, eq->eqn, eq->cons_index, arm);
>  }
>  
> +static void xsc_cq_completion(struct xsc_core_device *xdev, u32 cqn)
> +{
> +	struct xsc_cq_table *table = &xdev->cq_table;
> +	struct xsc_core_cq *cq;
> +
> +	rcu_read_lock();
> +	cq = radix_tree_lookup(&table->tree, cqn);
> +	if (likely(cq))
> +		atomic_inc(&cq->refcount);
> +	rcu_read_unlock();
> +
> +	if (!cq) {
> +		pci_err(xdev->pdev, "Completion event for bogus CQ, cqn=%d\n",
> +			cqn);
> +		return;
> +	}

[Severity: Low]
This runs from the MSI-X hard IRQ handler, via
xsc_msix_handler()->xsc_eq_int(), and the queue ID comes from the device.
Could a misbehaving device flood the console from hardirq context here?
EQEs that arrive after a CQ/QP has left its table could do the same,
since the destroy helpers delete from the tree before sending the
firmware destroy command.

xsc_eq_cq_event() ("Async event for bogus CQ") and xsc_qp_event() ("Async
event for bogus QP") have the same unratelimited pci_err(). The equivalent
message in mlx5_eq_comp_int() uses dev_dbg_ratelimited().

[ ... ]

> @@ -63,6 +120,32 @@ static int xsc_eq_int(struct xsc_eq *eq)
>  		 * checked the ownership bit.
>  		 */
>  		rmb();
> +		switch (eqe->type) {
> +		case XSC_EVENT_TYPE_COMP:
> +		case XSC_EVENT_TYPE_INTERNAL_ERROR:
> +			queue_id = FIELD_GET(XSC_EQE_QUEUE_ID_MASK,
> +					     le16_to_cpu(eqe->queue_id_data));
> +			cqn = queue_id;
> +			xsc_cq_completion(xdev, cqn);
> +			break;

[Severity: Low]
Is XSC_EVENT_TYPE_INTERNAL_ERROR meant to be handled as a normal
completion?

enum xsc_event lists it with the other error events. xsc_cq_completion()
only calls cq->comp(cq) and drops the event type. So cq->event never sees
an internal error, and nothing is logged for it.

Should this go through xsc_eq_cq_event() like XSC_EVENT_TYPE_CQ_ERROR? Or
does the name not reflect what the hardware reports? The intended
semantics can't be confirmed from the tree.

[ ... ]

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/qp.c b/drivers/net/ethernet/yunsilicon/xsc/pci/qp.c
> new file mode 100644
> index 0000000000000..ca2ad4ab0b42b
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/qp.c
> @@ -0,0 +1,180 @@

[ ... ]

> +int xsc_core_eth_modify_qp_status(struct xsc_core_device *xdev,
> +				  u32 qpn, u16 status)
> +{
> +	struct xsc_modify_qp_mbox_out out = {};
> +	struct xsc_modify_qp_mbox_in in = {};
> +	int ret;
> +
> +	in.hdr.opcode = cpu_to_be16(status);

[Severity: Low]
This isn't a bug with the current callers, but the third argument is
named status and printed as "status=%u", yet it is written straight into
the command opcode.

The only valid values are XSC_CMD_OP_* opcodes, such as
XSC_CMD_OP_2RST_QP and XSC_CMD_OP_RTR2RTS_QP, which is what the in-tree
callers pass. struct xsc_modify_qp_mbox_in also has a real state field,
which stays zero here.

Since this helper is exported, could the argument be renamed (to opcode,
for example)? A future caller could otherwise pass a QP state and send
firmware an invalid opcode.

[ ... ]

> +int xsc_core_eth_destroy_qp(struct xsc_core_device *xdev, u32 qpn)
> +{
> +	struct xsc_destroy_qp_mbox_out out;
> +	struct xsc_destroy_qp_mbox_in in;
> +	int err;
> +
> +	err = xsc_core_eth_modify_qp_status(xdev, qpn, XSC_CMD_OP_2RST_QP);
> +	if (err) {
> +		pci_err(xdev->pdev, "failed to set sq%d status=rst, err=%d\n",
> +			qpn, err);
> +		return err;
> +	}

[Severity: Low]
If the 2RST command fails, this returns without ever sending
XSC_CMD_OP_DESTROY_QP. Does that leak the firmware QP context and its
qpn?

The close paths later in the series, xsc_eth_close_qp_sq() and
xsc_eth_close_qp_rq(), leak the WQ buffers when this returns an error.
The open-path rollbacks in xsc_eth_open_qp_sq() and xsc_eth_open_qp_rq()
ignore the return value:

err_sq_destroy:
	xsc_core_eth_destroy_qp(xdev, psq->cqp.qpn);

The QP has already been removed from qp_table at that point, so it can't
be retried.

Would a best-effort DESTROY_QP after a failed 2RST be worthwhile? The tree
doesn't show whether firmware requires the QP to be in RST before it can
be destroyed.

> +
> +	memset(&in, 0, sizeof(in));
> +	memset(&out, 0, sizeof(out));
> +	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_DESTROY_QP);

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261126145711.70868-1-tianx%40yunsilicon.com
