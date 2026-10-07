Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D964119F2;
	Wed,  7 Oct 2026 07:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791358567; cv=none; b=nA33DlXb5FY3xpaiCv7YzI7fU4MKsM8H+lx9LPAXRqRDnl6eRHTqfTmPYeYh6ZHkZd6hvzJOqcOEANPItSoSy0fjv5Q1fRR6nWorR5Vis98lnK0SJ6Y6Kfw8IQ9jbgY8To8ZIbHDPT2WAq6wXjXqxqpQWTRmKERoDfTBpVpehW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791358567; c=relaxed/simple;
	bh=5pXeJttJkl0s/GsBDvdu3Qw4DOLa5agfZfKA3FzqLRk=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=A/M4XAd5NQtmMLfueClSkjQUT+RfB0t64s7KwzrYgvgvOyw+ULxWRsBYMcgy3xnBxXPt9GpnamXXpF2BVfTemuYzA1ILLavZfowUaQwMS91VPK83l6nVJMh56r0y/avkZGOEqyjuMrpwjRB3Cu0ig8FNQVy18OQLu/Tyht2nkic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IJTE8Z/T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IJTE8Z/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A431F0089B;
	Wed,  7 Oct 2026 07:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791358565;
	bh=4uKv6vMSg/oBjYDMaeegDobSI3yYRTcC+FGY8h95PZY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IJTE8Z/TkmWks7h3YWCDWvbcCB/0NIOKDLwRkohDkTm2bSeGzmT3tTo13+1pW17So
	 7RgIFRSYyPns3e9200lEOY9DaavlITt1RRfglGnKBtUFGIIy9YMZKJBILoVlwGfWHw
	 E7HYcLXwf3BtV2cdm9RV2aABB0kikNqHOBqgGHbPtg8exIE+X097iCSk7iMzVJ94La
	 gsDcPOb7o9WtgdVm+H/yJi00KjbehpQZ80270uUIGmPoqI9UwIR2+NUhobXzZ/FKkH
	 2Po261MGhtrHm+oqdxYAOJVtjF6iqzJntuFKvO4kPQngSCyDhJeKbwUAnh0raeuMzP
	 iXeysGdEWB8sA==
Message-ID: <sashiko-outbox-162715@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v3] net/smc: fix abort_work termination in
 smc_conn_free()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hidayath Khan" <hidayath@linux.ibm.com>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261006073550.1595003-1-hidayath@linux.ibm.com>
References: <20261006073550.1595003-1-hidayath@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 07:36:05 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] net/smc: zombie abort_work terminates valid fallback connection
--

commit cebb96f694baa10cd5a7d057d497a08031c69485
Author: Hidayath Khan <hidayath@linux.ibm.com>

net/smc: fix abort_work termination in smc_conn_free()

This commit switches smc_conn_free() to use a non-blocking cancel_work()
for abort_work to avoid deadlocks. It also adds a check for conn->freed
inside smc_conn_abort_work() and initializes abort_work once per socket
in smc_sk_init() instead of per connection.

Link: https://lore.kernel.org/netdev/20260806081549.595001-1-hidayath@linux=
.ibm.com/

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 9974149659c2f..907530e1d6464 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c

[ ... ]

> @@ -1276,8 +1280,13 @@ void smc_conn_free(struct smc_connection *conn)
>  			smcd_buf_detach(conn);
>  	} else {
>  		smc_cdc_wait_pend_tx_wr(conn);
> -		if (current_work() !=3D &conn->abort_work)
> -			cancel_work_sync(&conn->abort_work);
> +		/* Do not wait here: the work takes the socket lock this
> +		 * caller holds. An instance that is already running is
> +		 * parked on that lock and will find conn->freed set; only a
> +		 * still-pending one has to give its reference back.
> +		 */
> +		if (cancel_work(&conn->abort_work))
> +			sock_put(&smc->sk);

[Severity: High]
Does changing this to a non-blocking cancel_work() introduce a race with
server-side fallback connections?

During server listen, smc_listen_find_device() iterates over proposed
devices while holding the socket lock. If an initial connection attempt
calls smc_conn_create() but fails and is aborted via smc_conn_free(), an
abort_work queued concurrently could transition to running but block on the
socket lock.

Since cancel_work() does not wait, it would return false for the running
worker and leave it parked on the lock. When the fallback loop continues,
it calls smc_conn_create() for the next device on the same socket, which
unconditionally resets the flag:

net/smc/smc_core.c:smc_conn_create() {
    ...
    conn->freed =3D 0;
    ...
}

When the fallback connection ultimately succeeds and releases the socket
lock, could the parked abort_work unblock, observe the reset conn->freed
flag, and erroneously call smc_conn_kill() on the new, valid connection?

>  	}
>  	if (!list_empty(&lgr->list)) {
>  		smc_buf_unuse(conn, lgr); /* allow buffer reuse */

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006073550.1595=
003-1-hidayath@linux.ibm.com?part=3D1
