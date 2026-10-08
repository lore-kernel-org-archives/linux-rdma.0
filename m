Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2437A49B5D7;
	Thu,  8 Oct 2026 12:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791464044; cv=none; b=WPCokUryHSOrhfTDEDQcVjZXAHRQv5LpEbFOZhSI0Mf3ncqLa8O+khuq5zWJUWvrd6r0WqkwWB/2h+evHbNb+qSamPOrqRlGIhjK3PpCwrvYzim3d//X25Q+vKQwoJeleeaNBu+eghSIuycOzysu3ZGuHRMs1wShQB2pTCxB6j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791464044; c=relaxed/simple;
	bh=srfCvY/4aEWZISCq1me9MyUkzioS9cO/PoiykOhsjFQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Mrt3KC7NAAXYlJ0swldmMKM1u8dw3WnElgfNuWlvGELh96BHuBLs2eivu0jOVbAtD4KeglCZV+DvsKMHxT21E657g2W6+KBy38LA2l1j1tJEXx6DpnwuVTje5adzxFsPuHKb0freaijTAm6lale1DblM0GBkKwRwxpUYYZrxVvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e5H7KrRQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e5H7KrRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DC01F00898;
	Thu,  8 Oct 2026 12:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791464042;
	bh=8fl65qiN/3whdxxO+Pebh37Wz7C+ENPtqgMtjZE5Lqc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e5H7KrRQiSz5LJ2VDJYGccm/MdMygcSiu9DxMgqIzj8qHOOnCyZy22SDYIR8Yz/bT
	 4WcrmzhVd6IJueVw61ISO5qAXSETj235x3D5QX4XK3WINZbN4yx4OEOh+L64Yb8vHM
	 ulRrG0uvfRuu9WkPOeiy1iOcjfy5KZY3uTbosxC4Kv6RUO4JpGHhL4qJFVeGL2qwoN
	 1BW3vu1In5sZp/jZDbQsNfYVzH3luD5QX/fo9BElx5cl7fXjHnCzL/lFOLc3awDnwq
	 UoDUF1gyW3Creo3wDiiunjtnjQSoiUrkJ4iRJWYETZQxx6ED/Ur3UwuOMlu9Wv3ojM
	 0aKSZaBXqdv8Q==
Message-ID: <sashiko-outbox-164177@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 1/4] net: mana: prepare HWC ownership for
 safe reinitialization
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <901e5237127da4fbd8e14ff07fa32dec8a20fd84.1790670523.git.weh@linux.microsoft.com>
References: <cover.1790665894.git.weh@linux.microsoft.com>
 <901e5237127da4fbd8e14ff07fa32dec8a20fd84.1790670523.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 12:54:01 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] net: mana: Use-After-Free of CQ during queue teardown due to missi=
ng RCU grace period
--

commit 50d2c3c4bc7f5e569d234a68a7842e4c466d0022
Author: Long Li <longli@microsoft.com>

net: mana: prepare HWC ownership for safe reinitialization

Dynamic HWC queue sizing tears down the bootstrap queues and establishes a
second channel before publishing it. Prepare the existing HWC ownership and
teardown paths so that sequence cannot free or reuse state still reachable
by either the PF or an EQ handler.

Link: https://lore.kernel.org/r/20260908035201.402424-2-longli@microsoft.com
Link: https://lore.kernel.org/r/20260908035201.402424-5-longli@microsoft.com
Link: https://lore.kernel.org/r/178910960115.219967.13830871915506436112@ke=
rnel.org

> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/ne=
t/ethernet/microsoft/mana/gdma_main.c
> index 8e9bfc1d6a2ae..f63e236d4d190 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
[ ... ]
> @@ -922,11 +923,16 @@ static void mana_gd_process_eqe(struct gdma_queue *=
eq)
>  	switch (type) {
>  	case GDMA_EQE_COMPLETION:
>  		cq_id =3D eqe->details[0] & 0xFFFFFF;
> -		if (WARN_ON_ONCE(cq_id >=3D gc->max_num_cqs))
> +		/* The IRQ handler's RCU read-side section protects the table
> +		 * until HWC teardown has fenced its EQ and waited for readers.
> +		 */
> +		cq_table =3D smp_load_acquire(&gc->cq_table);
> +		if (!cq_table || cq_id >=3D READ_ONCE(gc->max_num_cqs))
>  			break;
> =20
> -		cq =3D gc->cq_table[cq_id];
> -		if (WARN_ON_ONCE(!cq || cq->type !=3D GDMA_CQ || cq->id !=3D cq_id))
> +		cq =3D READ_ONCE(cq_table[cq_id]);
> +		if (!cq || WARN_ON_ONCE(cq->type !=3D GDMA_CQ ||
> +					cq->id !=3D cq_id))

[Severity: High]
Can this dereference of cq race with mana_gd_destroy_queue() and cause a
use-after-free?

When the network device is detached (e.g., driver unload or suspend),
mana_dealloc_queues() destroys Ethernet CQs via mana_destroy_rxqs() and
mana_destroy_txq() before destroying the Ethernet EQs via mana_destroy_eq().

Because the Ethernet EQ handler is still active, its IRQ handler
(mana_gd_process_eqe()) can run concurrently.  Inside the RCU read-side
critical section, mana_gd_process_eqe() reads the CQ pointer from cq_table.

If the pointer is read just before it is unpublished, the subsequent cq->ty=
pe
dereference will access memory that is immediately freed by
mana_gd_destroy_queue():

drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_destroy_queue() {
    ...
    mana_gd_free_memory(gmi);
    kfree(queue);
}

The kfree(queue) here doesn't wait for an RCU grace period (via
synchronize_rcu() or kfree_rcu()), allowing the active EQ handler to access
freed memory.

>  			break;
> =20
>  		if (cq->cq.callback)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1790665894.gi=
t.weh@linux.microsoft.com?part=3D1
