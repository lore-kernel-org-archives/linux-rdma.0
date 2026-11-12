Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794515319;
	b=B8W5hK0T9S5GhHUSqsyLPSf2Z2PpKmRGlU2ygV4QaKpq3Mwt2ffOp6H1h8T2pedyqiGz
	 EtM8Zw9eg5x7aXC/AWRWvQD4MnozFTKot3NKljL9Ll6AWLUbwmldG3U0+tuBk7DmYA+Hj
	 +wywxxoGHevk8Hbrh+WXR4NVJZd1PHE/R0JObIzrHbkRxTaqEjvqQ0SBtQQ48MJesZE1p
	 rxvFjnLxNgIM+mTLIN8aUvK1X9BkgYjFKE+UWHcb5fHcubPZNeQVFlGJDvzxQYvkAISVf
	 8oontaojjnA/KAh28zogKgg4xJrusouDbNNb8kL7a7uLz+MK0RV0RyC/xEsRevuC2CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794515319;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=m8a9UFLp0gUliAK3qMa5TzYTJr7FuIy6P2LNaGn+B24=;
	b=N7bQfleE51RRwf1pEFf2Nv28jq8E1zyJpfxqvxZSODQfw+3IT9eFrGgqCI5DsThMs4QM
	 PzcuKulZbCbqKAIhdWNV+rd/uLWqNxn/w+rxKyVwf+q6N45km/PkSyVPzQILDkctfsa2D
	 x1sLZrE40VQQiKzll3Q4SJog92Sl3RoFkJ4gfQ3Fwv+hVsBMtZ63Cm+ejJE0DEwWsd0UJ
	 de+WwhbPwxQeXuEnm3kT3xOA2uZkoBxVJi0pxUU7VCm5R3m8R/Jw1N4GzICXfyOemL/GH
	 7pOqeL+RIT2Zo6Abyjd/ZbgjIfJvTMjLNrd93UBsBQChoJSupux2W59Ek4lJ+Ltq3bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CJBeBQgy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAA6606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 20:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CJBeBQgy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBA61F000C4;
	Thu, 12 Nov 2026 20:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794515318;
	bh=m8a9UFLp0gUliAK3qMa5TzYTJr7FuIy6P2LNaGn+B24=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CJBeBQgyLGW7KQVag8kIv03HJKkq+Hs/EXuZx8lYlVEWrJLso/m9RqQ54x1vPkK/a
	 fuM2F4nforLasdmNTw7kj2JkvJvq4mEMyrG1T0aIQXPeMKTRkDm6X6F7fedTdno0ly
	 i1OUEhLqSCiiiH03m+ozjms5gGKQVm1tk4L8SHQIdgLC56BXao6Gbn+/lCE3+FNt/A
	 O1FILNoPH96K5EbIVzyqJ9RzO+n/Kg5puq9qH9gZjXg8HgEXmJJL+e+lQVKXMgNEQK
	 3wNHV/HQx30qYM1xmJ/SYxKTsWanbPq1nfzHBifTMfCKIWc93Gd3kQ5wjRTVlOgd0z
	 z6xx+KpGJbqLA==
Message-ID: <sashiko-outbox-211791@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/rds: tcp: bound the message length announced by
 the peer
Reply-To: sashiko-reviews@lists.linux.dev
To: "Weidong Wang" <weidongw@illinois.edu>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111-h047-send-v1-1-2727a38dbfcd@illinois.edu>
References: <20261111-h047-send-v1-1-2727a38dbfcd@illinois.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 20:28:38 +0000
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
- [Medium] net/rds: tcp: rds_tcp_data_recv() drop stalls shutdown and
  clobbers cp_state
--

commit e71e7a51b12574a1429c193c4c2a910762c2f915
Author: Weidong Wang <weidongw@illinois.edu>

net/rds: tcp: bound the message length announced by the peer

This commit bounds the incoming message payload length in
rds_tcp_data_recv() to RDS_MAX_MSG_SIZE and drops the connection path
when a peer announces a larger header length.

> diff --git a/net/rds/tcp_recv.c b/net/rds/tcp_recv.c
> index ffe843ca219c7..29db73df84fa3 100644
> --- a/net/rds/tcp_recv.c
> +++ b/net/rds/tcp_recv.c
> @@ -213,6 +213,20 @@ static int rds_tcp_data_recv(read_descriptor_t *desc=
, struct sk_buff *skb,
>  			}
>  		}
> =20
> +		/*
> +		 * The payload is queued on tinc until the whole message has
> +		 * arrived, so a peer must not announce more than a sender is
> +		 * allowed to send. Check on every pass, not only when the
> +		 * header completes: the drop is asynchronous and more data
> +		 * can arrive before the connection is shut down.
> +		 */
> +		if (!tc->t_tinc_hdr_rem &&
> +		    tc->t_tinc_data_rem > RDS_MAX_MSG_SIZE) {
> +			rds_conn_path_drop(cp, false);
> +			desc->error =3D -EPROTO;
> +			goto out;
> +		}
> +
>  		if (left && tc->t_tinc_data_rem) {
>  			to_copy =3D min(tc->t_tinc_data_rem, left);
> =20

[Severity: Medium]
Does returning here without draining the socket or resetting
tc->t_tinc_data_rem stall rds_tcp_conn_path_shutdown() for 5 seconds and
clobber cp->cp_state when any payload bytes follow the oversized header?

When the header is followed by payload bytes, the payload remains in
sk->sk_receive_queue while cp->cp_down_w runs rds_conn_shutdown() ->
rds_tcp_conn_path_shutdown(). Before releasing the socket or resetting
tc->t_tinc_data_rem, rds_tcp_conn_path_shutdown() tries to drain the
receive queue:

net/rds/tcp_connect.c:rds_tcp_conn_path_shutdown() {
	...
		rounds =3D 0;
		do {
			rds_tcp_recv_path(cp);
		} while (!wait_event_timeout(tc->t_recv_done_waitq,
				(sk->sk_state =3D=3D TCP_CLOSING ||
				 sk->sk_state =3D=3D TCP_TIME_WAIT ||
				 sk->sk_state =3D=3D TCP_CLOSE_WAIT ||
				 sk->sk_state =3D=3D TCP_LAST_ACK ||
				 sk->sk_state =3D=3D TCP_CLOSE) &&
				skb_queue_empty_lockless(&sk->sk_receive_queue),
				msecs_to_jiffies(100)) &&
			 ++rounds < 50);
	...
}

Because tc->t_tinc_data_rem is still greater than RDS_MAX_MSG_SIZE, each
rds_tcp_recv_path() call hits the new check and returns 0 without
consuming sk->sk_receive_queue, stalling cp->cp_wq for all 50 rounds
(5 seconds) before closing the socket. In addition, calling
rds_conn_path_drop() during this loop overwrites cp->cp_state from
RDS_CONN_DISCONNECTING back to RDS_CONN_ERROR and re-queues
cp->cp_down_w, causing rds_conn_shutdown() to fail its transition to
RDS_CONN_DOWN and run a redundant second shutdown pass.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-h047-send-=
v1-1-2727a38dbfcd@illinois.edu?part=3D1
