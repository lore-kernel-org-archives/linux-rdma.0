Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E137435EC0;
	Thu, 13 Aug 2026 07:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786606153; cv=none; b=NR5S2dMj4T/oBH4XGUD5uyCkwnWNFVL2twtnlk5UwI8g6E7oXuSMMcQswIxZW8zmLNQQFM4y2qIOIXZ8Cvqg4o0RZ985THfkCjX+RH+aEe6txtNr9iE9bcGOpMoLtH5Heju2Hs8zQHAG1S5/9a/sry5fHFavW9GWJAwuCeyXI78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786606153; c=relaxed/simple;
	bh=ZcMvekwqkBVuW0utLG8dyGFQxlkW9xGnxmAR17JH+Zc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=obJqhAcTZUHhy916yh8xCSmzSz6k/haUJ8AzIB+cxIzDhPifBQCSKYr1QFfRPwVcrisnFfxKSTckFo29j9RdvRms1CmuQUrQeOgZfjDbwjbGtldOYxqLkaiP0yHtqpPCal8TrM7X4kmbjzhtxcyUz2mQJCmu8Jlh6kubfvaCny0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=qXIBAV7w; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="qXIBAV7w"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786606143; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=171Nn1Qu0WbABudm80PxbAQ5xosJQTr63Fxtm6EKRFg=;
	b=qXIBAV7wgRR7fAY3R/th1wYYXA1u706vwgQdA9UCm/L/fggdixOFUb9gGOcphhMn3lni3Q2mAF4pDlmGb+XuwASVef/8ShSHF3hGjzSMLYIkrZGTvZtaZYvcHNYsWM9PXF4SWDGtHUJpZtTFDzsLxR1LaYUT5QH7MO0z/+QrCUE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X8tYZ5m_1786606141;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0X8tYZ5m_1786606141 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 13 Aug 2026 15:29:02 +0800
Date: Thu, 13 Aug 2026 15:29:00 +0800
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
Subject: Re: [PATCH net v2 1/2] net/smc: unregister the connection before
 draining the rx tasklet
Message-ID: <an1yPOa-GoiXLvH5@TONYMAC-ALIBABA.local>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20260808-b4-disp-22f119e6-v2-0-61647601a6f3@proton.me>
 <20260808-b4-disp-22f119e6-v2-1-61647601a6f3@proton.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260808-b4-disp-22f119e6-v2-1-61647601a6f3@proton.me>

On Sat, Aug 08, 2026 at 02:21:23AM -0500, Bryam Vargas via B4 Relay wrote:
> From: Bryam Vargas <hexlabsecurity@proton.me>
> 
> smc_conn_free() calls smc_ism_unset_conn() only while the link group is
> still on its device list, and never sets conn->killed.
> smc_lgr_terminate_sched() unlinks the group immediately and defers killing
> its connections to a work item, so a connection freed in that window keeps
> its smcd->conn[] slot with both gates in smcd_handle_irq() open, and the
> device can re-arm the receive tasklet after tasklet_kill() has returned. On
> the DMB-nocopy path the ghost send buffer is freed right after that drain,
> so the re-armed tasklet dereferences it.
> 
> Unregister unconditionally and drain before the detach at both teardown
> sites, mirroring rmb_desc, which smc_buf_unuse() releases after the drain.
> Clear conn->sndbuf_desc before freeing it as well, so a reader that samples
> the pointer cannot get one that is already freed.
> 
> Fixes: ae2be35cbed2 ("net/smc: {at|de}tach sndbuf to peer DMB if supported")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>

> ---
>  net/smc/smc_core.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index b4208cb186c5..181647982490 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1209,14 +1209,16 @@ static void smcd_buf_detach(struct smc_connection *conn)
>  {
>  	struct smcd_dev *smcd = conn->lgr->smcd;
>  	u64 peer_token = conn->peer_token;
> +	struct smc_buf_desc *buf_desc;
>  
>  	if (!conn->sndbuf_desc)
>  		return;
>  
>  	smc_ism_detach_dmb(smcd, peer_token);
>  
> -	kfree(conn->sndbuf_desc);
> +	buf_desc = conn->sndbuf_desc;
>  	conn->sndbuf_desc = NULL;
> +	kfree(buf_desc);
>  }
>  
>  static void smc_buf_unuse(struct smc_connection *conn,
> @@ -1268,11 +1270,10 @@ void smc_conn_free(struct smc_connection *conn)
>  		goto lgr_put;
>  
>  	if (lgr->is_smcd) {
> -		if (!list_empty(&lgr->list))
> -			smc_ism_unset_conn(conn);
> +		smc_ism_unset_conn(conn);
> +		tasklet_kill(&conn->rx_tsklet);
>  		if (smc_ism_support_dmb_nocopy(lgr->smcd))
>  			smcd_buf_detach(conn);
> -		tasklet_kill(&conn->rx_tsklet);
>  	} else {
>  		smc_cdc_wait_pend_tx_wr(conn);
>  		if (current_work() != &conn->abort_work)
> @@ -1525,12 +1526,12 @@ static void smc_conn_kill(struct smc_connection *conn, bool soft)
>  	smc_sk_wake_ups(smc);
>  	if (conn->lgr->is_smcd) {
>  		smc_ism_unset_conn(conn);
> -		if (smc_ism_support_dmb_nocopy(conn->lgr->smcd))
> -			smcd_buf_detach(conn);
>  		if (soft)
>  			tasklet_kill(&conn->rx_tsklet);
>  		else
>  			tasklet_unlock_wait(&conn->rx_tsklet);
> +		if (smc_ism_support_dmb_nocopy(conn->lgr->smcd))
> +			smcd_buf_detach(conn);
>  	} else {
>  		smc_cdc_wait_pend_tx_wr(conn);
>  	}
> 
> -- 
> 2.55.0
> 
