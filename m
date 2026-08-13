Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CC8437476;
	Thu, 13 Aug 2026 07:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786606187; cv=none; b=QRQxYvjwsviGUreOmmAswf73esZtrsgws0HM2qr/udK9wIfDqiW9fFXG34DgxuXXk+rjfaegNzdicvVoBZPzO7WoeeCZ5LFr6tV0yJJsWLN0S5a2xrJlzZTwbynEBraAk54xdbVqx5anfyFmdNJns+j2VgIhnNtYo/QtKiADTPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786606187; c=relaxed/simple;
	bh=R9f4kQk+r1GRAQ2q85VnOycd3tI1TmBtUwlBa1JfC6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Um4A5LrrPVQhcl9QQub65fidTQxpPOoOvd/l855zokyAp+l4ggqXlgGRX/qWnEBOXP31is1tmhsI4Zllz0FeONSx8gsbRoe1QKVA4296CeSqUG6z7E2c2iANYtbAp31SXTgApEbITEiz144I82fcdzv3/IIzRaM9Nr1Mw0wlp1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ZORU2Ira; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ZORU2Ira"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786606176; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=SrESeyRFvqT3UEMCU9ti87jiDJEkuLcuUagh32sFTvo=;
	b=ZORU2IramQSXm/iz349hJYNwcfCJ7yxvLfRbvcW1kpxPmeimOzREoIH6uI4gyPyMNFBHVSZC0DPPLMJQEqrvDrDkL+W3lGdjQ+cbgOdYEdfyNIbtJmCZ+NjXs4cU2pgL10i+A8P12BzTh+csYF1K8NMMxdSgG6olwDJmo4aVcRw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X8tXQwn_1786606175;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0X8tXQwn_1786606175 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 13 Aug 2026 15:29:35 +0800
Date: Thu, 13 Aug 2026 15:29:35 +0800
From: Tony Lu <tonylu@linux.alibaba.com>
To: hexlabsecurity@proton.me
Cc: Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
	Simon Horman <horms@kernel.org>, linux-s390@vger.kernel.org
Subject: Re: [PATCH net v2 2/2] net/smc: do not dereference an unset send
 buffer on the SMC-D teardown path
Message-ID: <an1yXz_py0bdy80q@TONYMAC-ALIBABA.local>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20260808-b4-disp-22f119e6-v2-0-61647601a6f3@proton.me>
 <20260808-b4-disp-22f119e6-v2-2-61647601a6f3@proton.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260808-b4-disp-22f119e6-v2-2-61647601a6f3@proton.me>

On Sat, Aug 08, 2026 at 02:21:24AM -0500, Bryam Vargas via B4 Relay wrote:
> From: Bryam Vargas <hexlabsecurity@proton.me>
> 
> smc_close_stream_wait() calls smc_tx_prepared_sends() from inside its
> sk_wait_event() condition, and sk_wait_event() evaluates that condition
> once with the socket lock released. smcd_buf_detach() clears
> conn->sndbuf_desc from smc_conn_kill() under lock_sock(), so a link group
> terminating while a socket waits there leaves the helper dereferencing
> NULL, faulting out of close(). SIOCOUTQ reads the field by hand, and
> smc_close_cancel_work() drops the lock across two cancel_*_sync() calls.
> 
> Sample the pointer once in the helper, report nothing prepared while it is
> unset, and bound the ioctl the same way. The receive tasklet dereferences
> the field directly in smc_cdc_msg_recv_action(), not through this helper;
> 1/2 is what keeps it from running that late.
> 
> Fixes: ae2be35cbed2 ("net/smc: {at|de}tach sndbuf to peer DMB if supported")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>

> ---
>  net/smc/af_smc.c | 3 ++-
>  net/smc/smc_tx.h | 6 +++++-
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index 00403175b740..cff910cedbfc 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -3233,7 +3233,8 @@ int smc_ioctl(struct socket *sock, unsigned int cmd,
>  			return -EINVAL;
>  		}
>  		if (smc->sk.sk_state == SMC_INIT ||
> -		    smc->sk.sk_state == SMC_CLOSED)
> +		    smc->sk.sk_state == SMC_CLOSED ||
> +		    !READ_ONCE(smc->conn.sndbuf_desc))
>  			answ = 0;
>  		else
>  			answ = smc->conn.sndbuf_desc->len -
> diff --git a/net/smc/smc_tx.h b/net/smc/smc_tx.h
> index a59f370b8b43..610a945aefd6 100644
> --- a/net/smc/smc_tx.h
> +++ b/net/smc/smc_tx.h
> @@ -20,11 +20,15 @@
>  
>  static inline int smc_tx_prepared_sends(struct smc_connection *conn)
>  {
> +	struct smc_buf_desc *sndbuf_desc = READ_ONCE(conn->sndbuf_desc);
>  	union smc_host_cursor sent, prep;
>  
> +	if (!sndbuf_desc)
> +		return 0;
> +
>  	smc_curs_copy(&sent, &conn->tx_curs_sent, conn);
>  	smc_curs_copy(&prep, &conn->tx_curs_prep, conn);
> -	return smc_curs_diff(conn->sndbuf_desc->len, &sent, &prep);
> +	return smc_curs_diff(sndbuf_desc->len, &sent, &prep);
>  }
>  
>  void smc_tx_pending(struct smc_connection *conn);
> 
> -- 
> 2.55.0
> 
