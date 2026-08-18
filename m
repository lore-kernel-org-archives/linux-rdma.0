Received: from mta1.migadu.com (out-102.mta1.migadu.com [95.215.58.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7464D47DF9A
	for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2026 16:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787070813; cv=none; b=ollGsLCTN25XvTJ/sUGrVtvHJ8wh5UocA3Q/3G9gnsaqNtDo3wH7YDTQmE5+tlDWhW2kYM/VqAOmyRiGJJpD4uSXR6z4xkPkDW0MmdZknj5/XNi5r184HcGeR3unqu8zATABXnp/bUHfCKmIr+pxlybQgvu3MHLQ9h1saMqPIx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787070813; c=relaxed/simple;
	bh=1ChsaIcUzV3z7iB7jMoE6zl17GNTpbstTGoBWWpJ91U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=euF2HIfbcwRpfUpvHNRbxl4VCGgsso8/pqDWwbdBRxoILXHM+Pb8EfWMYbmCelf9MgLtjhAbFhELaPrTY/ttNOgKe16L9BXKwbSkC4E4VJrTK5+gzZbgQ3gzxSD2kC2b5Ygz6SdaewUHyMasa7rX6IQ49fNNPcT0q9j6WcUF2RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MetsjYp2; arc=none smtp.client-ip=95.215.58.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MetsjYp2"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=1ChsaIcUzV3z7iB7jMoE6zl17GNTpbstTGoBWWpJ91U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787070807; v=1; x=1787675607;
 b=MetsjYp2ne19b457OA/yVMsB6UKXRPMfPefweaQt0QnDHUf/SLZbAT/kyfFiAi2ppKpCvAlN
 MbX9V6xesjjnq/gE+IttL5GTKTR49qiZZWpjNth0nvmuwwPtb1/9Ep/s9yYLaNOIPS6AHB5GDRO
 QACCJFfFGTDPolURMb6n4IJ4=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: from [IPV6:2a04:ee41:4:15d4:8934:f21b:2683:d2a4] (2a04:ee41:4:15d4:8934:f21b:2683:d2a4)
	by smtp.migadu.com with ESMTPS id d413b1b951dd68e1;
	Tue, 18 Aug 2026 16:33:17 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <51f3705f-6338-4892-86cb-d059e8101f8a@linux.dev>
Date: Tue, 18 Aug 2026 18:33:16 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/siw: Fix use-after-free in siw_accept()
To: Shuangpeng Bai <shuangpeng.kernel@gmail.com>, jgg@ziepe.ca,
 leon@kernel.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260801213632.1086548-1-shuangpeng.kernel@gmail.com>
From: Bernard Metzler <bernard.metzler@linux.dev>
In-Reply-To: <20260801213632.1086548-1-shuangpeng.kernel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01.08.2026 23:36, Shuangpeng Bai wrote:

Sorry I was away for 3 weeks and can review only now.

> siw_accept() looks up the QP supplied by userspace. If that QP is
> already in RTS, the function jumps to error cleanup before associating
> the incoming CEP with it.
> 
We test against any QP state other than expected
SIW_EPSTATE_RECVD_MPAREQ. The QP should never be in RTS here, since
it moves to RTS only after the user issued this accept we are in
and the RDMA CM core code makes sure a user does that only one time
per QP.
We typically end up in that error path, if the user spent to much time
in a new connection indication/accept path, while the peer already
closed that half open connection. So I don't follow that comment above.

Were you able to force such state mismatch?


> The cleanup tests whether qp->cep is non-NULL and assumes the current
> call installed the association. However, qp->cep can point to the CEP
> of an existing connection. The cleanup then drops a reference from the

Can that happen? QP numbers should be unique, maintained by
xa_alloc()/xa_erase(). A cep cannot be transferred among QP's.

> incoming cep, not qp->cep. Once the incoming endpoint loses its
> remaining references, this can free it before the subsequent cep->qp
> store, causing a use-after-free. It also clears the existing QP
> association.
> 
> Only release the association reference when qp->cep is the incoming
> CEP. This preserves an existing association and avoids accessing the
> freed endpoint.
> 
> Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
> Cc: stable@vger.kernel.org
> Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
> ---
>   drivers/infiniband/sw/siw/siw_cm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
> index 87c79527ac09..0245b25e7271 100644
> --- a/drivers/infiniband/sw/siw/siw_cm.c
> +++ b/drivers/infiniband/sw/siw/siw_cm.c
> @@ -1751,7 +1751,7 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
>   	cep->state = SIW_EPSTATE_CLOSED;
>   
>   	siw_free_cm_id(cep);
> -	if (qp->cep) {
> +	if (qp->cep == cep) {

Is it really possible we have (qp->cep != cep)?
Were you able to create such situation?

Did you run into use_after_free?

Thanks very much!
Bernard.>   		siw_cep_put(cep);
>   		qp->cep = NULL;
>   	}
