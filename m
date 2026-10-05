Received: from mta1.migadu.com (out-156.mta1.migadu.com [95.215.58.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0444C3CBE91
	for <linux-rdma@vger.kernel.org>; Mon,  5 Oct 2026 11:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791199929; cv=none; b=gQXz0hM/vRWyy9bEIG4kkoRRdVivm4wEHkae2RneLjmSvHGcb+GqVRuffcqORT5n48+glnM/KVEjAPf4nlD+pwqBIP94nMqPHeXqrmyeJsdSQyGOrdBE56S8F1G6nS8M8dq09E1Jgew1+h7HqBppLzaoq+WFM3cS2yqnQirL6Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791199929; c=relaxed/simple;
	bh=269nd+I1EAeOX0RpssvCfGisJcgoKXgWwOs4dp/AG1M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gq4tf0y6CfVSNmJUiKD8537Ua4p4BClO2ABM1QQ+TA/hH8ooR51GON6mHRxsKEjHR7EhxKF3P1rrFiL0InS9jnAGxI2ObJnf4NRW6TUGDu0HLurD8CQkbVi83VkpGX4CkA1BOaU8EcLHgzVc9aj7KTSqVFO3B8T8pGh8GkjlCwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AfLbuTuy; arc=none smtp.client-ip=95.215.58.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AfLbuTuy"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=269nd+I1EAeOX0RpssvCfGisJcgoKXgWwOs4dp/AG1M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791199923; v=1; x=1791804723;
 b=AfLbuTuyVZmsi/EBqgXpDf/VK/olQV2hi5/9kCQRCNLq5bdsQhZWS0XsZGb02lALvBF/SIv7
 0Qrl/b+gkS2CxjJDmK59p4nPJ0TAlm/tVA+7IOsu7X6tHl8O+yTNxN6V8YxOfl71b6mxPLWTXAC
 k2h3K5DigV+XtkJT97UOXwJs=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5a01dbf037b0ce12;
	Mon, 05 Oct 2026 11:32:03 +0000
X-Mizu-Trace-ID: 5a01dbf037b0ce12
X-Migadu-Flow: FLOW_OUT
Message-ID: <ecf307a2-e814-480d-8da8-1a7b76537d3f@linux.dev>
Date: Mon, 5 Oct 2026 13:31:59 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-rc] RDMA/siw: Enforce IB_ACCESS_REMOTE_READ for read
 responses
To: Haitam Lazaar <haitam@lazaarsec.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 linux-rdma <linux-rdma@vger.kernel.org>, stable <stable@vger.kernel.org>
References: <1a10973a2a8.17e04b672219.8760522594078806286@lazaarsec.com>
From: Bernard Metzler <bernard.metzler@linux.dev>
In-Reply-To: <1a10973a2a8.17e04b672219.8760522594078806286@lazaarsec.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.10.2026 02:25, Haitam Lazaar wrote:
> When generating an RDMA READ response (SIW_OP_READ_RESPONSE),
> siw_check_sgl_tx() unconditionally passes 0 as the required permission
> mask:
> 
>      /* Reference memory to be tx'd w/o checking access for LOCAL_READ */
>      rv = siw_check_sgl_tx(qp->pd, wqe, 0);
> 
> Because perms is 0, siw_check_mem()'s authorization test:
>      if ((mem->perms & perms) < perms)
> evaluates to (mem->perms & 0) < 0, which is always false. Consequently,
> an untrusted remote peer can issue an RDMA Read targeting any valid
> STag in the Protection Domain, even if the memory was registered strictly
> as write-only (IB_ACCESS_REMOTE_WRITE) without IB_ACCESS_REMOTE_READ.
> 
> Enforce that the target memory region was granted IB_ACCESS_REMOTE_READ
> when answering SIW_OP_READ_RESPONSE work queue entries, while preserving
> perms = 0 for standard local sends.
> 
> Fixes: b9be6f18cf9e ("rdma/siw: transmit path")
> Cc: stable@vger.kernel.org
> Signed-off-by: Haitam Lazaar <haitam@lazaarsec.com>
> ---
>   drivers/infiniband/sw/siw/siw_qp_tx.c | 13 +++++++++----
>   1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
> index f7dd32c6e5ba..9e652585f904 100644
> --- a/drivers/infiniband/sw/siw/siw_qp_tx.c
> +++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
> @@ -810,12 +810,17 @@ static int siw_qp_sq_proc_tx(struct siw_qp *qp, struct siw_wqe *wqe)
>   
>   			if (tx_type(wqe) != SIW_OP_READ &&
>   			    tx_type(wqe) != SIW_OP_READ_LOCAL_INV) {
> +				enum ib_access_flags perms = 0;
> +
>   				/*
> -				 * Reference memory to be tx'd w/o checking
> -				 * access for LOCAL_READ permission, since
> -				 * not defined in RDMA core.
> +				 * Local READ permission doesn't exist in RDMA core.
> +				 * A READ RESPONSE source is read by the remote peer,
> +				 * so it must be checked for REMOTE_READ permission.
>   				 */
> -				rv = siw_check_sgl_tx(qp->pd, wqe, 0);
> +				if (tx_type(wqe) == SIW_OP_READ_RESPONSE)
> +					perms = IB_ACCESS_REMOTE_READ;
> +
> +				rv = siw_check_sgl_tx(qp->pd, wqe, perms);
>   				if (rv < 0) {
>   					if (tx_type(wqe) ==
>   					    SIW_OP_READ_RESPONSE)

Excellent finding! You may further compact the code by
moving the test and set...

                         if (tx_type(wqe) == SIW_OP_READ_RESPONSE)
                                 wqe->sqe.num_sge = 1;

.. from a few lines above and merge it with the new 'perms'
assignmnet like:

			if (tx_type(wqe) == SIW_OP_READ_RESPONSE) {
				perms = IB_ACCESS_REMOTE_READ;
				wqe->sqe.num_sge = 1;
			}

Thanks,
Bernard.
