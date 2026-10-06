Received: from mta1.migadu.com (out-223.mta1.migadu.com [95.215.58.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC4B41D657
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 12:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791290234; cv=none; b=hIi5PQA71gLXzM/5GJ51rTWFCuLri6rC2rIB1zZKQWAGAbqOzWJKi3/8fePp5Oq2eZ2Is4myjcpQf+WHePN/xYkWkEI7B5PkJPCULvyEjOQ313OyClD4TTFms22qLt5tL8/5XgvirhKV0ytN3DKCI/LAddEQmUJEgm4PGSa+Z3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791290234; c=relaxed/simple;
	bh=O5Pox5jAQRHT3eIZ2cH/0SuT0LdKOIff0PDs47S2468=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l8/rie4x0JsBOxRllQ+Epa+0S5QnkB46AS2xxS5dhD0shLzaKwh0CnGW6MF8Kiz0hmmySaem/Zx6QG6jlbBC+V1erngTF8owQNAqj8gg2fUOTp7ZWUYtw9V+zzChbch/N0YZU1Pvko6/nw4RtIugHMKU/SBxlDmOMi+bI10+83A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fYa9a+hT; arc=none smtp.client-ip=95.215.58.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fYa9a+hT"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=O5Pox5jAQRHT3eIZ2cH/0SuT0LdKOIff0PDs47S2468=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791290214; v=1; x=1791895014;
 b=fYa9a+hTnXprdoJ6EpMMTiwp6e/eXTer/Khf+SnZj+jS8HZx6B1aftvCwTUXHnV/HO9p9ia4
 h01QrXNs7g9FO0y5A5S08hkePNaU1AVxpYb1NiHlKgaf6R4HqYvnNQPrRMUdUdqAgz6O0cwYQnp
 7iNnJv0vOUDVy66lyOp0694A=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4caaabf127e1af1d;
	Tue, 06 Oct 2026 12:36:54 +0000
X-Mizu-Trace-ID: 4caaabf127e1af1d
X-Migadu-Flow: FLOW_OUT
Message-ID: <0f0960dd-e4a4-49fa-82cc-8b502bfb9c7c@linux.dev>
Date: Tue, 6 Oct 2026 14:36:50 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 for-rc] RDMA/siw: Enforce IB_ACCESS_REMOTE_READ for
 read responses
To: Haitam Lazaar <haitam@lazaarsec.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 linux-rdma <linux-rdma@vger.kernel.org>, stable <stable@vger.kernel.org>
References: <1a10973a2a8.17e04b672219.8760522594078806286@lazaarsec.com>
 <ecf307a2-e814-480d-8da8-1a7b76537d3f@linux.dev>
 <1a10ca50b82.4c79b9977088.8671544618706545172@lazaarsec.com>
From: Bernard Metzler <bernard.metzler@linux.dev>
In-Reply-To: <1a10ca50b82.4c79b9977088.8671544618706545172@lazaarsec.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.10.2026 17:18, Haitam Lazaar wrote:
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
> v1 -> v2:
>   - Compact READ_RESPONSE handling by combining num_sge and perms assignment
>     as suggested by Bernard Metzler.
> 
>   drivers/infiniband/sw/siw/siw_qp_tx.c | 18 +++++++++++-------
>   1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
> index f7dd32c6e5ba..7dac144cc903 100644
> --- a/drivers/infiniband/sw/siw/siw_qp_tx.c
> +++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
> @@ -805,17 +805,21 @@ static int siw_qp_sq_proc_tx(struct siw_qp *qp, struct siw_wqe *wqe)
>   
>   	if (wqe->wr_status == SIW_WR_QUEUED) {
>   		if (!(wqe->sqe.flags & SIW_WQE_INLINE)) {
> -			if (tx_type(wqe) == SIW_OP_READ_RESPONSE)
> -				wqe->sqe.num_sge = 1;
> -
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
> +				if (tx_type(wqe) == SIW_OP_READ_RESPONSE) {
> +					perms = IB_ACCESS_REMOTE_READ;
> +					wqe->sqe.num_sge = 1;
> +				}
> +
> +				rv = siw_check_sgl_tx(qp->pd, wqe, perms);
>   				if (rv < 0) {
>   					if (tx_type(wqe) ==
>   					    SIW_OP_READ_RESPONSE)

Great, thanks!

Acked-by: Bernard Metzler <bernard.metzler@linux.dev>
