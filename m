Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B9335DA7F;
	Thu, 23 Jul 2026 03:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784776451; cv=none; b=i4pWx/clKnoOS2m+72RZcQGeSLizGlpCPWV9g7iborWUb9kiBeng1qKJ0BiIZNqhnaESyR4isRHnlKhgYOC8986dl0BiLjEMjjIi8b59Mcs/R1kdk3BzVnTvGt41i9f9XYlxt6nHYqMNA6ylycYGi3NJ0vU2V4G0YqEDsv2qTAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784776451; c=relaxed/simple;
	bh=U+6X4Hn7v2FxBz0YWJ+3pn0gL2ifRjWnRb1e0elZgkQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lltwXl2omWDfGZ4Gm3BFD/9j22mQ8HhWEJyPNVE7beUZNKl9iBylgexCPO4nKV4Rl/7LxsDBr1TXNLVFsOo5TY9JRRjOxKjvWcqJr4cxJneJIA8Y9f1NHm/K8MVpnhEEmIwwL1IeRPEcMmuDy2Ph6foOy+OF44742B9l+6UZM5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=DqCX6O0m; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="DqCX6O0m"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784776445; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=uh07OLumvbhKMHFzl/98Q4fWI+dA3VAJ3YKixuoHIBQ=;
	b=DqCX6O0mwviE6O7RbV9ZvzoLWyqo8cRKrKAGnmfTjNKoxW5Dm5G1MaAxsgrI+EeXufD31rqRzf1CI7N+ucbtfhBlLvzEf6cpxiSLgQfODm+mDJW26wEXSPyu4fU1O/93H5wBU8u610Jyv0gio1wdxG1jCvygo1lMGPVoOvHGBfo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X7ejvXZ_1784776443;
Received: from 30.221.147.55(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0X7ejvXZ_1784776443 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 23 Jul 2026 11:14:04 +0800
Message-ID: <73c5bbf5-c9ed-4439-a76b-7f75c2c769f8@linux.alibaba.com>
Date: Thu, 23 Jul 2026 11:14:03 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v4 2/3] net/smc: reduce TX slot contention with
 exclusive wait
To: "D. Wythe" <alibuda@linux.alibaba.com>, mjambigi@linux.ibm.com,
 wenjia@linux.ibm.com, wintera@linux.ibm.com, dust.li@linux.alibaba.com,
 tonylu@linux.alibaba.com
Cc: kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, leonro@nvidia.com,
 pabeni@redhat.com, edumazet@google.com, sidraya@linux.ibm.com,
 jaka@linux.ibm.com, oliver.yang@linux.alibaba.com
References: <20260716113745.65234-1-alibuda@linux.alibaba.com>
 <20260716113745.65234-3-alibuda@linux.alibaba.com>
From: Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <20260716113745.65234-3-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/7/16 19:37, D. Wythe wrote:
> smc_wr_tx_get_free_slot() waits for a free TX slot with
> wait_event_interruptible_timeout(). Since the wait_event family
> enqueues waiters as non-exclusive, wake_up() may wake multiple
> waiters even though only one can use the slot, causing
> thundering-herd contention when slots are scarce.
> 
> Use an exclusive wait loop with prepare_to_wait_exclusive() so
> wake_up() wakes only one waiter per freed slot.
> smc_wr_wakeup_tx_wait() still uses wake_up_all() during link
> teardown, so teardown behavior is unchanged.
> 
> This also corrects the return value on a pending signal: the previous
> wait_event_interruptible_timeout() path fell through to the "no free
> slot" case and returned -EPIPE, masking the signal as a connection
> error. The open-coded loop now returns -ERESTARTSYS, matching the
> standard interruptible-wait semantics and letting the syscall restart
> machinery handle it.
> 
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> ---

Reviewed-by: Wen Gu <guwen@linux.alibaba.com>

Thanks.

>   net/smc/smc_wr.c | 36 ++++++++++++++++++++++++++----------
>   1 file changed, 26 insertions(+), 10 deletions(-)
> 
> diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
> index 6b5add922993..2cdd4063c13d 100644
> --- a/net/smc/smc_wr.c
> +++ b/net/smc/smc_wr.c
> @@ -198,11 +198,13 @@ int smc_wr_tx_get_free_slot(struct smc_link *link,
>   			    struct smc_rdma_wr **wr_rdma_buf,
>   			    struct smc_wr_tx_pend_priv **wr_pend_priv)
>   {
> +	unsigned long timeout = SMC_WR_TX_WAIT_FREE_SLOT_TIME;
>   	struct smc_link_group *lgr = smc_get_lgr(link);
>   	struct smc_wr_tx_pend *wr_pend;
>   	u32 idx = link->wr_tx_cnt;
>   	struct ib_send_wr *wr_ib;
>   	u64 wr_id;
> +	DEFINE_WAIT(wait);
>   	int rc;
>   
>   	*wr_buf = NULL;
> @@ -212,17 +214,31 @@ int smc_wr_tx_get_free_slot(struct smc_link *link,
>   		if (rc)
>   			return rc;
>   	} else {
> -		rc = wait_event_interruptible_timeout(
> -			link->wr_tx_wait,
> -			!smc_link_sendable(link) ||
> -			lgr->terminating ||
> -			(smc_wr_tx_get_free_slot_index(link, &idx) != -EBUSY),
> -			SMC_WR_TX_WAIT_FREE_SLOT_TIME);
> -		if (!rc) {
> -			/* timeout - terminate link */
> -			smcr_link_down_cond_sched(link);
> -			return -EPIPE;
> +		rc = 0;
> +		for (;;) {
> +			prepare_to_wait_exclusive(&link->wr_tx_wait, &wait,
> +						  TASK_INTERRUPTIBLE);
> +			if (!smc_link_sendable(link) || lgr->terminating ||
> +			    smc_wr_tx_get_free_slot_index(link, &idx) != -EBUSY)
> +				break;
> +			timeout = schedule_timeout(timeout);
> +			/* re-check */
> +			if (!smc_link_sendable(link) || lgr->terminating ||
> +			    smc_wr_tx_get_free_slot_index(link, &idx) != -EBUSY)
> +				break;
> +			if (!timeout) {
> +				/* timeout - terminate link */
> +				smcr_link_down_cond_sched(link);
> +				break;
> +			}
> +			if (signal_pending(current)) {
> +				rc = -ERESTARTSYS;
> +				break;
> +			}
>   		}
> +		finish_wait(&link->wr_tx_wait, &wait);
> +		if (rc)
> +			return rc;
>   		if (idx == link->wr_tx_cnt)
>   			return -EPIPE;
>   	}

