Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434DE1EFF93;
	Wed, 26 Aug 2026 03:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787714318; cv=none; b=pu+zAUM8CKaQtj+xr7OqkkF9+ElNrfFyCrgh735DGBgAaJeAsTktFvks/FdvoEJviofIz0I6Cm+LMlJQK6SwC6L54i+c0edzftV+lF51cQ1kCBV9utMWpZWRE0ZQOG2mUEZYanHiVmiXOkHkwxWuUn9FkmMxTL2XEFaiFdc9/Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787714318; c=relaxed/simple;
	bh=h8msQHr+CXsejwj0Tg9mxPlXdG/lbLNOfIaOqLqNyqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rYpYQXBj5ymfH6MQhNnZfv/Vab41SvOvT2dUh/HpNT5rs8yQekj6APqYbvW2cEcqhGquT85GsypDWlNQvNSNBvL42eZqHwekCuTMp+hWiQjGR11eG6+eaB0aISV6AECS4bcifET1dekpUJ60biw7neSkhfN/hRpf90jJrPDufaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=c0m3KFNY; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="c0m3KFNY"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787714312; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=Kyr8+8isRvv+cr0uQOk3l0k7AzeaOzG44yM3F3HZ2c0=;
	b=c0m3KFNY4Hm/pnCxvfqBZf3rLOzi7KTM7d9ar/g3RdQ8Wz9xUF5d2cmJGSt2Icu6wrfPHoWq5NTRCs580nKqq9LiDtpQklodK042xdUBxKnSCI2GJHyJ3KnZ0lDVd2iAiu5nwhuoBsFS6a3lqoRfzjBvS7awORNGt8jvtoTXDms=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X9fbpz2_1787714311;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0X9fbpz2_1787714311 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 26 Aug 2026 11:18:31 +0800
Date: Wed, 26 Aug 2026 11:18:31 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Mahanta Jambigi <mjambigi@linux.ibm.com>, andrew+netdev@lunn.ch,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, alibuda@linux.alibaba.com, sidraya@linux.ibm.com,
	hidayath@linux.ibm.com
Cc: pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com, netdev@vger.kernel.org,
	linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net] net/smc: serialize clcsock teardown in
 smc_accept_dequeue
Message-ID: <ao5bB9OCbJ5PQbEp@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20260824065851.1070988-1-mjambigi@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824065851.1070988-1-mjambigi@linux.ibm.com>

On 2026-08-24 08:58:51, Mahanta Jambigi wrote:
>smc_accept_dequeue() open-codes clcsock teardown for SMC_CLOSED child sockets
>without taking clcsock_release_lock:
>
>  new_sk->sk_prot->unhash(new_sk);
>  if (isk->clcsock) {
>      sock_release(isk->clcsock);
>      isk->clcsock = NULL;
>  }
>
>This bypasses the clcsock_release_lock discipline used elsewhere in SMC clcsock
>lifetime handling. In particular, other paths serialize clcsock access and
>updates with clcsock_release_lock, but this local teardown path does not.
>
>Fix it by taking clcsock_release_lock around the local teardown and by storing
>NULL before sock_release(), matching the established ordering used by other
>clcsock teardown paths.
>
>Fixes: 127f49705823 ("net/smc: release clcsock from tcp_listen_worker")
>Reviewed-by: Hidayath Khan <hidayath@linux.ibm.com>
>Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
>---
> net/smc/af_smc.c | 12 ++++++++----
> 1 file changed, 8 insertions(+), 4 deletions(-)
>
>diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
>index 00403175b740..bbf8269876ee 100644
>--- a/net/smc/af_smc.c
>+++ b/net/smc/af_smc.c
>@@ -1833,10 +1833,14 @@ struct sock *smc_accept_dequeue(struct sock *parent,
> 		smc_accept_unlink(new_sk);
> 		if (new_sk->sk_state == SMC_CLOSED) {
> 			new_sk->sk_prot->unhash(new_sk);
>-			if (isk->clcsock) {
>-				sock_release(isk->clcsock);
>-				isk->clcsock = NULL;
>-			}
>+			mutex_lock(&isk->clcsock_release_lock);
>+			if (isk->clcsock) {
>+				struct socket *clcsock = isk->clcsock;
>+
>+				isk->clcsock = NULL;
>+				sock_release(clcsock);
>+			}
>+			mutex_unlock(&isk->clcsock_release_lock);

Why not call smc_clcsock_release() here ?

After looking deeper into this issue, I found smc_diag_msg_common_fill()/
smc_getname() and many other branches hasn't hold lock_sock() and may also
have the race issue ? For example, smc_getname() calling smc->clcsock->ops->getname()
while the other workqueue is releasing the clcsock.

Since SMC has long been plagued by this kind of locking issue, I think we
should consider a long-term solution to address it.

What about stop releasing the clcsock early and tie its lifetime to the SMC
socket itself. The early paths don't really need to release it ??? a
kernel_sock_shutdown()/tcp_abort() is enough to stop it, and calling them more
than once is safe because the TCP layer already handles that.  sock_release()
is different: it frees the socket, so it must happen exactly once. If we move
this single release to the final teardown of the SMC socket, no user can exist
at that point anymore (fd users are gone after smc_release(), and every
work/accept-queue context holds a sock reference), which makes both
clcsock_release_lock and all the if (smc->clcsock) NULL checks removable.

Ideas ?

Best regards,
Dust
