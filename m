Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DDB486650;
	Wed, 14 Oct 2026 20:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792008780; cv=none; b=Ef1fVtJQjNOL9tMULUyefMbGO34oUO1bcP6neTGc/m0xAEHb/Ji/NY5V/bmFxUsAln2ZyHbMuJ46taLjGqcV6D23Ws/oCYwQWHhdocmtwusW6UygXDkbxVAZggcX/tKr5OhnIhJqKVsG367MGzqrgJPeXPqzGLLDkmUdVpjBiVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792008780; c=relaxed/simple;
	bh=me11QB/uJ9Wmp3JXTCpDOpGWZCIdCxfc1icbA6TR2nA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=V72gIOtgl6ub8ZbNHnjcEZpz1BlxoytboPFxVc4KRAJrM0W8jPtjRpGmWb36tkZR2obRVBeI3J1NIvb/NTIkeIvesUtbvGLu8idLALd7Y+eqarg0Muj8d9gsfIYJdQwaueSzCl2Qa1JGrSVK9vj2lCig4h1vRJrDM5lWeuQQkw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cQz497rJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cQz497rJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B44E1F000C4;
	Wed, 14 Oct 2026 20:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792008774;
	bh=ZfFRWgll+/u/em5LmBjfJ9L3IYMVEO+MC+mYeJebVQM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cQz497rJBk18tqtYLhCYA/JMrX4oriOxL8RwL1vHQA9VpMewqwCOgY/ogU/PynLHl
	 tqir70SaDOxE1ekZChRZOjxShB/8ZX/OcZAs9kpYyXcVO0v/IZpvgsrXBrAWz5IUnK
	 Kb2uuwD+DWT89f52s/ylchbDXkVjxvivOYZXZnD3Txbc66G976qX1syBzMuUanJwHP
	 Qpr8paQ+LAksbc2szUqeUq9MOfCuEBV2hDv7qVrKNHFmmkhGbh/mtSLI+XLZ7UlSuT
	 8ze31mDwAH5Z/c0bgDk+v/sdjLxKe/WBbLqDPxIm2CDQOxz/jvjbI4VNHGOiFVm8TD
	 YmL4WlvmbyvUQ==
Message-ID: <sashiko-outbox-171843@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v7 1/4] net/smc: bound the wire-controlled producer
 cursor to the RMB
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-disp-f345196c-v7-1-ef3dddfbfa68@proton.me>
References: <20261013-b4-disp-f345196c-v7-0-ef3dddfbfa68@proton.me>
 <20261013-b4-disp-f345196c-v7-1-ef3dddfbfa68@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 20:12:53 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] net/smc: NULL pointer dereference in SMC CDC receive path
--

commit a66b04c40aa7b03be8e0d1b68a8b99f2014ef1fb
Author: Bryam Vargas <hexlabsecurity@proton.me>

net/smc: bound the wire-controlled producer cursor to the RMB

smcr_cdc_msg_to_host() and smcd_cdc_msg_to_host() import the peer's
producer cursor from the wire into conn->local_rx_ctrl.prod without
bounding it to the RMB. This patch bounds the producer cursor count
to rmb_desc->len when it comes off the wire for both SMC-R and SMC-D.

> diff --git a/net/smc/smc_cdc.h b/net/smc/smc_cdc.h
> index 696cc11f2303b..4d630a3051184 100644
> --- a/net/smc/smc_cdc.h
> +++ b/net/smc/smc_cdc.h
[ ... ]
> @@ -246,8 +253,9 @@ static inline void smcr_cdc_msg_to_host(struct smc_ho=
st_cdc_msg *local,
>  	local->len =3D peer->len;
>  	local->seqno =3D ntohs(peer->seqno);
>  	local->token =3D ntohl(peer->token);
> -	smc_cdc_cursor_to_host(&local->prod, &peer->prod, conn);
> -	smc_cdc_cursor_to_host(&local->cons, &peer->cons, conn);
> +	smc_cdc_cursor_to_host(&local->prod, &peer->prod, conn,
> +			       conn->rmb_desc->len);

[Severity: High]
Is it possible for conn->rmb_desc to be NULL here?

If an existing SMC-R link group is reused for a new connection,
smc_conn_create() inserts the connection into the globally visible
lgr->conns_all RB-tree via smc_lgr_register_conn(conn, true) before
the rmb_desc buffer is allocated by smc_buf_create().

Since the QP is already in RTS state, could a malicious remote peer sharing
the link group predict the new connection's alert_token_local (which is a
predictable atomic counter) and send a CDC message during this race window?

If so, smc_cdc_rx_handler() would find the connection and call
smcr_cdc_msg_to_host() without checking sk_state or if conn->rmb_desc is
allocated, leading to a NULL pointer dereference. Note that bh_lock_sock()
does not block softirqs from pre-empting or running concurrently with the
process-context lock_sock() held during setup.

> +	smc_cdc_cursor_to_host(&local->cons, &peer->cons, conn, 0);
>  	local->prod_flags =3D peer->prod_flags;
>  	local->conn_state_flags =3D peer->conn_state_flags;
>  }
> @@ -260,6 +268,9 @@ static inline void smcd_cdc_msg_to_host(struct smc_ho=
st_cdc_msg *local,
> =20
>  	temp.wrap =3D peer->prod.wrap;
>  	temp.count =3D peer->prod.count;
> +	/* as in smc_cdc_cursor_to_host(): bound prod, not cons */
> +	if (temp.count > conn->rmb_desc->len)
> +		temp.count =3D conn->rmb_desc->len;

[Severity: High]
Would the same race window affect SMC-D connections in smcd_cdc_msg_to_host=
(),
triggering a NULL pointer dereference if a CDC message is received before
the rmb_desc buffer is allocated?

>  	smc_curs_copy(&local->prod, &temp, conn);
> =20
>  	temp.wrap =3D peer->cons.wrap;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-disp-f3=
45196c-v7-0-ef3dddfbfa68@proton.me?part=3D1
