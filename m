Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD1C30AD05;
	Fri,  9 Oct 2026 06:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791526367; cv=none; b=I5snC7K2ZVmlcB8vETr1MMIsTHAl4mj9YA/x0CZgry3Yx4z0FiTcVQ1z8q0FIiqVFclz5Hy5IbJxnZh4OoUMhi3994eBTZheWywHYvgT9aiuP7gEbW9U96/wfyEGYQLQOQl30GvzrizAtc0kjG9tCpg0mRUQAonAAgXRnKLJj4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791526367; c=relaxed/simple;
	bh=rW1+QOl6CAsz8HkXRATz37lmdJ3RdhiJLeNTq5W7IiQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=jsbBI0jeji7GFFcl8Sx1yA27OWdjBJ5rsbPuyV79vHSZoxAYz1xqGBbSeP5ZzmKxrPvh0ywGh9YRzrbcY2wVLGhxh3uvJQtT0tmm9DFBydQZ/9uemkFq4nQ/7NyjFsqTiJ9CvjpNk0ouRpuN3/vlVrEj4S+BdxkG+wl0DzivB6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lmWim0+h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lmWim0+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8924A1F00893;
	Fri,  9 Oct 2026 06:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791526366;
	bh=r38nT3rgxcMhpN3S6ECNSW4Uv8zRvToSv8TwZsmUckY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lmWim0+hVu8sQKeMFeD4jqcvsvjfTYh+RT+qjfwjZgZnl649PmgPgylOoFTP1I45x
	 4BYOvPbQbdaXU4J8+4ufluBGJbkRoEqfUWYsHUQ8/xmHCsPBYeq/rm1//53/p7fe0t
	 JKJ5nAj/aGwuUh3tssCUMvg/g5NxQckirQLS6MUTo0LjUPAUPnOQhD7G7L0eHrqESF
	 SJZRSvmPymLi1C8r7HaDdUtS++63ZpNvREnXSLkmu43QfvwqRzcMOuo5B9nL80WQoN
	 3hllTWyh4jjyPP87JAZvHUSd9g9jJD3Nd7y9olhglNaPFK6uGtc/KwLu/BUN1rXPOf
	 IF0u8Lmtnxndw==
Message-ID: <sashiko-outbox-164917@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v6 1/3] net/smc: bound the wire-controlled producer
 cursor to the RMB
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-rdma@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>
In-Reply-To: <20261008-b4-disp-f7cd3d96-v6-1-fba616c0920c@proton.me>
References: <20261008-b4-disp-f7cd3d96-v6-0-fba616c0920c@proton.me>
 <20261008-b4-disp-f7cd3d96-v6-1-fba616c0920c@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 06:12:45 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] smc: NULL pointer deref in smcr_cdc_msg_to_host() via token guessi=
ng race
--

commit 841c4fb2c2d0123708a65170d68d2745b02a7ce8
Author: Bryam Vargas <hexlabsecurity@proton.me>

net/smc: bound the wire-controlled producer cursor to the RMB

This commit bounds the wire-controlled producer cursor to the receive
buffer length in smcr_cdc_msg_to_host() and smcd_cdc_msg_to_host(). This
prevents a peer from advertising a producer cursor past the buffer bounds
and disclosing adjacent kernel memory during urgent data path processing.

> diff --git a/net/smc/smc_cdc.h b/net/smc/smc_cdc.h
> --- a/net/smc/smc_cdc.h
> +++ b/net/smc/smc_cdc.h
[ ... ]
> @@ -246,8 +256,13 @@ static inline void smcr_cdc_msg_to_host(struct smc_h=
ost_cdc_msg *local,
>  	local->len =3D peer->len;
>  	local->seqno =3D ntohs(peer->seqno);
>  	local->token =3D ntohl(peer->token);
> -	smc_cdc_cursor_to_host(&local->prod, &peer->prod, conn);
> -	smc_cdc_cursor_to_host(&local->cons, &peer->cons, conn);
> +	/* bound the wire-controlled producer cursor to our RMB (used as a raw
> +	 * index by the urgent path); leave the consumer cursor unbounded -- it
> +	 * indexes the peer's RMB and is bounded by peer_rmbe_size.
> +	 */
> +	smc_cdc_cursor_to_host(&local->prod, &peer->prod, conn,
> +			       conn->rmb_desc->len);

[Severity: High]
Can this lead to a NULL pointer dereference?

There appears to be a race window where conn->rmb_desc can be NULL when this
code is executed. In af_smc.c, smc_connect_rdma() registers the connection
via smc_conn_create() before the send buffer and RMB are created via
smc_buf_create():

af_smc.c:smc_connect_rdma() {
    ...
    reason_code =3D smc_conn_create(smc, ini);
    ...
    if (smc_buf_create(smc, false)) {
    ...
}

During smc_conn_create(), smc_lgr_register_conn() is called, which makes the
connection globally visible with a highly predictable token:

smc_core.c:smc_lgr_register_conn() {
    ...
    while (!conn->alert_token_local) {
        conn->alert_token_local =3D atomic_inc_return(&nexttoken);
        if (smc_lgr_find_conn(conn->alert_token_local, conn->lgr))
            conn->alert_token_local =3D 0;
    }
    smc_lgr_add_alert_token(conn);
    ...
}

If an unauthenticated remote peer on the same RoCE network guesses the token
and sends a CDC message over the active link before smc_buf_create() alloca=
tes
the rmb_desc, smc_cdc_rx_handler() will process the message and call
smcr_cdc_msg_to_host(). This would cause a kernel panic when trying to acce=
ss
conn->rmb_desc->len.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008-b4-disp-f7=
cd3d96-v6-0-fba616c0920c@proton.me?part=3D1
