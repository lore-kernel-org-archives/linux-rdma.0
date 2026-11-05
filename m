Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894228;
	b=R5VTaqmn0EO42GkYSSi74Fo/KCkQ5NqFQmVkRRb9BbNySYKjtzayoxSPhiXd6XGcd9V9
	 9DSiKG4aOAS/ntOHnjmmJz9A7svs4QCnAFakAdof/ljSkg/88NFh4i3/QJoMrFnMq+tJk
	 B3zpICLSNjgKRr5wxECF9LblHFCg6x1cbcTRZ5Zp/nWRXeABfGYAKOgNzeNvHvXZGmsr6
	 RdS+HfSl3ePwsZa+Too5uLe12wDEGkjUT1twfYFXR8EUm3TNE9wUAzp3cJnuDXMbO2iR0
	 fqMOlD2pEt5d6NQAgqcUTvqxHhQYGdREMCbmecVtO3Nqx0aqSJfqxcFLflktFPqnm8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894228;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=opG7PP3xsPhiyKdc3mmb/fTHQaSomEP7j9ECOOTZiU8=;
	b=hddHfQ12bipmObEobA+JfSTIpcnK+XxRTc+TdHsQZyFRtBqU5SFy5qmsReaQR4/iG11d
	 w4rKOdETx0KP3cYwCseOyPDuOJ8I56IK4pjfU1BgzURiB++zLAk7Qhf8mkd19Fs4g2lSu
	 HgC0nBypIyhXxU3UNjhh1BzZA5B/Vdb9hNPkpe8MEDGR/MmlaUrdi1iCqE/U51GP1aEzm
	 nNko6L+/AM49A+RjiuB38YFKwI8E7l9UjaJYgv24gDkISv6aHnBk4gVwUVT3p/rmYdPu2
	 /0nAc8+PCWnENIAtmLZuc3xb5YqdEchva+OIbMVitasTz1RvvpW3LtIGc1uDsF5Jhjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Cx/+BPlK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BEA606EEB2
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 15:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cx/+BPlK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1B61F000C1;
	Thu,  5 Nov 2026 15:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894227;
	bh=opG7PP3xsPhiyKdc3mmb/fTHQaSomEP7j9ECOOTZiU8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Cx/+BPlKVXuZJMnM058MYEZpZY9yDhY+RkXXWQyXFQCb5bWIKOD45Zvv20cwfcvRZ
	 //cCAs7RxlWKoAvmK1nnM/zZ3ZMhHzgUdF2cidrZMwVJJ0yOhZnZjNpS3gzF2AEOlG
	 33UzvynRm49Vn4awy6ksy3ZbnxA350jHOtigiivZB8Bq+eZplE6ViW7yBUJmhWzD4h
	 mPcbwWfvZ1Mqc2COhE3sAp8lBlKVWp5b9M0+dz/YpvMNguxBANjpZe3twRSodIEnTO
	 G43eqDtrXfMKLB24HgfTROCojLYcZMexX4dcHpeT21gjHz+fsV8Km7DKZ/ncdr1dCW
	 +uxwrri7moaEA==
Message-ID: <sashiko-outbox-199379@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/irdma: fix double free of close_entry in TIME_WAIT
 teardown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wentao Liang" <vulab@iscas.ac.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104025347.1527584-1-vulab@iscas.ac.cn>
References: <20261104025347.1527584-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 15:57:06 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] RDMA/irdma: refcount underflow and UAF in irdma_cm_timer_tick()
--

commit 3abe5e40541e0bcf80a0a51f21ea66e768ed3bae
Author: Wentao Liang <vulab@iscas.ac.cn>

RDMA/irdma: fix double free of close_entry in TIME_WAIT teardown

This commit reorders freeing close_entry and clearing cm_node->close_entry
before calling irdma_rem_ref_cm_node() in irdma_handle_close_entry() to avo=
id
a double free if dropping the cm_node reference triggers
irdma_destroy_connection().

> diff --git a/drivers/infiniband/hw/irdma/cm.c b/drivers/infiniband/hw/ird=
ma/cm.c
> index 91c0e72982836..d8b8939d6abdb 100644
> --- a/drivers/infiniband/hw/irdma/cm.c
> +++ b/drivers/infiniband/hw/irdma/cm.c
> @@ -1243,13 +1243,15 @@ static void irdma_handle_close_entry(struct irdma=
_cm_node *cm_node,
>  		} else {
>  			spin_unlock_irqrestore(&iwqp->lock, flags);
>  		}
> -	} else if (rem_node) {
> -		/* TIME_WAIT state */
> -		irdma_rem_ref_cm_node(cm_node);
>  	}
> =20
>  	kfree(close_entry);
>  	cm_node->close_entry =3D NULL;
> +
> +	if (!iwqp && rem_node) {
> +		/* TIME_WAIT state */
> +		irdma_rem_ref_cm_node(cm_node);
> +	}
>  }

[Severity: Critical]
If irdma_rem_ref_cm_node(cm_node) here drops the last reference on cm_node,
does the caller irdma_cm_timer_tick() suffer a use-after-free on cm_node and
underflow cm_node->refcnt?

irdma_handle_close_entry() has only two callers: irdma_destroy_connection()
passes rem_node =3D 0, and irdma_cm_timer_tick() passes rem_node =3D 1.

Before iterating timer_list, irdma_cm_timer_tick() calls
irdma_timer_list_prep(), which takes a dedicated reference on each queued
cm_node for timer_list:

drivers/infiniband/hw/irdma/cm.c:irdma_timer_list_prep() {
	...
		if ((cm_node->close_entry || cm_node->send_entry) &&
		    refcount_inc_not_zero(&cm_node->refcnt))
			list_add(&cm_node->timer_entry, timer_list);
	...
}

In normal non-racing TIME_WAIT expiration, cm_node->refcnt is at least 2 wh=
en
entering irdma_handle_close_entry(cm_node, 1) (one for the connection in
IRDMA_CM_STATE_TIME_WAIT and one for timer_list), so the put in
irdma_handle_close_entry() drops refcnt from 2 to 1 and is not the final pu=
t.

The put in irdma_handle_close_entry(cm_node, 1) only becomes the final put
(reducing refcnt from 1 to 0 and calling irdma_destroy_connection()) when a
concurrent FIN or RST packet in irdma_handle_fin_pkt() or
irdma_handle_rst_pkt() processes IRDMA_CM_STATE_TIME_WAIT and drops the
TIME_WAIT reference without clearing cm_node->close_entry while cm_node is =
on
timer_list (or when irdma_handle_close_entry() drops the TIME_WAIT reference
without changing cm_node->state out of IRDMA_CM_STATE_TIME_WAIT before a
concurrent FIN or RST arrives):

drivers/infiniband/hw/irdma/cm.c:irdma_handle_fin_pkt() {
	...
	case IRDMA_CM_STATE_TIME_WAIT:
		cm_node->tcp_cntxt.rcv_nxt++;
		irdma_cleanup_retrans_entry(cm_node);
		cm_node->state =3D IRDMA_CM_STATE_CLOSED;
		irdma_rem_ref_cm_node(cm_node);
		break;
	...
}

drivers/infiniband/hw/irdma/cm.c:irdma_handle_rst_pkt() {
	...
	case IRDMA_CM_STATE_TIME_WAIT:
		cm_node->state =3D IRDMA_CM_STATE_CLOSED;
		irdma_rem_ref_cm_node(cm_node);
		break;
	...
}

When that happens, irdma_rem_ref_cm_node(cm_node) inside
irdma_handle_close_entry(cm_node, 1) consumes the caller's timer_list
reference, runs irdma_destroy_connection(cm_node), and schedules
kfree_rcu(cm_node, rcu_head). It then returns to irdma_cm_timer_tick(), whi=
ch
is outside RCU protection and continues using cm_node before dropping the
timer_list reference at done:

drivers/infiniband/hw/irdma/cm.c:irdma_cm_timer_tick() {
	...
			} else {
				irdma_handle_close_entry(cm_node, 1);
			}
		}

		spin_lock_irqsave(&cm_node->retrans_list_lock, flags);

		send_entry =3D cm_node->send_entry;
		if (!send_entry)
			goto done;
	...
done:
		spin_unlock_irqrestore(&cm_node->retrans_list_lock, flags);
		irdma_rem_ref_cm_node(cm_node);
	}
}

Even with close_entry freed and cleared beforehand, wouldn't
irdma_cm_timer_tick() still access a destroyed cm_node and call
irdma_rem_ref_cm_node(cm_node) again when cm_node->refcnt is already 0?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104025347.1527=
584-1-vulab@iscas.ac.cn?part=3D1
