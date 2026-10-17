Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A74713DBBD;
	Sat, 17 Oct 2026 03:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792207861; cv=none; b=gJMxlP2l1qolh0TI8BcALO1YZYn7jJ736cqAgp8oivBlkaJy3Llm4wuicKOyxAiNE8HUoHWBlQCcDu6q5cxsTYt1prEf40sodkVmm8Lc/JZqEuiX0MLKYwH2JgvgeQ1zCC8Xk5V4Z92uCKq8OW+4pIFoZ8URgVT6Elpzj+ioL5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792207861; c=relaxed/simple;
	bh=4htGvYAaz+HNY/W5RkM0Qnrrlup/q0CU9Pnb/p7ag3Y=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FK//xMy7icWomisQqxylYb4nF8mmCB2DEJrPs1nP2GBhkqLguWDOHRiCvnmBHqAIX4jIqaQI79R8+OIt7MH509xMkVexxyXSLYLDCWL1WoLATlB82QlnXTiPwYfuB5KZClTBeaP6tRNaJlUjssBYdAKQFUuU5M2dF79zeOD/zkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hs+Zeub9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hs+Zeub9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D7A1F000C4;
	Sat, 17 Oct 2026 03:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792207860;
	bh=ZUxYoYWAabNcZrZ6jwTO0vLugKf54gQSbtB94tzJeSs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Hs+Zeub9KwGIrN7zoLvKtohPZLiVxJtCwm851oR+c2wWFj86LZuGOrCbOkCwsKSOt
	 XUtocbQVs4gvRO8Md6CUmJEoKnc67oocX/iMNmXW5HM0n0RCxpUwkGMTHVI6zrxWfh
	 KNpkHPL3vvpLl0SDwflBJto/CuKtqVsfNHagri+6m3Dfbjw8Fz2nun4q8Jn6pnxF5l
	 RoffcjsyEojEMVZYynwR0L1Ljv0lOyIEkuj05jajhjISgimL4Qcc5GyyN3zEyZYxZE
	 wAnuYYKDE1MdBpoqW9tlhpEZEZHq6KpRmt62lguq8lxbP7sFDW5WCkAv+hjaoiu9W9
	 wSxQpBFQJtIrg==
Message-ID: <d0f8499622c1b81505ecfafa4fd056840d5cfd89.camel@kernel.org>
Subject: Re: [PATCH] net/rds: ib: don't enable IRQs in rds_ib_conn_free()
From: Allison Henderson <achender@kernel.org>
To: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>, "David S . Miller"
	 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>, netdev@vger.kernel.org, 
 linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, 
 linux-kernel@vger.kernel.org, 
 syzbot+c3741bb338b5c6d6a4aa@syzkaller.appspotmail.com,
 stable@vger.kernel.org
Date: Fri, 16 Oct 2026 20:30:58 -0700
In-Reply-To: <20261016161525.146537-1-ngocthang2710.1999@gmail.com>
References: <20261016161525.146537-1-ngocthang2710.1999@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-10-16 at 23:15 +0700, Nguyen Ngoc Thang wrote:
> __rds_conn_create() calls trans->conn_free() with rds_conn_lock held
> and IRQs disabled when it loses the race to insert a connection.
> rds_ib_conn_free() takes the device list lock with spin_lock_irq() and
> releases it with spin_unlock_irq(), so IRQs are turned on while
> rds_conn_lock is still held:
>=20
>   raw_local_irq_restore() called with IRQs enabled
>   WARNING: kernel/locking/irqflag-debug.c:10 at warn_bogus_irq_restore+0x=
c/0x20
>    _raw_spin_unlock_irqrestore+0x67/0x80
>    __rds_conn_create+0x1de5/0x2290
>    rds_conn_create_outgoing+0x43/0x60
>    rds_sendmsg+0xfca/0x20e0
>    __sys_sendto+0x408/0x5a0
>=20
> It needs an RDS socket bound to an address on an RDMA device (e.g. rxe)
> and two concurrent sendto() calls to the same new destination.
>=20
> The TCP and loopback ->conn_free() callbacks already use irqsave, so
> do the same here.
>=20
> Fixes: 745cbccac3fe ("RDS: Rewrite connection cleanup, fixing oops on rmm=
od")
> Reported-by: syzbot+c3741bb338b5c6d6a4aa@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dc3741bb338b5c6d6a4aa
> Cc: stable@vger.kernel.org
> Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

Hi Nguyen,

Thanks for the fix.  This is the same change as patch 1 of the
connection-lifetime series pending for net-next ("net/rds: ib: don't
enable interrupts in rds_ib_conn_free()").  But that's a much bigger set
that's been churning for a while.  Since yours is stand alone with the
syzbot report for net, it's fine for yours to go first.  I'll drop my
patch 1 when your patch lands.

Reviewed-by: Allison Henderson <achender@kernel.org>

Thanks!
Allison

> ---
>  net/rds/ib_cm.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> index 6e3110a04ae6..5c717120eab5 100644
> --- a/net/rds/ib_cm.c
> +++ b/net/rds/ib_cm.c
> @@ -1271,6 +1271,7 @@ void rds_ib_conn_free(void *arg)
>  {
>  	struct rds_ib_connection *ic =3D arg;
>  	spinlock_t	*lock_ptr;
> +	unsigned long flags;
> =20
>  	rdsdebug("ic %p\n", ic);
> =20
> @@ -1281,9 +1282,10 @@ void rds_ib_conn_free(void *arg)
>  	 */
>  	lock_ptr =3D ic->rds_ibdev ? &ic->rds_ibdev->spinlock : &ib_nodev_conns=
_lock;
> =20
> -	spin_lock_irq(lock_ptr);
> +	/* May be called with IRQs already disabled (see __rds_conn_create()) *=
/
> +	spin_lock_irqsave(lock_ptr, flags);
>  	list_del(&ic->ib_node);
> -	spin_unlock_irq(lock_ptr);
> +	spin_unlock_irqrestore(lock_ptr, flags);
> =20
>  	rds_ib_recv_free_caches(ic);
> =20

