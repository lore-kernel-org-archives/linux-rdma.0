Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC4C3932D3;
	Wed, 22 Jul 2026 09:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784712893; cv=none; b=LMEnaY2fET9JHkHOEi0ZkcXHvilz8rA+pgFEkRhLdj90vr/1XPyCcaLjZgmCw/Bc0KiQaIYgvK4UielydakZF+dFUcFsu6/B+D+0q66RSRl9oK/5lCguWg3LPgc0ADhnKDTpKGCSsS3h4XYzejrKE90vvu/FZRzwymB+xc2Hq34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784712893; c=relaxed/simple;
	bh=jXge4MEvf8hC6rKy+p7kdVex6C+4MXZb3cMxRCmxCkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BjnVkm1KRl4m4kAe5YPX1Fb8bcdg253mvTRKtp+mNgMKZ7k+M/26WTtFoxh7+xlbmXueAgbUKHQQu7KAq4i2+0+WLYi5F4TGCeZWRoEuolDwzob/wI2OunauBfdAhDw9EasDAQijYkAdwu/gqTVBc0kPm8VAAxZAp+gXnY/noMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CKgbHmh2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CKgbHmh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB1A1F000E9;
	Wed, 22 Jul 2026 09:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784712892;
	bh=2sIrVF0hS1XGGSmNHFO5YLfVMFJFNw0fJvaAWUxdHTY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CKgbHmh2tYYYQySuDNZJaITZni6CGtiiI3pmN7x3a0megrYEJpp7tqvjhKi++9nM4
	 x0q4IN39rQPywCEewVj0SAi4PrdGPdz6HdCUVYqABy73NakBtUlqS9A5r2moY8Uvko
	 FR5Br16kILcsedtjwb/XOEI+0QNWe6GAbop8P+va3JInH/QsCP+EYxlgPhGpJULg4N
	 MXq3uMfC+D8ERrlljEnnPcd4O+mtQHNaSe/QLvL+zK3Wa/OlLN3UsFtxOiW8O2aFRT
	 1oa4rSw23N9aRaFtXTagA8wpD6+guoAP9wHkuV5eyyTOS+7uVQF1vMRvSc6flujz8i
	 YQXnvp5j3FlLw==
Date: Wed, 22 Jul 2026 12:34:45 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Konstantin Taranov <kotaranov@microsoft.com>
Cc: Long Li <longli@microsoft.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Shiraz Saleem <shirazsaleem@microsoft.com>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH rdma-next] RDMA/mana_ib: drain QP references after
 partial table insertion
Message-ID: <20260722093445.GX110966@unreal>
References: <20260721-if-mana-table-store-qp-qids-partiall-v1-1-8fb3d2d2b559@nvidia.com>
 <DU8PR83MB0975C74A6A47AB8EAE06AB29B4C12@DU8PR83MB0975.EURPRD83.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DU8PR83MB0975C74A6A47AB8EAE06AB29B4C12@DU8PR83MB0975.EURPRD83.prod.outlook.com>

On Wed, Jul 22, 2026 at 09:18:12AM +0000, Konstantin Taranov wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > mana_table_store_ud_qp() publishes a QP at its send-queue id before
> > inserting the receive-queue id, dropping the XArray lock between the two
> > xa_insert_irq() calls. A concurrent completion handler can look up the QP and
> > take a transient reference. When the second insertion fails, the rollback
> > erased only the send-queue entry and returned, leaving both the initial table
> > reference and the transient reference outstanding while RDMA core frees the
> > QP, causing a use-after-free.
> > 
> > Drain the reference as normal destruction does: drop the initial reference and
> > wait for qp->free, releasing the QP only after every concurrent lookup returns
> > its reference.
> > 
> > Fixes: 8001e9257eca ("RDMA/mana_ib: extend mana QP table")
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> Reviewed-by: Konstantin Taranov <kotaranov@microsoft.com> 
> 
> > ---
> > Konstantin,
> > 
> > I saw this in one of the Sashiko runs, and I believe the AI is correct. The
> > reference can be acquired through the GDMA_EQE_RNIC_QP_FATAL event.
> > 
> 
> I doubt that it is possible for EQEs. The eqe only can mention an RQ and we first try to insert an SQ.
> As well as when we drain GSI QP, we also look up with an RQ.

GDMA_EQE_RNIC_QP_FATAL is my interpretation, and not AI :).

Thanks
