Received: from mta0.migadu.com (out-28.mta0.migadu.com [91.218.175.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716FC3E6DD5
	for <linux-rdma@vger.kernel.org>; Tue, 29 Sep 2026 16:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790700620; cv=none; b=REVdiuDjup5LqvY/ZKx/o44NN/XAhpKE5g5p88EVeNmYrBSaMFBXdaB8yf7ZbRGIpCwHiciZXEpC4DCRlbuXRjSjqJvx2WyKqcHC/oc4EPMwyXGNRwhaqi/11e5eIvJFZrjIosvZI4R4ZB+ExzV0baTmKnIkRRRpznyn0YmOJ9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790700620; c=relaxed/simple;
	bh=NsD4u1KD0ML9C5RRwuJTBf1tlKoOOz1dTzox0/5Xacs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AnDAk04FtT+fHs36nZj8KVw8AAtBmWrOGEuOEa/h969WOWkDvSBvaSnof0XP1gvbhp+mYadAWY5jlLbmSL04whvMhdpLtr6g+8PGs+tGphroPBgeN0BXYygoz9cCxljlyUOZ3IWxAEpLhm1QYPPXGg2CvwVBF7Zvyy3Is9lD+DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nNFnlmd0; arc=none smtp.client-ip=91.218.175.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nNFnlmd0"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=NsD4u1KD0ML9C5RRwuJTBf1tlKoOOz1dTzox0/5Xacs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790700616; v=1; x=1791305416;
 b=nNFnlmd0/nHNXaRWoiMejXtYJbrZGwJoiUBBCSFGy128LXhqUCLidZcNKtuA7xDenijbHhT+
 0h3B/K5CE+4CkunODjdkM6mR59X9wcaaDyfFjYojyDCpaORF2b3qkIVXshq01fftLwepVwI7LAp
 jdeHEEe3Sj5VKa7zSa5kMMhk=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ffec101f3beee8d0;
	Tue, 29 Sep 2026 16:50:15 +0000
X-Mizu-Trace-ID: ffec101f3beee8d0
X-Migadu-Flow: FLOW_OUT
Message-ID: <c037f1a6-6cf1-4c9b-bf63-c01105c1dce7@linux.dev>
Date: Tue, 29 Sep 2026 09:50:07 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] RDMA/rxe: Fix out-of-range unsigned-to-signed
 conversion for RDMA message in 2GiB size
To: Honggang LI <honggangli@163.com>, zyjzyj2000@gmail.com, jgg@ziepe.ca,
 leon@kernel.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260929055853.164026-1-honggangli@163.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260929055853.164026-1-honggangli@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2026/9/28 22:58, Honggang LI 写道:
> When RDMA READ request for 2GiB in single WR, res->read.resid is u32
> 0x80000000, which is INT_MIN (-2147483648).
>
>      payload = min_t(int, res->read.resid, mtu);
>
> The `min_t` function will return -2147483648 for payload. The wrong
> size is propagated through call chain, `read_reply` -> `prepare_ack_packet`
> -> `rxe_init_packet` -> `alloc_skb` . `alloc_skb` failed because of
> invalid size. The passive side failed to emit response packet for RDMA
> READ request.
>
> After fixed it, the active side of RDMA READ failed with error code
> "IB_WC_LOC_PROT_ERR". When RDMA_READ_RESPONSE_FIRST packet recived by
> the active side, `do_read` call `copy_data`. dma->resid is u32 0x80000000.
>
>     int resid	= dma->resid;
>
> This conversion set resid to -2147483648. `copy_data` abort as length
> greater than resid.
>
> RDMA SEND and WRITE 2GiB message works too, after fixed these two bugs.
>
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Honggang LI <honggangli@163.com>
> ---
> Change log:
> v2 -> v1:
> Use u32 for must-be-unsized quantities, no unsigned-to-signed conversion

Using u32 instead of int for payload and buffer lengths makes sense here 
to prevent

negative conversion on 2GiB boundary transfers. u32 is sufficient to 
hold length up to 4GiB.

I am fine with this commit. Wait for feedback from Leon and Jason.

Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Zhu Yanjun

>
>   drivers/infiniband/sw/rxe/rxe_loc.h  |  4 ++--
>   drivers/infiniband/sw/rxe/rxe_mr.c   |  8 ++++----
>   drivers/infiniband/sw/rxe/rxe_net.c  |  2 +-
>   drivers/infiniband/sw/rxe/rxe_resp.c | 17 +++++++++--------
>   4 files changed, 16 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
> index 64d636bf80fd..b5aaba7cf76f 100644
> --- a/drivers/infiniband/sw/rxe/rxe_loc.h
> +++ b/drivers/infiniband/sw/rxe/rxe_loc.h
> @@ -64,7 +64,7 @@ int rxe_flush_pmem_iova(struct rxe_mr *mr, u64 iova, unsigned int length);
>   int rxe_mr_copy(struct rxe_mr *mr, u64 iova, void *addr,
>   		unsigned int length, enum rxe_mr_copy_dir dir);
>   int copy_data(struct rxe_pd *pd, int access, struct rxe_dma_info *dma,
> -	      void *addr, int length, enum rxe_mr_copy_dir dir);
> +	      void *addr, u32 length, enum rxe_mr_copy_dir dir);
>   int rxe_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
>   		  int sg_nents, unsigned int *sg_offset);
>   enum resp_states rxe_mr_do_atomic_op(struct rxe_mr *mr, u64 iova, int opcode,
> @@ -91,7 +91,7 @@ void rxe_mw_cleanup(struct rxe_pool_elem *elem);
>   
>   /* rxe_net.c */
>   struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
> -				int paylen, struct rxe_pkt_info *pkt);
> +				u32 paylen, struct rxe_pkt_info *pkt);
>   int rxe_prepare(struct rxe_av *av, struct rxe_pkt_info *pkt,
>   		struct sk_buff *skb);
>   int rxe_xmit_packet(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
> diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
> index 71d9ea477289..f2ffbefb9675 100644
> --- a/drivers/infiniband/sw/rxe/rxe_mr.c
> +++ b/drivers/infiniband/sw/rxe/rxe_mr.c
> @@ -418,13 +418,13 @@ int copy_data(
>   	int			access,
>   	struct rxe_dma_info	*dma,
>   	void			*addr,
> -	int			length,
> +	u32			length,
>   	enum rxe_mr_copy_dir	dir)
>   {
> -	int			bytes;
> +	u32			bytes;
>   	struct rxe_sge		*sge	= &dma->sge[dma->cur_sge];
> -	int			offset	= dma->sge_offset;
> -	int			resid	= dma->resid;
> +	u32			offset	= dma->sge_offset;
> +	u32			resid	= dma->resid;
>   	struct rxe_mr		*mr	= NULL;
>   	u64			iova;
>   	int			err;
> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
> index 53daaf4c1eb2..f548f312b393 100644
> --- a/drivers/infiniband/sw/rxe/rxe_net.c
> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
> @@ -536,7 +536,7 @@ int rxe_xmit_packet(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
>   }
>   
>   struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
> -				int paylen, struct rxe_pkt_info *pkt)
> +				u32 paylen, struct rxe_pkt_info *pkt)
>   {
>   	unsigned int hdr_len;
>   	struct sk_buff *skb = NULL;
> diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
> index 02b16e2b49b8..4e71bc985721 100644
> --- a/drivers/infiniband/sw/rxe/rxe_resp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_resp.c
> @@ -612,7 +612,7 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
>   }
>   
>   static enum resp_states send_data_in(struct rxe_qp *qp, void *data_addr,
> -				     int data_len)
> +				     u32 data_len)
>   {
>   	int err;
>   
> @@ -827,20 +827,21 @@ static enum resp_states atomic_write_reply(struct rxe_qp *qp,
>   static struct sk_buff *prepare_ack_packet(struct rxe_qp *qp,
>   					  struct rxe_pkt_info *ack,
>   					  int opcode,
> -					  int payload,
> +					  u32 payload,
>   					  u32 psn,
>   					  u8 syndrome)
>   {
>   	struct rxe_dev *rxe = to_rdev(qp->ibqp.device);
>   	struct sk_buff *skb;
> -	int paylen;
> -	int pad;
> +	u32 paylen;
> +	u32 pad = 0;
>   	int err;
>   
>   	/*
>   	 * allocate packet
>   	 */
> -	pad = (-payload) & 0x3;
> +	if (payload % 4)
> +		pad = 4 - payload % 4;
>   	paylen = rxe_opcode[opcode].length + payload + pad + RXE_ICRC_SIZE;
>   
>   	skb = rxe_init_packet(rxe, &qp->pri_av, paylen, ack);
> @@ -934,9 +935,9 @@ static enum resp_states read_reply(struct rxe_qp *qp,
>   {
>   	struct rxe_pkt_info ack_pkt;
>   	struct sk_buff *skb;
> -	int mtu = qp->mtu;
> +	u32 mtu = qp->mtu;
>   	enum resp_states state;
> -	int payload;
> +	u32 payload;
>   	int opcode;
>   	int err;
>   	struct resp_res *res = qp->resp.res;
> @@ -982,7 +983,7 @@ static enum resp_states read_reply(struct rxe_qp *qp,
>   
>   	res->state = rdatm_res_state_next;
>   
> -	payload = min_t(int, res->read.resid, mtu);
> +	payload = min(res->read.resid, mtu);
>   
>   	skb = prepare_ack_packet(qp, &ack_pkt, opcode, payload,
>   				 res->cur_psn, AETH_ACK_UNLIMITED);

-- 
Best Regards,
Yanjun.Zhu

