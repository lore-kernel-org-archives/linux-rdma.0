Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0857F3C4551;
	Mon,  8 Jun 2026 14:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780927488; cv=none; b=j4vy4vkuHVjtJwDpMaZ5J97NCYKuz9poIz1P0Zrg+VheokCIFhrhTJNRytu4EBv7V61ZR+KJ+4gKCyEu0RfCtG7UxLqGhLyP/ojtTloPAStouEppxJcTGpj+2NDBzy2z5tkepyMoZcP/m9i+TQzUXVEAF7tiW5ub11p063Txk9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780927488; c=relaxed/simple;
	bh=o9ZqeZQndmaawdy1VD/8gxEmuhGgfg1vq5AT0Ln5GrM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t4Hlq0HCxtxrULOiZcCrOCAu8/ublYzwvbY03YT9ybNGpsPDtzCgMAE6YNTzkxx4uftZEKcTrW2+xaulnwlAnIwiond6izG5McfrQczEKH/rdrGPpFvS8GlQ026vAwfJV6bo2cRwGvPCG+I0LL+UVbQRqHGFK35lpt7UPoQzhYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=kJF5s6UJ; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="kJF5s6UJ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780927476; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=FzmVchP79tCuI2XT+vBVQjUl7+ilYcFgXsd3+S4/940=;
	b=kJF5s6UJIBhDkFlRchtrOl5qM/4P72r+q5cLmv4lMSxaxrJX7M9Gz745XkWqWNKNMqNUx8+baz3lf5M/Ec0uoYF/tYCEJU48YBI4pJ6R4obRKKAOY2XridSCf8RLrh8hJXZPKgX+14rKekyHRxDhWLL6RiKIzd8pr6j6NwUdCQI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X4Q0kgv_1780927475;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0X4Q0kgv_1780927475 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 08 Jun 2026 22:04:35 +0800
Date: Mon, 8 Jun 2026 22:04:34 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: "D. Wythe" <alibuda@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>
Cc: Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
	netdev@vger.kernel.org, oliver.yang@linux.alibaba.com,
	pasic@linux.ibm.com
Subject: Re: [PATCH net-next v2 2/2] net/smc: reduce TX slot contention with
 exclusive wait
Message-ID: <aibL8g1hxAcZzPRJ@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20260528084819.6059-1-alibuda@linux.alibaba.com>
 <20260528084819.6059-3-alibuda@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528084819.6059-3-alibuda@linux.alibaba.com>

On 2026-05-28 16:48:19, D. Wythe wrote:
>smc_wr_tx_get_free_slot() waits for a free TX slot with
>wait_event_interruptible_timeout(). Since the wait_event family
>enqueues waiters as non-exclusive, wake_up() may wake multiple
>waiters even though only one can use the slot, causing
>thundering-herd contention when slots are scarce.
>
>Use an exclusive wait loop with prepare_to_wait_exclusive() so
>wake_up() wakes only one waiter per freed slot.
>smc_wr_wakeup_tx_wait() still uses wake_up_all() during link
>teardown, so teardown behavior is unchanged.
>
>Performance measured with netperf TCP_RR (63 flows, 200B write /
>1000B read, 60s duration):
>
>+-------------------------------+---------------+---------------+
>| smcr_max_conns_per_lgr        | 32            | 255           |
>|-------------------------------+---------------+---------------|
>| before                        | 4.85 Gb/s     | 657.95 Mb/s   |
>|-------------------------------+---------------+---------------|
>| after                         | 5.01 Gb/s     | 2.2 Gb/s      |
>+-------------------------------+---------------+---------------+
>
>Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
>---
> net/smc/smc_wr.c | 36 ++++++++++++++++++++++++++----------
> 1 file changed, 26 insertions(+), 10 deletions(-)
>
>diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
>index 130bc6c26fb3..3cb47f77130e 100644
>--- a/net/smc/smc_wr.c
>+++ b/net/smc/smc_wr.c
>@@ -153,9 +153,11 @@ int smc_wr_tx_get_free_slot(struct smc_link *link,
> 			    struct smc_rdma_wr **wr_rdma_buf,
> 			    struct smc_wr_tx_pend_priv **wr_pend_priv)
> {
>+	unsigned long timeout = SMC_WR_TX_WAIT_FREE_SLOT_TIME;
> 	struct smc_link_group *lgr = smc_get_lgr(link);
> 	struct smc_wr_tx_pend *wr_pend;
> 	u32 idx = link->wr_tx_cnt;
>+	DEFINE_WAIT(wait);
> 	int rc;
> 
> 	*wr_buf = NULL;
>@@ -165,17 +167,31 @@ int smc_wr_tx_get_free_slot(struct smc_link *link,
> 		if (rc)
> 			return rc;
> 	} else {
>-		rc = wait_event_interruptible_timeout(
>-			link->wr_tx_wait,
>-			!smc_link_sendable(link) ||
>-			lgr->terminating ||
>-			(smc_wr_tx_get_free_slot_index(link, &idx) != -EBUSY),
>-			SMC_WR_TX_WAIT_FREE_SLOT_TIME);
>-		if (!rc) {
>-			/* timeout - terminate link */
>-			smcr_link_down_cond_sched(link);
>-			return -EPIPE;
>+		rc = 0;
>+		for (;;) {
>+			prepare_to_wait_exclusive(&link->wr_tx_wait, &wait,
>+						  TASK_INTERRUPTIBLE);
>+			if (!smc_link_sendable(link) || lgr->terminating ||
>+			    smc_wr_tx_get_free_slot_index(link, &idx) != -EBUSY)
>+				break;
>+			timeout = schedule_timeout(timeout);
>+			/* re-check */
>+			if (!smc_link_sendable(link) || lgr->terminating ||
>+			    smc_wr_tx_get_free_slot_index(link, &idx) != -EBUSY)
>+				break;
>+			if (!timeout) {
>+				/* timeout - terminate link */
>+				smcr_link_down_cond_sched(link);
>+				break;
>+			}

The change itself looks correct to me. But I think we should probably define
a wait_event_interruptible_exclusive_timeout() helper in include/linux/wait.h
rather than open-coding it in smc ?

>+			if (signal_pending(current)) {
>+				rc = -ERESTARTSYS;
>+				break;
>+			}
> 		}

One more thing, seems we changed the signal here, it's better to add a comment
or note it in the commit message.

Best regards,
Dust

