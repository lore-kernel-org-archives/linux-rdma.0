Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B1F34DCE3
	for <linux-rdma@vger.kernel.org>; Sun, 31 May 2026 18:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780251107; cv=none; b=YNRPBW+2/QGpGgGlfXKge8UaO278zHelJho/lnUSLZVPHK5BglBDz0jSRVsWceie+krWrbKuFiRwM+Qh9pVa58ROp1J+doer7yNOqxz7p20fzWoQ+/qRwFYm5IALKaqDX+/5tAxfOdseucg9rxxvMJupwmK0iZercWGtjsUlzWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780251107; c=relaxed/simple;
	bh=+V0F/Or9ksx/H0oo2ivy592D157Dk5NBHnzpdGKXzyU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FFoMJ8XJ/fli6WcDOGBVLffZCVuF5jZcRM/70YIajqWFIQ7uIKdl9+hb4IESmCL+UscS5jT2nWMMr1iLngVMAsaq/jJSPFsFrQq4yHFYPuzjlfg/HZrOntKv5+GTxzGTOoJZ2Y5ARErYVRLOSn/gwxvqcdKrcuBrkxzW/sqRlX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LNxsU/PR; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LNxsU/PR"
Message-ID: <b3f1f416-5de4-4160-b6b2-2d5d3c2f690e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780251101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E2cNn9hJ/opIYc56aaL6fBI4qg5ELmJgIceNylJjpT4=;
	b=LNxsU/PRTsulkwZyjtIAF+zGiXYmq45NmJ3/a8GRcaMjjF1iTiEGuCAPgIEdC61psKouL+
	5U+r90HfJrcLQnqrK353xnRC/ernn5cUCfskEYc+47d2vY2+oWO+3Eix3IzsifaapCPvOa
	L1CwQ6yGxtwNN645mOfzpPtiy50BBok=
Date: Sun, 31 May 2026 11:11:36 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] rxe: Fix dma.length computation in wr_set_sge_list
To: Jared Holzman <jholzman@nvidia.com>, linux-rdma@vger.kernel.org,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
References: <20260531120721.1347977-1-jholzman@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260531120721.1347977-1-jholzman@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

在 2026/5/31 5:07, Jared Holzman 写道:
> wr_set_sge_list() summed the SGE lengths with a loop that never
> advanced sg_list:

Good catch! This is a clean and straightforward fix for a subtle but 
high-impact bug in the Soft-RoCE (rxe) user-space provider.

Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Zhu Yanjun

> 
> 	while (num_sge--)
> 		tot_length += sg_list->length;
> 
> so tot_length ended up as num_sge * sg_list[0].length instead of the
> true sum, and wqe->dma.length / wqe->dma.resid were written with that
> wrong value. The per-SGE entries themselves were unaffected because
> they are populated by the preceding memcpy().
> 
> The kernel rxe driver requires dma.length == sum(sge[i].length) and
> enforces it in rxe_mr.c:copy_data(), so a multi-SGE WR posted through
> the ibv_qp_ex builder API (ibv_wr_set_sge_list) on rxe completes with
> IB_WC_LOC_PROT_ERR once finish_packet()/copy_data() runs off the end
> of the SGE list.
> 
> The legacy ibv_post_send path (init_send_wqe) is unaffected; it sums
> the lengths with an indexed for loop.
> 
> Fix by computing the total with an indexed loop, matching the style
> already used in rxe_post_one_recv() and init_send_wqe() in this file.
> 
> Fixes: 1a894ca10105 ("Providers/rxe: Implement ibv_create_qp_ex verb")
> Signed-off-by: Jared Holzman <jholzman@nvidia.com>
> PR: https://github.com/linux-rdma/rdma-core/pull/1744
> ---
>   providers/rxe/rxe.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/providers/rxe/rxe.c b/providers/rxe/rxe.c
> index 423f834b1..6d7be1493 100644
> --- a/providers/rxe/rxe.c
> +++ b/providers/rxe/rxe.c
> @@ -1138,6 +1138,7 @@ static void wr_set_sge_list(struct ibv_qp_ex *ibqp, size_t num_sge,
>   	struct rxe_send_wqe *wqe = addr_from_index(qp->sq.queue,
>   						   qp->cur_index - 1);
>   	size_t tot_length = 0;
> +	size_t i;
>   
>   	if (qp->err)
>   		return;
> @@ -1150,8 +1151,8 @@ static void wr_set_sge_list(struct ibv_qp_ex *ibqp, size_t num_sge,
>   	wqe->dma.num_sge = num_sge;
>   	memcpy(wqe->dma.sge, sg_list, num_sge*sizeof(*sg_list));
>   
> -	while (num_sge--)
> -		tot_length += sg_list->length;
> +	for (i = 0; i < num_sge; i++)
> +		tot_length += sg_list[i].length;
>   
>   	wqe->dma.length = tot_length;
>   	wqe->dma.resid = tot_length;

