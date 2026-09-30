Received: from mta1.formilux.org (mta1.formilux.org [51.159.59.229])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890273DD849
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 19:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.59.229
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796309; cv=none; b=P2+7PkWzXv7O0awDhdkG57XWzhOqGaaJz3s90AKuTsbVwAZkUyIsOkInRWrN6ToBTPC0cd/Yu3WA4y0CcJMVNquCI/TthJxw5lnWwv+bQ/NT8yF5B4wSnmwwokwX3g5KrBveX2JdvsOrS0Ne9QBUxSCTF8ba3TRsrpY7VLS9op4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796309; c=relaxed/simple;
	bh=jK1Vsd1sJzUwGcQH1eEP6IfjlnsV4iMCDWvqxiuNOAI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JSusF9dipa0mXuJ9SD2g1itv8ItkZTdccA/TX34rJH1HPK1lix38HMEXeJfP85igNy/JROXWfrlyMOE3zW9/lzHne1WMjpSbQvl/8YPytLMFUtIaZLNKSrpAygt+UH/bTK0vExSdFlnNpalIJX3367EQo1iRrVg8Q+nMgyoVzps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=1wt.eu; spf=pass smtp.mailfrom=1wt.eu; dkim=pass (1024-bit key) header.d=1wt.eu header.i=@1wt.eu header.b=T+QUtEiq; arc=none smtp.client-ip=51.159.59.229
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=1wt.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=1wt.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=1wt.eu header.i=@1wt.eu header.b="T+QUtEiq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1wt.eu; s=mail;
	t=1790796305; bh=iS2Ynmp1e0rgbM5TYbuQrEGBzWlSnZaHZCZ4DWaM9Ho=;
	h=From:Message-ID:From;
	b=T+QUtEiqDCxsEyp7NtaMBaP6bNBKJWyt8EUeqmf8NXEDixsCDcwlMtUUn7t8CXoxO
	 sJcfvvf02265Ba4ck9SXQhvI8LRVVq21fP1NWXyhqUF217FnHhwLKWkLCxOWvJQm9l
	 UQnObS4RFRl2VTo5Alp0RWmVrog3qfxisx+qfROQ=
Received: from 1wt.eu (ded1.1wt.eu [163.172.96.212])
	by mta1.formilux.org (Postfix) with ESMTP id 423A2C08D3;
	Wed, 30 Sep 2026 21:25:05 +0200 (CEST)
Date: Wed, 30 Sep 2026 21:25:04 +0200
From: Willy Tarreau <w@1wt.eu>
To: Youngsung Ahn <ays511.kr@gmail.com>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>, zyjzyj2000@gmail.com,
        linux-rdma@vger.kernel.org, security@kernel.org
Subject: Re: [PATCH] RDMA/rxe: bound the ODP page index against the umem in
 rxe_check_pagefault()
Message-ID: <ar1iENLJynuJuU27@1wt.eu>
References: <20260930175145.2491352-1-ays511.kr@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930175145.2491352-1-ays511.kr@gmail.com>

Hello,

On Thu, Oct 01, 2026 at 02:51:45AM +0900, Youngsung Ahn wrote:
> An ODP MR's page array map.pfn_list[] is sized from the umem's
> start, but rxe_check_pagefault() indexes it with an iova taken
> relative to that start, while the access was range-checked against
> the MR's iova (ibmr.iova). reg_mr only requires start and hca_va to
> share a page offset, so a user can register with hca_va =
> start + N*PAGE, and the index skew (hca_va - start) >> PAGE_SHIFT
> then lands out of bounds of pfn_list[], which is read with no bound
> check. An unprivileged local user reaches this with a single RDMA
> operation on a self-connected rxe QP: observed as a KASAN
> slab-out-of-bounds read and, when the out-of-bounds qword looks like
> a writable HMM pfn, a write into an attacker-influenced page.
> 
> Reject an index that leaves the umem and force the fault path, which
> fails the out-of-range access via the umem range check in
> ib_umem_odp_map_dma_and_lock(). The downstream pfn_list[] users
> (__rxe_odp_mr_copy() and the atomic helpers) run only after a
> successful map, so this check protects them as well.
> 
> Fixes: 2fae67ab63db ("RDMA/rxe: Add support for Send/Recv/Write/Read with ODP")
> Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>

Are you sure you're not missing an Assisted-by: tag here ?

I didn't notice that you sent this to a public list, that's fine but in
this case there's no need to Cc security@k.o since the essential role of
the team is to help route the message to its destination :-)

thanks,
Willy
