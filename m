Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336048;
	b=ijIBlLYr1Ke9FGjYm+sbvHlHhXXE+Wv6GytK0WQWDh6uAS26/t/+OYUtp1OQVSoZdo77
	 AWx2xUK2S01B61Fd46oTXcLhNbXhIkM7rcDP810LWi2wTEEJQRx4I7IEU0/PYwt/gFuAz
	 OONK8CE1/3Vi8bkdtgC/00Sf8C9Pqwdf7xisrZasXy9QIq3tcBzitxa98SsAsDbwmFyrs
	 LVzcz5sfDwhoogOWVDgI5iUs5RgCgUGmhyBkwQ2a+0pOtl2ZtCv1ZY1ih/fm34xorj650
	 OkdbKvY2B9DH8dfVddIJCXCunaGeZh2NY1GSstGXL78BRAYZBbmoeyEy+gLRZKTzXjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336048;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=zTBQkrIXpCkeRxirv2Y5dvubaVq3mE3e/p+vnM3L570=;
	b=TCH3/BjLGxw8iZuRHNnTnBIJwWaWPgJXSva3bF0JK7yBuiz11kiif2SsZEhExOgIXGVi
	 6YF1QefhjWZMHhgIEd/ongvlFKSmsHTXl0+T3HQkBaeyiZixQU7nW1bFyD2AkvSiSwuK/
	 UFGtH/1K0RguihV91++XO59BbAWYvDapY/mwhjTWvb00fLzyUexKOkHLl6vwbzFK5ZONE
	 /XdOLfzT3IlMz305jIa1sHi92ZfLkJHTcaA924rq+XyPstOBOqsDMqW4yux7xjY8ezVVw
	 nFucpYEPLhWxL587whTN2nFCaeTjSRW7TnYYF0QLsXFa6DK1+OFjsUCaLRnOHxjPOLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CbxnFdVo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54507606A321;
	Fri, 30 Oct 2026 04:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CbxnFdVo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F561F000C1;
	Fri, 30 Oct 2026 04:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336048;
	bh=zTBQkrIXpCkeRxirv2Y5dvubaVq3mE3e/p+vnM3L570=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CbxnFdVofaO3n4paFLTbjhTBZ3CQYtzT3Ipf15gfHvecZnGzpxoTZvw3N6bOkTkQT
	 oQY4iyC6uSKEsURkvu7BsgXhotDlnnjKIfuHlkWuroheDXUUMKJYXJxwYWVwNXSh9d
	 X5LTMOLwLY9ncL8JVkTg5oIDoF2GUfWhbnqK+k4Joeh1itmyQgU+BolwNmjsmJkwoz
	 5zMXxDEncSCBqhyc5dNCqYyEbFJA/Xu9DpfzHWUaqAoJN/JhhXGf0QOT4WHOP4si/O
	 17Q53EZzSZO8NDdCplootE7YW+IZLCGXsFV6SbWKptWMEbTy1rcUfeEqsBmyo11oOy
	 1qHIzBwJArCjg==
Message-ID: <sashiko-outbox-190412@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v8 1/6] net: mana: Create separate EQs for each
 vPort
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20260508221202.15725-2-longli@microsoft.com>
References: <20260508221202.15725-2-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:54:07 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] Missing reference counting for EQs in RSS QP leads to Use-Afte=
r-Free and DMA corruption.
- [High] An off-by-one error in the `mana_ib_create_qp_rss` error handling =
path causes a memory leak of previously allocated WQ objects.
- [High] Lockless access to `mpc->eqs` causes TOCTOU races resulting in NUL=
L pointer dereferences or Use-After-Free.
--

commit e7e0da70dd7f308d1d04d77e17767cbeb27d8fb9
Author: Long Li <longli@microsoft.com>

net: mana: Create separate EQs for each vPort

To prepare for assigning vPorts to dedicated MSI-X vectors, remove EQ
sharing among the vPorts and create dedicated EQs for each vPort.

> diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana=
/qp.c
> index 0fbcf449c134b..6167742df9d29 100644
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c
> @@ -171,7 +171,15 @@ static int mana_ib_create_qp_rss(struct ib_qp *ibqp,=
 struct ib_pd *pd,
>  		cq_spec.gdma_region =3D cq->queue.gdma_region;
>  		cq_spec.queue_size =3D cq->cqe * COMP_ENTRY_SIZE;
>  		cq_spec.modr_ctx_id =3D 0;
> -		eq =3D &mpc->ac->eqs[cq->comp_vector];
> +		/* EQs are created when a raw QP configures the vport.
> +		 * A raw QP must be created before creating rwq_ind_tbl.
> +		 */
> +		if (!mpc->eqs) {
> +			ret =3D -EINVAL;
> +			i--;

Does this double decrement leak the WQ object?

If the failure occurs at index i=3D1, the explicit i-- makes it 0. The
while (i-- > 0) in the fail: block then evaluates to 0-- > 0 (false), skipp=
ing
the cleanup of index 0 and leaking the WQ resource from the previous
iteration.

> +			goto fail;
> +		}

Does this access to mpc->eqs need synchronization?

If this races with mana_create_eq(), mana_create_eq() publishes the apc->eqs
array via kzalloc_objs() before actually initializing the inner queue point=
ers
(apc->eqs[i].eq) in a subsequent loop. The RDMA thread could observe
mpc->eqs !=3D NULL, read a NULL eq->eq pointer, and panic when dereferencing
eq->eq->id.

Similarly, could a race with mana_destroy_eq() lead to a use-after-free on
the mpc->eqs array?

> +		eq =3D &mpc->eqs[cq->comp_vector % mpc->num_queues];
>  		cq_spec.attached_eq =3D eq->eq->id;

Does this code need to hold a reference to the vport?

This binds the Completion Queue to the port's Event Queues, but it does not
appear to increment pd->vport_use_count or otherwise hold a reference to
the EQs.

If the EQs were created by a raw QP and that raw QP is destroyed,
pd->vport_use_count drops to 0, which triggers mana_destroy_eq(). The EQs
can also be destroyed unconditionally by the Ethernet driver if the interfa=
ce
is brought down.

Could the DMA memory and the mpc->eqs array be freed while the RSS QP remai=
ns
active, leading to a use-after-free and DMA corruption when hardware events
occur?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260508221202.1572=
5-1-longli@microsoft.com?part=3D1
