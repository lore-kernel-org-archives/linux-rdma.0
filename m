Received: from mta1.formilux.org (mta1.formilux.org [51.159.59.229])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B6B3BA244
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 19:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.59.229
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796077; cv=none; b=GV9ZQpXuspKoZdonEIrXwGQd6YPsNpZtxlCNI439aE2XlMeoLXSniXTneUkpxxXvR2SS/Mdkg4cvIyAVtxSgwzXBBBY4u9qimJSf1IOTIzFWzyJf8e0j+/ATTlEw4xr6jvQiOx0xNpYis4VU1vX9E+0MO7wwTzxmRenDYzUBhmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796077; c=relaxed/simple;
	bh=An9y4906e5cQA62eW6kCgqEpvoe0BevqcfBTLJqyA8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ubc0YfxVz4k/Y9FWeZ9ZGNTUcLUKWtORoQ7ctBVBUQnjtlS0XAR0zMubvnc14p2aLcMDtkDUJKvoyMpwCDJSXMRC0Gg9fPRI2a2yRM0wNmv6O/esLyacGp2aDnQgPXGpnyt8bbVMOrJ6gPDrvo36/U3Lab7OVdCC7jJT2F1s0Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=1wt.eu; spf=pass smtp.mailfrom=1wt.eu; dkim=pass (1024-bit key) header.d=1wt.eu header.i=@1wt.eu header.b=WjNvehq6; arc=none smtp.client-ip=51.159.59.229
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=1wt.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=1wt.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=1wt.eu header.i=@1wt.eu header.b="WjNvehq6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1wt.eu; s=mail;
	t=1790796071; bh=RtSgkBgCgE+pu+49LVKT3JeR1jW0e8lR8QzrOZbTC/0=;
	h=From:Message-ID:From;
	b=WjNvehq6qS+/X3u11RDws4BbQbkoEm0TFKB0J+N54XMAS5c+UUKPfLozTYzxV7imM
	 k0+StFCesXf/X0Rh/ZJAdnn4lNakKEf3ZSNxiTx/U6IOdLdFWyrAeVYqPJ92yE+nm3
	 23qv+FRCGLiBkQ0Piay5hx5iWH/OhNuv08LOroSk=
Received: from 1wt.eu (ded1.1wt.eu [163.172.96.212])
	by mta1.formilux.org (Postfix) with ESMTP id 99694C08D3;
	Wed, 30 Sep 2026 21:21:11 +0200 (CEST)
Date: Wed, 30 Sep 2026 21:21:11 +0200
From: Willy Tarreau <w@1wt.eu>
To: AYS <ays511.kr@gmail.com>
Cc: zyjzyj2000@gmail.com, linux-rdma@vger.kernel.org, security@kernel.org
Subject: Re: [PATCH] RDMA/rxe: validate cur_sge on the receive path before
 indexing dma->sge[]
Message-ID: <ar1hJ_uZ-vduLOQG@1wt.eu>
References: <CAPAqSgYT9torsoAh_UexRewz-uPV9QNzOg1v3TPFxykQSaMJGA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPAqSgYT9torsoAh_UexRewz-uPV9QNzOg1v3TPFxykQSaMJGA@mail.gmail.com>

Hello,

On Wed, Sep 30, 2026 at 11:02:13PM +0900, AYS wrote:
(...)
> diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c
> b/drivers/infiniband/sw/rxe/rxe_mr.c
> index 71d9ea477289..b9aff32fffad 100644
> --- a/drivers/infiniband/sw/rxe/rxe_mr.c
> +++ b/drivers/infiniband/sw/rxe/rxe_mr.c
> @@ -437,6 +437,11 @@ int copy_data(
>   goto err2;
>   }
> 
> + if (unlikely(dma->cur_sge >= dma->num_sge)) {
> + err = -EINVAL;
> + goto err2;
> + }
> +
>   if (sge->length && (offset < sge->length)) {
>   mr = lookup_mr(pd, access, sge->lkey, RXE_LOOKUP_LOCAL);
>   if (!mr) {

All your messages arrive mangled. Please fix your email clients after
consulting Documentation/process/email-clients.rst. Also as a general
rule it's not a good idea to send a flood of messages without verifying
that the setup is OK, because now everyone will delete your whole series
without checking further. You'd rather wait at least a day before
resending to avoid your second series being trashed by accident in the
same batch. Also don't forget to mark them v2.

Willy
