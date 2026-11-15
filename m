Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794764190;
	b=eCYFdmBs+XNCmvNqQaFkqLB+omKoHvhB/gB0LJj84gQ/q7FrQ0nXMQeq4EsiAjFOtBOQ
	 yr3Wz1BudSFbbV2CXBQ7OeM3lr69yOZJ2mnBIRfvBTnbtuc01kiyT80yU5h5jYsOkysVE
	 CohD5OeS4gUX3C08XNpCK6KTwtKFWpPsfzj5nWtgNB8xb7d3i7HFXU0Tvc38KIbsWIk+9
	 lkdj0oFMDfyYJ/HTHm9peHgTM5E1b1jQE1UrEMYndaFNVbUgiL2vFwuEvR9i/Aycf1TqS
	 qBGGyEW68WzeFbkTFFSiSkSPHmrjNiFSrHbCfrn4NZXQRy0KuzztxrSvG5XPr4br4Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794764190;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=GRWYSuLQP9sZfKWWqP+UL8TabCKmkxKc6qkoZFoAHOo=;
	b=00KvhfTGp2sl4zDK7ef686VCW6B48q/ep7HJ3n35KdlRA44ZA3UntngmPv7s2HE9viLi
	 v2WHnZGGQfO9koDfK/8eIkOOu9souRq955weanLHRMSuvCEoBugQV5D/lBbxairgLL10t
	 Mkfg2NFRPvykwXx/14WdqQz9qr3GrU95niUi5SOHaGQa5sZvtoSHdWlyfOQUe0C3tlwnW
	 al9yyDJ1tqkyyY/ehaecMMm+y/ywNhIX2JU4lxJwMX1idbO6vW7GYfqkR16Pom1cgo6mm
	 ff7xFkMfcpWtBpm50VhyPo+yhEX7zvMrgCaIYEslH732gyAD/vvCM8780KJCiZQ73hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=Ut76e44E;
	arc=none smtp.remote-ip=74.125.82.178
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C92606A31F
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 17:36:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95C92606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=Ut76e44E
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-37000e7234bso1621511eec.1
        for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 09:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1794764188; x=1795368988; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GRWYSuLQP9sZfKWWqP+UL8TabCKmkxKc6qkoZFoAHOo=;
        b=Ut76e44Eer+SVkzm7j6VbbdgAJUYEtAvHPQkRWwmhc8sTzHTEX2gX9c8INz0D3UkTZ
         c5Q8nQf/Ja72N6pQ86DzQVnTj7X9LvwZf/XCdcLhHU9cldDr65Uuqd+XNN2qCKkJd+tQ
         Gaf0IGiVv3s+DiUjMKfKgvGIFS/EYzaldtN5cACuzLuYRIse2xyhxfiY6mUSuQAaohM/
         6LbmQmF7zIL3DEh/wKcmfNrxcCEs2LG+fMzejSLo5cjQ01LLrGBeO11vcy9Q5loUR4q9
         j2x+QU/H9bYI7aQH6Ns7oqnPpudKbrq0uK7bpL9fHm9EI+HBMMzh/LX9Hk8/odxHIohu
         z3pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794764188; x=1795368988;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=GRWYSuLQP9sZfKWWqP+UL8TabCKmkxKc6qkoZFoAHOo=;
        b=KLgqdDn85BsNibW/xM6iZewL3ETfwnMFsGSFX2jjYFgval4cy2cc2YeRfYT127PjIR
         FBGu8RAuGKaQpCpwhYk9vIWxsdppKWPvqmZhZmaWMvWzRw1myvWWW+xUC8Fm9t1R6r7H
         srfhUCv4+9ANXUmwWOY1yusPlhxsxg2/mrKsoQKmh/Q0VrhyfXPfaQkOhGaEdjWRd6xm
         VQ2yZkKwp2EwDY7NRRSqmh/Vun1wSrQ9p4drsjmUJPBfXbfPh/Hy1V7ysoYSuTYBF5sQ
         BssxaMKVpo02nEjfr7Rd2L1zO7Kt2HUwS2fswpLUhGcQnNTeqQq4csKD6df9orQPeI7N
         JrLw==
X-Forwarded-Encrypted: i=1; AL+hErGZCQwl3+jRiMjj/kxGuxXmTP45d8X5g/M33qaekVKfxkG+fQg1OXNd6VpuewwlkSIN3vkJeEiNC9EA@vger.kernel.org
X-Gm-Message-State: APuU4Z90qD0h+9OmS+19jF7I3X8Rxi48buKse+HiXMn38eE1xbpcMVMM
	m91TPKlsA3K/oJrOD18t48EeSsDcUno7Gni3y+i5twOAyptK7POr08mqxgdoF5YWwUQ=
X-Gm-Gg: AYBFou1wMS6k7F/5k1Vn3q35GCWnbc9vOqeuim37u2Wq/fVLjC5XaBO0WQiP2qXn/zq
	9ex5gHiRBbE+MDRetHTrEBe6O7EivpCWJx+lD/3QFamSHFI1lx35lzVxWccjVcJ5Iruxnub3ABK
	B/pvwQdEJADx+iU+Qe/kksiu4j8axJ1HOl0tsCWgKJ5xdovU+1XngfhZtMhrt7bP7wxjg03oppp
	ZwrGvp2iQ2ji51KAsc+rKvskgkOKQBsTmQdlXaGIYI3T8dA0Gf/jt/9RA7nFa33VbJiH02tKDr4
	aJFT331dg/kIkhIQCDtj3ionFUu3NHm/3f7QXMZrBA3NOVg1nPw7xRNBNvsRUBqVnsS9pIyzByt
	VppV3IbT6tnyts6au6XyxDGgnD67kgb7bMESTTjEXpY8VcDShA8r0rWNeQKc1Py4fZmCFlVdduY
	+g18uvt0nybsWHajAUdSh1KeMMRZYU4lm0diHkR93KWBpgKQDT/NCPo62RjHzr/kCtgYIVY4iDZ
	/he+Nt93RqMKIiGu6xsX8sk0CKfTRKyoIySa4Jou0MYkKu87f6c3FBDsgLX7QmKFjh2xXyl4GA0
	5+IDrgs5/fY4wZo9lZeoTggFum56bpC0Zyq3plFn3nah4htGbG4vifPZ3+Y=
X-Received: by 2002:a05:7301:2024:b0:36a:18e2:64c with SMTP id 5a478bee46e88-379655d3d12mr9319544eec.11.1794764187185;
        Sun, 15 Nov 2026 09:36:27 -0800 (PST)
Received: from medusa.lab.kspace.sh ([2607:fb90:9c20:35a5::cb18])
        by smtp.googlemail.com with ESMTPSA id 5a478bee46e88-379560f5e06sm35343144eec.19.2026.11.15.09.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 09:36:26 -0800 (PST)
Date: Sun, 15 Nov 2026 09:36:18 -0800
From: Mohamed Khalfella <mkhalfella@purestorage.com>
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] RDMA/rxe: Do not re-execute completed local ops after a
 retry
Message-ID: <20261115173618.GD34016-mkhalfella@purestorage.com>
References: <20261113230831.2682071-1-mkhalfella@purestorage.com>
 <e432178a-6e73-4096-9f59-5c5d2bc9d682@linux.dev>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e432178a-6e73-4096-9f59-5c5d2bc9d682@linux.dev>

On Sat 2026-11-14 11:05:39 -0800, Zhu Yanjun wrote:
> 
> 在 2026/11/13 15:08, Mohamed Khalfella 写道:
> > Local operations (IB_WR_REG_MR, IB_WR_LOCAL_INV, IB_WR_BIND_MW) are
> > executed inline by rxe_requester() through rxe_do_local_ops(), which
> > marks the wqe wqe_state_done and advances qp->req.wqe_index past it.
> > Unlike wire operations, nothing is posted to the network and no ack is
> > expected.
> >
> > The completer only consumes wqes from the head of the send queue, in
> > order. A done local op wqe therefore stays in the queue until every
> > older wqe has completed, so it can sit behind a SEND or RDMA WRITE that
> > is still waiting for an ack. With nvme-rdma, which posts REG_MR + SEND
> > for every I/O, the queue regularly looks like:
> >
> >    SEND(A) pending, REG_MR(B) done, SEND(B) pending, REG_MR(C) done ...
> >
> > When a retransmit timeout fires or a NAK arrives, req_retry() rewinds
> > qp->req.wqe_index to the consumer so that every unacked wqe is resent.
> > Its loop skips wqe_state_done entries when resetting DMA state, but
> > rxe_requester() itself has no such check. After the rewind it walks
> > forward through the queue, reaches REG_MR(B), sees WR_LOCAL_OP_MASK and
> > calls rxe_do_local_ops() on it a second time.
> >
> > rxe_reg_fast_mr() rejects the repeated registration because the MR is
> > already RXE_MR_STATE_VALID, not FREE. The wqe is given
> > IB_WC_LOC_QP_OP_ERR and the QP is moved to the error state. The
> > completer then flushes the entire send queue with IB_WC_WR_FLUSH_ERR,
> > including the wqe that failed, so the consumer never sees the real
> > error status. nvme-rdma logs only "SEND ... failed with status WR
> > flushed (5)" and tears down the controller.
> >
> > Any packet loss that triggers a retry while a later request is queued
> > is enough to hit this. On a soft-RoCE setup with a few hundred lost
> > frames per run every controller reconnect traced back to the same
> > rxe_dbg_mr() line:
> >
> >    rxe1: mr#776 rxe_reg_fast_mr:  mr->lkey = 0x3084c not free
> >
> > Skip local op wqes that are already done when the requester reaches
> > them again after a rewind. Advance wqe_index past them exactly as a
> > successful execution would and continue with the next wqe. The MR keeps
> > its registered state and the completer still reports the wqe in order
> > with its original status. Only local ops can be in wqe_state_done ahead
> > of the consumer on an RC QP, since wire operations stay pending until
> > acked, so the check cannot match anything else.
> >
> > Fixes: 001345339f4c ("RDMA/rxe: Separate HW and SW l/rkeys")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Mohamed Khalfella <mkhalfella@purestorage.com>
> > ---
> >   drivers/infiniband/sw/rxe/rxe_req.c | 14 ++++++++++++++
> >   1 file changed, 14 insertions(+)
> >
> > diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
> > index 4f353abd76f5..fdb55366d668 100644
> > --- a/drivers/infiniband/sw/rxe/rxe_req.c
> > +++ b/drivers/infiniband/sw/rxe/rxe_req.c
> > @@ -723,6 +723,20 @@ int rxe_requester(struct rxe_qp *qp)
> >   		goto err;
> >   	}
> >   
> > +	/*
> > +	 * A retry rewinds wqe_index to the send queue consumer. Local
> > +	 * operations that were already executed may still sit in the
> > +	 * queue behind an unacked wqe waiting for in-order completion.
> > +	 * Re-executing them fails (e.g. REG_MR on an MR that is no
> > +	 * longer free) and would move the QP to the error state, so
> > +	 * skip them instead.
> > +	 */
> > +	if ((wqe->mask & WR_LOCAL_OP_MASK) &&
> > +	    wqe->state == wqe_state_done) {
> > +		qp->req.wqe_index = queue_next_index(q, qp->req.wqe_index);
> > +		goto done;
> > +	}
> 
> I understand the need for this check to prevent already-completed local 
> operations from
> 
> being re-executed after a retry rewinds the WQE index.
> 
> However, this check is currently placed in the common `rxe_requester()` 
> path, so it is evaluated
> 
> for every WQE, including normal SEND and RDMA WRITE operations.
> 
> Since this condition is only relevant when a retry causes the requester 
> to revisit an already-completed
> 
> local operation, it is expected to be very rare in the normal execution 
> path.
> 
> Could we move this check into the existing `WR_LOCAL_OP_MASK` handling 
> path, or at least mark
> 
> the condition with `unlikely()`?
> 
> I would prefer moving it into the local operation handling path, if the 
> control flow allows it, so that normal wire
> 
> operations do not pay the cost of an additional state check.
> 
> This would keep the fix while minimizing its impact on the common fast path.

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 12d03f390b09..8bd1f9b1ce06 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -707,6 +707,13 @@ int rxe_requester(struct rxe_qp *qp)
 	}
 
 	if (wqe->mask & WR_LOCAL_OP_MASK) {
+		/* Retry rewinds wqe_index, skip it if already done */
+		if (unlikely(wqe->state == wqe_state_done)) {
+			qp->req.wqe_index = queue_next_index(q,
+						qp->req.wqe_index);
+			goto done;
+		}
+
 		err = rxe_do_local_ops(qp, wqe);
 		if (unlikely(err))
 			goto err;

Does something like the diff above work?

Also, sashiko marked a high severity issue [1] in this version of the
patch. I am not familiar with this codebase enough to know if this is a
real issue introduced by this change or not.

Is the issue reported by sashiko real?
If yes, is it introduced by this patch?

1- https://lore.kernel.org/all/sashiko-outbox-213867@kernel.org/

Thanks,
Mohamed Khalfella
