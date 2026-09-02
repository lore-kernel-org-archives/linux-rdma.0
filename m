Received: from mta0.migadu.com (out-121.mta0.migadu.com [91.218.175.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C7D399899
	for <linux-rdma@vger.kernel.org>; Wed,  2 Sep 2026 07:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.121
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788335924; cv=none; b=I6hr3Okb0Sk5BaIuJOmFPThj1+fbykXa7ciuJgY12yzz+C047fSYlrNbdSiBsIKqSPappwfNjq9aDFwLO/w1TM1sJdDTjI2Dq49ghGqhPw3w5vrxNiY1nJwYt7bXq/+aUx34yPZj3wMHvbx47NSZj3BJvRbcIxaQIAtTXsMCT6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788335924; c=relaxed/simple;
	bh=8/mxER8tQ/jM0UjHuhFZAfTGDg4iwkRPnN25i6PnJtE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YzAJhUkO6bGu0EKKVI/58MnjyxuOckrEbhYhx0jjt5DGvIHMLb2MQUMPqtDm/gHcM+m3U/Xdr+XAzuEDblsZn/6lFUxMAGxZ6azDOvlkyNha87eJZ+UphDvFiwl6uZI9BZWSmX64ghojtAqVz6vMJRoR8Hmvkg1A4sYhZ/LhzYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DmcB4DGn; arc=none smtp.client-ip=91.218.175.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DmcB4DGn"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=8/mxER8tQ/jM0UjHuhFZAfTGDg4iwkRPnN25i6PnJtE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788335920; v=1; x=1788940720;
 b=DmcB4DGnhxVtLX7GW8b/MvZBYS4pg8qxltGa2ZHrnjYy1iYgEGGTDud1v8ysezrhpYThfZb8
 V1nwKrna8P5b0cHUInfyK5bRDia59OsKzt0HYSeZQazXvS70FYlWs2i1saBMMUWs12J0tGNKNmc
 womcIgWtt11IldLST/zwiMik=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1dce99fdb7487cf3;
	Wed, 02 Sep 2026 07:58:40 +0000
X-Mizu-Trace-ID: 1dce99fdb7487cf3
X-Migadu-Flow: FLOW_OUT
Message-ID: <2e005595-3761-4a29-9c62-e7f935c8691e@linux.dev>
Date: Wed, 2 Sep 2026 10:58:39 +0300
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-rc] RDMA/efa: Fix race between admin command timeout
 and completion
To: Yonatan Nachum <ynachum@amazon.com>, jgg@nvidia.com, leon@kernel.org,
 linux-rdma@vger.kernel.org
Cc: mrgolin@amazon.com, sleybo@amazon.com, matua@amazon.com,
 Tom Sela <tomsela@amazon.com>
References: <20260901113016.581935-1-ynachum@amazon.com>
From: Gal Pressman <gal.pressman@linux.dev>
Content-Language: en-US
In-Reply-To: <20260901113016.581935-1-ynachum@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 01/09/2026 14:30, Yonatan Nachum wrote:
> When an admin command times out, there is a potential race between the
> interrupt handler processing the completion and the timeout path
> releasing the completion context. The interrupt handler may observe the
> command as still submitted and attempt to complete it while the timeout
> path is concurrently freeing the context.
> 
> Fix this by introducing a timed-out state in the completion context. On
> timeout, both the polling and interrupt wait paths set the status to
> timed-out under the CQ lock before returning. The completion handler
> only process commands in submitted state, eliminating the race.
> 
> Fixes: 0420e542569b ("RDMA/efa: Implement functions that submit and complete admin commands")
> Reviewed-by: Tom Sela <tomsela@amazon.com>
> Signed-off-by: Yonatan Nachum <ynachum@amazon.com>
> ---
>  drivers/infiniband/hw/efa/efa_com.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/efa/efa_com.c b/drivers/infiniband/hw/efa/efa_com.c
> index 583b1cf0d721..a91de9283b6b 100644
> --- a/drivers/infiniband/hw/efa/efa_com.c
> +++ b/drivers/infiniband/hw/efa/efa_com.c
> @@ -41,6 +41,7 @@ enum efa_cmd_status {
>  	EFA_CMD_ALLOCATED,
>  	EFA_CMD_SUBMITTED,
>  	EFA_CMD_COMPLETED,
> +	EFA_CMD_TIMED_OUT,
>  };
>  
>  struct efa_comp_ctx {
> @@ -605,6 +606,10 @@ static int efa_com_wait_and_process_admin_cq_polling(struct efa_comp_ctx *comp_c
>  			break;
>  
>  		if (time_is_before_jiffies(timeout)) {
> +			spin_lock_irqsave(&aq->cq.lock, flags);
> +			comp_ctx->status = EFA_CMD_TIMED_OUT;
> +			spin_unlock_irqrestore(&aq->cq.lock, flags);

This smells bad, a few lines above 'comp_ctx->status' is being read
without a lock. Can't it change during this window?
