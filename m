Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794559974;
	b=XP7omQNBSHdRuc+Xq2ZjdxdfGpC9idflDdVCYT8S4clztuTrt5kpdw7tTLIoAC2JeFRm
	 wmhY8F99GwJ9udvKQri/02TNJKJLrIKDNgl7DzDB+wd8fHVZpJmeto8KE+KgHIZCruKUh
	 xSlhiHSAt6OjlP7c/lf3fuFWXGnK6sqZqIzxlMguxsF56BUeuUY8DfmH1zK8ftZUc4dR1
	 sD5zkAHM7yr95Lf9DKumh6PELed1WURxbU0lXuc6XQrRGSdpai2x0TTreg/tqY3aKx/mY
	 l3y91vL225oovQte7yNw2OMaR0/Zb9z9uHboQE0sv7mVwsGJGnog0KXNx3V2jYAFUqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794559974;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=OkDaAoi/EIO3hdXCojocOr/5XtidjiwgmGepMahiVm4=;
	b=euYRYJz3CW4hM4lRi4EucGt/7BkEHxF5V5mWv/OAdmttJLrX7KJsStcB1RBW4pNKnDxM
	 0bfp/jcSYgZKb5K/twTWLwj8RqwE04t8YZEHP5AWDkyPobYVfzFje5sB1+bUfDIyfF9Ap
	 04vo51g+T31hq5UUBNeaX6rLhKya4UlVM5bI/ogcoZQibqz3sQ12ZcycHsqP//31Xefet
	 /2jse/RE3UEwjaG3LUxna9xPk+58DQqcgeBw4qsRDknJtRBIqBxuAdb8CUXUFZ/3cREWU
	 ScsJXZjxNVUXG9iLsrFmdt6NfyJIlC4Lv0rd5GM6qWuOAOCXL5Fd2AQGlQRDQnBvPmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i8Je1Ja6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FD8606A896;
	Fri, 13 Nov 2026 08:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i8Je1Ja6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E779B1F000C4;
	Fri, 13 Nov 2026 08:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794559974;
	bh=OkDaAoi/EIO3hdXCojocOr/5XtidjiwgmGepMahiVm4=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=i8Je1Ja6fo2rixfWShhRVRyR8nZVBvWOUOYad2GPmNouZWCVF6fRMqsX7J5u78EkZ
	 ot7rDQeuzOni154H/2rhLJrj1Y6gPTK1u7xlxPWj7WMrupSHFH7H02G679cI1Pykr+
	 5JE0Wd0qMJx0TKsxCOsB8EKrs0FAghbyCevoKOFVZb1vOA0aU4lcFVTTNpRtQfAjWY
	 ziutDuMmIDphp5ckdIw1YItDRYdN/VvDGG+DzVmExFKRvsaa4v5s/aXD2lKD4SEFiJ
	 8FAn/8f4SNjoxTjAlTfGYdPaKOCIuD0QYS7rOzzosAuzWvMOCJzR12GqaplH0YM9tp
	 pGOegJtAPb2bQ==
Message-ID: <sashiko-outbox-212474@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v3] net: mana: Avoid waiting on dead HWC after
 device reset
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sahil Chandna" <sahilchandna@linux.microsoft.com>, linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261112085226.878780-1-sahilchandna@linux.microsoft.com>
References: <20261112085226.878780-1-sahilchandna@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 08:52:53 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] net: mana: premature TX NAPI deletion in
  mana_dealloc_queues()
--

commit d359cd9ade3de8d4713c17d8d3e7c311b5d6d28c
Author: Sahil Chandna <sahilchandna@linux.microsoft.com>

net: mana: Avoid waiting on dead HWC after device reset

This commit replaces the sleep-based TX drain in mana_dealloc_queues()
with synchronous CQ polling and marks the hardware channel dead after a
device reset so subsequent HWC commands fail fast.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/=
ethernet/microsoft/mana/mana_en.c
> index 38249e092090a..739021aa09b38 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c

[ ... ]

> @@ -3799,42 +3809,110 @@ static int mana_dealloc_queues(struct net_device=
 *ndev)

[ ... ]

>  		for (i =3D 0; i < apc->num_queues; i++) {
> +			struct napi_struct *napi;
> +			struct mana_cq *tx_cq;
> +
> +			if (!apc->tx_qp[i])
> +				continue;
> +
> +			tx_cq =3D &apc->tx_qp[i]->tx_cq;
> +			napi =3D &tx_cq->napi;
> +
>  			txq =3D &apc->tx_qp[i]->txq;
>  			while ((skb =3D skb_dequeue(&txq->pending_skbs))) {
>  				mana_unmap_skb(skb, apc);
>  				dev_kfree_skb_any(skb);
>  			}
>  			atomic_set(&txq->pending_sends, 0);
> +
> +			if (txq->napi_initialized) {
> +				netif_napi_del_locked(napi);
> +				txq->napi_initialized =3D false;
> +			}
>  		}
>  	}

[Severity: Medium]
Does deleting the TX NAPI and clearing txq->napi_initialized here run too
early, before mana_destroy_txq() destroys the SQ object and detaches the
TX CQ?

At this point in mana_dealloc_queues(), the SQ object is still alive and
tx_cq.gdma_cq remains published in gc->cq_table[] and eq->eq.child_cq[]
while mana_disable_vport_rx(), mana_fence_rqs(), mana_destroy_rxqs() and
mana_destroy_wq_obj() run, so a completion or GDMA_EQE_THROTTLE event on
the shared EQ can still call mana_schedule_napi() on the deleted
napi_struct.

Clearing txq->napi_initialized here also causes mana_destroy_txq() to skip
its post-mana_destroy_wq_obj() detach block:

drivers/net/ethernet/microsoft/mana/mana_en.c:mana_destroy_txq() {
    ...
		if (apc->tx_qp[i]->tx_object !=3D INVALID_MANA_HANDLE)
			mana_destroy_wq_obj(apc, GDMA_SQ, apc->tx_qp[i]->tx_object);

		if (apc->tx_qp[i]->txq.napi_initialized) {
			/* Detach the CQ only after the WQ object is destroyed,
			 * so a completion EQE that arrives before then still
			 * finds the CQ in cq_table[] rather than hitting the
			 * WARN in mana_gd_process_eqe(). One grace period then
			 * covers both mana_gd_intr() and NAPI users.
			 */
			mana_gd_detach_cq(gc, apc->tx_qp[i]->tx_cq.gdma_cq);
			netif_napi_del_locked(napi);
			apc->tx_qp[i]->txq.napi_initialized =3D false;
		}

		mana_deinit_cq(apc, &apc->tx_qp[i]->tx_cq);
    ...
}

Because mana_gd_detach_cq() is skipped there, mana_deinit_cq() ->
mana_gd_destroy_queue() -> mana_gd_destroy_cq() has to detach the CQ and
wait for a second synchronize_net() grace period for every TX queue under
rtnl_lock.  Leaving netif_napi_del_locked() and txq->napi_initialized =3D
false to mana_destroy_txq() (and guarding the redundant napi_disable_locked=
()
in mana_destroy_txq()) would avoid both issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112085226.8787=
80-1-sahilchandna@linux.microsoft.com?part=3D1
