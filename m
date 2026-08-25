Received: from mta0.migadu.com (out-43.mta0.migadu.com [91.218.175.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4F04734C1
	for <linux-rdma@vger.kernel.org>; Tue, 25 Aug 2026 13:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666029; cv=none; b=cv3FFRW1TPgAJbG5RnlpvVteKSn8ibO2ByNADApiZl0DFIqq228Yazl3FFM6qDFK5FbNbahz3Xi2lk8Gy7mvjtgD/7hc0xIXCUBUXzjIsq7WsaUjziRinwbxIUHg4OWGJ5ZefXLJWqLTSxta2gllMN4nx1NmDcgL1+s6ryCiGxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666029; c=relaxed/simple;
	bh=8SURnY7nUXPZUgPj7XlXlLRWu8V60aP6cjdgnzN0C3o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cd56V9e1FeOx1EP0UFZgetPu22SP1iA6YIDcezsDvn6f1yNr4cxVsPXTEAAdacgKtigRtYijkuAmwhjwxRurnkwvn30yErVKhMeoFqsy0nhUtBkScSW/Bo8sdG8Qv87Hq+e5MP8Rtu9tZWhT/U3JYIcS/NqMCW+EMhIdb7qujb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tR3rqI5Y; arc=none smtp.client-ip=91.218.175.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tR3rqI5Y"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=8SURnY7nUXPZUgPj7XlXlLRWu8V60aP6cjdgnzN0C3o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787666025; v=1; x=1788270825;
 b=tR3rqI5YcJs1XPtPRBiEoVX/s4Ufy5jmok/jsTHwqSA80NuzSG4kmqY0WU8v1P5ky/wQ6YNk
 DCzVyuMucEDPwszquSy4LCvmdVjAWwEgxwcfc6bNQxlXN6MawnrqKC8IX8iZmVZBYnVvB48ESli
 FGYcjWtqY19wDK+hGzFL79io=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: from [IPV6:2a04:ee41:4:15d4:8934:f21b:2683:d2a4] (2a04:ee41:4:15d4:8934:f21b:2683:d2a4)
	by smtp.migadu.com with ESMTPS id 2b0f087a17df77f1;
	Tue, 25 Aug 2026 13:53:35 +0000
X-Mizu-Trace-ID: 2b0f087a17df77f1
X-Migadu-Flow: FLOW_OUT
Message-ID: <de7ccaed-e270-459b-a34a-d32b2b2ce4e8@linux.dev>
Date: Tue, 25 Aug 2026 15:53:33 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/siw: Clear association under lock if siw_qp_modify
 fails in siw_accept
To: Guoqing Jiang <guoqing.jiang@linux.dev>, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, shuangpeng.kernel@gmail.com
References: <20260825130954.27327-1-guoqing.jiang@linux.dev>
From: Bernard Metzler <bernard.metzler@linux.dev>
In-Reply-To: <20260825130954.27327-1-guoqing.jiang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 25.08.2026 15:09, Guoqing Jiang wrote:
> We need to clear qp and cep before release state_lock as siw_qp_llp_closeo
> and siw_qp_modify->siw_qp_llp_close did.
> 
> Otherwise if siw_qp_modify() fails in siw_accept(), the QP's state_lock
> is released before the error path cleanup. A concurrent ibv_modify_qp()
> transitioning the QP to ERROR can race in this window:
> 
>    siw_accept()                       ibv_modify_qp(ERROR)
>    ----------------------             ----------------------
>    siw_qp_modify() fails
>    up_write(&qp->state_lock)
>                                       down_write(&qp->state_lock)
>                                       nextstate_from_idle():
> 				     if (qp->cep)
>                                         siw_cep_put(qp->cep) <- frees cep
>                                         qp->cep = NULL
>    goto error
>      cep->qp = NULL                   <- UAF
> 
> Clear qp->cep and cep->qp, and drop the association reference taken by
> siw_cep_get(), all under the write lock held from the initial
> down_write(&qp->state_lock). Thread B therefore sees qp->cep == NULL,
> skips its own put, and cannot free the cep before siw_accept() is done
> with it.
> 
> Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
> Link: https://lore.kernel.org/linux-rdma/d6fbe475-a5c2-f975-99b0-a0bd6b6d10e8@linux.dev/T/#m5876c1ff2de8686a9a1173b8f1aa0ff5363a785c
> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
> ---
>   drivers/infiniband/sw/siw/siw_cm.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
> index 0245b25e7271..1573f2e888b2 100644
> --- a/drivers/infiniband/sw/siw/siw_cm.c
> +++ b/drivers/infiniband/sw/siw/siw_cm.c
> @@ -1719,9 +1719,13 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
>   			   SIW_QP_ATTR_STATE | SIW_QP_ATTR_LLP_HANDLE |
>   				   SIW_QP_ATTR_ORD | SIW_QP_ATTR_IRD |
>   				   SIW_QP_ATTR_MPA);
> +	if (rv) {
> +		cep->qp = NULL;
This can better be omitted since done in error_unlock path
anyway and is redundant otherwise. It would also better
retain the logic of calling siw_qp_put(qp) right after
clearing cep's reference to the qp, as done in error path.

Thank you!
Bernard.> +		qp->cep = NULL;
> +		siw_cep_put(cep);
> +		goto error_unlock;
> +	}
>   	up_write(&qp->state_lock);
> -	if (rv)
> -		goto error;
>   
>   	siw_dbg_cep(cep, "[QP %u]: send mpa reply, %d byte pdata\n",
>   		    qp_id(qp), params->private_data_len);
