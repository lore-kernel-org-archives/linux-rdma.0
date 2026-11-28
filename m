Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795875680;
	b=2IwR1zL33tGWNhQDdviYCxb1NzqvH0RbTIYLK2Q2NA3rS1HabyLvuIPimp6Ypqi+jHnQ
	 qo9Pc01ZsAuhMmA0k9DXma+Idc7b1Yw8wZrHYKbwx41GFSkTDrjaMXlGIcSrMceBXNRE2
	 0WS84qS60T98cDwK6VRy9LY6Av+DbVjcHvZzZLkawJZGicZumjV2ysPtjgIOShv0+1XCU
	 Ys3CJaJHs46F0UdG/Oq0eDYKBJQQuVoWyZXLo3LWczqr2EUZ12LH1ir9AaKhzklPlzKND
	 Ja0YYKpswXAQi+Pe18WeFyb8VYG3ma9faSw/S9/5E2vsHKrv47G6RPhMBGZWMBeI4Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795875680;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xsaUdBlnTkbBe/OrFQrng6FKqzvfZn+Suly+XpJZruo=;
	b=HYT8Bl8enj3lSw9Q83SnjC/Ux/lfAP35BJBZt48YPrD69EH5cYG6poDwkaLtz1C+Kb7G
	 TVRPd6CSSzaus0+2VLMeOa27sRL/9Bo0wb5K4U0J5+kvkl26ECngk9i/+jze3slM7qoFH
	 q0KSDMw2gJbGnRkUfTIJV6QixhVMzrbeD26F5hQr6C0I7Ha6oZIDLLwHoRxiXdImsH4WR
	 TKxIGb24SfEe1nKaKh1T3qcmmrvMfbecuf/73d28yxxePzG677r7SMp6eD63/4iYepD/w
	 DlcdN70akcN4hW8x6PQUtJQNrbWiTiR+DtDfyoXDYaKgSQpEyPbm0op8nY2uGv3CDGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d+AKuaUZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182FC606A31C
	for <linux-rdma@vger.kernel.org>; Sat, 28 Nov 2026 14:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d+AKuaUZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B6D1F000C1;
	Sat, 28 Nov 2026 14:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795875679;
	bh=xsaUdBlnTkbBe/OrFQrng6FKqzvfZn+Suly+XpJZruo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d+AKuaUZCCngiH7iXwMA/vX2IKm335SDI2XPofw+9YcP/PV5mJ6/R1kzNpETZoU2v
	 L3DCgvAUbMWQoX2C1lkZktROWkjDf+pgaO2I7PR/Jw+rvkgmMtb+XHYxNePmF6POiG
	 kbqB9y4PSutUqACsFY3TnnYhfzjWZrXTcvFUHONv/CY2mzLmiPZX4hs0M17DtQS2I+
	 R6J7pCeDVW8n+Oh9+Eydl7Ugp9aETevdKTJd2XlMZ0YcF6hU1uz9nQYu9JM6hw/Utc
	 lj+k6xwKgZfG9cicjds0TQAPRY/28YsBF38AuWZevqEkdDsWKv1g5pldREfUvA1X1j
	 mU4HpnWVq6jGw==
Message-ID: <sashiko-outbox-238765@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-rc] RDMA/siw: Fix NULL dereference when disconnect
 races the RTR callback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Stellman" <bugs@stellman-greene.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261128140843.59029-1-bugs@stellman-greene.com>
References: <20261128140843.59029-1-bugs@stellman-greene.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 28 Nov 2026 14:21:19 +0000
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
- [High] RDMA/siw: race with siw_cm_work_handler() in
  siw_rtr_data_ready()
--

commit 79aa7e62cc4f0bc3e76b32bcd12993ddd9a6d3e4
Author: Andrew Stellman <astellman@stellman-greene.com>

RDMA/siw: Fix NULL dereference when disconnect races the RTR callback

This commit inlines the QP socket callback assignment in
siw_rtr_data_ready() under sk->sk_callback_lock after verifying that
sk_to_cep(sk) =3D=3D cep and cep->qp =3D=3D qp.

> diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/s=
iw/siw_cm.c
> index ed49818793dde..8612db3cc94e8 100644
> --- a/drivers/infiniband/sw/siw/siw_cm.c
> +++ b/drivers/infiniband/sw/siw/siw_cm.c
> @@ -181,8 +181,15 @@ static void siw_rtr_data_ready(struct sock *sk)
>  		siw_cm_upcall(cep, IW_CM_EVENT_ESTABLISHED, 0);
>  out:
>  	read_unlock(&sk->sk_callback_lock);
> -	if (qp)
> -		siw_qp_socket_assoc(cep, qp);
> +	if (qp) {
> +		write_lock_bh(&sk->sk_callback_lock);
> +		if (sk_to_cep(sk) =3D=3D cep && cep->qp =3D=3D qp) {
> +			qp->attrs.sk =3D cep->sock;
> +			sk->sk_data_ready =3D siw_qp_llp_data_ready;
> +			sk->sk_write_space =3D siw_qp_llp_write_space;
> +		}
> +		write_unlock_bh(&sk->sk_callback_lock);
> +	}
>  }

[Severity: High]
Can this race with siw_cm_work_handler() to leave a dangling socket pointer
in qp->attrs.sk or write to a freed qp?

If the incoming RTR frame is malformed and siw_tcp_rx_data() calls
siw_qp_cm_drop(qp, 1), qp->rx_stream.rx_suspend is set and
SIW_CM_WORK_CLOSE_LLP is queued on siw_cm_wq, yet siw_rtr_data_ready() still
falls through to the if (qp) block after dropping sk_callback_lock.

In siw_cm_work_handler(), the release_cep path closes the QP and drops the
CEP's QP reference before disassociating the socket under sk_callback_lock:

drivers/infiniband/sw/siw/siw_cm.c:siw_cm_work_handler() {
    ...
		if (cep->qp) {
			struct siw_qp *qp =3D cep->qp;
    ...
			siw_qp_llp_close(qp);
			siw_qp_put(qp);

			siw_cep_set_inuse(cep);
			cep->qp =3D NULL;
			siw_qp_put(qp);
		}
		if (s) {
			siw_socket_disassoc(s);
			sock_release(s);
		}
    ...
}

This allows the following interleaving:

<softirq>                         kworker
siw_rtr_data_ready()
  tcp_read_sock()
    ...
      siw_qp_cm_drop(qp, 1)
  read_unlock(&sk_callback_lock)
                                  siw_cm_work_handler()
                                    siw_qp_llp_close(qp)
                                      down_write(&qp->state_lock)
                                      qp->attrs.sk =3D NULL
                                      up_write(&qp->state_lock)
  write_lock_bh(&sk_callback_lock)
  if (sk_to_cep(sk) =3D=3D cep &&
      cep->qp =3D=3D qp)
                                    cep->qp =3D NULL
                                    siw_qp_put(qp)
    qp->attrs.sk =3D cep->sock
  write_unlock_bh(&sk_callback_lock)
                                    siw_socket_disassoc(s)
                                    sock_release(s)  <-- qp->attrs.sk dangl=
es

Because siw_rtr_data_ready() sets qp->attrs.sk without holding
qp->state_lock, it overwrites the NULL written by siw_qp_llp_close() right
before sock_release(s) frees the socket.  Also, because cep->qp is cleared
and siw_qp_put(qp) is called without holding sk_callback_lock, the last QP
reference can drop right after cep->qp =3D=3D qp is checked, making the wri=
te to
qp->attrs.sk a use-after-free if siw_destroy_qp() is waiting on qp->qp_free.

Note that siw_accept() already sets qp->attrs.sk =3D cep->sock via
siw_qp_modify() before installing the RTR callbacks.  Skipping the callback
reassignment when qp->rx_stream.rx_suspend is set, and disassociating the
socket in siw_cm_work_handler() before closing and releasing cep->qp (as
siw_qp_cm_drop() does in its immediate path), would avoid both races.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261128140843.5902=
9-1-bugs@stellman-greene.com?part=3D1
