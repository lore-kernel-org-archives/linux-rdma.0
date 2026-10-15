Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58A64C651D;
	Thu, 15 Oct 2026 13:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792071814; cv=none; b=MprHaTsIAle49SaKhjqzpyDrL4oG7w0U21fmk49lrYn83hVytI+bRXvvTkOrauIUK1iILaGmUoDfvI5gv61tEJ4zUfmaQQ59cInEJr5d2X3DBcFSvJ5gHas387ar5SN/QtJctfw+jFwrJ6Ma6WMnDkzOh99IpH8xGC9Ea9lM5Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792071814; c=relaxed/simple;
	bh=8oSHdcx7AC10hio/DtY7RqQ+PBHJeQkUVNLlXx2m9Pk=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=dzBkA6n6Z0+D42KbjzOlacHEogP9xB1xQ1Rfo21/aujaGgpMDzhcSoXLE5twF6gvTPvzMjmoQ1SRfhdkuRsY7OZBteHdZ/TIhykoCsAm6340UyQJ6YrPuQ+QmJUGfH5jkBfznVL75xMkYz3MNx4Owm7XqiLdPAiSpJpdcGATj00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dXHG/BiT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dXHG/BiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386481F000C4;
	Thu, 15 Oct 2026 13:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792071813;
	bh=8bDJzN2tvgTr/ei45vMf4KahxT9ywbtFdBRo3xuzEqA=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=dXHG/BiT/M5BE8uHy/g3r3vEvNqdg6hVyYC7iW8m2dkktM5tdIE+ajIQ8fuTDe+xT
	 kq+GgfRoUyaCiUapKSl2vJ5JzB9mlIDKQm1kxiNNYLj1tFhpuvN75/tTOqCO7iVAkN
	 JMc635jEsRJC74T7qp6lhTdzXuHBdPyFVr5TTjrN8o5LInB/ZFUlG2z1pXEd0h7OZS
	 of/mMyySLC4nGa8h3VEatitYv2+GbLO4ycQeTId4F/ubddyHKA7xqNT6HqU6U166sy
	 Klp6bpfLxjqNirkaINe1CP5MIPlQq2a9pxe1NUdyhxYtnUxi2BaU6TvIivdjH49nTx
	 A3pVgGlGSAX8g==
Message-ID: <sashiko-outbox-172938@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2] net: mana: Add support to process throttled EQEs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sahil Chandna" <sahilchandna@linux.microsoft.com>, linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261014134304.4177657-1-sahilchandna@linux.microsoft.com>
References: <20261014134304.4177657-1-sahilchandna@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 13:43:32 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] net: mana: use-after-free of CQ during teardown due to RCU-001 rem=
oval ordering violation
--

commit 4c00972dfa8283dfc036bc3bbb77031cb6550854
Author: Sahil Chandna <sahilchandna@linux.microsoft.com>

net: mana: Add support to process throttled EQEs

When an event queue nears full, the hardware coalesces the per-CQ
GDMA_EQE_COMPLETION notifications into a single throttle EQE (type 4)
that carries no cq_id. The driver does not handle this event type, so
it falls through to the default case and is dropped. Any CQ whose
completion notification was replaced by the throttle EQE can remain
unserviced, causing its queue to stall.

Link: https://lore.kernel.org/all/20261008083315.306076-1-sahilchandna@linu=
x.microsoft.com/

> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/ne=
t/ethernet/microsoft/mana/gdma_main.c
> index ae0ed700b3b93..95ba6ba161ae2 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
[ ... ]
> @@ -1063,17 +1089,45 @@ static void mana_gd_create_cq(const struct gdma_q=
ueue_spec *spec,
>  static void mana_gd_destroy_cq(struct gdma_context *gc,
>  			       struct gdma_queue *queue)
>  {
> +	struct gdma_queue *eq =3D queue->cq.parent;
> +	bool attached =3D false;
>  	u32 id =3D queue->id;
> +	u8 i;
> +
> +	if (eq) {
> +		for (i =3D 0; i < GDMA_EQ_MAX_CHILD_CQ; i++) {
> +			if (rcu_access_pointer(eq->eq.child_cq[i]) =3D=3D queue) {
> +				RCU_INIT_POINTER(eq->eq.child_cq[i], NULL);
> +				attached =3D true;
> +			}
> +		}
> +
> +		if (attached)
> +			synchronize_net();
> +	}
> =20
>  	if (id >=3D gc->max_num_cqs)
>  		return;

[Severity: High]
Does this code order the CQ removal and grace period correctly to prevent
a use-after-free?

Looking at the rest of mana_gd_destroy_cq(), gc->cq_table[id] is cleared
after the synchronize_net() grace period ends:

drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_destroy_cq() {
	if (eq) {
		...
		if (attached)
			synchronize_net();
	}

	if (id >=3D gc->max_num_cqs)
		return;

	if (!gc->cq_table[id])
		return;

	gc->cq_table[id] =3D NULL;
}

Because gc->cq_table[id] remains published during and immediately after
the grace period, can a concurrent or delayed interrupt processing
GDMA_EQE_COMPLETION in mana_gd_process_eqe() still find the CQ?

drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_process_eqe() {
	case GDMA_EQE_COMPLETION:
		...
		cq =3D gc->cq_table[cq_id];
		...
		if (cq->cq.callback)
			cq->cq.callback(cq->cq.context, cq);
}

If a new reader accesses the CQ from gc->cq_table after synchronize_net()
returns, but before the caller mana_gd_destroy_queue() frees the memory via
kfree(), could it lead to a use-after-free crash?

Should the clearing of gc->cq_table[id] happen before calling
synchronize_net() so all reader-visible references are removed before
waiting for the grace period?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014134304.4177=
657-1-sahilchandna@linux.microsoft.com?part=3D1
