Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51D64F3902
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 11:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791891971; cv=none; b=OXzLP5e6D7P7W0MKq+RAJjnMSkkj1O6foAcpiu8SPW9w0pfK9JsZf9dUuS+aWhb6iWHBI7+0IdnjkVz/mR0tj3KAvCoAX4dSMiBJcGjRofmHWgO3ODaWyUwWZNyci4ZXyll5lkC5oU9IdVpzXSrZuJQrAwYiM41PRZCuxu8cflc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791891971; c=relaxed/simple;
	bh=laLRWIlMrZxJmcy0a31Gl+ioS2R5XtYGEVcMGMUAKpk=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=B2oGJE+UNgsJFttkiY+Ld5IEZlpDS1tUWwAv2dP9NuFsKeuCTFO3UQ7RxJyhwGBZhkvKu6MCDjF+EcpCLfTYIsltxuDkJam4t3SCgP/V7NxODob6lO0VlDG3EUzK4GqYFbep2Z+lxH1rJ289458ptLd/yyOLmfhOoRnebTpRsmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NTJGHfPu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NTJGHfPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1351F000FF;
	Tue, 13 Oct 2026 11:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791891969;
	bh=/dRYpeI2wvrneo73mCPpf/JD1gWmhbDnnBxFRwipu60=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NTJGHfPug0447lCoAPPlA1/mXmh0clT7bU/hKcyBvvTnMNoA0P2FgqLmEM072S3DE
	 LP4QJ6JR3kd/LtVG2gjMU1oOJGMyD+yajGdDzk7FMsbDvrGJrAwkvl7JlSQCq5EzgQ
	 Xhjmtc8NTeMaJqGIjRQEkURij9gFhrmU3HCeMr4v/Z9qxDx6VsJ/0uJBU6BL5RZ/By
	 5vAnKbQ7V/+UQyXnjp5nmapE8EkiQP6dcuwa3oxO1uhx7TuQUqVy/pfw4yGFwA/WAC
	 aVYOX+NdNamWwILc8AXrIzwp5TzPQI9Sf7W8Q7JTk48CC35+ewMikHy9NGNYr5Ybaq
	 KPdndnwEsD8ug==
Message-ID: <sashiko-outbox-169642@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 05/15] yunsilicon: add the CQ and QP resource pools
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261012114402.2471317-6-tianx@yunsilicon.com>
References: <20261012114352.2471317-1-tianx@yunsilicon.com>
 <20261012114402.2471317-6-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 11:46:09 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 8 potential issue(=
s) to consider:
- [High] networking-core: UAF in xsc_cq_completion due to missing RCU grace=
 period
- [High] networking-drivers: Race condition exposing uninitialized QP state=
 and NULL callbacks
- [High] networking-core: RCU Use-After-Free in xsc_cq_completion due to mi=
ssing synchronize_rcu()
- [High] Infinite loop in xsc_set_cq_buf_pa if max_cmd_in_len is small
- [Medium] networking-drivers: Resource leak and synchronization bypass on =
HW teardown error
- [Medium] networking-drivers: Dead code and masked HW errors due to xsc_cm=
d_exec status override
- [Medium] networking-drivers: in_hdr->ver is unconditionally zeroed out in=
 xsc_cmd_exec
- [Low] networking-drivers: Endianness mismatch printing __be16 with %d
--

commit 395a471908d4219d4c81557da37b36e1a6d0b7d1
Author: Xin Tian <tianx@yunsilicon.com>

    yunsilicon: add the CQ and QP resource pools
   =20
    Add the core-side completion queue and queue pair pools: the CQ/QP
    table management, the create/destroy/drain helpers and the EQ dispatch
    of CQ completion, CQ error and QP events.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/cq.c b/drivers/net/e=
thernet/yunsilicon/xsc/pci/cq.c
> new file mode 100644
> index 0000000000000..39715682fecc3
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/cq.c
[ ... ]
> +static int xsc_set_cq_context(struct xsc_core_device *xdev,
> +			      struct xsc_cq_context_ex *ctx_ex,
> +			      u32 *pa_list_base, u32 *cqn)
> +{
> +	struct xsc_set_cq_context_mbox_in in;
> +	struct xsc_set_cq_context_mbox_out out;
> +	int err;
> +
> +	memset(&in, 0, sizeof(in));
> +	memcpy(&in.ctx_ex, ctx_ex, sizeof(*ctx_ex));
> +	in.hdr.opcode =3D cpu_to_be16(XSC_CMD_OP_SET_CQ_CONTEXT);
> +	in.hdr.ver =3D cpu_to_be16(CMD_SET_CQ_CONTEXT_V1);
> +
> +	memset(&out, 0, sizeof(out));
> +	err =3D xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));

[Severity: Medium]
Does xsc_cmd_exec() preserve the version parameter set here? It looks like
xsc_cmd_exec() might unconditionally zero out in_hdr->ver before dispatching
the command to hardware, which would discard the CMD_SET_CQ_CONTEXT_V1 flag.

> +	if (err || out.hdr.status) {
> +		pci_err(xdev->pdev, "failed to set cq context\n");
> +		return -EIO;
> +	}
> +
> +	*pa_list_base =3D be32_to_cpu(out.cq_pa_list_base);
> +	*cqn =3D be32_to_cpu(out.cqn);
> +	return 0;
> +}
> +
> +static int xsc_set_cq_buf_pa(struct xsc_core_device *xdev,
> +			     struct xsc_create_cq_ex_mbox_in *req,
> +			     u32 pa_list_base, u32 cqn)
> +{
> +	struct xsc_set_cq_buf_pa_mbox_in *in;
> +	struct xsc_set_cq_buf_pa_mbox_out out;
> +	u32 pa_num_total =3D be32_to_cpu(req->ctx_ex.pa_num_ex);
> +	u32 pa_num_max =3D (xdev->caps.max_cmd_in_len - sizeof(*in)) / sizeof(_=
_be64);
> +	u32 pa_num_left =3D pa_num_total;
> +	u32 pa_num, copy_len;
> +	int in_len, err;
> +
> +	while (pa_num_left) {
> +		pa_num =3D min(pa_num_max, pa_num_left);

[Severity: High]
Could this result in an infinite loop if the hardware returns a capability
where max_cmd_in_len is small (e.g., between 16 and 23)? pa_num_max would
evaluate to 0, causing pa_num to be 0. The loop would never decrement
pa_num_left and run infinitely. If max_cmd_in_len is < 16, the subtraction
might underflow to a massive unsigned value. Does xsc_cmd_query_hca_cap()
enforce a safe minimum bound?

> +		copy_len =3D pa_num * sizeof(__be64);
> +		in_len =3D sizeof(*in) + copy_len;
[ ... ]
> +int xsc_core_create_cq(struct xsc_core_device *xdev, struct xsc_core_cq =
*cq,
> +		       struct xsc_create_cq_ex_mbox_in *in, int inlen)
> +{
> +	struct xsc_cq_table *table =3D &xdev->dev_res->cq_table;
> +	struct xsc_create_cq_mbox_out out;
> +	u32 pa_list_base =3D 0;
> +	u32 cqn =3D 0;
> +	int err;
> +
> +	if (inlen < xdev->caps.max_cmd_in_len) {
> +		in->hdr.opcode =3D cpu_to_be16(XSC_CMD_OP_CREATE_CQ_EX);
> +		memset(&out, 0, sizeof(out));
> +		err =3D xsc_cmd_exec(xdev, in, inlen, &out, sizeof(out));
> +		if (err)
> +			return err;
> +
> +		if (out.hdr.status && out.hdr.status !=3D XSC_CMD_STATUS_NOT_SUPPORTED)
> +			return xsc_cmd_status_to_err(&out.hdr);
> +
> +		if (out.hdr.status =3D=3D XSC_CMD_STATUS_NOT_SUPPORTED) {
> +			err =3D xsc_create_cq_compat(xdev, in, &out);

[Severity: Medium]
Will this compatibility fallback ever be reached? If xsc_cmd_exec() sees th=
at
out_hdr->status is set, it might return -EIO directly, triggering the earli=
er
if (err) return err; block. This would make the check for
XSC_CMD_STATUS_NOT_SUPPORTED dead code and mask the specific firmware error.

> +			if (err)
> +				return err;
> +		}
[ ... ]
> +int xsc_core_destroy_cq(struct xsc_core_device *xdev, struct xsc_core_cq=
 *cq)
> +{
> +	struct xsc_cq_table *table =3D &xdev->dev_res->cq_table;
> +	struct xsc_destroy_cq_mbox_in in;
> +	struct xsc_destroy_cq_mbox_out out;
> +	struct xsc_core_cq *tmp;
> +	int err;
> +
> +	spin_lock_irq(&table->lock);
> +	tmp =3D radix_tree_delete(&table->tree, cq->cqn);
> +	spin_unlock_irq(&table->lock);
> +	if (!tmp || tmp !=3D cq) {
> +		pci_warn(xdev->pdev, "cq 0x%x not found in tree\n", cq->cqn);
> +		return -EINVAL;
> +	}
> +
> +	memset(&in, 0, sizeof(in));
> +	memset(&out, 0, sizeof(out));
> +	in.hdr.opcode =3D cpu_to_be16(XSC_CMD_OP_DESTROY_CQ);
> +	in.cqn =3D cpu_to_be32(cq->cqn);
> +
> +	err =3D xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
> +	if (err)
> +		return err;
> +
> +	if (out.hdr.status)
> +		return xsc_cmd_status_to_err(&out.hdr);

[Severity: Medium]
If the hardware command fails, returning early here skips the refcount
decrement and the wait_for_completion() synchronization. Can this leak the
resource if the base reference is never dropped, or cause a use-after-free
for active concurrent event handlers if the caller frees the memory anyway?

[Severity: High]
Since the CQ is deleted from the RCU-protected radix tree above, shouldn't
there be a synchronize_rcu() or kfree_rcu() wait before returning? Without
an RCU grace period, concurrent lockless readers (like xsc_cq_completion)
might access the CQ structure after the caller frees the memory.

> +
> +	if (atomic_dec_and_test(&cq->refcount))
> +		complete(&cq->free);
> +	wait_for_completion(&cq->free);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(xsc_core_destroy_cq);
> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/eq.c b/drivers/net/e=
thernet/yunsilicon/xsc/pci/eq.c
> index d273a42d6ffe7..ff4bcb42b33ff 100644
> --- a/drivers/net/ethernet/yunsilicon/xsc/pci/eq.c
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/eq.c
> @@ -53,16 +53,59 @@ static void eq_update_ci(struct xsc_eq *eq, int arm)
> =20
>  static void xsc_cq_completion(struct xsc_core_device *xdev, u32 cqn)
>  {
> +	struct xsc_cq_table *table =3D &xdev->dev_res->cq_table;
> +	struct xsc_core_cq *cq;
> +
> +	rcu_read_lock();
> +	cq =3D radix_tree_lookup(&table->tree, cqn);
> +	if (likely(cq))
> +		atomic_inc(&cq->refcount);

[Severity: High]
Is this lockless RCU lookup safe for an object being destroyed? The teardown
path in xsc_core_destroy_cq() deletes the CQ from the tree without waiting
for an RCU grace period. Additionally, shouldn't this use
atomic_inc_not_zero() instead of atomic_inc() to avoid resurrecting an
object that might already have its refcount at 0?

> +	rcu_read_unlock();
[ ... ]
> +static void xsc_eq_cq_event(struct xsc_core_device *xdev,
> +			    u32 cqn, int event_type)
> +{
> +	struct xsc_cq_table *table =3D &xdev->dev_res->cq_table;
> +	struct xsc_core_cq *cq;
> +
> +	spin_lock(&table->lock);
> +	cq =3D radix_tree_lookup(&table->tree, cqn);
> +	if (likely(cq))
> +		atomic_inc(&cq->refcount);
> +	spin_unlock(&table->lock);
> +
> +	if (unlikely(!cq)) {
> +		pci_err(xdev->pdev, "Async event for bogus CQ, cqn=3D%d\n",
> +			cqn);
> +		return;
> +	}
> +
> +	cq->event(cq, event_type);

[Severity: High]
Is it possible for cq->event to be NULL here? The CQ is added to the global
radix tree in xsc_core_create_cq() before the caller has a chance to
initialize the cq->event callback. If an interrupt arrives immediately, this
could cause a NULL pointer dereference.

> +
> +	if (atomic_dec_and_test(&cq->refcount))
> +		complete(&cq->free);
>  }
> =20
>  static int xsc_eq_int(struct xsc_core_device *xdev, struct xsc_eq *eq)
[ ... ]
> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/qp.c b/drivers/net/e=
thernet/yunsilicon/xsc/pci/qp.c
> new file mode 100644
> index 0000000000000..8ea57a09f6ceb
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/qp.c
> @@ -0,0 +1,356 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
> + * All rights reserved.
> + */
> +
> +#include <linux/gfp.h>
> +#include <linux/time.h>
> +#include <linux/export.h>
> +#include <linux/kthread.h>
> +
> +#include "common/xsc_core.h"
> +#include "common/xsc_cmd_api.h"
> +#include "qp.h"
> +
> +int xsc_core_create_resource_common(struct xsc_core_device *xdev,
> +				    struct xsc_core_qp *qp)
> +{
> +	struct xsc_qp_table *table =3D &xdev->dev_res->qp_table;
> +	int err;
> +
> +	spin_lock_irq(&table->lock);
> +	err =3D radix_tree_insert(&table->tree, qp->qpn, qp);
> +	spin_unlock_irq(&table->lock);
> +	if (err)
> +		return err;
> +
> +	atomic_set(&qp->refcount, 1);
> +	init_completion(&qp->free);

[Severity: High]
Should the refcount and completion be initialized before the QP is inserted
into the radix tree? Once inserted, asynchronous event handlers like
xsc_qp_event() can look up the QP. If an event fires immediately, the
handler might execute atomic_inc(&qp->refcount) on uninitialized memory,
which is then clobbered by atomic_set() here.

> +	qp->pid =3D current->pid;
> +
> +	return 0;
> +}
[ ... ]
> +void xsc_qp_event(struct xsc_core_device *xdev, u32 qpn, int event_type)
> +{
> +	struct xsc_qp_table *table =3D &xdev->dev_res->qp_table;
> +	struct xsc_core_qp *qp;
> +
> +	spin_lock(&table->lock);
> +
> +	qp =3D radix_tree_lookup(&table->tree, qpn);
> +	if (qp)
> +		atomic_inc(&qp->refcount);
> +
> +	spin_unlock(&table->lock);
> +
> +	if (!qp) {
> +		pci_err(xdev->pdev, "Async event for bogus QP 0x%x\n", qpn);
> +		return;
> +	}
> +
> +	qp->event(qp, event_type);

[Severity: High]
Can qp->event be NULL here? The QP is published to the radix tree before the
caller initializes the qp->event function pointer. An early interrupt could
trigger a NULL pointer dereference.

> +
> +	if (atomic_dec_and_test(&qp->refcount))
> +		complete(&qp->free);
> +}
[ ... ]
> +int xsc_core_eth_create_rss_qp_rqs(struct xsc_core_device *xdev,
> +				   struct xsc_create_multiqp_mbox_in *in,
> +				   int insize,
> +				   u32 *p_qpn_base)
> +{
> +	struct xsc_create_multiqp_mbox_out out;
> +	int err;
> +
> +	in->hdr.opcode =3D cpu_to_be16(XSC_CMD_OP_CREATE_MULTI_QP);
> +	err =3D xsc_cmd_exec(xdev, in, insize, &out, sizeof(out));
> +	if (err) {
> +		pci_err(xdev->pdev,
> +			"failed to create rss rq, qp_num=3D%d, type=3D%d, err=3D%d out.status=
=3D%u\n",
> +			in->qp_num, in->qp_type, err, out.hdr.status);

[Severity: Low]
Is it intentional to pass in->qp_num directly to %d? Since in->qp_num is a
__be16 field, this will print garbled values on little-endian architectures
unless converted with be16_to_cpu().

> +		return err;
> +	}
[ ... ]
> +int xsc_core_destroy_qp(struct xsc_core_device *xdev,
> +			struct xsc_core_qp *qp)
> +{
> +	struct xsc_destroy_qp_mbox_in in;
> +	struct xsc_destroy_qp_mbox_out out;
> +	int err;
> +
> +	xsc_core_destroy_resource_common(xdev, qp);
> +
> +	memset(&in, 0, sizeof(in));
> +	memset(&out, 0, sizeof(out));
> +	in.hdr.opcode =3D cpu_to_be16(XSC_CMD_OP_DESTROY_QP);
> +	in.qpn =3D cpu_to_be32(qp->qpn);
> +
> +	err =3D xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
> +	if (err)
> +		return err;
> +
> +	if (out.hdr.status)
> +		return xsc_cmd_status_to_err(&out.hdr);

[Severity: Medium]
Does returning early here skip decrementing the global active QP counter
(atomic_dec(&xdev->num_qps))? In xsc_core_create_qp(), num_qps is increment=
ed
after resource creation, but a failure in the hardware destroy path seems
to leak this counter.

> +
> +	atomic_dec(&xdev->num_qps);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(xsc_core_destroy_qp);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012114352.2471=
317-1-tianx@yunsilicon.com?part=3D5
