Received: from mta0.migadu.com (out-145.mta0.migadu.com [91.218.175.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B984848BC
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 09:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790589061; cv=none; b=Pmq3/j7S7H1I7aLSnlD9nTd+4jIF0qYkDHIa0lUAZ6kKcL3WS3IRG/6G1uzratjb0XT3aUVa5qYHPLCJb99vAgkYi4UfhB0jYmK1vQ8ZAT8qwTh5hPys/CaeJw75OWza2Gk+/HHa/4YeXuVSqjFI7tdInMjdmWbOM36Yo/Opiw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790589061; c=relaxed/simple;
	bh=WkxN/5dAUxXFbbDwIeF/56xavCgVamR0+aU/wEfUy9w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uxf+Q1HVkUbSdfa6lOeL7m9V2r4mjhqGIFI9g4pxbyyVjOE1qIcG7MXxd3wZWA7MWRggG52gepL8g2mJFlgB8b2ya+ZRDdmgM5X772fM+F9uA9x1xWkarFd3gXIyZ5alblItxSEH1rZGsQaeGFIe0ByNpS0enDSNEtzhSW3iDEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HIO/4h7Q; arc=none smtp.client-ip=91.218.175.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HIO/4h7Q"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=WkxN/5dAUxXFbbDwIeF/56xavCgVamR0+aU/wEfUy9w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790589056; v=1; x=1791193856;
 b=HIO/4h7QJ2SEx/CiJqz+CDODhC7FF/IkvOnLS7eQvdM1MhxB1y7L8RwwnOj/035VyGZklOt8
 zm3V0yRozCFUzMAThEtj0eK6hlTvNG4ZeMeOhZQqxVRrgnZ13rXuKi8/czo22QQCy5GcScsT/0X
 swFRAcOeqqGx+FhutjD2W7N4=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 12e8f578d9e83fbe;
	Mon, 28 Sep 2026 09:50:56 +0000
X-Mizu-Trace-ID: 12e8f578d9e83fbe
X-Migadu-Flow: FLOW_OUT
Message-ID: <05e55fe5-04b0-4fab-a256-eafcdf14cc81@linux.dev>
Date: Mon, 28 Sep 2026 11:50:45 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/siw: Fix length of first chunk in siw_try_1seg()
To: Serhat Kumral <serhatkumral1@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260927115351.12245-1-serhatkumral1@gmail.com>
From: Bernard Metzler <bernard.metzler@linux.dev>
In-Reply-To: <20260927115351.12245-1-serhatkumral1@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27.09.2026 13:53, Serhat Kumral wrote:
> When a short-single SGE payload crosses a page boundary, siw_try_1seg()
> computes the length of the first chunk as the amount that spills into
> the second page instead of the amount left in the first page
> 
> 	part = bytes - (PAGE_SIZE - off);
> 
> Use the remaining length of the first page as the first chunk.
> 
> Fixes: b9be6f18cf9e ("rdma/siw: transmit path")
> Assisted-by: LLM
> Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
> ---
>   drivers/infiniband/sw/siw/siw_qp_tx.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
> index f7dd32c6e5ba..54c9d97015e8 100644
> --- a/drivers/infiniband/sw/siw/siw_qp_tx.c
> +++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
> @@ -85,7 +85,7 @@ static int siw_try_1seg(struct siw_iwarp_tx *c_tx, void *paddr)
>   			if (likely(PAGE_SIZE - off >= bytes)) {
>   				memcpy(paddr, buffer + off, bytes);
>   			} else {
> -				unsigned long part = bytes - (PAGE_SIZE - off);
> +				unsigned long part = PAGE_SIZE - off;
>   
>   				memcpy(paddr, buffer + off, part);
>   				kunmap_local(buffer);

Excellent finding. Thanks very much Serhat.

This is quite serious, since we may copy data
from a location beyond the current page (if there
are more remaining bytes to be copied in the next
page than in the current page).

Acked-by: Bernard Metzler <bernard.metzler@linux.dev>
