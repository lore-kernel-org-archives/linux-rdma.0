Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881DA3988E3;
	Sat, 17 Oct 2026 12:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792238807; cv=none; b=s5YGHhHcWjbrUfYFnaaY2s2WKWn104Fx6tyBJIQKJxZ2sscA8K4SJb6CNOLlgxqdomjpewx7gjc9wNShhtnOTMwKldLxKUZBB1zuTM7+g/gYpcBlcqMBYCxWEevRYPyeVCGAcLW/dUNIhmJcrQmg6qPp0bkdrVJNCd4rlNKZVFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792238807; c=relaxed/simple;
	bh=Uzv9jtNkcEK/5SIhZtqyRHnH0CiGKcCsgkjrLkY5s/w=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=jhZNDlbZWLj6z3NNbIiApf525s4eFDNuzyJ3+0zns41Dx75NwDHCF0gLxFDMLfc0yahmDPoBBCZ+JRSKx1KRCj2O9IMYv2yJrMb3F9dVutRKYqgQtahGi6CHfI/CdMQK8LCd5hHYJQE7fLw+AswVBf6F77Z0ZiTIa/lYqjYaW+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lma8zatA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lma8zatA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001921F000C4;
	Sat, 17 Oct 2026 12:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792238806;
	bh=FDeCkCWKQPRULcCEhWyC2+KaIJ/M/GnOZA11xsY3l6o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Lma8zatAwWGbWfEborMEG6+5nTe0QXwgoCKaQhqJyNMGzLGHcjSE9PrEJ/aKTVXir
	 5I94Fut3kLgQC6pTJ4Q5iSYG61eTjKqt9cpGBv0D2WcvQSM0IoZvNe4lEzWLxngjZ+
	 xoFRLuUCe3F0hACkRpR8iQTSaNRCVDqWaGTrQuoXqKLCJOE5H6SIK0uzOK+FRcNvpf
	 RkNsjPWtzdg6SC7LWs83L6YzdFfGVP5Ul7Brk0dprp4/J+SoYO2SrBIjN6f8z8f6rK
	 grxYS7Ig2rmb1nAP1unUeOgI+l2tZs5g4wtVqaZnJFGhSaliOASggmOz81MNr2Updx
	 f0PH8c6GupiWQ==
Message-ID: <sashiko-outbox-175499@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v8 1/4] net: mana: prepare HWC ownership for
 safe reinitialization
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <64987f49ea13b5ccdc9ef95f4a9baf23a479edc3.1791998462.git.weh@linux.microsoft.com>
References: <cover.1791998462.git.weh@linux.microsoft.com>
 <64987f49ea13b5ccdc9ef95f4a9baf23a479edc3.1791998462.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 12:06:45 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] net: mana: Use-after-free of CQ objects during teardown due to mis=
sing RCU sync
--

commit 2740a958c23f5ddb6759715d592fec4a687478f3
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
Link: https://lore.kernel.org/r/179196575238.434549.10775387794024020898@ke=
rnel.org
Link: https://lore.kernel.org/r/sashiko-outbox-170992@kernel.org

> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/ne=
t/ethernet/microsoft/mana/gdma_main.c
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c

[ ... ]

> @@ -765,11 +767,16 @@ static void mana_gd_process_eqe(struct gdma_queue *=
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
>  			break;
> =20
>  		if (cq->cq.callback)
>  			cq->cq.callback(cq->cq.context, cq);

[Severity: High]
Does this sequence still leave a use-after-free regression for Ethernet and
RDMA queues during teardown?

While this patch adds RCU documentation and memory barriers for the hardware
channel (HWC), it appears the teardown order issue remains for Ethernet
queues. During teardown, mana_detach() destroys CQs before EQs:

drivers/net/ethernet/microsoft/mana/mana_en.c:mana_detach() {
    ...
    mana_destroy_rxqs(apc);
    mana_destroy_txq(apc);
    mana_destroy_eq(apc);
}

When the CQ is destroyed, mana_gd_destroy_cq() unpublishes the CQ, and then
mana_gd_destroy_queue() immediately frees the queue memory via kfree()
without an RCU grace period:

drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_destroy_queue() {
    ...
    case GDMA_CQ:
        mana_gd_destroy_cq(gc, queue);
        break;
    ...
    mana_gd_destroy_dma_region(gc, gmi->dma_region_handle);
    mana_gd_free_memory(gmi);
    kfree(queue);
}

Because the EQ hasn't been fenced yet, an in-flight EQ interrupt could
execute mana_gd_process_eqe() concurrently. Since the RCU read-side
critical section here does not protect against kfree(), could it
dereference the freed memory when invoking cq->cq.callback() for these
queues?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791998462.gi=
t.weh@linux.microsoft.com?part=3D1
