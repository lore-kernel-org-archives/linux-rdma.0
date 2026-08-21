Received: from mta0.migadu.com (out-198.mta0.migadu.com [91.218.175.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7606339DBDB
	for <linux-rdma@vger.kernel.org>; Fri, 21 Aug 2026 15:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787326032; cv=none; b=KaGvaALw2VQEagb/Xv3CwsEW5FkVuqNnMYJNyqKXYgLuvJvRgL1vEjWMbA6xlN9hXSnbt7Z+ISSpGoau0FVrz/Dm1k4iigMVZVmMIy/sFanayjdFi03IeidZjU+J2RZns+7gqIrvb2gTtYWcFVHqwYdVDp8zA+zWLiZYMyUmNkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787326032; c=relaxed/simple;
	bh=OkYrRKIJtK3XNjxfrkfFfe7z95McGGNgCLA+0RoOTRA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DrDTFByYr+xTCu1fI1fEOKi244FW4vawJ+JyjxJqKxhvjobroHSW8MEZOQzpagda9btFXEsVk7STJljAx8I2gOZ8uf2JJRq/RyhsTvcpuovWJtoEVOH06ueBvZI+CG1ZelFKo5dgBcine8vTeWX10M7Qt8oAp7KvMnCPTRzTcxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=b31V6a7k; arc=none smtp.client-ip=91.218.175.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="b31V6a7k"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=OkYrRKIJtK3XNjxfrkfFfe7z95McGGNgCLA+0RoOTRA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787326025; v=1; x=1787930825;
 b=b31V6a7kXsW20BrNoN1Gtgd79dipHOxHJhuUil4nnBTcsPg3ScaNgKe/pFXVHVYWwBNme4SV
 5M4+V9pdT8Lj7730vFpECJ0i5NA3pRAhJE7JssjN4328NI6yO20w0w8KONqJs8S6gSKTmtGzEuv
 2i/qaUIcPbZ+7aPFR16tb0v0=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: from [IPV6:2a04:ee41:4:15d4:8934:f21b:2683:d2a4] (2a04:ee41:4:15d4:8934:f21b:2683:d2a4)
	by smtp.migadu.com with ESMTPS id 76576405c15bdc62;
	Fri, 21 Aug 2026 15:26:55 +0000
X-Mizu-Trace-ID: 76576405c15bdc62
X-Migadu-Flow: FLOW_OUT
Message-ID: <cab4d5b8-7813-4f63-900f-e6ef6f93cf72@linux.dev>
Date: Fri, 21 Aug 2026 17:26:53 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/siw: Fix CEP use-after-free in siw_connect()
To: Shuangpeng Bai <shuangpeng.kernel@gmail.com>, jgg@ziepe.ca,
 leon@kernel.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260816022619.3629422-1-shuangpeng.kernel@gmail.com>
From: Bernard Metzler <bernard.metzler@linux.dev>
In-Reply-To: <20260816022619.3629422-1-shuangpeng.kernel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16.08.2026 04:26, Shuangpeng Bai wrote:
> siw_connect() publishes a newly allocated CEP through qp->cep and gives
> the QP an association reference.
> 
> If connection setup fails while the QP is being destroyed, QP teardown
> can clear qp->cep and drop that reference first. The error path
> nevertheless drops what it assumes is the association reference. This
> consumes the local allocation reference and frees the CEP before the
> error path updates cep->state and releases cep->in_use, causing a
> use-after-free.
> 
Was that use-after-free encountered?

Can we see a stack trace?

> Serialize CEP association and error-side detachment with qp->state_lock.
> Only drop the association reference when qp->cep still points to the CEP
> being cleaned up, leaving the local reference valid until cleanup is
> complete.
> 
> Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
> Cc: stable@vger.kernel.org
> Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
> ---
>   drivers/infiniband/sw/siw/siw_cm.c | 15 ++++++++++-----
>   1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
> index 87c79527ac09..7b32158ea49f 100644
> --- a/drivers/infiniband/sw/siw/siw_cm.c
> +++ b/drivers/infiniband/sw/siw/siw_cm.c
> @@ -1467,11 +1467,13 @@ int siw_connect(struct iw_cm_id *id, struct iw_cm_conn_param *params)
>   	siw_cep_set_inuse(cep);
>   
>   	/* Associate QP with CEP */
> +	down_write(&qp->state_lock);

What could destroy the QP at this point, so
that we need a lock? The RDMA core should serialize
any user initiated QP destroy during the connect.

>   	siw_cep_get(cep);
>   	qp->cep = cep;
>   
>   	/* siw_qp_get(qp) already done by QP lookup */
>   	cep->qp = qp;
> +	up_write(&qp->state_lock);
>   
>   	id->add_ref(id);
>   	cep->cm_id = id;
> @@ -1564,16 +1566,19 @@ int siw_connect(struct iw_cm_id *id, struct iw_cm_conn_param *params)
>   		siw_socket_disassoc(s);
>   		sock_release(s);
>   
> -		cep->qp = NULL;
> -
>   		cep->cm_id = NULL;
>   		id->rem_ref(id);
>   
> -		qp->cep = NULL;
> -		siw_cep_put(cep);
> -
>   		cep->state = SIW_EPSTATE_CLOSED;
>   

What can destroy the QP at this point?

The only possibility I see is a connection
drop from peer side, which races with the current
connect() processing. Having a lock at the cep
is sufficient to serialize that.
We hold the cep lock via siw_cep_set_inuse(),
which releasedonly the th every end of the
connect via siw_cep_set_free() (success), or
siw_cep_set_free_and_put() (failure.


> +		down_write(&qp->state_lock);
> +		cep->qp = NULL;
> +		if (qp->cep == cep) {
> +			qp->cep = NULL;
> +			siw_cep_put(cep);
> +		}
> +		up_write(&qp->state_lock);
> +
>   		siw_cep_set_free_and_put(cep);
>   
>   	} else if (s) {

