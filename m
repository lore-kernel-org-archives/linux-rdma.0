Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.153
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795295360;
	b=biSpRgS5T0qgKhKygqvO/4T2A9P98eHA+CkYok4PwAm3KlmQJoebPEeENS02dqNsCQMe
	 JUCfrzQDmUa8XggMUFPwEMV9Iy1lA7+LfePagm5TLb5hPgeC+FM0cr8vPkhFA5amjd/aR
	 /YG94ltV0eY/zt429t5trBdIRODMt6rOfNfrFRDlgNZ8wXAuh5exjpZwYtau8J3EIv0Lv
	 6D0eKw5dbj3Yp5pJ7Zdlmv/39E9qe99DVeNH6wui4OPf0mqEq8k8fhsnEfG4dIOIt6L2N
	 rnOO/tLPJfNxMW9GVR1hhuX4DZCkNagKFn/11dYOyTPesBxBNr0YE1BpocNshMjKVOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795295360;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=FILw1BUU13VmbLBMyG9K0DFpVAG3hbn960fhU8qq/90=;
	b=ql8j+ZBVFR2TbUUMJUbqEcP/KQOykWay3V7BnC/W28nRfWB14Mpgf/l7zh2IxidDvU9E
	 c237rqCK3T/wM6hHreiVFoIPFOKPvIwt/J1upFAJ+fjiU3a051q5akbTEyjAb3QaR5KuC
	 J468UuLI1sqi3Su89PDGa0jfFE0cvuE2aVuUU43CY0Rqlp7hB8Y9GXuEY7jvKOHv33HX7
	 Hf/FvEe+7tT1Po8v2rPnF5gTlWiyA/kXBXlrj0/tA0XDDpIxA0CQuBpEGvfo0dlNfbrzH
	 mKiWmr1VefXuAaTt0u2Gq7Lk/a/T913lezli75iuuLWgcS32XaU+cdTXeAdLw2XR10g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JclfRHCS;
	arc=none smtp.remote-ip=95.215.58.153
Received: from mta1.migadu.com (out-153.mta1.migadu.com [95.215.58.153])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66234606A320
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 21:09:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66234606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JclfRHCS
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=PgbC1H0E1UNZYOVBbx3o/pUMbLRsx5eTFPVVjt3CvXU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795295357; v=1; x=1795900157;
 b=JclfRHCSpHdpDNUp3/hn1w9pPCTHPBFtGUIJFVvW4/YG2x+GAMfcx3nCkT4Nb54AFCxQHtD3
 KQ87eklSGH+yB1WxuT7rxS2u76qG6BdVDURw1nTTxslfmwy0z8VSDrZZ2iuGMXck8Rxsq1qKmBW
 W7b10cBqTpvM55JJa9HGcw3w=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a8e2b04fc8ae0b67;
	Sat, 21 Nov 2026 21:09:17 +0000
X-Mizu-Trace-ID: a8e2b04fc8ae0b67
X-Migadu-Flow: FLOW_OUT
Message-ID: <9ec73d93-2d91-4d87-857f-4480084bb7a1@linux.dev>
Date: Sat, 21 Nov 2026 13:09:10 -0800
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
Subject: Re: [PATCH] RDMA/rxe: match a duplicate request to a resource of its
 own type
To: Yiran Qiu <eritque-arcus@ikuyo.dev>, zyjzyj2000@gmail.com, jgg@ziepe.ca,
 leon@kernel.org, "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261120055951.302239-1-eritque-arcus@ikuyo.dev>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20261120055951.302239-1-eritque-arcus@ikuyo.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2026/11/19 21:59, Yiran Qiu 写道:
> find_resource() matches a retransmitted request to a responder resource
> by PSN alone, and rxe_prepare_res() never sets the PSN range of a FLUSH
> resource, so it keeps the PSNs of the request that last used the slot.
> duplicate_request() then gives a retransmitted READ the FLUSH resource
> and reads res->read through the union, so read.rkey and read.length come
> from the FLUSH's RETH va, chosen by the requester. read_reply() replays
> the READ through rxe_recheck_mr(), which only checks that the rkey names
> a valid MR.
>
> A FLUSH with no persistence type needs no QP access bit. A connected RC
> peer holding one rkey of the QP's PD can thus read any valid MR on the
> device, including MRs of other PDs without remote access and the DMA MR
> that each kernel PD gets on rxe, which reads kernel memory at the
> address the peer gives.
>
> Record the PSNs of a FLUSH resource, and match a duplicate only to a
> resource of its own type.
>
> Found with afb-afl, an LLM-driven kernel audit/repro pipeline; the fix
> and this changelog were also drafted with LLM assistance. Reproduced on
> an unmodified KASAN build of mainline, with raw RoCEv2 packets to an rxe
> RC QP: four zero-length READs, a FLUSH, then a READ with the first PSN.
> The replayed READ returned 64 bytes of an MR that another process had
> registered in another PD with local access only and, against the kernel
> DMA MR of rxe0 (key byte found in at most 256 tries), 64 bytes of
> linux_banner. With this patch the replayed READ is dropped in both
> cases. Retransmitted READ, FETCH_ADD and ATOMIC WRITE requests are
> replayed as before, a READ with a foreign rkey is NAKed, and a
> retransmitted FLUSH is now acknowledged instead of dropped. The
> rdma-core v65.0 tests pass on rxe with and without this patch.
>
> Fixes: ea1bb00ee9a5 ("RDMA/rxe: Implement flush execution in responder side")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yiran Qiu <eritque-arcus@ikuyo.dev>
> ---
> Tested on mainline 4405c18c95d2 (v7.4-rc3+) in QEMU. Applies to
> rdma.git for-rc and for-next.
> A reproducer and the test logs are available on request.

Thanks a lot. If you can share the reproducer and the test logs with me,

I can reproduce this problem in my local host.

Except that, I am fine with this commit.

Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Zhu Yanjun

>
>   drivers/infiniband/sw/rxe/rxe_resp.c | 14 +++++++++-----
>   1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
> index 1b7f31737225..db662736404c 100644
> --- a/drivers/infiniband/sw/rxe/rxe_resp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_resp.c
> @@ -688,6 +688,9 @@ static struct resp_res *rxe_prepare_res(struct rxe_qp *qp,
>   		res->flush.length = qp->resp.length;
>   		res->flush.type = feth_plt(pkt);
>   		res->flush.level = feth_sel(pkt);
> +		res->first_psn = pkt->psn;
> +		res->last_psn = pkt->psn;
> +		res->cur_psn = pkt->psn;
>   	}
>   
>   	return res;
> @@ -1327,14 +1330,14 @@ static enum resp_states cleanup(struct rxe_qp *qp,
>   	return RESPST_DONE;
>   }
>   
> -static struct resp_res *find_resource(struct rxe_qp *qp, u32 psn)
> +static struct resp_res *find_resource(struct rxe_qp *qp, u32 psn, int type)
>   {
>   	int i;
>   
>   	for (i = 0; i < qp->attr.max_dest_rd_atomic; i++) {
>   		struct resp_res *res = &qp->resp.resources[i];
>   
> -		if (res->type == 0)
> +		if (res->type != type)
>   			continue;
>   
>   		if (psn_compare(psn, res->first_psn) >= 0 &&
> @@ -1361,7 +1364,7 @@ static enum resp_states duplicate_request(struct rxe_qp *qp,
>   		struct resp_res *res;
>   
>   		/* Find the operation in our list of responder resources. */
> -		res = find_resource(qp, pkt->psn);
> +		res = find_resource(qp, pkt->psn, RXE_FLUSH_MASK);
>   		if (res) {
>   			res->replay = 1;
>   			res->cur_psn = pkt->psn;
> @@ -1376,7 +1379,7 @@ static enum resp_states duplicate_request(struct rxe_qp *qp,
>   	} else if (pkt->mask & RXE_READ_MASK) {
>   		struct resp_res *res;
>   
> -		res = find_resource(qp, pkt->psn);
> +		res = find_resource(qp, pkt->psn, RXE_READ_MASK);
>   		if (!res) {
>   			/* Resource not found. Class D error.  Drop the
>   			 * request.
> @@ -1423,7 +1426,8 @@ static enum resp_states duplicate_request(struct rxe_qp *qp,
>   		struct resp_res *res;
>   
>   		/* Find the operation in our list of responder resources. */
> -		res = find_resource(qp, pkt->psn);
> +		res = find_resource(qp, pkt->psn, pkt->mask & RXE_ATOMIC_MASK ?
> +				    RXE_ATOMIC_MASK : RXE_ATOMIC_WRITE_MASK);
>   		if (res) {
>   			res->replay = 1;
>   			res->cur_psn = pkt->psn;

-- 
Best Regards,
Yanjun.Zhu

