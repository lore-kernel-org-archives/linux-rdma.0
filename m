Received: from mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3933F51A73A
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 18:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791310; cv=none; b=fm/KtqlbmPKFTofOcRcQ/H6lno1MH9lRjlwhhpd/XxhD5ff5/32ASzi4FvXfeXSCU3FuDbvnPCJ23ebScGfynXSahn25LhcmjECQ/Gm7zwO7CjRQx/OgEjjD3eu4jna9WGA3er+jvsQZFfLVol3z/Jm+RPACv93xOSaqxpzPeew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791310; c=relaxed/simple;
	bh=LaDuJJ4IQZF7oRJyVtptW7GREYxvgyVocI0N3tPZEZc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m+f4tUxpTwbgB5rh4dKQ9hY7/EWkWpOB7+wsfGMIsCy9fTD6qc3sfOdW7t2kgMA7RrUjuoqTxf7LnOk5LBZYgArkW1bj+Bnq2GVuBs5VIUwCxteZeZkSKCFbwQdSxVbbURDgnWTMJUlxW9RSJTIuhKvM183cjAt3fSaLJtK4r7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=r7Y6G6VW; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="r7Y6G6VW"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=LaDuJJ4IQZF7oRJyVtptW7GREYxvgyVocI0N3tPZEZc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790791304; v=1; x=1791396104;
 b=r7Y6G6VW0bFOjLPmTB22LyBZdlCqTkt/ueQhx5fFW/kZ9TDW9kdHTx79yPHuHOYY9w3O7RB3
 Svn5ZnqBzhUDOQWyosmKS5AEM2yUe/6jAHaMTAYUpZ4/t5qy+eb8+lWoA+Bena3arK5699GK/Gt
 Hmk3xh+QMNWAi0Z70XTYAeV8=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8be2cb23cbeaf301;
	Wed, 30 Sep 2026 18:01:44 +0000
X-Mizu-Trace-ID: 8be2cb23cbeaf301
X-Migadu-Flow: FLOW_OUT
Message-ID: <c4dcae63-b19a-41a7-9236-0dd9b7f95156@linux.dev>
Date: Wed, 30 Sep 2026 11:01:41 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RDMA/rxe: use-after-free of rxe_qp when destroy_qp proceeds with
 a bound type-2 MW still holding a QP reference
To: AYS <ays511.kr@gmail.com>, zyjzyj2000@gmail.com
Cc: linux-rdma@vger.kernel.org, security@kernel.org
References: <CAPAqSgZhfWXwrYh=OT8xta+mY00Fc-xhkc5HdP=qVvxUABnWnA@mail.gmail.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <CAPAqSgZhfWXwrYh=OT8xta+mY00Fc-xhkc5HdP=qVvxUABnWnA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2026/9/30 9:49, AYS 写道:
> Summary
>    Component : drivers/infiniband/sw/rxe (Soft-RoCE)
>    File/func : rxe_mw.c rxe_do_bind_mw() (takes the ref) and rxe_mw_cleanup()
>                (uses it); rxe_qp.c rxe_qp_chk_destroy() (missing guard);
>                rxe_pool.c __rxe_cleanup() (timeout path)
>    Affected  : present in 7.3-rc4 (93f51579e7df). No commit touched
>                drivers/infiniband/sw/rxe/ between 93f51579e7df and current
>                master 551c722f4080 (2026-09-29) or rdma for-next, so
> both are affected.
>                (Distinct from ae36a5b6, which fixed a PD UAF on the rereg_mr
>                path; this is a QP UAF on the destroy_qp path.)
>    Config    : CONFIG_RDMA_RXE, CONFIG_INFINIBAND_USER_ACCESS
>    Trigger   : local process able to open the rxe uverbs char device. One-time
>                root setup; the trigger itself ran as uid 1000. IB_WR_BIND_MW is
>                a local op, so no network/peer is needed.
>    Primitive : use-after-free WRITE on a freed struct rxe_qp (kmalloc-2k): a 4B
>                refcount_dec_and_test at offset 368, plus complete()/list work
>                when it reaches zero.
>    Found via : manual review. A reproducer exists and can be provided
>                privately on request.
>
> Details
>
> A type-2 MW bind takes a reference on the QP:
>
> /* rxe_mw.c rxe_do_bind_mw() */
> if (mw->ibmw.type == IB_MW_TYPE_2) {
> rxe_get(qp);
> mw->qp = qp;
> }
>
> That reference is dropped only on IB_WR_LOCAL_INV (rxe_do_invalidate_mw()) or
> when the MW itself is destroyed (rxe_mw_cleanup()). But destroy_qp does not
> account for it: rxe_qp_chk_destroy() only refuses when qp->mcg_num != 0; it
> does not check for bound type-2 MWs. So a QP with a live MW reference can be
> torn down. __rxe_cleanup() then hits its -ETIMEDOUT path (the refcount has not
> reached zero) and proceeds to free the QP anyway. Later, when the MW is
> invalidated or deallocated, rxe_mw_cleanup() does rxe_put(mw->qp) on the freed
> rxe_qp -- a refcount_dec_and_test write into freed memory, followed by
> complete()/list manipulation if it hits zero.
>
> Reproduced on a KASAN x86-64 build of 7.3-rc4 as uid 1000: KASAN
> slab-use-after-free write via rxe_mw_cleanup -> __rxe_put on the freed
> struct rxe_qp. Deterministic (not a race): bind a type-2 MW to an RTS QP,
> destroy the QP, then deallocate the MW.
>
> Suggested fix
>
> Make rxe_qp_chk_destroy() refuse (or defer) destruction while the QP still has
> bound type-2 MWs, analogous to the existing qp->mcg_num guard -- e.g. track a
> bound-MW count on the QP and fail destroy_qp with -EBUSY, or drop the MW's QP
> reference before the QP is freed.
>
> I have not built/tested a patch; the Fixes: commit should be identified when
> preparing one (introduced with type-2 MW support). A checkpatch-clean patch
> can follow on request.

I can not see the code snippet. Please resend this commit following the 
kernel style in document/process.

Thanks a lot.

Yanjun Zhu

> Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>

-- 
Best Regards,
Yanjun.Zhu

