Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.234
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704023;
	b=R/rrA3h6x+Xmva/ueY3gr3EBfd4usUNsfHK0yAaNwYTo8jZc04dG4skbw1FmIFgrmUkv
	 eaf7q4/OX1MDIi/Q3NuhrRlTTTUokfiqWjQNfrEGbKRrKBdaGMzg76XI+Cy6Dt8Jta/x7
	 DII7X69niWZnROrvW3J/neTwA7lJJzmEyFjtWDEUQmJiKAlvitxLTTVN09sMtv2STd/1g
	 C74+PYWrOaAySPMnJXTmij77PbLhthJTUuRbL8ulla7EzegGX/OohPQMjoqz23ARLWqyc
	 +AhrYT1Lhs171mgM8WF63W3lQhpDA5SDsCWP+PEG/sDiQGO5RqQywK4RkiSDPuArjqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704023;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=/3T7oiZbrzNKvCjJayhfkzBs0RV+pa68sTmpUnKn7rs=;
	b=BGDtGydNYCnyhEKKjf3rix+++uULtTCVsLU6x5s53zfPvTsgsbL3Uztz5W8mpiIhKPDC
	 pms061cPbzD22VdunuGhhuVFAPbC5kT9AqTh0c0qGyrcuCknK6FdzHLJM+lJoP9yCW3Oc
	 tT948n+5PhzcVgM4o/+tT+19EQF4Dg8nvCWlWk/tO6ZG8s3GadzKsqO8b9Bs/x+1/Wtzl
	 NUtdSWxwfeK6rKDqis1oRAlSaHcS1bffU6O8IB+14q8eIFfsX39Dgjm9QUMZQK4ZkF4DO
	 7dR7Zu51infeNLuImu7+DP7Px0tdxOERCZL9Ii8QNuD5GzZnxoT5KHdKWgnFFwtPqBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=B2+w7OwE;
	arc=none smtp.remote-ip=95.215.58.234
Received: from mta1.migadu.com (out-234.mta1.migadu.com [95.215.58.234])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D22606A31E
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 14:40:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86D22606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=B2+w7OwE
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=FUYofHEtZmsDAFAQmvn8xMrRYmXLfWsxmeUs44PhWD0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795704020; v=1; x=1796308820;
 b=B2+w7OwE/9Y3/TUc7HiJGCGBZ87bleVHCKq3Co+zJ+S4N4zTNGBSptPsLnnGzfC0OdIQrUiY
 lD6Ai61rg2Cwy3CqjXRVjTXKTH9YHWdkKT6+C2ED0ybLooRRaEHBwRzrqwCSbjU/THUmACCIHn6
 EdugFLqc/OfGBJg7FE06WF5U=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e358b551fb338187;
	Thu, 26 Nov 2026 14:40:19 +0000
X-Mizu-Trace-ID: e358b551fb338187
X-Migadu-Flow: FLOW_OUT
Message-ID: <beb2d989-6bea-4c35-8a61-18de52ea4671@linux.dev>
Date: Thu, 26 Nov 2026 15:40:18 +0100
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-rc] RDMA/siw: Don't send stale data for a queued zero
 length Read Request
To: Andrew Stellman <astellman@stellman-greene.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261122191122.65240-1-astellman@stellman-greene.com>
From: Bernard Metzler <bernard.metzler@linux.dev>
In-Reply-To: <20261122191122.65240-1-astellman@stellman-greene.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22.11.2026 20:11, Andrew Stellman wrote:
> siw_init_rresp() queues an inbound RDMA Read Request in the inbound read
> queue (IRQ) when the TX work request is busy. For a zero length Read
> Request the IRQ entry has num_sge 0, and siw_activate_tx() then leaves
> wqe->sqe.sge[0] as the previous work request left it.
> siw_qp_sq_proc_tx() sets num_sge to 1 for every Read Response, so the
> Read Response is built from the previous work request's sge[0]. RFC
> 5040, section 5.2.1, requires a zero length Read Response.
> 
> A plain TCP peer that speaks MPA rev 1 sent two Read Requests in one
> write(): 64 bytes from an MR with remote read access, then a zero
> length Read Request. The second Read Response carried the same 64
> bytes of the MR:
> 
>    Read Response, sink STag 0x11110000: 64 bytes "SIW016-REMOTE-RD..."
>    Read Response, sink STag 0x22220000: 64 bytes "SIW016-REMOTE-RD..."
> 
> When the zero length Read Request was sent 500 ms after the first one,
> its Read Response had no payload.
> 
> Copy sge[0] from the IRQ entry whatever its length, as the immediate
> path in siw_init_rresp() does. With this change the second Read
> Response has no payload in both cases.
> 
> The issue was found by Claude Opus 5.5 running Quality Playbook, an
> LLM-driven code review tool:
> https://github.com/andrewstellman/quality-playbook
> The fix and this changelog were drafted with Claude Opus 5.5 and
> reviewed by me.
> 
> Fixes: f29dd55b0236 ("rdma/siw: queue pair methods")
> Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>
> ---
> Tested in QEMU on v7.4-rc3 with KASAN, with a plain TCP peer that speaks
> MPA rev 1. A reproducer is available on request.
> 
>   drivers/infiniband/sw/siw/siw_qp.c | 17 +++++++++--------
>   1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/siw/siw_qp.c b/drivers/infiniband/sw/siw/siw_qp.c
> index bb780e3904a..f3eb1c85f3e 100644
> --- a/drivers/infiniband/sw/siw/siw_qp.c
> +++ b/drivers/infiniband/sw/siw/siw_qp.c
> @@ -972,14 +972,15 @@ int siw_activate_tx(struct siw_qp *qp)
>   	/* start READ RESPONSE */
>   	wqe->sqe.opcode = SIW_OP_READ_RESPONSE;
>   	wqe->sqe.flags = 0;
> -	if (irqe->num_sge) {
> -		wqe->sqe.num_sge = 1;
> -		wqe->sqe.sge[0].length = irqe->sge[0].length;
> -		wqe->sqe.sge[0].laddr = irqe->sge[0].laddr;
> -		wqe->sqe.sge[0].lkey = irqe->sge[0].lkey;
> -	} else {
> -		wqe->sqe.num_sge = 0;
> -	}
> +	/*
> +	 * Copy sge[0] also for a zero length Read Request. The TX path
> +	 * sends sge[0] of every Read Response, and the previous work
> +	 * request's sge[0] must not be sent in its place.
> +	 */
> +	wqe->sqe.num_sge = irqe->num_sge;
> +	wqe->sqe.sge[0].length = irqe->sge[0].length;
> +	wqe->sqe.sge[0].laddr = irqe->sge[0].laddr;
> +	wqe->sqe.sge[0].lkey = irqe->sge[0].lkey;
>   

Sorry for the late reply. And many thanks for catching this one!
Actually, setting num_sge here is of no effect since alway set to
1 during RRESPONSE processing in siw_qp_sq_proc_tx().
But thats just fine as it is now.

Acked-by: Bernard Metzler <bernard.metzler@linux.dev>



>   	/* Retain original RREQ's message sequence number for
>   	 * potential error reporting cases.

