Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894974;
	b=qw+Lg73GAa3mIH3OYGdhCUbX19moyFM9qxjQ/8vjriqJiKD/v01w3PlpFmOek6Esq80p
	 tqrqarxhrbBZ2mU8lsytnbTnzja/JpNHbQY/8AOw+iOG+ZSxvfNSENSrSuRubEq90zI5O
	 YfKW4d+WxheV+25M8t215JrKC7U+6DX4paTnXDYu1HL289B0/A0Ey6nKM8zC7NghLgzxu
	 Fvms+wfAKe58FdEMi7rpX1oMWKY/3ybqCC6Sf7qzkfLIe0t+P3ZZbfk8ENsQyFAK88bIP
	 y8Cp+efUEbs+oPEkR913nQcv74Mw3M3Ut3pful8xNGIUbgsrtCRyi0WpXtGU6vx72Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894974;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=R4en3EvASWFvefQIxBELmfW29YDrS85bNeY4PbgWIGI=;
	b=bovTv1CmW/A0HPsW0mJQZ6BtdwOGY/2eNSuV5oPaVuB5aHnN69pPHYJteZ6w8nu5WkH4
	 7vgvnOnTLIrd3inicFGHqNeE0ZHoMrv+iJuPZj53aLQgkIohw+tvFl9Ap1BKLoDTViWSm
	 mZJJALz8EpItEa68vmuDDZLCf4+SaB5iuaUfKpn1MtPM9SoEGSVqJZGLi2WR5iHCOWmxx
	 92JI+Q8hJa3UFkdUhEJ6NEkzslgVp7on7DqrPxJGT/Pb3GK+LLv5aDocagQyVKIztYtrI
	 BmKxURFxyTK7o7gYklOMUxqVBER7GvQa7yHQEQNBdBwolu9aXe/vxGnb7FoLGNIUYTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hKPhC0TU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6B7606BE86
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 16:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hKPhC0TU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44AB1F00919;
	Thu,  5 Nov 2026 16:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894973;
	bh=R4en3EvASWFvefQIxBELmfW29YDrS85bNeY4PbgWIGI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hKPhC0TUfDmn13yQwomkv2bX8Pv+ujqexMQ1XXpIi6OhowtCVozEEUZX/iMRlOSvI
	 Cv///pwcMhWzjh6N1BHmTC7BdKSu9BuLK/q3rB9kvnC082YDPRD5L1uor420JcBbvF
	 atK9yp7VoAowGba/0QQ2LTy57JtgrlG0cZyLM+PWH02pQNdUFuCgBC2ruQMHHtpSSB
	 5W1aAuJOqnwPHRtD2xVZUnx/maFC/GZ+QdHh1u/+noykRFqCopIAbiN8FkKFu98mMk
	 ryT/sbk4badqQrc5X7XfB2mee9jPfPqfb5M1YsUDea2ClY4PC+J9v85C0j2eJPVPGx
	 f0OA0pR+pcLfg==
Message-ID: <sashiko-outbox-199428@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 06/15] net/xsc: add the CQ and QP resource pools
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104155703.37053-7-tianx@yunsilicon.com>
References: <20261104155650.37053-1-tianx@yunsilicon.com>
 <20261104155703.37053-7-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 16:09:33 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] net/xsc: premature DESTROY_CQ and skipped refcount wait in CQ tear=
down
- [Medium] net/xsc: missing abort on invalid radix tree delete in xsc_core_=
destroy_cq()
- [Medium] net/xsc: inverted CQ/QP destroy ordering and inaccurate commit d=
escription
- [Low] net/xsc: duplicated CQ teardown in xsc_core_destroy_cq() and change=
log mismatch
--

commit bc5206144b3c6edd9114d2a7f0311c3a018b5c6a
Author: Xin Tian <tianx@yunsilicon.com>

net/xsc: add the CQ and QP resource pools

This commit adds the device-wide radix-tree registries and lifecycle helpers
for completion queues and queue pairs, and wires completion and asynchronous
events from EQs into their respective callbacks.

>     net/xsc: add the CQ and QP resource pools
>    =20
>     Add the device-wide registries for completion queues and queue pairs,
>     and wire completion events from the EQs into them.
>    =20
>     CQs and QPs live in radix trees keyed by CQN and QPN and are looked
>     up from the EQ dispatch under RCU with a reference count taken on
>     hit; destroy removes the entry, synchronizes RCU and waits for
>     in-flight users before issuing the firmware destroy command, so a
>     completion arriving concurrently with teardown cannot touch freed
>     memory.  QP destroy issues two RST transitions first to drain
>     pending work.
>    =20
>     Provide two CQ creation paths: a legacy one used by the ethernet
>     function, and an extended one used by RDMA that falls back to the
>     legacy command when firmware rejects it and splits large contexts
>     into a context command followed by chunked buffer-address commands
>     when the context exceeds the maximum command payload.  New CQs are
>     armed after creation.
>    =20
>     Add the QP creation, destruction and state transition helpers,
>     including raw-TSO queues and multi-QP RSS receive queues needed by
>     the ethernet function, and route asynchronous QP events to the
>     event callback stored in the core QP.
>    =20
>     Signed-off-by: Xin Tian <tianx@yunsilicon.com>

[Severity: Medium]
Does the commit message match what the patch actually implements in a few
places?

First, the changelog states that both CQs and QPs are looked up under RCU
and synchronized with RCU on destroy, whereas xsc_qp_event() and
xsc_eq_cq_event() perform radix_tree_lookup() under spin_lock(&table->lock),
and xsc_core_destroy_resource_common() does not call synchronize_rcu().

Second, the changelog states that destroy waits for in-flight users before
issuing the firmware destroy command, but both xsc_core_eth_destroy_cq() and
xsc_core_destroy_cq() issue XSC_CMD_OP_DESTROY_CQ before decrementing
refcount and calling wait_for_completion().

Third, the changelog states that QP destroy issues two RST transitions
first, which appears to misread the opcode name XSC_CMD_OP_2RST_QP
(transition to RST): xsc_core_eth_destroy_qp() issues a single
XSC_CMD_OP_2RST_QP command, and xsc_core_destroy_qp() does not issue a RST
transition at all.

[ ... ]

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/cq.c b/drivers/net/e=
thernet/yunsilicon/xsc/pci/cq.c
> new file mode 100644
> index 0000000000000..e3e13ef531988
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/cq.c
> @@ -0,0 +1,319 @@

[ ... ]

> +static int xsc_destroy_cq(struct xsc_core_device *xdev, u32 cqn)
> +{
> +	struct xsc_destroy_cq_mbox_out out;
> +	struct xsc_destroy_cq_mbox_in in;
> +
> +	memset(&in, 0, sizeof(in));
> +	memset(&out, 0, sizeof(out));
> +	in.hdr.opcode =3D cpu_to_be16(XSC_CMD_OP_DESTROY_CQ);
> +	in.cqn =3D cpu_to_be32(cqn);
> +
> +	return xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
> +}

[ ... ]

> +int xsc_core_eth_destroy_cq(struct xsc_core_device *xdev,
> +			    struct xsc_core_cq *xcq)
> +{
> +	struct xsc_cq_table *table =3D &xdev->dev_res->cq_table;
> +	struct xsc_core_cq *tmp;
> +	int err;
> +
> +	spin_lock_irq(&table->lock);
> +	tmp =3D radix_tree_delete(&table->tree, xcq->cqn);
> +	spin_unlock_irq(&table->lock);
> +	if (!tmp) {
> +		err =3D -ENOENT;
> +		goto err_delete_cq;
> +	}
> +
> +	if (tmp !=3D xcq) {
> +		err =3D -EINVAL;
> +		goto err_delete_cq;
> +	}
> +
> +	/* the completion reader looks the cq up under rcu_read_lock and
> +	 * takes its reference afterwards; wait for it before dropping
> +	 * the tree reference so it never touches a freed cq
> +	 */
> +	synchronize_rcu();
> +
> +	err =3D xsc_destroy_cq(xdev, xcq->cqn);
> +	if (err)
> +		goto err_destroy_cq;
> +
> +	if (atomic_dec_and_test(&xcq->refcount))
> +		complete(&xcq->free);
> +	wait_for_completion(&xcq->free);
> +	return 0;

[Severity: High]
Should atomic_dec_and_test(&xcq->refcount) and
wait_for_completion(&xcq->free) happen before xsc_destroy_cq() here (and
likewise before xsc_cmd_exec() in xsc_core_destroy_cq())?

In xsc_cq_completion(), rcu_read_lock() only covers radix_tree_lookup() and
atomic_inc(&cq->refcount):

drivers/net/ethernet/yunsilicon/xsc/pci/eq.c:xsc_cq_completion() {
	rcu_read_lock();
	cq =3D radix_tree_lookup(&table->tree, cqn);
	if (likely(cq))
		atomic_inc(&cq->refcount);
	rcu_read_unlock();
	...
	if (!cq->comp)
		pci_err(xdev->pdev, "cq->comp is NULL\n");
	else
		cq->comp(cq);

	if (atomic_dec_and_test(&cq->refcount))
		complete(&cq->free);
}

Similarly, xsc_eq_cq_event() drops table->lock before calling cq->event().

Because cq->comp() and cq->event() run outside rcu_read_lock() and
table->lock, synchronize_rcu() only guarantees that no new reader can take a
reference; it does not wait for an in-flight callback that already took a
reference to finish. Issuing XSC_CMD_OP_DESTROY_CQ before waiting on
xcq->free destroys the hardware CQ (allowing the firmware to reassign the
CQN) while cq->comp() or cq->event() is still executing on another CPU.

Furthermore, if xsc_destroy_cq() fails and jumps to err_destroy_cq, xcq has
already been deleted from table->tree, but the function returns without
waiting for in-flight callbacks on xcq->free. If the caller frees xcq after
destroy returns, an in-flight xsc_cq_completion() or xsc_eq_cq_event() will
access freed memory; if the caller retries xsc_core_eth_destroy_cq(),
radix_tree_delete() will return NULL and fail with -ENOENT without
destroying the firmware CQ.

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
> +	if (!tmp || tmp !=3D cq)
> +		pci_warn(xdev->pdev, "cq 0x%x not found in tree\n", cq->cqn);

[Severity: Medium]
If !tmp or tmp !=3D cq here, shouldn't xsc_core_destroy_cq() abort and retu=
rn
an error instead of continuing after pci_warn()?

If the entry was not found (for instance, if a prior destroy call deleted it
from table->tree before failing in xsc_cmd_exec(), or on a duplicate
destroy), continuing will execute XSC_CMD_OP_DESTROY_CQ and then call
atomic_dec_and_test(&cq->refcount) followed by
wait_for_completion(&cq->free). If cq->refcount was already decremented, it
will underflow to -1 and hang indefinitely in wait_for_completion().

Also, in both xsc_core_eth_destroy_cq() and xsc_core_destroy_cq(), calling
radix_tree_delete(&table->tree, cq->cqn) before verifying that the stored
entry matches cq will remove an unrelated active CQ (tmp) from table->tree
when tmp !=3D cq. Would it be safer to check radix_tree_lookup() under
table->lock before deleting?

> +
> +	/* wait for lockless completion readers as in
> +	 * xsc_core_eth_destroy_cq()
> +	 */
> +	synchronize_rcu();
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
> +	if (atomic_dec_and_test(&cq->refcount))
> +		complete(&cq->free);
> +	wait_for_completion(&cq->free);
> +
> +	return 0;
> +}

[Severity: Low]
This isn't a bug, but xsc_core_destroy_cq() open-codes xsc_destroy_cq() and
duplicates the radix-tree removal, synchronize_rcu(), and completion wait
sequence from xsc_core_eth_destroy_cq(). Could xsc_core_destroy_cq() and
xsc_core_eth_destroy_cq() share this teardown logic?

[ ... ]

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/qp.c b/drivers/net/e=
thernet/yunsilicon/xsc/pci/qp.c
> new file mode 100644
> index 0000000000000..bbcdb18e1b84f
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/qp.c
> @@ -0,0 +1,355 @@

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
> +	atomic_dec(&xdev->num_qps);
> +	return 0;
> +}

[Severity: Medium]
If xsc_cmd_exec() fails in xsc_core_destroy_qp(), xsc_core_destroy_resource=
_common()
has already removed qp from qp_table.tree and consumed its initial refcount,
while xdev->num_qps remains incremented. How should a caller recover if
XSC_CMD_OP_DESTROY_QP fails after the QP has been removed from the resource
table?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104155650.3705=
3-1-tianx@yunsilicon.com?part=3D6
